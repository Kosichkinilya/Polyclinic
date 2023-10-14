using Polyclinic.Data;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Windows;
using System.Windows.Controls;

namespace Polyclinic.Pages
{
    /// <summary>
    /// Логика взаимодействия для NursesPage.xaml
    /// </summary>
    public partial class NursesPage : Page
    {
        private readonly DbEntities _db = DbEntities.GetContext();
        public NursesPage()
        {
            InitializeComponent();
        }

        /// <summary>
        /// Вызывается при переходе на страницу
        /// </summary>
        private void Page_Loaded(object sender, System.Windows.RoutedEventArgs e)
        {
            //Загружаем таблицу медсестер и выводим их на форму
            _db.Nurses.Load();
            collectionView.ItemsSource = _db.Nurses.Local.ToBindingList();

            //Сбрасываем фильтры
            txtFindFio.Text = "Поиск по фио";
            txtFindOffice.Text = "Поиск по номеру кабинета";
        }

        private void AddButton_Click(object sender, System.Windows.RoutedEventArgs e)
        {
            //Создаем новую медсестру, заполняем значениями по умолчанию
            Nurse nurse = new Nurse()
            {
                Worker = new Worker()
                {
                    Salary = 15000,
                    DateEnployment = DateTime.Now.Date
                }
            };
            //Переходим на страницу заполнения
            this.NavigationService.Navigate(new ExtensionPages.AddNursePage(nurse));
        }

        private void EditButton_Click(object sender, System.Windows.RoutedEventArgs e)
        {
            //Получаем медсестру из кнопки
            var nurse = (sender as Button).DataContext as Nurse;
            //Переходим на страницу заполнения
            this.NavigationService.Navigate(new ExtensionPages.AddNursePage(nurse));
        }

        private void DeleteButton_Click(object sender, System.Windows.RoutedEventArgs e)
        {
            var asnwer = MessageBox.Show("Вы действительно хотите удалить эту запись?", "Внимание", MessageBoxButton.YesNoCancel, MessageBoxImage.Warning);
            if (asnwer != MessageBoxResult.Yes) return;
            //Получаем медсестру из кнопки
            var nurse = (sender as Button).DataContext as Nurse;
            //Удаляем и сохраняем
            _db.Workers.Remove(nurse.Worker);
            _db.Nurses.Remove(nurse);
            _db.SaveChanges();
        }

        /// <summary>
        /// Поиск по фио
        /// </summary>
        private void TxtFindFio_TextChanged(object sender, TextChangedEventArgs e)
        {
            if (txtFindFio == null) return;
            if (txtFindOffice == null) return;

            if (txtFindFio.Text == "Поиск по фио") return; //Если это заглушка, ничего не делаем
            txtFindOffice.Text = "Поиск по номеру кабинета"; //Сбрасываем другой поиск

            if (string.IsNullOrEmpty(txtFindFio.Text)) //Если текстбокс пустой, выводим все записи
            {
                collectionView.ItemsSource = _db.Nurses.Local.ToBindingList();
                return;
            }

            List<Nurse> list = collectionView.ItemsSource?.Cast<Nurse>().ToList();
            if (list == null || list.Count == 0) list = _db.Nurses.Local.ToList();
            collectionView.ItemsSource = list.Where(p => p.Worker.FIO.Contains(txtFindFio.Text));
        }

        /// <summary>
        /// Поиск по номеру кабинета
        /// </summary>
        private void TxtFindOffice_TextChanged(object sender, TextChangedEventArgs e)
        {
            if (txtFindOffice == null) return;
            if (txtFindFio == null) return;

            if (txtFindOffice.Text == "Поиск по номеру кабинета") return;
            txtFindFio.Text = "Поиск по фио";

            if (string.IsNullOrEmpty(txtFindOffice.Text))
            {
                collectionView.ItemsSource = _db.Nurses.Local.ToBindingList();
                return;
            }

            //Если список пустой, для выборки наполним его записями из таблицы
            List<Nurse> list = collectionView.ItemsSource?.Cast<Nurse>().ToList();
            if (list == null || list.Count == 0) list = _db.Nurses.Local.ToList();

            //Проводим выборку по фио
            collectionView.ItemsSource = list.Where(p => p.Office.Value.ToString() == txtFindOffice.Text);
        }
    }
}

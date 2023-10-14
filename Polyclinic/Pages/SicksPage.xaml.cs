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
    /// Логика взаимодействия для SicksPage.xaml
    /// </summary>
    public partial class SicksPage : Page
    {
        private readonly DbEntities _db = DbEntities.GetContext();
        public SicksPage()
        {
            InitializeComponent();
        }

        /// <summary>
        /// Вызывается при переходе на страницу
        /// </summary>
        private void Page_Loaded(object sender, System.Windows.RoutedEventArgs e)
        {
            _db.Sicks.Load();
            collectionView.ItemsSource = _db.Sicks.Local.ToBindingList();
            txtFind.Text = "Поиск по номеру";
        }

        private void AddButton_Click(object sender, System.Windows.RoutedEventArgs e)
        {
            //Генерируем случайный номер для боличного, проверяем на уникальность
            Random random = new Random();
            int sickNumber = 0;
            do
            {
                sickNumber = random.Next(1231981, 9982794);
            } while (_db.Sicks.Count(p => p.Number == sickNumber) != 0);

            //Создаем больничный, заполняем значениями по умолчанию
            Sick sick = new Sick()
            {
                Number = sickNumber,
                DateStart = DateTime.Now,
                DateEnd = DateTime.Now.AddDays(7),
            };
            //Переходим на страницу заполнения
            this.NavigationService.Navigate(new ExtensionPages.AddSickPage(sick));
        }

        private void EditButton_Click(object sender, System.Windows.RoutedEventArgs e)
        {
            //Получаем больничный из кнопки
            var sick = (sender as Button).DataContext as Sick;
            //Переходим на страницу заполнения
            this.NavigationService.Navigate(new ExtensionPages.AddSickPage(sick));
        }

        private void DeleteButton_Click(object sender, System.Windows.RoutedEventArgs e)
        {
            var asnwer = MessageBox.Show("Вы действительно хотите удалить эту запись?", "Внимание", MessageBoxButton.YesNoCancel, MessageBoxImage.Warning);
            if (asnwer != MessageBoxResult.Yes) return;
            //Получаем больничный из кнопки
            var sick = (sender as Button).DataContext as Sick;
            //Удаляем и сохраняем
            _db.Sicks.Remove(sick);
            _db.SaveChanges();
        }

        /// <summary>
        /// Поиск по номеру больничного
        /// </summary>
        private void TxtFindFio_TextChanged(object sender, TextChangedEventArgs e)
        {
            if (txtFind == null) return;
            if (txtFind.Text == "Поиск по номеру") return; //Если это заглушка, ничего не делаем

            //Если пустой текстбокс, выводим все записи
            if (!string.IsNullOrEmpty(txtFind.Text)) collectionView.ItemsSource = _db.Sicks.Local.ToBindingList();

            //Если список пустой, для выборки наполним его записями из таблицы
            List<Sick> list = collectionView.ItemsSource?.Cast<Sick>().ToList();
            if (list == null || list.Count == 0) list = _db.Sicks.Local.ToList();

            //Проводим выборку по номеру
            collectionView.ItemsSource = list.Where(p => p.Number.ToString().Contains(txtFind.Text));
        }
    }
}

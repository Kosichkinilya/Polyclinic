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
    /// Логика взаимодействия для DoctorsPage.xaml
    /// </summary>
    public partial class DoctorsPage : Page
    {
        private readonly DbEntities _db = DbEntities.GetContext();
        public DoctorsPage()
        {
            InitializeComponent();
        }

        /// <summary>
        /// Вызывается при переходе на страницу
        /// </summary>
        private void Page_Loaded(object sender, System.Windows.RoutedEventArgs e)
        {
            //Загружаем таблицу врачей и специализаций и выводим их на форму
            _db.Doctors.Load();
            _db.Specializations.Load();

            //Заполняем combobox специализациями
            var listSpecs = _db.Specializations.ToList();
            //Вставляем первым элементом заглушку для сброса фильтра
            listSpecs.Insert(0, new Specialization() { Title = "Фильтр по специализации" });
            cmbSpecFilter.ItemsSource = listSpecs;
            //Выбираем заглушку, при которой фильтр отключен
            cmbSpecFilter.SelectedIndex = 0;
        }

        private void AddButton_Click(object sender, System.Windows.RoutedEventArgs e)
        {
            //Создаем нового врача, заполняем значениями по умолчанию
            Doctor doctor = new Doctor()
            {
                Worker = new Worker()
                {
                    Salary = 35000,
                    DateEnployment = DateTime.Now.Date
                }
            };
            //Переходим на страницу заполнения
            this.NavigationService.Navigate(new ExtensionPages.AddDoctorPage(doctor));
        }

        private void EditButton_Click(object sender, System.Windows.RoutedEventArgs e)
        {
            //Получаем врача из кнопки
            var doctor = (sender as Button).DataContext as Doctor;
            //Переходим на страницу заполнения
            this.NavigationService.Navigate(new ExtensionPages.AddDoctorPage(doctor));
        }

        private void DeleteButton_Click(object sender, System.Windows.RoutedEventArgs e)
        {
            var asnwer = MessageBox.Show("Вы действительно хотите удалить эту запись?", "Внимание", MessageBoxButton.YesNoCancel, MessageBoxImage.Warning);
            if (asnwer != MessageBoxResult.Yes) return;
            //Получаем врача из кнопки
            var doctor = (sender as Button).DataContext as Doctor;
            //Удаляем и сохраняем
            _db.Workers.Remove(doctor.Worker);
            _db.Doctors.Remove(doctor);
            _db.SaveChanges();
        }

        /// <summary>
        /// Фильтр по специализациям
        /// </summary>
        private void CmbSpecFilter_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (cmbSpecFilter.SelectedItem == null) return;
            var spec = cmbSpecFilter.SelectedItem as Specialization; //Получаем выбранную специализацию
            if (spec.Title == "Фильтр по специализации") //Если это заглушка, выводим все записи
            {
                collectionView.ItemsSource = _db.Doctors.Local.ToBindingList();
                return;
            }
            //Если это НЕ заглушка, проводим выборку по специализациям
            collectionView.ItemsSource = _db.Doctors.Local.Where(p => p.Specialization == spec).ToList();
            txtFind.Text = "Поиск по фио"; //Сбрасываем фильтр по фио
        }

        /// <summary>
        /// Поиск по фио
        /// </summary>
        private void TxtFind_TextChanged(object sender, TextChangedEventArgs e)
        {
            if (txtFind.Text == null) return;
            if (collectionView.ItemsSource == null) return;
            if (txtFind.Text == "Поиск по фио") return; //Если это заглушка, ничего не делаем

            //Получаем записи из списка на форме и преобразуем их в List
            var entities = collectionView.ItemsSource;
            List<Doctor> list = entities.Cast<Doctor>().ToList();

            //Если поиск пуст, выводим все записи выбранной специальности, принудительно вызвав фильтр
            if (string.IsNullOrEmpty(txtFind.Text))
            {
                CmbSpecFilter_SelectionChanged(null, null);
                return;
            }
            //Если это НЕ заглушка, проводим выборку по фио
            collectionView.ItemsSource = list.Where(p => p.Worker.FIO.Contains(txtFind.Text));
        }
    }
}

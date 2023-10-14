using Polyclinic.Data;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Windows;
using System.Windows.Controls;

namespace Polyclinic.Pages
{
    /// <summary>
    /// Логика взаимодействия для AppoitmentsPage.xaml
    /// </summary>
    public partial class AppoitmentsPage : Page
    {
        private readonly DbEntities _db = DbEntities.GetContext();
        public AppoitmentsPage()
        {
            InitializeComponent();
        }

        /// <summary>
        /// Вызывается при переходе на страницу
        /// </summary>
        private void Page_Loaded(object sender, System.Windows.RoutedEventArgs e)
        {
            //Загружаем таблицу приемов и выводим ее на форму
            _db.Appointments.Load();
            collectionView.ItemsSource = _db.Appointments.Local.ToBindingList();

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
            //Создаем новый прием
            Appointment appointment = new Appointment();
            //Переходим на страницу заполнения
            this.NavigationService.Navigate(new ExtensionPages.AddAppointmentPage(appointment));
        }

        private void EditButton_Click(object sender, System.Windows.RoutedEventArgs e)
        {
            //Получаем прием из кнопки
            var appointment = (sender as Button).DataContext as Appointment;
            //Переходим на страницу заполнения
            this.NavigationService.Navigate(new ExtensionPages.AddAppointmentPage(appointment));
        }

        private void DeleteButton_Click(object sender, System.Windows.RoutedEventArgs e)
        {
            var asnwer = MessageBox.Show("Вы действительно хотите удалить эту запись?", "Внимание", MessageBoxButton.YesNoCancel, MessageBoxImage.Warning);
            if (asnwer != MessageBoxResult.Yes) return;
            //Получаем прием из кнопки
            var appointment = (sender as Button).DataContext as Appointment;
            //Удаляем и сохраняем
            _db.Appointments.Remove(appointment);
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
                collectionView.ItemsSource = _db.Appointments.Local.ToBindingList();
                return;
            }
            //Если это НЕ заглушка, проводим выборку по специализациям
            collectionView.ItemsSource = _db.Appointments.Local.Where(p => p.Doctor.Specialization == spec).ToList();
            if (txtFind.SelectedDate != null) //Сбрасываем фильтр по дате
            {
                txtFind.SelectedDate = null;
            }
        }

        /// <summary>
        /// Фильтр по дате приема
        /// </summary>
        private void TxtFind_SelectedDateChanged(object sender, SelectionChangedEventArgs e)
        {
            if (txtFind == null) return;

            //Если ничего не выбрано, или список на форме пустой, обновим его принудительным вызовом фильтра
            if (txtFind.Text == string.Empty || collectionView.ItemsSource.Cast<Appointment>().Count() == 0)
            {
                CmbSpecFilter_SelectionChanged(null, null);
                return;
            }

            //Получаем записи из списка на форме и преобразуем их в List
            var entities = collectionView.ItemsSource;
            List<Appointment> list = entities.Cast<Appointment>().ToList();
            //Проводим выборку по дате
            collectionView.ItemsSource = list.Where(p => p.Date.Value.Date == txtFind.SelectedDate.Value.Date);
        }
    }
}

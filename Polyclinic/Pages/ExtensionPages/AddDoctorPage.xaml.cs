using Polyclinic.Data;
using System;
using System.Data.Entity;
using System.Linq;
using System.Windows;
using System.Windows.Controls;

namespace Polyclinic.Pages.ExtensionPages
{
    /// <summary>
    /// Логика взаимодействия для AddDoctorPage.xaml
    /// </summary>
    public partial class AddDoctorPage : Page
    {
        private readonly DbEntities _db = DbEntities.GetContext();
        public AddDoctorPage(Doctor doctor)
        {
            InitializeComponent();
            //Получаем объект для редактирования и привязываем его
            this.DataContext = doctor;

            //Загружаем данные, заполняем comboboх
            _db.Specializations.Load();
            cmb.ItemsSource = _db.Specializations.ToList();
        }

        private void CancelButton_Click(object sender, RoutedEventArgs e)
        {
            this.NavigationService.GoBack();
        }

        private void SaveButton_Click(object sender, RoutedEventArgs e)
        {
            //Получаем объект из привязки
            var doctor = this.DataContext as Doctor;
            txtErrorMessage.Text = string.Empty; //Очищаем строку с ошибкой

            //Валидация данных
            if (cmb.SelectedItem == null)
            {
                txtErrorMessage.Text = "Ошибка: Выберите специализацию";
                return;
            }
            if (string.IsNullOrEmpty(doctor.Worker.FIO))
            {
                txtErrorMessage.Text = "Ошибка: Укажите фио";
                return;
            }
            if (string.IsNullOrEmpty(doctor.Worker.Adress))
            {
                txtErrorMessage.Text = "Ошибка: Укажите адрес";
                return;
            }
            if (doctor.Worker.DateEnployment == null)
            {
                txtErrorMessage.Text = "Ошибка: Укажите дату трудоустройства";
                return;
            }

            //Указываем id для связей в бд
            doctor.SpecializationId = doctor.Specialization.Id;

            //Если такой записи еще нет, значит добавим ее
            if (_db.Workers.Find(doctor.Id) == null)
            {
                //Добавим сначала работника, к которому привяжем нового врача
                _db.Workers.Add(doctor.Worker);

                doctor.Id = doctor.Worker.Id; //Указываем что новый рабочий будет новым врачом
                //Добавляем врача
                _db.Doctors.Add(doctor);
            }
            try
            {
                _db.SaveChanges();
            }
            catch (Exception ex)
            {
                txtErrorMessage.Text = ex.Message + ex.InnerException?.Message;
                return;
            }
            this.NavigationService.GoBack();
        }
    }
}

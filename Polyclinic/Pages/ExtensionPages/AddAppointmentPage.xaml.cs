using Polyclinic.Data;
using System;
using System.Data.Entity;
using System.Linq;
using System.Windows;
using System.Windows.Controls;

namespace Polyclinic.Pages.ExtensionPages
{
    /// <summary>
    /// Логика взаимодействия для AddAppointmentPage.xaml
    /// </summary>
    public partial class AddAppointmentPage : Page
    {
        private readonly DbEntities _db = DbEntities.GetContext();
        public AddAppointmentPage(Appointment appointment)
        {
            InitializeComponent();
            //Получаем объект для редактирования и привязываем его
            this.DataContext = appointment;
            
            //Устанавливаем дату если есть
            if (appointment.Date != null)
            {
                txtTime.Text = appointment.Date.Value.ToString("HH") + ":" + appointment.Date.Value.ToString("mm");
            }

            //Загружаем данные, заполняем combobox'ы
            _db.Specializations.Load();
            _db.Doctors.Load();
            _db.Nurses.Load();
            _db.MedicalCards.Load();
            cmbSpec.ItemsSource = _db.Specializations.ToList();
            cmbMedCard.ItemsSource = _db.MedicalCards.ToList();
            cmbNurse.ItemsSource = _db.Nurses.ToList();
        }

        private void CancelButton_Click(object sender, RoutedEventArgs e)
        {
            this.NavigationService.GoBack();
        }

        private void SaveButton_Click(object sender, RoutedEventArgs e)
        {
            //Получаем объект из привязки
            Appointment appointment = this.DataContext as Appointment;
            txtErrorMessage.Text = string.Empty; //Очищаем строку с ошибкой

            //Валидация данных
            if (cmbSpec.SelectedItem == null)
            {
                txtErrorMessage.Text = "Ошибка: Выберите специализацию";
                return;
            }
            if (cmbDoctor.SelectedItem == null)
            {
                txtErrorMessage.Text = "Ошибка: Выберите врача";
                return;
            }
            if (cmbMedCard.SelectedItem == null)
            {
                txtErrorMessage.Text = "Ошибка: Выберите пациента";
                return;
            }
            if (cmbNurse.SelectedItem == null)
            {
                txtErrorMessage.Text = "Ошибка: Выберите медсестру";
                return;
            }
            if (appointment.Date == null)
            {
                txtErrorMessage.Text = "Ошибка: Выберите дату приема";
                return;
            }
            if (string.IsNullOrEmpty(txtTime.Text) || txtTime.Text.Length != 5)
            {
                txtErrorMessage.Text = "Ошибка: Укажите время с 07:00 по 20:59";
                return;
            }

            if (!int.TryParse(txtTime.Text.Substring(0, 2), out int hours))
            {
                txtErrorMessage.Text = "Ошибка: Укажите время с 07:00 по 20:59";
                return;
            }

            if (!int.TryParse(txtTime.Text.Substring(3, 2), out int minutes))
            {
                txtErrorMessage.Text = "Ошибка: Укажите время с 07:00 по 20:59";
                return;
            }

            if (hours < 7 || hours > 20)
            {
                txtErrorMessage.Text = "Ошибка: Укажите время с 07:00 по 20:59";
                return;
            }
            if (minutes < 0 || minutes > 59)
            {
                txtErrorMessage.Text = "Ошибка: Укажите время с 07:00 по 20:59";
                return;
            }

            //Добавляем время из текстбокса в дату из датапикера
            var old = appointment.Date.Value;

            appointment.Date = new DateTime(old.Year, old.Month, old.Day, hours, minutes, 0);

            if (appointment.Date < DateTime.Now)
            {
                txtErrorMessage.Text = "Ошибка: Выбрана дата в прошлом";
                return;
            }

            //Указываем id для связей в бд
            appointment.MedicalCardId = appointment.MedicalCard.Id;
            appointment.NurseId = appointment.Nurse.Id;
            appointment.DoctorId = appointment.Doctor.Id;
            
            //Если такой записи еще нет, значит добавим ее
            if (_db.Appointments.Find(appointment.Id) == null)
            {
                //Получение расписания приемов у выбранного доктора
                var list = _db.Appointments.Where(p => p.DoctorId == appointment.DoctorId).ToList();

                //Если в 15 минутный промежуток в этот день у врача уже есть запись, сообщаем об этом
                if (list.Count(p => p.Date > appointment.Date.Value.AddMinutes(-15) && p.Date < appointment.Date.Value.AddMinutes(15)) > 0)
                {
                    txtErrorMessage.Text = "Ошибка: На данное время к данному врачу уже существует запись";
                    return;
                }
                //Добавляем запись в базу данных
                _db.Appointments.Add(appointment);
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

        private void SpecChanged(object sender, SelectionChangedEventArgs e)
        {
            if (cmbSpec.SelectedItem == null) return;
            //Получаем выбранную специализацию из комбобокса
            var spec = cmbSpec.SelectedItem as Specialization;
            //Заполняем комбобокс врачей врачами выбранной специализации
            cmbDoctor.ItemsSource = _db.Doctors.Where(p => p.SpecializationId == spec.Id).ToList();
        }
    }
}

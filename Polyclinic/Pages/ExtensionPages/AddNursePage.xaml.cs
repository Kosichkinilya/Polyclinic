using Polyclinic.Data;
using System;
using System.Windows;
using System.Windows.Controls;

namespace Polyclinic.Pages.ExtensionPages
{
    /// <summary>
    /// Логика взаимодействия для AddNursePage.xaml
    /// </summary>
    public partial class AddNursePage : Page
    {
        private readonly DbEntities _db = DbEntities.GetContext();
        public AddNursePage(Nurse nurse)
        {
            InitializeComponent();
            //Получаем объект для редактирования и привязываем его
            this.DataContext = nurse;
        }

        private void CancelButton_Click(object sender, RoutedEventArgs e)
        {
            this.NavigationService.GoBack();
        }

        private void SaveButton_Click(object sender, RoutedEventArgs e)
        {
            //Получаем объект из привязки
            var nurse = this.DataContext as Nurse;
            txtErrorMessage.Text = string.Empty; //Очищаем строку с ошибкой

            //Валидация данных
            if (string.IsNullOrEmpty(nurse.Worker.FIO))
            {
                txtErrorMessage.Text = "Ошибка: Укажите фио";
                return;
            }
            if (string.IsNullOrEmpty(nurse.Worker.Adress))
            {
                txtErrorMessage.Text = "Ошибка: Укажите адрес";
                return;
            }
            if (nurse.Office == null | nurse.Office == 0)
            {
                txtErrorMessage.Text = "Ошибка: Укажите номер кабинета";
                return;
            }
            if (nurse.Worker.DateEnployment == null)
            {
                txtErrorMessage.Text = "Ошибка: Укажите дату трудоустройства";
                return;
            }


            //Если такой записи еще нет, значит добавим ее
            if (_db.Workers.Find(nurse.Id) == null)
            {
                //Добавим сначала работника, к которому привяжем новую медсестру
                _db.Workers.Add(nurse.Worker);

                nurse.Id = nurse.Worker.Id; //Указываем что новый рабочий будет новой медсестрой
                //Добавляем медсестру
                _db.Nurses.Add(nurse);
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

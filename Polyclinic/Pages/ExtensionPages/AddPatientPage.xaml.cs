using Polyclinic.Data;
using System;
using System.Windows;
using System.Windows.Controls;

namespace Polyclinic.Pages.ExtensionPages
{
    /// <summary>
    /// Логика взаимодействия для AddPatientPage.xaml
    /// </summary>
    public partial class AddPatientPage : Page
    {
        private readonly DbEntities _db = DbEntities.GetContext();
        public AddPatientPage(MedicalCard patient)
        {
            InitializeComponent();
            //Получаем объект для редактирования и привязываем его
            this.DataContext = patient;
        }

        private void CancelButton_Click(object sender, RoutedEventArgs e)
        {
            this.NavigationService.GoBack();
        }

        private void SaveButton_Click(object sender, RoutedEventArgs e)
        {
            //Получаем объект из привязки
            var medicalCard = this.DataContext as MedicalCard;
            txtErrorMessage.Text = string.Empty; //Очищаем строку с ошибкой

            //Валидация данных
            if (string.IsNullOrEmpty(medicalCard.FIO))
            {
                txtErrorMessage.Text = "Ошибка: Укажите фио";
                return;
            }
            if (string.IsNullOrEmpty(medicalCard.Adress))
            {
                txtErrorMessage.Text = "Ошибка: Укажите адрес";
                return;
            }
            if (string.IsNullOrEmpty(medicalCard.Phone))
            {
                txtErrorMessage.Text = "Ошибка: Укажите телефон";
                return;
            }

            //Если такой записи еще нет, значит добавим ее
            if (_db.MedicalCards.Find(medicalCard.Id) == null)
            {
                _db.MedicalCards.Add(medicalCard);
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

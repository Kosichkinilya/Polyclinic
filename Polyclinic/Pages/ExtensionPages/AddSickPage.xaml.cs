using Polyclinic.Data;
using System;
using System.Data.Entity;
using System.Linq;
using System.Windows;
using System.Windows.Controls;

namespace Polyclinic.Pages.ExtensionPages
{
    /// <summary>
    /// Логика взаимодействия для AddSickPage.xaml
    /// </summary>
    public partial class AddSickPage : Page
    {
        private readonly DbEntities _db = DbEntities.GetContext();
        public AddSickPage(Sick sick)
        {
            InitializeComponent();
            //Получаем объект для редактирования и привязываем его
            this.DataContext = sick;

            //Загружаем данные, заполняем combobox
            _db.MedicalCards.Load();
            cmb.ItemsSource = _db.MedicalCards.ToList();
        }

        private void CancelButton_Click(object sender, RoutedEventArgs e)
        {
            this.NavigationService.GoBack();
        }

        private void SaveButton_Click(object sender, RoutedEventArgs e)
        {
            //Получаем объект из привязки
            var sick = this.DataContext as Sick;
            txtErrorMessage.Text = string.Empty; //Очищаем строку с ошибкой

            //Валидация данных
            if (cmb.SelectedItem == null)
            {
                txtErrorMessage.Text = "Ошибка: Выберите пациента";
                return;
            }
            if (sick.DateStart == null)
            {
                txtErrorMessage.Text = "Ошибка: Укажите дату начала больничного";
                return;
            }
            if (sick.DateEnd == null)
            {
                txtErrorMessage.Text = "Ошибка: Укажите дату выхода с больничного";
                return;
            }
            if (sick.DateEnd <= sick.DateStart)
            {
                txtErrorMessage.Text = "Ошибка: Дата конца раньше даты начала";
                return;
            }
            if (_db.Sicks.Count(p => p.MedicalCardId == sick.MedicalCard.Id && p.DateEnd >= DateTime.Now) > 0)
            {
                txtErrorMessage.Text = "Ошибка: Пациент уже на больничном";
                return;
            }

            //Указываем id для связей в бд
            sick.MedicalCardId = sick.MedicalCard.Id;

            //Если такой записи еще нет, значит добавим ее
            if (_db.Sicks.Find(sick.Id) == null)
            {
                _db.Sicks.Add(sick);
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

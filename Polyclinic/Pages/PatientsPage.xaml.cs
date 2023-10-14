using Polyclinic.Data;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Windows;
using System.Windows.Controls;

namespace Polyclinic.Pages
{
    /// <summary>
    /// Логика взаимодействия для PatientsPage.xaml
    /// </summary>
    public partial class PatientsPage : Page
    {
        private readonly DbEntities _db = DbEntities.GetContext();
        public PatientsPage()
        {
            InitializeComponent();
        }

        /// <summary>
        /// Вызывается при переходе на страницу
        /// </summary>
        private void Page_Loaded(object sender, System.Windows.RoutedEventArgs e)
        {
            //Загружаем таблицу паицентов и выводим их на форму
            _db.MedicalCards.Load();
            collectionView.ItemsSource = _db.MedicalCards.Local.ToBindingList();
            txtFindFio.Text = "Поиск по фио"; //Сбрасываем фильтр
        }

        private void AddButton_Click(object sender, System.Windows.RoutedEventArgs e)
        {
            //Создаем нового врача
            MedicalCard patient = new MedicalCard();
            //Переходим на страницу заполнения
            this.NavigationService.Navigate(new ExtensionPages.AddPatientPage(patient));
        }

        private void EditButton_Click(object sender, System.Windows.RoutedEventArgs e)
        {
            //Получаем пациента из кнопки
            var patient = (sender as Button).DataContext as MedicalCard;
            //Переходим на страницу заполнения
            this.NavigationService.Navigate(new ExtensionPages.AddPatientPage(patient));
        }

        private void DeleteButton_Click(object sender, System.Windows.RoutedEventArgs e)
        {
            var asnwer = MessageBox.Show("Вы действительно хотите удалить эту запись?", "Внимание", MessageBoxButton.YesNoCancel, MessageBoxImage.Warning);
            if (asnwer != MessageBoxResult.Yes) return;
            //Получаем пациента из кнопки
            var patient = (sender as Button).DataContext as MedicalCard;
            //Удаляем и сохраняем
            _db.MedicalCards.Remove(patient);
            _db.SaveChanges();
        }

        /// <summary>
        /// Поиск по фио
        /// </summary>
        private void TxtFindFio_TextChanged(object sender, TextChangedEventArgs e)
        {
            if (txtFindFio == null) return;
            if (txtFindFio.Text == "Поиск по фио") return; //Если это заглушка, ничего не делаем

            //Если пустой текстбокс, выводим все записи
            if (!string.IsNullOrEmpty(txtFindFio.Text)) collectionView.ItemsSource = _db.MedicalCards.Local.ToBindingList();

            //Если список пустой, для выборки наполним его записями из таблицы
            List<MedicalCard> list = collectionView.ItemsSource?.Cast<MedicalCard>().ToList();
            if (list == null || list.Count == 0) list = _db.MedicalCards.Local.ToList();

            //Проводим выборку по фио
            collectionView.ItemsSource = list.Where(p => p.FIO.Contains(txtFindFio.Text));
        }
    }
}

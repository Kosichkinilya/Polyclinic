using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;

namespace Polyclinic
{
    /// <summary>
    /// Логика взаимодействия для MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
            //Переходим на страницу врачей
            ToDoctors_Click(btnPage1, null);
        }

        /// <summary>
        /// Выключить подсветку всех кнопок
        /// </summary>
        private void UnSelectAll()
        {
            btnPage1.Background = Brushes.DodgerBlue;
            btnPage2.Background = Brushes.DodgerBlue;
            btnPage3.Background = Brushes.DodgerBlue;
            btnPage4.Background = Brushes.DodgerBlue;
            btnPage5.Background = Brushes.DodgerBlue;
        }

        /// <summary>
        /// Переход на страницу врачей
        /// </summary>
        private void ToDoctors_Click(object sender, RoutedEventArgs e)
        {
            UnSelectAll();
            pageContainer.NavigationService.Navigate(new Pages.DoctorsPage());
            (sender as Button).Background = Brushes.White; //Выделить кноку на нижней панели
        }

        /// <summary>
        /// Переход на страницу медсестер
        /// </summary>
        private void ToNurses_Click(object sender, RoutedEventArgs e)
        {
            UnSelectAll();
            pageContainer.NavigationService.Navigate(new Pages.NursesPage());
            (sender as Button).Background = Brushes.White; //Выделить кноку на нижней панели
        }

        /// <summary>
        /// Переход на страницу приемов
        /// </summary>
        private void ToAppoitments_Click(object sender, RoutedEventArgs e)
        {
            UnSelectAll(); 
            pageContainer.NavigationService.Navigate(new Pages.AppoitmentsPage());
            (sender as Button).Background = Brushes.White; //Выделить кноку на нижней панели
        }

        /// <summary>
        /// Переход на страницу пациентов
        /// </summary>
        private void ToPatients_Click(object sender, RoutedEventArgs e)
        {
            UnSelectAll(); 
            pageContainer.NavigationService.Navigate(new Pages.PatientsPage());
            (sender as Button).Background = Brushes.White; //Выделить кноку на нижней панели
        }

        /// <summary>
        /// Переход на страницу больничных
        /// </summary>
        private void ToSicks_Click(object sender, RoutedEventArgs e)
        {
            UnSelectAll(); 
            pageContainer.NavigationService.Navigate(new Pages.SicksPage());
            (sender as Button).Background = Brushes.White; //Выделить кноку на нижней панели
        }

        private void ExitButton_Click(object sender, RoutedEventArgs e)
        {
            this.Close();
        }
    }
}

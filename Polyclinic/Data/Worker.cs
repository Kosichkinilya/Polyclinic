//------------------------------------------------------------------------------
// <auto-generated>
//     Этот код создан по шаблону.
//
//     Изменения, вносимые в этот файл вручную, могут привести к непредвиденной работе приложения.
//     Изменения, вносимые в этот файл вручную, будут перезаписаны при повторном создании кода.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Polyclinic.Data
{
    using System;
    using System.Collections.Generic;
    
    public partial class Worker
    {
        public int Id { get; set; }
        public string FIO { get; set; }
        public string Phone { get; set; }
        public string Adress { get; set; }
        public Nullable<System.DateTime> DateEnployment { get; set; }
        public Nullable<decimal> Salary { get; set; }
    
        public virtual Doctor Doctor { get; set; }
        public virtual Nurse Nurse { get; set; }
    }
}

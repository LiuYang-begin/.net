﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CoSales.Model.PO
{
    [Dapper.Table("T_EMPLOYEE")]
    public class Employee
    {
        /// <summary>
        /// 标识为主键
        /// </summary>
        [Dapper.Key]
        public int ID { get; set; }
        public string EmployeeName { get; set; }
        public string Sex { get; set; }
        public DateTime BirthDate { get; set; }
        public DateTime HireDate { get; set; }
        public double Salary { get; set; }
        public Department Depart { get; set; }
    }
}

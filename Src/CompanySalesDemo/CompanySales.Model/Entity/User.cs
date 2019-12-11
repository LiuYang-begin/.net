namespace CompanySales.Model.Entity
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Users")]
    public partial class User
    {
        [Key]
        public int ID { get; set; }

        /// <summary>
        /// �ع�-�������������뷨Ӣ��״̬��
        /// ctrl+. ��ʾ��ݲ�����ʾ����
        /// </summary>
        [StringLength(50)]
        public string Name { get; set; }

        [StringLength(20)]
        public string UserId { get; set; }

        [StringLength(50)]
        public string Password { get; set; }

        [StringLength(100)]
        public string Address { get; set; }

        [StringLength(100)]
        public string Roles { get; set; }
    }
}

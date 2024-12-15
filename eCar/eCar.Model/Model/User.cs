using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Model.Model
{
    public class User
    {
        public int Id { get; set; }

        public string? Name { get; set; }

        public string? Surname { get; set; }

        public string? UserName { get; set; }

        public string? Email { get; set; }

        //public string? Password { get; set; }

        public string? TelephoneNumber { get; set; }

        public string? Gender { get; set; }

        public DateTime? RegistrationDate { get; set; }

        public bool? IsActive { get; set; }

        //public virtual ICollection<Admin> Admins { get; set; } = new List<Admin>();

        public virtual ICollection<Client> Clients { get; set; } = new List<Client>();

        public virtual ICollection<Driver> Drivers { get; set; } = new List<Driver>();
    }
}

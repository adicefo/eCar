using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Model.Requests
{
    public class UserUpdateRequest
    {
        public string? Name { get; set; }

        public string? Surname { get; set; }

        public string? TelephoneNumber { get; set; }
        public string? Email { get; set; }

        public string? UserName { get; set; }

        public string? Gender { get; set; }
        public string? Password { get; set; }
        public string? PasswordConfirm { get; set; }

    }
}

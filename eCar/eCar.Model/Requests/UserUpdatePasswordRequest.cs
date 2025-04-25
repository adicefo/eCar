using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Model.Requests
{
    public class UserUpdatePasswordRequest
    {
        public string Password { get; set; }
        public string PasswordConfirm { get; set; }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Model.Helper
{
    public class AuthResponse
    {
        public AuthResult Result { get; set; }
        public string Token { get; set; }
        public int UserId { get; set; }
        public string Role { get; set; }
    }
}

using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Model.Requests
{
    public class DriverUpdateRequest
    {
        [Required]
        public string Password { get; set; }
        [Required]
        public string PasswordConfirm { get; set; }
        public string? TelephoneNumber { get; set; }
        public string? Email { get; set; }
    }
}

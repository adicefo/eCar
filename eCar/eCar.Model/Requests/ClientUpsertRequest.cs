using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Model.Requests
{
    public class ClientUpsertRequest
    {
        [Required]
       
        public string Name { get; set; }
        [Required]
       
        public string Surname { get; set; }
        [Required]
       
        public string UserName { get; set; }
        [Required]
        [EmailAddress]
        public string Email { get; set; }
        [Required]
        
        public string Password { get; set; }
        [Required]
        
        public string PasswordConfirm { get; set; }

        public string? TelephoneNumber { get; set; }

        public string? Gender { get; set; }
    }
}

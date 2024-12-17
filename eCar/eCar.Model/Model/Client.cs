using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Model.Model
{
    public class Client
    {
        
        public int Id { get; set; }

        public int UserId { get; set; }
        public virtual User User { get; set; } = null!;

        public Client()
            
        {
            
        }
    }
}

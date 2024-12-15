using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace eCar.Model.DTO
{
    public class PointDTO
    {
        
        public double Latitude { get; set; }
        public double Longitude { get; set; }

        [DefaultValue(4326)]
        public int SRID { get; set; }

        public PointDTO(double longitude,double latitude,int SRID)
        {
            Latitude = latitude;
            Longitude= longitude;
            this.SRID = SRID;
        }
    }
}

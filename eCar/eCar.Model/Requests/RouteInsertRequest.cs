using eCar.Model.DTO;
using Nest;
using NetTopologySuite.Geometries;
using System;
using System.ComponentModel;
using System.Data.Entity.Spatial;


namespace eCar.Model.Requests
{
    public class RouteInsertRequest
    {
        public PointDTO? SourcePoint { get; set; }

        public PointDTO? DestinationPoint { get; set; }

        public int ClientId { get; set; }

        public int DriverID { get; set; }
     

    }
}
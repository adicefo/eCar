using eCar.Model.DTO;
using eCar.Model.Model;
using eCar.Services;
using Mapster;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using NetTopologySuite.Geometries;
using System.Data.Entity;

public static class MapsterConfig
{
    public static void Configure()
    {
        TypeAdapterConfig<PointDTO, Point>
     .NewConfig()
     .MapWith(dto => new Point(dto.Longitude, dto.Latitude) { SRID = dto.SRID });

        TypeAdapterConfig<Point, PointDTO>
            .NewConfig()
            .MapWith(point => new PointDTO(point.X, point.Y, point.SRID));
     
    }
}


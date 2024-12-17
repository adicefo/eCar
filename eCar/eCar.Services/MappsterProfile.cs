using eCar.Model.DTO;
using Mapster;
using NetTopologySuite.Geometries; 

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


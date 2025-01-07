using eCar.Model.Helper;
using eCar.Services.Database;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.JsonWebTokens;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.Helpers
{
    public static class TokenGenerate
    {
        public static ECarDbContext Context { get; set; }
        public static IConfiguration Configuration { get; set; }

        public static string CreateToken(User user,string desiredRole)
        {
           var role=CheckRole(user,desiredRole);
            if (role == null)
                return null;
            string secretKey = Configuration["Jwt:Secret"];

            var securityKey=new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secretKey));

            var credentilas=new SigningCredentials(securityKey,SecurityAlgorithms.HmacSha256);

            var tokenDescriptor = new SecurityTokenDescriptor()
            {
                Subject = new ClaimsIdentity(
                [
                 
                    new Claim(ClaimTypes.Email,user.Email),
                    new Claim(ClaimTypes.Role,role),

                ]),
                Expires = DateTime.UtcNow.AddDays(1),
                SigningCredentials = credentilas,
                Issuer = Configuration["Jwt:Issuer"],
                Audience = Configuration["Jwt:Audience"]
                
            };
            var handler = new JsonWebTokenHandler();

            string token=handler.CreateToken(tokenDescriptor);

            return token;
            
          
        }

        public static string CheckRole(User user,string desiredRole)
        {
            switch (desiredRole)
            {
                case ("Admin"):
                    var admin = Context.Admins.FirstOrDefault(a => a.UserID == user.Id);
                    if (admin != null)
                        return "Admin";
                    return null;
                case ("Client"):
                    var client = Context.Clients.FirstOrDefault(c=>c.UserId == user.Id);
                    if (client != null)
                        return "Client";
                    return null;
                case ("Driver"):
                    var driver = Context.Drivers.FirstOrDefault(d => d.UserID == user.Id);
                    if (driver != null)
                        return "Driver";
                    return null;
                default:
                    throw new UserException("Invalid role");
            }
            

        }
        public static ClaimsPrincipal? ValidateToken(string token)
        {
            var tokenHandler = new JwtSecurityTokenHandler();
            var key = Encoding.UTF8.GetBytes(Configuration["Jwt:Secret"]);
            try
            {
                var claimsPrincipal = tokenHandler.ValidateToken(token, new TokenValidationParameters
                {
                    ValidateIssuer = true,
                    ValidateAudience = true,
                    ValidateLifetime = true,
                    ValidateIssuerSigningKey = true,
                    ValidIssuer = Configuration["Jwt:Issuer"],
                    ValidAudience = Configuration["Jwt:Audience"],
                    IssuerSigningKey = new SymmetricSecurityKey(key)
                }, out SecurityToken validatedToken);

                return claimsPrincipal;
            }
            catch
            {
                return null;
            }
        }
    }
}

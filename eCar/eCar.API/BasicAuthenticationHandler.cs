﻿using eCar.Services.Interfaces;
using Microsoft.AspNetCore.Authentication;
using Microsoft.Extensions.Options;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text;
using System.Text.Encodings.Web;
using System.Threading;

namespace eCar.API
{
    public class BasicAuthenticationHandler: AuthenticationHandler<AuthenticationSchemeOptions>
    {
        public IUserService _service { get; set; }
        public BasicAuthenticationHandler(IOptionsMonitor<AuthenticationSchemeOptions> options,ILoggerFactory logger,
            UrlEncoder encoder,ISystemClock clock,IUserService service):base(options,logger,encoder,clock)
        {
            _service = service;
        }
       protected override async Task<AuthenticateResult> HandleAuthenticateAsync()
       {
           if (!Request.Headers.ContainsKey("Authorization"))
           {
               return AuthenticateResult.Fail("Missing header");
           }
      
           var authHeader = AuthenticationHeaderValue.Parse(Request.Headers["Authorization"]);
           var credentialsBytes = Convert.FromBase64String(authHeader.Parameter);
           var credentials = Encoding.UTF8.GetString(credentialsBytes).Split(':');
      
           var username = credentials[0];
           var password = credentials[1];
      
           
           if (username==null||password==null)
               return AuthenticateResult.Fail("Incorrect username or password");
           else
           {
               var claims = new List<Claim>()
               {
                   new Claim(ClaimTypes.Role, "Admin")
               };
      
               var identity=new ClaimsIdentity(claims,Scheme.Name);
      
               var principal=new ClaimsPrincipal(identity);
      
               var ticket=new AuthenticationTicket(principal,Scheme.Name);
      
               return AuthenticateResult.Success(ticket);
           }
      
       }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MapsterMapper;
using System.Security.Cryptography;
using eCar.Services.Interfaces;
using eCar.Model.Requests;
using eCar.Services.Database;
using eCar.Services.Helpers;
using eCar.Model.SearchObject;
using System.Data.Entity;
using Microsoft.Extensions.Logging;
using eCar.Model.Helper;
using Microsoft.IdentityModel.Tokens;
using System.Configuration;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using Microsoft.Extensions.Configuration;
namespace eCar.Services.Services
{
    public class UserService : BaseCRUDService<Model.Model.User, UserSearchObject, Database.User, UserInsertRequest, UserUpdateRequest>, IUserService
    {

        public ILogger<UserService> _logger { get; set; }
        public UserService(ECarDbContext context, IMapper mapper, ILogger<UserService> logger) :
            base(context, mapper)
        {
            _logger = logger;
        }
        public AuthResponse AuthenticateUser(string email, string password, string role)
        {
            var user = Context.Users.FirstOrDefault(u => u.Email == email);
            if (user == null)
                return new AuthResponse { Result = AuthResult.UserNotFound };


            if (!PasswordGenerate.VerifyPassword(password, user.PasswordHash, user.PasswordSalt))
                return new AuthResponse { Result = AuthResult.InvalidPassword };

            var token = TokenGenerate.CreateToken(user, role);
            if (token == null)
                return new AuthResponse() { Result = AuthResult.UserNotFound };

            string rola="";

            switch (role)
            {
                case ("Admin"):
                    var admin = Context.Admins.FirstOrDefault(a => a.UserID == user.Id);
                    rola = "admin";
                    break;
                case ("Client"):
                    var client = Context.Clients.FirstOrDefault(c => c.UserId == user.Id);
                    rola = "client";
                    break;
                case ("Driver"):
                    var driver = Context.Drivers.FirstOrDefault(d => d.UserID == user.Id);
                    rola = "driver"; 
                    break;
                default:
                    throw new UserException("Invalid role");
            }

            return new AuthResponse
            {
                Result = AuthResult.Success,
                UserId = user.Id,
                Token = token,
                Role = rola,
            };

        }
        public Model.Model.User UpdatePassword(int id,UserUpdatePasswordRequest request)
        {
            var entity=Context.Users.Find(id);
            if (entity == null)
                throw new UserException($"User with {id} not found");
            if (request.Password != request.PasswordConfirm)
                throw new UserException($"Password and confirm password must be equal");
            entity.PasswordSalt = PasswordGenerate.GenerateSalt();
            entity.PasswordHash = PasswordGenerate.GenerateHash(entity.PasswordSalt, request.Password);
            Context.SaveChanges();
            return Mapper.Map<Model.Model.User>(entity);
        }
        public override IQueryable<Database.User> AddFilter(UserSearchObject search, IQueryable<Database.User> query)
        {
            var filteredQuery = base.AddFilter(search, query);
            if (!string.IsNullOrWhiteSpace(search?.NameGTE))
                filteredQuery = filteredQuery.Where(x => x.Name.StartsWith(search.NameGTE));
            if (!string.IsNullOrWhiteSpace(search?.SurnameGTE))
                filteredQuery = filteredQuery.Where(x => x.Surname.StartsWith(search.SurnameGTE));
            if (!string.IsNullOrWhiteSpace(search?.Email))
                filteredQuery = filteredQuery.Where(x => x.Email == search.Email);
            if (!string.IsNullOrWhiteSpace(search?.Username))
                filteredQuery = filteredQuery.Where(x => x.UserName == search.Username);
            return filteredQuery;
        }

        public override void BeforeInsert(UserInsertRequest request, User entity)
        {
            _logger.LogInformation($"Adding user: {entity.UserName}");

            if (request.Password != request.PasswordConfirm)
            {
                throw new Exception("Password and Confirmed password are not the same");
            }
            entity.PasswordSalt = PasswordGenerate.GenerateSalt();
            entity.PasswordHash = PasswordGenerate.GenerateHash(entity.PasswordSalt, request.Password);
            entity.RegistrationDate = DateTime.Now;
            base.BeforeInsert(request, entity);
        }
        public override void BeforeUpdate(UserUpdateRequest request, User entity)
        {

            if (request.Password != null)
            {
                if (request.Password != request.PasswordConfirm)
                {
                    throw new Exception("Password and Confirm password" +
                        "must be same values");
                }
                entity.PasswordSalt = PasswordGenerate.GenerateSalt();
                entity.PasswordHash = PasswordGenerate.GenerateHash(entity.PasswordSalt, request.Password);
            }
            base.BeforeUpdate(request, entity);
        }

        public Model.Model.User GetBasedOnToken(string token)
        {
            var principles=TokenGenerate.ValidateToken(token);

            if (principles == null)
                throw new UserException("Invalid token");

            var emailClaim = principles.FindFirst(ClaimTypes.Email)?.Value;
            if (emailClaim == null)
                throw new UserException("Invalid emaill");

            var entity = Context.Users.FirstOrDefault(x => x.Email == emailClaim);
            if (entity == null)
                throw new UserException("User not found");

            return Mapper.Map<Model.Model.User>(entity);

        }

        
    }
}

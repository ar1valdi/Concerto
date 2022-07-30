using Concerto.Server.Services;
using Concerto.Shared.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Concerto.Server.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private readonly ILogger<UserController> _logger;
        private readonly UserService _userService;


        public UserController(ILogger<UserController> logger, UserService userService)
        {
            _logger = logger;
            _userService = userService;
        }

        [HttpGet]
        public async Task<User?> GetCurrentUser()
        {
            // Todo add app identity claim in middleware
            var identity = this.User.Identity.Name;
            long id = 1;
            return await _userService.GetUser(1);
        }
    }
}

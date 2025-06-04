using System.Diagnostics;
using CuriousJordan_.Net_Core_Web_App_MVC.Models;
using Microsoft.AspNetCore.Mvc;

namespace CuriousJordan_.Net_Core_Web_App_MVC.Controllers
{
    public class AboutMe : Controller
    {
        private readonly ILogger<HomeController> _logger;

        public AboutMe(ILogger<HomeController> logger)
        {
            _logger = logger;
        }
        public IActionResult Index()
        {
            return View();
        }
        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}

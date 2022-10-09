using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Data;

namespace WebApplication1.Controllers
{
    public class UsuarioAdministradorController : Controller
    {
        DataTable dt = new DataTable();
        // GET: HomeController1
        public ActionResult Persona()
        {
            return View(dt);
        }

        public ActionResult Propiedad()
        {
            return View(dt);
        }

        public ActionResult Usuario()
        {
            return View(dt);
        }

        public ActionResult PersonaPropiedad()
        {
            return View(dt);
        }

        public ActionResult UsuarioPropiedad()
        {
            return View(dt);
        }

        public ActionResult Consultas()
        {
            return View();
        }

        // GET: HomeController1/Details/5
        public ActionResult Details(int id)
        {
            return View();
        }

        // GET: HomeController1/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: HomeController1/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(IFormCollection collection)
        {
            try
            {
                return RedirectToAction(nameof(Persona));
            }
            catch
            {
                return View();
            }
        }

        // GET: HomeController1/Edit/5
        public ActionResult Edit(int id)
        {
            return View();
        }

        // POST: HomeController1/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(int id, IFormCollection collection)
        {
            try
            {
                return RedirectToAction(nameof(Persona));
            }
            catch
            {
                return View();
            }
        }

        // GET: HomeController1/Delete/5
        public ActionResult Delete(int id)
        {
            return View();
        }

        // POST: HomeController1/Delete/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Delete(int id, IFormCollection collection)
        {
            try
            {
                return RedirectToAction(nameof(Persona));
            }
            catch
            {
                return View();
            }
        }
    }
}

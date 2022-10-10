using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using System.Data;

namespace WebApplication1.Controllers
{
    public class UsuarioAdministradorController : Controller
    {
        DataTable dt = new DataTable();
        // GET: HomeController1
        public ActionResult Persona()
        {
            SqlConnection con = new SqlConnection("Data Source=JPBR66\\SQLEXPRESS;" +
                "Initial Catalog=SegundaTarea;Integrated Security=SSPI");
            SqlCommand cmd = new SqlCommand();
            int outResult = 0;

            cmd.Connection = con;
            cmd.CommandText = "proc_tblPersonas";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable dt = new DataTable();
            da.Fill(dt);
            con.Close();
            return View(dt);
        }

        public ActionResult Propiedad()
        {
            SqlConnection con = new SqlConnection("Data Source=JPBR66\\SQLEXPRESS;" +
                "Initial Catalog=SegundaTarea;Integrated Security=SSPI");
            SqlCommand cmd = new SqlCommand();
            int outResult = 0;

            cmd.Connection = con;
            cmd.CommandText = "proc_tblPropiedades";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable dt = new DataTable();
            da.Fill(dt);
            con.Close();
            return View(dt);
        }

        public ActionResult Usuario()
        {
            SqlConnection con = new SqlConnection("Data Source=JPBR66\\SQLEXPRESS;" +
                "Initial Catalog=SegundaTarea;Integrated Security=SSPI");
            SqlCommand cmd = new SqlCommand();
            int outResult = 0;

            cmd.Connection = con;
            cmd.CommandText = "proc_tblUsuarios";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable dt = new DataTable();
            da.Fill(dt);
            con.Close();
            return View(dt);
        }

        public ActionResult PersonaPropiedad()
        {
            SqlConnection con = new SqlConnection("Data Source=JPBR66\\SQLEXPRESS;" +
                "Initial Catalog=SegundaTarea;Integrated Security=SSPI");
            SqlCommand cmd = new SqlCommand();
            int outResult = 0;

            cmd.Connection = con;
            cmd.CommandText = "proc_tblPersonaPropiedad";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable dt = new DataTable();
            da.Fill(dt);
            con.Close();
            return View(dt);
        }

        public ActionResult UsuarioPropiedad()
        {
            SqlConnection con = new SqlConnection("Data Source=JPBR66\\SQLEXPRESS;" +
                "Initial Catalog=SegundaTarea;Integrated Security=SSPI");
            SqlCommand cmd = new SqlCommand();
            int outResult = 0;

            cmd.Connection = con;
            cmd.CommandText = "proc_tblUsuarioPropiedad";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable dt = new DataTable();
            da.Fill(dt);
            con.Close();
            return View(dt);
        }

        public ActionResult Consultas()
        {
            return View();
        }

        public ActionResult ConsultaPropiedadesPropietario()
        {
            return View();
        }

        public ActionResult ConsultaPropietarioPropiedad()
        {
            return View();
        }

        public ActionResult ConsultaPropiedadesUsuario()
        {
            return View();
        }

        public ActionResult ConsultaUsuariosPropiedad()
        {
            return View();
        }

        public ActionResult CreatePersona()
        {
            return View();
        }

        public ActionResult EditPersona(int id)
        {
            return View();
        }

        public ActionResult DeletePersona(int id)
        {
            return View();
        }

        public ActionResult DetailsPersona(int id)
        {
            return View();
        }

        public ActionResult CreatePropiedad()
        {
            return View();
        }

        public ActionResult EditPropiedad(int id)
        {
            return View();
        }

        public ActionResult DeletePropiedad(int id)
        {
            return View();
        }

        public ActionResult DetailsPropiedad(int id)
        {
            return View();
        }

        public ActionResult CreateUsuario()
        {
            return View();
        }

        public ActionResult EditUsuario(int id)
        {
            return View();
        }

        public ActionResult DeleteUsuario(int id)
        {
            return View();
        }

        public ActionResult DetailsUsuario(int id)
        {
            return View();
        }

        public ActionResult CreatePersonaPropiedad()
        {
            return View();
        }

        public ActionResult EditPersonaPropiedad(int id)
        {
            return View();
        }

        public ActionResult DeletePersonaPropiedad(int id)
        {
            return View();
        }

        public ActionResult DetailsPersonaPropiedad(int id)
        {
            return View();
        }

        public ActionResult CreateUsuarioPropiedad()
        {
            return View();
        }

        public ActionResult EditUsuarioPropiedad(int id)
        {
            return View();
        }

        public ActionResult DeleteUsuarioPropiedad(int id)
        {
            return View();
        }

        public ActionResult DetailsUsuarioPropiedad(int id)
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

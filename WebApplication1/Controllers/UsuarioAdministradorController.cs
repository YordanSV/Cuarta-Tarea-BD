using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore.SqlServer.Query.Internal;
using System.Collections.Generic;
using System.Data;

namespace WebApplication1.Controllers
{
    public class UsuarioAdministradorController : Controller
    {
        DataTable dt = new DataTable();
        SqlConnection con = new SqlConnection("Data Source=JPBR66\\SQLEXPRESS;" +
                "Initial Catalog=SegundaTarea;Integrated Security=SSPI");
        SqlCommand cmd = new SqlCommand();
        int outResult = 0;
        // GET: HomeController1
        public ActionResult Persona()
        {
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

        public ActionResult ConsultaPropiedadesPropietario(string ident)
        {
            cmd.Connection = con;
            cmd.CommandText = "proc_consultaPropiedadesPropietario";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            if (int.TryParse(ident, out int id))
            {
                cmd.Parameters.AddWithValue("@inNombre", "");
                cmd.Parameters.AddWithValue("@inIdent", id);
            }
            else
            {
                cmd.Parameters.AddWithValue("@inNombre", ident);
                cmd.Parameters.AddWithValue("@inIdent", 0);
            }
            cmd.Parameters.AddWithValue("@outResult", outResult);
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable dt = new DataTable();
            da.Fill(dt);
            con.Close();
            return View(dt);
        }

        public ActionResult ConsultaPropietarioPropiedad(int numFinca)
        {
            cmd.Connection = con;
            cmd.CommandText = "proc_consultaPropietarioPropiedad";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            cmd.Parameters.AddWithValue("@inNumFinca", numFinca);
            cmd.Parameters.AddWithValue("@outResult", outResult);
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable dt = new DataTable();
            da.Fill(dt);
            con.Close();
            return View(dt);
        }

        public ActionResult ConsultaPropiedadesUsuario(string nombre)
        {
            cmd.Connection = con;
            cmd.CommandText = "proc_consultaPropiedadesUsuario";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            cmd.Parameters.AddWithValue("@inNombre", nombre);
            cmd.Parameters.AddWithValue("@outResult", outResult);
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable dt = new DataTable();
            da.Fill(dt);
            con.Close();
            return View(dt);
        }

        public ActionResult ConsultaUsuariosPropiedad(int numFinca)
        {
            cmd.Connection = con;
            cmd.CommandText = "proc_consultaUsuariosPropiedad";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            cmd.Parameters.AddWithValue("@inNumFinca", numFinca);
            cmd.Parameters.AddWithValue("@outResult", outResult);
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable dt = new DataTable();
            da.Fill(dt);
            con.Close();
            return View(dt);
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

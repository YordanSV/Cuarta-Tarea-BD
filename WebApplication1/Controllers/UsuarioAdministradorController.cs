using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore.SqlServer.Query.Internal;
using System.Collections.Generic;
using System.Data;
using WebApplication1.Models;

namespace WebApplication1.Controllers
{
    public class UsuarioAdministradorController : Controller
    {
        DataTable dt = new DataTable();
        SqlConnection con = new SqlConnection("Data Source=JPBR66\\SQLEXPRESS;" +
                "Initial Catalog=SegundaTarea;Integrated Security=SSPI");
        int outResult = 0;
        // GET: HomeController1
        public ActionResult Persona()
        {
            outResult = 0;
            SqlCommand cmd = new SqlCommand();
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
            outResult = 0;
            SqlCommand cmd = new SqlCommand();
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
            outResult = 0;
            SqlCommand cmd = new SqlCommand();
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
            outResult = 0;
            SqlCommand cmd = new SqlCommand();
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
            outResult = 0;
            SqlCommand cmd = new SqlCommand();
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
            SqlCommand cmd = new SqlCommand();
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
            SqlCommand cmd = new SqlCommand();
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
            SqlCommand cmd = new SqlCommand();
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
            SqlCommand cmd = new SqlCommand();
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
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "proc_obtenerTiposDocId";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            SqlParameter retorno = cmd.Parameters.Add("@outResult", SqlDbType.Int);
            retorno.Direction = ParameterDirection.Output;
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable dt = new DataTable();
            da.Fill(dt);
            con.Close();

            if (outResult == 50007)
                ViewData["ErrorData"] = "Error al insertar a la persona";
            else if (outResult == 50008)
                ViewData["ErrorData"] = "La persona ya existe";
            return View(dt);
        }

        [HttpPost]
        public ActionResult CreatePersona(string nombre, int valorDocId, string tipoDocId, string email, int telefono1, int telefono2)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "proc_insertarPersona";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            cmd.Parameters.AddWithValue("@inNombre", nombre);
            cmd.Parameters.AddWithValue("@inValorDocId", valorDocId);
            cmd.Parameters.AddWithValue("@inTipoDoc", tipoDocId);
            cmd.Parameters.AddWithValue("@inEmail", email);
            cmd.Parameters.AddWithValue("@inTele1", telefono1);
            cmd.Parameters.AddWithValue("@inTele2", telefono2);
            SqlParameter retorno = cmd.Parameters.Add("@outResult", SqlDbType.Int);
            retorno.Direction = ParameterDirection.Output;
            cmd.ExecuteNonQuery();
            con.Close();

            outResult = (int)retorno.Value;
            if (outResult != 50007 && outResult != 50008)
                return RedirectToAction("Persona");
            return CreatePersona();
        }

        public ActionResult EditPersona(int id)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "proc_obtenerTiposDocId";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            SqlParameter retorno = cmd.Parameters.Add("@outResult", SqlDbType.Int);
            retorno.Direction = ParameterDirection.Output;
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable dt = new DataTable();
            da.Fill(dt);
            con.Close();

            if (outResult == 50007)
                ViewData["ErrorData"] = "Error al editar a la persona";
            else if (outResult == 50008)
                ViewData["ErrorData"] = "La persona ya existe";
            return View(dt);
        }

        // POST: HomeController1/Edit/5
        [HttpPost]
        public ActionResult EditPersona(int id, string nombre, int valorDocId, string tipoDocId, string email, int telefono1, int telefono2)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "proc_editarPersona";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            cmd.Parameters.AddWithValue("@inId", id);
            cmd.Parameters.AddWithValue("@inNombre", nombre);
            cmd.Parameters.AddWithValue("@inValorDocId", valorDocId);
            cmd.Parameters.AddWithValue("@inTipoDoc", tipoDocId);
            cmd.Parameters.AddWithValue("@inEmail", email);
            cmd.Parameters.AddWithValue("@inTele1", telefono1);
            cmd.Parameters.AddWithValue("@inTele2", telefono2);
            SqlParameter retorno = cmd.Parameters.Add("@outResult", SqlDbType.Int);
            retorno.Direction = ParameterDirection.Output;
            cmd.ExecuteNonQuery();
            con.Close();

            outResult = (int)retorno.Value;
            if (outResult != 50007 && outResult != 50008)
                return RedirectToAction("Persona");
            return EditPersona(id);
        }

        public ActionResult DeletePersona(int id)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "proc_detallesPersona";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            cmd.Parameters.AddWithValue("@inId", id);
            SqlParameter retorno = cmd.Parameters.Add("@outResult", SqlDbType.Int);
            retorno.Direction = ParameterDirection.Output;
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable dt = new DataTable();
            da.Fill(dt);
            con.Close();

            if (outResult == 50007)
                ViewData["ErrorData"] = "Error al eliminar a la persona";
            return View(dt);
        }

        [HttpPost]
        public ActionResult DeletePersona(int id, int nada)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "proc_eliminarPersona";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            cmd.Parameters.AddWithValue("@inId", id);
            SqlParameter retorno = cmd.Parameters.Add("@outResult", SqlDbType.Int);
            retorno.Direction = ParameterDirection.Output;
            cmd.ExecuteNonQuery();
            con.Close();

            outResult = (int)retorno.Value;
            if (outResult != 50007)
                return RedirectToAction("Persona");
            return DeletePersona(id);
        }

        public ActionResult DetailsPersona(int id)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "proc_detallesPersona";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            cmd.Parameters.AddWithValue("@inId", id);
            SqlParameter retorno = cmd.Parameters.Add("@outResult", SqlDbType.Int);
            retorno.Direction = ParameterDirection.Output;
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable dt = new DataTable();
            da.Fill(dt);
            con.Close();

            return View(dt);
        }

        public ActionResult CreatePropiedad()
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "proc_obtenerTiposTerreno";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            SqlParameter retorno = cmd.Parameters.Add("@outResult", SqlDbType.Int);
            retorno.Direction = ParameterDirection.Output;
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable dtt = new DataTable();
            da.Fill(dtt);

            cmd.CommandText = "proc_obtenerTiposZona";
            cmd.CommandType = CommandType.StoredProcedure;
            DataTable dtz = new DataTable();
            da.Fill(dtz);
            con.Close();

            DataRow drw = dtt.NewRow();
            drw[0] = null;
            dtt.Rows.Add(drw);
            for (int i = 0; i < dtz.Rows.Count; i++)
            {
                DataRow dr = dtt.NewRow();
                dr[0] = dtz.Rows[i][0].ToString();
                dtt.Rows.Add(dr);
            }
            

            if (outResult == 50007)
                ViewData["ErrorData"] = "Error al insertar la propiedad";
            else if (outResult == 50008)
                ViewData["ErrorData"] = "El numero de finca ya existe";
            return View(dtt);
        }

        [HttpPost]
        public ActionResult CreatePropiedad(int numFinca, float area, string valor, string tipoTerreno, string tipoZona)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "proc_insertarPropiedad";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            cmd.Parameters.AddWithValue("@inNumFinca", numFinca);
            cmd.Parameters.AddWithValue("@inArea", area);
            cmd.Parameters.AddWithValue("@inValor", valor);
            cmd.Parameters.AddWithValue("@inTipoTerreno", tipoTerreno);
            cmd.Parameters.AddWithValue("@inTipoZona", tipoZona);
            SqlParameter retorno = cmd.Parameters.Add("@outResult", SqlDbType.Int);
            retorno.Direction = ParameterDirection.Output;
            cmd.ExecuteNonQuery();
            con.Close();

            outResult = (int)retorno.Value;
            if (outResult != 50007 && outResult != 50008)
                return RedirectToAction("Propiedad");
            return CreatePropiedad();
        }

        public ActionResult EditPropiedad(int id)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "proc_obtenerTiposTerreno";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            SqlParameter retorno = cmd.Parameters.Add("@outResult", SqlDbType.Int);
            retorno.Direction = ParameterDirection.Output;
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable dtt = new DataTable();
            da.Fill(dtt);

            cmd.CommandText = "proc_obtenerTiposZona";
            cmd.CommandType = CommandType.StoredProcedure;
            DataTable dtz = new DataTable();
            da.Fill(dtz);
            con.Close();

            DataRow drw = dtt.NewRow();
            drw[0] = null;
            dtt.Rows.Add(drw);
            for (int i = 0; i < dtz.Rows.Count; i++)
            {
                DataRow dr = dtt.NewRow();
                dr[0] = dtz.Rows[i][0].ToString();
                dtt.Rows.Add(dr);
            }


            if (outResult == 50007)
                ViewData["ErrorData"] = "Error al editar la propiedad";
            else if (outResult == 50008)
                ViewData["ErrorData"] = "El numero de finca ya existe";
            return View(dtt);
        }

        [HttpPost]
        public ActionResult EditPropiedad(int id, int numFinca, float area, string valor, string tipoTerreno, string tipoZona)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "proc_editarPropiedad";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            cmd.Parameters.AddWithValue("@inId", id);
            cmd.Parameters.AddWithValue("@inNumFinca", numFinca);
            cmd.Parameters.AddWithValue("@inArea", area);
            cmd.Parameters.AddWithValue("@inValor", valor);
            cmd.Parameters.AddWithValue("@inTipoTerreno", tipoTerreno);
            cmd.Parameters.AddWithValue("@inTipoZona", tipoZona);
            SqlParameter retorno = cmd.Parameters.Add("@outResult", SqlDbType.Int);
            retorno.Direction = ParameterDirection.Output;
            cmd.ExecuteNonQuery();
            con.Close();

            outResult = (int)retorno.Value;
            if (outResult != 50007 && outResult != 50008)
                return RedirectToAction("Propiedad");
            return EditPersona(id);
        }

        public ActionResult DeletePropiedad(int id)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "proc_detallesPropiedad";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            cmd.Parameters.AddWithValue("@inId", id);
            SqlParameter retorno = cmd.Parameters.Add("@outResult", SqlDbType.Int);
            retorno.Direction = ParameterDirection.Output;
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable dt = new DataTable();
            da.Fill(dt);
            con.Close();

            if (outResult == 50007)
                ViewData["ErrorData"] = "Error al eliminar a la persona";
            return View(dt);
        }

        [HttpPost]
        public ActionResult DeletePropiedad(int id, int nada)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "proc_eliminarPropiedad";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            cmd.Parameters.AddWithValue("@inId", id);
            SqlParameter retorno = cmd.Parameters.Add("@outResult", SqlDbType.Int);
            retorno.Direction = ParameterDirection.Output;
            cmd.ExecuteNonQuery();
            con.Close();

            outResult = (int)retorno.Value;
            if (outResult != 50007)
                return RedirectToAction("Propiedad");
            return DeletePersona(id);
        }

        public ActionResult DetailsPropiedad(int id)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "proc_detallesPropiedad";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            cmd.Parameters.AddWithValue("@inId", id);
            SqlParameter retorno = cmd.Parameters.Add("@outResult", SqlDbType.Int);
            retorno.Direction = ParameterDirection.Output;
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable dt = new DataTable();
            da.Fill(dt);
            con.Close();

            return View(dt);
        }

        public ActionResult CreateUsuario()
        {
            if (outResult == 50007)
                ViewData["ErrorData"] = "Error al insertar el usuario";
            else if (outResult == 50008)
                ViewData["ErrorData"] = "El valor de documento de id no existe";
            else if (outResult == 50009)
                ViewData["ErrorData"] = "Ya existe un usuario asociado a esta persona";
            else if (outResult == 50010)
                ViewData["ErrorData"] = "El username ya esta en uso";
            return View();
        }

        [HttpPost]
        public ActionResult CreateUsuario(string username, string password, string tipoUsuario, int valoDocId)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "proc_insertarUsuario";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            cmd.Parameters.AddWithValue("@inUserName", username);
            cmd.Parameters.AddWithValue("@inPassword", password);
            cmd.Parameters.AddWithValue("@inTipoUsuario", tipoUsuario);
            cmd.Parameters.AddWithValue("@inValorDocId", valoDocId);
            SqlParameter retorno = cmd.Parameters.Add("@outResult", SqlDbType.Int);
            retorno.Direction = ParameterDirection.Output;
            cmd.ExecuteNonQuery();
            con.Close();

            outResult = (int)retorno.Value;
            if (outResult == 0)
                return RedirectToAction("Usuario");
            return CreateUsuario();
        }

        public ActionResult EditUsuario(int id)
        {
            if (outResult == 50007)
                ViewData["ErrorData"] = "Error al editar el usuario";
            else if (outResult == 50008)
                ViewData["ErrorData"] = "El valor de documento de id no existe";
            else if (outResult == 50009)
                ViewData["ErrorData"] = "Ya existe un usuario asociado a esta persona";
            else if (outResult == 50010)
                ViewData["ErrorData"] = "El username ya esta en uso";
            return View();
        }

        [HttpPost]
        public ActionResult EditUsuario(int id, string username, string password, string tipoUsuario, int valoDocId)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "proc_editarUsuario";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            cmd.Parameters.AddWithValue("@inId", id);
            cmd.Parameters.AddWithValue("@inUserName", username);
            cmd.Parameters.AddWithValue("@inPassword", password);
            cmd.Parameters.AddWithValue("@inTipoUsuario", tipoUsuario);
            cmd.Parameters.AddWithValue("@inValorDocId", valoDocId);
            SqlParameter retorno = cmd.Parameters.Add("@outResult", SqlDbType.Int);
            retorno.Direction = ParameterDirection.Output;
            cmd.ExecuteNonQuery();
            con.Close();

            outResult = (int)retorno.Value;
            if (outResult == 0)
                return RedirectToAction("Usuario");
            return EditUsuario(id);
        }

        public ActionResult DeleteUsuario(int id)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "proc_detallesUsuario";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            cmd.Parameters.AddWithValue("@inId", id);
            SqlParameter retorno = cmd.Parameters.Add("@outResult", SqlDbType.Int);
            retorno.Direction = ParameterDirection.Output;
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable dt = new DataTable();
            da.Fill(dt);
            con.Close();

            if (outResult == 50007)
                ViewData["ErrorData"] = "Error al eliminar al usuario";
            return View(dt);
        }

        [HttpPost]
        public ActionResult DeleteUsuario(int id, int nada)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "proc_eliminarUsuario";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            cmd.Parameters.AddWithValue("@inId", id);
            SqlParameter retorno = cmd.Parameters.Add("@outResult", SqlDbType.Int);
            retorno.Direction = ParameterDirection.Output;
            cmd.ExecuteNonQuery();
            con.Close();

            outResult = (int)retorno.Value;
            if (outResult != 50007)
                return RedirectToAction("Usuario");
            return DeleteUsuario(id);
        }

        public ActionResult DetailsUsuario(int id)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "proc_detallesUsuario";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            cmd.Parameters.AddWithValue("@inId", id);
            SqlParameter retorno = cmd.Parameters.Add("@outResult", SqlDbType.Int);
            retorno.Direction = ParameterDirection.Output;
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable dt = new DataTable();
            da.Fill(dt);
            con.Close();

            return View(dt);
        }

        public ActionResult CreatePersonaPropiedad()
        {
            if (outResult == 50007)
                ViewData["ErrorData"] = "Error al asociar la persona con la propiedad";
            else if (outResult == 50008)
                ViewData["ErrorData"] = "EL valor de documento de identidad no se encuentra registrado";
            else if (outResult == 50009)
                ViewData["ErrorData"] = "El numero de finca no se encuentra registrado";
            else if (outResult == 50010)
                ViewData["ErrorData"] = "Ya existe una asociación vigente entre la persona y la propiedad dados";
            return View();
        }

        [HttpPost]
        public ActionResult CreatePersonaPropiedad(int valorDocId, int numFinca)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "proc_insertarPersonaPropiedad";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            cmd.Parameters.AddWithValue("@inValorDocId", valorDocId);
            cmd.Parameters.AddWithValue("@inNumFinca", numFinca);
            SqlParameter retorno = cmd.Parameters.Add("@outResult", SqlDbType.Int);
            retorno.Direction = ParameterDirection.Output;
            cmd.ExecuteNonQuery();
            con.Close();

            outResult = (int)retorno.Value;
            if (outResult == 0)
                return RedirectToAction("PersonaPropiedad");
            return CreatePersonaPropiedad();
        }

        public ActionResult EditPersonaPropiedad(int id)
        {
            if (outResult == 50007)
                ViewData["ErrorData"] = "Error al asociar la persona con la propiedad";
            else if (outResult == 50008)
                ViewData["ErrorData"] = "Ya existe una asociación vigente entre la persona y la propiedad dados";
            return View();
        }

        [HttpPost]
        public ActionResult EditPersonaPropiedad(int id, int valorDocId, int numFinca)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "proc_editarPersonaPropiedad";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            cmd.Parameters.AddWithValue("@inId", id);
            cmd.Parameters.AddWithValue("@inValorDocId", valorDocId);
            cmd.Parameters.AddWithValue("@inNumFinca", numFinca);
            SqlParameter retorno = cmd.Parameters.Add("@outResult", SqlDbType.Int);
            retorno.Direction = ParameterDirection.Output;
            cmd.ExecuteNonQuery();
            con.Close();

            outResult = (int)retorno.Value;
            if (outResult == 0)
                return RedirectToAction("PersonaPropiedad");
            return EditPersonaPropiedad(id);
        }

        public ActionResult DesasociarPersonaPropiedad(int id)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "proc_detallesPersonaPropiedad";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            cmd.Parameters.AddWithValue("@inId", id);
            SqlParameter retorno = cmd.Parameters.Add("@outResult", SqlDbType.Int);
            retorno.Direction = ParameterDirection.Output;
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable dt = new DataTable();
            da.Fill(dt);
            con.Close();

            if (outResult == 50007)
                ViewData["ErrorData"] = "Error al desasociar la persona con la propiedad";
            return View(dt);
        }

        [HttpPost]
        public ActionResult DesasociarPersonaPropiedad(int id, int nada)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "proc_desasociarPersonaPropiedad";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            cmd.Parameters.AddWithValue("@inId", id);
            SqlParameter retorno = cmd.Parameters.Add("@outResult", SqlDbType.Int);
            retorno.Direction = ParameterDirection.Output;
            cmd.ExecuteNonQuery();
            con.Close();

            outResult = (int)retorno.Value;
            if (outResult == 0)
                return RedirectToAction("PersonaPropiedad");
            return DeletePersonaPropiedad(id);
        }

        public ActionResult DeletePersonaPropiedad(int id)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "proc_detallesPersonaPropiedad";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            cmd.Parameters.AddWithValue("@inId", id);
            SqlParameter retorno = cmd.Parameters.Add("@outResult", SqlDbType.Int);
            retorno.Direction = ParameterDirection.Output;
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable dt = new DataTable();
            da.Fill(dt);
            con.Close();

            if (outResult == 50007)
                ViewData["ErrorData"] = "Error al borrar la persona con la propiedad";
            return View(dt);
        }

        [HttpPost]
        public ActionResult DeletePersonaPropiedad(int id, int nada)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "proc_eliminarPersonaPropiedad";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            cmd.Parameters.AddWithValue("@inId", id);
            SqlParameter retorno = cmd.Parameters.Add("@outResult", SqlDbType.Int);
            retorno.Direction = ParameterDirection.Output;
            cmd.ExecuteNonQuery();
            con.Close();

            outResult = (int)retorno.Value;
            if (outResult == 0)
                return RedirectToAction("PersonaPropiedad");
            return DeletePersonaPropiedad(id);
        }

        public ActionResult DetailsPersonaPropiedad(int id)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "proc_detallesPersonaPropiedad";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            cmd.Parameters.AddWithValue("@inId", id);
            SqlParameter retorno = cmd.Parameters.Add("@outResult", SqlDbType.Int);
            retorno.Direction = ParameterDirection.Output;
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable dt = new DataTable();
            da.Fill(dt);
            con.Close();

            return View(dt);
        }

        public ActionResult CreateUsuarioPropiedad()
        {
            if (outResult == 50007)
                ViewData["ErrorData"] = "Error al asociar al usuario con la propiedad";
            else if (outResult == 50008)
                ViewData["ErrorData"] = "EL valor de documento de identidad no se encuentra registrado";
            else if (outResult == 50009)
                ViewData["ErrorData"] = "El numero de finca no se encuentra registrado";
            else if (outResult == 50010)
                ViewData["ErrorData"] = "Ya existe una asociación vigente en la propiedad dada";
            return View();
        }

        [HttpPost]
        public ActionResult CreateUsuarioPropiedad(int valorDocId, int numFinca)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "proc_insertarUsuarioPropiedad";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            cmd.Parameters.AddWithValue("@inValorDocId", valorDocId);
            cmd.Parameters.AddWithValue("@inNumFinca", numFinca);
            SqlParameter retorno = cmd.Parameters.Add("@outResult", SqlDbType.Int);
            retorno.Direction = ParameterDirection.Output;
            cmd.ExecuteNonQuery();
            con.Close();

            outResult = (int)retorno.Value;
            if (outResult == 0)
                return RedirectToAction("UsuarioPropiedad");
            return CreateUsuarioPropiedad();
        }

        public ActionResult EditUsuarioPropiedad(int id)
        {
            if (outResult == 50007)
                ViewData["ErrorData"] = "Error al asociar al usuario con la propiedad";
            else if (outResult == 50008)
                ViewData["ErrorData"] = "EL valor de documento de identidad no se encuentra registrado";
            else if (outResult == 50009)
                ViewData["ErrorData"] = "El numero de finca no se encuentra registrado";
            else if (outResult == 50010)
                ViewData["ErrorData"] = "Ya existe una asociación vigente en la propiedad dada";
            return View();
        }

        [HttpPost]
        public ActionResult EditUsuarioPropiedad(int id, int valorDocId, int numFinca)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "proc_editarUsuarioPropiedad";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            cmd.Parameters.AddWithValue("@inId", id);
            cmd.Parameters.AddWithValue("@inValorDocId", valorDocId);
            cmd.Parameters.AddWithValue("@inNumFinca", numFinca);
            SqlParameter retorno = cmd.Parameters.Add("@outResult", SqlDbType.Int);
            retorno.Direction = ParameterDirection.Output;
            cmd.ExecuteNonQuery();
            con.Close();

            outResult = (int)retorno.Value;
            if (outResult == 0)
                return RedirectToAction("UsuarioPropiedad");
            return EditUsuarioPropiedad(id);
        }

        public ActionResult DesasociarUsuarioPropiedad(int id)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "proc_detallesUsuarioPropiedad";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            cmd.Parameters.AddWithValue("@inId", id);
            SqlParameter retorno = cmd.Parameters.Add("@outResult", SqlDbType.Int);
            retorno.Direction = ParameterDirection.Output;
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable dt = new DataTable();
            da.Fill(dt);
            con.Close();

            if (outResult == 50007)
                ViewData["ErrorData"] = "Error al desasociar al usuario con la propiedad";
            return View(dt);
        }

        [HttpPost]
        public ActionResult DesasociarUsuarioPropiedad(int id, int nada)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "proc_desasociarUsuarioPropiedad";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            cmd.Parameters.AddWithValue("@inId", id);
            SqlParameter retorno = cmd.Parameters.Add("@outResult", SqlDbType.Int);
            retorno.Direction = ParameterDirection.Output;
            cmd.ExecuteNonQuery();
            con.Close();

            outResult = (int)retorno.Value;
            if (outResult == 0)
                return RedirectToAction("UsuarioPropiedad");
            return DeletePersonaPropiedad(id);
        }

        public ActionResult DetailsUsuarioPropiedad(int id)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "proc_detallesUsuarioPropiedad";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            cmd.Parameters.AddWithValue("@inId", id);
            SqlParameter retorno = cmd.Parameters.Add("@outResult", SqlDbType.Int);
            retorno.Direction = ParameterDirection.Output;
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable dt = new DataTable();
            da.Fill(dt);
            con.Close();

            return View(dt);
        }
    }
}

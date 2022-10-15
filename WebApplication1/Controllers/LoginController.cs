using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using WebApplication1.Data;
using WebApplication1.Models;

namespace WebApplication1.Controllers
{
    public class LoginController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }

        public async Task<IActionResult> Ingresar([Bind("id,Nombre,Clave")] Usuario usuario)
        {
            if (ModelState.IsValid)
            {
                SqlConnection con = new SqlConnection("Data Source=JPBR66\\SQLEXPRESS;" +
                    "Initial Catalog=SegundaTarea;Integrated Security=SSPI");
                SqlCommand cmd = new SqlCommand();
                int result = 0;
                cmd.Connection = con;
                cmd.CommandText = "proc_loginUsuario";
                cmd.CommandType = CommandType.StoredProcedure;

                con.Open();
                cmd.Parameters.AddWithValue("@inNombre", usuario.Nombre);
                cmd.Parameters.AddWithValue("@inClave", usuario.Clave);
                SqlParameter retorno = cmd.Parameters.Add("@outResult", SqlDbType.Int);
                retorno.Direction = ParameterDirection.Output;
                cmd.ExecuteNonQuery();
                con.Close();

                result = (int)retorno.Value;
                if (result == 6000)
                    ViewData["CI"] = "Combinación de usuario/password no existe en la BD";
                if (result == 1)
                {
                    
                    //View("Persona", usuario.Nombre);
                    return RedirectToAction("Persona", "UsuarioAdministrador");
                }
                if (result == 2)
                {
                    return RedirectToAction("Index", "UsuarioNoAdministrador", new { user = usuario.Nombre });
                }
            }
            return View("Index");
        }
    }
}

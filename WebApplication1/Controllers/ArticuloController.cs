using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using WebApplication1.Data;
using WebApplication1.Models;

namespace WebApplication1.Controllers
{
    public class ArticuloController : Controller
    {
        private readonly ApplicationDbContext _context;

        public ArticuloController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: Articulo
        public async Task<IActionResult> Index(string nombre)
        {
            if (nombre == null)
                nombre = "";
            DataTable dt = FiltrarNombre(nombre);

            SqlConnection con = new SqlConnection("Data Source=JPBR66\\SQLEXPRESS;" +
                "Initial Catalog=PrimerTarea;Integrated Security=SSPI");
            SqlCommand cmd = new SqlCommand();

            cmd.Connection = con;
            cmd.CommandText = "proc_obtenerClases";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable dtClases = new DataTable();
            da.Fill(dtClases);
            con.Close();

            for (int i = 0; i < dtClases.Rows.Count; i++)
            {
                DataRow dr = dt.NewRow();
                dr[0] = 0;
                dr[1] = dtClases.Rows[i][0].ToString();
                dr[2] = null;
                dr[3] = 0;
                dt.Rows.Add(dr);
            }

            return View(dt);
        }

        public async Task<IActionResult> filtCant(int cantidad)
        {
            DataTable dt = FiltrarCantidad(cantidad);

            SqlConnection con = new SqlConnection("Data Source=JPBR66\\SQLEXPRESS;" +
                "Initial Catalog=PrimerTarea;Integrated Security=SSPI");
            SqlCommand cmd = new SqlCommand();

            cmd.Connection = con;
            cmd.CommandText = "proc_obtenerClases";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable dtClases = new DataTable();
            da.Fill(dtClases);
            con.Close();

            for (int i = 0; i < dtClases.Rows.Count; i++)
            {
                DataRow dr = dt.NewRow();
                dr[0] = 0;
                dr[1] = dtClases.Rows[i][0].ToString();
                dr[2] = null;
                dr[3] = 0;
                dt.Rows.Add(dr);
            }

            return View("Index", dt);
        }

        public async Task<IActionResult> filtClase(string clase)
        {
            DataTable dt = FiltrarClase(clase);

            SqlConnection con = new SqlConnection("Data Source=JPBR66\\SQLEXPRESS;" +
                "Initial Catalog=PrimerTarea;Integrated Security=SSPI");
            SqlCommand cmd = new SqlCommand();

            cmd.Connection = con;
            cmd.CommandText = "proc_obtenerClases";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable dtClases = new DataTable();
            da.Fill(dtClases);
            con.Close();

            for (int i = 0; i < dtClases.Rows.Count; i++)
            {
                DataRow dr = dt.NewRow();
                dr[0] = 0;
                dr[1] = dtClases.Rows[i][0].ToString();
                dr[2] = null;
                dr[3] = 0;
                dt.Rows.Add(dr);
            }

            return View("Index", dt);
        }

        // GET: Articulo/Create
        public async Task<IActionResult> Create()
        {
            SqlConnection con = new SqlConnection("Data Source=JPBR66\\SQLEXPRESS;" +
                    "Initial Catalog=PrimerTarea;Integrated Security=SSPI");
            SqlCommand cmd = new SqlCommand();
            SqlDataAdapter da = new SqlDataAdapter();
            DataTable dt = new DataTable();

            cmd.Connection = con;
            cmd.CommandText = "proc_obtenerClases";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            da.SelectCommand = cmd;
            da.Fill(dt);
            con.Close();

            return View(dt);
        }

        // POST: Articulo/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(string clase, string nombre, double precio)
        {
            SqlConnection con = new SqlConnection("Data Source=JPBR66\\SQLEXPRESS;" +
                "Initial Catalog=PrimerTarea;Integrated Security=SSPI");
            SqlCommand cmd = new SqlCommand();
            SqlCommand cmd2 = new SqlCommand();
            SqlDataAdapter da = new SqlDataAdapter();
            DataTable dt = new DataTable();
            int result = 0;

            cmd.Connection = con;
            cmd.CommandText = "proc_insertarArticulo";
            cmd.CommandType = CommandType.StoredProcedure;
            cmd2.Connection = con;
            cmd2.CommandText = "proc_obtenerClases";
            cmd2.CommandType = CommandType.StoredProcedure;


            con.Open();
            cmd.Parameters.AddWithValue("@Nombre", nombre);
            cmd.Parameters.AddWithValue("@ClaseArticulo", clase);
            cmd.Parameters.AddWithValue("@Precio", precio);
            SqlParameter retorno = cmd.Parameters.Add("@outResult", SqlDbType.Int);
            retorno.Direction = ParameterDirection.Output;
            cmd.ExecuteNonQuery();
            
            da.SelectCommand = cmd2;
            da.Fill(dt);
            con.Close();

            result = (int)retorno.Value;
            if (result == 6000)
                ViewData["AI"] = "Articulo con nombre duplicado";
            else
                return RedirectToAction("Index", "Articulo");

            return View(dt);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public DataTable FiltrarNombre(string nombre)
        {
            SqlConnection con = new SqlConnection("Data Source=JPBR66\\SQLEXPRESS;" +
                "Initial Catalog=PrimerTarea;Integrated Security=SSPI");
            SqlCommand cmd = new SqlCommand();

            cmd.Connection = con;
            cmd.CommandText = "proc_filtrarNombre";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            cmd.Parameters.AddWithValue("@Nombre", nombre);
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable dt = new DataTable();
            da.Fill(dt);
            con.Close();

            return dt;
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public DataTable FiltrarCantidad(int cantidad)
        {
            
            
            SqlConnection con = new SqlConnection("Data Source=JPBR66\\SQLEXPRESS;" +
                "Initial Catalog=PrimerTarea;Integrated Security=SSPI");
            SqlCommand cmd = new SqlCommand();

            cmd.Connection = con;
            cmd.CommandText = "proc_filtrarCantidad";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            cmd.Parameters.AddWithValue("@Cantidad", cantidad);
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable dt = new DataTable();
            da.Fill(dt);
            con.Close();
            
            return dt;
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public DataTable FiltrarClase(string clase)
        {
            SqlConnection con = new SqlConnection("Data Source=JPBR66\\SQLEXPRESS;" +
                "Initial Catalog=PrimerTarea;Integrated Security=SSPI");
            SqlCommand cmd = new SqlCommand();

            cmd.Connection = con;
            cmd.CommandText = "proc_filtrarClase";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            cmd.Parameters.AddWithValue("@Clase", clase);
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable dt = new DataTable();
            da.Fill(dt);
            con.Close();

            return dt;
        }
    }
}

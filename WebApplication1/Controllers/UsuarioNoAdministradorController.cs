using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using System.Data;
using System.Drawing;
using System.Threading.Tasks;
using WebApplication1.Data;

namespace WebApplication1.Controllers
{
    public class UsuarioNoAdministradorController : Controller
    {
        private readonly ApplicationDbContext _context;
        private static string userName;
        private static int propiedad = 0;
        public UsuarioNoAdministradorController(ApplicationDbContext context)
        {
            _context = context;
        }
        // GET: HomeController1
        public ActionResult Index(string user)
        {
            SqlConnection con = new SqlConnection("Data Source=JPBR66\\SQLEXPRESS;" +
                "Initial Catalog=CuartaTarea;Integrated Security=SSPI");
            SqlCommand cmd = new SqlCommand();
            if (user != null)
                userName = user;
            int outResult = 0;

            cmd.Connection = con;
            cmd.CommandText = "proc_propiedadesPropietario";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            cmd.Parameters.AddWithValue("@inUser", userName);
            cmd.Parameters.AddWithValue("@outResult", outResult);
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable dt = new DataTable();
            da.Fill(dt);
            con.Close();
            return View(dt);
        }

        // GET: HomeController1/Details/5
        public ActionResult Lecturas(int id)
        {
            SqlConnection con = new SqlConnection("Data Source=JPBR66\\SQLEXPRESS;" +
                "Initial Catalog=CuartaTarea;Integrated Security=SSPI");
            int outResult = 0;

            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "proc_consultaMovConsumoPropiedad";
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
            propiedad = 0;
            return View(dt);
        }

        public ActionResult FacturasPendientes(int id)
        {
            SqlConnection con = new SqlConnection("Data Source=JPBR66\\SQLEXPRESS;" +
                "Initial Catalog=CuartaTarea;Integrated Security=SSPI");
            int outResult = 0;
            if (propiedad == 0)
                propiedad = id;

            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "proc_factPendientes";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            cmd.Parameters.AddWithValue("@inId", propiedad);
            SqlParameter retorno = cmd.Parameters.Add("@outResult", SqlDbType.Int);
            retorno.Direction = ParameterDirection.Output;
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable dt = new DataTable();
            da.Fill(dt);
            con.Close();
            propiedad = 0;

            return View(dt);
        }

        public ActionResult FacturasPagadas(int id)
        {
            SqlConnection con = new SqlConnection("Data Source=JPBR66\\SQLEXPRESS;" +
                "Initial Catalog=CuartaTarea;Integrated Security=SSPI");
            int outResult = 0;
            if (propiedad != 0)
                id = propiedad;

            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "proc_factPagadas";
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
            propiedad = 0;

            return View(dt);
        }

        public ActionResult Comprobante(int id)
        {
            SqlConnection con = new SqlConnection("Data Source=JPBR66\\SQLEXPRESS;" +
                "Initial Catalog=CuartaTarea;Integrated Security=SSPI");
            int outResult = 0;

            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "proc_comprobantePago";
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

        public ActionResult Pagar()
        {
            SqlConnection con = new SqlConnection("Data Source=JPBR66\\SQLEXPRESS;" +
                "Initial Catalog=CuartaTarea;Integrated Security=SSPI");
            int outResult = 0;

            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "proc_obtenerTiposPago";
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
                ViewData["ErrorData"] = "Error al pagar la factura";
            return View(dt);
        }

        [HttpPost]
        public ActionResult Pagar(int id, string tipoPago)
        {
            SqlConnection con = new SqlConnection("Data Source=JPBR66\\SQLEXPRESS;" +
                "Initial Catalog=CuartaTarea;Integrated Security=SSPI");
            int outResult = 0;

            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "proc_pagoFactura";
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            cmd.Parameters.AddWithValue("@inId", id);
            cmd.Parameters.AddWithValue("@inTipoPago", tipoPago);
            SqlParameter retorno = cmd.Parameters.Add("@outResult", SqlDbType.Int);
            retorno.Direction = ParameterDirection.Output;
            cmd.ExecuteNonQuery();
            con.Close();

            outResult = (int)retorno.Value;
            if (outResult != 50007)
                return RedirectToAction("FacturasPendientes");
            return Pagar();
        }
    }
}

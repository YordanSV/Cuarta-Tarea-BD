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
        public UsuarioNoAdministradorController(ApplicationDbContext context)
        {
            _context = context;
        }
        // GET: HomeController1
        public ActionResult Index(string user)
        {
            SqlConnection con = new SqlConnection("Data Source=JPBR66\\SQLEXPRESS;" +
                "Initial Catalog=SegundaTarea;Integrated Security=SSPI");
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
                "Initial Catalog=SegundaTarea;Integrated Security=SSPI");
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

            return View(dt);
        }
    }
}

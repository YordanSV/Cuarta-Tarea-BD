using Microsoft.EntityFrameworkCore;
using WebApplication1.Models;

namespace WebApplication1.Data
{
    public class ApplicationDbContext: DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
        {

        }
        public DbSet<WebApplication1.Models.Articulo> Articulo { get; set; }
        public DbSet<WebApplication1.Models.Usuario> Usuario { get; set; }
        public DbSet<WebApplication1.Models.ClaseArticulo> ClaseArticulo { get; set; }

    }
}

using System.ComponentModel.DataAnnotations;
using System.Data.SqlTypes;
using System.Security.Cryptography.X509Certificates;

namespace WebApplication1.Models
{
    public class ClaseArticulo
    {
        [Key]
        public int id { get; set; }

        [Required]
        [MaxLength(128)]
        public string Nombre { get; set; }
    }
}

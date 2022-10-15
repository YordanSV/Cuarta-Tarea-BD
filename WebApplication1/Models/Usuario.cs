using System.ComponentModel.DataAnnotations;
using System.Data.SqlTypes;
using System.Security.Cryptography.X509Certificates;

namespace WebApplication1.Models
{
    public class Usuario
    {

        [Key]
        public int id { get; set; }

        [Required]
        [MaxLength(32)]
        public string Nombre { get; set; }

        [Required]
        [MaxLength(32)]
        public string Clave { get; set; }
    }
}
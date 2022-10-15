using System.ComponentModel.DataAnnotations;
using System.Data.SqlTypes;
using System.Security.Cryptography.X509Certificates;

namespace WebApplication1.Models
{
    public class Articulo
    {
  
        [Key]
        public int id { get; set; }

        [Required]
        public int idClaseArticulo { get; set; }

        [Required]
        [MaxLength(100)]
        public string Nombre { get; set; }

        [Required]
        public decimal Precio { get; set; }


    }
}

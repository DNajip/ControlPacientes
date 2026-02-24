using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using ControlPacientes.Conection;

namespace ControlPacientes.Conection
{
    public static class ConexionBD
    {
        private static string cadena = @"Data Source=(localdb)\MSSQLLocalDB;
          Initial Catalog=ControlPacientes;
          Integrated Security=True;
          Encrypt=False;";

        public static SqlConnection ObtenerConexion()
        {
            return new SqlConnection(cadena);
        }
    }


}

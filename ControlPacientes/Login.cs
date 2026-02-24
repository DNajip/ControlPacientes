using ControlPacientes.Conection;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ControlPacientes
{
    public partial class Login : Form
    {
        public Login()
        {
            InitializeComponent();
            
        }


        private void label4_Click(object sender, EventArgs e)
        {

        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void btn_iniciar_Click(object sender, EventArgs e)
        {
            string correo = txtcorreo.Text.Trim();
            string password = txtpassword.Text.Trim();

            // =========================
            // VALIDACIONES DE CAMPOS
            // =========================

            if (string.IsNullOrWhiteSpace(correo) && string.IsNullOrWhiteSpace(password))
            {
                MessageBox.Show("Complete los campos.");
                return;
            }

            if (string.IsNullOrWhiteSpace(correo))
            {
                MessageBox.Show("Ingrese su correo.");
                return;
            }

            if (string.IsNullOrWhiteSpace(password))
            {
                MessageBox.Show("Ingrese su contraseña.");
                return;
            }

            // =========================
            // LOGIN BD
            // =========================

            try
            {
                using (SqlConnection cn = ConexionBD.ObtenerConexion())
                using (SqlCommand cmd = new SqlCommand("sp_login", cn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@email", correo);
                    cmd.Parameters.AddWithValue("@password", password);

                    cn.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            int resultado = Convert.ToInt32(dr["resultado"]);

                            switch (resultado)
                            {
                                case -1:
                                    MessageBox.Show("El correo no existe.");
                                    break;

                                case -2:
                                    MessageBox.Show("El usuario está inactivo.");
                                    break;

                                case -3:
                                    MessageBox.Show("Contraseña incorrecta.");
                                    break;

                                case 1:
                                    string rol = dr["desc_rol"].ToString();

                                    MessageBox.Show("Bienvenido");

                                    // Recordar usuario
                                    if (UsuarioGuardado.Checked)
                                    {
                                        Properties.Settings.Default.UsuarioGuardado = correo;
                                    }
                                    else
                                    {
                                        Properties.Settings.Default.UsuarioGuardado = "";
                                    }

                                    Properties.Settings.Default.Save();

                                    
                                    new Form1().Show();
                                    break;
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error: " + ex.Message);
            }
        }
    }
}

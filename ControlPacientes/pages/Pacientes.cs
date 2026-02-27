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

namespace ControlPacientes.pages
{
    public partial class Pacientes : Form
    {
        public Pacientes()
        {
            InitializeComponent();



            //A la barra de busqueda le pondremos la carga de la descripcion
            txtBuscar.Text = "Buscar por nombre, cédula o teléfono";
            txtBuscar.ForeColor = Color.Gray;





        }

        /*
        Para mantener el orden primero crearemos los metodos y luego los llamaremos en sus lugares correspondientes

        */

        private void CargarPacientes()
        {

            try
            {
                using (SqlConnection cn = ConexionBD.ObtenerConexion())
                {
                    cn.Open();

                    using (SqlCommand cmd = new SqlCommand("sp_pacientes_listar", cn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;

                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        dataPacientes.DataSource = dt;
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error cargando pacientes: " + ex.Message);
            }
            //using (SqlConnection cn = ConexionBD.ObtenerConexion()) {
            //    using (SqlCommand cmd = new SqlCommand("sp_pacientes_listar", cn))
            //    {
            //        cmd.CommandType = CommandType.StoredProcedure;

            //        SqlDataAdapter da = new SqlDataAdapter(cmd);
            //        DataTable dt = new DataTable();

            //        da.Fill(dt);

            //        dataPacientes.DataSource = dt;

            //        // Ahora debes llamar este metodo desde el evento del Datagridview en Load
            //    }

            //}
        }

        private void ConfigurarGrid()
        {
            if (dataPacientes.Columns.Count == 0) return;

            if (dataPacientes.Columns["id_paciente"] != null)
                dataPacientes.Columns["id_paciente"].Visible = false;

            // Agregar botón si no existe
            if (!dataPacientes.Columns.Contains("Ver"))
            {
                DataGridViewButtonColumn btn = new DataGridViewButtonColumn();
                btn.Name = "Ver";
                btn.HeaderText = "Ficha";
                btn.Text = "Ver ficha";
                btn.UseColumnTextForButtonValue = true;

                dataPacientes.Columns.Add(btn);
            }

            dataPacientes.Columns["Nombre"].DisplayIndex = 0;
            dataPacientes.Columns["Identificación"].DisplayIndex = 1;
            dataPacientes.Columns["Teléfono"].DisplayIndex = 2;
            dataPacientes.Columns["Fecha de ingreso"].DisplayIndex = 3;
            dataPacientes.Columns["Ver"].DisplayIndex = 4;

            ////dataPacientes.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            //dataPacientes.ReadOnly = true;
            //dataPacientes.AllowUserToAddRows = false;
            //dataPacientes.RowHeadersVisible = false;




        }

        private void EstiloGrid()
        {


            // No permitir edición
            dataPacientes.ReadOnly = true;
            dataPacientes.AllowUserToAddRows = false;
            dataPacientes.AllowUserToDeleteRows = false;

            // No permitir redimensionar
            dataPacientes.AllowUserToResizeRows = false;
            dataPacientes.AllowUserToResizeColumns = false;

            // No permitir mover columnas
            dataPacientes.AllowUserToOrderColumns = false;

            // Selección completa de fila
            dataPacientes.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            dataPacientes.MultiSelect = false;

            // Quitar columna gris lateral
            dataPacientes.RowHeadersVisible = false;

            // Ajuste automático
            dataPacientes.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
        }

        private void BuscarPacientes(string texto)
        {
            using (SqlConnection cn = ConexionBD.ObtenerConexion())
            {
                using (SqlCommand cmd = new SqlCommand("sp_pacientes_buscar", cn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@texto", string.IsNullOrWhiteSpace(texto) ? (object)DBNull.Value : texto);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    dataPacientes.DataSource = dt;
                }
            }
        }

        private void textBox2_TextChanged(object sender, EventArgs e)
        {

        }

        private void Pacientes_Load(object sender, EventArgs e)  //Evento de carga del DataGridView
        {

            CargarPacientes(); // Inicamos el metodo al cargar el formulario
            ConfigurarGrid(); // Ocultamos el id y agregamos la columnna de Ver ficha
            EstiloGrid(); // Estilos y modificaciones
        }



        //Le creamos un evento al DataGridView para detectar cuando haces clic
        private void dataPacientes_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex < 0) return;

            if (dataPacientes.Columns[e.ColumnIndex].Name == "Ver")
            {
                int idPaciente = Convert.ToInt32(
                    dataPacientes.Rows[e.RowIndex].Cells["id_paciente"].Value
                );

                MessageBox.Show("Abrir ficha del paciente ID: " + idPaciente);
            }
        }

        private void txtBuscar_TextChanged(object sender, EventArgs e)
        {
           //BuscarPacientes(txtBuscar.Text.Trim());

            if (txtBuscar.Text == "Buscar por nombre, cédula o teléfono")
                return;

            if (string.IsNullOrWhiteSpace(txtBuscar.Text))
            {
                CargarPacientes();
                ConfigurarGrid();
                EstiloGrid();
                return;
            }

            BuscarPacientes(txtBuscar.Text.Trim());
            ConfigurarGrid();
            EstiloGrid();
        }

        private void txtBuscar_Enter(object sender, EventArgs e)
        {
            //Funcion si el txt contiene este elemento, al darle clic se eliminara
            if (txtBuscar.Text == "Buscar por nombre, cédula o teléfono")
            {

                txtBuscar.Text = "";
                txtBuscar.ForeColor = Color.Gray;
            
            
            }
        }

        private void txtBuscar_Leave(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtBuscar.Text))
            {
                txtBuscar.Text = "Buscar por nombre, cédula o teléfono";
                txtBuscar.ForeColor = Color.Gray;
            }
        }

        private void cmbFiltro_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}

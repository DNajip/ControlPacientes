using ControlPacientes.pages;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ControlPacientes
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();

            ModificarVentana();
        }

        private void Cerrar_Click(object sender, EventArgs e)
        {
            this.Hide (); // OCULTA EL FORM1 ACTUAL
            Login login = new Login();
            login.Show();

            this.Close (); // Cierra definitivamente el form1
        }


        /* 
            Para este sofware primero crearemos los metodos que iremos utilizando y luego los integramos para funcionalidad. 


        */

        private void ModificarVentana() { 
            //Que sea pantalla completa
            this.WindowState = FormWindowState.Maximized;

            //Quitar posibilidad de redimensionar 
            this.FormBorderStyle = FormBorderStyle.FixedSingle;


        }

        private Form formularioActivo = null;

        private void AbrirFormulario(Form nuevoFormulario)
        { 
            if (formularioActivo != null)
                formularioActivo.Close();
            formularioActivo = nuevoFormulario;

            nuevoFormulario.TopLevel = false;
            nuevoFormulario.FormBorderStyle = FormBorderStyle.None;
            nuevoFormulario.Dock = DockStyle.Fill;

            container.Controls.Clear();
            container.Controls.Add( nuevoFormulario );

            nuevoFormulario.BringToFront();
            nuevoFormulario.Show();
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void container_Paint(object sender, PaintEventArgs e)
        {

        }

        private void button3_Click(object sender, EventArgs e)
        {
            AbrirFormulario(new ControlPacientes.pages.Pacientes());
            
        }
    }
}



use ControlPacientes
go


-- Tablas catalogo

Create table tbl_estados(
	id_estado int primary key identity(1,1),
	desc_estado varchar(50) not null,
	fecha_creacion datetime not null default getdate()
)

INSERT INTO tbl_estados (desc_estado)VALUES ('Activo'), ('Inactivo');

create table tbl_roles (
	id_rol int primary key identity (1,1),
	desc_rol varchar(100) not null,

	--Control del sistema
	fecha_creacion datetime not null default getdate(),
	id_estado int references tbl_estados (id_estado)
)
INSERT INTO tbl_roles (desc_rol, id_estado) VALUES ('Administrador',1), ('Medico',1);

create table tbl_tipo_identificaciones(
	id_tipo_identificacion int primary key identity (1,1),
	desc_tipo_identificacion varchar(100), 

	--Control del sistema
	fecha_creacion datetime not null default getdate(),
	id_estado int references tbl_estados (id_estado)
)

INSERT INTO tbl_tipo_identificaciones (desc_tipo_identificacion, id_estado)VALUES 
('Cedula',1),
('Pasaporte',1),
('Otro',1);

create table tbl_genero(
	id_genero int primary key identity (1,1),
	desc_genero char(1) not null,

	--Control del sistema
	fecha_creacion datetime not null default getdate(),
	id_estado int references tbl_estados (id_estado)
)
INSERT INTO tbl_genero(desc_genero, id_estado)
VALUES ('M',1), ('F',1);

/*
--------------- Tablas de Control de datos PERSONA
*/

create table tbl_personas(
	id_persona int primary key identity(1,1),
	primer_nombre varchar (100) not null,
	segundo_nombre varchar (100), 
	primer_apellido varchar(100) not null, 
	segundo_apellido varchar(100),
	id_tipo_identificacion int references tbl_tipo_identificaciones(id_tipo_identificacion) not null,
	desc_identificacion varchar (20) not null,
	id_genero int references tbl_genero (id_genero) not null, 
	fecha_nacimiento date not null, 
	ocupacion varchar(100), 
	email varchar(100),
	telefono varchar(50),
	direccion varchar(50) not null,
	--Control del sistema
	fecha_creacion datetime not null default getdate(),
	id_estado int references tbl_estados (id_estado),

	constraint UQ_persona_identificacion unique (id_tipo_identificacion, desc_identificacion)
)


create table tbl_empleados(
	id_empleado int primary key identity(1,1), 
	id_persona int references tbl_personas(id_persona) not null,
	id_rol int references tbl_roles (id_rol) not null,
	--Control del sistema
	fecha_creacion datetime not null default getdate(),
	id_estado int references tbl_estados (id_estado)
)

create table tbl_usuarios(
	id_usuario int primary key identity(1,1),
	email varchar(100) not null UNIQUE,
	password varchar(100) not null, 
	id_empleado int references tbl_empleados(id_empleado) not null,

	--Control del sistema
	fecha_creacion datetime not null default getdate(),
	id_estado int references tbl_estados (id_estado)

)

create table tbl_pacientes(
	id_paciente int primary key identity(1,1), 
	id_persona int not null references tbl_personas(id_persona),
	numero_expediente varchar(20),

	--Control del sistema
	fecha_creacion datetime not null default getdate(),
	id_estado int references tbl_estados (id_estado)
)

/* =====================================================
   HISTORIA CLINICA (UNA POR PACIENTE)
===================================================== */

CREATE TABLE tbl_historia_clinica(
    id_historia INT PRIMARY KEY IDENTITY(1,1),
    id_paciente INT NOT NULL REFERENCES tbl_pacientes(id_paciente),

    alergias BIT,
    descripcion_alergias VARCHAR(300),

    diabetes BIT,
    hipertension BIT,
    cardiacos BIT,
    otros_padecimientos VARCHAR(300),

    fuma BIT,
    consume_alcohol BIT,

    peso DECIMAL(5,2),

    contacto_emergencia_nombre VARCHAR(100),
    contacto_emergencia_parentesco VARCHAR(50),
    contacto_emergencia_telefono VARCHAR(20),

    fecha_creacion DATETIME DEFAULT GETDATE(),
    id_estado INT REFERENCES tbl_estados(id_estado)
);



/* =====================================================
   TRATAMIENTOS
===================================================== */

create table tbl_tratamientos(
	id_tratamiento int primary key identity (1,1),
	tratamiento varchar(100),
	precio decimal(10,2),
	
	--Control del sistema
	fecha_creacion datetime not null default getdate(),
	id_estado int references tbl_estados (id_estado)
)



/* =====================================================
   CONSULTAS (EVENTO MEDICO)
===================================================== */

CREATE TABLE tbl_consultas(
    id_consulta INT PRIMARY KEY IDENTITY(1,1),
    id_paciente INT NOT NULL REFERENCES tbl_pacientes(id_paciente),
    id_empleado INT NOT NULL REFERENCES tbl_empleados(id_empleado),

    fecha_consulta DATETIME DEFAULT GETDATE(),
    observaciones VARCHAR(500),

    total_dolares DECIMAL(10,2),
    total_cordobas DECIMAL(10,2),

    fecha_creacion DATETIME DEFAULT GETDATE(),
    id_estado INT REFERENCES tbl_estados(id_estado)
);



/* =====================================================
   DETALLE DE CONSULTA (TRATAMIENTOS REALIZADOS)
===================================================== */

CREATE TABLE tbl_consulta_detalle(
    id_detalle INT PRIMARY KEY IDENTITY(1,1),
    id_consulta INT NOT NULL REFERENCES tbl_consultas(id_consulta),
    id_tratamiento INT NOT NULL REFERENCES tbl_tratamientos(id_tratamiento),

    precio_unitario DECIMAL(10,2),
    cantidad INT DEFAULT 1,
    subtotal DECIMAL(10,2)
);



/* =====================================================
   MOVIMIENTOS DE CAJA
===================================================== */

CREATE TABLE tbl_movimientos_caja(
    id_movimiento INT PRIMARY KEY IDENTITY(1,1),
    id_consulta INT REFERENCES tbl_consultas(id_consulta),

    monto_dolares DECIMAL(10,2),
    monto_cordobas DECIMAL(10,2),

    metodo_pago VARCHAR(50),

    fecha_movimiento DATETIME DEFAULT GETDATE(),
    id_estado INT REFERENCES tbl_estados(id_estado)
);



/* =====================================================
   CONFIGURACION (TASA DE CAMBIO)
===================================================== */

CREATE TABLE tbl_configuracion(
    id_configuracion INT PRIMARY KEY IDENTITY(1,1),
    tasa_cambio DECIMAL(10,4),
    fecha_actualizacion DATETIME DEFAULT GETDATE()
);

INSERT INTO tbl_configuracion(tasa_cambio)
VALUES (36.40);





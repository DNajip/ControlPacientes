USE ControlPacientes;
GO

/* =====================================================
   PERSONAS (50)
===================================================== */

DECLARE @i INT = 1;

WHILE @i <= 50
BEGIN
    INSERT INTO tbl_personas (
        primer_nombre,
        segundo_nombre,
        primer_apellido,
        segundo_apellido,
        id_tipo_identificacion,
        desc_identificacion,
        id_genero,
        fecha_nacimiento,
        ocupacion,
        email,
        telefono,
        direccion,
        id_estado
    )
    VALUES (
        CONCAT('Nombre', @i),
        CONCAT('Segundo', @i),
        CONCAT('Apellido', @i),
        CONCAT('Apellido2_', @i),
        1,
        CONCAT('ID', FORMAT(@i,'000')),
        CASE WHEN @i % 2 = 0 THEN 1 ELSE 2 END,
        DATEADD(YEAR, -20 - (@i % 20), GETDATE()),
        'Profesional',
        CONCAT('persona',@i,'@correo.com'),
        CONCAT('8888',FORMAT(@i,'0000')),
        CONCAT('Direccion ',@i),
        1
    );

    SET @i = @i + 1;
END
GO


/* =====================================================
   EMPLEADOS (2)
===================================================== */

INSERT INTO tbl_empleados (id_persona,id_rol,id_estado)
VALUES 
(1,1,1), -- Admin
(2,2,1); -- Medico
GO


/* =====================================================
   USUARIOS (2)
===================================================== */

INSERT INTO tbl_usuarios (email,password,id_empleado,id_estado)
VALUES
('admin','admin',1,1),
('medico@meditech.com','medico123',2,1);
GO

select  * from tbl_usuarios

/* =====================================================
   PACIENTES (50)
===================================================== */
DECLARE @i INT = 1;
SET @i = 1;

WHILE @i <= 50
BEGIN
    INSERT INTO tbl_pacientes (id_persona,numero_expediente,id_estado)
    VALUES (@i, CONCAT('EXP',FORMAT(@i,'000')),1);

    SET @i = @i + 1;
END
GO


/* =====================================================
   HISTORIA CLINICA (50)
===================================================== */
DECLARE @i INT = 1;
SET @i = 1;

WHILE @i <= 50
BEGIN
    INSERT INTO tbl_historia_clinica (
        id_paciente,
        alergias,
        descripcion_alergias,
        diabetes,
        hipertension,
        cardiacos,
        otros_padecimientos,
        fuma,
        consume_alcohol,
        peso,
        contacto_emergencia_nombre,
        contacto_emergencia_parentesco,
        contacto_emergencia_telefono,
        id_estado
    )
    VALUES (
        @i,
        CASE WHEN @i % 3 = 0 THEN 1 ELSE 0 END,
        'Ninguna relevante',
        CASE WHEN @i % 4 = 0 THEN 1 ELSE 0 END,
        0,
        0,
        'Ninguno',
        CASE WHEN @i % 5 = 0 THEN 1 ELSE 0 END,
        0,
        140 + (@i % 30),
        CONCAT('Contacto',@i),
        'Familiar',
        CONCAT('7777',FORMAT(@i,'0000')),
        1
    );

    SET @i = @i + 1;
END
GO


/* =====================================================
   TRATAMIENTOS (50)
===================================================== */
DECLARE @i INT = 1;
SET @i = 1;

WHILE @i <= 50
BEGIN
    INSERT INTO tbl_tratamientos (tratamiento,precio,id_estado)
    VALUES (
        CONCAT('Tratamiento ',@i),
        50 + (@i * 2),
        1
    );

    SET @i = @i + 1;
END
GO


/* =====================================================
   CONSULTAS (50)
===================================================== */
DECLARE @i INT = 1;
SET @i = 1;

WHILE @i <= 50
BEGIN
    INSERT INTO tbl_consultas (
        id_paciente,
        id_empleado,
        observaciones,
        total_dolares,
        total_cordobas,
        id_estado
    )
    VALUES (
        @i,
        2,
        'Consulta de prueba',
        100 + (@i * 5),
        (100 + (@i * 5)) * 36.40,
        1
    );

    SET @i = @i + 1;
END
GO


/* =====================================================
   DETALLE CONSULTA (50)
===================================================== */
DECLARE @i INT = 1;
SET @i = 1;

WHILE @i <= 50
BEGIN
    INSERT INTO tbl_consulta_detalle (
        id_consulta,
        id_tratamiento,
        precio_unitario,
        cantidad,
        subtotal
    )
    VALUES (
        @i,
        @i,
        100,
        1,
        100
    );

    SET @i = @i + 1;
END
GO


/* =====================================================
   MOVIMIENTOS CAJA (50)
===================================================== */
DECLARE @i INT = 1;
SET @i = 1;

WHILE @i <= 50
BEGIN
    INSERT INTO tbl_movimientos_caja (
        id_consulta,
        monto_dolares,
        monto_cordobas,
        metodo_pago,
        id_estado
    )
    VALUES (
        @i,
        100,
        3640,
        'Efectivo',
        1
    );

    SET @i = @i + 1;
END
GO
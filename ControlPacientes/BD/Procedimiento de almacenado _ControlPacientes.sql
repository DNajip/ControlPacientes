/*
------------------------------
Procedimientos de almacenado 
------------------------------

*/

--Login
CREATE OR ALTER PROCEDURE sp_login
    @email VARCHAR(100),
    @password VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Verificar si existe el usuario
    IF NOT EXISTS (SELECT 1 FROM tbl_usuarios WHERE email = @email)
    BEGIN
        SELECT -1 AS resultado; -- Correo no existe
        RETURN;
    END

    -- 2. Verificar si está inactivo
    IF EXISTS (
        SELECT 1 FROM tbl_usuarios 
        WHERE email = @email AND id_estado = 2
    )
    BEGIN
        SELECT -2 AS resultado; -- Usuario inactivo
        RETURN;
    END

    -- 3. Verificar contraseña
    IF NOT EXISTS (
        SELECT 1 FROM tbl_usuarios 
        WHERE email = @email AND password = @password
    )
    BEGIN
        SELECT -3 AS resultado; -- Contraseña incorrecta
        RETURN;
    END

    -- 4. Login correcto
    SELECT 
        1 AS resultado,
        u.id_usuario,
        r.desc_rol
    FROM tbl_usuarios u
    INNER JOIN tbl_empleados e ON u.id_empleado = e.id_empleado
    INNER JOIN tbl_roles r ON e.id_rol = r.id_rol
    WHERE u.email = @email;
END

-------------------
-- MODULO PACIENTES
-------------------

CREATE OR ALTER PROCEDURE sp_pacientes_listar 
AS
BEGIN 
    SET NOCOUNT ON;
        
    SELECT 
        pa.id_paciente, 

        LTRIM(RTRIM(
            pe.primer_nombre + ' ' +
            ISNULL(pe.segundo_nombre + ' ', '') +
            pe.primer_apellido + ' ' +
            ISNULL(pe.segundo_apellido, '')
        )) AS Nombre,

        pe.desc_identificacion AS Identificación, 
        pe.telefono AS Teléfono,
        pa.fecha_creacion AS [Fecha de ingreso]

    FROM tbl_pacientes pa
    INNER JOIN tbl_personas pe
        ON pa.id_persona = pe.id_persona
    WHERE pa.id_estado = 1
    ORDER BY pa.fecha_creacion DESC;
END;
GO

select * from tbl_pacientes
exec sp_pacientes_listar

--Buscar pacientes
CREATE OR ALTER PROCEDURE sp_pacientes_buscar
    @texto VARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        p.id_paciente,
        CONCAT(
            per.primer_nombre, ' ',
            ISNULL(per.segundo_nombre, ''), ' ',
            per.primer_apellido, ' ',
            ISNULL(per.segundo_apellido, '')
        ) AS Nombre,
        per.desc_identificacion AS Identificación,
        per.telefono AS Teléfono,
        p.fecha_creacion AS [Fecha de ingreso]
    FROM tbl_pacientes p
    INNER JOIN tbl_personas per ON p.id_persona = per.id_persona
    WHERE 
        p.id_estado = 1
        AND (
            @texto IS NULL
            OR per.primer_nombre LIKE '%' + @texto + '%'
            OR per.segundo_nombre LIKE '%' + @texto + '%'
            OR per.primer_apellido LIKE '%' + @texto + '%'
            OR per.segundo_apellido LIKE '%' + @texto + '%'
            OR per.desc_identificacion LIKE '%' + @texto + '%'
            OR per.telefono LIKE '%' + @texto + '%'
        )
    ORDER BY p.fecha_creacion DESC;
END;
GO

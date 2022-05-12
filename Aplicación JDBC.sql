USE LBD2022; 

DROP PROCEDURE IF EXISTS VerEmpleados;

DELIMITER //
CREATE PROCEDURE VerEmpleados()
BEGIN  
	SELECT IDEmpleado, Apellido, Nombre, Titulo, TituloDeCortesia, FechaNacimiento, 
		FechaContratacion, Direccion, Ciudad, Region, CodigoPostal, Pais, Telefono, Extension, 
        Notas, ReportaA, Foto
	FROM Empleados
    ORDER BY 2, 3;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS BuscarEmpleado;

DELIMITER //
CREATE PROCEDURE BuscarEmpleado(pIDEmpleado INT)
BEGIN  
	SELECT IDEmpleado, Apellido, Nombre, Titulo, TituloDeCortesia, FechaNacimiento, FechaContratacion, Direccion, Ciudad, Region, CodigoPostal, Pais, Telefono, Extension, Notas, ReportaA, Foto
	FROM Empleados
	WHERE IDEmpleado = pIDEmpleado;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS `NuevoEmpleado`;

DELIMITER //
CREATE PROCEDURE `NuevoEmpleado`(pIDEmpleado INT, pApellido VARCHAR(20), pNombre VARCHAR (10), 
			pTitulo VARCHAR(30), pTituloDeCortesia VARCHAR(25), pFechaNacimiento DATETIME, 
            pFechaContratacion DATETIME, pDireccion VARCHAR(60), pCiudad VARCHAR(15),
            pRegion VARCHAR(15), pCodigoPostal VARCHAR(10), pPais VARCHAR(15), pTelefono VARCHAR(24),
            pExtension VARCHAR(4), pNotas VARCHAR(500), pReportaA INT, pFoto VARCHAR(255),
            OUT mensaje varchar(200))
SALIR: BEGIN
	IF (pIDEmpleado IS NULL) OR 
		(pApellido IS NULL OR pApellido = '') OR
        (pNombre IS NULL OR pNombre = '') THEN
		SET mensaje = 'El identificador, apellido y/o nombre son incorrectos';
        LEAVE SALIR;
	ELSEIF EXISTS (SELECT * FROM Empleados WHERE IDEmpleado = pIDEmpleado) THEN
		SET mensaje = 'Ya existe un empleado con ese identificador';
        LEAVE SALIR;
    ELSEIF (pReportaA IS NOT NULL) AND NOT EXISTS (SELECT * FROM Empleados WHERE IDEmpleado = pReportaA) THEN    
		SET mensaje = 'No existe el empleado a quien reportar';
        LEAVE SALIR;
	ELSE
		INSERT INTO Empleados (IDEmpleado, Apellido, Nombre, Titulo, TituloDeCortesia, 
			FechaNacimiento, FechaContratacion, Direccion, Ciudad, Region, CodigoPostal, Pais, 
            Telefono, Extension,Notas, ReportaA, Foto)
			VALUES (pIDEmpleado, pApellido, pNombre, pTitulo, pTituloDeCortesia, 
			pFechaNacimiento, pFechaContratacion, pDireccion, pCiudad, pRegion, pCodigoPostal, pPais, 
            pTelefono, pExtension,pNotas, pReportaA, pFoto);
		SET Mensaje = 'Empleado creado con éxito';
	END IF;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS `BorrarEmpleado`;

DELIMITER //
CREATE PROCEDURE `BorrarEmpleado`(pIDEmpleado INT, OUT mensaje varchar(200))
SALIR: BEGIN
	IF (pIDEmpleado IS NULL) OR (NOT EXISTS (SELECT * FROM Empleados WHERE IDEmpleado = pIDEmpleado)) THEN
		SET mensaje = 'No existe el empleado especificado';
        LEAVE SALIR;
	ELSEIF EXISTS (SELECT * FROM Ordenes WHERE IDEmpleado = pIDEmpleado) THEN
		SET mensaje = 'No se puede borrar el empleado porque tiene órdenes';
        LEAVE SALIR;
	ELSE
		DELETE FROM Empleados WHERE IDEmpleado = pIDEmpleado;
		SET Mensaje = 'Empleado borrado con éxito';
	END IF;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS `ModificarEmpleado`;

DELIMITER //
CREATE PROCEDURE `ModificarEmpleado`(pIDEmpleado INT, pApellido VARCHAR(20), pNombre VARCHAR (10), 
			pTitulo VARCHAR(30), pTituloDeCortesia VARCHAR(25), pFechaNacimiento DATETIME, 
            pFechaContratacion DATETIME, pDireccion VARCHAR(60), pCiudad VARCHAR(15),
            pRegion VARCHAR(15), pCodigoPostal VARCHAR(10), pPais VARCHAR(15), pTelefono VARCHAR(24),
            pExtension VARCHAR(4), pNotas VARCHAR(500), pReportaA INT, pFoto VARCHAR(255),
            OUT mensaje varchar(200))
SALIR: BEGIN
	IF (pIDEmpleado IS NULL) THEN
		SET mensaje = 'No existe el empleado especificado';
        LEAVE Salir;
	ELSEIF (pApellido IS NULL OR pApellido = '') OR (pNombre IS NULL OR pNombre = '') THEN
		SET mensaje = 'El apellido y/o nombre son incorrectos';
        LEAVE SALIR;
    ELSEIF (pReportaA IS NOT NULL) AND NOT EXISTS (SELECT * FROM Empleados WHERE IDEmpleado = pReportaA) THEN    
		SET mensaje = 'No existe el empleado a quien reportar';
        LEAVE SALIR;
	ELSE
		UPDATE Empleados
			SET Apellido = pApellido, Nombre = pNombre, Titulo = pTitulo, TituloDeCortesia = pTituloDeCortesia,
				FechaNacimiento = pFechaNacimiento, FechaContratacion = pFechaContratacion, 
                Direccion = pDireccion, Ciudad = pCiudad, Region = pRegion, CodigoPostal = pCodigoPostal, 
                Pais = pPais, Telefono = pTelefono, Extension = pExtension, Notas = pNotas, 
                ReportaA = pReportaA, Foto = pFoto
		WHERE IDEmpleado = pIDEmpleado;
		SET Mensaje = 'Empleado modificado con éxito';
	END IF;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS VerOrdenes;

DELIMITER //
CREATE PROCEDURE VerOrdenes()
BEGIN  
	SELECT IDOrden, Ordenes.IDCliente, Compania, Clientes.Nombre AS 'NombreCliente', Ordenes.IDEmpleado, Apellido, Empleados.Nombre AS 'NombreEmpleado', Fecha, FechaRequerida, FechaEnviada, EnviadoPor, Carga, NombreDespachante, DireccionDespachante, CiudadDespachante, RegionDespachante, CodigoPostalDespachante, PaisDespachante
	FROM Ordenes JOIN Empleados
	ON Ordenes.IDEmpleado = Empleados.IDEmpleado
	JOIN Clientes
	ON Ordenes.IDCliente = Clientes.IDCliente
	ORDER BY Fecha DESC;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS BuscarOrdenes;

DELIMITER //
CREATE PROCEDURE BuscarOrdenes(pAnio INT)
BEGIN  
	IF (pAnio IS NULL) THEN
		CALL VerOrdenes();
	ELSE
		SELECT IDOrden, Ordenes.IDCliente, Compania, Clientes.Nombre AS 'NombreCliente', Ordenes.IDEmpleado, Apellido, Empleados.Nombre AS 'NombreEmpleado', Fecha, FechaRequerida, FechaEnviada, EnviadoPor, Carga, NombreDespachante, DireccionDespachante, CiudadDespachante, RegionDespachante, CodigoPostalDespachante, PaisDespachante
		FROM Ordenes JOIN Empleados
		ON Ordenes.IDEmpleado = Empleados.IDEmpleado
		JOIN Clientes
		ON Ordenes.IDCliente = Clientes.IDCliente
		WHERE YEAR(Fecha) = pAnio
		ORDER BY Fecha DESC;
    END IF;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS VerDetalle;

DELIMITER //
CREATE PROCEDURE VerDetalle(pIDOrden INT)
BEGIN  
	IF (pIDOrden IS NOT NULL) THEN
		SELECT Detalles.IDItem, Nombre, IDProveedor, IDCategoria, CantidadPorUnidad, PrecioUnitario, 
			UnidadesEnStock, UnidadesAOrdenar, NivelReordenamiento, Discontinuado, Precio, 
            Cantidad, Descuento
		FROM Detalles JOIN Items
		ON Detalles.IDItem = Items.IDItem
        WHERE Detalles.IDOrden = pIDOrden
        ORDER BY Nombre;
    END IF;
END //
DELIMITER ;

USE [CuartaTarea]


DELETE dbo.DetalleCC
DELETE dbo.Factura
DELETE dbo.PXP
DELETE dbo.UXP
DELETE dbo.Usuario
DELETE dbo.Persona 
DELETE dbo.MovimientoConsumo
DELETE dbo.PropiedadCCAgua
DELETE dbo.PropiedadXCC
DELETE dbo.Propiedad
	
DBCC CHECKIDENT (DetalleCC, RESEED, 0)
DBCC CHECKIDENT (Factura, RESEED, 0)
DBCC CHECKIDENT (PXP, RESEED, 0)
DBCC CHECKIDENT (UXP, RESEED, 0)
DBCC CHECKIDENT (Persona, RESEED, 0)
DBCC CHECKIDENT (Usuario, RESEED, 0)
DBCC CHECKIDENT (Propiedad, RESEED, 0)
DBCC CHECKIDENT (PropiedadXCC, RESEED, 0)
DBCC CHECKIDENT (MovimientoConsumo, RESEED, 0)


SET NOCOUNT ON

DECLARE @Fechas TABLE (fechaOperacion DATE);  

DECLARE @Persona TABLE(
	nombre VARCHAR(128)
  , TipoDocumentoIdentidad VARCHAR(128)
  , ValorDocumentoIdentidad BIGINT
  , Telefono1 BIGINT
  , Telefono2 BIGINT
  , Email VARCHAR(128)
  );

DECLARE @Propiedad TABLE(
	NumeroFinca INT
  , MetrosCuadrados FLOAT
  , TipoTerreno VARCHAR(128)
  , TipoZona VARCHAR(128)
  , numMedidor INT
  , ValorFiscal VARCHAR(128)
  , M3AcumuladoAgua FLOAT
  , M3AcumuladosUltimoFactura FLOAT
  , FechaRegistro DATE
  );

DECLARE @PersonasyPropiedades TABLE(
	ValorDocumentoIdentidad INT
  , NumeroFinca INT
  , TipoAsociacion VARCHAR(128)
  );

DECLARE @Usuario TABLE(
	ValorDocumentoIdentidad INT
  , UserName VARCHAR(128)
  , VPassWord VARCHAR(128)
  , TipoUsuario VARCHAR(128)
  , TipoAsociacion VARCHAR(128)
  );

DECLARE @PropiedadesyUsuarios TABLE(
	ValorDocumentoIdentidad INT
  , NumeroFinca INT
  , TipoAsociacion VARCHAR(128)
  );

DECLARE @MovConsumo TableTypeMovConsumo


----Declaracion de variables----
DECLARE @fechaItera DATE
	  , @fechaFin DATE
	  , @lo INT
	  , @hi INT
	  , @fechaNodo VARCHAR(20)
	  , @xmlOperacion xml
	  , @hdoc int
	  ; -- una DECLARE siempre termina en ;

SET @xmlOperacion = (
	SELECT *
	FROM OPENROWSET(BULK 'C:\Users\jburg\OneDrive\Escritorio\Jose_Pablo\TEC\2022\II_Semestre\Bases de Datos I\Tareas\Tarea 3\xml\Operaciones.xml', SINGLE_BLOB) AS x) --Cargamos archivos de forma masiva
EXEC sp_xml_preparedocument @hdoc OUTPUT, @xmlOperacion

INSERT @Fechas(fechaOperacion)
SELECT Fecha = CONVERT(DATE,Fecha,102)
FROM OPENXML(@hdoc,'/Datos/Operacion',1) --Cargamos todas las fechas en la tabla @Fechas
WITH( Fecha VARCHAR(12) )

--------------------------------Comenzamos a iterar------------------------------------------------------------------
SELECT @fechaItera=MIN(fechaOperacion)
	 , @fechaFin=MAX(fechaOperacion)
FROM @Fechas


WHILE(@fechaItera <= @fechaFin) 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM @Fechas WHERE fechaOperacion = @fechaItera)
		CONTINUE

    SET @fechaNodo = CONVERT(VARCHAR(20), @fechaItera, 23) --Necesitamos un aux para leer @fechaItera como tipo VARCHAR
	--DECLARE @PersonasyPropiedades TABLE(ValorDocumentoIdentidad INT,NumeroFinca INT, TipoAsociacion VARCHAR(128),FechaInicio DATE,FechaFin DATE);
			-----------Insertar Propiedad-------------

    INSERT @Propiedad(
		NumeroFinca
	  , MetrosCuadrados
	  , ValorFiscal
	  , TipoTerreno
	  , TipoZona
	  , numMedidor
	  , M3AcumuladoAgua
	  , M3AcumuladosUltimoFactura
	  )
    SELECT 
		T.Item.value('@NumeroFinca','INT')
	  , T.Item.value('@MetrosCuadrados','FLOAT')
	  , T.Item.value('@ValorFiscal','VARCHAR(128)')
	  , T.Item.value('@tipoUsoPropiedad','VARCHAR(128)')
	  , T.Item.value('@tipoZonaPropiedad','VARCHAR(128)')
	  , T.Item.value('@NumeroMedidor','VARCHAR(128)')
	  , T.Item.value('@M3AcumuladoAgua','FLOAT')
	  , T.Item.value('@M3AcumuladosUltimoFactura','FLOAT')
	FROM @xmlOperacion.nodes('/Datos/Operacion[@Fecha=sql:variable("@FechaNodo")]/Propiedades/Propiedad') as T(Item)


	INSERT dbo.Propiedad(
		NumFinca
	  , Area
	  , ValorFiscal
	  , NumMedidor
	  , FechaRegistro
	  , IdTipoTerreno
	  , IdTipoZona
	  , activo
	  , M3AcumuladoAgua
	  , M3AcumuladosUltimoFactura
	  )
	SELECT
		p.NumeroFinca
	  , p.MetrosCuadrados
	  , p.ValorFiscal
	  , p.numMedidor
	  , @fechaItera
	  , t.ID
	  , z.ID
	  , 1
	  , P.M3AcumuladoAgua
	  , P.M3AcumuladosUltimoFactura
	FROM @Propiedad AS p
	INNER JOIN dbo.TipoTerreno t ON t.Nombre = p.TipoTerreno
	INNER JOIN dbo.TipoZona z ON z.Nombre = p.TipoZona


    ----Nueva Persona-----
    INSERT @Persona(
		nombre
	  , ValorDocumentoIdentidad
	  , TipoDocumentoIdentidad
	  , email
	  , telefono1
	  , telefono2
	  )
    SELECT
		T.Item.value('@Nombre','VARCHAR(128)')
	  , T.Item.value('@ValorDocumentoIdentidad','BIGINT')
	  , T.Item.value('@TipoDocumentoIdentidad','VARCHAR(128)')
	  , T.Item.value('@Email','VARCHAR(128)')
	  , T.Item.value('@Telefono1','BIGINT')
	  , T.Item.value('@Telefono2','BIGINT')
    FROM @xmlOperacion.nodes('/Datos/Operacion[@Fecha=sql:variable("@FechaNodo")]/Personas/Persona') as T(Item)

	
	INSERT dbo.Persona(
		Nombre
	  , ValorDocId
	  , IdTipoDoc
	  , email
	  , telefono1
	  , telefono2
	  , activo
	  )
	SELECT 
		p.nombre
	  , p.ValorDocumentoIdentidad
	  , d.ID
	  , p.email
	  , p.telefono1
	  , p.telefono2
	  , 1
	FROM @Persona AS p
	INNER JOIN dbo.TipoDocIdent d
	ON p.TipoDocumentoIdentidad = d.Nombre
	


	-----------Insertar Usuarios-------------
	INSERT @Usuario(
		ValorDocumentoIdentidad
	  , UserName
	  , VPassWord
	  , TipoUsuario
	  , TipoAsociacion
	  )
    SELECT
		T.Item.value('@ValorDocumentoIdentidad','INT')
	  , T.Item.value('@Username','VARCHAR(128)')
	  , T.Item.value('@Password','VARCHAR(128)')
	  , T.Item.value('@TipoUsuario','VARCHAR(128)')
	  , T.Item.value('@TipoAsociacion','VARCHAR(128)')
	FROM @xmlOperacion.nodes('/Datos/Operacion[@Fecha=sql:variable("@FechaNodo")]/Usuario/Usuario') as T(Item)
	

	INSERT dbo.Usuario(
		UserName
	  , [Password]
	  , TipoUsuario
	  , IdPersona
	  , IdTipoAsociacion
	  , activo
	  )
	SELECT
		u.UserName
	  , u.VPassWord
	  , u.TipoUsuario
	  , p.ID
	  , t.ID
	  , 1
	FROM @Usuario AS u
	INNER JOIN dbo.Persona p ON u.ValorDocumentoIdentidad = p.ValorDocId
	INNER JOIN dbo.TipoAsociacion t ON u.TipoAsociacion = t.Nombre
	
	
	-----------Insertar Personas-Propiedades-------------
	INSERT @PersonasyPropiedades(
		ValorDocumentoIdentidad
	  , NumeroFinca
	  , TipoAsociacion
	  )
    SELECT 
		T.Item.value('@ValorDocumentoIdentidad','INT')
	  , T.Item.value('@NumeroFinca','INT')
	  , T.Item.value('@TipoAsociacion','VARCHAR(128)')
    FROM @xmlOperacion.nodes('/Datos/Operacion[@Fecha=sql:variable("@FechaNodo")]/PersonasyPropiedades/PropiedadPersona') as T(Item)


	INSERT dbo.PXP(
		IdPersona
	  , IdPropiedad
	  , IdTipoAsociacion
	  , FechaInicio
	  , activo
	  )
	SELECT 
		p.ID
	  , pro.ID
	  , ta.ID
	  , @fechaItera
	  , 1
	FROM @PersonasyPropiedades pxp
	INNER JOIN dbo.Persona p ON pxp.ValorDocumentoIdentidad = p.ValorDocId
	INNER JOIN dbo.Propiedad pro ON pxp.NumeroFinca = pro.NumFinca
	INNER JOIN dbo.TipoAsociacion ta ON pxp.TipoAsociacion = ta.Nombre
	--WHERE pxp.TipoAsociacion = 'Agregar'
			
	
	-----------Insertar Usuarios-Propiedades-------------
	INSERT @PropiedadesyUsuarios(
		ValorDocumentoIdentidad
	  , NumeroFinca
	  , TipoAsociacion
	  )
	  
    SELECT 
		T.Item.value('@ValorDocumentoIdentidad','INT')
	  , T.Item.value('@NumeroFinca','INT')
	  , T.Item.value('@TipoAsociacion','VARCHAR(128)')
    FROM @xmlOperacion.nodes('/Datos/Operacion[@Fecha=sql:variable("@FechaNodo")]/PropiedadesyUsuarios/UsuarioPropiedad') as T(Item)
	--SELECT * FROM @PropiedadesyUsuarios
	

	IF NOT EXISTS (
		SELECT 1
		FROM dbo.UXP UP
		INNER JOIN dbo.Propiedad P ON P.ID = UP.ID
		INNER JOIN @PropiedadesyUsuarios PU ON PU.NumeroFinca = P.NumFinca
		)
		BEGIN
			INSERT dbo.UXP(
				  IdUsuario
				, ID
				, IdTipoAsociacion
				, FechaInicio
				, activo
				)
			SELECT 
				  u.ID
				, pro.ID
				, ta.ID
				, @fechaItera
				, 1
			FROM @PropiedadesyUsuarios up
			INNER JOIN dbo.Persona p ON up.ValorDocumentoIdentidad = p.ValorDocId
			INNER JOIN dbo.Usuario u ON p.ID = u.IdPersona
			INNER JOIN dbo.Propiedad pro ON up.NumeroFinca = pro.NumFinca
			INNER JOIN dbo.TipoAsociacion ta ON up.TipoAsociacion = ta.Nombre
		END
	ELSE
		BEGIN
			UPDATE dbo.UXP
			SET IdUsuario = u.ID
				, IdTipoAsociacion = ta.ID
				, FechaInicio = @fechaItera
				, activo = 1
			FROM @PropiedadesyUsuarios up
			INNER JOIN dbo.Persona p ON up.ValorDocumentoIdentidad = p.ValorDocId
			INNER JOIN dbo.Usuario u ON p.ID = u.IdPersona
			INNER JOIN dbo.Propiedad pro ON up.NumeroFinca = pro.NumFinca
			INNER JOIN dbo.TipoAsociacion ta ON up.TipoAsociacion = ta.Nombre
			WHERE pro.ID = UXP.ID
		END
	

	-----------Insertar lecturas-------------
	INSERT @MovConsumo(
		NumeroMedidor
	  , TipoMovimiento
	  , Valor
	  )
    SELECT 
        T.Item.value('@NumeroMedidor','INT')
	  , T.Item.value('@TipoMovimiento','VARCHAR(128)')
	  , T.Item.value('@Valor','MONEY')
    FROM @xmlOperacion.nodes('/Datos/Operacion[@Fecha=sql:variable("@FechaNodo")]/Lecturas/LecturaMedidor') as T(Item)

	EXEC proc_movConsumo @MovConsumo, @fechaitera, 0


	SELECT * FROM dbo.Factura
	SELECT * FROM dbo.DetalleCC
	SELECT * FROM dbo.Persona
	SELECT * FROM dbo.Usuario
	SELECT * FROM dbo.Propiedad
	SELECT * FROM dbo.PXP
	SELECT * FROM dbo.UXP
	SELECT * FROM dbo.PropiedadXCC
	SELECT * FROM dbo.PropiedadCCAgua
	SELECT * FROM dbo.MovimientoConsumo

	DELETE @Persona 
	DELETE @Usuario
	DELETE @Propiedad
	DELETE @PersonasyPropiedades
	DELETE @PropiedadesyUsuarios
	DELETE @MovConsumo
    
    SET @fechaItera= (DATEADD(DAY,1,@fechaItera)) --Siguiente

END;

	

	
	/*
	USE [SegundaTarea]

DECLARE @Fechas TABLE (fechaOperacion DATE);  

DECLARE @Persona TABLE(nombre VARCHAR(128), ValorDocumentoIdentidad BIGINT, TipoDocumentoIdentidad VARCHAR(128), Email VARCHAR(128),Telefono1 BIGINT, Telefono2 BIGINT);
DECLARE @Propiedad TABLE(NumeroFinca INT,MetrosCuadrados FLOAT,ValorFiscal VARCHAR(128),FechaRegistro DATE, IdTipoTerreno VARCHAR(128), IdTipoZona VARCHAR(128), IdUsuario INT);
DECLARE @Usuario TABLE(ValorDocumentoIdentidad INT,UserName VARCHAR(128),VPassWord VARCHAR(128), TipoUsuario VARCHAR(128));

----Declaracion de variables----
DECLARE @fechaItera DATE, @fechaFin DATE, @lo INT,@hi INT; -- una DECLARE siempre termina en ;
DECLARE @fechaNodo VARCHAR(20);
DECLARE @xmlOperacion xml;

SET @xmlOperacion = (SELECT *FROM OPENROWSET(BULK 'C:\Users\Usuario\Documents\Semestre actual\BD\SegundaTarea\Operaciones.xml', SINGLE_BLOB) AS x) --Cargamos archivos de forma masiva

DECLARE @hdoc int;  
EXEC sp_xml_preparedocument @hdoc OUTPUT, @xmlOperacion
INSERT @Fechas(fechaOperacion)
SELECT Fecha = CONVERT(DATE,Fecha,102)
FROM OPENXML(@hdoc,'/Datos/Operacion',1) --Cargamos todas las fechas en la tabla @Fechas
WITH(
    Fecha VARCHAR(12)
)
--------------------------------Comenzamos a iterar------------------------------------------------------------------
SELECT @fechaItera=MIN(fechaOperacion), @fechaFin=MAX(fechaOperacion)
FROM @Fechas 
WHILE(@fechaItera<=@fechaFin) 
BEGIN
	
    if not exists (select 1 from @Fechas where fechaOperacion=@fechaItera)
            continue

    SET @fechaNodo = CONVERT(VARCHAR(20),@fechaItera,23) --Necesitamos un aux para leer @fechaItera como tipo VARCHAR
		
    
		-----------Insertar Propiedad-------------

    INSERT @Propiedad(MetrosCuadrados ,ValorFiscal,IdTipoTerreno ,IdTipoZona)
    SELECT T.Item.value('@MetrosCuadrados','FLOAT'),
        T.Item.value('@ValorFiscal','VARCHAR(128)'),
		T.Item.value('@tipoUsoPropiedad','VARCHAR(128)'),
        T.Item.value('@tipoZonaPropiedad','VARCHAR(128)')


	FROM @xmlOperacion.nodes('/Datos/Operacion[@Fecha=sql:variable("@FechaNodo")]/Propiedades/Propiedad') as T(Item)

	--DECLARE @Propiedad TABLE(NumeroFinca INT,Area INT,ValorFiscal VARCHAR(128),FechaRegistro DATE, IdTipoTerreno INT, IdTipoZona INT, IdUsuario INT)
	--SET IDENTITY_INSERT dbo.Propiedad ON;
	--INSERT Propiedad(Area, ValorFiscal , FechaRegistro, IdTipoTerreno, IdTipoZona,IdUsuario)
	SELECT
		p.MetrosCuadrados,
		p.ValorFiscal,
		@fechaItera,
		t.ID
	FROM @Propiedad AS p
		INNER JOIN dbo.TipoTerreno t ON t.Nombre = p.IdTipoTerreno


	DELETE @Persona 
	DELETE @Usuario
	DELETE @Propiedad
    
    SET @fechaItera= (DATEADD(DAY,1,@fechaItera)) --Siguiente



END;
*/
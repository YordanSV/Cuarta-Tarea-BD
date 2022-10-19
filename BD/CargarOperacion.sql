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
		
    ----Nueva Persona-----
    INSERT @Persona(nombre , ValorDocumentoIdentidad, TipoDocumentoIdentidad , email, telefono1, telefono2)
    SELECT T.Item.value('@Nombre','VARCHAR(128)'),
        T.Item.value('@ValorDocumentoIdentidad','BIGINT'),
        T.Item.value('@TipoDocumentoIdentidad','VARCHAR(128)'),
        T.Item.value('@Email','VARCHAR(128)'),
        T.Item.value('@Telefono1','BIGINT'),
        T.Item.value('@Telefono2','BIGINT')
    FROM @xmlOperacion.nodes('/Datos/Operacion[@Fecha=sql:variable("@FechaNodo")]/Personas/Persona') as T(Item)

	INSERT dbo.Persona(Nombre,ValorDocId,IdTipoDoc,email,telefono1,telefono2)
	SELECT 
		p.nombre,
		p.ValorDocumentoIdentidad,
		d.ID,
		p.email,
		p.telefono1,
		p.telefono2
	FROM @Persona AS p
	INNER JOIN dbo.TipoDocIdent d
	ON p.TipoDocumentoIdentidad = d.Nombre
	
	-----------Insertar Usuarios-------------
	INSERT @Usuario(ValorDocumentoIdentidad,UserName,VPassWord,TipoUsuario)
    SELECT T.Item.value('@ValorDocumentoIdentidad','INT'),
        T.Item.value('@Username','VARCHAR(128)'),
        T.Item.value('@Password','VARCHAR(128)'),
		T.Item.value('@TipoUsuario','VARCHAR(128)')

	FROM @xmlOperacion.nodes('/Datos/Operacion[@Fecha=sql:variable("@FechaNodo")]/Usuario/Usuario') as T(Item)
	--SET IDENTITY_INSERT dbo.Usuario OFF;
	INSERT dbo.Usuario(UserName,[Password],TipoUsuario,IdPersona)
	SELECT	u.UserName,
			u.VPassWord,
			u.TipoUsuario,
			p.ID
	FROM @Usuario AS u
	INNER JOIN dbo.Persona p ON u.ValorDocumentoIdentidad = p.ValorDocId
	

		-----------Insertar Propiedad-------------

    INSERT @Propiedad(MetrosCuadrados ,ValorFiscal,IdTipoTerreno ,IdTipoZona)
    SELECT T.Item.value('@MetrosCuadrados','FLOAT'),
        T.Item.value('@ValorFiscal','VARCHAR(128)'),
		T.Item.value('@tipoUsoPropiedad','VARCHAR(128)'),
        T.Item.value('@tipoZonaPropiedad','VARCHAR(128)')


	FROM @xmlOperacion.nodes('/Datos/Operacion[@Fecha=sql:variable("@FechaNodo")]/Propiedades/Propiedad') as T(Item)

	--DECLARE @Propiedad TABLE(NumeroFinca INT,Area INT,ValorFiscal VARCHAR(128),FechaRegistro DATE, IdTipoTerreno INT, IdTipoZona INT, IdUsuario INT)
	--SET IDENTITY_INSERT dbo.Propiedad ON;
	INSERT Propiedad(Area, ValorFiscal , FechaRegistro, IdTipoTerreno, IdTipoZona,IdUsuario)
	SELECT
		p.MetrosCuadrados,
		p.ValorFiscal,
		@fechaItera,
		t.ID,
		z.ID,
		1
	FROM @Propiedad AS p
		INNER JOIN dbo.TipoTerreno t ON t.Nombre = p.IdTipoTerreno
		INNER JOIN dbo.TipoZona z ON z.Nombre = p.IdTipoZona
		
	SELECT * FROM dbo.Persona
	SELECT * FROM dbo.Usuario
	SELECT * FROM dbo.Propiedad

	DELETE @Persona 
	DELETE @Usuario
	DELETE @Propiedad
    
    SET @fechaItera= (DATEADD(DAY,1,@fechaItera)) --Siguiente



END;


	DELETE dbo.Persona 
	DELETE dbo.Usuario
	DELETE dbo.Propiedad


	DBCC CHECKIDENT (Persona, RESEED, 0)
    DBCC CHECKIDENT (Usuario, RESEED, 0)
    DBCC CHECKIDENT (Propiedad, RESEED, 0)


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
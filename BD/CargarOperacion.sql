USE [SegundaTarea]

SET NOCOUNT ON

DECLARE @Fechas TABLE (fechaOperacion DATE);  

DECLARE @Persona TABLE(nombre VARCHAR(128), ValorDocumentoIdentidad BIGINT, TipoDocumentoIdentidad VARCHAR(128), Email VARCHAR(128),Telefono1 BIGINT, Telefono2 BIGINT);
DECLARE @Propiedad TABLE(NumeroFinca INT,MetrosCuadrados FLOAT,ValorFiscal VARCHAR(128),FechaRegistro DATE, IdTipoTerreno VARCHAR(128), IdTipoZona VARCHAR(128), IdUsuario INT, numMedidor INT);
DECLARE @Usuario TABLE(ValorDocumentoIdentidad INT,UserName VARCHAR(128),VPassWord VARCHAR(128), TipoUsuario VARCHAR(128));
DECLARE @PersonasyPropiedades TABLE(ValorDocumentoIdentidad INT,NumeroFinca INT, TipoAsociacion VARCHAR(128),FechaInicio VARCHAR(128),FechaFin VARCHAR(128));
DECLARE @PropiedadesyUsuarios TABLE(ValorDocumentoIdentidad INT,NumeroFinca INT);
DECLARE @MovConsumo TABLE(NumeroMedidor INT, TipoMovimiento VARCHAR(128), Valor MONEY);



----Declaracion de variables----
DECLARE @fechaItera DATE, @fechaFin DATE, @lo INT,@hi INT; -- una DECLARE siempre termina en ;
DECLARE @fechaNodo VARCHAR(20);
DECLARE @xmlOperacion xml;

SET @xmlOperacion = (SELECT *FROM OPENROWSET(BULK 'C:\Users\jburg\OneDrive\Escritorio\Jose_Pablo\TEC\2022\II_Semestre\Bases de Datos I\Tareas\Tarea 2\xml\Operaciones.xml', SINGLE_BLOB) AS x) --Cargamos archivos de forma masiva

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
	--DECLARE @PersonasyPropiedades TABLE(ValorDocumentoIdentidad INT,NumeroFinca INT, TipoAsociacion VARCHAR(128),FechaInicio DATE,FechaFin DATE);
			-----------Insertar Propiedad-------------

    INSERT @Propiedad(NumeroFinca,MetrosCuadrados ,ValorFiscal,IdTipoTerreno ,IdTipoZona, numMedidor)
    SELECT 
		T.Item.value('@NumeroFinca','INT'),
		T.Item.value('@MetrosCuadrados','FLOAT'),
        T.Item.value('@ValorFiscal','VARCHAR(128)'),
		T.Item.value('@tipoUsoPropiedad','VARCHAR(128)'),
        T.Item.value('@tipoZonaPropiedad','VARCHAR(128)'),
		T.Item.value('@NumeroMedidor','VARCHAR(128)')

	FROM @xmlOperacion.nodes('/Datos/Operacion[@Fecha=sql:variable("@FechaNodo")]/Propiedades/Propiedad') as T(Item)

	--DECLARE @Propiedad TABLE(NumeroFinca INT,Area INT,ValorFiscal VARCHAR(128),FechaRegistro DATE, IdTipoTerreno INT, IdTipoZona INT, IdUsuario INT)
	--SET IDENTITY_INSERT dbo.Propiedad ON;
	INSERT dbo.Propiedad(NumFinca, Area, ValorFiscal , FechaRegistro, IdTipoTerreno, IdTipoZona,IdUsuario)
	SELECT
		p.NumeroFinca,
		p.MetrosCuadrados,
		p.ValorFiscal,
		@fechaItera,
		t.ID,
		z.ID,
		NULL
	FROM @Propiedad AS p
		INNER JOIN dbo.TipoTerreno t ON t.Nombre = p.IdTipoTerreno
		INNER JOIN dbo.TipoZona z ON z.Nombre = p.IdTipoZona
	

	INSERT dbo.PropiedadXCC(IdPropiedad,IdConceptoCobro)
    SELECT 
		p.ID,
        1
    FROM dbo.Propiedad p


	INSERT dbo.PropiedadCCAgua(ID, NumeroMedidor, SaldoAcumulado)
    SELECT 
		PCC.ID,
		Pr.numMedidor,
        0
    FROM dbo.Propiedad P
	INNER JOIN dbo.PropiedadXCC PCC ON PCC.IdPropiedad = P.ID
	INNER JOIN @Propiedad Pr ON Pr.NumeroFinca = P.NumFinca

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
	
	
	-----------Insertar Personas-Propiedades-------------
	INSERT @PersonasyPropiedades(ValorDocumentoIdentidad,NumeroFinca, TipoAsociacion,FechaInicio,FechaFin)
    SELECT 
		T.Item.value('@ValorDocumentoIdentidad','INT'),
        T.Item.value('@NumeroFinca','INT'),
        T.Item.value('@TipoAsociacion','VARCHAR(128)'),
		IIF (T.Item.value('@TipoAsociacion','VARCHAR(128)') = 'Agregar',  @fechaItera,NULL),
		IIf (T.Item.value('@TipoAsociacion','VARCHAR(128)') = 'Eliminar', @fechaItera,NULL)
    FROM @xmlOperacion.nodes('/Datos/Operacion[@Fecha=sql:variable("@FechaNodo")]/PersonasyPropiedades/PropiedadPersona') as T(Item)


	INSERT dbo.PXP(IdPersona,IdPropiedad,FechaInicio,FechaFin)
	SELECT 
	p.ID,
	pro.ID,
	pxp.FechaInicio,
	pxp.FechaFin
	FROM @PersonasyPropiedades pxp
	INNER JOIN dbo.Persona p
	ON pxp.ValorDocumentoIdentidad = p.ValorDocId
	INNER JOIN dbo.Propiedad pro 
	ON pxp.NumeroFinca = pro.NumFinca
	--WHERE pxp.TipoAsociacion = 'Agregar'
			
	
	-----------Insertar Usuarios-Propiedades-------------
	INSERT @PropiedadesyUsuarios(ValorDocumentoIdentidad,NumeroFinca)
    SELECT 
		T.Item.value('@ValorDocumentoIdentidad','INT'),
        T.Item.value('@NumeroFinca','INT')
    FROM @xmlOperacion.nodes('/Datos/Operacion[@Fecha=sql:variable("@FechaNodo")]/PropiedadesyUsuarios/UsuarioPropiedad') as T(Item)

	UPDATE dbo.Propiedad
		SET IdUsuario = U.ID
		FROM Usuario U
		INNER JOIN dbo.Persona P
		ON U.IdPersona = P.ID
		INNER JOIN @PropiedadesyUsuarios PU
		ON P.ValorDocId = PU.ValorDocumentoIdentidad
		INNER JOIN dbo.Propiedad Pr
		ON Pr.NumFinca = PU.NumeroFinca


	-----------Insertar lecturas-------------
	INSERT @MovConsumo(NumeroMedidor, TipoMovimiento, Valor)
    SELECT 
        T.Item.value('@NumeroMedidor','INT'),
		T.Item.value('@TipoMovimiento','VARCHAR(128)'),
		T.Item.value('@Valor','MONEY')
    FROM @xmlOperacion.nodes('/Datos/Operacion[@Fecha=sql:variable("@FechaNodo")]/Lecturas/LecturaMedidor') as T(Item)

	INSERT dbo.MovimientoConsumo(Fecha, Monto, IdTipoMovimiento, IdPropiedadCCAgua)
	SELECT	@fechaItera,
			MC.Valor,
			TM.ID,
			PA.ID
	FROM @MovConsumo MC, dbo.PropiedadCCAgua PA, dbo.TipoMovimientoConsumo TM
	WHERE TM.Nombre = MC.TipoMovimiento
	
	UPDATE dbo.MovimientoConsumo
	SET Monto = -Monto
	WHERE IdTipoMovimiento = 3

	UPDATE dbo.PropiedadCCAgua
	SET SaldoAcumulado = SaldoAcumulado + MC.Monto
	FROM dbo.MovimientoConsumo MC
	WHERE PropiedadCCAgua.ID = MC.IdPropiedadCCAgua
	

	SELECT * FROM dbo.Persona
	SELECT * FROM dbo.Usuario
	SELECT * FROM dbo.Propiedad
	SELECT * FROM dbo.PXP
	SELECT * FROM dbo.PropiedadXCC
	SELECT * FROM dbo.PropiedadCCAgua
	SELECT * FROM dbo.MovimientoConsumo

	DELETE @Persona 
	DELETE @Usuario
	DELETE @Propiedad
	DELETE @PersonasyPropiedades
	DELETE @MovConsumo
    
    SET @fechaItera= (DATEADD(DAY,1,@fechaItera)) --Siguiente

END;

	DELETE dbo.PXP
	DELETE dbo.Persona 
	DELETE dbo.Usuario
	DELETE dbo.Propiedad
	DELETE dbo.PropiedadXCC
	DELETE dbo.PropiedadCCAgua
	DELETE dbo.MovimientoConsumo

	DBCC CHECKIDENT (PXP, RESEED, 0)
	DBCC CHECKIDENT (Persona, RESEED, 0)
    DBCC CHECKIDENT (Usuario, RESEED, 0)
    DBCC CHECKIDENT (Propiedad, RESEED, 0)
	DBCC CHECKIDENT (PropiedadXCC, RESEED, 0)
	DBCC CHECKIDENT (MovimientoConsumo, RESEED, 0)

	
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
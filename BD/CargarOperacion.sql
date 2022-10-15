DECLARE @Fechas TABLE (fechaOperacion DATE);  

DECLARE @Persona TABLE(nombre VARCHAR(128), valorDocId BIGINT, idTipoDoc VARCHAR(128), email VARCHAR(128), telefono1 BIGINT, telefono2 BIGINT);
DECLARE @Propiedad TABLE(NumeroFinca INT,MetrosCuadrados INT,tipoUsoPropiedad VARCHAR(128),tipoZonaPropiedad VARCHAR(128),NumeroMedidor INT,ValorFiscal INT)


----Declaracion de variables----
DECLARE @fechaItera DATE, @fechaFin DATE, @lo INT,@hi INT; -- una DECLARE siempre termina en ;
DECLARE @fechaNodo VARCHAR(20);
DECLARE @xmlOperacion xml;


SET @xmlOperacion = (SELECT *FROM OPENROWSET(BULK 'C:\Users\Usuario\Downloads\Operaciones.xml', SINGLE_BLOB) AS x) --Cargamos archivos de forma masiva

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
    INSERT @Persona(nombre , valorDocId, idTipoDoc , email, telefono1, telefono2)
    SELECT T.Item.value('@Nombre','VARCHAR(128)'),
        T.Item.value('@ValorDocumentoIdentidad','BIGINT'),
        T.Item.value('@TipoDocumentoIdentidad','VARCHAR(128)'),
        T.Item.value('@Email','VARCHAR(128)'),
        T.Item.value('@Telefono1','BIGINT'),
        T.Item.value('@Telefono2','BIGINT')
    FROM @xmlOperacion.nodes('/Datos/Operacion[@Fecha=sql:variable("@FechaNodo")]/Personas/Persona') as T(Item)
	BEGIN TRANSACTION insertarPersona

	--INSERT dbo.Persona(Nombre,ValorDocId,IdTipoDoc,email,telefono1,telefono2)
	SELECT 
		p.nombre,
		p.valorDocId,
		d.ID,
		p.email,
		p.telefono1,
		p.telefono2
	FROM @Persona p
	INNER JOIN dbo.TipoDocIdent d
	ON p.idTipoDoc = d.Nombre

	COMMIT TRANSACTION insertarPersona
	--SELECT * FROM @Persona
	
	-----------Insertar Propiedades-------------
	
    INSERT @Propiedad TABLE(NumeroFinca ,MetrosCuadrados ,tipoUsoPropiedad ,tipoZonaPropiedad ,NumeroMedidor ,ValorFiscal )

    SELECT T.Item.value('@NumeroFinca','INT'),
        T.Item.value('@MetrosCuadrados','FLOAT'),
        T.Item.value('@tipoUsoPropiedad','VARCHAR(128)'),
        T.Item.value('@tipoZonaPropiedad','VARCHAR(128)'),
        T.Item.value('@NumeroMedidor','INT'),
        T.Item.value('@ValorFiscal','INT')
    FROM @xmlOperacion.nodes('/Datos/Operacion[@Fecha=sql:variable("@FechaNodo")]/Propiedades/Propiedad') as T(Item)
	BEGIN TRANSACTION insertarPropiedad

	INSERT dbo.Propiedad(ID
	SELECT 
		p.NumeroFinca,

	FROM @Propiedad p
		INNER JOIN dbo.TipoTerreno t ON t.Nombre = p.tipoUsoPropiedad
		INNER JOIN dbo.TipoZona z ON z.Nombre = p.tipoZonaPropiedad	

	COMMIT TRANSACTION insertarPropiedad



	DELETE @Persona 
    
    SET @fechaItera= (DATEADD(DAY,1,@fechaItera)) --Siguiente



END;

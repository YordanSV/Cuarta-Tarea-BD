USE [SegundaTarea]

DECLARE @Fechas TABLE (fechaOperacion DATE);  

DECLARE @Persona TABLE(nombre VARCHAR(128), valorDocId BIGINT, idTipoDoc VARCHAR(128), email VARCHAR(128), telefono1 BIGINT, telefono2 BIGINT);

----Declaracion de variables----
DECLARE @fechaItera DATE, @fechaFin DATE, @lo INT,@hi INT; -- una DECLARE siempre termina en ;
DECLARE @fechaNodo VARCHAR(20);
DECLARE @xmlOperacion xml;


SET @xmlOperacion = (SELECT *FROM OPENROWSET(BULK 'C:\Users\jburg\OneDrive\Escritorio\Jose_Pablo\TEC\2022\II_Semestre\Bases de Datos I\Tareas\Tarea 2\xml\Operaciones.xml', SINGLE_BLOB) AS x) --Cargamos archivos de forma masiva

DECLARE @hdoc int;  
EXEC sp_xml_preparedocument @hdoc OUTPUT, @xmlOperacion
INSERT @Fechas(fechaOperacion)
SELECT Fecha = CONVERT(DATE,Fecha,103)
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

    SET @fechaNodo = CONVERT(VARCHAR(20),@fechaItera,105) --Necesitamos un aux para leer @fechaItera como tipo VARCHAR
		
    ----Nuevo Empleado-----
    INSERT @Persona(nombre , valorDocId, idTipoDoc , email, telefono1, telefono2)
    SELECT T.Item.value('@Nombre','VARCHAR(128)'),
        T.Item.value('@ValorDocumentoIdentidad','BIGINT'),
        T.Item.value('@TipoDocumentoIdentidad','VARCHAR(128)'),
        T.Item.value('@Email','VARCHAR(128)'),
        T.Item.value('@Telefono1','BIGINT'),
        T.Item.value('@Telefono2','BIGINT')
    FROM @xmlOperacion.nodes('/Datos/Operacion[@Fecha=sql:variable("@FechaNodo")]/Personas/Persona') as T(Item)
	BEGIN TRANSACTION insertarPersona

	SELECT 
		p.nombre,
		p.valorDocId,
		d.ID,
		p.email,
		p.telefono1,
		p.telefono2
	FROM @Persona p
	INNER JOIN TipoDocIdent d
	ON p.idTipoDoc = d.Nombre;

	COMMIT TRANSACTION insertarPersona
	--SELECT * FROM @Persona

	DELETE @Persona 
    
    SET @fechaItera= (DATEADD(DAY,1,@fechaItera)) --Siguiente
END;

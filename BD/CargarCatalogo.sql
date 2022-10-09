USE [SegundaTarea]


DECLARE @hdoc int;  
DECLARE @info xml;
SET @info = (SELECT *FROM OPENROWSET(BULK 'C:\Users\jburg\OneDrive\Escritorio\Jose_Pablo\TEC\2022\II_Semestre\Bases de Datos I\Tareas\Tarea 2\xml\Catalogo.xml', SINGLE_BLOB) AS x) --Cargamos archivos de forma masiva
EXEC sp_xml_preparedocument @hdoc OUTPUT, @info


DELETE dbo.TipoDocIdent
DBCC CHECKIDENT(TipoDocIdent, RESEED, 0)
DELETE dbo.TipoMovimientoConsumo
DBCC CHECKIDENT(TipoMovimientoConsumo, RESEED, 0)
DELETE dbo.TipoTerreno
DBCC CHECKIDENT(TipoTerreno, RESEED, 0)
DELETE dbo.TipoZona
DBCC CHECKIDENT(TipoZona, RESEED, 0)
DELETE dbo.ConceptoCobro
DBCC CHECKIDENT(ConceptoCobro, RESEED, 0)
----------------Insertar ClaseArticulo...........................

INSERT dbo.TipoMovimientoConsumo(Nombre)
SELECT T.Item.value('@Nombre','VARCHAR(32)')
FROM @info.nodes('/Catalogo/TipodeMovimientoLecturadeMedidores/TipodeMovimientoLecturadeMedidor') as T(Item)


INSERT dbo.TipoTerreno(Nombre)
SELECT T.Item.value('@Nombre','VARCHAR(32)')
FROM @info.nodes('/Catalogo/TipoUsoPropiedades/TipoUsoPropiedad') as T(Item)


INSERT dbo.TipoZona(Nombre)
SELECT T.Item.value('@Nombre','VARCHAR(32)')
FROM @info.nodes('/Catalogo/TipoZonaPropiedades/TipoZonaPropiedad') as T(Item)


INSERT dbo.TipoDocIdent(Nombre)
SELECT T.Item.value('@Nombre','VARCHAR(32)')
FROM @info.nodes('/Catalogo/TipoDocumentoIdentidades/TipoDocumentoIdentidad') as T(Item)


INSERT dbo.ConceptoCobro(Nombre)
SELECT T.Item.value('@Nombre','VARCHAR(32)')
FROM @info.nodes('/Catalogo/TipoMedioPagos/TipoMedioPago') as T(Item)



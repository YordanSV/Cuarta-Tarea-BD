USE [TerceraTarea]


DECLARE @hdoc int;  
DECLARE @info xml;
SET @info = (SELECT *FROM OPENROWSET(BULK 'C:\Users\Usuario\Downloads\Catalogo.xml', SINGLE_BLOB) AS x) --Cargamos archivos de forma masiva
EXEC sp_xml_preparedocument @hdoc OUTPUT, @info


DELETE dbo.TipoMovimientoConsumo
DELETE dbo.TipoTerreno
DELETE dbo.TipoZona
DELETE dbo.TipoDocIdent
DELETE dbo.TipoAsociacion
DELETE dbo.TipoMedioPago
DELETE dbo.CCAgua
DELETE dbo.CCImpPropiedad
DELETE dbo.CCBasura
DELETE dbo.CCPatente
DELETE dbo.CCReconexion
DELETE dbo.CCIntMoratorios
DELETE dbo.CCMantParques
DELETE dbo.ConceptoCobro
DELETE dbo.PeriodoMontoCC
DELETE dbo.TipoMontoCC
DELETE dbo.ParametroSistema
DELETE dbo.TipoParametroSistema

----------------Insertar ClaseArticulo...........................

INSERT dbo.TipoMovimientoConsumo(ID, Nombre)
SELECT T.Item.value('@id','INT')
	 , T.Item.value('@Nombre','VARCHAR(128)')
FROM @info.nodes('/Catalogo/TipodeMovimientoLecturadeMedidores/TipodeMovimientoLecturadeMedidor') as T(Item)

INSERT dbo.TipoTerreno(ID, Nombre)
SELECT T.Item.value('@id','INT')
     , T.Item.value('@Nombre','VARCHAR(128)')
FROM @info.nodes('/Catalogo/TipoUsoPropiedades/TipoUsoPropiedad') as T(Item)

INSERT dbo.TipoZona(ID, Nombre)
SELECT T.Item.value('@id','INT')
	 , T.Item.value('@Nombre','VARCHAR(128)')
FROM @info.nodes('/Catalogo/TipoZonaPropiedades/TipoZonaPropiedad') as T(Item)

INSERT dbo.TipoDocIdent(ID, Nombre, Mascara)
SELECT T.Item.value('@id','INT')
	 , T.Item.value('@Nombre','VARCHAR(128)')
	 , T.Item.value('@Mascara','VARCHAR(128)')
FROM @info.nodes('/Catalogo/TipoDocumentoIdentidades/TipoDocumentoIdentidad') as T(Item)

INSERT dbo.TipoAsociacion(ID, Nombre)
SELECT T.Item.value('@id','INT')
     , T.Item.value('@Nombre','VARCHAR(128)')
FROM @info.nodes('/Catalogo/TipoAsociaciones/TipoAsociacion') as T(Item)

INSERT dbo.TipoMedioPago(ID, Nombre)
SELECT T.Item.value('@id','INT')
     , T.Item.value('@Nombre','VARCHAR(128)')
FROM @info.nodes('/Catalogo/TipoMedioPagos/TipoMedioPago') as T(Item)

INSERT dbo.PeriodoMontoCC(ID, Nombre, QMeses)
SELECT T.Item.value('@id','INT')
	 , T.Item.value('@Nombre','VARCHAR(128)')
	 , T.Item.value('@QMeses','INT')
FROM @info.nodes('/Catalogo/PeriodoMontoCCs/PeriodoMontoCC') as T(Item)

INSERT dbo.TipoMontoCC(ID, Nombre)
SELECT T.Item.value('@id','INT')
     , T.Item.value('@Nombre','VARCHAR(128)')
FROM @info.nodes('/Catalogo/TipoMontoCCs/TipoMontoCC') as T(Item)

INSERT dbo.TipoParametroSistema(ID, Nombre)
SELECT T.Item.value('@id','INT')
     , T.Item.value('@Nombre','VARCHAR(128)')
FROM @info.nodes('/Catalogo/TipoParametroSistema/TipoParametro') as T(Item)

INSERT dbo.ParametroSistema(ID, Nombre, Valor, IdTipoParametro)
SELECT T.Item.value('@id','INT')
	 , T.Item.value('@Nombre','VARCHAR(128)')
	 , T.Item.value('@Valor','INT')
	 , TPS.ID
FROM @info.nodes('/Catalogo/ParametrosSistema/ParametroSistema') as T(Item)
INNER JOIN dbo.TipoParametroSistema TPS
ON TPS.Nombre = T.Item.value('@NombreTipoPar','VARCHAR(128)')

INSERT dbo.ConceptoCobro(
	ID
  , Nombre
  , IdTipoMonto
  , IdPeriodoMonto
  )
SELECT
	T.Item.value('@id','INT')
  , T.Item.value('@Nombre','VARCHAR(128)')
  , T.Item.value('@TipoMontoCC','INT')
  , T.Item.value('@PeriodoMontoCC','INT')
FROM @info.nodes('/Catalogo/CCs/CC') as T(Item)

INSERT dbo.CCAgua(
	ID
  , ValorMinimo
  , ValorMinimoM3
  , ValorM3
  , ValorFijoAdicionalM3
  )
SELECT
	T.Item.value('@id','INT')
  , T.Item.value('@ValorMinimo','INT')
  , T.Item.value('@ValorMinimoM3','INT')
  , T.Item.value('@Valorm3','INT')
  , T.Item.value('@ValorFijoM3Adicional','INT')
FROM @info.nodes('/Catalogo/CCs/CC') as T(Item)
WHERE T.Item.value('@id','INT') = 1

INSERT dbo.CCImpPropiedad(
	ID
  , ValorPorcentual
  )
SELECT
	T.Item.value('@id','INT')
  , T.Item.value('@ValorPorcentual','FLOAT')
FROM @info.nodes('/Catalogo/CCs/CC') as T(Item)
WHERE T.Item.value('@id','INT') = 2

INSERT dbo.CCBasura(
	ID
  , ValorMinimo
  , ValorFijo
  , ValorMinimoM2
  , ValorTractosM2
  )
SELECT
	T.Item.value('@id','INT')
  , T.Item.value('@ValorMinimo','INT')
  , T.Item.value('@ValorFijo','INT')
  , T.Item.value('@ValorM2Minimo','INT')
  , T.Item.value('@ValorTractosM2','INT')
FROM @info.nodes('/Catalogo/CCs/CC') as T(Item)
WHERE T.Item.value('@id','INT') = 3

INSERT dbo.CCPatente(
	ID
  , ValorFijo
  )
SELECT
	T.Item.value('@id','INT')
  , T.Item.value('@ValorFijo','INT')
FROM @info.nodes('/Catalogo/CCs/CC') as T(Item)
WHERE T.Item.value('@id','INT') = 4

INSERT dbo.CCReconexion(
	ID
  , ValorFijo
  )
SELECT
	T.Item.value('@id','INT')
  , T.Item.value('@ValorFijo','INT')
FROM @info.nodes('/Catalogo/CCs/CC') as T(Item)
WHERE T.Item.value('@id','INT') = 5

INSERT dbo.CCIntMoratorios(
	ID
  , ValorFijo
  , ValorPorcentual
  )
SELECT
	T.Item.value('@id','INT')
  , T.Item.value('@ValorFijo','INT')
  , T.Item.value('@ValorPorcentual','FLOAT')
FROM @info.nodes('/Catalogo/CCs/CC') as T(Item)
WHERE T.Item.value('@id','INT') = 6

INSERT dbo.CCMantParques(
	ID
  , ValorFijo
  , ValorPorcentual
  )
SELECT
	T.Item.value('@id','INT')
  , T.Item.value('@ValorFijo','INT')
  , T.Item.value('@ValorPorcentual','FLOAT')
FROM @info.nodes('/Catalogo/CCs/CC') as T(Item)
WHERE T.Item.value('@id','INT') = 7
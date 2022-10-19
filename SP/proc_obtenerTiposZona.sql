USE [SegundaTarea]
GO
/****** Object:  StoredProcedure [dbo].[proc_obtenerTiposZona]    Script Date: 19/10/2022 00:20:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_obtenerTiposZona]
	@outResult INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	SELECT TZ.Nombre
	FROM dbo.TipoZona tZ
	ORDER BY TZ.Nombre
	SET NOCOUNT OFF;
END;


USE [SegundaTarea]
GO
/****** Object:  StoredProcedure [dbo].[proc_obtenerTiposTerreno]    Script Date: 19/10/2022 00:19:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_obtenerTiposTerreno]
	@outResult INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	SELECT TT.Nombre
	FROM dbo.TipoTerreno TT
	ORDER BY TT.Nombre
	SET NOCOUNT OFF;
END;


USE [SegundaTarea]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[proc_tblPropiedades]
AS
BEGIN
	SET NOCOUNT ON;
	SELECT P.ID, P.ValorFiscal, P.Area, P.FechaRegistro, TZ.Nombre, TT.Nombre
	FROM dbo.Propiedad P
	INNER JOIN dbo.TipoZona TZ
	ON TZ.ID = P.IdTipoZona
	INNER JOIN dbo.TipoTerreno TT
	ON TT.ID = P.IdTipoTerreno
END
GO

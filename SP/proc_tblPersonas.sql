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
CREATE PROCEDURE [dbo].[proc_tblPersonas]
AS
BEGIN
	SET NOCOUNT ON;
	SELECT P.ID, P.Nombre, TDI.Nombre, P.ValorDocId, P.email, P.telefono1, P.telefono2
	FROM dbo.Persona P
	INNER JOIN dbo.TipoDocIdent TDI
	ON P.IdTipoDoc = TDI.ID
END
GO

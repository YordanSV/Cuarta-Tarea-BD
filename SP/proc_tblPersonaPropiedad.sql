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
CREATE PROCEDURE [dbo].[proc_tblPersonaPropiedad]
AS
BEGIN
	SET NOCOUNT ON;
	SELECT PP.ID, P.Nombre, Pr.ValorFiscal
	FROM dbo.PXP PP
	INNER JOIN dbo.Persona P
	ON P.ID = PP.IdPersona
	INNER JOIN dbo.Propiedad Pr
	ON Pr.ID = PP.IdPropiedad
END
GO

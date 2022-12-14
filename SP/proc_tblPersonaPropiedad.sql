USE [SegundaTarea]
GO
/****** Object:  StoredProcedure [dbo].[proc_tblPersonaPropiedad]    Script Date: 19/10/2022 00:21:15 ******/
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
	SELECT PP.ID, P.Nombre, Pr.NumFinca, Pr.ID
	FROM dbo.PXP PP
	INNER JOIN dbo.Persona P
	ON P.ID = PP.IdPersona
	INNER JOIN dbo.Propiedad Pr
	ON Pr.ID = PP.IdPropiedad
END

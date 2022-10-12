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
CREATE PROCEDURE [dbo].[proc_tblUsuarioPropiedad]
AS
BEGIN
	SET NOCOUNT ON;
	SELECT P.Nombre, Pr.ID
	FROM dbo.Propiedad Pr
	INNER JOIN Usuario U
	ON U.ID = Pr.IdUsuario
	INNER JOIN dbo.Persona P
	ON P.ID = U.IdPersona
END
GO

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
CREATE PROCEDURE [dbo].[proc_tblUsuarios]
AS
BEGIN
	SET NOCOUNT ON;
	SELECT U.ID, U.UserName, U.[Password], U.TipoUsuario
	FROM dbo.Usuario U
END
GO

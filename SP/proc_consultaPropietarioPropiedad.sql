USE [SegundaTarea]
GO
/****** Object:  StoredProcedure [dbo].[proc_filtrarNombre]    Script Date: 6/9/2022 19:32:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[proc_consultaPropietarioPropiedad](
	@inNumFinca INT,
	@outResult INT OUTPUT
	) AS
BEGIN
	SELECT P.ID, P.Nombre, TDI.Nombre, P.ValorDocId, P.email, P.telefono1, P.telefono2
	FROM dbo.Persona P
	INNER JOIN dbo.TipoDocIdent TDI
	ON P.IdTipoDoc = TDI.ID
	WHERE P.ID = 
	(
		SELECT U.IdPersona
		FROM dbo.Usuario U
		WHERE U.TipoUsuario = 'Propietario'
		AND U.ID =
		(
			SELECT Pr.IdUsuario
			FROM Propiedad Pr
			WHERE Pr.ID = @inNumFinca
		)
	)

	
	
END;

--EXEC [proc_consultaPropietarioPropiedad]  1033, 0


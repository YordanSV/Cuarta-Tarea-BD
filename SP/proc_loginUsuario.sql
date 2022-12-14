USE [SegundaTarea]
GO
/****** Object:  StoredProcedure [dbo].[proc_loginUsuario]    Script Date: 19/10/2022 00:18:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[proc_loginUsuario] (
	@inNombre VARCHAR(32),
	@inClave VARCHAR(32),
	@outResult INT OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON;
	SET @outResult=0;
	
	IF NOT EXISTS
	(
		SELECT 1
		FROM Usuario U
		WHERE U.[UserName] = @inNombre
		AND U.[Password] = @inClave
	)
	BEGIN
		SET @outResult = 6000; -- credenciales incorrectos
		RAISERROR('Credenciales incorrectos',10,1) WITH NOWAIT;
		SELECT @outResult
		RETURN;
	END;

	IF EXISTS
	(
		SELECT 1
		FROM Usuario U
		WHERE U.[UserName] = @inNombre
		AND U.[Password] = @inClave
		AND U.[TipoUsuario] = 'Administrador'
	)
	BEGIN
		SET @outResult = 1; -- credenciales incorrectos
		SELECT @outResult
		RETURN;
	END;

	IF EXISTS
	(
		SELECT 1
		FROM Usuario U
		WHERE U.[UserName] = @inNombre
		AND U.[Password] = @inClave
		AND U.[TipoUsuario] = 'Propietario'
	)
	BEGIN
		SET @outResult = 2; -- credenciales incorrectos
		SELECT @outResult
		RETURN;
	END;

	-- selecciona todos los resultados que coincidan
	--SELECT
	--@outResult AS ExitCode,
	--U.[UserName],
	--U.[id]
	--FROM [dbo].Usuario AS U
	--WHERE	U.[UserName] = @inNombre
	--		AND U.[Password] = @inClave
	
	SET NOCOUNT OFF;
END;

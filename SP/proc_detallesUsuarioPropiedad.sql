USE [SegundaTarea]
GO
/****** Object:  StoredProcedure [dbo].[proc_detallesUsuarioPropiedad]    Script Date: 19/10/2022 00:10:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_detallesUsuarioPropiedad]
	@inId INT,
	@outResult INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		SET @outResult=0;
		DECLARE @fecha DATE;
		SET @fecha = GETDATE()

		BEGIN TRANSACTION tDetallesUsuarioPropiedad
			SELECT P.Nombre, Pr.NumFinca
			FROM dbo.Propiedad Pr
			INNER JOIN dbo.Usuario U
			ON U.ID = Pr.IdUsuario
			INNER JOIN dbo.Persona P
			ON P.ID = U.IdPersona
			WHERE Pr.ID = @inId
		COMMIT TRANSACTION tDetallesUsuarioPropiedad
	END TRY

	BEGIN CATCH		
		IF @@TRANCOUNT> 0
		BEGIN
			ROLLBACK TRANSACTION tDetallesUsuarioPropiedad;
		END;
		INSERT INTO dbo.DBErrors(
		 [UserName]
		, [ErrorNumber]
		, [ErrorState]
		, [ErrorSeverity]
		, [ErrorLine]
		, [ErrorProcedure]
		, [ErrorMessage]
		, [ErrorDateTime])
		VALUES (
			SUSER_SNAME(),
			ERROR_NUMBER(),
			ERROR_STATE(),
			ERROR_SEVERITY(),
			ERROR_LINE(),
			ERROR_PROCEDURE(),
			ERROR_MESSAGE(),
			GETDATE()
		);
		Set @outResult=50007;
	END CATCH
	SET NOCOUNT OFF;
END;


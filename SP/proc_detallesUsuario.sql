USE [SegundaTarea]
GO
/****** Object:  StoredProcedure [dbo].[proc_detallesUsuario]    Script Date: 19/10/2022 00:09:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_detallesUsuario]
	@inId INT,
	@outResult INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		SET @outResult=0;
		
		BEGIN TRANSACTION tDetallesUsuario
			SELECT U.UserName, U.[Password], U.TipoUsuario, P.Nombre
			FROM dbo.Usuario U
			INNER JOIN dbo.Persona P
			ON P.ID = U.IdPersona
			WHERE U.ID = @inId
		COMMIT TRANSACTION tDetallesUsuario	
	END TRY

	BEGIN CATCH		
		IF @@TRANCOUNT> 0
		BEGIN
			ROLLBACK TRANSACTION tDetallesUsuario;
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


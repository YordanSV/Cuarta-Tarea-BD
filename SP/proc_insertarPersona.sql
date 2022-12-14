USE [SegundaTarea]
GO
/****** Object:  StoredProcedure [dbo].[proc_insertarPersona]    Script Date: 19/10/2022 00:16:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_insertarPersona]
	@inNombre VARCHAR(128),	 
	@inValorDocId BIGINT,
	@inTipoDoc VARCHAR(128),
	@inEmail VARCHAR(128),
	@inTele1 BIGINT,
	@inTele2 BIGINT,
	@outResult INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		SET @outResult=0;
		DECLARE @idTipoDoc INT;
		SELECT @idTipoDoc = T.ID
		FROM dbo.TipoDocIdent T
		WHERE T.Nombre = @inTipoDoc;
		IF NOT EXISTS (SELECT 1 FROM dbo.Persona P WHERE P.ValorDocId = @inValorDocId)
			BEGIN
				BEGIN TRANSACTION tInsertarPersona
					INSERT INTO [dbo].[Persona] (
					Nombre
					, ValorDocId
					, IdTipoDoc
					, email
					, telefono1
					, telefono2
					)
					VALUES (
					@inNombre
					, @inValorDocId
					, @idTipoDoc
					, @inEmail
					, @inTele1
					, @inTele2
					)
				COMMIT TRANSACTION tInsertarPersona
			END
		ELSE
			SET @outResult=50008;
	END TRY

	BEGIN CATCH		
		IF @@TRANCOUNT> 0
		BEGIN
			ROLLBACK TRANSACTION tInsertarPersona;
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


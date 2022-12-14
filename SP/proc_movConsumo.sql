USE [CuartaTarea]
GO
/****** Object:  StoredProcedure [dbo].[proc_editarUsuario]    Script Date: 24/11/2022 21:34:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[proc_movConsumo]
	@inTblMovConsumo TableTypeMovConsumo READONLY
  , @inFecha DATE
  , @outResult INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		SET @outResult=0;
		BEGIN TRANSACTION tMovConsumo
			INSERT dbo.MovimientoConsumo(Fecha, Monto, IdTipoMovimiento, IdPropiedadCCAgua)
			SELECT	@inFecha,
					MC.Valor,
					TM.ID,
					PA.ID
			FROM @inTblMovConsumo MC
			INNER JOIN dbo.PropiedadCCAgua PA ON PA.NumeroMedidor = MC.NumeroMedidor
			INNER JOIN dbo.TipoMovimientoConsumo TM ON TM.Nombre = MC.TipoMovimiento

			UPDATE dbo.MovimientoConsumo
			SET Monto = Monto * -1
			WHERE IdTipoMovimiento = 3

			UPDATE dbo.PropiedadCCAgua
			SET SaldoAcumulado = MC.Monto
			FROM dbo.MovimientoConsumo MC
			INNER JOIN dbo.PropiedadXCC PCC ON PCC.ID = MC.IdPropiedadCCAgua
			INNER JOIN Propiedad P ON P.ID = PCC.IdPropiedad
			WHERE MC.IdTipoMovimiento = 1

			UPDATE dbo.PropiedadCCAgua
			SET SaldoAcumulado = SaldoAcumulado + MC.Monto
			FROM dbo.MovimientoConsumo MC
			INNER JOIN dbo.PropiedadXCC PCC ON PCC.ID = MC.IdPropiedadCCAgua
			INNER JOIN Propiedad P ON P.ID = PCC.IdPropiedad
			WHERE MC.IdTipoMovimiento = 2 OR MC.IdTipoMovimiento = 3
		COMMIT TRANSACTION tMovConsumo
	END TRY

	BEGIN CATCH		
		IF @@TRANCOUNT> 0
		BEGIN
			ROLLBACK TRANSACTION tMovConsumo;
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


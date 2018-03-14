SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ing. Alejandro Grijalva Antonio
-- Create date: 2018-02-16
-- Description:	Se guarda en Tabla Provisión los 
-- detalles de cada DOCUMENTO.
-- =============================================
ALTER PROCEDURE [dbo].[GUARDAPROVISION_SP]
	@idEmpresa INT					= 0,
	@idSucursal INT					= 0,
	@idFinanciera INT				= 0,
	@CCP_IDDOCTO VARCHAR(20)		= '',
	@consecutivo NUMERIC(18,0)		= 0,
	@saldoDocumento NUMERIC(18,0)	= 0,
	@interesCalculado NUMERIC(18,0) = 0,
	@interesAplicar NUMERIC(18,0)	= 0,
	@aplica INT						= 0
AS
BEGIN
	BEGIN TRY	
		DECLARE @LastId INT;
		DECLARE @validateCons INT;
		
		IF( @consecutivo = 0 )
			BEGIN
				SET @validateCons = 1;
				SET @consecutivo  = (	SELECT CASE WHEN MAX(consecutivo) IS NULL
													THEN 1
													ELSE  MAX(consecutivo) + 1
												END
										FROM Provision WHERE idEmpresa = @idEmpresa
									 );
			END
		ELSE
			BEGIN
				IF EXISTS( SELECT idProvision FROM Provision WHERE consecutivo = @consecutivo AND idEmpresa = @idEmpresa AND estatus = 0 )
					BEGIN
						SET @validateCons = 1;
					END
				ELSE
					BEGIN
						SET @validateCons = 0;
					END
				
			END
		
		IF ( @validateCons = 1 )
			BEGIN
				INSERT INTO [Provision] (
											[idEmpresa],
											[idSucursal],
											[idFinanciera],
											[CCP_DOCUMENTO],
											[consecutivo],
											[saldoDocumento],
											[interesCalculado],
											[interesAplicar],
											[fechaEntrada],
											[estatus] 
										)
				VALUES	(
							@idEmpresa,
							@idSucursal,
							@idFinanciera,
							@CCP_IDDOCTO,
							@consecutivo,
							@saldoDocumento,
							@interesCalculado,
							@interesAplicar,
							GETDATE(),
							0
						);
				
				SET @LastId = @@IDENTITY;
				
				IF( @aplica = 1 )
					BEGIN
						-- SE EJECUTARA EL VACIADO A TABLAS DE BRPO
						UPDATE Provision SET estatus = 1 WHERE consecutivo = @consecutivo; 
						EXECUTE [dbo].[PROCESAPROVISIO_SP] @consecutivo;
						SELECT success = 1, code = 2, msg='Se ha procesado correctamente la Provisión.', consecutivo = @consecutivo;
					END
				ELSE
					BEGIN
						SELECT success = 1, code = 1, msg='Interes registrado correctamente.', consecutivo = @consecutivo;
					END
			END
		ELSE
			BEGIN
				SELECT success = 0, code = 0, msg='Hay un problema con la integridad de datos a guardar.';
			END
	END TRY
	BEGIN CATCH	
		DELETE FROM Provision WHERE consecutivo = @consecutivo;
		SELECT success = 0, code = ERROR_NUMBER(), msg = ERROR_MESSAGE();
	END CATCH
END
GO

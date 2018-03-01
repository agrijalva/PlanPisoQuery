SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ing. Alejandro Grijalva Antonio
-- Create date: 2018-02-21
-- Description:	Guarda en temporal los registros del layout
-- =============================================
ALTER PROCEDURE [dbo].[TEMPORALLAYOUT_SP]
	@numeroSerie [varchar](25)	= '',
	@valor [numeric](18, 4)		= 0,
	@interes [numeric](18, 4)	= 0,
	@consecutivo [int]			= 0
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @validateCons INT = 0;
	IF( @consecutivo = 0 )
		BEGIN
			SET @validateCons = 1;
			SET @consecutivo  = (	SELECT CASE WHEN MAX(consecutivo) IS NULL
												THEN 1
												ELSE  MAX(consecutivo) + 1
											END
									FROM TmpExcelData
								 );
		END
	ELSE
		BEGIN
			IF EXISTS( SELECT consecutivo FROM TmpExcelData WHERE consecutivo = @consecutivo )
				BEGIN
					SET @validateCons = 1;
				END
			ELSE
				BEGIN
					SET @validateCons = 0;
				END
			
		END
	
	IF( @validateCons = 1) 
		BEGIN			
			INSERT INTO TmpExcelData(numeroSerie, valor, interes, consecutivo, fecha) VALUES( @numeroSerie, @valor, @interes, @consecutivo, GETDATE() );
			SELECT success = 1, @consecutivo consecutivo;
		END
	ELSE
		BEGIN
			SELECT success = 0;
		END
END
GO

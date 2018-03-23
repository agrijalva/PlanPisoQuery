SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ing. Alejandro Grijalva Antonio
-- Create date: 2018-03-14
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[CONC_VALIDAEXISTENCIA_SP]
	@idEmpresa INT = 0, @idFinanciera INT = 0, @periodo INT = 0, @anio INT = 0
AS
BEGIN
	IF EXISTS(SELECT idConciliacion FROM conciliacion WHERE idEmpresa = @idEmpresa AND idFinanciera = @idFinanciera AND periodo = @periodo AND anio = @anio)
		BEGIN 
			SELECT success = 0, msg = 'Ya existe una conciliación para este periodo y financiera';
		END
	ELSE
		BEGIN
			--SELECT success = 0, msg = 'Ya existe una conciliación para este periodo y financiera';
			SELECT success = 1;
		END
END
GO

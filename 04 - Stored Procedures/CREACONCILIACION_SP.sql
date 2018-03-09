SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		ing. Alejandro Grijalva Antonio
-- Create date: 2018-03-05
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[CREACONCILIACION_SP]
	@idEmpresa INT		= 0,
	@idFinanciera INT	= 0,
	@periodo INT		= 0,
	@periodoAnio INT	= 0,
	@idUsuario INT		= 0
AS
BEGIN
	INSERT INTO [dbo].[conciliacion]([idEmpresa],[idFinanciera],[periodo],[anio],[idUsuario],[fechaCreacion],[estatus])
	SELECT  [idEmpresa]		= @idEmpresa,
			[idFinanciera]	= @idFinanciera,
			[periodo]		= @periodo,
			[anio]			= @periodoAnio,
			[idUsuario]		= @idUsuario,
			[fechaCreacion] = GETDATE(),
			[estatus]		= 1;
			
	SELECT success = 1, msg = 'Inserción correcta', LastId = @@IDENTITY;
END
GO
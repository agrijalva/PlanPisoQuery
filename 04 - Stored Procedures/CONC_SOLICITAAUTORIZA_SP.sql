SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ing. Alejandro Grijalva Antonio
-- Create date: 2018-03-06
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[CONC_SOLICITAAUTORIZA_SP]
	@consecutivo	 INT = 0,
	@estatus		 INT = 1,
	@idUsuario		 INT = 0,
	@idFinanciera	 INT = 0,
	@periodoContable INT = 0,
	@anioContable	 INT = 0
AS
BEGIN
	INSERT INTO [dbo].[autorizaConciliacion]( [idFinanciera],
											  [periodoContable],
											  [anio],
											  [consecutivo],
											  [estatus],
											  [idUsuarioSolicita],
											  [fechaSolicitud],
											  [idUsuarioAutoriza],
											  [fechaAutoriza],
											  [token] )
	SELECT
		[idFinanciera]		= @idFinanciera,
		[periodoContable]   = @periodoContable,
		[anio]				= @anioContable,
		[consecutivo]		= @consecutivo,		
		[estatus]			= @estatus,
		[idUsuarioSolicita]	= @idUsuario,
		[fechaSolicitud]	= GETDATE(),
		[idUsuarioAutoriza]	= NULL,
		[fechaAutoriza]		= NULL,
		[token]				= CONVERT(VARCHAR(32), HashBytes('MD5', CONVERT(VARCHAR(20),@consecutivo)), 2);

	SELECT success = 1, msg = 'Se ha solicitado la autorización de forma correcta', LastId = @@IDENTITY;
END
GO

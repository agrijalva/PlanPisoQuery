SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ing. Alejandro Grijalva Antonio
-- Create date: 2018-03-06
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[CONC_AUTORIZA_SP]
	@token VARCHAR(32)	= '',
	@autoriza INT		= 0,
	@idUsuario INT		= 0
AS
BEGIN
	IF EXISTS(SELECT idAutorizaConciliacion FROM autorizaConciliacion WHERE token = @token AND estatus = 1)
		BEGIN
			UPDATE autorizaConciliacion 
			SET estatus				= CASE @autoriza WHEN 0 THEN 0 WHEN 1 THEN 2 ELSE 0 END,
				idUsuarioAutoriza	= @autoriza,
				fechaAutoriza		= GETDATE()
			WHERE token = @token;
			
			SELECT success = 1;
		END
	ELSE
		BEGIN
			SELECT success = 0, mgs = 'La solicitud ya ha sido procesada.';
		END
END
GO


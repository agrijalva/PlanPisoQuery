SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ing. Alejandro Grijalva Antonio
-- Create date: 2018-02-21
-- Description:	Actualizacion de TIIE
-- =============================================
ALTER PROCEDURE [dbo].[ACTUALIZATIIE_SP]
	@idTIIE INT = 0,
	@porcentaje NUMERIC(18,4) = 0
AS
BEGIN
	UPDATE [Tiie] SET porcentaje = @porcentaje WHERE tiieID = @idTIIE;
	SELECT success = 1; 
END
GO

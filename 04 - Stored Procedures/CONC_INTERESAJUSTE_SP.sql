SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ing. Alejandro Grijalva Antonio
-- Create date: 2018-03-21
-- Description:	Inserta nuevo interes conciliado se cancelan los intereses del mes
-- =============================================
ALTER PROCEDURE [dbo].[CONC_INTERESAJUSTE_SP]
	@periodo INT			 = 0,
	@anio INT				 = 0,
	@monto NUMERIC(18,2)	 = 0,
	@CCP_IDDOCTO VARCHAR(50) = ''
AS
BEGIN
	DECLARE @movimientoID INT = 0;
	DECLARE @fecha DATETIME	  = (SELECT DATEADD(month, ((@anio - 1900) * 12) + @periodo, -1))

	SELECT
		@movimientoID = [movimientoID]
	FROM Movimiento WHERE CCP_IDDOCTO = @CCP_IDDOCTO AND active = 1;

	UPDATE Interes SET estatusID = 5 WHERE MONTH(fecha) = @periodo AND YEAR(fecha) = @anio AND estatusID = 3;

	SELECT 
		[movimientoID]		= @movimientoID,
		[porcentajeTiie]	= 0,
		[monto]				= @monto,
		[saldos]			= SALDO,
		[fecha]				= @fecha,
		[estatusID]			= 4,
		[diasrestantes]		= 0
	FROM Documentos WHERE CCP_IDDOCTO = @CCP_IDDOCTO;
END
GO

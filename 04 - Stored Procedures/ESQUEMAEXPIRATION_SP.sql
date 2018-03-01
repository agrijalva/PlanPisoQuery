SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ing. Alejandro Grijalva Antonio
-- Create date: 2018-02-23
-- Description:	Obtiene los esquemas y su estatus de Expiración
-- =============================================
ALTER PROCEDURE [dbo].[ESQUEMAEXPIRATION_SP]
	@idEmpresa INT = 1
AS
BEGIN
	DECLARE @ExpirationDay INT = (	SELECT par_IntVal 
									FROM Parametros 
									WHERE [par_identificador] = 'ExpirationDay' );
									
	DECLARE @ExpirationDate DATE = ( SELECT DATEADD(day, -@ExpirationDay, CONVERT (date, GETDATE())) )
	
	SELECT 
		FIN.[nombre] as Financiera,
		[esquemaID],
		[diasGracia],
		[plazo],
		ESQ.[financieraID],
		ESQ.[nombre],
		[descripcion],
		[interesMoratorio],
		[estatusCID],
		[creadoPor],
		[tasaInteres],
		[fechaInicio],
		[fechaFin],
		[porcentajePenetracion],
		[tipoTiieCID],
		[tiie],
		[fechaCreacion],
		[modificadoPor],
		[fechaModificacion],
		DATEDIFF( DAY, GETDATE(), fechaFin) diasDisponibles
	INTO #EsquemaExpiration
	FROM dbo.Esquema ESQ
	INNER JOIN Financiera FIN ON ESQ.financieraID = FIN.financieraID
	WHERE FIN.empresaID = @idEmpresa;

	SELECT
		*,
		CASE
			WHEN (diasDisponibles) <= 0
				THEN 0
			WHEN (diasDisponibles > 0 AND diasDisponibles <= @ExpirationDay)
				THEN 1
			ELSE 2
		END AS lbl
	FROM #EsquemaExpiration
	ORDER BY lbl ASC;
	DROP TABLE #EsquemaExpiration;
END
GO

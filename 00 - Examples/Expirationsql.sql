DECLARE @ExpirationDay INT = (	SELECT par_IntVal 
								FROM Parametros 
								WHERE [par_identificador] = 'ExpirationDay' );
								
DECLARE @ExpirationDate DATE = ( SELECT DATEADD(day, -@ExpirationDay, CONVERT (date, GETDATE())) )

SELECT 
	[esquemaID],
	[diasGracia],
	[plazo],
	[financieraID],
	[nombre],
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
FROM dbo.Esquema;

SELECT
	*,
	CASE
		WHEN (diasDisponibles) <= 0
			THEN 0
		WHEN (diasDisponibles > 0 AND diasDisponibles <= @ExpirationDay)
			THEN 1
		ELSE 2
	END AS lbl
FROM #EsquemaExpiration;
DROP TABLE #EsquemaExpiration;
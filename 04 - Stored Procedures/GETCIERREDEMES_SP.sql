SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ing. Alejandro Grijalva Antonio
-- Create date: 2018-03-05
-- Description:	
-- =============================================
ALTER PROCEDURE GETCIERREDEMES_SP
	@Periodo INT = 0
AS
BEGIN
	SELECT TOP 1 ple_idplanpiso,ple_idempresa, ple_idsucursal, ple_fechapoliza, CASE WHEN (CON.idConciliacion) IS NULL THEN 0 ELSE CON.idConciliacion END as conciliacion
	FROM [PlanPiso].[dbo].[plp_planpisoenc] PLP
	LEFT JOIN [PlanPiso].[dbo].[conciliacion] CON ON MONTH(ple_fechapoliza) = CON.periodo AND Estatus = 1
	WHERE pro_idtipoproceso = 3
		  AND MONTH(ple_fechapoliza) = @Periodo
	ORDER BY conciliacion DESC;
END
GO

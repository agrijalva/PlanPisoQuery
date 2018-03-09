SELECT
	ROW_NUMBER() OVER(ORDER BY relPolizasCierresMesID ASC) AS Row,
	CON.idConciliacion,
	CON.idEmpresa,
	CON.idFinanciera,
	POL.planpisoID,
	CON.periodo,
	CON.anio,
	CON.estatus,
	DET.CCP_IDDOCTO,
	DET.VIN,
	DET.interesGrupoAndrade,
	DET.interesFinanciera,
	DET.interesAjuste,
	DET.situacion
INTO #temConciliacion
FROM conciliacion CON
INNER JOIN conciliacionDetalle DET ON CON.idConciliacion = DET.idConciliacion
INNER JOIN [PlanPiso].[dbo].[relPolizasCierreMes] POL ON DET.CCP_IDDOCTO = POL.CCP_IDDOCTO
WHERE CON.periodo = 3 AND CON.anio = 2018 AND situacion IN (1,2);

DECLARE @Current INT = 0, @Max INT = 0, @idPlanpiso INT = 0;

SELECT @Current = MIN(Row), @Max = MAX(Row) FROM #temCOnciliacion;
WHILE( @Current <= @Max )
	BEGIN
		SELECT * FROM #temConciliacion WHERE Row = @Current;
		SET @idPlanpiso = ( SELECT planpisoID FROM #temConciliacion WHERE Row = @Current );
		
		INSERT INTO [PlanPiso].[dbo].[plp_planpisoenc]
		SELECT [pro_idtipoproceso]	 = 5,
			   [ple_idempresa]		 = [ple_idempresa],
			   [ple_idsucursal]		 = [ple_idsucursal],
			   [ple_tipopoliza]		 = [ple_tipopoliza],
			   [ple_fechapoliza]	 = GETDATE(),
			   [ple_concepto]		 = REPLACE ( [ple_concepto], 'PROVISION', 'CONCILIACION'),
			   [ple_fechageneracion] = NULL,
			   [ple_conspol]		 = NULL,
			   [ple_mes]			 = NULL,
			   [ple_año]			 = NULL,
			   [ple_estatus]		 = 0 
		FROM [PlanPiso].[dbo].[plp_planpisoenc] 
		WHERE ple_idplanpiso = @idPlanpiso;
		
		INSERT INTO [PlanPiso].[dbo].[plp_planpisodet]
		SELECT [ple_idplanpiso]				= @@IDENTITY,
			   [pld_consecutivo]			= DET.[pld_consecutivo],
			   [pld_numcuenta]				= DET.[pld_numcuenta],
			   [pld_concepto]				= REPLACE ( DET.[pld_concepto], 'PROVISION', 'CONCILIACION'),
			   [pld_cargo]					= DET.[pld_cargo],
			   [pld_abono]					= DET.[pld_abono],
			   [pld_idpersona]				= DET.[pld_idpersona],
			   [pld_iddocumento]			= DET.[pld_iddocumento],
			   [pld_tipodocumento]			= DET.[pld_tipodocumento],
			   [pld_vin]					= DET.[pld_vin],
			   [pld_fechavencimiento]		= DET.[pld_fechavencimiento],
			   [pld_porcentajeiva]			= DET.[pld_porcentajeiva],
			   [pld_afecta]					= GETDATE(),
			   [idProvision]				= DET.[idProvision]
		FROM [PlanPiso].[dbo].[plp_planpisoenc] ENC
		INNER JOIN [PlanPiso].[dbo].[plp_planpisodet] DET ON ENC.ple_idplanpiso = DET.ple_idplanpiso
		WHERE ENC.ple_idplanpiso = @idPlanpiso ORDER BY [pld_idplanpisodet] DESC;
		
		SET @Current = @Current + 1;
	END
DROP TABLE #temConciliacion;






--SELECT
--	ROW_NUMBER() OVER(ORDER BY relPolizasCierresMesID ASC) AS Row,
--	CON.idConciliacion,
--	CON.idEmpresa,
--	CON.idFinanciera AS financieraid,
--	POL.planpisoID,
--	CON.periodo,
--	CON.anio,
--	CON.estatus,
--	DET.CCP_IDDOCTO,
--	DET.VIN,
--	DET.interesGrupoAndrade,
--	DET.interesFinanciera,
--	DET.interesAjuste,
--	DET.situacion
--FROM conciliacion CON
--INNER JOIN conciliacionDetalle DET ON CON.idConciliacion = DET.idConciliacion
--INNER JOIN [PlanPiso].[dbo].[relPolizasCierreMes] POL ON DET.CCP_IDDOCTO = POL.CCP_IDDOCTO
--INNER JOIN @plp_planpisoenc TEMP ON TEMP.CCP_IDDOCTO = DET.CCP_IDDOCTO
--WHERE CON.periodo = 3 AND CON.anio = 2018 AND situacion IN (1,2);
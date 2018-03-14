USE [PlanPiso];
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ing. Alejandro Grijalva Antonio
-- Create date: 2018-03-09
-- Description:	Creacion de provision de conciliación
-- [dbo].[CONC_GENERAPROVISION_SP] 3, 2018
-- =============================================
ALTER PROCEDURE [dbo].[CONC_GENERAPROVISION_SP]
	@periodo INT = 0,
	@anio INT = 0
AS
BEGIN
	--DECLARE @periodo INT = 3;
	--DECLARE @anio INT = 2018;
	
	SET NOCOUNT ON;
	DECLARE @mes NVARCHAR(15)
	SELECT @mes = CASE 
		WHEN MONTH(GETDATE())=1 THEN 'ENERO'
		WHEN MONTH(GETDATE())=2 THEN 'FEBRERO'
		WHEN MONTH(GETDATE())=3 THEN 'MARZO'
		WHEN MONTH(GETDATE())=4 THEN 'ABRIL'
		WHEN MONTH(GETDATE())=5 THEN 'MAYO'
		WHEN MONTH(GETDATE())=6 THEN 'JUNIO'
		WHEN MONTH(GETDATE())=7 THEN 'JULIO'
		WHEN MONTH(GETDATE())=8 THEN 'AGOSTO'
		WHEN MONTH(GETDATE())=9 THEN 'SEPTIEMBRE'
		WHEN MONTH(GETDATE())=10 THEN 'OCTUBRE'
		WHEN MONTH(GETDATE())=11 THEN 'NOVIEMBRE'
		WHEN MONTH(GETDATE())=12 THEN 'DICIEMBRE'
	END

	DECLARE @plp_planpisoenc TABLE(
		rownumber BIGINT,
		empresaid INT,
		sucursalid INT,
		financieraid INT,
		CCP_IDDOCTO VARCHAR(20),
		consecutivo INT,
		interesGrupoAndrade NUMERIC(18,4),
		interesFinanciera NUMERIC(18,4),
		interesAjuste NUMERIC(18,4)
	)

	-- SE OBTIENEN LOS DOCUMENTOS A CONCILIAR
	INSERT INTO @plp_planpisoenc 
	SELECT 
		ROW_NUMBER() OVER(ORDER BY empresaid ASC) AS RowNum,
		empresaID,
		sucursalID = ( SELECT idSucursal FROM Documentos WHERE CCP_IDDOCTO = MOV.CCP_IDDOCTO),
		financieraID,
		MOV.CCP_IDDOCTO,
		cuantos,
		DET.interesGrupoAndrade,
		DET.interesFinanciera,
		DET.interesAjuste
	FROM (
		SELECT  m.empresaID, m.financieraID, m.CCP_IDDOCTO, COUNT(*) cuantos
		FROM [PlanPiso].[dbo].[Movimiento] m 
		GROUP BY m.empresaID, m.financieraID, m.CCP_IDDOCTO ) MOV
	INNER JOIN [PlanPiso].[dbo].[relPolizasCierreMes] POL ON MOV.CCP_IDDOCTO		= POL.CCP_IDDOCTO
	INNER JOIN [PlanPiso].[dbo].[conciliacionDetalle] DET ON DET.CCP_IDDOCTO	= POL.CCP_IDDOCTO
	INNER JOIN [PlanPiso].[dbo].[conciliacion]		  CON ON DET.idConciliacion = CON.idConciliacion
	WHERE	CON.periodo = @periodo
			AND CON.anio = @anio
			AND POL.tipoProcesoId = 3
			AND situacion IN (1,2);

	DECLARE @totalregistos   INT, 
			@icontador       INT ,
			@planPisoIDPadre bigint,
			@ple_idplanpiso  bigint

	SET @icontador = 1 

	SELECT @totalregistos = COUNT(*) FROM @plp_planpisoenc;

	DECLARE @CCP_IDDOCTO VARCHAR(50) = ''

	WHILE @icontador <= @totalregistos 
		BEGIN 
			INSERT INTO [dbo].[plp_planpisoenc]
			         ([pro_idtipoproceso]
			         ,[ple_idempresa]
			         ,[ple_idsucursal]
			         ,[ple_tipopoliza]
			         ,[ple_fechapoliza]
			         ,[ple_concepto]
			         ,[ple_estatus])
			SELECT 
				[pro_idtipoproceso] = 5,
				[ple_idempresa] 	= MOV.empresaID,
				[ple_idsucursal] 	= MOV.sucursalID,
				[ple_tipopoliza] 	= 0,
				[ple_fechapoliza] 	= getdate(),
				[ple_concepto] 		= 'CONCILIACION DE PLAN PISO ' + @mes + ' ' + MOV.CCP_IDDOCTO,
				[ple_estatus] 		= 0
			FROM @plp_planpisoenc MOV
			INNER JOIN financiera FIN ON MOV.financieraID = FIN.financieraID
			WHERE MOV.rownumber = @icontador
			GROUP BY MOV.empresaID, MOV.sucursalID, FIN.nombre, MOV.CCP_IDDOCTO

			SET @ple_idplanpiso = SCOPE_IDENTITY()

			INSERT INTO [dbo].[relPolizasCierreMes]
			           ([planpisoID]
			           ,[CCP_IDDOCTO]
			           ,[mes]
			           ,[anio]
			           ,[tipoProcesoId])
			SELECT
				[planpisoID]	= @ple_idplanpiso,
				[CCP_IDDOCTO]	= MOV.CCP_IDDOCTO,
				[mes]			= MONTH(GETDATE()),
				[anio]			= YEAR(GETDATE()),
				[tipoProcesoId] = 5
			FROM @plp_planpisoenc MOV
			INNER JOIN financiera FIN on MOV.financieraID = FIN.financieraID
			WHERE MOV.rownumber = @icontador			

			SELECT
				[Row]					= ROW_NUMBER() OVER(ORDER BY MOV.vin ASC),
				[ple_idplanpiso]		= @ple_idplanpiso,
				[pld_consecutivo]		= ROW_NUMBER() OVER(ORDER BY MOV.movimientoId ASC) + PLP.consecutivo,
				[pld_numcuenta]			= [dbo].[ObtenNumCuenta](MOV.sucursalID,1,MOV.tipoMovimientoId),
				[pld_concepto]			= 'CONCILIACION DE PLAN PISO ' + @mes + ' ' + MOV.CCP_IDDOCTO,
				[pld_cargo]				= SUM(INT.monto),
				[pld_abono]				= 0,
				[pld_idpersona]			= [dbo].[ObtenIdPersona](MOV.financieraID),
				[pld_iddocumento]		= 'PP-'+SUBSTRING(@mes,1,3)+SUBSTRING(CONVERT(NVARCHAR(4),YEAR(GETDATE())),3,2)+'-'+SUBSTRING(MOV.vin,LEN(MOV.vin)-10,10),
				[pld_tipodocumento]		= 'FAC',
				[pld_vin]				= MOV.vin,
				[pld_fechavencimiento]	= GETDATE(),
				[pld_porcentajeiva]		= 0,
				[pld_afecta]			= 1,
				[idProvision]			= 0
			INTO #InteresesCargos
			FROM [PlanPiso].[dbo].[Movimiento]	MOV 
			INNER JOIN @plp_planpisoenc			PLP ON MOV.empresaID = PLP.empresaid		 AND MOV.financieraID = PLP.financieraid 
													   AND MOV.CCP_IDDOCTO = PLP.CCP_IDDOCTO
			INNER JOIN Interes					INT ON MOV.movimientoID = INT.movimientoID
			INNER JOIN financiera				FIN ON MOV.financieraID = FIN.financieraID
			WHERE	rownumber = @icontador
					AND MONTH(INT.fecha) = MONTH(GETDATE())
			GROUP BY MOV.empresaID, MOV.sucursalID, FIN.nombre, MOV.CCP_IDDOCTO, MOV.financieraID, MOV.vin, MOV.tipoMovimientoId ,MOV.movimientoId ,MOV.fecha ,PLP.consecutivo

			DECLARE @TotRegistros INT = ( SELECT COUNT( pld_afecta ) TOTREGISTROS FROM #InteresesCargos);

			DECLARE @interezGA NUMERIC(18,2) = (
				SELECT
					SUM(i.monto) TOTAL
				FROM [PlanPiso].[dbo].[Movimiento] m 
				INNER JOIN @plp_planpisoenc p on m.empresaID=p.empresaid and m.financieraID=p.financieraid and m.CCP_IDDOCTO=p.CCP_IDDOCTO
				INNER JOIN Interes i on m.movimientoID=i.movimientoID
				INNER JOIN financiera f on m.financieraID=f.financieraID
				WHERE rownumber=@icontador  and month(i.fecha)=month(GETDATE())
			)

			DECLARE @interezAjuste NUMERIC(18,2) = (
				SELECT
					p.interesAjuste
				FROM @plp_planpisoenc p
				WHERE rownumber=@icontador
			)

			DECLARE @diferencia NUMERIC(18,2) = ( @interezAjuste - @interezGA );
			select @diferencia diferencia, @interezAjuste interezAjuste, @interezGA interezGA ;
			
			SELECT @CCP_IDDOCTO = MOV.CCP_IDDOCTO
			FROM @plp_planpisoenc MOV
			WHERE MOV.rownumber = @icontador;
			
			EXEC [dbo].[CONC_INTERESAJUSTE_SP] @periodo, @anio, @interezAjuste, @CCP_IDDOCTO;
			
			DECLARE @curCargo INT = 0, @maxCargo INT = 0;
			SELECT @curCargo = MIN(Row), @maxCargo = MAX(Row) FROM #InteresesCargos;
			
			WHILE( @curCargo <= @maxCargo )
				BEGIN
					IF(@curCargo = @maxCargo)
						BEGIN
							UPDATE #InteresesCargos SET pld_cargo = ( pld_cargo + @diferencia ) WHERE Row = @curCargo;
						END
					
					INSERT INTO [dbo].[plp_planpisodet]
					         ([ple_idplanpiso]
					         ,[pld_consecutivo]
					         ,[pld_numcuenta]
					         ,[pld_concepto]
					         ,[pld_cargo]
					         ,[pld_abono]
					         ,[pld_idpersona]
					         ,[pld_iddocumento]
					         ,[pld_tipodocumento]
					         ,[pld_vin]
					         ,[pld_fechavencimiento]
					         ,[pld_porcentajeiva]
					         ,[pld_afecta]
					         ,[idProvision])
					SELECT
						[ple_idplanpiso],
						[pld_consecutivo],
						[pld_numcuenta],
						[pld_concepto],
						[pld_cargo],
						[pld_abono],
						[pld_idpersona],
						[pld_iddocumento],
						[pld_tipodocumento],
						[pld_vin],
						[pld_fechavencimiento],
						[pld_porcentajeiva],
						[pld_afecta],
						[idProvision]
					FROM #InteresesCargos WHERE Row = @curCargo;
					SET @curCargo = @curCargo + 1;
				END

			DROP TABLE #InteresesCargos;
			
			SELECT 
				[Row]					= ROW_NUMBER() OVER(ORDER BY MOV.vin ASC),
				[ple_idplanpiso]  		= @ple_idplanpiso,
				[pld_consecutivo]  		= ROW_NUMBER() OVER(ORDER BY MOV.movimientoId ASC) + PLP.consecutivo,
				[pld_numcuenta]  		= [dbo].[ObtenNumCuenta](MOV.sucursalID,0,MOV.tipoMovimientoId),
				[pld_concepto]  		= 'CONCILIACION DE PLAN PISO ' + @mes + ' ' + MOV.CCP_IDDOCTO,
				[pld_cargo]  			= 0,
				[pld_abono]  			= SUM(INT.monto),
				[pld_idpersona]  		= [dbo].[ObtenIdPersona](MOV.financieraID),
				[pld_iddocumento]  		= 'PP-'+SUBSTRING(@mes,1,3)+SUBSTRING(CONVERT(nvarchar(4),YEAR(GETDATE())),3,2)+'-'+SUBSTRING(MOV.vin,LEN(MOV.vin)-10,10),
				[pld_tipodocumento]  	= 'FAC',
				[pld_vin]  				= MOV.vin,
				[pld_fechavencimiento] 	= GETDATE(),
				[pld_porcentajeiva]  	= 0,
				[pld_afecta]  			= 1,
				[idProvision]  			= 0
			INTO #InteresesAbonos
			FROM [PlanPiso].[dbo].[Movimiento]	MOV 
			INNER JOIN @plp_planpisoenc			PLP ON MOV.empresaID = PLP.empresaid		AND MOV.financieraID = PLP.financieraid 
													   AND MOV.CCP_IDDOCTO = PLP.CCP_IDDOCTO
			INNER JOIN Interes					INT ON MOV.movimientoID = INT.movimientoID
			INNER JOIN financiera				FIN ON MOV.financieraID = FIN.financieraID
			WHERE rownumber = @icontador 
				  AND MONTH(INT.fecha) = MONTH(GETDATE())
			GROUP BY MOV.empresaID, MOV.sucursalID, FIN.nombre, MOV.CCP_IDDOCTO, MOV.financieraID, MOV.vin, MOV.tipoMovimientoId, MOV.movimientoId, MOV.fecha, PLP.consecutivo
			
			DECLARE @curAbono INT = 0, @maxAbono INT = 0;
			SELECT @curAbono = MIN(Row), @maxAbono = MAX(Row) FROM #InteresesAbonos;
			
			WHILE( @curAbono <= @maxAbono )
				BEGIN
					IF(@curAbono = @maxAbono)
						BEGIN
							UPDATE #InteresesAbonos SET pld_abono = ( pld_abono + @diferencia ) WHERE Row = @curAbono;
						END
					
					INSERT INTO [dbo].[plp_planpisodet]
					         ([ple_idplanpiso]
					         ,[pld_consecutivo]
					         ,[pld_numcuenta]
					         ,[pld_concepto]
					         ,[pld_cargo]
					         ,[pld_abono]
					         ,[pld_idpersona]
					         ,[pld_iddocumento]
					         ,[pld_tipodocumento]
					         ,[pld_vin]
					         ,[pld_fechavencimiento]
					         ,[pld_porcentajeiva]
					         ,[pld_afecta]
					         ,[idProvision])
					SELECT
						[ple_idplanpiso],
						[pld_consecutivo],
						[pld_numcuenta],
						[pld_concepto],
						[pld_cargo],
						[pld_abono],
						[pld_idpersona],
						[pld_iddocumento],
						[pld_tipodocumento],
						[pld_vin],
						[pld_fechavencimiento],
						[pld_porcentajeiva],
						[pld_afecta],
						[idProvision]
					FROM #InteresesAbonos WHERE Row = @curAbono;
					SET @curAbono = @curAbono + 1;
				END
			
			DROP TABLE #InteresesAbonos;
			SET @icontador =@icontador + 1 
	  END
	UPDATE Interes SET estatusID = 3 WHERE estatusID = 2
END
GO

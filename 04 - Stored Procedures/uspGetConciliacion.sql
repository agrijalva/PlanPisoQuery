USE [PlanPiso]
GO
/****** Object:  StoredProcedure [dbo].[uspGetConciliacion]    Script Date: 02/27/2018 11:50:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ing. Alejandro Grijalva Antonio
-- Create date: 2018-02-27
-- Description:	
-- =============================================
ALTER procedure [dbo].[uspGetConciliacion] 
	@consecutivo INT = 0,
	@periodo INT	 = 0
AS
BEGIN
	-- UNIVERSO DE INTERESES MENSUAL
	SELECT 
		DISTINCT( MO1.VIN ) AS VIN, 
		CCP_IDDOCTO		= MO1.CCP_IDDOCTO,  
		INTERESMENSUAL	= (	
							SELECT SUM(monto)
							FROM Interes INTE
							INNER JOIN  Movimiento MOV ON INTE.movimientoID = MOV.movimientoID
							WHERE	MONTH(INTE.fecha) = @periodo
									AND VIN = MO1.VIN
						   )
	INTO #InteresMensual
	FROM Movimiento MO1
					
	-- ==================================================
	-- UNIDADES ENCONTRADAS EN PLANPISO ANDRADE VS LAYOUT
	-- ==================================================
	
	SELECT 
		[equiparante]		= 1,
		[numeroSerie]		= TED.numeroSerie,
		[valor]				= TED.valor,
		[InteresMesActual]  = SUMA.INTERESMENSUAL,
		[interes]			= TED.interes,
		[esMayor]			=	CASE
									WHEN( SUMA.INTERESMENSUAL = TED.interes ) THEN 1
									WHEN( SUMA.INTERESMENSUAL > TED.interes ) THEN 2
									ELSE 0 
								END,
		[diferencia]		= ( SUMA.INTERESMENSUAL - TED.interes ),
		[CCP_IDDOCTO]		= SUMA.CCP_IDDOCTO
	FROM TmpExcelData TED
	INNER JOIN #InteresMensual SUMA ON TED.numeroSerie = SUMA.VIN
	WHERE TED.consecutivo = @consecutivo
	
	-- ====================================================================
	-- UNIDADES NO ENCONTRADAS EN PLANPISO ANDRADE PERO QUE ESTAN EN LAYOUT
	-- ====================================================================
	UNION
	
	SELECT 
		[equiparante]		= 2,
		[numeroSerie]		= TED.numeroSerie,
		[valor]				= TED.valor,
		[InteresMesActual]  = 0,
		[interes]			= TED.interes,
		[esMayor]			= 0,
		[diferencia]		= TED.interes,
		[CCP_IDDOCTO]		= ''
	FROM TmpExcelData TED
	LEFT JOIN #InteresMensual SUMA ON TED.numeroSerie = SUMA.VIN
	WHERE consecutivo = @consecutivo AND CCP_IDDOCTO IS NULL
	
	-- ====================================================================
	-- UNIDADES ENCONTRADAS EN PLANPISO ANDRADE PERO NO EN LAYOUT
	-- ====================================================================
	UNION
	
	SELECT 
		[equiparante]		= 3,
		[numeroSerie]		= SUMA.VIN,
		[valor]				= ( SELECT TOP 1 DOC.SALDO FROM VINDOCUMENTOS_VIEW VIE
								INNER JOIN Documentos DOC ON DOC.CCP_IDDOCTO = VIE.CCP_IDDOCTO
								WHERE VIN = SUMA.VIN ),
		[InteresMesActual]  = SUMA.INTERESMENSUAL,
		[interes]			= 0,
		[esMayor]			= 0,
		[diferencia]		= SUMA.INTERESMENSUAL,
		[CCP_IDDOCTO]		= SUMA.CCP_IDDOCTO
	FROM TmpExcelData TED
	RIGHT JOIN #InteresMensual SUMA ON TED.numeroSerie = SUMA.VIN AND consecutivo = @consecutivo
	WHERE TED.consecutivo IS NULL;
	
	DROP TABLE #InteresMensual;
END

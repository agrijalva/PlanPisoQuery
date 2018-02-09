BEGIN TRY
	USE [PlanPiso]
	SET NOCOUNT ON;
	DECLARE @Fecha VARCHAR(10)	= '02/02/2018';
	DECLARE @idEmpresa INT		= 1;

	SELECT 
		DISTINCT ltrim(rtrim(PER_PATERNO + ' ' + PER_MATERNO + ' ' + PER_NOMRAZON)) AS Nombre,
		CCP_IDPERSONA as PERSONA,
		PER_RFC,
		USUARIO = 'GMI'
	INTO #CXC_TEMPPERSONAANT
	FROM [GAAU_Concentra].[dbo].[VIS_CONCAR01], [GAAU_Concentra].[dbo].[Per_Personas] WHERE CCP_IDPERSONA = PER_IDPERSONA


	SELECT * 
	INTO #BI_CARTERA_PLP 
	FROM [GAAU_Concentra].[dbo].[vis_concar01], #CXC_TEMPPERSONAANT  
	WHERE CCP_IDPERSONA = #CXC_TEMPPERSONAANT.PERSONA
		  AND ccp_cartera IN (SELECT par_idenpara FROM [GAAU_Concentra].[dbo].[Pnc_Parametr] WHERE Par_tipopara = 'CARTERA' AND Par_status <> 'I' 
		  AND SUBSTRING(PAR_DESCRIP5,1,9) = '2100-0010')


	UPDATE #BI_CARTERA_PLP 
	SET ccp_docori='S' 
	FROM #BI_CARTERA_PLP AS Externo 
	WHERE ccp_docori<>'S' 
		  AND NOT EXISTS  
			(SELECT Interno.CCP_CONSCARTERA 
			 FROM #BI_CARTERA_PLP AS Interno 
			 WHERE interno.ccp_iddocto			= externo.ccp_iddocto 
				   AND interno.ccp_idpersona	= externo.ccp_idpersona 
				   AND interno.CCP_CARTERA		= externo.CCP_CARTERA 
				   AND interno.ccp_docori		= 'S') 



	UPDATE NUEVO 
	SET ccp_docori = ''  
	FROM #BI_CARTERA_PLP AS ANTERIOR, #BI_CARTERA_PLP AS NUEVO
	WHERE ANTERIOR.CCP_IDDOCTO			= NUEVO.CCP_IDDOCTO
		  AND ANTERIOR.CCP_CARTERA		= NUEVO.CCP_CARTERA
		  AND ANTERIOR.CCP_IDPERSONA	= NUEVO.CCP_IDPERSONA
		  AND ANTERIOR.ccp_docori		= 'S'
		  AND NUEVO.ccp_docori			= 'S'
		  AND convert(varchar,ANTERIOR.vcc_anno) + substring('0000000000',1,10 - len(convert(varchar,ANTERIOR.ccp_conscartera))) 
			  + convert(varchar,ANTERIOR.ccp_conscartera) <  convert(varchar,NUEVO.vcc_anno) 
			  + substring('0000000000',1,10-len(convert(varchar,NUEVO.ccp_conscartera))) + convert(varchar,NUEVO.ccp_conscartera)


	DELETE FROM #BI_CARTERA_PLP WHERE convert(Datetime,ccp_fechaDOCTO,103) > convert(Datetime,@Fecha,103) 

	SELECT 
		idEmpresa = @idEmpresa,
		MODULO = CARTERA.PAR_IDMODULO ,
		DES_CARTERA = CARTERA.PAR_DESCRIP1,
		DES_TIPODOCTO = TIMO.PAR_DESCRIP1,  
		CCP_IDDOCTO,
		CCP_NODOCTO,
		CCP_COBRADOR,
		CCP_IDPERSONA,  
		rtrim(ltrim(PER_PATERNO + ' ' + PER_MATERNO + ' ' + PER_NOMRAZON)) as Nombre,
		CCP_FECHVEN,
		CCP_FECHPAG,
		CCP_FECHPROMPAG,
		CCP_FECHREV,
		CCP_CONCEPTO,
		CCP_REFERENCIA,
		CCP_OBSPAR, 
		ltrim(rtrim(ccp_obsgen + ' ' + CASE 
											WHEN ccp_vftipodocto = 'a' OR ccp_vftipodocto = 'u' 
												THEN (	SELECT vte_serie 
														FROM [GAAU_Concentra].[dbo].[ade_vtafi]
														WHERE ccp_vftipodocto = vte_tipodocto 
															 AND ccp_vfdocto = vte_docto) 
											WHEN substring(ccp_vftipodocto,1,1) = 's' 
												THEN (	SELECT vte_referencia1 
														FROM [GAAU_Concentra].[dbo].[ade_vtafi]
														WHERE ccp_vftipodocto = vte_tipodocto 
															  AND ccp_vfdocto = vte_docto) 
											WHEN ccp_vftipodocto = '' 
												 AND ccp_vfdocto = '' 
												 AND ccp_tipodocto = 'fac' 
												 AND len(ccp_obsgen) = 17 
												 AND ccp_cargo > 0 
												THEN (	SELECT TOP 1 rtrim(ltrim(isnull(vte_docto,'') + ' ' + isnull(ccp_obsgen,''))) 
														FROM [GAAU_Concentra].[dbo].[ade_vtafi]
														WHERE vte_tipodocto IN ('a', 'u') 
															  AND vte_serie = ccp_obsgen 
															  AND vte_status = 'i') 
											ELSE '' 
										END)) as CCP_OBSGEN,  
		'IMPORTE' = CASE CARTERA.PAR_IDMODULO 
						WHEN 'CXC' THEN ccp_cargo-ccp_abono 
						ELSE ccp_abono-ccp_cargo 
					END,  
		'SALDO' = CASE CARTERA.PAR_IDMODULO 
						WHEN 'CXC' THEN ccp_cargo-ccp_abono +  (SELECT isnull(sum(CCP_CARGO-CCP_ABONO),0) 
																FROM #BI_CARTERA_PLP AS MOVIMIENTO 
																WHERE MOVIMIENTO.CCP_IDDOCTO = DOCUMENTO.CCP_IDDOCTO 
																	  AND MOVIMIENTO.CCP_IDPERSONA = DOCUMENTO.CCP_IDPERSONA 
																	  AND MOVIMIENTO.CCP_CARTERA = DOCUMENTO.CCP_CARTERA 
																	  AND MOVIMIENTO.CCP_DOCORI <> 'S' ) 
						ELSE ccp_abono - ccp_cargo + (	SELECT isnull(sum(CCP_ABONO-CCP_CARGO),0) 
														FROM #BI_CARTERA_PLP AS MOVIMIENTO  
														WHERE MOVIMIENTO.CCP_IDDOCTO = DOCUMENTO.CCP_IDDOCTO 
															  AND MOVIMIENTO.CCP_IDPERSONA = DOCUMENTO.CCP_IDPERSONA 
															  AND MOVIMIENTO.CCP_CARTERA = DOCUMENTO.CCP_CARTERA 
															  AND MOVIMIENTO.CCP_DOCORI <> 'S') 
					END,  
		'DIAS' = CASE WHEN CCP_FECHVEN <> '' 
						THEN Datediff(day,convert(datetime,@Fecha,103),convert(datetime,CCP_FECHVEN,103)) 
					  ELSE 0 
				 END,
		CCP_FECHADOCTO,
		CCP_REFER, 
		CVEUSU = 'GMI', 
		HORAOPE = CONVERT(VARCHAR(8),GETDATE(),108), 
		'DIASVENCIDOS' = CASE WHEN isdate(CCP_FECHVEN) = 1 
							THEN DATEDIFF(DAY,CONVERT(DATETIME,CCP_FECHVEN,103),GETDATE()) 
							ELSE 0 
						 END, 
		INTERESES = 0, 
		FECHAVENCIDO = CCP_FECHVEN,
		CCP_GRUPO1,
		CCP_CARTERA,
		CARTERA.PAR_DESCRIP2 AS GRUPO,   -- 30
		TELEFONO1 = PER_TELEFONO1,
		CCP_VFTIPODOCTO,
		CCP_VFDOCTO, 
		0 AS VEH_CATALOGO,
		0 AS VEH_ANMODELO,
		'' AS VEH_TIPOAUTO, 
		'' AS VTE_SERIE,
		0 AS VENDEDOR_NUEVO,
		CASE WHEN substring(ccp_referencia,1,8) = 'PER_FAC ' 
				THEN(	SELECT ltrim(rtrim(PER_PATERNO + ' ' +  PER_MATERNO + ' ' + PER_NOMRAZON)) 
						FROM [GAAU_Concentra].[dbo].[per_personas]
						WHERE per_idpersona=substring(ccp_referencia,9,len(ccp_referencia))) 
			ELSE '' 
		END AS NOMBRE_REFERENCIAS,
		'' AS REFERENCIA1,
		'' AS REFERENCIA2,
		'' AS REFERENCIA3,
		CCP_TIPODOCTO,
		CCP_ORIGENCON,
		0 AS VEH_NOINVENTA,	
		CCP_TIPOPOL,
		CCP_CONSPOL,
		ccp_fechope,
		'' AS VENDEDOR_CXC,
		CCP_CONTRARECIBO,
		'' AS UNC_DESCRIPCION,
		(CASE WHEN VTE_TIPODOCTO = 'A' AND ( (	SELECT COUNT(VTE_REFERENCIA1) 
												FROM [GAAU_Concentra].[dbo].[ade_vtafi] 
												INNER JOIN [GAAU_Concentra].[dbo].[UNI_HISSALUNI] ON HSU_NOPEDIDO = VTE_REFERENCIA1 
												WHERE vte_docto = CCP_IDDOCTO) > 0) 
				THEN 'DPP' 
			ELSE '' 
		END) AS DPP,
		DOCUMENTO.CCP_PORIVA,
		0 AS IVA,
		0 AS SaldoSinIva,
		0 AS SaldoMasIva,
		DOCUMENTO.PER_RFC
	INTO #BI_CCP_TEMPAS
	FROM #BI_CARTERA_PLP AS DOCUMENTO 
	LEFT OUTER JOIN [GAAU_Concentra].[dbo].[pnc_parametr] as CARTERA ON CCP_CARTERA = CARTERA.PAR_IDENPARA AND CARTERA.PAR_TIPOPARA='CARTERA'  
	INNER JOIN [GAAU_Concentra].[dbo].[PER_PERSONAS] ON CCP_IDPERSONA = PER_IDPERSONA 
	LEFT OUTER JOIN [GAAU_Concentra].[dbo].[pnc_parametr] as TIMO ON CCP_TIPODOCTO = TIMO.PAR_IDENPARA AND TIMO.PAR_TIPOPARA = 'TIMO'  
	INNER JOIN #CXC_TEMPPERSONAANT ON CCP_IDPERSONA = #CXC_TEMPPERSONAANT.PERSONA AND #CXC_TEMPPERSONAANT.USUARIO = 'GMI' 
	LEFT OUTER JOIN [GAAU_Concentra].[dbo].[ADE_VTAFI] ON VTE_DOCTO = CCP_IDDOCTO AND VTE_CONSECUTIVO = CCP_CONSPOL  
	WHERE CCP_DOCORI='S' 
		  AND ccp_cartera IN (	SELECT par_idenpara 
								FROM [GAAU_Concentra].[dbo].[Pnc_Parametr] 
								WHERE Par_tipopara = 'CARTERA' 
									  AND Par_status <> 'I' 
									  AND (SUBSTRING(PAR_DESCRIP5,1,9) = '2100-0010')) 


	UPDATE #BI_CCP_TEMPAS
	SET CCP_VFDOCTO = CCP_IDDOCTO, CCP_VFTIPODOCTO = 'A'
	WHERE CVEUSU = 'GMI'
		  AND CCP_TIPODOCTO = 'RD'
		  AND charindex('-',ccp_iddocto) <> 0 AND CCP_ORIGENCON = 'PD'

	UPDATE #BI_CCP_TEMPAS 
	SET CCP_VFDOCTO = substring(CCP_IDDOCTO,1,1) + SUBSTRING('000000000',1,9-LEN(RTRIM(LTRIM(SUBSTRING(CCP_IDDOCTO,2,charindex('-',ccp_iddocto)-2))))) + 
	RTRIM(LTRIM(SUBSTRING(CCP_IDDOCTO,2,charindex('-',ccp_iddocto)-2))) 
	WHERE CVEUSU='GMI' AND CCP_TIPODOCTO = 'RD' AND 
	CCP_VFDOCTO<>'' AND CCP_VFTIPODOCTO<>'' and len(CCP_VFDOCTO)<10

	UPDATE #BI_CCP_TEMPAS 
	SET CCP_VFDOCTO=SUBSTRING(CCP_IDDOCTO,1,charindex('-',ccp_iddocto)-2) 
	WHERE CVEUSU='GMI' 
		  AND CCP_TIPODOCTO = 'RD' 
		  AND CCP_VFDOCTO <>'' 
		  AND CCP_VFTIPODOCTO <> '' 
		  AND len(CCP_VFDOCTO) > 10

	UPDATE #BI_CCP_TEMPAS 
	SET REFERENCIA1 = ISNULL(ADE_VTAFI.VTE_REFERENCIA1, ''),
		REFERENCIA2 = ISNULL(ADE_VTAFI.VTE_REFERENCIA2, ''),
		REFERENCIA3 = ISNULL(ADE_VTAFI.VTE_REFERENCIA3, ''),
		VTE_SERIE   = ISNULL(ADE_VTAFI.VTE_SERIE,'') 
	FROM #BI_CCP_TEMPAS, [GAAU_Concentra].[dbo].[ADE_VTAFI]
	WHERE CCP_VFTIPODOCTO = ADE_VTAFI.VTE_TIPODOCTO 
		  AND CCP_VFDOCTO = ADE_VTAFI.VTE_DOCTO 
		  AND CVEUSU	  = 'GMI';
		  

	UPDATE #BI_CCP_TEMPAS 
	SET IVA = ( CASE WHEN C.VTE_TIPODOCTO = 'U' 
						THEN  (((A.SALDO) * VTE_IVA)/VTE_TOTAL) 
					ELSE (A.SALDO - Round(A.SALDO /((CONVERT(DECIMAL(4,2),(CONVERT(INT,A.CCP_PORIVA)))/100) + 1), 2)) 
				END) 
	FROM #BI_CCP_TEMPAS A 
	INNER JOIN [GAAU_Concentra].[dbo].[VIS_CONCAR01] B ON B.CCP_IDDOCTO = A.CCP_IDDOCTO 
														 AND B.CCP_IDPERSONA = A.CCP_IDPERSONA 
														 AND B.CCP_CARTERA = A.CCP_CARTERA 
														 AND B.CCP_TIPODOCTO = A.CCP_TIPODOCTO 
														 AND B.CCP_ORIGENCON = A.CCP_ORIGENCON 
	LEFT OUTER JOIN [GAAU_Concentra].[dbo].[ADE_VTAFI] C ON C.VTE_IDCLIENTE = B.CCP_IDPERSONA AND C.VTE_FECHDOCTO = A.CCP_FECHADOCTO 
	WHERE CVEUSU = 'GMI' AND SALDO <> 0

	UPDATE #BI_CCP_TEMPAS 
	SET IVA = ( CASE WHEN IVA IS NULL 
						THEN (SALDO - Round(SALDO /((CONVERT(DECIMAL(4,2),(CONVERT(INT,CCP_PORIVA)))/100) + 1), 2))  
				END) 
	WHERE IVA IS NULL

	UPDATE #BI_CCP_TEMPAS 
	SET SaldoSinIva = (DOCUMENTO.SALDO - IVA)
	FROM #BI_CCP_TEMPAS DOCUMENTO 
	LEFT OUTER JOIN [GAAU_Concentra].[dbo].[ADE_VTAFI] SEMINUEVOS ON SEMINUEVOS.VTE_DOCTO = DOCUMENTO.CCP_IDDOCTO 
																	AND SEMINUEVOS.VTE_IDCLIENTE = DOCUMENTO.CCP_IDPERSONA  
	WHERE CVEUSU = 'GMI' AND DOCUMENTO.SALDO <> 0 

	UPDATE #BI_CCP_TEMPAS 
	SET SaldoMasIva = (SaldoSinIva + IVA)  
	FROM #BI_CCP_TEMPAS DOCUMENTO 
	LEFT OUTER  JOIN [GAAU_Concentra].[dbo].[ADE_VTAFI] SEMINUEVOS ON SEMINUEVOS.VTE_DOCTO = DOCUMENTO.CCP_IDDOCTO 
																	AND SEMINUEVOS.VTE_IDCLIENTE = DOCUMENTO.CCP_IDPERSONA  
	WHERE CVEUSU = 'GMI' AND DOCUMENTO.SALDO <> 0 


	UPDATE #BI_CCP_TEMPAS 
	SET CCP_VFTIPODOCTO = null, 
		CCP_VFDOCTO = null 
	WHERE CCP_VFTIPODOCTO<>'A' AND cveusu='GMI'

	UPDATE #BI_CCP_TEMPAS 
	SET veh_catalogo = SER_VEHICULO.veh_catalogo,
		veh_anmodelo = SER_VEHICULO.veh_anmodelo,
		veh_tipoauto = SER_VEHICULO.veh_tipoauto,
		vte_serie = ADE_VTAFI.vte_serie,
		VENDEDOR_NUEVO=ltrim(rtrim(per_paterno + ' ' + per_materno + ' ' + per_nomrazon)),
		VEH_NOINVENTA = SER_VEHICULO.VEH_NOINVENTA,
		UNC_DESCRIPCION = UNI_CATALOGO.UNC_DESCRIPCION 
	FROM #BI_CCP_TEMPAS,[GAAU_Concentra].[dbo].[ade_vtafi],[GAAU_Concentra].[dbo].[uni_pedido],[GAAU_Concentra].[dbo].[per_personas],[GAAU_Concentra].[dbo].[ser_vehiculo],[GAAU_Concentra].[dbo].[UNI_CATALOGO]
	WHERE ade_vtafi.vte_serie = ser_vehiculo.veh_numserie 
		  AND per_idpersona = upe_idagte 
		  AND VTE_TIPODOCTO = CCP_VFTIPODOCTO 
		  AND VTE_DOCTO = CCP_VFDOCTO 
		  AND vte_referencia1 = convert(varchar,upe_idpedi) 
		  AND cveusu = 'GMI' 
		  -- AND UNC_IDCATALOGO =* SER_VEHICULO.veh_catalogo 
		  -- AND UNC_MODELO     =* SER_VEHICULO.veh_anmodelo 

	DELETE FROM #BI_CCP_TEMPAS WHERE SALDO = 0
	DELETE FROM #BI_CCP_TEMPAS WHERE DES_CARTERA NOT LIKE '%-%-0002-0001%';
	
	-- DELETE FROM [dbo].[CarteraProveedores] WHERE idEmpresa = @idEmpresa;
	-- INSERT INTO [dbo].[CarteraProveedores]
	SELECT * FROM #BI_CCP_TEMPAS;
	
	DROP TABLE #CXC_TEMPPERSONAANT;
	DROP TABLE #BI_CARTERA_PLP;
	DROP TABLE #BI_CCP_TEMPAS;
END TRY
BEGIN CATCH
	DROP TABLE #CXC_TEMPPERSONAANT;
	DROP TABLE #BI_CARTERA_PLP;
	DROP TABLE #BI_CCP_TEMPAS;
	
	SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
END CATCH

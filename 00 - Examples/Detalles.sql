--VAHICULOS - Concentradoras
--vis_concar01
--ser_vehiculo


--Corporartiva, poner en las siguientes tablas
--plp_planpisoenc   pide el tipo de proceso 'provision'|''
--plp_planpisodet


--SELECT * FROM GA_Corporativa..plp_planpisoenc;

SELECT TOP 1000 CCP_OBSGEN, * FROM GAAU_Concentra..VIS_CONCAR01
SELECT TOP 1000 VEH_TIPENTRADA, * FROM GAAU_Universidad..SER_VEHICULO

SELECT TOP 1000 CCP_OBSGEN, * FROM GAAU_Concentra..VIS_CONCAR01 VIS, GAAU_Universidad..SER_VEHICULO SER
WHERE CCP_OBSGEN = VEH_NUMSERIE;



SELECT * FROM cuentasxpagar..cxp_ordencompra
SELECT * FROM cuentasxpagar..cxp_ordencompra WHERE oce_folioorden LIKE '%MIR-UN-PE-%';
SELECT * FROM cuentasxpagar..cxp_detalleautosnuevos WHERE oce_folioorden LIKE '%UNI-UN-PE-%';

-- Centralizadas
SELECT * FROM GAAU_Universidad..PNC_PARAMETR WHERE PAR_DESCRIP1 LIKE '%COMPRA PLANTA%'
SELECT * FROM GAAU_Universidad..PNC_PARAMETR WHERE PAR_TIPOPARA = 'TIPENT';

SELECT * FROM GAAU_Universidad..PNC_PARAMETR WHERE PAR_TIPOPARA = 'VNT';


-- Ejemplo
SELECT TOP 1000 VEH_TIPENTRADA, * FROM GAAU_Universidad..SER_VEHICULO WHERE VEH_NUMSERIE = 'JS2FH81SXJ6104873';
SELECT PAR_IDENPARA, * FROM GAAU_Universidad..PNC_PARAMETR WHERE PAR_TIPOPARA = 'TIPENT';

SELECT * FROM GAAU_Universidad..ADE_VTAFI WHERE VTE_DOCTO LIKE 'AA%' AND VTE_STATUS = 'I'
-- Compra/Venta
DECLARE @vin VARCHAR(100) = 'TSMYAA2S0JM560875';
SELECT VTE_FORMAPAGO, * FROM GAAU_Universidad..ADE_VTAFI WHERE VTE_SERIE = @vin; -- Si esta aqui esta vendida
SELECT TOP 1000 VEH_TIPENTRADA, * FROM GAAU_Universidad..SER_VEHICULO WHERE VEH_NUMSERIE = @vin;

SELECT PAR_IDENPARA, * FROM GAAU_Universidad..PNC_PARAMETR WHERE PAR_TIPOPARA = 'PLNCON';

-- Traspaso
SELECT * FROM GAAU_Concentra..UNI_TRASPASOS;
SELECT * FROM GAAU_Concentra..UNI_TRASPASOS WHERE TRA_NUMSERIE = 'TSMYAA2S0JM560875';


-- Canal de compra: ser_vehiculo (local)
-- Canal de Venta: ADE_VTAFI (local)
-- Suc Compra: ser_vehiculo/uni_traspaso
-- Suc Traspaso: uni_traspaso



FROM Documentos TEMP
SELECT *
INNER JOIN [cuentasxpagar].[dbo].[cxp_detalleautosnuevos] DET ON DET.oce_folioorden = TEMP.CCP_IDDOCTO COLLATE Modern_Spanish_CI_AS
INNER JOIN [cuentasxpagar].[dbo].[cxp_ordencompra] ORD ON DET.oce_folioorden = ORD.oce_folioorden
WHERE TEMP.CCP_IDDOCTO LIKE '%-%-%-%-%-%';

SELECT * FROM  [cuentasxpagar]..cat_situacionorden

SELECT DISTINCT( sod_idsituacionorden ) FROM [cuentasxpagar].[dbo].[cxp_ordencompra] ORDER BY sod_idsituacionorden;


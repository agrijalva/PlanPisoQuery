-- ¿Que consideraciones tomar para traer cartera?
/*
SELECT CCP_OBSGEN, * FROM GAAU_Concentra..VIS_CONCAR01 WHERE CCP_TIPOPOL IN ( 'CUUN', 'CUPE' )
SELECT CCP_OBSGEN, * FROM GAAU_Concentra..VIS_CONCAR01 WHERE CCP_TIPOPOL IN ( 'CUUN' );
SELECT CCP_OBSGEN, * FROM GAAU_Concentra..VIS_CONCAR01 WHERE CCP_TIPOPOL IN ( 'CUPE' );
*/



-- Consulta de unidad por VIN en Cartera y en Inventario
-- Existe mas de un registro en Cartera ¿Que parametros se toman para identificar los vigentes?
/*
SELECT CCP_OBSGEN, Vcc_Empresa, * FROM GAAU_Concentra..VIS_CONCAR01 WHERE CCP_OBSGEN = 'JS2RE91S1F6100164' ORDER BY CCP_CONSCARTERA;
SELECT * FROM GAAU_Universidad..ADE_VTAFI WHERE VTE_SERIE = 'JS2RE91S1F6100164'
*/



----SELECT * FROM GAAU_Universidad..ADE_VTAFI WHERE VTE_DOCTO LIKE 'AA%' AND VTE_STATUS = 'I'



-- PASO 1: Obtener tipo de compra ( 'PTA', 'PTA2' )
SELECT PAR_DESCRIP1 FROM GAAU_Universidad..PNC_PARAMETR WHERE PAR_TIPOPARA = 'TIPENT' AND PAR_IDENPARA IN ( 'PTA' );
-- SELECT PAR_DESCRIP1 FROM GAAU_Cuautitlan..PNC_PARAMETR WHERE PAR_TIPOPARA = 'TIPENT' 
-- SELECT PAR_DESCRIP1 FROM GAAU_Pedregal..PNC_PARAMETR WHERE PAR_TIPOPARA = 'TIPENT' 
-- SELECT PAR_DESCRIP1, * FROM GAAA_Azcapo..PNC_PARAMETR WHERE PAR_TIPOPARA = 'TIPENT'
-- SELECT PAR_DESCRIP1, * FROM [192.168.20.31].[GAZM_Zaragoza].[dbo].PNC_PARAMETR WHERE PAR_TIPOPARA = 'TIPENT'




-- PASO 2: Obtener los detalles de las compras de las unidades
DECLARE @idEmpresa INT		= 4;
DECLARE @Current INT		= 0;
DECLARE @Max INT			= 0;
DECLARE @Base VARCHAR(500)	= '';
DECLARE @tableConf  TABLE(
	idEmpresa INT, idSucursal INT, 
	servidor VARCHAR(250), 
	baseConcentra VARCHAR(250), 
	sqlCmd VARCHAR(8000), 
	cargaDiaria VARCHAR(8000)
);

INSERT INTO @tableConf Execute [dbo].[SEL_ACTIVE_DATABASES_SP];

SELECT @Current = MIN(idSucursal),@Max = MAX(idSucursal) FROM @tableConf WHERE idEmpresa = @idEmpresa;
WHILE(@Current <= @Max )
	BEGIN
		-- BÚSQUEDA DE UNIDADES EN SUCURSAL
		SET @Base = (SELECT servidor FROM @tableConf WHERE idSucursal = @Current);
		
		DECLARE @quertyString VARCHAR(MAX) = 
			'SELECT anu_numeroserie, *
			FROM [cuentasxpagar].[dbo].[cxp_ordencompra] ORC
			INNER JOIN [cuentasxpagar].[dbo].[cxp_detalleautosnuevos] DET ON ORC.oce_folioorden = DET.oce_folioorden
			INNER JOIN [ControlAplicaciones].[dbo].[cat_departamentos] DEP ON ORC.oce_iddepartamento = DEP.dep_iddepartamento
			WHERE oce_idempresa = '+ CONVERT(VARCHAR(10),@idEmpresa) +'
				  AND oce_idsucursal = ' + CONVERT( VARCHAR(10), @Current ) + '
				  AND anu_idtipocompra COLLATE SQL_Latin1_General_CP1_CI_AS IN (
																					SELECT PAR_DESCRIP1 
																					FROM '+ @Base +'.PNC_PARAMETR 
																					WHERE PAR_TIPOPARA = ''TIPENT'' 
																						  AND PAR_IDENPARA IN (''PTA'')
																				)
			ORDER BY anu_iddetalle ASC;';
		EXECUTE( @quertyString );
		
		SET	@Current = @Current + 1;
	END
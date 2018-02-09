-- USE [referencias];
-- SELECT TOP 1000 VEH_TIPENTRADA, * FROM GAAU_Universidad..SER_VEHICULO;
DECLARE @idEmpresa INT		= 1;
-- DECLARE @vin VARCHAR(17)	= 'TSMYA22S0EM135054';
DECLARE @vin VARCHAR(17)	= 'JS2RE91S1F6100164';

SET NOCOUNT ON;
DECLARE @FacturaQuery varchar(max)  = '';
DECLARE @Base VARCHAR(MAX)			= '';

-- Consulta de las bases de datos y sucursales activas
DECLARE @tableConf  TABLE(idEmpresa INT, idSucursal INT, servidor VARCHAR(250), baseConcentra VARCHAR(250), sqlCmd VARCHAR(8000), cargaDiaria VARCHAR(8000));
DECLARE @sucCompra TABLE(id INT IDENTITY, idSucursal INT, vin VARCHAR(17), base VARCHAR(MAX));

INSERT INTO @tableConf Execute [dbo].[SEL_ACTIVE_DATABASES_SP];
DECLARE @CountSuc INT = (SELECT COUNT(idSucursal) Sucursales FROM @tableConf WHERE idEmpresa = @idEmpresa);
PRINT( '========================= [ Búsqueda de Unidades ] =========================' );
PRINT( 'EMPRESA ' + CONVERT(VARCHAR(2), @idEmpresa) + ': SUCURSALES ' + CONVERT(VARCHAR(3), @CountSuc) );

-- SELECT * FROM @tableConf;

DECLARE @Current INT = 0, @Max INT = 0;
DECLARE @CurrentBanco INT = 0, @MaxBanco INT = 0;
DECLARE @CurrentBancoCoti INT = 0, @MaxBancoCoti INT = 0;

SELECT @Current = MIN(idSucursal),@Max = MAX(idSucursal) FROM @tableConf WHERE idEmpresa = @idEmpresa;
WHILE(@Current <= @Max )
	BEGIN
		-- BÚSQUEDA DE UNIDADES EN SUCURSAL
		SET @Base = (SELECT servidor FROM @tableConf WHERE idSucursal = @Current);
		
		INSERT INTO @sucCompra EXECUTE('SELECT SUC = 1, VEH_NUMSERIE, '''+ @Base +''' FROM '+ @Base +'.SER_VEHICULO WHERE VEH_NUMSERIE = ''' + @vin + '''');
		SET	@Current = @Current + 1;
	END 

DECLARE @total INT = (SELECT COUNT(id) FROM @sucCompra);
-- PRINT( @total );
-- SELECT * FROM @sucCompra;

IF( @total = 0 )
	BEGIN
		SELECT msg = 'VIN no existente';
	END
ELSE IF( @total = 1 ) -- Sin traspaso
	BEGIN
		SELECT * FROM GAAU_Concentra..UNI_TRASPASOS WHERE TRA_NUMSERIE = @vin;
	END
ELSE
	BEGIN
		-- SUCURSAL COMPRA
		-- SUCURSAL COMPRA
		-- SUCURSAL COMPRA
		DECLARE @sucEnvia VARCHAR(100) = (SELECT TOP 1 TRA_SUCENVIA FROM GAAU_Concentra..UNI_TRASPASOS WHERE TRA_NUMSERIE = @vin);
		DECLARE @sucCompra1 VARCHAR(300) = ( SELECT servidor FROM @tableConf WHERE idEmpresa = @idEmpresa AND servidor LIKE '%'+ @sucEnvia +'%');
		PRINT( 'Quien compra: ' + @sucEnvia );
		EXECUTE('SELECT VEH_NUMSERIE,
						VEH_SITUACION,
						VEH_CATALOGO,
						VEH_ANMODELO
				 FROM '+ @sucCompra1 +'.SER_VEHICULO 
				 WHERE VEH_NUMSERIE = ''' + @vin + '''');
		
		-- TRASPASOS ENTRE SUCURSALES
		-- TRASPASOS ENTRE SUCURSALES
		-- TRASPASOS ENTRE SUCURSALES
		DECLARE @Traspasos TABLE( ID INT IDENTITY, NUMTRASPASO VARCHAR(10) );
		INSERT INTO @Traspasos
		SELECT TRA_NUMTRASPASO FROM GAAU_Concentra..UNI_TRASPASOS WHERE TRA_NUMSERIE = @vin ORDER BY TRA_NUMTRASPASO ASC;
		
		DECLARE @CurTras INT, @MaxTras INT;
		SELECT @CurTras = MIN(ID),@MaxTras = MAX(ID) FROM @Traspasos;
		WHILE(@CurTras <= @MaxTras )
			BEGIN
				SELECT TRA_NUMTRASPASO,
					   TRA_NUMSERIE,
					   TRA_SUCENVIA,
					   TRA_SUCRECIBE,
					   TRA_STATUS,
					   TRA_FECHOPE
				FROM GAAU_Concentra..UNI_TRASPASOS 
				WHERE TRA_NUMTRASPASO = (SELECT NUMTRASPASO FROM @Traspasos WHERE ID = @CurTras);
				SET	@CurTras = @CurTras + 1;
			END 
		-- SELECT * FROM @Traspasos;
	END
	
	

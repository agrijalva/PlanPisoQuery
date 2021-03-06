USE [PlanPiso]
GO
/****** Object:  StoredProcedure [dbo].[PLP_CHECKVIN_SP]    Script Date: 02/09/2018 11:42:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ing. Alejandro Grijalva Antonio
-- Create date: 2018-01-22
-- Description:	Consulta por VIN de los eventos que les ha sucedido.
-- [dbo].[PLP_CHECKVIN_SP] 1, 'TSMYE21S0GM266915'
-- =============================================
ALTER PROCEDURE [dbo].[PLP_CHECKVIN_SP]
	@idEmpresa INT		= 1,
	@vin VARCHAR(17)	= 'TSMYD21S5GM186416'
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @FacturaQuery varchar(max)  = '';
	DECLARE @Base VARCHAR(MAX)			= '';

	-- Consulta de las bases de datos y sucursales activas
	DECLARE @tableConf  TABLE(idEmpresa INT, idSucursal INT, servidor VARCHAR(250), baseConcentra VARCHAR(250), sqlCmd VARCHAR(8000), cargaDiaria VARCHAR(8000));
	DECLARE @sucCompra  TABLE(id INT IDENTITY, idSucursal INT, vin VARCHAR(17), base VARCHAR(MAX));
	
	-- Se obtienen las rutas de las bases de datos
	INSERT INTO @tableConf Execute [PlanPiso].[dbo].[SEL_ACTIVE_DATABASES_SP];
	PRINT( '========================= [ Búsqueda Eventos de Unidades en la Empresa ] =========================' );
	-- PRINT( 'EMPRESA ' + CONVERT(VARCHAR(2), @idEmpresa));
	
	-- Delimitación de inicio y fin de las sucursales
	DECLARE @Current INT = 0, @Max INT = 0;
	SELECT @Current = MIN(idSucursal),@Max = MAX(idSucursal) FROM @tableConf WHERE idEmpresa = @idEmpresa;
	
	-- BÚSQUEDA DE UNIDADES EN LAS SUCURSALES
	WHILE(@Current <= @Max )
		BEGIN
			SET @Base = (SELECT servidor FROM @tableConf WHERE idSucursal = @Current);
			
			INSERT INTO @sucCompra EXECUTE('SELECT SUC = '+ @Current +', VEH_NUMSERIE, '''+ @Base +''' FROM '+ @Base +'.SER_VEHICULO WHERE VEH_NUMSERIE = ''' + @vin + '''');
			SET	@Current = @Current + 1;
		END 

	DECLARE @total INT = (SELECT COUNT(id) FROM @sucCompra);
	DECLARE @currentBase VARCHAR(300);
	
	DECLARE @Iventario VARCHAR(MAX); 
	
	DECLARE @tmp_inventario VARCHAR(MAX);
	
	
	IF( @total = 0 )
		BEGIN
			SELECT msg = 'VIN no existente';
		END
	ELSE IF( @total = 1 ) -- Sin traspaso
		BEGIN			
			SET @currentBase  = ( SELECT base FROM @sucCompra);
			SELECT @Iventario = [PlanPiso].[dbo].[INVENTARIO_FN]( @currentBase, @vin,1,1 );
			EXECUTE(@Iventario);
		END
	ELSE
		BEGIN
			-- SUCURSAL COMPRA
			-- SUCURSAL COMPRA
			-- SUCURSAL COMPRA
			DECLARE @sucEnvia VARCHAR(100) = (SELECT TOP 1 TRA_SUCENVIA FROM GAAU_Concentra..UNI_TRASPASOS WHERE TRA_NUMSERIE = @vin);
			
			IF( @sucEnvia IS NOT NULL )
				BEGIN
					SET @currentBase = ( SELECT servidor FROM @tableConf WHERE idEmpresa = @idEmpresa AND servidor LIKE '%'+ @sucEnvia +'%');
					PRINT( '' );
					PRINT( 'QUIEN COMPRA: ' + @sucEnvia );
					PRINT( '' );
					SELECT @Iventario = [PlanPiso].[dbo].[INVENTARIO_FN]( @currentBase, @vin,1,1 );
					EXECUTE(@Iventario);
					--EXECUTE('SELECT VEH_NUMSERIE,
					--				VEH_SITUACION,
					--				VEH_CATALOGO,
					--				VEH_ANMODELO
					--		 FROM '+ @sucCompra1 +'.SER_VEHICULO 
					--		 WHERE VEH_NUMSERIE = ''' + @vin + '''');
					
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
			ELSE
				BEGIN
					PRINT('No hay traspasos pero existen en dos bases.');
				END
			
		END
		
		
END

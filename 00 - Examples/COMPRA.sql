-- QUIEN COMPRA LA UNIDAD
DECLARE @idEmpresa INT = 1;
DECLARE @vin VARCHAR(17) = 'TSMYEA1S6HM353018';


SET NOCOUNT ON;
DECLARE @FacturaQuery varchar(max)  = '';
DECLARE @Base VARCHAR(MAX)			= '';
DECLARE @BaseConcentra VARCHAR(MAX)	= '';
DECLARE @SucCompra INT				= 0;

-- Consulta de las bases de datos y sucursales activas
DECLARE @tableConf  TABLE(idEmpresa INT, idSucursal INT, servidor VARCHAR(250), baseConcentra VARCHAR(250), sqlCmd VARCHAR(8000), cargaDiaria VARCHAR(8000));
DECLARE @tblSucCompra  TABLE(id INT IDENTITY, idSucursal INT, vin VARCHAR(17), base VARCHAR(MAX), baseConcentra VARCHAR(MAX));



IF EXISTS(SELECT * FROM [cuentasxpagar].[dbo].[cxp_detalleautosnuevos] DET WHERE anu_numeroserie = @vin)
	BEGIN
		SELECT 
			empresa			= oce_idempresa,
			sucursal		= oce_idsucursal,
			vin				= anu_numeroserie,
			catalogo		= anu_idcatalogo,
			modelo			= anu_modelo,
			anio_modelo		= anu_aniomodelo,
			marca			= anu_idmarca,
			colorExt		= anu_idcolorext,
			colorInt		= anu_idcolorint,
			idtipocompra	= anu_idtipocompra,
			financiera		= anu_idfinanciera,
			fechaOrden		= oce_fechaorden,
			fechaEntrega	= anu_fechapromentrega	
		FROM [cuentasxpagar].[dbo].[cxp_detalleautosnuevos] DET
		INNER JOIN [cuentasxpagar].[dbo].[cxp_ordencompra] ORD ON DET.oce_folioorden = ORD.oce_folioorden
		WHERE anu_numeroserie = @VIN AND oce_idtipoorden != 0;
		
		--SELECT 
		--	*
		--FROM [cuentasxpagar].[dbo].[cxp_detalleautosnuevos] DET
		--INNER JOIN [cuentasxpagar].[dbo].[cxp_ordencompra] ORD ON DET.oce_folioorden = ORD.oce_folioorden
		--WHERE anu_numeroserie = @VIN;
	END
ELSE
	BEGIN
		-- Se obtienen las rutas de las bases de datos
		INSERT INTO @tableConf Execute [dbo].[SEL_ACTIVE_DATABASES_SP];

		-- Delimitación de inicio y fin de las sucursales
		DECLARE @Current INT = 0, @Max INT = 0;
		SELECT @Current = MIN(idSucursal),@Max = MAX(idSucursal) FROM @tableConf WHERE idEmpresa = @idEmpresa;

		-- BÚSQUEDA DE UNIDADES EN LAS SUCURSALES

		WHILE(@Current <= @Max )
			BEGIN
				SET @Base			= (SELECT servidor FROM @tableConf WHERE idSucursal = @Current);
				SET @BaseConcentra  = (SELECT baseConcentra FROM @tableConf WHERE idSucursal = @Current);
				
				INSERT INTO @tblSucCompra EXECUTE('SELECT SUC = '+ @Current +', VEH_NUMSERIE, '''+ @Base +''', '''+@BaseConcentra+''' FROM '+ @Base +'.SER_VEHICULO WHERE VEH_NUMSERIE = ''' + @vin + '''');
				SET	@Current = @Current + 1;
			END 
		-- SELECT * FROM @tblSucCompra;
		DECLARE @total INT = (SELECT COUNT(id) FROM @tblSucCompra);
		DECLARE @currentBase VARCHAR(300);

		DECLARE @Iventario VARCHAR(MAX); 

		PRINT( 'BaseConcentra: ' + @BaseConcentra );

		IF( @total = 0 )
			BEGIN
				SELECT msg = 'VIN NO EXISTE EN ESTA EMPRESA';
			END
		ELSE IF( @total = 1 ) -- Sin traspaso
			BEGIN			
				SET @currentBase  = ( SELECT base FROM @tblSucCompra);
				SELECT @Iventario = [dbo].[INVENTARIO_FN]( @currentBase, @vin, 1, 3 );
				EXECUTE(@Iventario);
			END
		ELSE
			BEGIN
				-- SUCURSAL COMPRA
				-- SUCURSAL COMPRA
				-- SUCURSAL COMPRA
				-- SELECT * FROM 
				DECLARE @table TABLE( sucursal VARCHAR(200) );
				INSERT INTO @table
				EXECUTE( 'SELECT TOP 1 TRA_SUCENVIA FROM '+ @BaseConcentra +'.UNI_TRASPASOS WHERE TRA_NUMSERIE = '''+ @vin +'''' );
				
				-- EXECUTE( 'SELECT * FROM '+ @BaseConcentra +'.UNI_TRASPASOS WHERE TRA_NUMSERIE = '''+ @vin +'''' );
				
				DECLARE @sucEnvia VARCHAR(100) = (SELECT sucursal FROM @table);		
				
				IF( @sucEnvia IS NOT NULL )
					BEGIN
						SET @currentBase = ( SELECT servidor FROM @tableConf WHERE idEmpresa = @idEmpresa AND servidor LIKE '%'+ @sucEnvia +'%');
						SET @SucCompra   = ( SELECT idSucursal FROM @tableConf WHERE idEmpresa = @idEmpresa AND servidor LIKE '%'+ @sucEnvia +'%' );
						PRINT( '' );
						PRINT( 'QUIEN COMPRA: ' + @sucEnvia );
						PRINT( '' );
						print( @idEmpresa );
						print( @SucCompra );
						SELECT @Iventario = [dbo].[INVENTARIO_FN]( @currentBase, @vin, @idEmpresa, @SucCompra );
						EXECUTE(@Iventario);
					END
				ELSE
					BEGIN
						PRINT('No hay traspasos pero existen en dos bases.');
					END
			END
	END
	

/*	
SELECT * 
FROM [cuentasxpagar].[dbo].[cxp_detalleautosnuevos] DET
INNER JOIN [cuentasxpagar].[dbo].[cxp_ordencompra] ORD ON DET.oce_folioorden = ORD.oce_folioorden
WHERE oce_idempresa = 1
*/
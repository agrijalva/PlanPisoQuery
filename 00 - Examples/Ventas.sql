USE [PlanPiso];
-- [GAAU].[dbo].[ADE_VTAFI]
-- SELECT TOP 10 * FROM [GAAU_Universidad].[dbo].[ADE_VTAFI]
-- SELECT * FROM [GAAU_Universidad].[dbo].[ADE_VTAFI] WHERE VTE_SERIE = 'TSMYE21S2GM261392' AND VTE_STATUS = 'I'
BEGIN TRY
	DECLARE @idEmpresa INT = 1

	DECLARE @VinDocumentos TABLE( Id INT IDENTITY, idEmpresa INT, idSucursal INT, VIN VARCHAR(17), Documento VARCHAR(20) );
	INSERT INTO @VinDocumentos EXECUTE [OBTIENEVIN_SP] @idEmpresa;
	
	--SELECT * FROM @VinDocumentos;
	
	DECLARE @Current INT, @Max INT;
	SELECT @Current = MIN( Id ), @Max = MAX(Id) FROM @VinDocumentos;
	
	-- SET @Max = 50;
	
	
	DECLARE @VIN VARCHAR(17) = '',
			@idSucursal INT = 0,
			@Documento VARCHAR(20) = '';
	
	DECLARE @tableConf  TABLE(idEmpresa INT, idSucursal INT, servidor VARCHAR(250), baseConcentra VARCHAR(250), sqlCmd VARCHAR(8000), cargaDiaria VARCHAR(8000));
	INSERT INTO @tableConf Execute [dbo].[SEL_ACTIVE_DATABASES_SP];
	
	DECLARE @Ventas TABLE(
		Id INT IDENTITY,
		VTE_TIPODOCTO varchar(10),
		VTE_DOCTO varchar(20),
		VTE_IDCLIENTE numeric(18, 0),
		VTE_FECHDOCTO varchar(10),
		VTE_HORADOCTO varchar(5),
		VTE_REFERENCIA1 varchar(50),
		VTE_FORMAPAGO varchar(10),
		VTE_VTABRUT decimal(18, 5),
		VTE_IVA decimal(18, 5),
		VTE_TOTAL decimal(18, 5),
		VTE_SERIE varchar(17),
		VTE_CVEUSU varchar(10),
		VTE_FECHOPE varchar(10),
		VTE_IVADESG varchar(1),
		VTE_IVAPLICADO varchar(10),
		VTE_TIPO varchar(10),
		VTE_CONSECUTIVO numeric(18, 0),
		VTE_ANNO varchar(4),
		VTE_MES numeric(18, 0),
		idEmpresa INT,
		idSucursal INT
	);
	
	DECLARE @BaseSucursal VARCHAR(100);
	DECLARE @aux VARCHAR(MAX) = '';
	
	
	
	WHILE ( @Current <= @Max )
		BEGIN			
			SELECT @VIN = VIN, @Documento = Documento, @idSucursal = idSucursal FROM @VinDocumentos WHERE Id = @Current;

			SET NOCOUNT ON;
			
			SET @BaseSucursal = (SELECT servidor FROM @tableConf WHERE idEmpresa = @idEmpresa AND idSucursal = @idSucursal);
			
			
	--		-- SELECT * FROM [GAAU_Universidad].[dbo].[ADE_VTAFI]
			
			
			SET @aux ='SELECT 
							VTE_TIPODOCTO,		VTE_DOCTO,			VTE_IDCLIENTE,	VTE_FECHDOCTO,
							VTE_HORADOCTO,		VTE_REFERENCIA1,	VTE_FORMAPAGO,	VTE_VTABRUT,
							VTE_IVA,			VTE_TOTAL,			VTE_SERIE,		VTE_CVEUSU,
							VTE_FECHOPE,		VTE_IVADESG,		VTE_IVAPLICADO,	VTE_TIPO,
							VTE_CONSECUTIVO,	VTE_ANNO,			VTE_MES,
							idEmpresa = ' + CONVERT( VARCHAR(3), @idEmpresa ) + ',
							idSucursal = ' + CONVERT( VARCHAR(3), @idSucursal ) + '
						FROM '+ @BaseSucursal +'.[ADE_VTAFI] 
						WHERE VTE_SERIE  = '''+ @VIN +'''
							  AND VTE_STATUS = ''I'';';
					
	
			INSERT INTO @Ventas
			EXECUTE( @aux );
			
			
			SET @Current = @Current + 1;
	END
	
	SELECT * FROM @Ventas;
			
	-- DELETE FROM @Ventas;
	
END TRY
BEGIN CATCH
	SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
END CATCH

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ing. Alejandro Grijalva Antonio
-- Create date: 2018-02-09
-- Description:	Monitoreo de Ventas de Unidades
-- [dbo].[BRPO_VENTAS_SP] 4
-- =============================================
ALTER PROCEDURE [dbo].[BRPO_VENTAS_SP]
	@idEmpresa INT = 1
AS
BEGIN
	BEGIN TRY
		DECLARE @VinDocumentos TABLE( Id INT IDENTITY, idEmpresa INT, idSucursal INT, VIN VARCHAR(17), Documento VARCHAR(20) );
		INSERT INTO @VinDocumentos 
		SELECT * FROM [dbo].[VINDOCUMENTOS_VIEW] WHERE idEmpresa = @idEmpresa;
		
		DECLARE @Current INT, @Max INT;
		SELECT @Current = MIN( Id ), @Max = MAX(Id) FROM @VinDocumentos;
		
		DECLARE @VIN VARCHAR(17) = '',
				@idSucursal INT = 0,
				@Documento VARCHAR(20) = '';
		
		DECLARE @tableConf  TABLE(idEmpresa INT, idSucursal INT, servidor VARCHAR(250), baseConcentra VARCHAR(250), sqlCmd VARCHAR(8000), cargaDiaria VARCHAR(8000));
		INSERT INTO @tableConf Execute [dbo].[SEL_ACTIVE_DATABASES_SP];
		
		DECLARE @Ventas TABLE(
			idEmpresa INT,
			idSucursal INT,
			CCP_IDDOCTO VARCHAR(20),
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
			VTE_MES numeric(18, 0)
		);
		
		DECLARE @BaseSucursal VARCHAR(100);
		DECLARE @aux VARCHAR(MAX) = '';
		
		WHILE ( @Current <= @Max )
			BEGIN			
				SELECT @VIN = VIN, @Documento = Documento, @idSucursal = idSucursal FROM @VinDocumentos WHERE Id = @Current;
				SET NOCOUNT ON;			
				SET @BaseSucursal = (SELECT servidor FROM @tableConf WHERE idEmpresa = @idEmpresa AND idSucursal = @idSucursal);
				SET @aux ='SELECT 
								' + CONVERT( VARCHAR(3), @idEmpresa ) + ' as idEmpresa,
								' + CONVERT( VARCHAR(3), @idSucursal ) + ' as idSucursal,
								''' + @Documento + ''' as Documento,
								VTE_TIPODOCTO,		VTE_DOCTO,			VTE_IDCLIENTE,	VTE_FECHDOCTO,
								VTE_HORADOCTO,		VTE_REFERENCIA1,	VTE_FORMAPAGO,	VTE_VTABRUT,
								VTE_IVA,			VTE_TOTAL,			VTE_SERIE,		VTE_CVEUSU,
								VTE_FECHOPE,		VTE_IVADESG,		VTE_IVAPLICADO,	VTE_TIPO,
								VTE_CONSECUTIVO,	VTE_ANNO,			VTE_MES
								
							FROM '+ @BaseSucursal +'.[ADE_VTAFI] 
							WHERE VTE_SERIE  = '''+ @VIN +'''
								  AND VTE_STATUS = ''I'';';
						
				INSERT INTO @Ventas
				EXECUTE( @aux );
				
				SET @Current = @Current + 1;
		END
		
		INSERT INTO Venta(
			idEmpresa,			idSucursal,			CCP_IDDOCTO,
			VTE_TIPODOCTO,		VTE_DOCTO,			VTE_IDCLIENTE,	VTE_FECHDOCTO,
			VTE_HORADOCTO,		VTE_REFERENCIA1,	VTE_FORMAPAGO,	VTE_VTABRUT,
			VTE_IVA,			VTE_TOTAL,			VTE_SERIE,		VTE_CVEUSU,
			VTE_FECHOPE,		VTE_IVADESG,		VTE_IVAPLICADO,	VTE_TIPO,
			VTE_CONSECUTIVO,	VTE_ANNO,			VTE_MES
		)
		SELECT	
			TEMP.idEmpresa,			TEMP.idSucursal,		TEMP.CCP_IDDOCTO,
			TEMP.VTE_TIPODOCTO,		TEMP.VTE_DOCTO,			TEMP.VTE_IDCLIENTE,		TEMP.VTE_FECHDOCTO,
			TEMP.VTE_HORADOCTO,		TEMP.VTE_REFERENCIA1,	TEMP.VTE_FORMAPAGO,		TEMP.VTE_VTABRUT,
			TEMP.VTE_IVA,			TEMP.VTE_TOTAL,			TEMP.VTE_SERIE,			TEMP.VTE_CVEUSU,
			TEMP.VTE_FECHOPE,		TEMP.VTE_IVADESG,		TEMP.VTE_IVAPLICADO,	TEMP.VTE_TIPO,
			TEMP.VTE_CONSECUTIVO,	TEMP.VTE_ANNO,			TEMP.VTE_MES
		FROM @Ventas TEMP
		LEFT JOIN Venta VEN ON VEN.idEmpresa		= TEMP.idEmpresa
								AND VEN.idSucursal		= TEMP.idSucursal
								AND VEN.CCP_IDDOCTO		= TEMP.CCP_IDDOCTO
								AND VEN.VTE_DOCTO		= TEMP.VTE_DOCTO
								AND VEN.VTE_IDCLIENTE	= TEMP.VTE_IDCLIENTE
								AND VEN.VTE_FECHDOCTO	= TEMP.VTE_FECHDOCTO
								AND VEN.VTE_HORADOCTO	= TEMP.VTE_HORADOCTO
								AND VEN.VTE_SERIE		= TEMP.VTE_SERIE
		WHERE VEN.VTE_DOCTO IS NULL;
	END TRY
	BEGIN CATCH
		SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
	END CATCH
END
GO

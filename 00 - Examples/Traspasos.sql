USE [PlanPiso];
BEGIN TRY
	DECLARE @idEmpresa INT = 4;
	DECLARE @VinDocumentos TABLE( Id INT IDENTITY, idEmpresa INT, VIN VARCHAR(17), Documento VARCHAR(20) );

	INSERT INTO @VinDocumentos
	SELECT idEmpresa, CCP_OBSGEN as VIN, CCP_IDDOCTO FROM Documentos WHERE CCP_IDDOCTO LIKE '%-%-%-%-%-%' AND CCP_OBSGEN != '' AND idEmpresa = @idEmpresa
	UNION
	SELECT idEmpresa, CCP_IDDOCTO as VIN, CCP_IDDOCTO FROM Documentos WHERE CCP_IDDOCTO NOT LIKE '%-%-%-%-%-%' AND LEN( CCP_IDDOCTO ) = 17  AND idEmpresa = @idEmpresa
	UNION
	SELECT idEmpresa, SUBSTRING( CCP_IDDOCTO, 1, 17 ) as VIN, CCP_IDDOCTO FROM Documentos WHERE CCP_IDDOCTO NOT LIKE '%-%-%-%-%-%' AND LEN( CCP_IDDOCTO ) = 19 AND idEmpresa = @idEmpresa
	UNION
	SELECT idEmpresa, CCP_OBSGEN as VIN, CCP_IDDOCTO FROM Documentos WHERE CCP_IDDOCTO NOT LIKE '%-%-%-%-%-%' AND LEN( CCP_IDDOCTO ) < 17 AND CCP_OBSGEN != '' AND idEmpresa = @idEmpresa
	UNION
	SELECT idEmpresa, SUBSTRING( CCP_IDDOCTO, 2, 17 ) as VIN, CCP_IDDOCTO FROM Documentos WHERE CCP_IDDOCTO NOT LIKE '%-%-%-%-%-%' AND LEN( CCP_IDDOCTO ) = 18 AND idEmpresa = @idEmpresa
	
	DECLARE @Current INT, @Max INT;
	SELECT @Current = MIN( Id ), @Max = MAX(Id) FROM @VinDocumentos;
	
	DECLARE @VIN VARCHAR(17) = '',
			@Documento VARCHAR(20);
	
	DECLARE @tableConf  TABLE(idEmpresa INT, idSucursal INT, servidor VARCHAR(250), baseConcentra VARCHAR(250), sqlCmd VARCHAR(8000), cargaDiaria VARCHAR(8000));
	INSERT INTO @tableConf Execute [dbo].[SEL_ACTIVE_DATABASES_SP];
	DECLARE @Traspasos TABLE( idTraspasoLocal INT IDENTITY, idTraspaso INT, VIN VARCHAR(17), idSucursalEnvia VARCHAR(100), idSucursalRecibe VARCHAR(100), fechaOperacion DATE, sitacion VARCHAR(10) );
	DECLARE @BaseConcentra VARCHAR(100);
	DECLARE @aux VARCHAR(MAX) = '';
	
	WHILE ( @Current <= @Max )
		BEGIN			
			SELECT @VIN = VIN, @Documento = Documento FROM @VinDocumentos WHERE Id = @Current;

			SET NOCOUNT ON;
			
			SET @BaseConcentra  = (SELECT TOP 1 baseConcentra FROM @tableConf WHERE idEmpresa = @idEmpresa);
			
			SET @aux = 
					'SELECT 
						idTraspaso		 = TRA_NUMTRASPASO, 
						VIN				 = TRA_NUMSERIE, 
						idSucursalEnvia  = TRA_SUCENVIA, 
						idSucursalRecibe = TRA_SUCRECIBE, 
						fechaOperacion   = TRA_FECHOPE, 
						sitacion		 = TRA_SITUACION
					FROM '+ @BaseConcentra +'.UNI_TRASPASOS 
					WHERE TRA_NUMSERIE  = '''+ @VIN +''' 
					ORDER BY TRA_NUMTRASPASO DESC;';

			INSERT INTO @Traspasos
			EXECUTE( @aux );
			
			-- SELECT * FROM @Traspasos TEMP LEFT JOIN Traspaso TRA ON TRA.TRA_NUMTRASPASO = TEMP.idTraspaso WHERE TRA.TRA_NUMTRASPASO IS NULL
			IF EXISTS( SELECT * FROM @Traspasos TEMP LEFT JOIN Traspaso TRA ON TRA.TRA_NUMTRASPASO = TEMP.idTraspaso WHERE TRA.TRA_NUMTRASPASO IS NULL )
				BEGIN
					DECLARE @idSucursalRecibe VARCHAR( 25 ) = ( SELECT TOP 1 idSucursalRecibe FROM @Traspasos ORDER BY idTraspaso DESC );
					
					UPDATE Documentos 
					SET idSucursal = (SELECT idSucursal FROM @tableConf WHERE servidor LIKE '%' + @idSucursalRecibe + '%')
					WHERE CCP_IDDOCTO = @Documento;
				END
			
			INSERT INTO Traspaso(idEmpresa, TRA_NUMTRASPASO, VIN, CCP_IDDOCTO, idSucursalEnvia, idSucursalRecibe, fechaOperacion, sitacion)
			SELECT  idEmpresa = @idEmpresa,
					TEMP.idTraspaso,
					TEMP.VIN,
					CCP_IDDOCTO = @Documento,
					idSucursalEnvia  = (SELECT idSucursal FROM @tableConf WHERE servidor LIKE '%' + TEMP.idSucursalEnvia + '%'),
					idSucursalRecibe = (SELECT idSucursal FROM @tableConf WHERE servidor LIKE '%' + TEMP.idSucursalRecibe + '%'),
					TEMP.fechaOperacion,
					TEMP.sitacion
			FROM @Traspasos TEMP
			LEFT JOIN Traspaso TRA ON TRA.TRA_NUMTRASPASO = TEMP.idTraspaso
			WHERE TRA.TRA_NUMTRASPASO IS NULL;
			
			
			DELETE FROM @Traspasos;
			
			SET @Current = @Current + 1;
		END
	
END TRY
BEGIN CATCH
	SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
END CATCH

USE [PlanPiso]
GO
/****** Object:  StoredProcedure [dbo].[BPRO_TRASPASOS_SP]    Script Date: 02/09/2018 11:30:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ing. Alejandro Grijalva Antonio
-- Create date: 2018-02-08
-- Description:	
-- [BPRO_TRASPASOS_SP] 1
-- =============================================
ALTER PROCEDURE [dbo].[BPRO_TRASPASOS_SP]
	@idEmpresa INT = 0
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON;
		DECLARE @VinDocumentos TABLE( Id INT IDENTITY, idEmpresa INT, idSucursal INT, VIN VARCHAR(17), Documento VARCHAR(20) );

		INSERT INTO @VinDocumentos 
		SELECT * FROM [dbo].[VINDOCUMENTOS_VIEW] WHERE idEmpresa = @idEmpresa;
		
		DECLARE @Current INT, @Max INT;
		SELECT @Current = MIN( Id ), @Max = MAX(Id) FROM @VinDocumentos;
		
		DECLARE @VIN VARCHAR(17) = '',
				@Documento VARCHAR(20);
		
		DECLARE @tableConf  TABLE(idEmpresa INT, idSucursal INT, servidor VARCHAR(250), baseConcentra VARCHAR(250), sqlCmd VARCHAR(8000), cargaDiaria VARCHAR(8000));
		INSERT INTO @tableConf Execute [dbo].[SEL_ACTIVE_DATABASES_SP];
		DECLARE @Traspasos TABLE( idTraspasoLocal INT IDENTITY, idTraspaso INT, VIN VARCHAR(17), idSucursalEnvia VARCHAR(100), idSucursalRecibe VARCHAR(100), fechaOperacion DATE, sitacion VARCHAR(10) );
		DECLARE @BaseConcentra VARCHAR(100);
		DECLARE @fecha VARCHAR(100);
		DECLARE @aux VARCHAR(MAX) = '';
		
		SET @fecha = (SELECT par_DatVal FROM [dbo].[Parametros] WHERE idEmpresa = @idEmpresa AND par_grupo = 'CARTE');
		
		-- Se recorre todos los VIN disponibles.
		WHILE ( @Current <= @Max )
			BEGIN			
				SELECT @VIN = VIN, @Documento = Documento FROM @VinDocumentos WHERE Id = @Current;
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
						WHERE TRA_NUMSERIE		= '''+ @VIN +''' 
							  AND TRA_STATUS	= ''R''
							  AND TRA_FECHOPE	>= CONVERT(DATE,'''+@fecha+''')
						ORDER BY TRA_NUMTRASPASO DESC;';

				INSERT INTO @Traspasos
				EXECUTE( @aux );
				
				-- Si un traspaso se realizo se cambia la tabla de Documentos las Sucursal a la que se traspaso
				IF EXISTS( SELECT * FROM @Traspasos TEMP LEFT JOIN Traspaso TRA ON TRA.TRA_NUMTRASPASO = TEMP.idTraspaso WHERE TRA.TRA_NUMTRASPASO IS NULL )
					BEGIN
						DECLARE @idSucursalRecibe VARCHAR( 25 ) = ( SELECT TOP 1 idSucursalRecibe FROM @Traspasos ORDER BY idTraspaso DESC );
						
						UPDATE Documentos 
						SET idSucursal = (SELECT idSucursal FROM @tableConf WHERE servidor LIKE '%' + @idSucursalRecibe + '%')
						WHERE CCP_IDDOCTO = @Documento;
					END
				
				-- Se crea una tabla temporal para controlar los nuevos movimientos sucedidos
				SELECT  CCP_IDDOCTO			= @Documento,
						VIN					= TEMP.VIN,
						usuarioID			= 0,
						empresaID			= @idEmpresa,
						idSucursalEnvia		= ( SELECT idSucursal FROM @tableConf WHERE servidor LIKE '%' + TEMP.idSucursalEnvia + '%' ),
						idSucursalRecibe	= ( SELECT idSucursal FROM @tableConf WHERE servidor LIKE '%' + TEMP.idSucursalRecibe + '%' ),
						financieraID		= MOV.financieraID,
						esquemaID			= MOV.esquemaID,
						fecha				= TEMP.fechaOperacion,
						monto				= 0,
						active				= 0,
						tipoMovimientoId	= 2,
						genericID			= 0,
						fecha_originar		= TEMP.fechaOperacion,
						idTraspaso			= TEMP.idTraspaso
				INTO #TraspasoActivo
				FROM @Traspasos TEMP
				LEFT JOIN Traspaso TRA ON TRA.TRA_NUMTRASPASO = TEMP.idTraspaso
				INNER JOIN Movimiento MOV ON MOV.CCP_IDDOCTO = @Documento AND active = 1
				WHERE TRA.TRA_NUMTRASPASO IS NULL;
				
				--SELECT * FROM #TraspasoActivo;
				-- Se insertan los nuevos traspasos a la tabla Traspasos
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
				WHERE TRA.TRA_NUMTRASPASO IS NULL
				ORDER BY idTraspaso ASC;
				
				-- Se actualiza los "active" de los movimientos que quedan como historicos
				UPDATE MOV
				SET active = 0
				FROM #TraspasoActivo TEMP
				INNER JOIN Movimiento MOV ON TEMP.CCP_IDDOCTO = MOV.CCP_IDDOCTO;
				
				UPDATE TEMP
				SET genericID	= ( SELECT idTraspaso FROM traspaso WHERE TRA_NUMTRASPASO = TEMP.idTraspaso )
				FROM #TraspasoActivo TEMP
				
				-- SELECT * FROM #TraspasoActivo;
				
				
				UPDATE T
				SET T.ACTIVE = 1
				FROM #TraspasoActivo T
				INNER JOIN (
					SELECT CCP_IDDOCTO, MAX(genericID) genericID
					FROM #TraspasoActivo 
					GROUP BY CCP_IDDOCTO ) T2 ON T.CCP_IDDOCTO=T2.CCP_IDDOCTO AND T.genericID = T2.genericID
					
				-- Se inserta los nuevos movimientos Traspasos
				INSERT INTO Movimiento(
					[CCP_IDDOCTO],
					[VIN],
					[usuarioID],
					[empresaID],
					[sucursalID],
					[sucursalOrigenID],
					[financieraID],
					[esquemaID],
					[fecha],
					[active],
					[tipoMovimientoId],
					[genericID],
					[fecha_original],
					[fecha_calculo]
				)
				SELECT	CCP_IDDOCTO,
						VIN,
						usuarioID,
						empresaID,
						idSucursalRecibe,
						idSucursalEnvia,
						financieraID,
						esquemaID,
						fecha,
						active,
						tipoMovimientoId,
						genericID,
						fecha_originar,
						GETDATE()
				FROM #TraspasoActivo TEMP
				ORDER BY idTraspaso ASC;
				
				DELETE FROM @Traspasos;
				DROP TABLE #TraspasoActivo;
				
				SET @Current = @Current + 1;
			END
	END TRY
	BEGIN CATCH
		DROP TABLE #TraspasoActivo;
		SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
	END CATCH
END

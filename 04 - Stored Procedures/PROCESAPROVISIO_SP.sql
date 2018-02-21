SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ing. Alejandro Grijalva Antonio
-- Create date: 208-02-19
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[PROCESAPROVISIO_SP]
	@conse INT = 0
AS
BEGIN
	--DECLARE @conse INT = 3;
	DECLARE @sucCurrent INT = 0, @sucMax INT = 0;
	DECLARE @idSucursalActual INT = 0, @idEmpresa INT = 0;
	DECLARE @sucImplicadas INT = (SELECT COUNT(DISTINCT(idSucursal)) FROM Provision WHERE consecutivo = @conse);

	SET @idEmpresa = (SELECT TOP 1 idEmpresa FROM Provision WHERE consecutivo = @conse);

	-- Table temporal de sucursales implicadas
	DECLARE @tblSucursal TABLE( ID INT IDENTITY, idSucursal INT );
	INSERT INTO @tblSucursal( idSucursal )
	SELECT DISTINCT(idSucursal) 
	FROM Provision
	WHERE consecutivo = @conse AND estatus = 1

	-- Tabla temporal de los id´s de las cabeceras
	DECLARE @tblEncabezado TABLE( ID INT IDENTITY, idSucuersal INT, idEncabezado INT );

	SELECT @sucCurrent = MIN(ID), @sucMax = MAX(ID) FROM @tblSucursal
	WHILE( @sucCurrent <= @sucMax )
		BEGIN
			SET @idSucursalActual = ( SELECT idSucursal FROM @tblSucursal WHERE ID = @sucCurrent );
			
			INSERT INTO [plp_planpisoenc]
			SELECT 
				[pro_idtipoproceso]		= 1,
				[ple_idempresa]			= @idEmpresa,
				[ple_idsucursal]		= @idSucursalActual,
				[ple_tipopoliza]		= 1,
				[ple_fechapoliza]		= GETDATE(),
				[ple_concepto]			= 'PLAN PISO',
				[ple_fechageneracion]	= GETDATE(),
				[ple_conspol]			= 0,
				[ple_mes]				= 0,
				[ple_año]				= 0,
				[ple_estatus]			= 0;
			
			INSERT INTO [plp_planpisodet]
			SELECT
				[ple_idplanpiso]		= @@IDENTITY,
				[pld_consecutivo]		= 1,
				[pld_numcuenta]			= '00000987654',
				[pld_concepto]			= 'PLAN PISO',
				[pld_cargo]				= interesAplicar,
				[pld_abono]				= 0,
				[pld_idpersona]			= 0,
				[pld_iddocumento]		= CCP_DOCUMENTO,
				[pld_tipodocumento]		= 1,
				[pld_vin]				= V.VIN,
				[pld_fechavencimiento]	= GETDATE(),
				[pld_porcentajeiva]		= 16,
				[pld_afecta]			= '1',
				[idProvision]			= idProvision
			FROM Provision P
			LEFT JOIN VINDOCUMENTOS_VIEW V ON P.CCP_DOCUMENTO = V.CCP_IDDOCTO
			WHERE consecutivo = @conse 
				  AND P.idSucursal = @idSucursalActual;
				  
			UPDATE Provision SET estatus = 2 WHERE consecutivo = @conse AND idSucursal = @idSucursalActual;
			SET @sucCurrent = @sucCurrent + 1;
		END
END
GO

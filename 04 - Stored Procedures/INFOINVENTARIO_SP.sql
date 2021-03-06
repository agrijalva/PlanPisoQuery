USE [PlanPiso]
GO
/****** Object:  StoredProcedure [dbo].[INFOINVENTARIO_SP]    Script Date: 02/09/2018 11:31:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ing. Alejandro Grijalva Antonio
-- Create date: 2018-02-06
-- Description:	Se obtiene la sucursal primera en donde se obtuvo interacción
-- =============================================
ALTER PROCEDURE [dbo].[INFOINVENTARIO_SP]
	@idEmpresa  INT  = 0,
	@VIN VARCHAR(17) = '',
	@tipo INT		 = 1
AS
BEGIN
	SET NOCOUNT ON;
	-- Se obtiene la relacioón de las bases de datos para el dinamismo.
	DECLARE @tableConf  TABLE(idEmpresa INT, idSucursal INT, servidor VARCHAR(250), baseConcentra VARCHAR(250), sqlCmd VARCHAR(8000), cargaDiaria VARCHAR(8000));
	INSERT INTO @tableConf Execute [dbo].[SEL_ACTIVE_DATABASES_SP];

	DECLARE @tblSucActiva  TABLE(id INT IDENTITY, idSucursal INT, vin VARCHAR(17), base VARCHAR(MAX), baseConcentra VARCHAR(MAX));

	-- Se obtiene la base de datos en relacion a la sucursal y empresa.
	DECLARE @Base VARCHAR(MAX) = '';
	DECLARE @BaseConcentra VARCHAR(MAX) = '';

	DECLARE @Current INT = 0, @Max INT = 0;
	SELECT @Current = MIN(idSucursal),@Max = MAX(idSucursal) FROM @tableConf WHERE idEmpresa = @idEmpresa;

	-- BÚSQUEDA DE UNIDADES EN LAS SUCURSALES

	WHILE(@Current <= @Max )
		BEGIN
			SET @Base			= (SELECT servidor FROM @tableConf WHERE idSucursal = @Current);
			SET @BaseConcentra  = (SELECT baseConcentra FROM @tableConf WHERE idSucursal = @Current);
			-- PRINT(@BaseConcentra);
			
			INSERT INTO @tblSucActiva EXECUTE('SELECT SUC = '+ @Current +', VEH_NUMSERIE, '''+ @Base +''', '''+@BaseConcentra+''' FROM '+ @Base +'.SER_VEHICULO WHERE VEH_NUMSERIE = ''' + @vin + ''' AND VEH_SITUACION != ''''');
			SET	@Current = @Current + 1;
		END 
		
	DECLARE @total INT = (SELECT COUNT(id) FROM @tblSucActiva);
	
	IF( @total = 0 )		-- El VIN proporcionado no es correcto
		BEGIN
			-- RETURN (SELECT sucursal_matriz FROM Centralizacionv2..DIG_CAT_BASES_BPRO WHERE emp_idempresa = @idEmpresa AND tipo = 2);
			RETURN 0;
		END
	ELSE IF (@total = 1)	-- El VIN proporcinado no se ha movido de su sucursal de compra
		BEGIN
			RETURN (SELECT idSucursal FROM @tblSucActiva);
		END
	ELSE IF(@total > 1)		-- El VIN proporcionado se ha movido de sucursal
		BEGIN
			DECLARE @aux VARCHAR(MAX) = '';
			IF( @tipo = 1 )   -- Current
				BEGIN
					SET @aux = 
					'SELECT TOP 1 TRA_SUCRECIBE FROM '+ @BaseConcentra +'.UNI_TRASPASOS 
					WHERE TRA_NUMSERIE  = '''+ @VIN +''' 
					ORDER BY TRA_NUMTRASPASO DESC;';
				END
			ELSE IF( @tipo = 2 )  -- Compra
				BEGIN
					SET @aux = 
					'SELECT TOP 1 TRA_SUCENVIA FROM '+ @BaseConcentra +'.UNI_TRASPASOS 
					WHERE TRA_NUMSERIE  = '''+ @VIN +''' 
					ORDER BY TRA_NUMTRASPASO ASC;';
				END
			
			
			DECLARE @strSucursal VARCHAR(100) = '';
			DECLARE @tblSucStr TABLE( VIN VARCHAR(100) );
			
			
			INSERT INTO @tblSucStr
			EXECUTE( @aux );
						
			SET @strSucursal = (SELECT VIN FROM @tblSucStr);
			RETURN (SELECT idSucursal FROM @tableConf WHERE servidor LIKE '%' + @strSucursal + '%');
		END
END

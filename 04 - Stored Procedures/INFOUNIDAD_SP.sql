USE [PlanPiso]
GO
/****** Object:  StoredProcedure [dbo].[INFOUNIDAD_SP]    Script Date: 02/09/2018 11:31:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ing. Alejandro Grijalva Antonio
-- Create date: 2018-02-16
-- Description:	Obtención de la información de las unidades mediante el VIN
-- =============================================
ALTER PROCEDURE [dbo].[INFOUNIDAD_SP]
	@idEmpresa  INT  = 1,
	@idSucursal INT  = 3,
	@VIN VARCHAR(17) = 'JS2ZC63S9J6104103'
AS
BEGIN
	-- Se obtiene la relacioón de las bases de datos para el dinamismo.
	DECLARE @tableConf  TABLE(idEmpresa INT, idSucursal INT, servidor VARCHAR(250), baseConcentra VARCHAR(250), sqlCmd VARCHAR(8000), cargaDiaria VARCHAR(8000));
	INSERT INTO @tableConf Execute [dbo].[SEL_ACTIVE_DATABASES_SP];
	
	-- Se obtiene la base de datos en relacion a la sucursal y empresa.
	DECLARE @base VARCHAR(300) = (SELECT servidor FROM @tableConf WHERE idEmpresa = @idEmpresa AND idSucursal = @idSucursal);
	
	-- Los datos de las unidades se encuentra en la tabla VEH_NUMSERIE de cada una de las sucusales
	DECLARE @queryString VARCHAR(MAX) = 'SELECT * FROM ' + @base + '.SER_VEHICULO WHERE VEH_NUMSERIE = ''' + @VIN + '''';

	EXECUTE( @queryString );

END

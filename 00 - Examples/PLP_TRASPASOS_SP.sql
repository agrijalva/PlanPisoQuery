SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ing. Alejandro Grijalva Antonio
-- Create date: 2018-01-26
-- Description:	Búsqueda de traspasos
-- =============================================
CREATE PROCEDURE PLP_TRASPASOS_SP
	@idEmpresa INT		= 0,
	@vin VARCHAR(17)	= ''
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @queryString VARCHAR(MAX)   = '';
	DECLARE @Base VARCHAR(MAX)			= '';

	-- Consulta de las bases de datos y sucursales activas
	DECLARE @tableConf TABLE(idEmpresa INT, idSucursal INT, servidor VARCHAR(250), baseConcentra VARCHAR(250), sqlCmd VARCHAR(8000), cargaDiaria VARCHAR(8000));
	INSERT INTO @tableConf Execute [dbo].[SEL_ACTIVE_DATABASES_SP];

	DECLARE @tblTraspaso TABLE( TRA_NUMTRASPASO NUMERIC(18,0),
							  TRA_NUMSERIE VARCHAR(17),
							  TRA_SUCENVIA VARCHAR(50),
							  TRA_SUCRECIBE VARCHAR(50),
							  TRA_FECHOPE VARCHAR(10));
							  
	SET @Base = ( SELECT TOP 1 baseConcentra FROM @tableConf WHERE idEmpresa = @idEmpresa );

	SET @queryString = 'SELECT
							TRA_NUMTRASPASO,
							TRA_NUMSERIE,
							TRA_SUCENVIA,
							TRA_SUCRECIBE,
							TRA_FECHOPE
						FROM '+ @Base +'.[UNI_TRASPASOS] WHERE TRA_NUMSERIE = '''+ @vin +''';';

	INSERT INTO @tblTraspaso
	EXECUTE(@queryString);

	SELECT
		TRA_NUMTRASPASO,
		TRA_NUMSERIE,
		TRA_SUCENVIA,
		TRA_SUCRECIBE,
		TRA_FECHOPE,
		idSucursalEnvia = ( SELECT idSucursal FROM @tableConf WHERE idEmpresa = @idEmpresa  AND servidor LIKE '%'+ TRA_SUCENVIA COLLATE Modern_Spanish_CI_AS +'%' ),
		idSucursalRecibe = ( SELECT idSucursal FROM @tableConf WHERE idEmpresa = @idEmpresa AND servidor LIKE '%'+ TRA_SUCRECIBE COLLATE Modern_Spanish_CI_AS +'%' )
	FROM @tblTraspaso ORDER BY TRA_NUMTRASPASO ASC;
END
GO

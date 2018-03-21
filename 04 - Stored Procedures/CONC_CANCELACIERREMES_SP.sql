SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ing. Alejandro Grijalva Antonio
-- Create date: 2018-03-09
-- Description:	Cancelación de Provisiones de cierre de mes
-- =============================================
ALTER PROCEDURE [dbo].[CONC_CANCELACIERREMES_SP]
	@periodo INT = 0,
	@anio INT = 0
AS
BEGIN
	-- DECLARE @periodo INT = 3, @anio INT = 2018; 
	
	DECLARE @plp_planpisoenc TABLE(
		rownumber BIGINT,
		ple_idplanpiso NUMERIC(18, 0),
		pro_idtipoproceso INT,
		ple_idempresa INT,
		ple_idsucursal INT,
		ple_tipopoliza VARCHAR(20) ,
		ple_fechapoliza DATETIME,
		ple_concepto VARCHAR(200),
		ple_fechageneracion DATETIME,
		ple_conspol INT,
		ple_mes INT,
		ple_año VARCHAR(4),
		ple_estatus INT
	)

	INSERT INTO @plp_planpisoenc 
	SELECT ROW_NUMBER() OVER(ORDER BY ple_idplanpiso ASC) AS RowNum
		  ,[ple_idplanpiso]
		  ,[pro_idtipoproceso]
		  ,[ple_idempresa]
		  ,[ple_idsucursal]
		  ,[ple_tipopoliza]
		  ,[ple_fechapoliza]
		  ,[ple_concepto]
		  ,[ple_fechageneracion]
		  ,[ple_conspol]
		  ,[ple_mes]
		  ,[ple_año]
		  ,[ple_estatus]
	FROM [dbo].[plp_planpisoenc]
	WHERE pro_idtipoproceso = 3
		  AND MONTH(ple_fechapoliza)= @periodo
		  AND YEAR(ple_fechapoliza)= @anio
		  AND ple_conspol IS NOT NULL;

	DECLARE @totalregistos INT, 
			@icontador     INT ,
			@planPisoIDPadre BIGINT,
			@ple_idplanpiso BIGINT;

	SET @icontador = 1 

	SELECT @totalregistos = COUNT(*) FROM @plp_planpisoenc

	WHILE @icontador <= @totalregistos 
		BEGIN 

			INSERT INTO [dbo].[plp_cancelapoliza]
					   ([plc_idempresa]
					   ,[plc_idsucursal]
					   ,[plc_tipopoliza]
					   ,[plc_conspol]
					   ,[plc_mes]
					   ,[plc_año]
					   ,[plc_estatus])
			SELECT 
				ple_idempresa,
				ple_idsucursal,
				ple_tipopoliza,
				ple_conspol,
				ple_mes,
				ple_año,
				ple_estatus
			FROM   @plp_planpisoenc 
			WHERE  rownumber = @icontador ;

			SET @ple_idplanpiso = SCOPE_IDENTITY()

			SELECT @planPisoIDPadre = ple_idplanpiso FROM @plp_planpisoenc WHERE  rownumber = @icontador 

			INSERT INTO [dbo].[relPolizasCanceladas]([planpisoIDPadre],[planpisoID]) VALUES(@planPisoIDPadre,@ple_idplanpiso)
			SET @icontador=@icontador + 1 
		END
		
	UPDATE p SET ple_estatus = 2
	FROM plp_planpisoenc p 
	WHERE	ple_estatus = 0
			AND ple_conspol IS NULL
			AND pro_idtipoproceso = 3
			AND MONTH(ple_fechapoliza)= @periodo
			AND YEAR(ple_fechapoliza)= @anio
END
GO

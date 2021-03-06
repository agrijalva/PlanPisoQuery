USE [PlanPiso]
GO
/****** Object:  UserDefinedFunction [dbo].[GetFixedInterestPrevious]    Script Date: 01/23/2018 15:59:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[INVENTARIO_FN] ( 
	@base VARCHAR(200),
	@vin VARCHAR(17),
	@idEmpresa INT,
	@idSucursal INT
)
RETURNS VARCHAR(MAX) 
AS
BEGIN
	DECLARE @query VARCHAR(MAX);
	
	SET @query = 
		'SELECT 
				empresa  = '+ CONVERT( VARCHAR(100),@idEmpresa ) +',
				sucursal = '+ CONVERT( VARCHAR(100),@idSucursal ) +',
				VEH_NUMSERIE, 
				VEH_SITUACION,
				VEH_CATALOGO,
				VEH_ANMODELO, *
		 FROM '+ @base +'.SER_VEHICULO 
		 WHERE VEH_NUMSERIE = ''' + @vin + '''';
		
	RETURN @query;
END


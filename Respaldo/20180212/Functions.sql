USE [PlanPiso]
GO
/****** Object:  UserDefinedFunction [dbo].[IsOverlapDate]    Script Date: 02/12/2018 18:32:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION [dbo].[IsOverlapDate] (@dateA AS DATE,@dateB AS DATE,@dateC AS DATE,@dateD AS DATE)
RETURNS BIT 
AS
BEGIN
	

	DECLARE @isOverlap AS BIT = 0

	if (NOT(@dateB <= @dateC OR @dateA >= @dateD)) 
		begin 
			SET @isOverlap = 1	
			--print ('OVERLAP')
		end
	else
		begin
			SET @isOverlap = 0
			--print ('NOTOVERLAP')
		end
					
	RETURN @isOverlap 
	

	

END
GO
/****** Object:  UserDefinedFunction [dbo].[INVENTARIO_FN]    Script Date: 02/12/2018 18:32:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[INVENTARIO_FN] ( 
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
				empresa = '+ CONVERT( VARCHAR(100),@idEmpresa ) +',
				sucursal = '+ CONVERT( VARCHAR(100),@idSucursal ) +',
				VEH_NUMSERIE, 
				VEH_SITUACION,
				VEH_CATALOGO,
				VEH_ANMODELO, *
		 FROM '+ @base +'.SER_VEHICULO 
		 WHERE VEH_NUMSERIE = ''' + @vin + '''';
		
	RETURN @query;
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetTiie]    Script Date: 02/12/2018 18:32:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION [dbo].[GetTiie] (@type AS int, @iniDate AS date= null,@finDate AS date=null)
RETURNS NUMERIC(18,4) 
AS
BEGIN
	

	DECLARE @tiie AS NUMERIC(18,4) 
	
	select @tiie= case 
	when @type =1 then (SELECT  [porcentaje] FROM Tiie  WHERE [tiieID] = (SELECT MAX([tiieID] ) FROM Tiie ))
	when @type =2 then  (SELECT isnull(avg([porcentaje]),0) FROM  Tiie where fecha between @iniDate and  @finDate )
	else 0
	end  
		
	RETURN @tiie
	

	

END
GO

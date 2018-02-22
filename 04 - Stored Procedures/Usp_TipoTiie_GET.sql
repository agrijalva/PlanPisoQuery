USE [PlanPiso]
GO
/****** Object:  StoredProcedure [dbo].[Usp_TipoTiie_GET]    Script Date: 02/21/2018 16:52:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Irving Solorio>
-- Create date: <19/01/2018>
-- Description:	<Obtiene tipo Tiie>
-- =============================================
ALTER PROCEDURE [dbo].[Usp_TipoTiie_GET]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
  
	SELECT  [tipoTiieId]
      ,[tipoTiie]
      ,[activo]
	FROM [PlanPiso].[dbo].[TipoTiie]		

	
END

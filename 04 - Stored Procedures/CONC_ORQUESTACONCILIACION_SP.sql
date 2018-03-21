SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ing. Alejandro Grijalva Antonio
-- Create date: 2018-03-09
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[CONC_ORQUESTACONCILIACION_SP]
	@periodo INT = 0,
	@anio INT = 0
AS
BEGIN
	EXEC [dbo].[CONC_CANCELACIERREMES_SP] @periodo, @anio;
	EXEC [dbo].[CONC_GENERAPROVISION_SP]  @periodo, @anio;
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ing. Alejandro Grijalva Antonio
-- Create date: 2018-03-05
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[CREACONCILIACIONDETALLE_SP]
	@idConciliacion	INT					= 1,
	@CCP_IDDOCTO VARCHAR(20)			= '',
	@VIN VARCHAR(17)					= '',
	@interesGrupoAndrade NUMERIC(18,2)	= 0,
	@interesFinanciera	NUMERIC(18,2)	= 0,
	@interesAjuste NUMERIC(18,2)		= 0,
	@situacion INT						= 0
AS
BEGIN
	INSERT INTO [dbo].[conciliacionDetalle]( [idConciliacion],[CCP_IDDOCTO],[VIN],[interesGrupoAndrade],[interesFinanciera],[interesAjuste],[situacion])
	SELECT	[idConciliacion]		= @idConciliacion,
			[CCP_IDDOCTO]			= @CCP_IDDOCTO,
			[VIN]					= @VIN,
			[interesGrupoAndrade]	= @interesGrupoAndrade,
			[interesFinanciera]		= @interesFinanciera,
			[interesAjuste]			= @interesAjuste,
			[situacion]				= @situacion;

	SELECT success = 1;
END
GO

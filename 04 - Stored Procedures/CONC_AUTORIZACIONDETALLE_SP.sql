SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ing. Alejandro Grijalva Antonio
-- Create date: 2018-03-08
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[CONC_AUTORIZACIONDETALLE_SP]
	@consecutivo INT = 0
AS
BEGIN
	SELECT
		[idAutorizaConciliacion],
		[idFinanciera],
		[nombre],
		[periodoContable],
		[consecutivo],
		[estatus],
		[descripcion],
		[fechaSolicitud],
		[idUsuarioAutoriza],
		[fechaAutoriza]
	FROM PlanPiso..autorizaConciliacion CON
	INNER JOIN [PlanPiso].[dbo].[Financiera] FIN ON CON.idFinanciera = FIN.financieraID
	INNER JOIN [PlanPiso].[dbo].[estatusNotificacion] EST ON CON.estatus = EST.idEstatusNotificacion
	WHERE consecutivo = @consecutivo;
END
GO

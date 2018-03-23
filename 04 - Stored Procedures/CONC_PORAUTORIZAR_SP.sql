SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ing. Alejandro Grijalva Antonio
-- Create date: 2018-03-07
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[CONC_PORAUTORIZAR_SP] AS
BEGIN
	SELECT
		[idFinanciera],
		[nombre],
		[periodoContable],
		[consecutivo],
		[estatus],
		[descripcion],
		[idUsuarioSolicita],
		[fechaSolicitud],
		[idUsuarioAutoriza],
		[fechaAutoriza]
	FROM [PlanPiso].[dbo].[autorizaConciliacion] CON
	INNER JOIN [PlanPiso].[dbo].[Financiera] FIN ON CON.idFinanciera = FIN.financieraID
	LEFT JOIN [PlanPiso].[dbo].[estatusNotificacion] EST ON CON.estatus = EST.idEstatusNotificacion
END
GO
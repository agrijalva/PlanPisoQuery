USE [PlanPiso]
GO
/****** Object:  StoredProcedure [dbo].[EMPRESABYUSER_SP]    Script Date: 02/09/2018 11:31:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Ing. Alejandro Grijalva Antonio>
-- Create date: <2018-01-12>
-- Description:	<Obtención de empresas a las que ha sido asignado el usuario>
-- =============================================
ALTER PROCEDURE [dbo].[EMPRESABYUSER_SP]
	@idUsuario INT = 0
AS
BEGIN
	SELECT DISTINCT(emp_nombre), EMP.emp_idempresa
	FROM  [ControlAplicaciones].[dbo].[ope_organigrama]		ORG
	INNER JOIN [ControlAplicaciones].[dbo].[cat_sucursales] SUC ON ORG.suc_idsucursal = SUC.suc_idsucursal
	INNER JOIN [ControlAplicaciones].[dbo].[cat_empresas]	EMP ON EMP.emp_idempresa = SUC.emp_idempresa
	WHERE ORG.usu_idusuario = @idUsuario;
END

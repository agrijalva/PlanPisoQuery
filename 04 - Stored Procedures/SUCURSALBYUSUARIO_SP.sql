USE [PlanPiso]
GO
/****** Object:  StoredProcedure [dbo].[SUCURSALBYUSUARIO_SP]    Script Date: 02/09/2018 11:32:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Ing. Alejandro Grijalva Antonio>
-- Create date: <2018-01-12>
-- Description:	<Obtención de sucursales a las que ha sido asignado el usuario>
-- =============================================
ALTER PROCEDURE [dbo].[SUCURSALBYUSUARIO_SP]
	@idEmpresa INT = 0,
	@idUsuario INT = 0
AS
BEGIN
	SELECT 
		DISTINCT (SUC.suc_nombre) as nombreSucursal, 
		SUC.suc_idsucursal as sucursalID,
		4 as empresaID,
		suc_nombrebd as nombreBase,
		suc_ipbd as servidorIP,
		1 as tipo,
		1 as rfc
	FROM  [ControlAplicaciones].[dbo].[ope_organigrama]		ORG
	INNER JOIN [ControlAplicaciones].[dbo].[cat_sucursales] SUC ON ORG.suc_idsucursal = SUC.suc_idsucursal
	WHERE ORG.emp_idempresa		= @idEmpresa
		  AND ORG.usu_idusuario = @idUsuario
END

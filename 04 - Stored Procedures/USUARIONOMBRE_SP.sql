USE [PlanPiso]
GO
/****** Object:  StoredProcedure [dbo].[USUARIONOMBRE_SP]    Script Date: 02/09/2018 11:32:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Ing. Alejandro Grijalva Antonio>
-- Create date: <2018-01-12>
-- Description:	<Se obtiene el nombre del usuario para personalizar el sitio>
-- =============================================
ALTER PROCEDURE [dbo].[USUARIONOMBRE_SP]
	@idUsuario INT = 0
AS
BEGIN
	SELECT usu_paterno + ' ' + usu_materno + ' ' + usu_nombre as nombre
	FROM [ControlAplicaciones].[dbo].[cat_usuarios] 
	WHERE usu_idusuario = @idUsuario;
END

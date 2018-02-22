USE [PlanPiso]
GO
/****** Object:  StoredProcedure [dbo].[Usp_TipoTiie_GET]    Script Date: 02/21/2018 16:52:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ing. Alejandro Grijalva Antonio
-- Create date: 2018-02-21
-- Description:	Obtiene ultima tiie
-- =============================================
ALTER PROCEDURE [dbo].[CURRENTTIIE_SP] AS
BEGIN
	SET NOCOUNT ON;
  
	IF EXISTS(SELECT * FROM [PlanPiso].[dbo].[Tiie] WHERE fecha >= CONVERT (date, GETDATE()))
		BEGIN
			SELECT success = 1, Tiie = (SELECT porcentaje FROM [PlanPiso].[dbo].[Tiie] WHERE fecha >= CONVERT (date, GETDATE()));
		END
	ELSE
		BEGIN
			DECLARE @tiiesugerido NUMERIC(18,4) = ( SELECT	CASE COUNT(valor)
																 WHEN 0 THEN (
																				SELECT TOP 1 valor 
																				FROM Centralizacionv2..DIG_VALORESBANXICODET 
																				WHERE clave = 'SF60648' 
																				ORDER BY fecha_banxico DESC
																			  )
																ELSE ( 
																		SELECT valor 
																		FROM Centralizacionv2..DIG_VALORESBANXICODET
																		WHERE	clave = 'SF60648' 
																				AND fecha_banxico = CONVERT (date, GETDATE()) 
																	 )
															END
													FROM Centralizacionv2..DIG_VALORESBANXICODET
													WHERE	clave = 'SF60648' 
															AND fecha_banxico = CONVERT (date, GETDATE()));
			
			SELECT success = 0, Tiie = @tiiesugerido;
		END
END


	
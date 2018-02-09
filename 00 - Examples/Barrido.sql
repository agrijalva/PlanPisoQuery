-- Obtenemos todos los VIN de la cartera
-- SELECT DISTINCT( CCP_OBSGEN ) FROM GAAU_Concentra..VIS_CONCAR01 WHERE CCP_TIPOPOL IN ( 'CUUN' );
-- SELECT * FROM GAAU_Concentra..VIS_CONCAR01 WHERE CCP_TIPOPOL IN ( 'CUUN' ) AND CCP_TIPODOCTO = 'FAC' AND CCP_CONSMOV = 1 ORDER BY CCP_OBSGEN ASC;

--SELECT DISTINCT( CCP_OBSGEN ) ,Vcc_Anno 
--FROM GAAU_Concentra..VIS_CONCAR01 
--WHERE CCP_TIPOPOL IN ( 'CUUN' ) 
--	  AND CCP_TIPODOCTO = 'FAC' 
--	  AND CCP_CONSMOV = 1 
--	  AND CCP_OBSGEN != ''
--ORDER BY Vcc_Anno, CCP_OBSGEN DESC;
USE [PlanPiso];

DECLARE @tableVin TABLE( Id INT IDENTITY, VIN VARCHAR(20) );
DECLARE @VIN VARCHAR(20);

INSERT INTO @tableVin
SELECT DISTINCT(CCP_OBSGEN)
FROM GAAU_Concentra..VIS_CONCAR01 
WHERE CCP_TIPOPOL IN ( 'CUUN' ) 
	  AND CCP_TIPODOCTO = 'FAC' 
	  AND CCP_CONSMOV = 1 
	  AND CCP_OBSGEN != ''
ORDER BY CCP_OBSGEN DESC;


DECLARE @Current INT	= 0;
DECLARE @Max INT		= 0;

SELECT @Current = MIN(Id), @Max = MAX(Id) FROM @tableVin;--  WHERE Id <= 100;
WHILE( @Current <= @Max )
	BEGIN
		SET @VIN = (SELECT VIN FROM @tableVin WHERE Id = @Current);
		PRINT( CONVERT(VARCHAR(10),@Current) + ' : ' + @VIN );
		-- EXEC [PLP_CHECKVIN_SP] 1, @VIN;
		EXEC [dbo].[PLP_COMPRAUNIDAD_SP] 1, @VIN;
		EXEC [dbo].[PLP_TRASPASOS_SP] 1, @VIN;
		SET	@Current = @Current + 1;
	END
	
-- [PLP_CHECKVIN_SP] 1, 'JS2FH81S0J6103800';
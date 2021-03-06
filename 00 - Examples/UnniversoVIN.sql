USE [PlanPiso];
-- DECLARE @VinDocumentos TABLE( Id INT IDENTITY, idEmpresa INT, VIN VARCHAR(17), Documento VARCHAR(20) );
DECLARE @VinDocumentos TABLE( Id INT IDENTITY, idEmpresa INT, VIN VARCHAR(17), Documento VARCHAR(20) );

INSERT INTO @VinDocumentos
SELECT idEmpresa, CCP_OBSGEN as VIN, CCP_IDDOCTO FROM Documentos WHERE CCP_IDDOCTO LIKE '%-%-%-%-%-%' AND CCP_OBSGEN != ''										-- 475
UNION
SELECT idEmpresa, CCP_IDDOCTO as VIN, CCP_IDDOCTO FROM Documentos WHERE CCP_IDDOCTO NOT LIKE '%-%-%-%-%-%' AND LEN( CCP_IDDOCTO ) = 17							-- 212
UNION
SELECT idEmpresa, SUBSTRING( CCP_IDDOCTO, 1, 17 ) as VIN, CCP_IDDOCTO FROM Documentos WHERE CCP_IDDOCTO NOT LIKE '%-%-%-%-%-%' AND LEN( CCP_IDDOCTO ) = 19							--  11
UNION
SELECT idEmpresa, CCP_OBSGEN as VIN, CCP_IDDOCTO FROM Documentos WHERE CCP_IDDOCTO NOT LIKE '%-%-%-%-%-%' AND LEN( CCP_IDDOCTO ) < 17 AND CCP_OBSGEN != ''		-- 211
UNION
SELECT idEmpresa, SUBSTRING( CCP_IDDOCTO, 2, 17 ) as VIN, CCP_IDDOCTO FROM Documentos WHERE CCP_IDDOCTO NOT LIKE '%-%-%-%-%-%' AND LEN( CCP_IDDOCTO ) = 18							--   1

--SELECT idEmpresa, CCP_OBSGEN AS VIN, CCP_IDDOCTO FROM Documentos WHERE CCP_IDDOCTO LIKE '%-%-%-%-%-%' AND CCP_OBSGEN != ''
--UNION
--SELECT idEmpresa, CCP_IDDOCTO AS VIN, CCP_IDDOCTO  FROM Documentos WHERE CCP_IDDOCTO NOT LIKE '%-%-%-%-%-%' AND LEN( CCP_IDDOCTO ) = 17
--UNION
--SELECT idEmpresa, CCP_OBSGEN AS VIN, CCP_IDDOCTO  FROM Documentos WHERE CCP_IDDOCTO NOT LIKE '%-%-%-%-%-%' AND LEN( CCP_IDDOCTO ) != 17 AND CCP_OBSGEN != '';

SELECT * FROM @VinDocumentos;


-- SELECT COUNT(VIN)Total, VIN FROM @VinDocumentos GROUP BY VIN ORDER BY Total DESC;

-- SELECT CCP_IDDOCTO, CCP_OBSGEN FROM Documentos WHERE CCP_IDDOCTO NOT LIKE '%-%-%-%-%-%' AND LEN( CCP_IDDOCTO ) != 17 AND CCP_OBSGEN = '';	-- 316
 
 --SELECT idEmpresa, CCP_IDDOCTO, LEN(CCP_IDDOCTO) AS LEN, SUBSTRING( CCP_IDDOCTO, 1, 17 ) VINMOCHO
 --FROM Documentos DOC
 --WHERE CCP_IDDOCTO NOT LIKE '%-%-%-%-%-%' 
	--  AND LEN( RTRIM(CCP_IDDOCTO) ) = 19 AND CCP_OBSGEN = '' AND idEmpresa = 1;
	  


-- SELECT CCP_IDDOCTO, CCP_OBSGEN FROM Documentos;



-- SELECT 4, CCP_OBSGEN as VIN, CCP_IDDOCTO FROM Documentos WHERE CCP_IDDOCTO NOT LIKE '%-%-%-%-%-%' AND LEN( CCP_IDDOCTO ) < 17 AND CCP_OBSGEN != ''		-- 211
-- SELECT 4, CCP_OBSGEN as VIN, CCP_IDDOCTO FROM Documentos WHERE CCP_IDDOCTO NOT LIKE '%-%-%-%-%-%' AND LEN( CCP_IDDOCTO ) < 17 AND CCP_OBSGEN = ''		-- 304
USE [PlanPiso];

-- [ 01 ] Tabla de documentos, cartera y Traspaso por Empresa
SELECT * FROM Documentos		 WHERE idEmpresa = 1;
SELECT * FROM CarteraProveedores WHERE idEmpresa = 1;
SELECT * FROM Traspaso			 WHERE idEmpresa = 4;

-- [ 02 ] Verificar si un documento fue agregado (Quitar en GAAU_CARTERARAPROVEEDORES_SP y quitar un documento de la exclusion)
SELECT * FROM CarteraProveedores WHERE CCP_IDDOCTO = 'AU-AU-UNI-UN-TPP-124'
SELECT * FROM Documentos WHERE CCP_IDDOCTO = 'AU-AU-UNI-UN-TPP-124'

-- [ 03 ] Eliminar registros de las tablas
-- DELETE FROM CarteraProveedores;
-- DELETE FROM CarteraProveedores WHERE idEmpresa = 1;
-- DELETE FROM Documentos WHERE CCP_IDDOCTO NOT IN ('AU-AU-UNI-UN-TPP-201', 'AU-AU-UNI-UN-TPP-203');

-- DELETE FROM CarteraProveedores WHERE idEmpresa = 4;
-- DELETE FROM Documentos WHERE idEmpresa = 4;
-- TRUNCATE TABLE Traspaso;

-- [ 04 ] Verificación de información de los Documentos
SELECT CCP_IDDOCTO, CCP_OBSGEN, * FROM Documentos;
SELECT CCP_IDDOCTO, CCP_OBSGEN, * FROM Documentos WHERE idSucursal = 0 AND idEmpresa = 4;
SELECT DISTINCT( idEmpresa ) FROM Documentos WHERE idSucursal = 0;

-- [ 05 ] Que pasa con los VIN  de mas de 17 caracteres | Preguntar si los VIN de 19 caracteres estan igual en todos lados
SELECT CCP_IDDOCTO as Doc, CCP_OBSGEN as VIN, * FROM Documentos WHERE idSucursal = 0;

SELECT LTRIM( CCP_IDDOCTO ) as Doc, CCP_OBSGEN as VIN, LEN(CCP_OBSGEN) as Longitud 
FROM Documentos WHERE CCP_IDDOCTO NOT LIKE '%-%-%-%-%-%' AND LEN( LTRIM( CCP_IDDOCTO ) ) > 17;

SELECT idEmpresa, REPLACE(CCP_IDDOCTO,'',' ') , LEN(CCP_IDDOCTO) AS LEN , SUBSTRING( CCP_IDDOCTO, 0, 17 )
FROM Documentos DOC
WHERE CCP_IDDOCTO NOT LIKE '%-%-%-%-%-%'
	  AND LEN( CCP_IDDOCTO ) > 17 AND CCP_OBSGEN = '' AND idEmpresa = 1;


-- [ 06 ] Cuando un VIN esta en dos documentos (uno de esos documentos es un VIN), Qué pasa con los traspasos?, a quien se le que deja el Traspaso.
SELECT COUNT(TRA_NUMTRASPASO),TRA_NUMTRASPASO FROM Traspaso GROUP BY TRA_NUMTRASPASO ORDER BY TRA_NUMTRASPASO ASC;
SELECT * FROM Traspaso WHERE TRA_NUMTRASPASO IN( 1508, 1513 );
SELECT * FROM GAAU_Concentra..UNI_TRASPASOS WHERE TRA_NUMTRASPASO IN( 1508, 1513 );


SELECT CCP_IDDOCTO, CCP_OBSGEN, * FROM Documentos WHERE CCP_IDDOCTO = 'AU-AU-UNI-UN-TPP-229'
SELECT CCP_IDDOCTO, CCP_OBSGEN, * FROM Documentos WHERE CCP_IDDOCTO = 'JS2ZC63S7J6104178'
--------------








-- [ 07 ] SP alimentadoras de los Documentos

USE [PlanPiso];
Execute [dbo].[SEL_ACTIVE_DATABASES_SP];
SELECT CONVERT (date, GETDATE());

[GAAU_CARTERAPROVEEDORES_SP]	-- ( 1 ) 15 Seg
[BPRO_TRASPASOS_SP] 1;

[GAAT_CARTERAPROVEEDORES_SP]	-- ( 2 ) 01 Seg
[BPRO_TRASPASOS_SP] 2;

[GAHonda_CARTERAPROVEEDORES_SP] -- ( 3 ) 01 Seg
[BPRO_TRASPASOS_SP] 3;

[GAZM_CARTERAPROVEEDORES_SP]	-- ( 4 ) 40 Seg
[BPRO_TRASPASOS_SP] 4;

-- 3:26  3N1CN7AD6HK465592
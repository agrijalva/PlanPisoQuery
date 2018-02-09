SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ing. Alejandro Grijalva Antonio
-- Create date: 2018-02-09
-- Description:	Obtiene los VIN de toda la tabla de Documentos
-- [OBTIENEVIN_SP] 1
-- =============================================
ALTER PROCEDURE [OBTIENEVIN_SP]
	@idEmpresa INT = 0
AS
BEGIN
	DECLARE @VinDocumentos TABLE( Id INT IDENTITY, idEmpresa INT, VIN VARCHAR(17), Documento VARCHAR(20) );

	SELECT idEmpresa, idSucursal, CCP_OBSGEN as VIN, CCP_IDDOCTO FROM Documentos WHERE CCP_IDDOCTO LIKE '%-%-%-%-%-%' AND CCP_OBSGEN != '' AND idEmpresa = @idEmpresa
	UNION
	SELECT idEmpresa, idSucursal, CCP_IDDOCTO as VIN, CCP_IDDOCTO FROM Documentos WHERE CCP_IDDOCTO NOT LIKE '%-%-%-%-%-%' AND LEN( CCP_IDDOCTO ) = 17  AND idEmpresa = @idEmpresa
	UNION
	SELECT idEmpresa, idSucursal, SUBSTRING( CCP_IDDOCTO, 1, 17 ) as VIN, CCP_IDDOCTO FROM Documentos WHERE CCP_IDDOCTO NOT LIKE '%-%-%-%-%-%' AND LEN( CCP_IDDOCTO ) = 19 AND idEmpresa = @idEmpresa
	UNION
	SELECT idEmpresa, idSucursal, CCP_OBSGEN as VIN, CCP_IDDOCTO FROM Documentos WHERE CCP_IDDOCTO NOT LIKE '%-%-%-%-%-%' AND LEN( CCP_IDDOCTO ) < 17 AND CCP_OBSGEN != '' AND idEmpresa = @idEmpresa
	UNION
	SELECT idEmpresa, idSucursal, SUBSTRING( CCP_IDDOCTO, 2, 17 ) as VIN, CCP_IDDOCTO FROM Documentos WHERE CCP_IDDOCTO NOT LIKE '%-%-%-%-%-%' AND LEN( CCP_IDDOCTO ) = 18 AND idEmpresa = @idEmpresa	
END
GO

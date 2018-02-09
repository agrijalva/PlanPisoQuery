-- TSMYEA1S2JM425452 :: Sin traspaso, 2 registros en cxp_detalleautosnuevos
-- TSMYD21S5GM186416 :: Existe traspaso correcto
-- JS2ZC82S3F6301577 :: No existe traspaso pero existe en dos bases
-- TSMYEA1S4JM430099 :: Con venta
-- TSMYE21S0GM266915 :: VIN con todos los eventos
-- JS2ZC63S7J6100809 :: En detalleautosnuevos existe doble

DECLARE @VIN VARCHAR(17) = 'TSMYE21S0GM266915';
EXEC [dbo].[PLP_CHECKVIN_SP] 1, @VIN;

-- Compra
SELECT ORD.* 
FROM [cuentasxpagar].[dbo].[cxp_detalleautosnuevos] DET
INNER JOIN [cuentasxpagar].[dbo].[cxp_ordencompra] ORD ON DET.oce_folioorden = ORD.oce_folioorden
WHERE anu_numeroserie = @VIN;

-- Traspasos
SELECT * FROM GAAU_Concentra..UNI_TRASPASOS WHERE TRA_NUMSERIE = @VIN;

-- SER_VEHICULO
SELECT VEH_NUMSERIE, VEH_SITUACION, *
FROM [192.168.20.29].[GAAU_Pedregal].[dbo].SER_VEHICULO 
WHERE VEH_NUMSERIE = @VIN;

SELECT VEH_NUMSERIE, VEH_SITUACION, *
FROM [192.168.20.29].[GAAU_Universidad].[dbo].SER_VEHICULO 
WHERE VEH_NUMSERIE = @VIN;

SELECT VEH_NUMSERIE, VEH_SITUACION, *
FROM [192.168.20.29].[GAAU_Universidad].[dbo].SER_VEHICULO 
WHERE VEH_NUMSERIE = @VIN;


-- VENTAS
SELECT VTE_FORMAPAGO, * FROM [GAAU_Pedregal]..ADE_VTAFI WHERE VTE_SERIE = @VIN;
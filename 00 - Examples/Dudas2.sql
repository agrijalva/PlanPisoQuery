-- Por qué existen dos VIN con distinta descripción
SELECT *
FROM [cuentasxpagar].[dbo].[cxp_detalleautosnuevos] DET
INNER JOIN [cuentasxpagar].[dbo].[cxp_ordencompra] ORD ON DET.oce_folioorden = ORD.oce_folioorden
WHERE anu_numeroserie = 'JS2FH81S3J6105265' AND oce_idtipoorden = 6;

SELECT *
FROM [cuentasxpagar].[dbo].[cxp_detalleautosnuevos] DET
INNER JOIN [cuentasxpagar].[dbo].[cxp_ordencompra] ORD ON DET.oce_folioorden = ORD.oce_folioorden
WHERE anu_numeroserie = 'JS2ZC63S2J6107599' AND oce_idtipoorden = 6;


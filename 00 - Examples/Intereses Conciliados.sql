DECLARE @periodo INT = 0, @anio INT = 0;
DECLARE @fecha DATETIME = (SELECT DATEADD(month, ((2018 - 1900) * 12) + 2, -1))
-- PRINT(@fecha);

SELECT
	[movimientoID],
    [CCP_IDDOCTO],
    [VIN],
    [usuarioID],
    [empresaID],
    [sucursalID],
    [sucursalRecibeID],
    [financieraID],
    [esquemaID],
    [fecha],
    [active],
    [tipoMovimientoId],
    [genericID],
    [fecha_original] = @fecha,
    [fecha_calculo] = GETDATE()
FROM Movimiento WHERE CCP_IDDOCTO = 'AU-AU-UNI-UN-TPP-291' AND active = 1;
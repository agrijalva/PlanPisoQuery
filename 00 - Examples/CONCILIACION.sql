DECLARE @periodo INT = 2;

SELECT
	movimientoID	= MOV.movimientoID,
	porcentajeTiie	= 0,
	monto			= CONCILIA.interesAjuste,
	saldos			= DOC.SALDO,
	fecha			= GETDATE(),
	estatusID		= 4,
	diasrestantes	= 0
FROM Movimiento MOV
INNER JOIN (SELECT DISTINCT( CCP_IDDOCTO ) CCP_IDDOCTO
			FROM Interes INT
			INNER JOIN Movimiento MOV ON INT.movimientoID = MOV.movimientoID
			WHERE MONTH(INT.fecha) = @periodo AND INT.estatusID = 3) INTERES ON MOV.CCP_IDDOCTO = INTERES.CCP_IDDOCTO
INNER JOIN (SELECT DET.* 
			FROM conciliacion CON
			INNER JOIN conciliacionDetalle DET ON CON.idConciliacion = DET.idConciliacion
			WHERE periodo = @periodo AND situacion != 3) CONCILIA ON MOV.CCP_IDDOCTO = CONCILIA.CCP_IDDOCTO
INNER JOIN Documentos DOC ON DOC.CCP_IDDOCTO = MOV.CCP_IDDOCTO
WHERE active = 1;

-- UPDATE Interes SET estatusID = 5 WHERE MONTH(INT.fecha) = @periodo AND INT.estatusID = 3

SELECT
	[ple_idplanpiso],
    [pro_idtipoproceso] = 4,
    [ple_idempresa],
    [ple_idsucursal],
    [ple_tipopoliza],
    [ple_fechapoliza] = GETDATE(),
    [ple_concepto] = [ple_concepto],
    [ple_fechageneracion],
    [ple_conspol],
    [ple_mes],
    [ple_año],
    [ple_estatus]
FROM plp_planpisoenc WHERE pro_idtipoproceso = 3 AND MONTH(ple_fechapoliza) = @periodo;

SELECT
    [ple_idplanpiso] = 0,
    [pld_consecutivo],
    [pld_numcuenta],
    [pld_concepto] = [pld_concepto],
    [pld_cargo] = [pld_abono],
    [pld_abono] = [pld_cargo],
    [pld_idpersona],
    [pld_iddocumento],
    [pld_tipodocumento],
    [pld_vin],
    [pld_fechavencimiento] = GETDATE(),
    [pld_porcentajeiva],
    [pld_afecta],
    [idProvision]
FROM plp_planpisodet DET
INNER JOIN plp_planpisoenc ENC ON DET.ple_idplanpiso = ENC.ple_idplanpiso
WHERE pro_idtipoproceso = 3 AND MONTH(ple_fechapoliza) = @periodo;


SELECT
	CON.idConciliacion,
	CON.idEmpresa,
	CON.idFinanciera,
	POL.planpisoID,
	CON.periodo,
	CON.anio,
	CON.estatus,
	DET.CCP_IDDOCTO,
	DET.VIN,
	DET.interesGrupoAndrade,
	DET.interesFinanciera,
	DET.interesAjuste,
	DET.situacion
FROM conciliacion CON
INNER JOIN conciliacionDetalle DET ON CON.idConciliacion = DET.idConciliacion
INNER JOIN [PlanPiso].[dbo].[relPolizasCierreMes] POL ON DET.CCP_IDDOCTO = POL.CCP_IDDOCTO
WHERE CON.periodo = 2 AND CON.anio = 2018 AND situacion IN (1,2)

SELECT * FROM [PlanPiso].[dbo].[relPolizasCierreMes]

SELECT * FROM dbo.plp_planpisoenc
SELECT * FROM dbo.plp_planpisodet

 --DELETE FROM plp_planpisoenc WHERE ple_idplanpiso > 5
 --DELETE FROM plp_planpisodet WHERE ple_idplanpiso > 5

-- UPDATE [PlanPiso].[dbo].[relPolizasCierreMes] SET mes = 2

SELECT * FROM conciliacion
SELECT * FROM conciliacionDetalle
SELECT * FROM TmpExcelData
SELECT * FROM autorizaConciliacion
SELECT * FROM relPolizasCierreMes

-- UPDATE autorizaConciliacion SET estatus = 2


--DELETE FROM plp_planpisoenc WHERE ple_idplanpiso > 5
--DELETE FROM plp_planpisodet WHERE ple_idplanpiso > 5
TRUNCATE TABLE conciliacion
TRUNCATE TABLE conciliacionDetalle
TRUNCATE TABLE TmpExcelData
TRUNCATE TABLE autorizaConciliacion
TRUNCATE TABLE relPolizasCierreMes

SELECT * FROM GAAU_Concentra..UNI_TRASPASOS WHERE TRA_NUMTRASPASO = 1522


-- SELECT * FROM plp_planpisoenc
TRUNCATE TABLE Provision

SELECT * FROM relPolizasCierreMes;
SELECT * FROM estatusNotificacion


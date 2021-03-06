USE [PlanPiso]
GO
/****** Object:  StoredProcedure [dbo].[uspGetEmpresa]    Script Date: 02/12/2018 18:33:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[uspGetEmpresa]

AS
BEGIN
	
	/*
	select 
		emp_idempresa as idEmpresa,
		emp_nombrecto as nombreCorto,
		emp_nombre as nombre 
	from [ControlAplicaciones].[dbo].[cat_empresas]
	*/
			
		select 1 empresaID,	'AU' nombreCorto, 'ANDRADE UNIVERSIDAD SA DE CV' nombre
END
GO
/****** Object:  StoredProcedure [dbo].[uspSetEsquemaDetalle]    Script Date: 02/12/2018 18:33:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure  [dbo].[uspSetEsquemaDetalle]

@esquemaDetalleID int,
@tasaInteres numeric(18,4),
@fechaInicio varchar(20),
@fechaFin varchar(20),
@porcentajePenetracion numeric(18,4),
@tipoTiieCID int,
@tiie numeric(18,4),
@usuarioID int

AS 
BEGIN

	set @fechaInicio    = substring(@fechaInicio,7,4) +   substring(@fechaInicio,4,2) + substring(@fechaInicio,1,2) 
	set @fechaFin       = substring(@fechaFin,7,4) +  substring(@fechaFin,4,2) + substring(@fechaFin,1,2)

	UPDATE EsquemaDetalle
	SET				
			tasaInteres           = @tasaInteres,
			fechaInicio           = @fechaInicio,
			fechaFin              = @fechaFin,
			porcentajePenetracion = @porcentajePenetracion,
			tipoTiieCID           = @tipoTiieCID,
			tiie                  = @tiie,		
			modificadoPor         = @usuarioID,
			fechaModificacion     = getdate()	
	WHERE	esquemaDetalleID=@esquemaDetalleID

	select @esquemaDetalleID as result

end
GO
/****** Object:  StoredProcedure [dbo].[uspInsEsquemaDetalle]    Script Date: 02/12/2018 18:33:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure  [dbo].[uspInsEsquemaDetalle]

@esquemaID int ,
@tasaInteres int ,
@fechaInicio varchar(50)  ,
@fechaFin varchar(50),
@porcentajePenetracion int ,
@tipoTiieCID int ,
@tiie int ,
@usuarioID int 

AS 
BEGIN


	set @fechaInicio    = substring(@fechaInicio,7,4) +   substring(@fechaInicio,4,2) + substring(@fechaInicio,1,2) 
	set @fechaFin       = substring(@fechaFin,7,4) +  substring(@fechaFin,4,2) + substring(@fechaFin,1,2)

	INSERT INTO EsquemaDetalle

	(
		esquemaID,
		tasaInteres,
		fechaInicio,
		fechaFin,
		porcentajePenetracion,
		tipoTiieCID,
		tiie,
		estatusCID,
		creadoPor,
		fechaCreacion
	)

	VALUES 
	(
		@esquemaID,
		@tasaInteres,
		@fechaInicio,
		@fechaFin,
		@porcentajePenetracion,
		@tipoTiieCID,
		@tiie,
		1,
		@usuarioID,
		GETDATE()
	)

	select @@IDENTITY as result


end
GO
/****** Object:  StoredProcedure [dbo].[uspSetTraspasoFinanciera]    Script Date: 02/12/2018 18:33:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[uspSetTraspasoFinanciera]
@unidadID as int,
@userID as int,
@esquemaID as int
AS
BEGIN
		UPDATE Unidad 
		SET
			updateBy        = @userID,
			lastUpdate      = GETDATE(),
			esquemaID       = @esquemaID,
			EstatusCID		= 2,
			fechaCalculo    = getdate()
		WHERE unidadID=@unidadID 
END
GO
/****** Object:  StoredProcedure [dbo].[uspInsLoteInteresDetalle]    Script Date: 02/12/2018 18:33:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[uspInsLoteInteresDetalle]
@loteID as int,
@unidadID as int,
@interesCalculado as numeric(18,4)
as
begin 
	
	INSERT INTO LoteInteresDetalle 
				(loteID,unidadID,interesCalculado,interesUsuario,pagoPorReduccion) 
	VALUES		(@loteID,@unidadID,@interesCalculado,0,0)

	UPDATE Unidad SET fechaCalculo = GETDATE() WHERE unidadID = @unidadID

	SELECT @@IDENTITY AS result
	
end
GO
/****** Object:  StoredProcedure [dbo].[uspInsLoteInteres]    Script Date: 02/12/2018 18:33:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[uspInsLoteInteres]
as
begin 
	
	INSERT INTO loteInteres ( estatusCID ,fechaCreacion) 
	VALUES (1,GETDATE())
	SELECT @@IDENTITY AS result 
	
end
GO
/****** Object:  StoredProcedure [dbo].[USUARIONOMBRE_SP]    Script Date: 02/12/2018 18:33:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Ing. Alejandro Grijalva Antonio>
-- Create date: <2018-01-12>
-- Description:	<Se obtiene el nombre del usuario para personalizar el sitio>
-- =============================================
CREATE PROCEDURE [dbo].[USUARIONOMBRE_SP]
	@idUsuario INT = 0
AS
BEGIN
	SELECT usu_paterno + ' ' + usu_materno + ' ' + usu_nombre as nombre
	FROM [ControlAplicaciones].[dbo].[cat_usuarios] 
	WHERE usu_idusuario = @idUsuario;
END
GO
/****** Object:  StoredProcedure [dbo].[uspInsEsquema]    Script Date: 02/12/2018 18:33:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure  [dbo].[uspInsEsquema]
@diasGracia int ,
@plazo int ,
@financieraID int ,
@nombre varchar(50) ,
@descripcion varchar(150) ,
@interesMoratorio int ,
@tasaInteres numeric(18,4),
@fechaInicio varchar(10),
@fechaFin varchar(10),
@porcentajePenetracion numeric(18,4),
@tipoTiieCID int,
@tiie numeric(18,4),
@usuarioID int 

AS 
BEGIN

INSERT INTO Esquema

(
	diasGracia,
	plazo,
	financieraID,
	nombre,
	descripcion,	
	interesMoratorio,
	estatusCID,
	creadoPor,
	fechaCreacion,
	tasaInteres,
	fechaInicio,
	fechaFin,
	porcentajePenetracion,
	tipoTiieCID,
	tiie
)

VALUES 
(
	@diasGracia,
	@plazo,
	@financieraID,
	@nombre,
	@descripcion,	
	@interesMoratorio,
	1,
	@usuarioID,
	GETDATE(),
	@tasaInteres,
	convert(Datetime,@fechaInicio,103),
	convert(Datetime,@fechaFin,103),
	@porcentajePenetracion,
	@tipoTiieCID,
	@tiie
)

select @@IDENTITY as result

end
GO
/****** Object:  StoredProcedure [dbo].[uspGetUnidadesNuevas]    Script Date: 02/12/2018 18:33:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetUnidadesNuevas]
@empresaID int,
@sucursalID int = null
as
begin
	SELECT *, convert(varchar(10),d.fec_entrada,103) fechaCalculoString,d.CCP_OBSGEN vehNumserie, 0 saldoInicial,''marca,'' descmodelo,'' modelo 
	FROM	Documentos  d	
	WHERE	d.CCP_OBSGEN is not null and len(d.CCP_OBSGEN)>0 and  d.idEmpresa =@empresaID and doc_estatus != 2
	--AND	estatusCID=1	  
--	AND		(@sucursalID IS NULL OR sucursalID=@sucursalID ) 
end
GO
/****** Object:  StoredProcedure [dbo].[uspSetEsquema]    Script Date: 02/12/2018 18:33:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure  [dbo].[uspSetEsquema]
@esquemaID int ,
@diasGracia int ,
@plazo int ,
@financieraID int ,
@nombre varchar(50) ,
@descripcion varchar(150) ,
@interesMoratorio int ,
@tasaInteres numeric(18,4),
@fechaInicio varchar(10),
@fechaFin varchar(10),
@porcentajePenetracion numeric(18,4),
@tipoTiieCID int,
@tiie numeric(18,4),
@usuarioID int 

AS 
BEGIN

UPDATE Esquema
SET
		diasGracia        = @diasGracia,
		plazo             = @plazo,
		financieraID      = @financieraID,
		nombre            = @nombre,
		descripcion       = @descripcion,
		interesMoratorio  = @interesMoratorio,
		estatusCID        = 1,
		modificadoPor     = @usuarioID,
		fechaModificacion = GETDATE(),
		tasaInteres       = @tasaInteres,
		fechaInicio       = convert(Datetime,@fechaInicio,103),
		fechaFin		  = convert(Datetime,@fechaFin,103),
		porcentajePenetracion= @porcentajePenetracion,
		tipoTiieCID       = @tipoTiieCID,
		tiie			  = @tiie
WHERE	esquemaID =@esquemaID

SELECT @esquemaID AS result

end
GO
/****** Object:  StoredProcedure [dbo].[uspSetCambioAgencia]    Script Date: 02/12/2018 18:33:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[uspSetCambioAgencia]
@unidadID as int,
@userID as int,
@empresaID as int,
@sucursalID as int,
@esquemaID as int
AS
BEGIN
		UPDATE Unidad 
		SET
			updateBy        = @userID,
			lastUpdate      = GETDATE(),
			esquemaID       = @esquemaID,
			EstatusCID		= 2,
			fechaCalculo    = getdate(),
			empresaID       = @empresaID,
			sucursalID      = @sucursalID 
		WHERE unidadID=@unidadID 
END
GO
/****** Object:  StoredProcedure [dbo].[uspInsTiie]    Script Date: 02/12/2018 18:33:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[uspInsTiie]

@fecha as date,
@porcentaje as numeric(18,4),
@userID as int


as 

begin
	
	select @fecha

	INSERT INTO tiie 
				(fecha, porcentaje,estatusCID,createBy, createDate )
	values		(convert(date,@fecha,103),@porcentaje,1,@userID , GETDATE())

	SELECT @@IDENTITY AS result

end
GO
/****** Object:  StoredProcedure [dbo].[Usp_TipoTiie_GET]    Script Date: 02/12/2018 18:33:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Irving Solorio>
-- Create date: <19/01/2018>
-- Description:	<Obtiene tipo Tiie>
-- =============================================
create PROCEDURE [dbo].[Usp_TipoTiie_GET]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  
		SELECT  [tipoTiieId]
      ,[tipoTiie]
      ,[activo]
  FROM [PlanPiso].[dbo].[TipoTiie]		

	
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetConciliacion]    Script Date: 02/12/2018 18:33:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[uspGetConciliacion] 
@financieraID AS INT
AS
BEGIN

	SELECT * FROM	
	(
		SELECT UI.*,X.*,U.vehNumserie,U.esquemaID ,
				(SELECT financieraID FROM Esquema WHERE  esquemaID = U.esquemaID ) financieraID ,
				(UI.InteresMesActual - X.interes) diferencia,
				CASE 
					 WHEN (UI.InteresMesActual = X.interes)  THEN 1
					 WHEN (UI.InteresMesActual > X.interes)  THEN 2			 
					 ELSE 0 END  esMayor
		FROM UnidadInteres UI  
		INNER JOIN Unidad U
		ON U.unidadID  = UI.unidadID
		RIGHT JOIN TmpExcelData X
		ON numeroSerie = U.vehNumserie
	) AS conciliacion
	WHERE financieraID =@financieraID

END
GO
/****** Object:  StoredProcedure [dbo].[uspGetCatalogo]    Script Date: 02/12/2018 18:33:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetCatalogo]

@catalogoID as int

AS
BEGIN	

	SELECT 
		lst.appCatalogoID,
		lst.CID,
		lst.valor,
		lst.texto,
		lst.visible,
		cat.nombre,
		cat.tabla,
		cat.campo,
		cat.estaActivo
	FROM 
	AppCatalogoLista lst 
	INNER JOIN AppCatalogo cat
	ON lst.appCatalogoID = cat.appCatalogoID
	WHERE lst.appCatalogoID = @catalogoID  and visible = 1	

END
GO
/****** Object:  StoredProcedure [dbo].[uspGetLoteInteresDetalle]    Script Date: 02/12/2018 18:33:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[uspGetLoteInteresDetalle]
@loteID as int

as
begin

	SELECT 
		ld.loteDetalleID,
		ld.unidadID,
		ld.interesCalculado,
		ld.interesUsuario,
		ld.pagoPorReduccion,
		(SELECT vehNumserie  FROM Unidad WHERE unidadID =  ld.unidadID ) vehNumserie		
	FROM LoteInteresDetalle ld 
	
end
GO
/****** Object:  StoredProcedure [dbo].[uspGetLoteInteres]    Script Date: 02/12/2018 18:33:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[uspGetLoteInteres]
@estatusCID as int 
as


begin
	SELECT 
		loteID,	
		estatusCID,
		(SELECT texto FROM AppCatalogoLista WHERE  appCatalogoID =4 and CID = l.estatusCID) estatusDesc,	
		CONVERT( VARCHAR(20), fecha_Creacion,103) fechaCreacion
	FROM LoteInteres l
	WHERE estatusCID = @estatusCID 	
end
GO
/****** Object:  StoredProcedure [dbo].[uspGetInteresDashBoard]    Script Date: 02/12/2018 18:33:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetInteresDashBoard]
@empresaID int
as
begin

SELECT 
	empresaID,
	financieraID,
	nombreFinanciera,
	COUNT(empresaID) unidades,
	SUM(InteresCortePagado) InteresCortePagado,
	SUM(InteresMesActual) InteresMesActual,
	SUM(InteresAcumuladoFinanciera) InteresAcumuladoFinanciera,
	SUM(InteresTotal) InteresTotal			
FROM

(
	SELECT 			
		U.empresaID,		
		(SELECT financieraID FROM Esquema WHERE esquemaID = U.esquemaID) financieraID  ,
		(	 SELECT nombre from Financiera WHERE financieraID  = 
				(SELECT financieraID FROM Esquema WHERE esquemaID = U.esquemaID )
		) nombreFinanciera,		
		InteresCortePagado,
		InteresMesActual,
		InteresAcumuladoFinanciera,
		InteresTotal		
	FROM Unidad U 
		INNER JOIN UnidadInteres UI 
		ON U.unidadID  = UI.unidadID
		AND U.estatusCID = 2
		AND  empresaID=@empresaID
) AS Intereses
GROUP BY   
		empresaID,		
		financieraID,
		nombreFinanciera

UNION

	SELECT 			
		U.empresaID,		
		-1 financieraID,
		'Todas las unidades' Nombre,
		COUNT(U.empresaID) unidades,
		SUM(UI.InteresCortePagado) InteresCortePagado,
		SUM(UI.InteresMesActual) InteresMesActual,
		SUM(UI.InteresAcumuladoFinanciera) InteresAcumuladoFinanciera,
		SUM(UI.InteresTotal) InteresTotal			
	FROM Unidad U 
		INNER JOIN UnidadInteres UI 
		ON U.unidadID  = UI.unidadID
		AND U.estatusCID = 2
		AND  empresaID=@empresaID
	GROUP BY   
		U.empresaID			
end
GO
/****** Object:  StoredProcedure [dbo].[uspGetFinanciera]    Script Date: 02/12/2018 18:33:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetFinanciera]
AS
BEGIN

	/*OPTIMIZAR*/
	
	select 
			consecutivo,
			empresaID,
			nombre,
			financieraID,
			tipoCID
	from Financiera 
	
		
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetEsquemaDetalle]    Script Date: 02/12/2018 18:33:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[uspGetEsquemaDetalle]
@esquemaID as int,
@esquemaDetalleID as int = null
AS

BEGIN

	SELECT 
		esquemaDetalleID,
		esquemaID,
		tasaInteres,
		CONVERT(VARCHAR(10),fechaInicio,103)  fechaInicio,
		CONVERT(VARCHAR(10),fechaFin,103) fechaFin,
		porcentajePenetracion,
		tipoTiieCID,
		tiie,
		estatusCID	 ,
		(SELECT texto FROM AppCatalogoLista WHERE appCatalogoID =9 and CID = ed.estatusCID ) estatusTexto,
		(SELECT texto FROM AppCatalogoLista WHERE appCatalogoID =10 and CID = ed.TipotiieCID  ) TipotiieTexto
	 FROM EsquemaDetalle ed 
	 WHERE esquemaID = @esquemaID
	 AND (@esquemaDetalleID IS NULL OR esquemaDetalleID= @esquemaDetalleID)


END
GO
/****** Object:  StoredProcedure [dbo].[uspGetEsquema]    Script Date: 02/12/2018 18:33:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetEsquema]
@financieraID NUMERIC(18,0),
@esquemaID INT = NULL
AS
BEGIN
		SELECT  [esquemaID]
      ,[diasGracia]
      ,[plazo]
      ,[financieraID]
      ,[nombre]
      ,[descripcion]
      ,[interesMoratorio]
      ,[estatusCID]
      ,[creadoPor]
      ,[tasaInteres]
      ,convert(nvarchar(12),[fechaInicio],103) [fechaInicio]
      ,convert(nvarchar(12),[fechaFin],103) [fechaFin]
      ,[porcentajePenetracion]
      ,[tipoTiieCID]
      ,[tiie]
	  ,T.tipoTiie tipoTiie
      ,convert(nvarchar(12),[fechaCreacion],103) [fechaCreacion]
      ,[modificadoPor]
      ,[fechaModificacion], 
			(	
				SELECT	count(esquemaID ) 
				FROM	Unidad 
				WHERE	esquemaID = E.esquemaID 
			) numAsignado
		FROM	Esquema E 
		inner join TipoTiie T on E.tipoTiieCID=T.tipoTiieId
		WHERE	financieraID = @financieraID	
		AND e.estatusCID=1
		AND (@esquemaID IS NULL OR esquemaID =@esquemaID )
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetUnidadesDetalle]    Script Date: 02/12/2018 18:33:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspGetUnidadesDetalle]
@unidadID as int
as
begin


select 
		U.unidadID,
		U.vehNumserie,
		U.tipoUnidad,
		U.colorInterior,
		U.colorExterior,
		U.modelo,
		U.descModelo,
		U.marca,
		U.segmento,
		U.subtipoUnidad,
		U.uncIdcatalo,
		U.carLine,
		U.puertas,
		U.cilindros,
		U.uncPotencia,
		U.combustible,
		U.capacidad,
		U.transmision,
		U.ubicacion,
		U.tipomotor,
		U.noMotor,
		U.procedencia,
		U.vehNofactplan,
		U.vehFecremision,
		U.numPedimento,
		U.fechaPedimento,
		U.tipoCompra,
		U.vehFecrecibo,
		U.diasInventa,
		U.precioLista,
		U.valorInventario,
		U.situacion,
		U.consCartera,
		U.idDocto,
		U.saldo,
		convert(varchar(20),U.fechaEfectiva,103) fechaEfectiva,
		U.fechaCalculo,
		E.esquemaID,
		E.diasGracia,
		E.plazo,	
		E.nombre,
		E.descripcion,
		E.interesMoratorio,	
		E.creadoPor,
		E.fechaCreacion,
		E.modificadoPor,
		E.fechaModificacion,
		'Fecha' tipoEsquema,
		DATEDIFF (day,GETDATE(),GETDATE()-130) diasInventario,		
		20 diasFinanciamiento,
		20 diasAmpliacion,		
		(select nombre from Financiera where financieraID = E.financieraID ) financiera
	
FROM Unidad U inner join Esquema E
ON U.esquemaID =E.esquemaID
where U.unidadID  =@unidadID 

	

end
GO
/****** Object:  StoredProcedure [dbo].[uspGetTiieDateExist]    Script Date: 02/12/2018 18:33:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetTiieDateExist]
@fecha  AS Date
AS
BEGIN
		IF EXISTS (SELECT fecha FROM Tiie WHERE  fecha = @fecha )
		BEGIN
			SELECT  1 result
		END
		ELSE
		BEGIN 
			SELECT  0 result
		END
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetTiie]    Script Date: 02/12/2018 18:33:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[uspGetTiie]



as 

begin

	SELECT 
			tiieID,
			convert(varchar(20),fecha,103) fecha,
			porcentaje
	FROM	Tiie
end
GO
/****** Object:  StoredProcedure [dbo].[uspGetSucursal]    Script Date: 02/12/2018 18:33:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[uspGetSucursal]

@empresaID  NUMERIC(18,0)

AS
BEGIN

	/*optimizar*/ 
	/*crear tabla Propia que se llene mediante job*/
	/*
	select 
		suc_idsucursal as sucursalID,
		emp_idempresa as empresaID,
		catsuc_nombrecto as catSucNombrecto,
		nombre_sucursal as nombreSucursal,
		nombre_base as nombreBase,
		ip_servidor as servidorIP,
		tipo as tipo,
		rfc  as rfc
	from [192.168.20.9].[Centralizacionv2].[dbo].[DIG_CAT_BASES_BPRO] 
	where emp_idempresa = @EmpresaID and estatus=1
	AND TIPO =1*/

	SELECT 
			sucursalID,
			empresaID,
			catSucNombrecto,
			nombreSucursal,
			nombreBase,
			servidorIP,
			tipo,
			rfc
	FROM	sucursal
	WHERE	empresaID = @EmpresaID
	AND		estatusID=1
	AND		TIPO =1
	
	
		 
END
GO
/****** Object:  StoredProcedure [dbo].[OBTIENEVIN_SP]    Script Date: 02/12/2018 18:33:19 ******/
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
CREATE PROCEDURE [dbo].[OBTIENEVIN_SP]
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
/****** Object:  StoredProcedure [dbo].[SEL_ACTIVE_DATABASES_SP]    Script Date: 02/12/2018 18:33:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SEL_ACTIVE_DATABASES_SP]

as
begin

	declare @tableConf  Table
(
	idEmpresa  int,
	idSucursal int,
	servidor   varchar(250),
	baseConcentra   varchar(250),
	sqlCmd varchar(8000),
	cargaDiaria varchar(8000)
)


			insert into @tableConf
			select  BP. emp_idempresa as idEmpresa,
					BP.suc_idsucursal as idSucursal,				
					
					'['+ BP.ip_servidor +'].' +'['+ BP.nombre_base+'].'+'[dbo]' as servidor	,
					(select '['+ ip_servidor +'].' +'['+ nombre_base+'].'+'[dbo]'															
					from    [Centralizacionv2].[dbo].[DIG_CAT_BASES_BPRO] 
					where   emp_idempresa = BP.emp_idempresa and tipo=2) as baseConcentra,


					'INS_PRECARGA ' +
					+ char(39) +'['+ BP.ip_servidor +'].' +'['+ BP.nombre_base+'].'+'[dbo]' + char(39) + ','+
					+ char(39) + (select '['+ ip_servidor +'].' +'['+ nombre_base+'].'+'[dbo]' from    [Centralizacionv2].[dbo].[DIG_CAT_BASES_BPRO] where   emp_idempresa = BP.emp_idempresa and tipo=2)  +  char(39) + ','+
					  convert(varchar(5),BP. emp_idempresa) +','+
					  convert(varchar(5),BP.suc_idsucursal) as sqlcmd,

					'INS_CARGADIARIA ' +
					  char(39) +'['+ BP.nombre_base+'].'+'[dbo].' + char(39) + ','+					
					  convert(varchar(5),BP. emp_idempresa) +','+
					  convert(varchar(5),BP.suc_idsucursal) as sqlcmd

			from    [Centralizacionv2].[dbo].[DIG_CAT_BASES_BPRO] BP,
					[ControlAplicaciones].[dbo].[cat_empresas]    CE
			where   BP.emp_idempresa = CE.emp_idempresa
			and		BP.estatus=1 
			and		BP.tipo=1
			and		BP.suc_idsucursal  is not null

			select  * from @tableConf

end
GO
/****** Object:  StoredProcedure [dbo].[INFOUNIDAD_SP]    Script Date: 02/12/2018 18:33:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ing. Alejandro Grijalva Antonio
-- Create date: 2018-02-16
-- Description:	Obtención de la información de las unidades mediante el VIN
-- =============================================
CREATE PROCEDURE [dbo].[INFOUNIDAD_SP]
	@idEmpresa  INT  = 1,
	@idSucursal INT  = 3,
	@VIN VARCHAR(17) = 'JS2ZC63S9J6104103'
AS
BEGIN
	-- Se obtiene la relacioón de las bases de datos para el dinamismo.
	DECLARE @tableConf  TABLE(idEmpresa INT, idSucursal INT, servidor VARCHAR(250), baseConcentra VARCHAR(250), sqlCmd VARCHAR(8000), cargaDiaria VARCHAR(8000));
	INSERT INTO @tableConf Execute [dbo].[SEL_ACTIVE_DATABASES_SP];
	
	-- Se obtiene la base de datos en relacion a la sucursal y empresa.
	DECLARE @base VARCHAR(300) = (SELECT servidor FROM @tableConf WHERE idEmpresa = @idEmpresa AND idSucursal = @idSucursal);
	
	-- Los datos de las unidades se encuentra en la tabla VEH_NUMSERIE de cada una de las sucusales
	DECLARE @queryString VARCHAR(MAX) = 'SELECT * FROM ' + @base + '.SER_VEHICULO WHERE VEH_NUMSERIE = ''' + @VIN + '''';

	EXECUTE( @queryString );

END
GO
/****** Object:  StoredProcedure [dbo].[INFOINVENTARIO_SP]    Script Date: 02/12/2018 18:33:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ing. Alejandro Grijalva Antonio
-- Create date: 2018-02-06
-- Description:	Se obtiene la sucursal primera en donde se obtuvo interacción
-- =============================================
CREATE PROCEDURE [dbo].[INFOINVENTARIO_SP]
	@idEmpresa  INT  = 0,
	@VIN VARCHAR(17) = '',
	@tipo INT		 = 1
AS
BEGIN
	SET NOCOUNT ON;
	-- Se obtiene la relacioón de las bases de datos para el dinamismo.
	DECLARE @tableConf  TABLE(idEmpresa INT, idSucursal INT, servidor VARCHAR(250), baseConcentra VARCHAR(250), sqlCmd VARCHAR(8000), cargaDiaria VARCHAR(8000));
	INSERT INTO @tableConf Execute [dbo].[SEL_ACTIVE_DATABASES_SP];

	DECLARE @tblSucActiva  TABLE(id INT IDENTITY, idSucursal INT, vin VARCHAR(17), base VARCHAR(MAX), baseConcentra VARCHAR(MAX));

	-- Se obtiene la base de datos en relacion a la sucursal y empresa.
	DECLARE @Base VARCHAR(MAX) = '';
	DECLARE @BaseConcentra VARCHAR(MAX) = '';

	DECLARE @Current INT = 0, @Max INT = 0;
	SELECT @Current = MIN(idSucursal),@Max = MAX(idSucursal) FROM @tableConf WHERE idEmpresa = @idEmpresa;

	-- BÚSQUEDA DE UNIDADES EN LAS SUCURSALES

	WHILE(@Current <= @Max )
		BEGIN
			SET @Base			= (SELECT servidor FROM @tableConf WHERE idSucursal = @Current);
			SET @BaseConcentra  = (SELECT baseConcentra FROM @tableConf WHERE idSucursal = @Current);
			-- PRINT(@BaseConcentra);
			
			INSERT INTO @tblSucActiva EXECUTE('SELECT SUC = '+ @Current +', VEH_NUMSERIE, '''+ @Base +''', '''+@BaseConcentra+''' FROM '+ @Base +'.SER_VEHICULO WHERE VEH_NUMSERIE = ''' + @vin + ''' AND VEH_SITUACION != ''''');
			SET	@Current = @Current + 1;
		END 
		
	DECLARE @total INT = (SELECT COUNT(id) FROM @tblSucActiva);
	
	IF( @total = 0 )		-- El VIN proporcionado no es correcto
		BEGIN
			-- RETURN (SELECT sucursal_matriz FROM Centralizacionv2..DIG_CAT_BASES_BPRO WHERE emp_idempresa = @idEmpresa AND tipo = 2);
			RETURN 0;
		END
	ELSE IF (@total = 1)	-- El VIN proporcinado no se ha movido de su sucursal de compra
		BEGIN
			RETURN (SELECT idSucursal FROM @tblSucActiva);
		END
	ELSE IF(@total > 1)		-- El VIN proporcionado se ha movido de sucursal
		BEGIN
			DECLARE @aux VARCHAR(MAX) = '';
			IF( @tipo = 1 )   -- Current
				BEGIN
					SET @aux = 
					'SELECT TOP 1 TRA_SUCRECIBE FROM '+ @BaseConcentra +'.UNI_TRASPASOS 
					WHERE TRA_NUMSERIE  = '''+ @VIN +''' 
					ORDER BY TRA_NUMTRASPASO DESC;';
				END
			ELSE IF( @tipo = 2 )  -- Compra
				BEGIN
					SET @aux = 
					'SELECT TOP 1 TRA_SUCENVIA FROM '+ @BaseConcentra +'.UNI_TRASPASOS 
					WHERE TRA_NUMSERIE  = '''+ @VIN +''' 
					ORDER BY TRA_NUMTRASPASO ASC;';
				END
			
			
			DECLARE @strSucursal VARCHAR(100) = '';
			DECLARE @tblSucStr TABLE( VIN VARCHAR(100) );
			
			
			INSERT INTO @tblSucStr
			EXECUTE( @aux );
						
			SET @strSucursal = (SELECT VIN FROM @tblSucStr);
			RETURN (SELECT idSucursal FROM @tableConf WHERE servidor LIKE '%' + @strSucursal + '%');
		END
END
GO
/****** Object:  StoredProcedure [dbo].[EMPRESABYUSER_SP]    Script Date: 02/12/2018 18:33:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Ing. Alejandro Grijalva Antonio>
-- Create date: <2018-01-12>
-- Description:	<Obtención de empresas a las que ha sido asignado el usuario>
-- =============================================
CREATE PROCEDURE [dbo].[EMPRESABYUSER_SP]
	@idUsuario INT = 0
AS
BEGIN
	SELECT DISTINCT(emp_nombre), EMP.emp_idempresa
	FROM  [ControlAplicaciones].[dbo].[ope_organigrama]		ORG
	INNER JOIN [ControlAplicaciones].[dbo].[cat_sucursales] SUC ON ORG.suc_idsucursal = SUC.suc_idsucursal
	INNER JOIN [ControlAplicaciones].[dbo].[cat_empresas]	EMP ON EMP.emp_idempresa = SUC.emp_idempresa
	WHERE ORG.usu_idusuario = @idUsuario;
END
GO
/****** Object:  StoredProcedure [dbo].[BRPO_VENTAS_SP]    Script Date: 02/12/2018 18:33:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ing. Alejandro Grijalva Antonio
-- Create date: 2018-02-09
-- Description:	Monitoreo de Ventas de Unidades
-- [dbo].[BRPO_VENTAS_SP] 4
-- =============================================
CREATE PROCEDURE [dbo].[BRPO_VENTAS_SP]
	@idEmpresa INT = 1
AS
BEGIN
	BEGIN TRY

	DECLARE @VinDocumentos TABLE( Id INT IDENTITY, idEmpresa INT, idSucursal INT, VIN VARCHAR(17), Documento VARCHAR(20) );
	INSERT INTO @VinDocumentos EXECUTE [OBTIENEVIN_SP] @idEmpresa;
	
	DECLARE @Current INT, @Max INT;
	SELECT @Current = MIN( Id ), @Max = MAX(Id) FROM @VinDocumentos;
	
	DECLARE @VIN VARCHAR(17) = '',
			@idSucursal INT = 0,
			@Documento VARCHAR(20) = '';
	
	DECLARE @tableConf  TABLE(idEmpresa INT, idSucursal INT, servidor VARCHAR(250), baseConcentra VARCHAR(250), sqlCmd VARCHAR(8000), cargaDiaria VARCHAR(8000));
	INSERT INTO @tableConf Execute [dbo].[SEL_ACTIVE_DATABASES_SP];
	
	DECLARE @Ventas TABLE(
		idEmpresa INT,
		idSucursal INT,
		CCP_IDDOCTO VARCHAR(20),
		VTE_TIPODOCTO varchar(10),
		VTE_DOCTO varchar(20),
		VTE_IDCLIENTE numeric(18, 0),
		VTE_FECHDOCTO varchar(10),
		VTE_HORADOCTO varchar(5),
		VTE_REFERENCIA1 varchar(50),
		VTE_FORMAPAGO varchar(10),
		VTE_VTABRUT decimal(18, 5),
		VTE_IVA decimal(18, 5),
		VTE_TOTAL decimal(18, 5),
		VTE_SERIE varchar(17),
		VTE_CVEUSU varchar(10),
		VTE_FECHOPE varchar(10),
		VTE_IVADESG varchar(1),
		VTE_IVAPLICADO varchar(10),
		VTE_TIPO varchar(10),
		VTE_CONSECUTIVO numeric(18, 0),
		VTE_ANNO varchar(4),
		VTE_MES numeric(18, 0)
	);
	
	DECLARE @BaseSucursal VARCHAR(100);
	DECLARE @aux VARCHAR(MAX) = '';
	
	
	
	WHILE ( @Current <= @Max )
		BEGIN			
			SELECT @VIN = VIN, @Documento = Documento, @idSucursal = idSucursal FROM @VinDocumentos WHERE Id = @Current;

			SET NOCOUNT ON;
			
			SET @BaseSucursal = (SELECT servidor FROM @tableConf WHERE idEmpresa = @idEmpresa AND idSucursal = @idSucursal);
			
			
			
			SET @aux ='SELECT 
							' + CONVERT( VARCHAR(3), @idEmpresa ) + ' as idEmpresa,
							' + CONVERT( VARCHAR(3), @idSucursal ) + ' as idSucursal,
							''' + @Documento + ''' as Documento,
							VTE_TIPODOCTO,		VTE_DOCTO,			VTE_IDCLIENTE,	VTE_FECHDOCTO,
							VTE_HORADOCTO,		VTE_REFERENCIA1,	VTE_FORMAPAGO,	VTE_VTABRUT,
							VTE_IVA,			VTE_TOTAL,			VTE_SERIE,		VTE_CVEUSU,
							VTE_FECHOPE,		VTE_IVADESG,		VTE_IVAPLICADO,	VTE_TIPO,
							VTE_CONSECUTIVO,	VTE_ANNO,			VTE_MES
							
						FROM '+ @BaseSucursal +'.[ADE_VTAFI] 
						WHERE VTE_SERIE  = '''+ @VIN +'''
							  AND VTE_STATUS = ''I'';';
					
					
	
			INSERT INTO @Ventas
			EXECUTE( @aux );
			
			SET @Current = @Current + 1;
	END
	
	INSERT INTO Venta(
		idEmpresa,			idSucursal,			CCP_IDDOCTO,
		VTE_TIPODOCTO,		VTE_DOCTO,			VTE_IDCLIENTE,	VTE_FECHDOCTO,
		VTE_HORADOCTO,		VTE_REFERENCIA1,	VTE_FORMAPAGO,	VTE_VTABRUT,
		VTE_IVA,			VTE_TOTAL,			VTE_SERIE,		VTE_CVEUSU,
		VTE_FECHOPE,		VTE_IVADESG,		VTE_IVAPLICADO,	VTE_TIPO,
		VTE_CONSECUTIVO,	VTE_ANNO,			VTE_MES
	)
	SELECT	
		TEMP.idEmpresa,			TEMP.idSucursal,		TEMP.CCP_IDDOCTO,
		TEMP.VTE_TIPODOCTO,		TEMP.VTE_DOCTO,			TEMP.VTE_IDCLIENTE,		TEMP.VTE_FECHDOCTO,
		TEMP.VTE_HORADOCTO,		TEMP.VTE_REFERENCIA1,	TEMP.VTE_FORMAPAGO,		TEMP.VTE_VTABRUT,
		TEMP.VTE_IVA,			TEMP.VTE_TOTAL,			TEMP.VTE_SERIE,			TEMP.VTE_CVEUSU,
		TEMP.VTE_FECHOPE,		TEMP.VTE_IVADESG,		TEMP.VTE_IVAPLICADO,	TEMP.VTE_TIPO,
		TEMP.VTE_CONSECUTIVO,	TEMP.VTE_ANNO,			TEMP.VTE_MES
	FROM @Ventas TEMP
	LEFT JOIN Venta VEN ON VEN.idEmpresa		= TEMP.idEmpresa
							AND VEN.idSucursal		= TEMP.idSucursal
							AND VEN.CCP_IDDOCTO		= TEMP.CCP_IDDOCTO
							AND VEN.VTE_DOCTO		= TEMP.VTE_DOCTO
							AND VEN.VTE_IDCLIENTE	= TEMP.VTE_IDCLIENTE
							AND VEN.VTE_FECHDOCTO	= TEMP.VTE_FECHDOCTO
							AND VEN.VTE_HORADOCTO	= TEMP.VTE_HORADOCTO
							AND VEN.VTE_SERIE		= TEMP.VTE_SERIE
	WHERE VEN.VTE_DOCTO IS NULL;
END TRY
BEGIN CATCH
	SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[BPRO_TRASPASOS_SP]    Script Date: 02/12/2018 18:33:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ing. Alejandro Grijalva Antonio
-- Create date: 2018-02-08
-- Description:	
-- [BPRO_TRASPASOS_SP] 1
-- =============================================
CREATE PROCEDURE [dbo].[BPRO_TRASPASOS_SP]
	@idEmpresa INT = 0
AS
BEGIN
	BEGIN TRY
		DECLARE @VinDocumentos TABLE( Id INT IDENTITY, idEmpresa INT, idSucursal INT, VIN VARCHAR(17), Documento VARCHAR(20) );

		INSERT INTO @VinDocumentos EXECUTE [OBTIENEVIN_SP] @idEmpresa;
		
		DECLARE @Current INT, @Max INT;
		SELECT @Current = MIN( Id ), @Max = MAX(Id) FROM @VinDocumentos;
		
		DECLARE @VIN VARCHAR(17) = '',
				@Documento VARCHAR(20);
		
		DECLARE @tableConf  TABLE(idEmpresa INT, idSucursal INT, servidor VARCHAR(250), baseConcentra VARCHAR(250), sqlCmd VARCHAR(8000), cargaDiaria VARCHAR(8000));
		INSERT INTO @tableConf Execute [dbo].[SEL_ACTIVE_DATABASES_SP];
		DECLARE @Traspasos TABLE( idTraspasoLocal INT IDENTITY, idTraspaso INT, VIN VARCHAR(17), idSucursalEnvia VARCHAR(100), idSucursalRecibe VARCHAR(100), fechaOperacion DATE, sitacion VARCHAR(10) );
		DECLARE @BaseConcentra VARCHAR(100);
		DECLARE @aux VARCHAR(MAX) = '';
		
		WHILE ( @Current <= @Max )
			BEGIN			
				SELECT @VIN = VIN, @Documento = Documento FROM @VinDocumentos WHERE Id = @Current;

				SET NOCOUNT ON;
				
				SET @BaseConcentra  = (SELECT TOP 1 baseConcentra FROM @tableConf WHERE idEmpresa = @idEmpresa);
				
				SET @aux = 
						'SELECT 
							idTraspaso		 = TRA_NUMTRASPASO, 
							VIN				 = TRA_NUMSERIE, 
							idSucursalEnvia  = TRA_SUCENVIA, 
							idSucursalRecibe = TRA_SUCRECIBE, 
							fechaOperacion   = TRA_FECHOPE, 
							sitacion		 = TRA_SITUACION
						FROM '+ @BaseConcentra +'.UNI_TRASPASOS 
						WHERE TRA_NUMSERIE  = '''+ @VIN +''' 
						ORDER BY TRA_NUMTRASPASO DESC;';

				INSERT INTO @Traspasos
				EXECUTE( @aux );
				
				-- SELECT * FROM @Traspasos TEMP LEFT JOIN Traspaso TRA ON TRA.TRA_NUMTRASPASO = TEMP.idTraspaso WHERE TRA.TRA_NUMTRASPASO IS NULL
				IF EXISTS( SELECT * FROM @Traspasos TEMP LEFT JOIN Traspaso TRA ON TRA.TRA_NUMTRASPASO = TEMP.idTraspaso WHERE TRA.TRA_NUMTRASPASO IS NULL )
					BEGIN
						DECLARE @idSucursalRecibe VARCHAR( 25 ) = ( SELECT TOP 1 idSucursalRecibe FROM @Traspasos ORDER BY idTraspaso DESC );
						
						UPDATE Documentos 
						SET idSucursal = (SELECT idSucursal FROM @tableConf WHERE servidor LIKE '%' + @idSucursalRecibe + '%')
						WHERE CCP_IDDOCTO = @Documento;
					END
				
				INSERT INTO Traspaso(idEmpresa, TRA_NUMTRASPASO, VIN, CCP_IDDOCTO, idSucursalEnvia, idSucursalRecibe, fechaOperacion, sitacion)
				SELECT  idEmpresa = @idEmpresa,
						TEMP.idTraspaso,
						TEMP.VIN,
						CCP_IDDOCTO = @Documento,
						idSucursalEnvia  = (SELECT idSucursal FROM @tableConf WHERE servidor LIKE '%' + TEMP.idSucursalEnvia + '%'),
						idSucursalRecibe = (SELECT idSucursal FROM @tableConf WHERE servidor LIKE '%' + TEMP.idSucursalRecibe + '%'),
						TEMP.fechaOperacion,
						TEMP.sitacion
				FROM @Traspasos TEMP
				LEFT JOIN Traspaso TRA ON TRA.TRA_NUMTRASPASO = TEMP.idTraspaso
				WHERE TRA.TRA_NUMTRASPASO IS NULL;
				
				
				DELETE FROM @Traspasos;
				
				SET @Current = @Current + 1;
			END
		
	END TRY
	BEGIN CATCH
		SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[SUCURSALBYUSUARIO_SP]    Script Date: 02/12/2018 18:33:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Ing. Alejandro Grijalva Antonio>
-- Create date: <2018-01-12>
-- Description:	<Obtención de sucursales a las que ha sido asignado el usuario>
-- =============================================
CREATE PROCEDURE [dbo].[SUCURSALBYUSUARIO_SP]
	@idEmpresa INT = 0,
	@idUsuario INT = 0
AS
BEGIN
	SELECT 
		DISTINCT (SUC.suc_nombre) as nombreSucursal, 
		SUC.suc_idsucursal as sucursalID,
		4 as empresaID,
		suc_nombrebd as nombreBase,
		suc_ipbd as servidorIP,
		1 as tipo,
		1 as rfc
	FROM  [ControlAplicaciones].[dbo].[ope_organigrama]		ORG
	INNER JOIN [ControlAplicaciones].[dbo].[cat_sucursales] SUC ON ORG.suc_idsucursal = SUC.suc_idsucursal
	WHERE ORG.emp_idempresa		= @idEmpresa
		  AND ORG.usu_idusuario = @idUsuario
END
GO
/****** Object:  StoredProcedure [dbo].[PLP_CHECKVIN_SP]    Script Date: 02/12/2018 18:33:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ing. Alejandro Grijalva Antonio
-- Create date: 2018-01-22
-- Description:	Consulta por VIN de los eventos que les ha sucedido.
-- [dbo].[PLP_CHECKVIN_SP] 1, 'TSMYE21S0GM266915'
-- =============================================
CREATE PROCEDURE [dbo].[PLP_CHECKVIN_SP]
	@idEmpresa INT		= 1,
	@vin VARCHAR(17)	= 'TSMYD21S5GM186416'
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @FacturaQuery varchar(max)  = '';
	DECLARE @Base VARCHAR(MAX)			= '';

	-- Consulta de las bases de datos y sucursales activas
	DECLARE @tableConf  TABLE(idEmpresa INT, idSucursal INT, servidor VARCHAR(250), baseConcentra VARCHAR(250), sqlCmd VARCHAR(8000), cargaDiaria VARCHAR(8000));
	DECLARE @sucCompra  TABLE(id INT IDENTITY, idSucursal INT, vin VARCHAR(17), base VARCHAR(MAX));
	
	-- Se obtienen las rutas de las bases de datos
	INSERT INTO @tableConf Execute [PlanPiso].[dbo].[SEL_ACTIVE_DATABASES_SP];
	PRINT( '========================= [ Búsqueda Eventos de Unidades en la Empresa ] =========================' );
	-- PRINT( 'EMPRESA ' + CONVERT(VARCHAR(2), @idEmpresa));
	
	-- Delimitación de inicio y fin de las sucursales
	DECLARE @Current INT = 0, @Max INT = 0;
	SELECT @Current = MIN(idSucursal),@Max = MAX(idSucursal) FROM @tableConf WHERE idEmpresa = @idEmpresa;
	
	-- BÚSQUEDA DE UNIDADES EN LAS SUCURSALES
	WHILE(@Current <= @Max )
		BEGIN
			SET @Base = (SELECT servidor FROM @tableConf WHERE idSucursal = @Current);
			
			INSERT INTO @sucCompra EXECUTE('SELECT SUC = '+ @Current +', VEH_NUMSERIE, '''+ @Base +''' FROM '+ @Base +'.SER_VEHICULO WHERE VEH_NUMSERIE = ''' + @vin + '''');
			SET	@Current = @Current + 1;
		END 

	DECLARE @total INT = (SELECT COUNT(id) FROM @sucCompra);
	DECLARE @currentBase VARCHAR(300);
	
	DECLARE @Iventario VARCHAR(MAX); 
	
	DECLARE @tmp_inventario VARCHAR(MAX);
	
	
	IF( @total = 0 )
		BEGIN
			SELECT msg = 'VIN no existente';
		END
	ELSE IF( @total = 1 ) -- Sin traspaso
		BEGIN			
			SET @currentBase  = ( SELECT base FROM @sucCompra);
			SELECT @Iventario = [PlanPiso].[dbo].[INVENTARIO_FN]( @currentBase, @vin,1,1 );
			EXECUTE(@Iventario);
		END
	ELSE
		BEGIN
			-- SUCURSAL COMPRA
			-- SUCURSAL COMPRA
			-- SUCURSAL COMPRA
			DECLARE @sucEnvia VARCHAR(100) = (SELECT TOP 1 TRA_SUCENVIA FROM GAAU_Concentra..UNI_TRASPASOS WHERE TRA_NUMSERIE = @vin);
			
			IF( @sucEnvia IS NOT NULL )
				BEGIN
					SET @currentBase = ( SELECT servidor FROM @tableConf WHERE idEmpresa = @idEmpresa AND servidor LIKE '%'+ @sucEnvia +'%');
					PRINT( '' );
					PRINT( 'QUIEN COMPRA: ' + @sucEnvia );
					PRINT( '' );
					SELECT @Iventario = [PlanPiso].[dbo].[INVENTARIO_FN]( @currentBase, @vin,1,1 );
					EXECUTE(@Iventario);
					--EXECUTE('SELECT VEH_NUMSERIE,
					--				VEH_SITUACION,
					--				VEH_CATALOGO,
					--				VEH_ANMODELO
					--		 FROM '+ @sucCompra1 +'.SER_VEHICULO 
					--		 WHERE VEH_NUMSERIE = ''' + @vin + '''');
					
					-- TRASPASOS ENTRE SUCURSALES
					-- TRASPASOS ENTRE SUCURSALES
					-- TRASPASOS ENTRE SUCURSALES
					DECLARE @Traspasos TABLE( ID INT IDENTITY, NUMTRASPASO VARCHAR(10) );
					INSERT INTO @Traspasos
					SELECT TRA_NUMTRASPASO FROM GAAU_Concentra..UNI_TRASPASOS WHERE TRA_NUMSERIE = @vin ORDER BY TRA_NUMTRASPASO ASC;
					
					DECLARE @CurTras INT, @MaxTras INT;
					SELECT @CurTras = MIN(ID),@MaxTras = MAX(ID) FROM @Traspasos;
					WHILE(@CurTras <= @MaxTras )
						BEGIN
							SELECT TRA_NUMTRASPASO,
								   TRA_NUMSERIE,
								   TRA_SUCENVIA,
								   TRA_SUCRECIBE,
								   TRA_STATUS,
								   TRA_FECHOPE
							FROM GAAU_Concentra..UNI_TRASPASOS 
							WHERE TRA_NUMTRASPASO = (SELECT NUMTRASPASO FROM @Traspasos WHERE ID = @CurTras);
							SET	@CurTras = @CurTras + 1;
						END 
					-- SELECT * FROM @Traspasos;
				END
			ELSE
				BEGIN
					PRINT('No hay traspasos pero existen en dos bases.');
				END
			
		END
		
		
END
GO
/****** Object:  StoredProcedure [dbo].[uspGetMovimiento]    Script Date: 02/12/2018 18:33:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  procedure [dbo].[uspGetMovimiento]
@unidadID as bigint
as
begin
	SELECT 
			movimientoID,
			tipoCID,
			unidadID,
			usuarioID,
			empresaID,
			sucursalID,
			financieraID,
			esquemaID,
			fecha,
			monto
	FROM	Movimiento
	WHERE	@unidadID=unidadID

end
GO
/****** Object:  StoredProcedure [dbo].[uspGetMontoInteres]    Script Date: 02/12/2018 18:33:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[uspGetMontoInteres]

 @fechaCompra date, 
 @esquema numeric(18,4),
 @monto numeric(18,4)

AS
BEGIN			
		
				

		DECLARE @tablaInteres as table
		(
		idEsquema numeric(18,4),	
		idDetalleEsquema numeric(18,4),	
		idTiieTipo numeric(18,4),	
		

			tasaInteres numeric(18,4),	
			fechaInicio date,	
			fechaFin date,	
			tiie numeric(18,4),
			porcentajePenetracion numeric(18,4)
		)
		
		INSERT INTO @tablaInteres
		select 0,0,0, tasaInteres,fechaInicio,fechaFin, tiie,porcentajePenetracion from
			(
				select tasaInteres,fechaInicio,fechaFin,
				case 
					when [tipoTiieCID] =1 then  dbo.GetTiie([tipoTiieCID],default,default) 
					when [tipoTiieCID] =2 then  dbo.GetTiie([tipoTiieCID],fechaInicio	,fechaFin) 
					when [tipoTiieCID] =3 then  tiie 
					end  tiie,porcentajePenetracion ,
					[dbo].[IsOverlapDate] (fechaInicio,fechaFin,@fechaCompra,getdate()) isOverlap
				from EsquemaDetalle 
				where [esquemaID]= @esquema		
		) as base
		where isOverlap = 1

		declare @firstDayCurrentMonth as date = DATEADD(month, DATEDIFF(month, 0, getdate()), 0)
		update @tablaInteres set fechaInicio = @firstDayCurrentMonth
		where fechaInicio =@firstDayCurrentMonth
		
				
		IF((SELECT count(*) FROM @tablaInteres) > 0  )
		BEGIN
			UPDATE @tablaInteres 
			SET fechaInicio  = @fechaCompra
			WHERE fechaInicio =(SELECT min(fechaInicio) FROM @tablaInteres )

			UPDATE @tablaInteres 
			SET fechaFin  = GETDATE() 
			WHERE fechaFin =(SELECT max(fechaFin ) FROM @tablaInteres )
				
			SELECT 
			idEsquema,
			idDetalleEsquema,
			idTiieTipo,
			tasaInteres,
			fechaInicio,--convert(varchar(20),fechaInicio) fechaInicio,
			fechaFin,--convert(varchar(20),fechaFin) fechaFin,
			tiie,
			porcentajePenetracion
			, ((tasaInteres + tiie - porcentajePenetracion )/360/100 ) * 
					@monto * DATEDIFF(DAY,fechaInicio,fechaFin) monto
			FROM @tablaInteres 						
		END
	ELSE
		BEGIN
		select
		 0 as idEsquema,
			0 as idDetalleEsquema,
			0 as idTiieTipo,
			0 as tasaInteres,
			getdate() as fechaInicio,--			convert(varchar(20),getdate()) as fechaInicio,
			getdate() as fechaFin,--			convert(varchar(20),getdate()) as fechaFin,
			0 as tiie,
			0 as porcentajePenetracion,
			0 as monto
		
		END
	
END
GO
/****** Object:  StoredProcedure [dbo].[uspDelEsquema]    Script Date: 02/12/2018 18:33:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure  [dbo].[uspDelEsquema]
@esquemaID int

AS 
BEGIN
if exists (select * from movimiento where esquemaid = @esquemaID)
 BEGIN
	UPDATE Esquema
	SET		estatusCID        = 0
	WHERE	esquemaID =@esquemaID
 END
ELSE 
BEGIN
	 delete from esquema WHERE	esquemaID =@esquemaID
END

SELECT @esquemaID AS result

end
GO
/****** Object:  StoredProcedure [dbo].[Usp_MontoInteres_INS]    Script Date: 02/12/2018 18:33:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Irving Solorio>
-- Create date: <01/12/2017>
-- Description:	<Calcula e Inserta los intereses>
-- =============================================
CREATE PROCEDURE [dbo].[Usp_MontoInteres_INS]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  
		DECLARE @tablaInteres as table
		(
			idEsquema numeric(18,4),	
			idTiieTipo numeric(18,4),	
			idunidad varchar(20),
			tasaInteres numeric(18,4),	
			fechaInicio date,	
			fechaFin date,
			monto numeric(18,4),	
			tiie numeric(18,4),
			porcentajePenetracion numeric(18,4),
			plazo int,
			fechastatus int
		)
		
		INSERT INTO @tablaInteres
		select esquemaid,idTiieTipo,unidadid, tasaInteres,fechaInicio,fechaFin,monto, tiie,porcentajePenetracion,plazo,fechaStatus from
			(
				select e.esquemaid,e.tipoTiieCID idTiieTipo,tasaInteres,isnull(ma.fecha,fechaInicio) fechaInicio,fechaFin,u.SALDO monto,m.CCP_IDDOCTO unidadid,ma.fecha,
				case 
					when [tipoTiieCID] =1 then  dbo.GetTiie([tipoTiieCID],default,default) 
					when [tipoTiieCID] =2 then  dbo.GetTiie([tipoTiieCID],e.fechaInicio	,e.fechaFin) 
					when [tipoTiieCID] =3 then  tiie 
					end  tiie,porcentajePenetracion ,
					[dbo].[IsOverlapDate] (e.fechaInicio,e.fechaFin,u.fec_calculo,getdate()) isOverlap,
					plazo
					,case when ma.fecha is null then 0 else 1 end fechaStatus
				--	select  *
				from [dbo].[Esquema] e
				inner join [dbo].[Movimiento] m on e.esquemaID=m.esquemaID
				inner join [dbo].Documentos u on m.CCP_IDDOCTO=u.CCP_IDDOCTO
				left join (Select a.CCP_IDDOCTO,dateadd(day,1,MAX(a.fecha)) fecha
					from [dbo].[Movimiento] A
					inner join [dbo].[Movimiento] m on m.CCP_IDDOCTO=a.CCP_IDDOCTO
					where A.CCP_IDDOCTO = m.CCP_IDDOCTO
					and A.fecha < m.fecha and a.active=0
					group by a.CCP_IDDOCTO) ma on m.CCP_IDDOCTO=ma.CCP_IDDOCTO
				where m.active=1
				--where ed.[esquemaID]= @esquema		
		) as base
	--	where isOverlap = 1

		declare @firstDayCurrentMonth as date = DATEADD(month, DATEDIFF(month, 0, getdate()), 0)
		update @tablaInteres set fechaInicio = @firstDayCurrentMonth
		where  fechaStatus=0
		
				
		IF((SELECT count(*) FROM @tablaInteres) > 0  )
		BEGIN
			--UPDATE @tablaInteres 
			--SET fechaInicio  = @fechaCompra
			--WHERE fechaInicio =(SELECT min(fechaInicio) FROM @tablaInteres )

			UPDATE @tablaInteres 
			SET fechaFin  = GETDATE() 
			WHERE fechaFin =(SELECT max(fechaFin ) FROM @tablaInteres )
--INSERT INTO [dbo].[LoteInteres]
--           ([esquemaID]
--           ,[unidadID]
--           ,[interesCalculado]
--           ,[interesUsuario]
--           ,[pagoPorReduccion]
--           ,[estatusCID]
--			 ,plazo
--			 ,fecha_creacion)

			update m set monto=((t.monto*((tasaInteres + tiie - porcentajePenetracion )/100)/360)*plazo ) * ((DATEDIFF(DAY,fechaInicio,fechaFin)*100)/plazo),
			fecha=getdate()
--select *

			FROM @tablaInteres 		t
			inner join Movimiento m on t.idunidad=m.CCP_IDDOCTO and m.active=1



			SELECT 
			idEsquema,
			idunidad,
			((t.monto*((tasaInteres + tiie - porcentajePenetracion )/100)/360)*plazo ) * ((DATEDIFF(DAY,fechaInicio,fechaFin)*100)/plazo)
					 montointeres,
					0,0,0,0,getdate()
--select *
,*
			FROM @tablaInteres 		t
		--	left join 	[dbo].[LoteInteres] l on t.idEsquema=l.esquemaid and t.idunidad = l.unidadID and convert(nvarchar(8),l.fecha_creacion,112)=convert(nvarchar(8),getdate(),112)
		--	where l.loteId is null
			--SELECT 
--			idEsquema,
--			idunidad,
--			idDetalleEsquema,
--			idTiieTipo,
--			tasaInteres,
--			fechaInicio,--convert(varchar(20),fechaInicio) fechaInicio,
--			fechaFin,--convert(varchar(20),fechaFin) fechaFin,
--			tiie,
--			idunidad,
--			porcentajePenetracion,
--			plazo,
--			monto,
--			((tasaInteres + tiie - porcentajePenetracion )/360/plazo ) * 
--					monto * DATEDIFF(DAY,fechaInicio,fechaFin) montointeres
	--FROM @tablaInteres 			
		END

	
END
GO
/****** Object:  StoredProcedure [dbo].[Usp_EventosMovimientos_INS]    Script Date: 02/12/2018 18:33:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Irving Solorio>
-- Create date: <06/02/2018>
-- Description:	<Obtener movimientos de esquema,traspaso,etc de un documento e insertarlo en movimientos>
-- =============================================
CREATE PROCEDURE [dbo].[Usp_EventosMovimientos_INS]
	@CCP_IDDOCTO varchar(20),
	@usuarioID int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


 DECLARE 
		@esquemaID		as int = 0,	
		@sucursalID		as int = 0,
		@financieraID	as int = 0
		--,@CCP_IDDOCTO as varchar(20)='AU-ZM-NZA-UN-TPP-251',
	 --   @usuarioID  as int =71

		UPDATE [dbo].[Movimiento]
			   SET [active] = 0
			 WHERE CCP_IDDOCTO=@CCP_IDDOCTO

		select @esquemaID=esquemaID	, @sucursalID =sucursalID from Movimiento where CCP_IDDOCTO = @CCP_IDDOCTO 
		select @financieraID = financieraID from  Esquema where esquemaID = @esquemaID
INSERT INTO [dbo].[Movimiento]
           ([CCP_IDDOCTO]
           ,[VIN]
           ,[usuarioID]
           ,[empresaID]
           ,[sucursalID]
		   ,[sucursalRecibeID]
           ,[financieraID]
           ,[esquemaID]
           ,[fecha]
           ,[monto]
           ,[active]
           ,[tipoMovimientoId]
           ,[genericID]
           ,[fecha_original])
    select CCP_IDDOCTO,
	vin,
	@usuarioID,
	idEmpresa,
	idSucursalEnvia,
	idSucursalRecibe,
	@financieraID,
	@sucursalID,
	fechaOperacion,
	0 monto,
	0 active,
	2 traspaso,
	idTraspaso,
	fechaOperacion  
	from traspaso t where CCP_IDDOCTO = @CCP_IDDOCTO
	order by t.fechaOperacion,idTraspaso


INSERT INTO [dbo].[Movimiento]
           ([CCP_IDDOCTO]
           ,[VIN]
           ,[usuarioID]
           ,[empresaID]
           ,[sucursalID]
			 ,[sucursalRecibeID]
           ,[financieraID]
           ,[esquemaID]
           ,[fecha]
           ,[monto]
           ,[active]
           ,[tipoMovimientoId]
           ,[genericID]
           ,[fecha_original])
    select CCP_IDDOCTO,
	t.vte_serie,
	@usuarioID,
	idEmpresa,
	idSucursal,
	null,
	@financieraID,
	@sucursalID,
	convert(smalldatetime,VTE_FECHOPE,103) fechaOperacion,
	0 monto,
	0 active,
	5 venta,
	VTE_CONSECUTIVO,
	convert(smalldatetime,VTE_FECHOPE,103) fechaOriginal  
	from venta t where CCP_IDDOCTO = @CCP_IDDOCTO
	order by t.VTE_FECHOPE

	UPDATE Movimiento
			   SET [active]=1
	 WHERE  movimientoID in (select max(movimientoID) movimientoID from Movimiento WHERE CCP_IDDOCTO=@CCP_IDDOCTO)
END
GO
/****** Object:  StoredProcedure [dbo].[Usp_EsquemaMovimientos_GET]    Script Date: 02/12/2018 18:33:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Irving Solorio>
-- Create date: <06/02/2018>
-- Description:	<Obtener movimientos de esquema,traspaso,etc de un documento>
-- =============================================
CREATE PROCEDURE [dbo].[Usp_EsquemaMovimientos_GET]
	@CCP_IDDOCTO varchar(20)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT [movimientoID]
      ,[CCP_IDDOCTO]
      ,[usuarioID]
      ,[empresaID]
      ,[sucursalID]
      ,[financieraID]
      ,[esquemaID]
      ,[fecha]
      ,[monto]
      ,[active]
	  ,t.tipoMovimientoId tipoMovimientoId
      ,t.[tipoMovimiento] tipoMovimiento
  FROM [dbo].[Movimiento] m
  inner join [dbo].[TipoMovimiento] t on m.tipoMovimientoId=t.tipoMovimientoId
 WHERE CCP_IDDOCTO=@CCP_IDDOCTO

END
GO
/****** Object:  StoredProcedure [dbo].[Usp_Esquema_UPD]    Script Date: 02/12/2018 18:33:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Irving Solorio>
-- Create date: <06/02/2018>
-- Description:	<Actualiza el schema>
-- =============================================
CREATE PROCEDURE [dbo].[Usp_Esquema_UPD]
	@CCP_IDDOCTO varchar(20),
	@usuarioID int,
	@empresaID int,
	@sucursalID int,
	@financieraID int,
	@esquemaID int,
	@tipoMovimientoId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

UPDATE [dbo].[Movimiento]
   SET [active] = 0
 WHERE CCP_IDDOCTO=@CCP_IDDOCTO

INSERT INTO [dbo].[Movimiento]
           ([tipoMovimientoId]
           ,[CCP_IDDOCTO]
           ,[usuarioID]
           ,[empresaID]
           ,[sucursalID]
           ,[financieraID]
           ,[esquemaID]
           ,[fecha]
           ,[monto]
           ,[active])
     VALUES
           (@tipoMovimientoId
           ,@CCP_IDDOCTO
           ,@usuarioID
           ,@empresaID
           ,@sucursalID
           ,@financieraID
           ,@esquemaID
           ,getdate()
           ,0
           ,1)

END
GO
/****** Object:  StoredProcedure [dbo].[uspInsMovimiento]    Script Date: 02/12/2018 18:33:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[uspInsMovimiento]

@tipoMovimientoId as int,--[dbo].[uspGetCatalogo]  7
@CCP_IDDOCTO as varchar(20),
@vin as varchar(19),
@usuarioID as int,
@empresaID as int,
@sucursalID as int,
@financieraID as int,
@esquemaID as int,
@monto as numeric(18, 4),
@fechaoriginal smalldatetime

as
begin


INSERT INTO movimiento

    (
        tipoMovimientoId, 
        CCP_IDDOCTO,
		VIN,
        usuarioID,
        empresaID,
        sucursalID,
        financieraID,
        esquemaID,
        fecha,
        monto,
		active,
		fecha_original
    )
VALUES
    (
        @tipoMovimientoId,
        @CCP_IDDOCTO,
		@vin,
        @usuarioID,
        @empresaID,
        @sucursalID,
        @financieraID,
        @esquemaID,
        @fechaoriginal,
        @monto,
		1,
		@fechaoriginal
    )
end
GO
/****** Object:  StoredProcedure [dbo].[uspGetUnidadesInteres]    Script Date: 02/12/2018 18:33:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[uspGetUnidadesInteres] 1,3,59
CREATE Procedure [dbo].[uspGetUnidadesInteres]
@empresaID int,
@sucursalID int = null,
@financieraID int = null
as
begin



	select 
			U.CCP_IDDOCTO,
			U.CCP_OBSGEN vehNumserie,
			'' descModelo,
			'' modelo,
			U.IMPORTE importe,
			U.SALDO saldo,
			U.idEmpresa empresaID,
			U.idSucursal sucursalID,
			UI.esquemaID,
			U.DIAS diasInteres,
			U.DIASVENCIDOS diasRestantes,
			0 InteresCortePagado,
			UI.monto InteresMesActual,
			0 InteresAcumuladoFinanciera,
			0 InteresTotal,
			(select financieraID from Esquema where esquemaID = ui.esquemaID) financieraID,
			0 pagoReduccion			

	FROM Documentos U 
	INNER JOIN Movimiento UI 
	ON U.CCP_IDDOCTO  = UI.CCP_IDDOCTO
	and ui.active = 1 
	AND U.doc_estatus = 2
	AND ui.empresaID=@empresaID  
	AND  ui.sucursalID=@sucursalID 
	AND ui.financieraID=@financieraID

end
GO
/****** Object:  StoredProcedure [dbo].[uspSetUnidadSchema]    Script Date: 02/12/2018 18:33:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[uspSetUnidadSchema]
@CCP_IDDOCTO as varchar(20),
@userID as int,
@esquemaID as int,
@fechaCalculo as date,
@saldoInicial as decimal(18,4)
AS
BEGIN
		UPDATE Documentos 
		SET
			
				doc_estatus      = 2,--[dbo].[uspGetCatalogo] 2
				fec_Calculo    = @fechaCalculo
		WHERE	CCP_IDDOCTO = @CCP_IDDOCTO 
		
		DECLARE 
		@empresaID		as int = 0,	
		@sucursalID		as int = 0,
		@financieraID	as int = 0,
		@vin as varchar(19),
		@fechaorigen smalldatetime
		select @empresaID=IDempresa	, @sucursalID =IDsucursal,@vin=CCP_OBSGEN ,@fechaorigen=convert(smalldatetime,ccp_fechope,103) from Documentos where CCP_IDDOCTO = @CCP_IDDOCTO 
		select @financieraID = financieraID from  Esquema where esquemaID = @esquemaID
										
		exec [uspInsMovimiento] 1,@CCP_IDDOCTO,@vin,@userID,@empresaID,@sucursalID,@financieraID,@esquemaID,@saldoInicial,@fechaorigen
		exec [Usp_EventosMovimientos_INS] @CCP_IDDOCTO,@userID
		select @@ROWCOUNT as rowAffected
END
GO
/****** Object:  StoredProcedure [dbo].[GAZM_CARTERAPROVEEDORES_SP]    Script Date: 02/12/2018 18:33:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ing. Alejandro Grijalva Antonio
-- Create date: 2018-02-07
-- Description:	Consulta de cartera de proveedores para la población
--				de tablas de operación plan piso 
-- =============================================
CREATE PROCEDURE [dbo].[GAZM_CARTERAPROVEEDORES_SP]
	
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON;
		
		DECLARE @idEmpresa INT		= 4;
		DECLARE @Fecha VARCHAR(10)	= CONVERT (date, GETDATE());
		

		SELECT
			DISTINCT ltrim(rtrim(PER_PATERNO + ' ' + PER_MATERNO + ' ' + PER_NOMRAZON)) AS Nombre,
			CCP_IDPERSONA as PERSONA,
			PER_RFC,
			USUARIO = 'GMI'
		INTO #CXC_TEMPPERSONAANT
		FROM [192.168.20.92].[GAZM_Concentra].[dbo].[VIS_CONCAR01], [192.168.20.92].[GAZM_Concentra].[dbo].[Per_Personas] WHERE CCP_IDPERSONA = PER_IDPERSONA

		SELECT * 
		INTO #BI_CARTERA_PLP 
		FROM [192.168.20.92].[GAZM_Concentra].[dbo].[vis_concar01], #CXC_TEMPPERSONAANT  
		WHERE CCP_IDPERSONA = #CXC_TEMPPERSONAANT.PERSONA
			  AND ccp_cartera IN (SELECT par_idenpara FROM [192.168.20.92].[GAZM_Concentra].[dbo].[Pnc_Parametr] WHERE Par_tipopara = 'CARTERA' AND Par_status <> 'I' 
			  AND SUBSTRING(PAR_DESCRIP5,1,9) = '2100-0010')
			  

		UPDATE #BI_CARTERA_PLP 
		SET ccp_docori='S' 
		FROM #BI_CARTERA_PLP AS Externo 
		WHERE ccp_docori<>'S' 
			  AND NOT EXISTS  
				(SELECT Interno.CCP_CONSCARTERA 
				 FROM #BI_CARTERA_PLP AS Interno 
				 WHERE interno.ccp_iddocto			= externo.ccp_iddocto 
					   AND interno.ccp_idpersona	= externo.ccp_idpersona 
					   AND interno.CCP_CARTERA		= externo.CCP_CARTERA 
					   AND interno.ccp_docori		= 'S') 



		UPDATE NUEVO 
		SET ccp_docori = ''  
		FROM #BI_CARTERA_PLP AS ANTERIOR, #BI_CARTERA_PLP AS NUEVO
		WHERE ANTERIOR.CCP_IDDOCTO			= NUEVO.CCP_IDDOCTO
			  AND ANTERIOR.CCP_CARTERA		= NUEVO.CCP_CARTERA
			  AND ANTERIOR.CCP_IDPERSONA	= NUEVO.CCP_IDPERSONA
			  AND ANTERIOR.ccp_docori		= 'S'
			  AND NUEVO.ccp_docori			= 'S'
			  AND convert(varchar,ANTERIOR.vcc_anno) + substring('0000000000',1,10 - len(convert(varchar,ANTERIOR.ccp_conscartera))) 
				  + convert(varchar,ANTERIOR.ccp_conscartera) <  convert(varchar,NUEVO.vcc_anno) 
				  + substring('0000000000',1,10-len(convert(varchar,NUEVO.ccp_conscartera))) + convert(varchar,NUEVO.ccp_conscartera)


		DELETE FROM #BI_CARTERA_PLP WHERE convert(Datetime,ccp_fechaDOCTO,103) > convert(Datetime,@Fecha,103) 

		SELECT 
			idEmpresa			= @idEmpresa,
			idSucursal			= 0,
			idSucursalCompra	= 0,
			MODULO				= CARTERA.PAR_IDMODULO ,
			DES_CARTERA			= CARTERA.PAR_DESCRIP1,
			DES_TIPODOCTO		= TIMO.PAR_DESCRIP1,  
			CCP_IDDOCTO,
			CCP_NODOCTO,
			CCP_COBRADOR,
			CCP_IDPERSONA,  
			rtrim(ltrim(PER_PATERNO + ' ' + PER_MATERNO + ' ' + PER_NOMRAZON)) as Nombre,
			CCP_FECHVEN,
			CCP_FECHPAG,
			CCP_FECHPROMPAG,
			CCP_FECHREV,
			CCP_CONCEPTO,
			CCP_REFERENCIA,
			CCP_OBSPAR, 
			ltrim(rtrim(ccp_obsgen + ' ' + CASE 
												WHEN ccp_vftipodocto = 'a' OR ccp_vftipodocto = 'u' 
													THEN (	SELECT vte_serie 
															FROM [192.168.20.92].[GAZM_Concentra].[dbo].[ade_vtafi]
															WHERE ccp_vftipodocto = vte_tipodocto 
																 AND ccp_vfdocto = vte_docto) 
												WHEN substring(ccp_vftipodocto,1,1) = 's' 
													THEN (	SELECT vte_referencia1 
															FROM [192.168.20.92].[GAZM_Concentra].[dbo].[ade_vtafi]
															WHERE ccp_vftipodocto = vte_tipodocto 
																  AND ccp_vfdocto = vte_docto) 
												WHEN ccp_vftipodocto = '' 
													 AND ccp_vfdocto = '' 
													 AND ccp_tipodocto = 'fac' 
													 AND len(ccp_obsgen) = 17 
													 AND ccp_cargo > 0 
													THEN (	SELECT TOP 1 rtrim(ltrim(isnull(vte_docto,'') + ' ' + isnull(ccp_obsgen,''))) 
															FROM [192.168.20.92].[GAZM_Concentra].[dbo].[ade_vtafi]
															WHERE vte_tipodocto IN ('a', 'u') 
																  AND vte_serie = ccp_obsgen 
																  AND vte_status = 'i') 
												ELSE '' 
											END)) as CCP_OBSGEN,  
			'IMPORTE' = CASE CARTERA.PAR_IDMODULO 
							WHEN 'CXC' THEN ccp_cargo-ccp_abono 
							ELSE ccp_abono-ccp_cargo 
						END,  
			'SALDO' = CASE CARTERA.PAR_IDMODULO 
							WHEN 'CXC' THEN ccp_cargo-ccp_abono +  (SELECT isnull(sum(CCP_CARGO-CCP_ABONO),0) 
																	FROM #BI_CARTERA_PLP AS MOVIMIENTO 
																	WHERE MOVIMIENTO.CCP_IDDOCTO = DOCUMENTO.CCP_IDDOCTO 
																		  AND MOVIMIENTO.CCP_IDPERSONA = DOCUMENTO.CCP_IDPERSONA 
																		  AND MOVIMIENTO.CCP_CARTERA = DOCUMENTO.CCP_CARTERA 
																		  AND MOVIMIENTO.CCP_DOCORI <> 'S' ) 
							ELSE ccp_abono - ccp_cargo + (	SELECT isnull(sum(CCP_ABONO-CCP_CARGO),0) 
															FROM #BI_CARTERA_PLP AS MOVIMIENTO  
															WHERE MOVIMIENTO.CCP_IDDOCTO = DOCUMENTO.CCP_IDDOCTO 
																  AND MOVIMIENTO.CCP_IDPERSONA = DOCUMENTO.CCP_IDPERSONA 
																  AND MOVIMIENTO.CCP_CARTERA = DOCUMENTO.CCP_CARTERA 
																  AND MOVIMIENTO.CCP_DOCORI <> 'S') 
						END,  
			'DIAS' = CASE WHEN CCP_FECHVEN <> '' 
							THEN Datediff(day,convert(datetime,@Fecha,103),convert(datetime,CCP_FECHVEN,103)) 
						  ELSE 0 
					 END,
			CCP_FECHADOCTO,
			CCP_REFER, 
			CVEUSU			= 'GMI', 
			HORAOPE			= CONVERT(VARCHAR(8),GETDATE(),108), 
			'DIASVENCIDOS'	= CASE WHEN isdate(CCP_FECHVEN) = 1 
								THEN DATEDIFF(DAY,CONVERT(DATETIME,CCP_FECHVEN,103),GETDATE()) 
								ELSE 0 
							  END, 
			INTERESES		= 0, 
			FECHAVENCIDO	= CCP_FECHVEN,
			CCP_GRUPO1,
			CCP_CARTERA,
			GRUPO			= CARTERA.PAR_DESCRIP2,   -- 30
			TELEFONO1		= PER_TELEFONO1,
			CCP_VFTIPODOCTO,
			CCP_VFDOCTO, 
			0 AS VEH_CATALOGO,
			0 AS VEH_ANMODELO,
			'' AS VEH_TIPOAUTO, 
			'' AS VTE_SERIE,
			0 AS VENDEDOR_NUEVO,
			CASE WHEN substring(ccp_referencia,1,8) = 'PER_FAC ' 
					THEN(	SELECT ltrim(rtrim(PER_PATERNO + ' ' +  PER_MATERNO + ' ' + PER_NOMRAZON)) 
							FROM [192.168.20.92].[GAZM_Concentra].[dbo].[per_personas]
							WHERE per_idpersona=substring(ccp_referencia,9,len(ccp_referencia))) 
				ELSE '' 
			END AS NOMBRE_REFERENCIAS,
			'' AS REFERENCIA1,
			'' AS REFERENCIA2,
			'' AS REFERENCIA3,
			CCP_TIPODOCTO,
			CCP_ORIGENCON,
			0 AS VEH_NOINVENTA,	
			CCP_TIPOPOL,
			CCP_CONSPOL,
			ccp_fechope,
			'' AS VENDEDOR_CXC,
			CCP_CONTRARECIBO,
			'' AS UNC_DESCRIPCION,
			(CASE WHEN VTE_TIPODOCTO = 'A' AND ( (	SELECT COUNT(VTE_REFERENCIA1) 
													FROM [192.168.20.92].[GAZM_Concentra].[dbo].[ade_vtafi] 
													INNER JOIN [192.168.20.92].[GAZM_Concentra].[dbo].[UNI_HISSALUNI] ON HSU_NOPEDIDO = VTE_REFERENCIA1 
													WHERE vte_docto = CCP_IDDOCTO) > 0) 
					THEN 'DPP' 
				ELSE '' 
			END) AS DPP,
			DOCUMENTO.CCP_PORIVA,
			0 AS IVA,
			0 AS SaldoSinIva,
			0 AS SaldoMasIva,
			DOCUMENTO.PER_RFC
		INTO #BI_CCP_TEMPAS
		FROM #BI_CARTERA_PLP AS DOCUMENTO 
		LEFT OUTER JOIN [192.168.20.92].[GAZM_Concentra].[dbo].[pnc_parametr] as CARTERA ON CCP_CARTERA = CARTERA.PAR_IDENPARA AND CARTERA.PAR_TIPOPARA='CARTERA'  
		INNER JOIN [192.168.20.92].[GAZM_Concentra].[dbo].[PER_PERSONAS] ON CCP_IDPERSONA = PER_IDPERSONA 
		LEFT OUTER JOIN [192.168.20.92].[GAZM_Concentra].[dbo].[pnc_parametr] as TIMO ON CCP_TIPODOCTO = TIMO.PAR_IDENPARA AND TIMO.PAR_TIPOPARA = 'TIMO'  
		INNER JOIN #CXC_TEMPPERSONAANT ON CCP_IDPERSONA = #CXC_TEMPPERSONAANT.PERSONA AND #CXC_TEMPPERSONAANT.USUARIO = 'GMI' 
		LEFT OUTER JOIN [192.168.20.92].[GAZM_Concentra].[dbo].[ADE_VTAFI] ON VTE_DOCTO = CCP_IDDOCTO AND VTE_CONSECUTIVO = CCP_CONSPOL  
		WHERE CCP_DOCORI='S' 
			  AND ccp_cartera IN (	SELECT par_idenpara 
									FROM [192.168.20.92].[GAZM_Concentra].[dbo].[Pnc_Parametr] 
									WHERE Par_tipopara = 'CARTERA' 
										  AND Par_status <> 'I' 
										  AND (SUBSTRING(PAR_DESCRIP5,1,9) = '2100-0010'));


		UPDATE #BI_CCP_TEMPAS
		SET CCP_VFDOCTO = CCP_IDDOCTO, CCP_VFTIPODOCTO = 'A'
		WHERE CVEUSU = 'GMI'
			  AND CCP_TIPODOCTO = 'RD'
			  AND charindex('-',ccp_iddocto) <> 0 AND CCP_ORIGENCON = 'PD'

		UPDATE #BI_CCP_TEMPAS 
		SET CCP_VFDOCTO = substring(CCP_IDDOCTO,1,1) + SUBSTRING('000000000',1,9-LEN(RTRIM(LTRIM(SUBSTRING(CCP_IDDOCTO,2,charindex('-',ccp_iddocto)-2))))) + 
		RTRIM(LTRIM(SUBSTRING(CCP_IDDOCTO,2,charindex('-',ccp_iddocto)-2))) 
		WHERE CVEUSU='GMI' AND CCP_TIPODOCTO = 'RD' AND 
		CCP_VFDOCTO<>'' AND CCP_VFTIPODOCTO<>'' and len(CCP_VFDOCTO)<10

		UPDATE #BI_CCP_TEMPAS 
		SET CCP_VFDOCTO=SUBSTRING(CCP_IDDOCTO,1,charindex('-',ccp_iddocto)-2) 
		WHERE CVEUSU='GMI' 
			  AND CCP_TIPODOCTO = 'RD' 
			  AND CCP_VFDOCTO <>'' 
			  AND CCP_VFTIPODOCTO <> '' 
			  AND len(CCP_VFDOCTO) > 10

		UPDATE #BI_CCP_TEMPAS 
		SET REFERENCIA1 = ISNULL(ADE_VTAFI.VTE_REFERENCIA1, ''),
			REFERENCIA2 = ISNULL(ADE_VTAFI.VTE_REFERENCIA2, ''),
			REFERENCIA3 = ISNULL(ADE_VTAFI.VTE_REFERENCIA3, ''),
			VTE_SERIE   = ISNULL(ADE_VTAFI.VTE_SERIE,'') 
		FROM #BI_CCP_TEMPAS, [192.168.20.92].[GAZM_Concentra].[dbo].[ADE_VTAFI]
		WHERE CCP_VFTIPODOCTO = ADE_VTAFI.VTE_TIPODOCTO 
			  AND CCP_VFDOCTO = ADE_VTAFI.VTE_DOCTO 
			  AND CVEUSU	  = 'GMI';
			  

		UPDATE #BI_CCP_TEMPAS 
		SET IVA = ( CASE WHEN C.VTE_TIPODOCTO = 'U' 
							THEN  (((A.SALDO) * VTE_IVA)/VTE_TOTAL) 
						ELSE (A.SALDO - Round(A.SALDO /((CONVERT(DECIMAL(4,2),(CONVERT(INT,A.CCP_PORIVA)))/100) + 1), 2)) 
					END) 
		FROM #BI_CCP_TEMPAS A 
		INNER JOIN [192.168.20.92].[GAZM_Concentra].[dbo].[VIS_CONCAR01] B ON B.CCP_IDDOCTO = A.CCP_IDDOCTO 
															 AND B.CCP_IDPERSONA = A.CCP_IDPERSONA 
															 AND B.CCP_CARTERA = A.CCP_CARTERA 
															 AND B.CCP_TIPODOCTO = A.CCP_TIPODOCTO 
															 AND B.CCP_ORIGENCON = A.CCP_ORIGENCON 
		LEFT OUTER JOIN [192.168.20.92].[GAZM_Concentra].[dbo].[ADE_VTAFI] C ON C.VTE_IDCLIENTE = B.CCP_IDPERSONA AND C.VTE_FECHDOCTO = A.CCP_FECHADOCTO 
		WHERE CVEUSU = 'GMI' AND SALDO <> 0


		UPDATE #BI_CCP_TEMPAS 
		SET IVA = ( CASE WHEN IVA IS NULL 
							THEN (SALDO - Round(SALDO /((CONVERT(DECIMAL(4,2),(CONVERT(INT,CCP_PORIVA)))/100) + 1), 2))  
					END) 
		WHERE IVA IS NULL


		UPDATE #BI_CCP_TEMPAS 
		SET SaldoSinIva = (DOCUMENTO.SALDO - IVA)
		FROM #BI_CCP_TEMPAS DOCUMENTO 
		LEFT OUTER JOIN [192.168.20.92].[GAZM_Concentra].[dbo].[ADE_VTAFI] SEMINUEVOS ON SEMINUEVOS.VTE_DOCTO = DOCUMENTO.CCP_IDDOCTO 
																		AND SEMINUEVOS.VTE_IDCLIENTE = DOCUMENTO.CCP_IDPERSONA  
		WHERE CVEUSU = 'GMI' AND DOCUMENTO.SALDO <> 0 


		UPDATE #BI_CCP_TEMPAS 
		SET SaldoMasIva = (SaldoSinIva + IVA)  
		FROM #BI_CCP_TEMPAS DOCUMENTO 
		LEFT OUTER  JOIN [192.168.20.92].[GAZM_Concentra].[dbo].[ADE_VTAFI] SEMINUEVOS ON SEMINUEVOS.VTE_DOCTO = DOCUMENTO.CCP_IDDOCTO 
																		AND SEMINUEVOS.VTE_IDCLIENTE = DOCUMENTO.CCP_IDPERSONA  
		WHERE CVEUSU = 'GMI' AND DOCUMENTO.SALDO <> 0 


		UPDATE #BI_CCP_TEMPAS 
		SET CCP_VFTIPODOCTO = null, 
			CCP_VFDOCTO = null 
		WHERE CCP_VFTIPODOCTO<>'A' AND cveusu='GMI'

		UPDATE #BI_CCP_TEMPAS 
		SET veh_catalogo = SER_VEHICULO.veh_catalogo,
			veh_anmodelo = SER_VEHICULO.veh_anmodelo,
			veh_tipoauto = SER_VEHICULO.veh_tipoauto,
			vte_serie = ADE_VTAFI.vte_serie,
			VENDEDOR_NUEVO=ltrim(rtrim(per_paterno + ' ' + per_materno + ' ' + per_nomrazon)),
			VEH_NOINVENTA = SER_VEHICULO.VEH_NOINVENTA,
			UNC_DESCRIPCION = UNI_CATALOGO.UNC_DESCRIPCION 
		FROM #BI_CCP_TEMPAS,[192.168.20.92].[GAZM_Concentra].[dbo].[ade_vtafi],[192.168.20.92].[GAZM_Concentra].[dbo].[uni_pedido],[192.168.20.92].[GAZM_Concentra].[dbo].[per_personas],[192.168.20.92].[GAZM_Concentra].[dbo].[ser_vehiculo],[192.168.20.92].[GAZM_Concentra].[dbo].[UNI_CATALOGO]
		WHERE ade_vtafi.vte_serie = ser_vehiculo.veh_numserie 
			  AND per_idpersona = upe_idagte 
			  AND VTE_TIPODOCTO = CCP_VFTIPODOCTO 
			  AND VTE_DOCTO = CCP_VFDOCTO 
			  AND vte_referencia1 = convert(varchar,upe_idpedi) 
			  AND cveusu = 'GMI' 
			  -- AND UNC_IDCATALOGO =* SER_VEHICULO.veh_catalogo
			  -- AND UNC_MODELO     =* SER_VEHICULO.veh_anmodelo
			  
		
		-- Depuración de registros
		DELETE FROM #BI_CCP_TEMPAS WHERE SALDO = 0;
		DELETE FROM #BI_CCP_TEMPAS WHERE DES_CARTERA NOT LIKE '%-%-0001-0001%';
		DELETE FROM #BI_CCP_TEMPAS WHERE CCP_IDDOCTO = 'AU-AU-UNI-UN-TPP-159';
		DELETE FROM #BI_CCP_TEMPAS WHERE CCP_IDDOCTO IN (
		'AU-AU-UNI-UN-TPP-124', 'AU-AU-UNI-UN-TPP-125', 'AU-AU-UNI-UN-TPP-226', 'AU-AU-UNI-UN-TPP-227', 'AU-AU-UNI-UN-TPP-228');
		
		UPDATE TEMP
		SET CCP_OBSGEN = DET.anu_numeroserie
		FROM #BI_CCP_TEMPAS TEMP
		INNER JOIN [cuentasxpagar].[dbo].[cxp_detalleautosnuevos] DET ON TEMP.CCP_IDDOCTO = DET.oce_folioorden COLLATE SQL_Latin1_General_CP1_CI_AS
		WHERE TEMP.CCP_IDDOCTO LIKE '%-%-%-%-%-%' AND CCP_OBSGEN = '';

		
		-- Set sucursal de compra de las unidades centralizadas
		UPDATE	TEMP
		SET		idSucursalCompra = oce_idsucursal
		FROM #BI_CCP_TEMPAS TEMP
		INNER JOIN [cuentasxpagar].[dbo].[cxp_detalleautosnuevos] DET ON DET.oce_folioorden = TEMP.CCP_IDDOCTO COLLATE Modern_Spanish_CI_AS
		INNER JOIN [cuentasxpagar].[dbo].[cxp_ordencompra] ORD ON DET.oce_folioorden = ORD.oce_folioorden
		WHERE TEMP.CCP_IDDOCTO LIKE '%-%-%-%-%-%' AND ORD.sod_idsituacionorden NOT IN(3,4);
		-- / Set sucursal de compra de las unidades centralizadas
		
		
		-- Set sucursal de las unidades NO centralizadas
		DECLARE @tblInventario TABLE( ID INT IDENTITY, VIN VARCHAR(20), DOCUMENTO VARCHAR(100) );
		
		INSERT INTO @tblInventario(VIN)
		SELECT  CCP_IDDOCTO FROM #BI_CCP_TEMPAS TEMP WHERE TEMP.CCP_IDDOCTO NOT LIKE '%-%-%-%-%-%';
		
		
		DECLARE @Current INT = 0, @Max INT = 0;
		SELECT @Current = MIN(ID), @Max = MAX(ID) FROM @tblInventario;
		
		DECLARE @vinTemp VARCHAR(20);
		DECLARE @idSucTempActual VARCHAR(5), 
				@idSucTempCompra VARCHAR(5);
		
		WHILE(@Current <= @Max )
			BEGIN
				SET @vinTemp = ( SELECT VIN FROM @tblInventario WHERE ID = @Current );
				
				EXEC @idSucTempActual = [INFOINVENTARIO_SP] @idEmpresa, @vinTemp, 1;
				EXEC @idSucTempCompra = [INFOINVENTARIO_SP] @idEmpresa, @vinTemp, 2;
				
				IF( @idSucTempActual != 0 )
					BEGIN 
						UPDATE	TEMP
						SET		idSucursal			= @idSucTempActual,
								idSucursalCompra	= @idSucTempCompra
						FROM #BI_CCP_TEMPAS TEMP
						WHERE TEMP.CCP_IDDOCTO = @vinTemp;
					END
				SET	@Current = @Current + 1;
			END 
		-- /Set sucursal de las unidades NO centralizadas
		
		
		-- Set sucursal de las unidades centralizadas
		DELETE FROM @tblInventario;
		
		INSERT INTO @tblInventario(VIN, DOCUMENTO)
		SELECT CCP_OBSGEN, CCP_IDDOCTO FROM #BI_CCP_TEMPAS TEMP WHERE TEMP.CCP_IDDOCTO LIKE '%-%-%-%-%-%';
		
		SELECT @Current = MIN(ID), @Max = MAX(ID) FROM @tblInventario;
		DECLARE @idDocto VARCHAR(100);
		WHILE(@Current <= @Max )
			BEGIN
				SELECT @vinTemp = VIN, @idDocto = DOCUMENTO FROM @tblInventario WHERE ID = @Current;
				
				EXEC @idSucTempActual = [INFOINVENTARIO_SP] @idEmpresa, @vinTemp, 1;
				
				IF( @idSucTempActual != 0 )
					BEGIN 
						UPDATE	TEMP
						SET		idSucursal = @idSucTempActual
						FROM #BI_CCP_TEMPAS TEMP
						WHERE TEMP.CCP_IDDOCTO = @idDocto;
					END
				SET	@Current = @Current + 1;
			END 
		-- /Set sucursal de las unidades centralizadas
		
		
		-- Set sucursal de los documentos sin estructura de IDDOCTO/VIN en el campo CCP_IDDOCTO
		DELETE FROM @tblInventario;
		
		INSERT INTO @tblInventario(VIN)
		SELECT CCP_OBSGEN
		FROM #BI_CCP_TEMPAS TEMP
		WHERE TEMP.CCP_IDDOCTO NOT LIKE '%-%-%-%-%-%' AND LEN( TEMP.CCP_IDDOCTO ) != 17 ;
		
		SELECT @Current = MIN(ID), @Max = MAX(ID) FROM @tblInventario;
		WHILE(@Current <= @Max )
			BEGIN
				SELECT @vinTemp = VIN FROM @tblInventario WHERE ID = @Current;
				
				EXEC @idSucTempActual = [INFOINVENTARIO_SP] @idEmpresa, @vinTemp, 1;
				
				IF( @idSucTempActual != 0 )
					BEGIN 
						UPDATE	TEMP
						SET		idSucursal = @idSucTempActual
						FROM #BI_CCP_TEMPAS TEMP
						WHERE TEMP.CCP_OBSGEN = @vinTemp;
					END
				SET	@Current = @Current + 1;
			END 
		-- /Set sucursal de los documentos sin estructura de IDDOCTO/VIN en el campo CCP_IDDOCTO
		
		
		-- ACTUALIZACIÓN DE SALDO DE DOCUMENTOS
		UPDATE
			DOCU
		SET
			DOCU.IMPORTE		= NUEVA.IMPORTE,
			DOCU.SALDO			= NUEVA.SALDO,
			DOCU.IVA			= NUEVA.IVA,
			DOCU.SaldoSinIva	= NUEVA.SaldoSinIva,
			DOCU.SaldoMasIva	= NUEVA.SaldoMasIva
		FROM #BI_CCP_TEMPAS NUEVA
		INNER JOIN [dbo].[CarteraProveedores] VIEJA ON VIEJA.CCP_IDDOCTO = NUEVA.CCP_IDDOCTO COLLATE Modern_Spanish_CI_AS
		INNER JOIN [dbo].[Documentos] DOCU ON DOCU.CCP_IDDOCTO = NUEVA.CCP_IDDOCTO COLLATE Modern_Spanish_CI_AS;
		
		
		-- DOCUMENTOS SALDADOS DESDE LA CARTERA
		UPDATE
			DOCU
		SET
			DOCU.IMPORTE		= 0,
			DOCU.SALDO			= 0,
			DOCU.IVA			= 0,
			DOCU.SaldoSinIva	= 0,
			DOCU.SaldoMasIva	= 0
		FROM #BI_CCP_TEMPAS NUEVA
		RIGHT JOIN [dbo].[CarteraProveedores] VIEJA ON VIEJA.CCP_IDDOCTO = NUEVA.CCP_IDDOCTO COLLATE Modern_Spanish_CI_AS
		INNER JOIN [dbo].[Documentos] DOCU ON DOCU.CCP_IDDOCTO = VIEJA.CCP_IDDOCTO COLLATE Modern_Spanish_CI_AS
		WHERE NUEVA.CCP_IDDOCTO IS NULL;
		
		
		-- INSERCION DE NUEVOS DOCUMENTOS A PLAN PISO
		INSERT INTO [dbo].[Documentos](
			[idEmpresa],			[MODULO],			[DES_CARTERA],			[DES_TIPODOCTO],
			[CCP_IDDOCTO],			[CCP_NODOCTO],		[CCP_COBRADOR],			[CCP_IDPERSONA],
			[Nombre],				[CCP_FECHVEN],		[CCP_FECHPAG],			[CCP_FECHPROMPAG],
			[CCP_FECHREV],			[CCP_CONCEPTO],		[CCP_REFERENCIA],		[CCP_OBSPAR],
			[CCP_OBSGEN],			[IMPORTE],			[SALDO],				[DIAS],
			[CCP_FECHADOCTO],		[CCP_REFER],		[CVEUSU],				[HORAOPE],
			[DIASVENCIDOS],			[INTERESES],		[FECHAVENCIDO],			[CCP_GRUPO1],
			[CCP_CARTERA],			[GRUPO],			[TELEFONO1],			[CCP_VFTIPODOCTO],
			[CCP_VFDOCTO],			[VEH_CATALOGO],		[VEH_ANMODELO],			[VEH_TIPOAUTO],
			[VTE_SERIE],			[VENDEDOR_NUEVO],	[NOMBRE_REFERENCIAS],	[REFERENCIA1],
			[REFERENCIA2],			[REFERENCIA3],		[CCP_TIPODOCTO],		[CCP_ORIGENCON],
			[VEH_NOINVENTA],		[ccp_tipopol],		[ccp_conspol],			[ccp_fechope],
			[VENDEDOR_CXC],			[CCP_CONTRARECIBO],	[UNC_DESCRIPCION],		[DPP],
			[CCP_PORIVA],			[IVA],				[SaldoSinIva],			[SaldoMasIva],
			[PER_RFC],				[idSucursal],		[idSucursalCompra]
		)
		SELECT 
			NUEVA.[idEmpresa],			NUEVA.[MODULO],			NUEVA.[DES_CARTERA],			NUEVA.[DES_TIPODOCTO],
			NUEVA.[CCP_IDDOCTO],		NUEVA.[CCP_NODOCTO],		NUEVA.[CCP_COBRADOR],			NUEVA.[CCP_IDPERSONA],
			NUEVA.[Nombre],				NUEVA.[CCP_FECHVEN],		NUEVA.[CCP_FECHPAG],			NUEVA.[CCP_FECHPROMPAG],
			NUEVA.[CCP_FECHREV],		NUEVA.[CCP_CONCEPTO],		NUEVA.[CCP_REFERENCIA],			NUEVA.[CCP_OBSPAR],
			NUEVA.[CCP_OBSGEN],			NUEVA.[IMPORTE],			NUEVA.[SALDO],					NUEVA.[DIAS],
			NUEVA.[CCP_FECHADOCTO],		NUEVA.[CCP_REFER],			NUEVA.[CVEUSU],					NUEVA.[HORAOPE],
			NUEVA.[DIASVENCIDOS],		NUEVA.[INTERESES],			NUEVA.[FECHAVENCIDO],			NUEVA.[CCP_GRUPO1],
			NUEVA.[CCP_CARTERA],		NUEVA.[GRUPO],				NUEVA.[TELEFONO1],				NUEVA.[CCP_VFTIPODOCTO],
			NUEVA.[CCP_VFDOCTO],		NUEVA.[VEH_CATALOGO],		NUEVA.[VEH_ANMODELO],			NUEVA.[VEH_TIPOAUTO],
			NUEVA.[VTE_SERIE],			NUEVA.[VENDEDOR_NUEVO],		NUEVA.[NOMBRE_REFERENCIAS],		NUEVA.[REFERENCIA1],
			NUEVA.[REFERENCIA2],		NUEVA.[REFERENCIA3],		NUEVA.[CCP_TIPODOCTO],			NUEVA.[CCP_ORIGENCON],
			NUEVA.[VEH_NOINVENTA],		NUEVA.[ccp_tipopol],		NUEVA.[ccp_conspol],			NUEVA.[ccp_fechope],
			NUEVA.[VENDEDOR_CXC],		NUEVA.[CCP_CONTRARECIBO],	NUEVA.[UNC_DESCRIPCION],		NUEVA.[DPP],
			NUEVA.[CCP_PORIVA],			NUEVA.[IVA],				NUEVA.[SaldoSinIva],			NUEVA.[SaldoMasIva],
			NUEVA.[PER_RFC],			NUEVA.[idSucursal],			NUEVA.[idSucursalCompra]
		FROM #BI_CCP_TEMPAS NUEVA
		LEFT JOIN [dbo].[CarteraProveedores] VIEJA ON VIEJA.CCP_IDDOCTO = NUEVA.CCP_IDDOCTO COLLATE Modern_Spanish_CI_AS
		WHERE VIEJA.CCP_IDDOCTO IS NULL 
			  AND NUEVA.CCP_IDDOCTO NOT IN ('AU-AU-UNI-UN-TPP-201', 'AU-AU-UNI-UN-TPP-203');
		
		
		DELETE FROM [dbo].[CarteraProveedores] WHERE idEmpresa = @idEmpresa;
		INSERT INTO [dbo].[CarteraProveedores]
		SELECT * FROM #BI_CCP_TEMPAS TEMP
		
		
		DROP TABLE #CXC_TEMPPERSONAANT;
		DROP TABLE #BI_CARTERA_PLP;
		DROP TABLE #BI_CCP_TEMPAS;
	END TRY
	BEGIN CATCH
		DROP TABLE #CXC_TEMPPERSONAANT;
		DROP TABLE #BI_CARTERA_PLP;
		DROP TABLE #BI_CCP_TEMPAS;
		
		SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[GAHonda_CARTERAPROVEEDORES_SP]    Script Date: 02/12/2018 18:33:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ing. Alejandro Grijalva Antonio
-- Create date: 2018-02-07
-- Description:	Consulta de cartera de proveedores para la población
--				de tablas de operación plan piso 
-- =============================================
CREATE PROCEDURE [dbo].[GAHonda_CARTERAPROVEEDORES_SP]
	
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON;
		
		DECLARE @idEmpresa INT		= 3;
		DECLARE @Fecha VARCHAR(10)	= CONVERT (date, GETDATE());
		

		SELECT
			DISTINCT ltrim(rtrim(PER_PATERNO + ' ' + PER_MATERNO + ' ' + PER_NOMRAZON)) AS Nombre,
			CCP_IDPERSONA as PERSONA,
			PER_RFC,
			USUARIO = 'GMI'
		INTO #CXC_TEMPPERSONAANT
		FROM [192.168.20.92].[GAHondaConcen].[dbo].[VIS_CONCAR01], [192.168.20.92].[GAHondaConcen].[dbo].[Per_Personas] WHERE CCP_IDPERSONA = PER_IDPERSONA

		SELECT * 
		INTO #BI_CARTERA_PLP 
		FROM [192.168.20.92].[GAHondaConcen].[dbo].[vis_concar01], #CXC_TEMPPERSONAANT  
		WHERE CCP_IDPERSONA = #CXC_TEMPPERSONAANT.PERSONA
			  AND ccp_cartera IN (SELECT par_idenpara FROM [192.168.20.92].[GAHondaConcen].[dbo].[Pnc_Parametr] WHERE Par_tipopara = 'CARTERA' AND Par_status <> 'I' 
			  AND SUBSTRING(PAR_DESCRIP5,1,9) = '2100-0010')
			  

		UPDATE #BI_CARTERA_PLP 
		SET ccp_docori='S' 
		FROM #BI_CARTERA_PLP AS Externo 
		WHERE ccp_docori<>'S' 
			  AND NOT EXISTS  
				(SELECT Interno.CCP_CONSCARTERA 
				 FROM #BI_CARTERA_PLP AS Interno 
				 WHERE interno.ccp_iddocto			= externo.ccp_iddocto 
					   AND interno.ccp_idpersona	= externo.ccp_idpersona 
					   AND interno.CCP_CARTERA		= externo.CCP_CARTERA 
					   AND interno.ccp_docori		= 'S') 



		UPDATE NUEVO 
		SET ccp_docori = ''  
		FROM #BI_CARTERA_PLP AS ANTERIOR, #BI_CARTERA_PLP AS NUEVO
		WHERE ANTERIOR.CCP_IDDOCTO			= NUEVO.CCP_IDDOCTO
			  AND ANTERIOR.CCP_CARTERA		= NUEVO.CCP_CARTERA
			  AND ANTERIOR.CCP_IDPERSONA	= NUEVO.CCP_IDPERSONA
			  AND ANTERIOR.ccp_docori		= 'S'
			  AND NUEVO.ccp_docori			= 'S'
			  AND convert(varchar,ANTERIOR.vcc_anno) + substring('0000000000',1,10 - len(convert(varchar,ANTERIOR.ccp_conscartera))) 
				  + convert(varchar,ANTERIOR.ccp_conscartera) <  convert(varchar,NUEVO.vcc_anno) 
				  + substring('0000000000',1,10-len(convert(varchar,NUEVO.ccp_conscartera))) + convert(varchar,NUEVO.ccp_conscartera)


		DELETE FROM #BI_CARTERA_PLP WHERE convert(Datetime,ccp_fechaDOCTO,103) > convert(Datetime,@Fecha,103) 

		SELECT 
			idEmpresa			= @idEmpresa,
			idSucursal			= 0,
			idSucursalCompra	= 0,
			MODULO				= CARTERA.PAR_IDMODULO ,
			DES_CARTERA			= CARTERA.PAR_DESCRIP1,
			DES_TIPODOCTO		= TIMO.PAR_DESCRIP1,  
			CCP_IDDOCTO,
			CCP_NODOCTO,
			CCP_COBRADOR,
			CCP_IDPERSONA,  
			rtrim(ltrim(PER_PATERNO + ' ' + PER_MATERNO + ' ' + PER_NOMRAZON)) as Nombre,
			CCP_FECHVEN,
			CCP_FECHPAG,
			CCP_FECHPROMPAG,
			CCP_FECHREV,
			CCP_CONCEPTO,
			CCP_REFERENCIA,
			CCP_OBSPAR, 
			ltrim(rtrim(ccp_obsgen + ' ' + CASE 
												WHEN ccp_vftipodocto = 'a' OR ccp_vftipodocto = 'u' 
													THEN (	SELECT vte_serie 
															FROM [192.168.20.92].[GAHondaConcen].[dbo].[ade_vtafi]
															WHERE ccp_vftipodocto = vte_tipodocto 
																 AND ccp_vfdocto = vte_docto) 
												WHEN substring(ccp_vftipodocto,1,1) = 's' 
													THEN (	SELECT vte_referencia1 
															FROM [192.168.20.92].[GAHondaConcen].[dbo].[ade_vtafi]
															WHERE ccp_vftipodocto = vte_tipodocto 
																  AND ccp_vfdocto = vte_docto) 
												WHEN ccp_vftipodocto = '' 
													 AND ccp_vfdocto = '' 
													 AND ccp_tipodocto = 'fac' 
													 AND len(ccp_obsgen) = 17 
													 AND ccp_cargo > 0 
													THEN (	SELECT TOP 1 rtrim(ltrim(isnull(vte_docto,'') + ' ' + isnull(ccp_obsgen,''))) 
															FROM [192.168.20.92].[GAHondaConcen].[dbo].[ade_vtafi]
															WHERE vte_tipodocto IN ('a', 'u') 
																  AND vte_serie = ccp_obsgen 
																  AND vte_status = 'i') 
												ELSE '' 
											END)) as CCP_OBSGEN,  
			'IMPORTE' = CASE CARTERA.PAR_IDMODULO 
							WHEN 'CXC' THEN ccp_cargo-ccp_abono 
							ELSE ccp_abono-ccp_cargo 
						END,  
			'SALDO' = CASE CARTERA.PAR_IDMODULO 
							WHEN 'CXC' THEN ccp_cargo-ccp_abono +  (SELECT isnull(sum(CCP_CARGO-CCP_ABONO),0) 
																	FROM #BI_CARTERA_PLP AS MOVIMIENTO 
																	WHERE MOVIMIENTO.CCP_IDDOCTO = DOCUMENTO.CCP_IDDOCTO 
																		  AND MOVIMIENTO.CCP_IDPERSONA = DOCUMENTO.CCP_IDPERSONA 
																		  AND MOVIMIENTO.CCP_CARTERA = DOCUMENTO.CCP_CARTERA 
																		  AND MOVIMIENTO.CCP_DOCORI <> 'S' ) 
							ELSE ccp_abono - ccp_cargo + (	SELECT isnull(sum(CCP_ABONO-CCP_CARGO),0) 
															FROM #BI_CARTERA_PLP AS MOVIMIENTO  
															WHERE MOVIMIENTO.CCP_IDDOCTO = DOCUMENTO.CCP_IDDOCTO 
																  AND MOVIMIENTO.CCP_IDPERSONA = DOCUMENTO.CCP_IDPERSONA 
																  AND MOVIMIENTO.CCP_CARTERA = DOCUMENTO.CCP_CARTERA 
																  AND MOVIMIENTO.CCP_DOCORI <> 'S') 
						END,  
			'DIAS' = CASE WHEN CCP_FECHVEN <> '' 
							THEN Datediff(day,convert(datetime,@Fecha,103),convert(datetime,CCP_FECHVEN,103)) 
						  ELSE 0 
					 END,
			CCP_FECHADOCTO,
			CCP_REFER, 
			CVEUSU			= 'GMI', 
			HORAOPE			= CONVERT(VARCHAR(8),GETDATE(),108), 
			'DIASVENCIDOS'	= CASE WHEN isdate(CCP_FECHVEN) = 1 
								THEN DATEDIFF(DAY,CONVERT(DATETIME,CCP_FECHVEN,103),GETDATE()) 
								ELSE 0 
							  END, 
			INTERESES		= 0, 
			FECHAVENCIDO	= CCP_FECHVEN,
			CCP_GRUPO1,
			CCP_CARTERA,
			GRUPO			= CARTERA.PAR_DESCRIP2,   -- 30
			TELEFONO1		= PER_TELEFONO1,
			CCP_VFTIPODOCTO,
			CCP_VFDOCTO, 
			0 AS VEH_CATALOGO,
			0 AS VEH_ANMODELO,
			'' AS VEH_TIPOAUTO, 
			'' AS VTE_SERIE,
			0 AS VENDEDOR_NUEVO,
			CASE WHEN substring(ccp_referencia,1,8) = 'PER_FAC ' 
					THEN(	SELECT ltrim(rtrim(PER_PATERNO + ' ' +  PER_MATERNO + ' ' + PER_NOMRAZON)) 
							FROM [192.168.20.92].[GAHondaConcen].[dbo].[per_personas]
							WHERE per_idpersona=substring(ccp_referencia,9,len(ccp_referencia))) 
				ELSE '' 
			END AS NOMBRE_REFERENCIAS,
			'' AS REFERENCIA1,
			'' AS REFERENCIA2,
			'' AS REFERENCIA3,
			CCP_TIPODOCTO,
			CCP_ORIGENCON,
			0 AS VEH_NOINVENTA,	
			CCP_TIPOPOL,
			CCP_CONSPOL,
			ccp_fechope,
			'' AS VENDEDOR_CXC,
			CCP_CONTRARECIBO,
			'' AS UNC_DESCRIPCION,
			(CASE WHEN VTE_TIPODOCTO = 'A' AND ( (	SELECT COUNT(VTE_REFERENCIA1) 
													FROM [192.168.20.92].[GAHondaConcen].[dbo].[ade_vtafi] 
													INNER JOIN [192.168.20.92].[GAHondaConcen].[dbo].[UNI_HISSALUNI] ON HSU_NOPEDIDO = VTE_REFERENCIA1 
													WHERE vte_docto = CCP_IDDOCTO) > 0) 
					THEN 'DPP' 
				ELSE '' 
			END) AS DPP,
			DOCUMENTO.CCP_PORIVA,
			0 AS IVA,
			0 AS SaldoSinIva,
			0 AS SaldoMasIva,
			DOCUMENTO.PER_RFC
		INTO #BI_CCP_TEMPAS
		FROM #BI_CARTERA_PLP AS DOCUMENTO 
		LEFT OUTER JOIN [192.168.20.92].[GAHondaConcen].[dbo].[pnc_parametr] as CARTERA ON CCP_CARTERA = CARTERA.PAR_IDENPARA AND CARTERA.PAR_TIPOPARA='CARTERA'  
		INNER JOIN [192.168.20.92].[GAHondaConcen].[dbo].[PER_PERSONAS] ON CCP_IDPERSONA = PER_IDPERSONA 
		LEFT OUTER JOIN [192.168.20.92].[GAHondaConcen].[dbo].[pnc_parametr] as TIMO ON CCP_TIPODOCTO = TIMO.PAR_IDENPARA AND TIMO.PAR_TIPOPARA = 'TIMO'  
		INNER JOIN #CXC_TEMPPERSONAANT ON CCP_IDPERSONA = #CXC_TEMPPERSONAANT.PERSONA AND #CXC_TEMPPERSONAANT.USUARIO = 'GMI' 
		LEFT OUTER JOIN [192.168.20.92].[GAHondaConcen].[dbo].[ADE_VTAFI] ON VTE_DOCTO = CCP_IDDOCTO AND VTE_CONSECUTIVO = CCP_CONSPOL  
		WHERE CCP_DOCORI='S' 
			  AND ccp_cartera IN (	SELECT par_idenpara 
									FROM [192.168.20.92].[GAHondaConcen].[dbo].[Pnc_Parametr] 
									WHERE Par_tipopara = 'CARTERA' 
										  AND Par_status <> 'I' 
										  AND (SUBSTRING(PAR_DESCRIP5,1,9) = '2100-0010'));


		UPDATE #BI_CCP_TEMPAS
		SET CCP_VFDOCTO = CCP_IDDOCTO, CCP_VFTIPODOCTO = 'A'
		WHERE CVEUSU = 'GMI'
			  AND CCP_TIPODOCTO = 'RD'
			  AND charindex('-',ccp_iddocto) <> 0 AND CCP_ORIGENCON = 'PD'

		UPDATE #BI_CCP_TEMPAS 
		SET CCP_VFDOCTO = substring(CCP_IDDOCTO,1,1) + SUBSTRING('000000000',1,9-LEN(RTRIM(LTRIM(SUBSTRING(CCP_IDDOCTO,2,charindex('-',ccp_iddocto)-2))))) + 
		RTRIM(LTRIM(SUBSTRING(CCP_IDDOCTO,2,charindex('-',ccp_iddocto)-2))) 
		WHERE CVEUSU='GMI' AND CCP_TIPODOCTO = 'RD' AND 
		CCP_VFDOCTO<>'' AND CCP_VFTIPODOCTO<>'' and len(CCP_VFDOCTO)<10

		UPDATE #BI_CCP_TEMPAS 
		SET CCP_VFDOCTO=SUBSTRING(CCP_IDDOCTO,1,charindex('-',ccp_iddocto)-2) 
		WHERE CVEUSU='GMI' 
			  AND CCP_TIPODOCTO = 'RD' 
			  AND CCP_VFDOCTO <>'' 
			  AND CCP_VFTIPODOCTO <> '' 
			  AND len(CCP_VFDOCTO) > 10

		UPDATE #BI_CCP_TEMPAS 
		SET REFERENCIA1 = ISNULL(ADE_VTAFI.VTE_REFERENCIA1, ''),
			REFERENCIA2 = ISNULL(ADE_VTAFI.VTE_REFERENCIA2, ''),
			REFERENCIA3 = ISNULL(ADE_VTAFI.VTE_REFERENCIA3, ''),
			VTE_SERIE   = ISNULL(ADE_VTAFI.VTE_SERIE,'') 
		FROM #BI_CCP_TEMPAS, [192.168.20.92].[GAHondaConcen].[dbo].[ADE_VTAFI]
		WHERE CCP_VFTIPODOCTO = ADE_VTAFI.VTE_TIPODOCTO 
			  AND CCP_VFDOCTO = ADE_VTAFI.VTE_DOCTO 
			  AND CVEUSU	  = 'GMI';
			  

		UPDATE #BI_CCP_TEMPAS 
		SET IVA = ( CASE WHEN C.VTE_TIPODOCTO = 'U' 
							THEN  (((A.SALDO) * VTE_IVA)/VTE_TOTAL) 
						ELSE (A.SALDO - Round(A.SALDO /((CONVERT(DECIMAL(4,2),(CONVERT(INT,A.CCP_PORIVA)))/100) + 1), 2)) 
					END) 
		FROM #BI_CCP_TEMPAS A 
		INNER JOIN [192.168.20.92].[GAHondaConcen].[dbo].[VIS_CONCAR01] B ON B.CCP_IDDOCTO = A.CCP_IDDOCTO 
															 AND B.CCP_IDPERSONA = A.CCP_IDPERSONA 
															 AND B.CCP_CARTERA = A.CCP_CARTERA 
															 AND B.CCP_TIPODOCTO = A.CCP_TIPODOCTO 
															 AND B.CCP_ORIGENCON = A.CCP_ORIGENCON 
		LEFT OUTER JOIN [192.168.20.92].[GAHondaConcen].[dbo].[ADE_VTAFI] C ON C.VTE_IDCLIENTE = B.CCP_IDPERSONA AND C.VTE_FECHDOCTO = A.CCP_FECHADOCTO 
		WHERE CVEUSU = 'GMI' AND SALDO <> 0


		UPDATE #BI_CCP_TEMPAS 
		SET IVA = ( CASE WHEN IVA IS NULL 
							THEN (SALDO - Round(SALDO /((CONVERT(DECIMAL(4,2),(CONVERT(INT,CCP_PORIVA)))/100) + 1), 2))  
					END) 
		WHERE IVA IS NULL


		UPDATE #BI_CCP_TEMPAS 
		SET SaldoSinIva = (DOCUMENTO.SALDO - IVA)
		FROM #BI_CCP_TEMPAS DOCUMENTO 
		LEFT OUTER JOIN [192.168.20.92].[GAHondaConcen].[dbo].[ADE_VTAFI] SEMINUEVOS ON SEMINUEVOS.VTE_DOCTO = DOCUMENTO.CCP_IDDOCTO 
																		AND SEMINUEVOS.VTE_IDCLIENTE = DOCUMENTO.CCP_IDPERSONA  
		WHERE CVEUSU = 'GMI' AND DOCUMENTO.SALDO <> 0 


		UPDATE #BI_CCP_TEMPAS 
		SET SaldoMasIva = (SaldoSinIva + IVA)  
		FROM #BI_CCP_TEMPAS DOCUMENTO 
		LEFT OUTER  JOIN [192.168.20.92].[GAHondaConcen].[dbo].[ADE_VTAFI] SEMINUEVOS ON SEMINUEVOS.VTE_DOCTO = DOCUMENTO.CCP_IDDOCTO 
																		AND SEMINUEVOS.VTE_IDCLIENTE = DOCUMENTO.CCP_IDPERSONA  
		WHERE CVEUSU = 'GMI' AND DOCUMENTO.SALDO <> 0 


		UPDATE #BI_CCP_TEMPAS 
		SET CCP_VFTIPODOCTO = null, 
			CCP_VFDOCTO = null 
		WHERE CCP_VFTIPODOCTO<>'A' AND cveusu='GMI'

		UPDATE #BI_CCP_TEMPAS 
		SET veh_catalogo = SER_VEHICULO.veh_catalogo,
			veh_anmodelo = SER_VEHICULO.veh_anmodelo,
			veh_tipoauto = SER_VEHICULO.veh_tipoauto,
			vte_serie = ADE_VTAFI.vte_serie,
			VENDEDOR_NUEVO=ltrim(rtrim(per_paterno + ' ' + per_materno + ' ' + per_nomrazon)),
			VEH_NOINVENTA = SER_VEHICULO.VEH_NOINVENTA,
			UNC_DESCRIPCION = UNI_CATALOGO.UNC_DESCRIPCION 
		FROM #BI_CCP_TEMPAS,[192.168.20.92].[GAHondaConcen].[dbo].[ade_vtafi],[192.168.20.92].[GAHondaConcen].[dbo].[uni_pedido],[192.168.20.92].[GAHondaConcen].[dbo].[per_personas],[192.168.20.92].[GAHondaConcen].[dbo].[ser_vehiculo],[192.168.20.92].[GAHondaConcen].[dbo].[UNI_CATALOGO]
		WHERE ade_vtafi.vte_serie = ser_vehiculo.veh_numserie 
			  AND per_idpersona = upe_idagte 
			  AND VTE_TIPODOCTO = CCP_VFTIPODOCTO 
			  AND VTE_DOCTO = CCP_VFDOCTO 
			  AND vte_referencia1 = convert(varchar,upe_idpedi) 
			  AND cveusu = 'GMI' 
			  -- AND UNC_IDCATALOGO =* SER_VEHICULO.veh_catalogo
			  -- AND UNC_MODELO     =* SER_VEHICULO.veh_anmodelo
			  
		
		-- Depuración de registros
		DELETE FROM #BI_CCP_TEMPAS WHERE SALDO = 0;
		DELETE FROM #BI_CCP_TEMPAS WHERE DES_CARTERA NOT LIKE '%-%-0001-0001%';
		DELETE FROM #BI_CCP_TEMPAS WHERE CCP_IDDOCTO = 'AU-AU-UNI-UN-TPP-159';
		DELETE FROM #BI_CCP_TEMPAS WHERE CCP_IDDOCTO IN (
		'AU-AU-UNI-UN-TPP-124', 'AU-AU-UNI-UN-TPP-125', 'AU-AU-UNI-UN-TPP-226', 'AU-AU-UNI-UN-TPP-227', 'AU-AU-UNI-UN-TPP-228');
		
		UPDATE TEMP
		SET CCP_OBSGEN = DET.anu_numeroserie
		FROM #BI_CCP_TEMPAS TEMP
		INNER JOIN [cuentasxpagar].[dbo].[cxp_detalleautosnuevos] DET ON TEMP.CCP_IDDOCTO = DET.oce_folioorden COLLATE SQL_Latin1_General_CP1_CI_AS
		WHERE TEMP.CCP_IDDOCTO LIKE '%-%-%-%-%-%' AND CCP_OBSGEN = '';

		
		-- Set sucursal de compra de las unidades centralizadas
		UPDATE	TEMP
		SET		idSucursalCompra = oce_idsucursal
		FROM #BI_CCP_TEMPAS TEMP
		INNER JOIN [cuentasxpagar].[dbo].[cxp_detalleautosnuevos] DET ON DET.oce_folioorden = TEMP.CCP_IDDOCTO COLLATE Modern_Spanish_CI_AS
		INNER JOIN [cuentasxpagar].[dbo].[cxp_ordencompra] ORD ON DET.oce_folioorden = ORD.oce_folioorden
		WHERE TEMP.CCP_IDDOCTO LIKE '%-%-%-%-%-%' AND ORD.sod_idsituacionorden NOT IN(3,4);
		-- / Set sucursal de compra de las unidades centralizadas
		
		
		-- Set sucursal de las unidades NO centralizadas
		DECLARE @tblInventario TABLE( ID INT IDENTITY, VIN VARCHAR(20), DOCUMENTO VARCHAR(100) );
		
		INSERT INTO @tblInventario(VIN)
		SELECT CCP_IDDOCTO FROM #BI_CCP_TEMPAS TEMP	WHERE TEMP.CCP_IDDOCTO NOT LIKE '%-%-%-%-%-%';
		
		DECLARE @Current INT = 0, @Max INT = 0;
		SELECT @Current = MIN(ID), @Max = MAX(ID) FROM @tblInventario;
		
		DECLARE @vinTemp VARCHAR(20);
		DECLARE @idSucTempActual VARCHAR(5), 
				@idSucTempCompra VARCHAR(5);
		
		WHILE(@Current <= @Max )
			BEGIN
				SET @vinTemp = ( SELECT VIN FROM @tblInventario WHERE ID = @Current );
				
				EXEC @idSucTempActual = [INFOINVENTARIO_SP] @idEmpresa, @vinTemp, 1;
				EXEC @idSucTempCompra = [INFOINVENTARIO_SP] @idEmpresa, @vinTemp, 2;
				
				IF( @idSucTempActual != 0 )
					BEGIN 
						UPDATE	TEMP
						SET		idSucursal			= @idSucTempActual,
								idSucursalCompra	= @idSucTempCompra
						FROM #BI_CCP_TEMPAS TEMP
						WHERE TEMP.CCP_IDDOCTO = @vinTemp;
					END
				SET	@Current = @Current + 1;
			END 
		-- /Set sucursal de las unidades NO centralizadas
		
		
		-- Set sucursal de las unidades centralizadas
		DELETE FROM @tblInventario;
		
		INSERT INTO @tblInventario(VIN, DOCUMENTO)
		SELECT CCP_OBSGEN, CCP_IDDOCTO FROM #BI_CCP_TEMPAS TEMP WHERE TEMP.CCP_IDDOCTO LIKE '%-%-%-%-%-%';
		
		SELECT @Current = MIN(ID), @Max = MAX(ID) FROM @tblInventario;
		DECLARE @idDocto VARCHAR(100);
		WHILE(@Current <= @Max )
			BEGIN
				SELECT @vinTemp = VIN, @idDocto = DOCUMENTO FROM @tblInventario WHERE ID = @Current;
				
				EXEC @idSucTempActual = [INFOINVENTARIO_SP] @idEmpresa, @vinTemp, 1;
				
				IF( @idSucTempActual != 0 )
					BEGIN 
						UPDATE	TEMP
						SET		idSucursal = @idSucTempActual
						FROM #BI_CCP_TEMPAS TEMP
						WHERE TEMP.CCP_IDDOCTO = @idDocto;
					END
				SET	@Current = @Current + 1;
			END 
		-- /Set sucursal de las unidades centralizadas
		
		-- Set sucursal de los documentos sin estructura de IDDOCTO/VIN en el campo CCP_IDDOCTO
		DELETE FROM @tblInventario;
		
		INSERT INTO @tblInventario(VIN)
		SELECT CCP_OBSGEN
		FROM #BI_CCP_TEMPAS TEMP
		WHERE TEMP.CCP_IDDOCTO NOT LIKE '%-%-%-%-%-%' AND LEN( TEMP.CCP_IDDOCTO ) != 17 ;
		
		SELECT @Current = MIN(ID), @Max = MAX(ID) FROM @tblInventario;
		WHILE(@Current <= @Max )
			BEGIN
				SELECT @vinTemp = VIN FROM @tblInventario WHERE ID = @Current;
				
				EXEC @idSucTempActual = [INFOINVENTARIO_SP] @idEmpresa, @vinTemp, 1;
				
				IF( @idSucTempActual != 0 )
					BEGIN 
						UPDATE	TEMP
						SET		idSucursal = @idSucTempActual
						FROM #BI_CCP_TEMPAS TEMP
						WHERE TEMP.CCP_OBSGEN = @vinTemp;
					END
				SET	@Current = @Current + 1;
			END 
		-- /Set sucursal de los documentos sin estructura de IDDOCTO/VIN en el campo CCP_IDDOCTO
		
		-- ACTUALIZACIÓN DE SALDO DE DOCUMENTOS
		UPDATE
			DOCU
		SET
			DOCU.IMPORTE		= NUEVA.IMPORTE,
			DOCU.SALDO			= NUEVA.SALDO,
			DOCU.IVA			= NUEVA.IVA,
			DOCU.SaldoSinIva	= NUEVA.SaldoSinIva,
			DOCU.SaldoMasIva	= NUEVA.SaldoMasIva
		FROM #BI_CCP_TEMPAS NUEVA
		INNER JOIN [dbo].[CarteraProveedores] VIEJA ON VIEJA.CCP_IDDOCTO = NUEVA.CCP_IDDOCTO COLLATE Modern_Spanish_CI_AS
		INNER JOIN [dbo].[Documentos] DOCU ON DOCU.CCP_IDDOCTO = NUEVA.CCP_IDDOCTO COLLATE Modern_Spanish_CI_AS;
		
		
		-- DOCUMENTOS SALDADOS DESDE LA CARTERA
		UPDATE
			DOCU
		SET
			DOCU.IMPORTE		= 0,
			DOCU.SALDO			= 0,
			DOCU.IVA			= 0,
			DOCU.SaldoSinIva	= 0,
			DOCU.SaldoMasIva	= 0
		FROM #BI_CCP_TEMPAS NUEVA
		RIGHT JOIN [dbo].[CarteraProveedores] VIEJA ON VIEJA.CCP_IDDOCTO = NUEVA.CCP_IDDOCTO COLLATE Modern_Spanish_CI_AS
		INNER JOIN [dbo].[Documentos] DOCU ON DOCU.CCP_IDDOCTO = VIEJA.CCP_IDDOCTO COLLATE Modern_Spanish_CI_AS
		WHERE NUEVA.CCP_IDDOCTO IS NULL;
		
		
		-- INSERCION DE NUEVOS DOCUMENTOS A PLAN PISO
		INSERT INTO [dbo].[Documentos](
			[idEmpresa],			[MODULO],			[DES_CARTERA],			[DES_TIPODOCTO],
			[CCP_IDDOCTO],			[CCP_NODOCTO],		[CCP_COBRADOR],			[CCP_IDPERSONA],
			[Nombre],				[CCP_FECHVEN],		[CCP_FECHPAG],			[CCP_FECHPROMPAG],
			[CCP_FECHREV],			[CCP_CONCEPTO],		[CCP_REFERENCIA],		[CCP_OBSPAR],
			[CCP_OBSGEN],			[IMPORTE],			[SALDO],				[DIAS],
			[CCP_FECHADOCTO],		[CCP_REFER],		[CVEUSU],				[HORAOPE],
			[DIASVENCIDOS],			[INTERESES],		[FECHAVENCIDO],			[CCP_GRUPO1],
			[CCP_CARTERA],			[GRUPO],			[TELEFONO1],			[CCP_VFTIPODOCTO],
			[CCP_VFDOCTO],			[VEH_CATALOGO],		[VEH_ANMODELO],			[VEH_TIPOAUTO],
			[VTE_SERIE],			[VENDEDOR_NUEVO],	[NOMBRE_REFERENCIAS],	[REFERENCIA1],
			[REFERENCIA2],			[REFERENCIA3],		[CCP_TIPODOCTO],		[CCP_ORIGENCON],
			[VEH_NOINVENTA],		[ccp_tipopol],		[ccp_conspol],			[ccp_fechope],
			[VENDEDOR_CXC],			[CCP_CONTRARECIBO],	[UNC_DESCRIPCION],		[DPP],
			[CCP_PORIVA],			[IVA],				[SaldoSinIva],			[SaldoMasIva],
			[PER_RFC],				[idSucursal],		[idSucursalCompra]
		)
		SELECT 
			NUEVA.[idEmpresa],			NUEVA.[MODULO],			NUEVA.[DES_CARTERA],			NUEVA.[DES_TIPODOCTO],
			NUEVA.[CCP_IDDOCTO],		NUEVA.[CCP_NODOCTO],		NUEVA.[CCP_COBRADOR],			NUEVA.[CCP_IDPERSONA],
			NUEVA.[Nombre],				NUEVA.[CCP_FECHVEN],		NUEVA.[CCP_FECHPAG],			NUEVA.[CCP_FECHPROMPAG],
			NUEVA.[CCP_FECHREV],		NUEVA.[CCP_CONCEPTO],		NUEVA.[CCP_REFERENCIA],			NUEVA.[CCP_OBSPAR],
			NUEVA.[CCP_OBSGEN],			NUEVA.[IMPORTE],			NUEVA.[SALDO],					NUEVA.[DIAS],
			NUEVA.[CCP_FECHADOCTO],		NUEVA.[CCP_REFER],			NUEVA.[CVEUSU],					NUEVA.[HORAOPE],
			NUEVA.[DIASVENCIDOS],		NUEVA.[INTERESES],			NUEVA.[FECHAVENCIDO],			NUEVA.[CCP_GRUPO1],
			NUEVA.[CCP_CARTERA],		NUEVA.[GRUPO],				NUEVA.[TELEFONO1],				NUEVA.[CCP_VFTIPODOCTO],
			NUEVA.[CCP_VFDOCTO],		NUEVA.[VEH_CATALOGO],		NUEVA.[VEH_ANMODELO],			NUEVA.[VEH_TIPOAUTO],
			NUEVA.[VTE_SERIE],			NUEVA.[VENDEDOR_NUEVO],		NUEVA.[NOMBRE_REFERENCIAS],		NUEVA.[REFERENCIA1],
			NUEVA.[REFERENCIA2],		NUEVA.[REFERENCIA3],		NUEVA.[CCP_TIPODOCTO],			NUEVA.[CCP_ORIGENCON],
			NUEVA.[VEH_NOINVENTA],		NUEVA.[ccp_tipopol],		NUEVA.[ccp_conspol],			NUEVA.[ccp_fechope],
			NUEVA.[VENDEDOR_CXC],		NUEVA.[CCP_CONTRARECIBO],	NUEVA.[UNC_DESCRIPCION],		NUEVA.[DPP],
			NUEVA.[CCP_PORIVA],			NUEVA.[IVA],				NUEVA.[SaldoSinIva],			NUEVA.[SaldoMasIva],
			NUEVA.[PER_RFC],			NUEVA.[idSucursal],			NUEVA.[idSucursalCompra]
		FROM #BI_CCP_TEMPAS NUEVA
		LEFT JOIN [dbo].[CarteraProveedores] VIEJA ON VIEJA.CCP_IDDOCTO = NUEVA.CCP_IDDOCTO COLLATE Modern_Spanish_CI_AS
		WHERE VIEJA.CCP_IDDOCTO IS NULL 
			  AND NUEVA.CCP_IDDOCTO NOT IN ('AU-AU-UNI-UN-TPP-201', 'AU-AU-UNI-UN-TPP-203');
		
		
		DELETE FROM [dbo].[CarteraProveedores] WHERE idEmpresa = @idEmpresa;
		INSERT INTO [dbo].[CarteraProveedores]
		SELECT * FROM #BI_CCP_TEMPAS TEMP
		
		
		DROP TABLE #CXC_TEMPPERSONAANT;
		DROP TABLE #BI_CARTERA_PLP;
		DROP TABLE #BI_CCP_TEMPAS;
	END TRY
	BEGIN CATCH
		DROP TABLE #CXC_TEMPPERSONAANT;
		DROP TABLE #BI_CARTERA_PLP;
		DROP TABLE #BI_CCP_TEMPAS;
		
		SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[GAAU_CARTERAPROVEEDORES_SP]    Script Date: 02/12/2018 18:33:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ing. Alejandro Grijalva Antonio
-- Create date: 2018-02-07
-- Description:	Consulta de cartera de proveedores para la población
--				de tablas de operación plan piso 
-- =============================================
CREATE PROCEDURE [dbo].[GAAU_CARTERAPROVEEDORES_SP]
	
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON;
		
		DECLARE @idEmpresa INT		= 1;
		DECLARE @Fecha VARCHAR(10)	= CONVERT (date, GETDATE());
		

		SELECT
			DISTINCT ltrim(rtrim(PER_PATERNO + ' ' + PER_MATERNO + ' ' + PER_NOMRAZON)) AS Nombre,
			CCP_IDPERSONA as PERSONA,
			PER_RFC,
			USUARIO = 'GMI'
		INTO #CXC_TEMPPERSONAANT
		FROM [192.168.20.92].[GAAU_Concentra].[dbo].[VIS_CONCAR01], [192.168.20.92].[GAAU_Concentra].[dbo].[Per_Personas] WHERE CCP_IDPERSONA = PER_IDPERSONA

		SELECT * 
		INTO #BI_CARTERA_PLP 
		FROM [192.168.20.92].[GAAU_Concentra].[dbo].[vis_concar01], #CXC_TEMPPERSONAANT  
		WHERE CCP_IDPERSONA = #CXC_TEMPPERSONAANT.PERSONA
			  AND ccp_cartera IN (SELECT par_idenpara FROM [192.168.20.92].[GAAU_Concentra].[dbo].[Pnc_Parametr] WHERE Par_tipopara = 'CARTERA' AND Par_status <> 'I' 
			  AND SUBSTRING(PAR_DESCRIP5,1,9) = '2100-0010')
			  

		UPDATE #BI_CARTERA_PLP 
		SET ccp_docori='S' 
		FROM #BI_CARTERA_PLP AS Externo 
		WHERE ccp_docori<>'S' 
			  AND NOT EXISTS  
				(SELECT Interno.CCP_CONSCARTERA 
				 FROM #BI_CARTERA_PLP AS Interno 
				 WHERE interno.ccp_iddocto			= externo.ccp_iddocto 
					   AND interno.ccp_idpersona	= externo.ccp_idpersona 
					   AND interno.CCP_CARTERA		= externo.CCP_CARTERA 
					   AND interno.ccp_docori		= 'S') 



		UPDATE NUEVO 
		SET ccp_docori = ''  
		FROM #BI_CARTERA_PLP AS ANTERIOR, #BI_CARTERA_PLP AS NUEVO
		WHERE ANTERIOR.CCP_IDDOCTO			= NUEVO.CCP_IDDOCTO
			  AND ANTERIOR.CCP_CARTERA		= NUEVO.CCP_CARTERA
			  AND ANTERIOR.CCP_IDPERSONA	= NUEVO.CCP_IDPERSONA
			  AND ANTERIOR.ccp_docori		= 'S'
			  AND NUEVO.ccp_docori			= 'S'
			  AND convert(varchar,ANTERIOR.vcc_anno) + substring('0000000000',1,10 - len(convert(varchar,ANTERIOR.ccp_conscartera))) 
				  + convert(varchar,ANTERIOR.ccp_conscartera) <  convert(varchar,NUEVO.vcc_anno) 
				  + substring('0000000000',1,10-len(convert(varchar,NUEVO.ccp_conscartera))) + convert(varchar,NUEVO.ccp_conscartera)


		DELETE FROM #BI_CARTERA_PLP WHERE convert(Datetime,ccp_fechaDOCTO,103) > convert(Datetime,@Fecha,103) 

		SELECT 
			idEmpresa			= @idEmpresa,
			idSucursal			= 0,
			idSucursalCompra	= 0,
			MODULO				= CARTERA.PAR_IDMODULO ,
			DES_CARTERA			= CARTERA.PAR_DESCRIP1,
			DES_TIPODOCTO		= TIMO.PAR_DESCRIP1,  
			CCP_IDDOCTO,
			CCP_NODOCTO,
			CCP_COBRADOR,
			CCP_IDPERSONA,  
			rtrim(ltrim(PER_PATERNO + ' ' + PER_MATERNO + ' ' + PER_NOMRAZON)) as Nombre,
			CCP_FECHVEN,
			CCP_FECHPAG,
			CCP_FECHPROMPAG,
			CCP_FECHREV,
			CCP_CONCEPTO,
			CCP_REFERENCIA,
			CCP_OBSPAR, 
			ltrim(rtrim(ccp_obsgen + ' ' + CASE 
												WHEN ccp_vftipodocto = 'a' OR ccp_vftipodocto = 'u' 
													THEN (	SELECT vte_serie 
															FROM [192.168.20.92].[GAAU_Concentra].[dbo].[ade_vtafi]
															WHERE ccp_vftipodocto = vte_tipodocto 
																 AND ccp_vfdocto = vte_docto) 
												WHEN substring(ccp_vftipodocto,1,1) = 's' 
													THEN (	SELECT vte_referencia1 
															FROM [192.168.20.92].[GAAU_Concentra].[dbo].[ade_vtafi]
															WHERE ccp_vftipodocto = vte_tipodocto 
																  AND ccp_vfdocto = vte_docto) 
												WHEN ccp_vftipodocto = '' 
													 AND ccp_vfdocto = '' 
													 AND ccp_tipodocto = 'fac' 
													 AND len(ccp_obsgen) = 17 
													 AND ccp_cargo > 0 
													THEN (	SELECT TOP 1 rtrim(ltrim(isnull(vte_docto,'') + ' ' + isnull(ccp_obsgen,''))) 
															FROM [192.168.20.92].[GAAU_Concentra].[dbo].[ade_vtafi]
															WHERE vte_tipodocto IN ('a', 'u') 
																  AND vte_serie = ccp_obsgen 
																  AND vte_status = 'i') 
												ELSE '' 
											END)) as CCP_OBSGEN,  
			'IMPORTE' = CASE CARTERA.PAR_IDMODULO 
							WHEN 'CXC' THEN ccp_cargo-ccp_abono 
							ELSE ccp_abono-ccp_cargo 
						END,  
			'SALDO' = CASE CARTERA.PAR_IDMODULO 
							WHEN 'CXC' THEN ccp_cargo-ccp_abono +  (SELECT isnull(sum(CCP_CARGO-CCP_ABONO),0) 
																	FROM #BI_CARTERA_PLP AS MOVIMIENTO 
																	WHERE MOVIMIENTO.CCP_IDDOCTO = DOCUMENTO.CCP_IDDOCTO 
																		  AND MOVIMIENTO.CCP_IDPERSONA = DOCUMENTO.CCP_IDPERSONA 
																		  AND MOVIMIENTO.CCP_CARTERA = DOCUMENTO.CCP_CARTERA 
																		  AND MOVIMIENTO.CCP_DOCORI <> 'S' ) 
							ELSE ccp_abono - ccp_cargo + (	SELECT isnull(sum(CCP_ABONO-CCP_CARGO),0) 
															FROM #BI_CARTERA_PLP AS MOVIMIENTO  
															WHERE MOVIMIENTO.CCP_IDDOCTO = DOCUMENTO.CCP_IDDOCTO 
																  AND MOVIMIENTO.CCP_IDPERSONA = DOCUMENTO.CCP_IDPERSONA 
																  AND MOVIMIENTO.CCP_CARTERA = DOCUMENTO.CCP_CARTERA 
																  AND MOVIMIENTO.CCP_DOCORI <> 'S') 
						END,  
			'DIAS' = CASE WHEN CCP_FECHVEN <> '' 
							THEN Datediff(day,convert(datetime,@Fecha,103),convert(datetime,CCP_FECHVEN,103)) 
						  ELSE 0 
					 END,
			CCP_FECHADOCTO,
			CCP_REFER, 
			CVEUSU			= 'GMI', 
			HORAOPE			= CONVERT(VARCHAR(8),GETDATE(),108), 
			'DIASVENCIDOS'	= CASE WHEN isdate(CCP_FECHVEN) = 1 
								THEN DATEDIFF(DAY,CONVERT(DATETIME,CCP_FECHVEN,103),GETDATE()) 
								ELSE 0 
							  END, 
			INTERESES		= 0, 
			FECHAVENCIDO	= CCP_FECHVEN,
			CCP_GRUPO1,
			CCP_CARTERA,
			GRUPO			= CARTERA.PAR_DESCRIP2,   -- 30
			TELEFONO1		= PER_TELEFONO1,
			CCP_VFTIPODOCTO,
			CCP_VFDOCTO, 
			0 AS VEH_CATALOGO,
			0 AS VEH_ANMODELO,
			'' AS VEH_TIPOAUTO, 
			'' AS VTE_SERIE,
			0 AS VENDEDOR_NUEVO,
			CASE WHEN substring(ccp_referencia,1,8) = 'PER_FAC ' 
					THEN(	SELECT ltrim(rtrim(PER_PATERNO + ' ' +  PER_MATERNO + ' ' + PER_NOMRAZON)) 
							FROM [192.168.20.92].[GAAU_Concentra].[dbo].[per_personas]
							WHERE per_idpersona=substring(ccp_referencia,9,len(ccp_referencia))) 
				ELSE '' 
			END AS NOMBRE_REFERENCIAS,
			'' AS REFERENCIA1,
			'' AS REFERENCIA2,
			'' AS REFERENCIA3,
			CCP_TIPODOCTO,
			CCP_ORIGENCON,
			0 AS VEH_NOINVENTA,	
			CCP_TIPOPOL,
			CCP_CONSPOL,
			ccp_fechope,
			'' AS VENDEDOR_CXC,
			CCP_CONTRARECIBO,
			'' AS UNC_DESCRIPCION,
			(CASE WHEN VTE_TIPODOCTO = 'A' AND ( (	SELECT COUNT(VTE_REFERENCIA1) 
													FROM [192.168.20.92].[GAAU_Concentra].[dbo].[ade_vtafi] 
													INNER JOIN [192.168.20.92].[GAAU_Concentra].[dbo].[UNI_HISSALUNI] ON HSU_NOPEDIDO = VTE_REFERENCIA1 
													WHERE vte_docto = CCP_IDDOCTO) > 0) 
					THEN 'DPP' 
				ELSE '' 
			END) AS DPP,
			DOCUMENTO.CCP_PORIVA,
			0 AS IVA,
			0 AS SaldoSinIva,
			0 AS SaldoMasIva,
			DOCUMENTO.PER_RFC
		INTO #BI_CCP_TEMPAS
		FROM #BI_CARTERA_PLP AS DOCUMENTO 
		LEFT OUTER JOIN [192.168.20.92].[GAAU_Concentra].[dbo].[pnc_parametr] as CARTERA ON CCP_CARTERA = CARTERA.PAR_IDENPARA AND CARTERA.PAR_TIPOPARA='CARTERA'  
		INNER JOIN [192.168.20.92].[GAAU_Concentra].[dbo].[PER_PERSONAS] ON CCP_IDPERSONA = PER_IDPERSONA 
		LEFT OUTER JOIN [192.168.20.92].[GAAU_Concentra].[dbo].[pnc_parametr] as TIMO ON CCP_TIPODOCTO = TIMO.PAR_IDENPARA AND TIMO.PAR_TIPOPARA = 'TIMO'  
		INNER JOIN #CXC_TEMPPERSONAANT ON CCP_IDPERSONA = #CXC_TEMPPERSONAANT.PERSONA AND #CXC_TEMPPERSONAANT.USUARIO = 'GMI' 
		LEFT OUTER JOIN [192.168.20.92].[GAAU_Concentra].[dbo].[ADE_VTAFI] ON VTE_DOCTO = CCP_IDDOCTO AND VTE_CONSECUTIVO = CCP_CONSPOL  
		WHERE CCP_DOCORI='S' 
			  AND ccp_cartera IN (	SELECT par_idenpara 
									FROM [192.168.20.92].[GAAU_Concentra].[dbo].[Pnc_Parametr] 
									WHERE Par_tipopara = 'CARTERA' 
										  AND Par_status <> 'I' 
										  AND (SUBSTRING(PAR_DESCRIP5,1,9) = '2100-0010'));


		UPDATE #BI_CCP_TEMPAS
		SET CCP_VFDOCTO = CCP_IDDOCTO, CCP_VFTIPODOCTO = 'A'
		WHERE CVEUSU = 'GMI'
			  AND CCP_TIPODOCTO = 'RD'
			  AND charindex('-',ccp_iddocto) <> 0 AND CCP_ORIGENCON = 'PD'

		UPDATE #BI_CCP_TEMPAS 
		SET CCP_VFDOCTO = substring(CCP_IDDOCTO,1,1) + SUBSTRING('000000000',1,9-LEN(RTRIM(LTRIM(SUBSTRING(CCP_IDDOCTO,2,charindex('-',ccp_iddocto)-2))))) + 
		RTRIM(LTRIM(SUBSTRING(CCP_IDDOCTO,2,charindex('-',ccp_iddocto)-2))) 
		WHERE CVEUSU='GMI' AND CCP_TIPODOCTO = 'RD' AND 
		CCP_VFDOCTO<>'' AND CCP_VFTIPODOCTO<>'' and len(CCP_VFDOCTO)<10

		UPDATE #BI_CCP_TEMPAS 
		SET CCP_VFDOCTO=SUBSTRING(CCP_IDDOCTO,1,charindex('-',ccp_iddocto)-2) 
		WHERE CVEUSU='GMI' 
			  AND CCP_TIPODOCTO = 'RD' 
			  AND CCP_VFDOCTO <>'' 
			  AND CCP_VFTIPODOCTO <> '' 
			  AND len(CCP_VFDOCTO) > 10

		UPDATE #BI_CCP_TEMPAS 
		SET REFERENCIA1 = ISNULL(ADE_VTAFI.VTE_REFERENCIA1, ''),
			REFERENCIA2 = ISNULL(ADE_VTAFI.VTE_REFERENCIA2, ''),
			REFERENCIA3 = ISNULL(ADE_VTAFI.VTE_REFERENCIA3, ''),
			VTE_SERIE   = ISNULL(ADE_VTAFI.VTE_SERIE,'') 
		FROM #BI_CCP_TEMPAS, [192.168.20.92].[GAAU_Concentra].[dbo].[ADE_VTAFI]
		WHERE CCP_VFTIPODOCTO = ADE_VTAFI.VTE_TIPODOCTO 
			  AND CCP_VFDOCTO = ADE_VTAFI.VTE_DOCTO 
			  AND CVEUSU	  = 'GMI';
			  

		UPDATE #BI_CCP_TEMPAS 
		SET IVA = ( CASE WHEN C.VTE_TIPODOCTO = 'U' 
							THEN  (((A.SALDO) * VTE_IVA)/VTE_TOTAL) 
						ELSE (A.SALDO - Round(A.SALDO /((CONVERT(DECIMAL(4,2),(CONVERT(INT,A.CCP_PORIVA)))/100) + 1), 2)) 
					END) 
		FROM #BI_CCP_TEMPAS A 
		INNER JOIN [192.168.20.92].[GAAU_Concentra].[dbo].[VIS_CONCAR01] B ON B.CCP_IDDOCTO = A.CCP_IDDOCTO 
															 AND B.CCP_IDPERSONA = A.CCP_IDPERSONA 
															 AND B.CCP_CARTERA = A.CCP_CARTERA 
															 AND B.CCP_TIPODOCTO = A.CCP_TIPODOCTO 
															 AND B.CCP_ORIGENCON = A.CCP_ORIGENCON 
		LEFT OUTER JOIN [192.168.20.92].[GAAU_Concentra].[dbo].[ADE_VTAFI] C ON C.VTE_IDCLIENTE = B.CCP_IDPERSONA AND C.VTE_FECHDOCTO = A.CCP_FECHADOCTO 
		WHERE CVEUSU = 'GMI' AND SALDO <> 0


		UPDATE #BI_CCP_TEMPAS 
		SET IVA = ( CASE WHEN IVA IS NULL 
							THEN (SALDO - Round(SALDO /((CONVERT(DECIMAL(4,2),(CONVERT(INT,CCP_PORIVA)))/100) + 1), 2))  
					END) 
		WHERE IVA IS NULL


		UPDATE #BI_CCP_TEMPAS 
		SET SaldoSinIva = (DOCUMENTO.SALDO - IVA)
		FROM #BI_CCP_TEMPAS DOCUMENTO 
		LEFT OUTER JOIN [192.168.20.92].[GAAU_Concentra].[dbo].[ADE_VTAFI] SEMINUEVOS ON SEMINUEVOS.VTE_DOCTO = DOCUMENTO.CCP_IDDOCTO 
																		AND SEMINUEVOS.VTE_IDCLIENTE = DOCUMENTO.CCP_IDPERSONA  
		WHERE CVEUSU = 'GMI' AND DOCUMENTO.SALDO <> 0 


		UPDATE #BI_CCP_TEMPAS 
		SET SaldoMasIva = (SaldoSinIva + IVA)  
		FROM #BI_CCP_TEMPAS DOCUMENTO 
		LEFT OUTER  JOIN [192.168.20.92].[GAAU_Concentra].[dbo].[ADE_VTAFI] SEMINUEVOS ON SEMINUEVOS.VTE_DOCTO = DOCUMENTO.CCP_IDDOCTO 
																		AND SEMINUEVOS.VTE_IDCLIENTE = DOCUMENTO.CCP_IDPERSONA  
		WHERE CVEUSU = 'GMI' AND DOCUMENTO.SALDO <> 0 


		UPDATE #BI_CCP_TEMPAS 
		SET CCP_VFTIPODOCTO = null, 
			CCP_VFDOCTO = null 
		WHERE CCP_VFTIPODOCTO<>'A' AND cveusu='GMI'

		UPDATE #BI_CCP_TEMPAS 
		SET veh_catalogo = SER_VEHICULO.veh_catalogo,
			veh_anmodelo = SER_VEHICULO.veh_anmodelo,
			veh_tipoauto = SER_VEHICULO.veh_tipoauto,
			vte_serie = ADE_VTAFI.vte_serie,
			VENDEDOR_NUEVO=ltrim(rtrim(per_paterno + ' ' + per_materno + ' ' + per_nomrazon)),
			VEH_NOINVENTA = SER_VEHICULO.VEH_NOINVENTA,
			UNC_DESCRIPCION = UNI_CATALOGO.UNC_DESCRIPCION 
		FROM #BI_CCP_TEMPAS,[192.168.20.92].[GAAU_Concentra].[dbo].[ade_vtafi],[192.168.20.92].[GAAU_Concentra].[dbo].[uni_pedido],[192.168.20.92].[GAAU_Concentra].[dbo].[per_personas],[192.168.20.92].[GAAU_Concentra].[dbo].[ser_vehiculo],[192.168.20.92].[GAAU_Concentra].[dbo].[UNI_CATALOGO]
		WHERE ade_vtafi.vte_serie = ser_vehiculo.veh_numserie 
			  AND per_idpersona = upe_idagte 
			  AND VTE_TIPODOCTO = CCP_VFTIPODOCTO 
			  AND VTE_DOCTO = CCP_VFDOCTO 
			  AND vte_referencia1 = convert(varchar,upe_idpedi) 
			  AND cveusu = 'GMI' 
			  -- AND UNC_IDCATALOGO =* SER_VEHICULO.veh_catalogo
			  -- AND UNC_MODELO     =* SER_VEHICULO.veh_anmodelo
			  
		
		-- Depuración de registros
		DELETE FROM #BI_CCP_TEMPAS WHERE SALDO = 0;
		DELETE FROM #BI_CCP_TEMPAS WHERE DES_CARTERA NOT LIKE '%-%-0001-0001%';
		DELETE FROM #BI_CCP_TEMPAS WHERE CCP_IDDOCTO = 'AU-AU-UNI-UN-TPP-159';
		
		DELETE FROM #BI_CCP_TEMPAS WHERE CCP_IDDOCTO IN ('AU-AU-UNI-UN-TPP-125', 'AU-AU-UNI-UN-TPP-226', 'AU-AU-UNI-UN-TPP-227', 'AU-AU-UNI-UN-TPP-228');
		
		UPDATE TEMP
		SET CCP_OBSGEN = DET.anu_numeroserie
		FROM #BI_CCP_TEMPAS TEMP
		INNER JOIN [cuentasxpagar].[dbo].[cxp_detalleautosnuevos] DET ON TEMP.CCP_IDDOCTO = DET.oce_folioorden COLLATE SQL_Latin1_General_CP1_CI_AS
		WHERE TEMP.CCP_IDDOCTO LIKE '%-%-%-%-%-%' AND CCP_OBSGEN = '';

		
		-- Set sucursal de compra de las unidades centralizadas
		UPDATE	TEMP
		SET		idSucursalCompra = oce_idsucursal
		FROM #BI_CCP_TEMPAS TEMP
		INNER JOIN [cuentasxpagar].[dbo].[cxp_detalleautosnuevos] DET ON DET.oce_folioorden = TEMP.CCP_IDDOCTO COLLATE Modern_Spanish_CI_AS
		INNER JOIN [cuentasxpagar].[dbo].[cxp_ordencompra] ORD ON DET.oce_folioorden = ORD.oce_folioorden
		WHERE TEMP.CCP_IDDOCTO LIKE '%-%-%-%-%-%' AND ORD.sod_idsituacionorden NOT IN(3,4);
		-- / Set sucursal de compra de las unidades centralizadas
		
		
		-- Set sucursal de las unidades NO centralizadas
		DECLARE @tblInventario TABLE( ID INT IDENTITY, VIN VARCHAR(20), DOCUMENTO VARCHAR(100) );
		
		INSERT INTO @tblInventario(VIN)
		SELECT CCP_IDDOCTO FROM #BI_CCP_TEMPAS TEMP	WHERE TEMP.CCP_IDDOCTO NOT LIKE '%-%-%-%-%-%';
		
		DECLARE @Current INT = 0, @Max INT = 0;
		SELECT @Current = MIN(ID), @Max = MAX(ID) FROM @tblInventario;
		
		DECLARE @vinTemp VARCHAR(20);
		DECLARE @idSucTempActual VARCHAR(5), 
				@idSucTempCompra VARCHAR(5);
		
		WHILE(@Current <= @Max )
			BEGIN
				SET @vinTemp = ( SELECT VIN FROM @tblInventario WHERE ID = @Current );
				
				EXEC @idSucTempActual = [INFOINVENTARIO_SP] @idEmpresa, @vinTemp, 1;
				EXEC @idSucTempCompra = [INFOINVENTARIO_SP] @idEmpresa, @vinTemp, 2;
				
				IF( @idSucTempActual != 0 )
					BEGIN 
						UPDATE	TEMP
						SET		idSucursal			= @idSucTempActual,
								idSucursalCompra	= @idSucTempCompra
						FROM #BI_CCP_TEMPAS TEMP
						WHERE TEMP.CCP_IDDOCTO = @vinTemp;
					END
				SET	@Current = @Current + 1;
			END 
		-- /Set sucursal de las unidades NO centralizadas
		
		
		-- Set sucursal de las unidades centralizadas
		DELETE FROM @tblInventario;
		
		INSERT INTO @tblInventario(VIN, DOCUMENTO)
		SELECT CCP_OBSGEN, CCP_IDDOCTO FROM #BI_CCP_TEMPAS TEMP WHERE TEMP.CCP_IDDOCTO LIKE '%-%-%-%-%-%';
		
		SELECT @Current = MIN(ID), @Max = MAX(ID) FROM @tblInventario;
		DECLARE @idDocto VARCHAR(100);
		WHILE(@Current <= @Max )
			BEGIN
				SELECT @vinTemp = VIN, @idDocto = DOCUMENTO FROM @tblInventario WHERE ID = @Current;
				
				EXEC @idSucTempActual = [INFOINVENTARIO_SP] @idEmpresa, @vinTemp, 1;
				
				IF( @idSucTempActual != 0 )
					BEGIN 
						UPDATE	TEMP
						SET		idSucursal = @idSucTempActual
						FROM #BI_CCP_TEMPAS TEMP
						WHERE TEMP.CCP_IDDOCTO = @idDocto;
					END
				SET	@Current = @Current + 1;
			END 
		-- /Set sucursal de las unidades centralizadas
		
		-- Set sucursal de los documentos sin estructura de IDDOCTO/VIN en el campo CCP_IDDOCTO
		DELETE FROM @tblInventario;
		
		INSERT INTO @tblInventario(VIN)
		SELECT CCP_OBSGEN
		FROM #BI_CCP_TEMPAS TEMP
		WHERE TEMP.CCP_IDDOCTO NOT LIKE '%-%-%-%-%-%' AND LEN( TEMP.CCP_IDDOCTO ) != 17 ;
		
		SELECT @Current = MIN(ID), @Max = MAX(ID) FROM @tblInventario;
		WHILE(@Current <= @Max )
			BEGIN
				SELECT @vinTemp = VIN FROM @tblInventario WHERE ID = @Current;
				
				EXEC @idSucTempActual = [INFOINVENTARIO_SP] @idEmpresa, @vinTemp, 1;
				
				IF( @idSucTempActual != 0 )
					BEGIN 
						UPDATE	TEMP
						SET		idSucursal = @idSucTempActual
						FROM #BI_CCP_TEMPAS TEMP
						WHERE TEMP.CCP_OBSGEN = @vinTemp;
					END
				SET	@Current = @Current + 1;
			END 
		-- /Set sucursal de los documentos sin estructura de IDDOCTO/VIN en el campo CCP_IDDOCTO
		
		
		-- ACTUALIZACIÓN DE SALDO DE DOCUMENTOS
		UPDATE
			DOCU
		SET
			DOCU.IMPORTE		= NUEVA.IMPORTE,
			DOCU.SALDO			= NUEVA.SALDO,
			DOCU.IVA			= NUEVA.IVA,
			DOCU.SaldoSinIva	= NUEVA.SaldoSinIva,
			DOCU.SaldoMasIva	= NUEVA.SaldoMasIva
		FROM #BI_CCP_TEMPAS NUEVA
		INNER JOIN [dbo].[CarteraProveedores] VIEJA ON VIEJA.CCP_IDDOCTO = NUEVA.CCP_IDDOCTO COLLATE Modern_Spanish_CI_AS
		INNER JOIN [dbo].[Documentos] DOCU ON DOCU.CCP_IDDOCTO = NUEVA.CCP_IDDOCTO COLLATE Modern_Spanish_CI_AS;
		
		
		-- DOCUMENTOS SALDADOS DESDE LA CARTERA
		UPDATE
			DOCU
		SET
			DOCU.IMPORTE		= 0,
			DOCU.SALDO			= 0,
			DOCU.IVA			= 0,
			DOCU.SaldoSinIva	= 0,
			DOCU.SaldoMasIva	= 0
		FROM #BI_CCP_TEMPAS NUEVA
		RIGHT JOIN [dbo].[CarteraProveedores] VIEJA ON VIEJA.CCP_IDDOCTO = NUEVA.CCP_IDDOCTO COLLATE Modern_Spanish_CI_AS
		INNER JOIN [dbo].[Documentos] DOCU ON DOCU.CCP_IDDOCTO = VIEJA.CCP_IDDOCTO COLLATE Modern_Spanish_CI_AS
		WHERE NUEVA.CCP_IDDOCTO IS NULL;
		
		
		-- INSERCION DE NUEVOS DOCUMENTOS A PLAN PISO
		INSERT INTO [dbo].[Documentos](
			[idEmpresa],			[MODULO],			[DES_CARTERA],			[DES_TIPODOCTO],
			[CCP_IDDOCTO],			[CCP_NODOCTO],		[CCP_COBRADOR],			[CCP_IDPERSONA],
			[Nombre],				[CCP_FECHVEN],		[CCP_FECHPAG],			[CCP_FECHPROMPAG],
			[CCP_FECHREV],			[CCP_CONCEPTO],		[CCP_REFERENCIA],		[CCP_OBSPAR],
			[CCP_OBSGEN],			[IMPORTE],			[SALDO],				[DIAS],
			[CCP_FECHADOCTO],		[CCP_REFER],		[CVEUSU],				[HORAOPE],
			[DIASVENCIDOS],			[INTERESES],		[FECHAVENCIDO],			[CCP_GRUPO1],
			[CCP_CARTERA],			[GRUPO],			[TELEFONO1],			[CCP_VFTIPODOCTO],
			[CCP_VFDOCTO],			[VEH_CATALOGO],		[VEH_ANMODELO],			[VEH_TIPOAUTO],
			[VTE_SERIE],			[VENDEDOR_NUEVO],	[NOMBRE_REFERENCIAS],	[REFERENCIA1],
			[REFERENCIA2],			[REFERENCIA3],		[CCP_TIPODOCTO],		[CCP_ORIGENCON],
			[VEH_NOINVENTA],		[ccp_tipopol],		[ccp_conspol],			[ccp_fechope],
			[VENDEDOR_CXC],			[CCP_CONTRARECIBO],	[UNC_DESCRIPCION],		[DPP],
			[CCP_PORIVA],			[IVA],				[SaldoSinIva],			[SaldoMasIva],
			[PER_RFC],				[idSucursal],		[idSucursalCompra]
		)
		SELECT 
			NUEVA.[idEmpresa],			NUEVA.[MODULO],			NUEVA.[DES_CARTERA],			NUEVA.[DES_TIPODOCTO],
			NUEVA.[CCP_IDDOCTO],		NUEVA.[CCP_NODOCTO],		NUEVA.[CCP_COBRADOR],			NUEVA.[CCP_IDPERSONA],
			NUEVA.[Nombre],				NUEVA.[CCP_FECHVEN],		NUEVA.[CCP_FECHPAG],			NUEVA.[CCP_FECHPROMPAG],
			NUEVA.[CCP_FECHREV],		NUEVA.[CCP_CONCEPTO],		NUEVA.[CCP_REFERENCIA],			NUEVA.[CCP_OBSPAR],
			NUEVA.[CCP_OBSGEN],			NUEVA.[IMPORTE],			NUEVA.[SALDO],					NUEVA.[DIAS],
			NUEVA.[CCP_FECHADOCTO],		NUEVA.[CCP_REFER],			NUEVA.[CVEUSU],					NUEVA.[HORAOPE],
			NUEVA.[DIASVENCIDOS],		NUEVA.[INTERESES],			NUEVA.[FECHAVENCIDO],			NUEVA.[CCP_GRUPO1],
			NUEVA.[CCP_CARTERA],		NUEVA.[GRUPO],				NUEVA.[TELEFONO1],				NUEVA.[CCP_VFTIPODOCTO],
			NUEVA.[CCP_VFDOCTO],		NUEVA.[VEH_CATALOGO],		NUEVA.[VEH_ANMODELO],			NUEVA.[VEH_TIPOAUTO],
			NUEVA.[VTE_SERIE],			NUEVA.[VENDEDOR_NUEVO],		NUEVA.[NOMBRE_REFERENCIAS],		NUEVA.[REFERENCIA1],
			NUEVA.[REFERENCIA2],		NUEVA.[REFERENCIA3],		NUEVA.[CCP_TIPODOCTO],			NUEVA.[CCP_ORIGENCON],
			NUEVA.[VEH_NOINVENTA],		NUEVA.[ccp_tipopol],		NUEVA.[ccp_conspol],			NUEVA.[ccp_fechope],
			NUEVA.[VENDEDOR_CXC],		NUEVA.[CCP_CONTRARECIBO],	NUEVA.[UNC_DESCRIPCION],		NUEVA.[DPP],
			NUEVA.[CCP_PORIVA],			NUEVA.[IVA],				NUEVA.[SaldoSinIva],			NUEVA.[SaldoMasIva],
			NUEVA.[PER_RFC],			NUEVA.[idSucursal],			NUEVA.[idSucursalCompra]
		FROM #BI_CCP_TEMPAS NUEVA
		LEFT JOIN [dbo].[CarteraProveedores] VIEJA ON VIEJA.CCP_IDDOCTO = NUEVA.CCP_IDDOCTO COLLATE Modern_Spanish_CI_AS
		WHERE VIEJA.CCP_IDDOCTO IS NULL 
			  AND NUEVA.CCP_IDDOCTO NOT IN ('AU-AU-UNI-UN-TPP-201', 'AU-AU-UNI-UN-TPP-203');
		
		
		DELETE FROM [dbo].[CarteraProveedores] WHERE idEmpresa = @idEmpresa;
		INSERT INTO [dbo].[CarteraProveedores]
		SELECT * FROM #BI_CCP_TEMPAS TEMP
		
		
		DROP TABLE #CXC_TEMPPERSONAANT;
		DROP TABLE #BI_CARTERA_PLP;
		DROP TABLE #BI_CCP_TEMPAS;
	END TRY
	BEGIN CATCH
		DROP TABLE #CXC_TEMPPERSONAANT;
		DROP TABLE #BI_CARTERA_PLP;
		DROP TABLE #BI_CCP_TEMPAS;
		
		SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[GAAT_CARTERAPROVEEDORES_SP]    Script Date: 02/12/2018 18:33:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ing. Alejandro Grijalva Antonio
-- Create date: 2018-02-07
-- Description:	Consulta de cartera de proveedores para la población
--				de tablas de operación plan piso 
-- =============================================
CREATE PROCEDURE [dbo].[GAAT_CARTERAPROVEEDORES_SP]
	
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON;
		
		DECLARE @idEmpresa INT		= 2;
		DECLARE @Fecha VARCHAR(10)	= CONVERT (date, GETDATE());
		

		SELECT
			DISTINCT ltrim(rtrim(PER_PATERNO + ' ' + PER_MATERNO + ' ' + PER_NOMRAZON)) AS Nombre,
			CCP_IDPERSONA as PERSONA,
			PER_RFC,
			USUARIO = 'GMI'
		INTO #CXC_TEMPPERSONAANT
		FROM [192.168.20.92].[GAAT_Concentra].[dbo].[VIS_CONCAR01], [192.168.20.92].[GAAT_Concentra].[dbo].[Per_Personas] WHERE CCP_IDPERSONA = PER_IDPERSONA

		SELECT * 
		INTO #BI_CARTERA_PLP 
		FROM [192.168.20.92].[GAAT_Concentra].[dbo].[vis_concar01], #CXC_TEMPPERSONAANT  
		WHERE CCP_IDPERSONA = #CXC_TEMPPERSONAANT.PERSONA
			  AND ccp_cartera IN (SELECT par_idenpara FROM [192.168.20.92].[GAAT_Concentra].[dbo].[Pnc_Parametr] WHERE Par_tipopara = 'CARTERA' AND Par_status <> 'I' 
			  AND SUBSTRING(PAR_DESCRIP5,1,9) = '2100-0010')
			  

		UPDATE #BI_CARTERA_PLP 
		SET ccp_docori='S' 
		FROM #BI_CARTERA_PLP AS Externo 
		WHERE ccp_docori<>'S' 
			  AND NOT EXISTS  
				(SELECT Interno.CCP_CONSCARTERA 
				 FROM #BI_CARTERA_PLP AS Interno 
				 WHERE interno.ccp_iddocto			= externo.ccp_iddocto 
					   AND interno.ccp_idpersona	= externo.ccp_idpersona 
					   AND interno.CCP_CARTERA		= externo.CCP_CARTERA 
					   AND interno.ccp_docori		= 'S') 



		UPDATE NUEVO 
		SET ccp_docori = ''  
		FROM #BI_CARTERA_PLP AS ANTERIOR, #BI_CARTERA_PLP AS NUEVO
		WHERE ANTERIOR.CCP_IDDOCTO			= NUEVO.CCP_IDDOCTO
			  AND ANTERIOR.CCP_CARTERA		= NUEVO.CCP_CARTERA
			  AND ANTERIOR.CCP_IDPERSONA	= NUEVO.CCP_IDPERSONA
			  AND ANTERIOR.ccp_docori		= 'S'
			  AND NUEVO.ccp_docori			= 'S'
			  AND convert(varchar,ANTERIOR.vcc_anno) + substring('0000000000',1,10 - len(convert(varchar,ANTERIOR.ccp_conscartera))) 
				  + convert(varchar,ANTERIOR.ccp_conscartera) <  convert(varchar,NUEVO.vcc_anno) 
				  + substring('0000000000',1,10-len(convert(varchar,NUEVO.ccp_conscartera))) + convert(varchar,NUEVO.ccp_conscartera)


		DELETE FROM #BI_CARTERA_PLP WHERE convert(Datetime,ccp_fechaDOCTO,103) > convert(Datetime,@Fecha,103) 

		SELECT 
			idEmpresa			= @idEmpresa,
			idSucursal			= 0,
			idSucursalCompra	= 0,
			MODULO				= CARTERA.PAR_IDMODULO ,
			DES_CARTERA			= CARTERA.PAR_DESCRIP1,
			DES_TIPODOCTO		= TIMO.PAR_DESCRIP1,  
			CCP_IDDOCTO,
			CCP_NODOCTO,
			CCP_COBRADOR,
			CCP_IDPERSONA,  
			rtrim(ltrim(PER_PATERNO + ' ' + PER_MATERNO + ' ' + PER_NOMRAZON)) as Nombre,
			CCP_FECHVEN,
			CCP_FECHPAG,
			CCP_FECHPROMPAG,
			CCP_FECHREV,
			CCP_CONCEPTO,
			CCP_REFERENCIA,
			CCP_OBSPAR, 
			ltrim(rtrim(ccp_obsgen + ' ' + CASE 
												WHEN ccp_vftipodocto = 'a' OR ccp_vftipodocto = 'u' 
													THEN (	SELECT vte_serie 
															FROM [192.168.20.92].[GAAT_Concentra].[dbo].[ade_vtafi]
															WHERE ccp_vftipodocto = vte_tipodocto 
																 AND ccp_vfdocto = vte_docto) 
												WHEN substring(ccp_vftipodocto,1,1) = 's' 
													THEN (	SELECT vte_referencia1 
															FROM [192.168.20.92].[GAAT_Concentra].[dbo].[ade_vtafi]
															WHERE ccp_vftipodocto = vte_tipodocto 
																  AND ccp_vfdocto = vte_docto) 
												WHEN ccp_vftipodocto = '' 
													 AND ccp_vfdocto = '' 
													 AND ccp_tipodocto = 'fac' 
													 AND len(ccp_obsgen) = 17 
													 AND ccp_cargo > 0 
													THEN (	SELECT TOP 1 rtrim(ltrim(isnull(vte_docto,'') + ' ' + isnull(ccp_obsgen,''))) 
															FROM [192.168.20.92].[GAAT_Concentra].[dbo].[ade_vtafi]
															WHERE vte_tipodocto IN ('a', 'u') 
																  AND vte_serie = ccp_obsgen 
																  AND vte_status = 'i') 
												ELSE '' 
											END)) as CCP_OBSGEN,  
			'IMPORTE' = CASE CARTERA.PAR_IDMODULO 
							WHEN 'CXC' THEN ccp_cargo-ccp_abono 
							ELSE ccp_abono-ccp_cargo 
						END,  
			'SALDO' = CASE CARTERA.PAR_IDMODULO 
							WHEN 'CXC' THEN ccp_cargo-ccp_abono +  (SELECT isnull(sum(CCP_CARGO-CCP_ABONO),0) 
																	FROM #BI_CARTERA_PLP AS MOVIMIENTO 
																	WHERE MOVIMIENTO.CCP_IDDOCTO = DOCUMENTO.CCP_IDDOCTO 
																		  AND MOVIMIENTO.CCP_IDPERSONA = DOCUMENTO.CCP_IDPERSONA 
																		  AND MOVIMIENTO.CCP_CARTERA = DOCUMENTO.CCP_CARTERA 
																		  AND MOVIMIENTO.CCP_DOCORI <> 'S' ) 
							ELSE ccp_abono - ccp_cargo + (	SELECT isnull(sum(CCP_ABONO-CCP_CARGO),0) 
															FROM #BI_CARTERA_PLP AS MOVIMIENTO  
															WHERE MOVIMIENTO.CCP_IDDOCTO = DOCUMENTO.CCP_IDDOCTO 
																  AND MOVIMIENTO.CCP_IDPERSONA = DOCUMENTO.CCP_IDPERSONA 
																  AND MOVIMIENTO.CCP_CARTERA = DOCUMENTO.CCP_CARTERA 
																  AND MOVIMIENTO.CCP_DOCORI <> 'S') 
						END,  
			'DIAS' = CASE WHEN CCP_FECHVEN <> '' 
							THEN Datediff(day,convert(datetime,@Fecha,103),convert(datetime,CCP_FECHVEN,103)) 
						  ELSE 0 
					 END,
			CCP_FECHADOCTO,
			CCP_REFER, 
			CVEUSU			= 'GMI', 
			HORAOPE			= CONVERT(VARCHAR(8),GETDATE(),108), 
			'DIASVENCIDOS'	= CASE WHEN isdate(CCP_FECHVEN) = 1 
								THEN DATEDIFF(DAY,CONVERT(DATETIME,CCP_FECHVEN,103),GETDATE()) 
								ELSE 0 
							  END, 
			INTERESES		= 0, 
			FECHAVENCIDO	= CCP_FECHVEN,
			CCP_GRUPO1,
			CCP_CARTERA,
			GRUPO			= CARTERA.PAR_DESCRIP2,   -- 30
			TELEFONO1		= PER_TELEFONO1,
			CCP_VFTIPODOCTO,
			CCP_VFDOCTO, 
			0 AS VEH_CATALOGO,
			0 AS VEH_ANMODELO,
			'' AS VEH_TIPOAUTO, 
			'' AS VTE_SERIE,
			0 AS VENDEDOR_NUEVO,
			CASE WHEN substring(ccp_referencia,1,8) = 'PER_FAC ' 
					THEN(	SELECT ltrim(rtrim(PER_PATERNO + ' ' +  PER_MATERNO + ' ' + PER_NOMRAZON)) 
							FROM [192.168.20.92].[GAAT_Concentra].[dbo].[per_personas]
							WHERE per_idpersona=substring(ccp_referencia,9,len(ccp_referencia))) 
				ELSE '' 
			END AS NOMBRE_REFERENCIAS,
			'' AS REFERENCIA1,
			'' AS REFERENCIA2,
			'' AS REFERENCIA3,
			CCP_TIPODOCTO,
			CCP_ORIGENCON,
			0 AS VEH_NOINVENTA,	
			CCP_TIPOPOL,
			CCP_CONSPOL,
			ccp_fechope,
			'' AS VENDEDOR_CXC,
			CCP_CONTRARECIBO,
			'' AS UNC_DESCRIPCION,
			(CASE WHEN VTE_TIPODOCTO = 'A' AND ( (	SELECT COUNT(VTE_REFERENCIA1) 
													FROM [192.168.20.92].[GAAT_Concentra].[dbo].[ade_vtafi] 
													INNER JOIN [192.168.20.92].[GAAT_Concentra].[dbo].[UNI_HISSALUNI] ON HSU_NOPEDIDO = VTE_REFERENCIA1 
													WHERE vte_docto = CCP_IDDOCTO) > 0) 
					THEN 'DPP' 
				ELSE '' 
			END) AS DPP,
			DOCUMENTO.CCP_PORIVA,
			0 AS IVA,
			0 AS SaldoSinIva,
			0 AS SaldoMasIva,
			DOCUMENTO.PER_RFC
		INTO #BI_CCP_TEMPAS
		FROM #BI_CARTERA_PLP AS DOCUMENTO 
		LEFT OUTER JOIN [192.168.20.92].[GAAT_Concentra].[dbo].[pnc_parametr] as CARTERA ON CCP_CARTERA = CARTERA.PAR_IDENPARA AND CARTERA.PAR_TIPOPARA='CARTERA'  
		INNER JOIN [192.168.20.92].[GAAT_Concentra].[dbo].[PER_PERSONAS] ON CCP_IDPERSONA = PER_IDPERSONA 
		LEFT OUTER JOIN [192.168.20.92].[GAAT_Concentra].[dbo].[pnc_parametr] as TIMO ON CCP_TIPODOCTO = TIMO.PAR_IDENPARA AND TIMO.PAR_TIPOPARA = 'TIMO'  
		INNER JOIN #CXC_TEMPPERSONAANT ON CCP_IDPERSONA = #CXC_TEMPPERSONAANT.PERSONA AND #CXC_TEMPPERSONAANT.USUARIO = 'GMI' 
		LEFT OUTER JOIN [192.168.20.92].[GAAT_Concentra].[dbo].[ADE_VTAFI] ON VTE_DOCTO = CCP_IDDOCTO AND VTE_CONSECUTIVO = CCP_CONSPOL  
		WHERE CCP_DOCORI='S' 
			  AND ccp_cartera IN (	SELECT par_idenpara 
									FROM [192.168.20.92].[GAAT_Concentra].[dbo].[Pnc_Parametr] 
									WHERE Par_tipopara = 'CARTERA' 
										  AND Par_status <> 'I' 
										  AND (SUBSTRING(PAR_DESCRIP5,1,9) = '2100-0010'));


		UPDATE #BI_CCP_TEMPAS
		SET CCP_VFDOCTO = CCP_IDDOCTO, CCP_VFTIPODOCTO = 'A'
		WHERE CVEUSU = 'GMI'
			  AND CCP_TIPODOCTO = 'RD'
			  AND charindex('-',ccp_iddocto) <> 0 AND CCP_ORIGENCON = 'PD'

		UPDATE #BI_CCP_TEMPAS 
		SET CCP_VFDOCTO = substring(CCP_IDDOCTO,1,1) + SUBSTRING('000000000',1,9-LEN(RTRIM(LTRIM(SUBSTRING(CCP_IDDOCTO,2,charindex('-',ccp_iddocto)-2))))) + 
		RTRIM(LTRIM(SUBSTRING(CCP_IDDOCTO,2,charindex('-',ccp_iddocto)-2))) 
		WHERE CVEUSU='GMI' AND CCP_TIPODOCTO = 'RD' AND 
		CCP_VFDOCTO<>'' AND CCP_VFTIPODOCTO<>'' and len(CCP_VFDOCTO)<10

		UPDATE #BI_CCP_TEMPAS 
		SET CCP_VFDOCTO=SUBSTRING(CCP_IDDOCTO,1,charindex('-',ccp_iddocto)-2) 
		WHERE CVEUSU='GMI' 
			  AND CCP_TIPODOCTO = 'RD' 
			  AND CCP_VFDOCTO <>'' 
			  AND CCP_VFTIPODOCTO <> '' 
			  AND len(CCP_VFDOCTO) > 10

		UPDATE #BI_CCP_TEMPAS 
		SET REFERENCIA1 = ISNULL(ADE_VTAFI.VTE_REFERENCIA1, ''),
			REFERENCIA2 = ISNULL(ADE_VTAFI.VTE_REFERENCIA2, ''),
			REFERENCIA3 = ISNULL(ADE_VTAFI.VTE_REFERENCIA3, ''),
			VTE_SERIE   = ISNULL(ADE_VTAFI.VTE_SERIE,'') 
		FROM #BI_CCP_TEMPAS, [192.168.20.92].[GAAT_Concentra].[dbo].[ADE_VTAFI]
		WHERE CCP_VFTIPODOCTO = ADE_VTAFI.VTE_TIPODOCTO 
			  AND CCP_VFDOCTO = ADE_VTAFI.VTE_DOCTO 
			  AND CVEUSU	  = 'GMI';
			  

		UPDATE #BI_CCP_TEMPAS 
		SET IVA = ( CASE WHEN C.VTE_TIPODOCTO = 'U' 
							THEN  (((A.SALDO) * VTE_IVA)/VTE_TOTAL) 
						ELSE (A.SALDO - Round(A.SALDO /((CONVERT(DECIMAL(4,2),(CONVERT(INT,A.CCP_PORIVA)))/100) + 1), 2)) 
					END) 
		FROM #BI_CCP_TEMPAS A 
		INNER JOIN [192.168.20.92].[GAAT_Concentra].[dbo].[VIS_CONCAR01] B ON B.CCP_IDDOCTO = A.CCP_IDDOCTO 
															 AND B.CCP_IDPERSONA = A.CCP_IDPERSONA 
															 AND B.CCP_CARTERA = A.CCP_CARTERA 
															 AND B.CCP_TIPODOCTO = A.CCP_TIPODOCTO 
															 AND B.CCP_ORIGENCON = A.CCP_ORIGENCON 
		LEFT OUTER JOIN [192.168.20.92].[GAAT_Concentra].[dbo].[ADE_VTAFI] C ON C.VTE_IDCLIENTE = B.CCP_IDPERSONA AND C.VTE_FECHDOCTO = A.CCP_FECHADOCTO 
		WHERE CVEUSU = 'GMI' AND SALDO <> 0


		UPDATE #BI_CCP_TEMPAS 
		SET IVA = ( CASE WHEN IVA IS NULL 
							THEN (SALDO - Round(SALDO /((CONVERT(DECIMAL(4,2),(CONVERT(INT,CCP_PORIVA)))/100) + 1), 2))  
					END) 
		WHERE IVA IS NULL


		UPDATE #BI_CCP_TEMPAS 
		SET SaldoSinIva = (DOCUMENTO.SALDO - IVA)
		FROM #BI_CCP_TEMPAS DOCUMENTO 
		LEFT OUTER JOIN [192.168.20.92].[GAAT_Concentra].[dbo].[ADE_VTAFI] SEMINUEVOS ON SEMINUEVOS.VTE_DOCTO = DOCUMENTO.CCP_IDDOCTO 
																		AND SEMINUEVOS.VTE_IDCLIENTE = DOCUMENTO.CCP_IDPERSONA  
		WHERE CVEUSU = 'GMI' AND DOCUMENTO.SALDO <> 0 


		UPDATE #BI_CCP_TEMPAS 
		SET SaldoMasIva = (SaldoSinIva + IVA)  
		FROM #BI_CCP_TEMPAS DOCUMENTO 
		LEFT OUTER  JOIN [192.168.20.92].[GAAT_Concentra].[dbo].[ADE_VTAFI] SEMINUEVOS ON SEMINUEVOS.VTE_DOCTO = DOCUMENTO.CCP_IDDOCTO 
																		AND SEMINUEVOS.VTE_IDCLIENTE = DOCUMENTO.CCP_IDPERSONA  
		WHERE CVEUSU = 'GMI' AND DOCUMENTO.SALDO <> 0 


		UPDATE #BI_CCP_TEMPAS 
		SET CCP_VFTIPODOCTO = null, 
			CCP_VFDOCTO = null 
		WHERE CCP_VFTIPODOCTO<>'A' AND cveusu='GMI'

		UPDATE #BI_CCP_TEMPAS 
		SET veh_catalogo = SER_VEHICULO.veh_catalogo,
			veh_anmodelo = SER_VEHICULO.veh_anmodelo,
			veh_tipoauto = SER_VEHICULO.veh_tipoauto,
			vte_serie = ADE_VTAFI.vte_serie,
			VENDEDOR_NUEVO=ltrim(rtrim(per_paterno + ' ' + per_materno + ' ' + per_nomrazon)),
			VEH_NOINVENTA = SER_VEHICULO.VEH_NOINVENTA,
			UNC_DESCRIPCION = UNI_CATALOGO.UNC_DESCRIPCION 
		FROM #BI_CCP_TEMPAS,[192.168.20.92].[GAAT_Concentra].[dbo].[ade_vtafi],[192.168.20.92].[GAAT_Concentra].[dbo].[uni_pedido],[192.168.20.92].[GAAT_Concentra].[dbo].[per_personas],[192.168.20.92].[GAAT_Concentra].[dbo].[ser_vehiculo],[192.168.20.92].[GAAT_Concentra].[dbo].[UNI_CATALOGO]
		WHERE ade_vtafi.vte_serie = ser_vehiculo.veh_numserie 
			  AND per_idpersona = upe_idagte 
			  AND VTE_TIPODOCTO = CCP_VFTIPODOCTO 
			  AND VTE_DOCTO = CCP_VFDOCTO 
			  AND vte_referencia1 = convert(varchar,upe_idpedi) 
			  AND cveusu = 'GMI' 
			  -- AND UNC_IDCATALOGO =* SER_VEHICULO.veh_catalogo
			  -- AND UNC_MODELO     =* SER_VEHICULO.veh_anmodelo
			  
		
		-- Depuración de registros
		DELETE FROM #BI_CCP_TEMPAS WHERE SALDO = 0;
		DELETE FROM #BI_CCP_TEMPAS WHERE DES_CARTERA NOT LIKE '%-%-0001-0001%';
		DELETE FROM #BI_CCP_TEMPAS WHERE CCP_IDDOCTO = 'AU-AU-UNI-UN-TPP-159';
		DELETE FROM #BI_CCP_TEMPAS WHERE CCP_IDDOCTO IN (
		'AU-AU-UNI-UN-TPP-124', 'AU-AU-UNI-UN-TPP-125', 'AU-AU-UNI-UN-TPP-226', 'AU-AU-UNI-UN-TPP-227', 'AU-AU-UNI-UN-TPP-228');
		
		UPDATE TEMP
		SET CCP_OBSGEN = DET.anu_numeroserie
		FROM #BI_CCP_TEMPAS TEMP
		INNER JOIN [cuentasxpagar].[dbo].[cxp_detalleautosnuevos] DET ON TEMP.CCP_IDDOCTO = DET.oce_folioorden COLLATE SQL_Latin1_General_CP1_CI_AS
		WHERE TEMP.CCP_IDDOCTO LIKE '%-%-%-%-%-%' AND CCP_OBSGEN = '';

		
		-- Set sucursal de compra de las unidades centralizadas
		UPDATE	TEMP
		SET		idSucursalCompra = oce_idsucursal
		FROM #BI_CCP_TEMPAS TEMP
		INNER JOIN [cuentasxpagar].[dbo].[cxp_detalleautosnuevos] DET ON DET.oce_folioorden = TEMP.CCP_IDDOCTO COLLATE Modern_Spanish_CI_AS
		INNER JOIN [cuentasxpagar].[dbo].[cxp_ordencompra] ORD ON DET.oce_folioorden = ORD.oce_folioorden
		WHERE TEMP.CCP_IDDOCTO LIKE '%-%-%-%-%-%' AND ORD.sod_idsituacionorden NOT IN(3,4);
		-- / Set sucursal de compra de las unidades centralizadas
		
		
		-- Set sucursal de las unidades NO centralizadas
		DECLARE @tblInventario TABLE( ID INT IDENTITY, VIN VARCHAR(20), DOCUMENTO VARCHAR(100) );
		
		INSERT INTO @tblInventario(VIN)
		SELECT CCP_IDDOCTO FROM #BI_CCP_TEMPAS TEMP	WHERE TEMP.CCP_IDDOCTO NOT LIKE '%-%-%-%-%-%';
		
		DECLARE @Current INT = 0, @Max INT = 0;
		SELECT @Current = MIN(ID), @Max = MAX(ID) FROM @tblInventario;
		
		DECLARE @vinTemp VARCHAR(20);
		DECLARE @idSucTempActual VARCHAR(5), 
				@idSucTempCompra VARCHAR(5);
		
		WHILE(@Current <= @Max )
			BEGIN
				SET @vinTemp = ( SELECT VIN FROM @tblInventario WHERE ID = @Current );
				
				EXEC @idSucTempActual = [INFOINVENTARIO_SP] @idEmpresa, @vinTemp, 1;
				EXEC @idSucTempCompra = [INFOINVENTARIO_SP] @idEmpresa, @vinTemp, 2;
				
				IF( @idSucTempActual != 0 )
					BEGIN 
						UPDATE	TEMP
						SET		idSucursal			= @idSucTempActual,
								idSucursalCompra	= @idSucTempCompra
						FROM #BI_CCP_TEMPAS TEMP
						WHERE TEMP.CCP_IDDOCTO = @vinTemp;
					END
				SET	@Current = @Current + 1;
			END 
		-- /Set sucursal de las unidades NO centralizadas
		
		
		-- Set sucursal de las unidades centralizadas
		DELETE FROM @tblInventario;
		
		INSERT INTO @tblInventario(VIN, DOCUMENTO)
		SELECT CCP_OBSGEN, CCP_IDDOCTO FROM #BI_CCP_TEMPAS TEMP WHERE TEMP.CCP_IDDOCTO LIKE '%-%-%-%-%-%';
		
		SELECT @Current = MIN(ID), @Max = MAX(ID) FROM @tblInventario;
		DECLARE @idDocto VARCHAR(100);
		WHILE(@Current <= @Max )
			BEGIN
				SELECT @vinTemp = VIN, @idDocto = DOCUMENTO FROM @tblInventario WHERE ID = @Current;
				
				EXEC @idSucTempActual = [INFOINVENTARIO_SP] @idEmpresa, @vinTemp, 1;
				
				IF( @idSucTempActual != 0 )
					BEGIN 
						UPDATE	TEMP
						SET		idSucursal = @idSucTempActual
						FROM #BI_CCP_TEMPAS TEMP
						WHERE TEMP.CCP_IDDOCTO = @idDocto;
					END
				SET	@Current = @Current + 1;
			END 
		-- /Set sucursal de las unidades centralizadas
		
		-- Set sucursal de los documentos sin estructura de IDDOCTO/VIN en el campo CCP_IDDOCTO
		DELETE FROM @tblInventario;
		
		INSERT INTO @tblInventario(VIN)
		SELECT CCP_OBSGEN
		FROM #BI_CCP_TEMPAS TEMP
		WHERE TEMP.CCP_IDDOCTO NOT LIKE '%-%-%-%-%-%' AND LEN( TEMP.CCP_IDDOCTO ) != 17 ;
		
		SELECT @Current = MIN(ID), @Max = MAX(ID) FROM @tblInventario;
		WHILE(@Current <= @Max )
			BEGIN
				SELECT @vinTemp = VIN FROM @tblInventario WHERE ID = @Current;
				
				EXEC @idSucTempActual = [INFOINVENTARIO_SP] @idEmpresa, @vinTemp, 1;
				
				IF( @idSucTempActual != 0 )
					BEGIN 
						UPDATE	TEMP
						SET		idSucursal = @idSucTempActual
						FROM #BI_CCP_TEMPAS TEMP
						WHERE TEMP.CCP_OBSGEN = @vinTemp;
					END
				SET	@Current = @Current + 1;
			END 
		-- /Set sucursal de los documentos sin estructura de IDDOCTO/VIN en el campo CCP_IDDOCTO
		
		
		-- ACTUALIZACIÓN DE SALDO DE DOCUMENTOS
		UPDATE
			DOCU
		SET
			DOCU.IMPORTE		= NUEVA.IMPORTE,
			DOCU.SALDO			= NUEVA.SALDO,
			DOCU.IVA			= NUEVA.IVA,
			DOCU.SaldoSinIva	= NUEVA.SaldoSinIva,
			DOCU.SaldoMasIva	= NUEVA.SaldoMasIva
		FROM #BI_CCP_TEMPAS NUEVA
		INNER JOIN [dbo].[CarteraProveedores] VIEJA ON VIEJA.CCP_IDDOCTO = NUEVA.CCP_IDDOCTO COLLATE Modern_Spanish_CI_AS
		INNER JOIN [dbo].[Documentos] DOCU ON DOCU.CCP_IDDOCTO = NUEVA.CCP_IDDOCTO COLLATE Modern_Spanish_CI_AS;
		
		
		-- DOCUMENTOS SALDADOS DESDE LA CARTERA
		UPDATE
			DOCU
		SET
			DOCU.IMPORTE		= 0,
			DOCU.SALDO			= 0,
			DOCU.IVA			= 0,
			DOCU.SaldoSinIva	= 0,
			DOCU.SaldoMasIva	= 0
		FROM #BI_CCP_TEMPAS NUEVA
		RIGHT JOIN [dbo].[CarteraProveedores] VIEJA ON VIEJA.CCP_IDDOCTO = NUEVA.CCP_IDDOCTO COLLATE Modern_Spanish_CI_AS
		INNER JOIN [dbo].[Documentos] DOCU ON DOCU.CCP_IDDOCTO = VIEJA.CCP_IDDOCTO COLLATE Modern_Spanish_CI_AS
		WHERE NUEVA.CCP_IDDOCTO IS NULL;
		
		
		-- INSERCION DE NUEVOS DOCUMENTOS A PLAN PISO
		INSERT INTO [dbo].[Documentos](
			[idEmpresa],			[MODULO],			[DES_CARTERA],			[DES_TIPODOCTO],
			[CCP_IDDOCTO],			[CCP_NODOCTO],		[CCP_COBRADOR],			[CCP_IDPERSONA],
			[Nombre],				[CCP_FECHVEN],		[CCP_FECHPAG],			[CCP_FECHPROMPAG],
			[CCP_FECHREV],			[CCP_CONCEPTO],		[CCP_REFERENCIA],		[CCP_OBSPAR],
			[CCP_OBSGEN],			[IMPORTE],			[SALDO],				[DIAS],
			[CCP_FECHADOCTO],		[CCP_REFER],		[CVEUSU],				[HORAOPE],
			[DIASVENCIDOS],			[INTERESES],		[FECHAVENCIDO],			[CCP_GRUPO1],
			[CCP_CARTERA],			[GRUPO],			[TELEFONO1],			[CCP_VFTIPODOCTO],
			[CCP_VFDOCTO],			[VEH_CATALOGO],		[VEH_ANMODELO],			[VEH_TIPOAUTO],
			[VTE_SERIE],			[VENDEDOR_NUEVO],	[NOMBRE_REFERENCIAS],	[REFERENCIA1],
			[REFERENCIA2],			[REFERENCIA3],		[CCP_TIPODOCTO],		[CCP_ORIGENCON],
			[VEH_NOINVENTA],		[ccp_tipopol],		[ccp_conspol],			[ccp_fechope],
			[VENDEDOR_CXC],			[CCP_CONTRARECIBO],	[UNC_DESCRIPCION],		[DPP],
			[CCP_PORIVA],			[IVA],				[SaldoSinIva],			[SaldoMasIva],
			[PER_RFC],				[idSucursal],		[idSucursalCompra]
		)
		SELECT 
			NUEVA.[idEmpresa],			NUEVA.[MODULO],			NUEVA.[DES_CARTERA],			NUEVA.[DES_TIPODOCTO],
			NUEVA.[CCP_IDDOCTO],		NUEVA.[CCP_NODOCTO],		NUEVA.[CCP_COBRADOR],			NUEVA.[CCP_IDPERSONA],
			NUEVA.[Nombre],				NUEVA.[CCP_FECHVEN],		NUEVA.[CCP_FECHPAG],			NUEVA.[CCP_FECHPROMPAG],
			NUEVA.[CCP_FECHREV],		NUEVA.[CCP_CONCEPTO],		NUEVA.[CCP_REFERENCIA],			NUEVA.[CCP_OBSPAR],
			NUEVA.[CCP_OBSGEN],			NUEVA.[IMPORTE],			NUEVA.[SALDO],					NUEVA.[DIAS],
			NUEVA.[CCP_FECHADOCTO],		NUEVA.[CCP_REFER],			NUEVA.[CVEUSU],					NUEVA.[HORAOPE],
			NUEVA.[DIASVENCIDOS],		NUEVA.[INTERESES],			NUEVA.[FECHAVENCIDO],			NUEVA.[CCP_GRUPO1],
			NUEVA.[CCP_CARTERA],		NUEVA.[GRUPO],				NUEVA.[TELEFONO1],				NUEVA.[CCP_VFTIPODOCTO],
			NUEVA.[CCP_VFDOCTO],		NUEVA.[VEH_CATALOGO],		NUEVA.[VEH_ANMODELO],			NUEVA.[VEH_TIPOAUTO],
			NUEVA.[VTE_SERIE],			NUEVA.[VENDEDOR_NUEVO],		NUEVA.[NOMBRE_REFERENCIAS],		NUEVA.[REFERENCIA1],
			NUEVA.[REFERENCIA2],		NUEVA.[REFERENCIA3],		NUEVA.[CCP_TIPODOCTO],			NUEVA.[CCP_ORIGENCON],
			NUEVA.[VEH_NOINVENTA],		NUEVA.[ccp_tipopol],		NUEVA.[ccp_conspol],			NUEVA.[ccp_fechope],
			NUEVA.[VENDEDOR_CXC],		NUEVA.[CCP_CONTRARECIBO],	NUEVA.[UNC_DESCRIPCION],		NUEVA.[DPP],
			NUEVA.[CCP_PORIVA],			NUEVA.[IVA],				NUEVA.[SaldoSinIva],			NUEVA.[SaldoMasIva],
			NUEVA.[PER_RFC],			NUEVA.[idSucursal],			NUEVA.[idSucursalCompra]
		FROM #BI_CCP_TEMPAS NUEVA
		LEFT JOIN [dbo].[CarteraProveedores] VIEJA ON VIEJA.CCP_IDDOCTO = NUEVA.CCP_IDDOCTO COLLATE Modern_Spanish_CI_AS
		WHERE VIEJA.CCP_IDDOCTO IS NULL 
			  AND NUEVA.CCP_IDDOCTO NOT IN ('AU-AU-UNI-UN-TPP-201', 'AU-AU-UNI-UN-TPP-203');
		
		
		DELETE FROM [dbo].[CarteraProveedores] WHERE idEmpresa = @idEmpresa;
		INSERT INTO [dbo].[CarteraProveedores]
		SELECT * FROM #BI_CCP_TEMPAS TEMP
		
		
		DROP TABLE #CXC_TEMPPERSONAANT;
		DROP TABLE #BI_CARTERA_PLP;
		DROP TABLE #BI_CCP_TEMPAS;
	END TRY
	BEGIN CATCH
		DROP TABLE #CXC_TEMPPERSONAANT;
		DROP TABLE #BI_CARTERA_PLP;
		DROP TABLE #BI_CCP_TEMPAS;
		
		SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
	END CATCH
END
GO

USE [PlanPiso]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Documento__doc_e__6C190EBB]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Documentos] DROP CONSTRAINT [DF__Documento__doc_e__6C190EBB]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Documento__fec_e__6D0D32F4]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Documentos] DROP CONSTRAINT [DF__Documento__fec_e__6D0D32F4]
END

GO

USE [PlanPiso]
GO

/****** Object:  Table [dbo].[Documentos]    Script Date: 02/09/2018 11:33:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Documentos]') AND type in (N'U'))
DROP TABLE [dbo].[Documentos]
GO

USE [PlanPiso]
GO

/****** Object:  Table [dbo].[Documentos]    Script Date: 02/09/2018 11:33:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Documentos](
	[idEmpresa] [int] NULL,
	[idSucursal] [int] NULL,
	[idSucursalCompra] [int] NULL,
	[MODULO] [varchar](10) NULL,
	[DES_CARTERA] [varchar](100) NULL,
	[DES_TIPODOCTO] [varchar](60) NULL,
	[CCP_IDDOCTO] [varchar](20) NOT NULL,
	[CCP_NODOCTO] [varchar](4) NULL,
	[CCP_COBRADOR] [varchar](10) NULL,
	[CCP_IDPERSONA] [numeric](18, 0) NULL,
	[Nombre] [varchar](250) NULL,
	[CCP_FECHVEN] [varchar](10) NULL,
	[CCP_FECHPAG] [varchar](10) NULL,
	[CCP_FECHPROMPAG] [varchar](10) NULL,
	[CCP_FECHREV] [varchar](10) NULL,
	[CCP_CONCEPTO] [varchar](10) NULL,
	[CCP_REFERENCIA] [varchar](20) NULL,
	[CCP_OBSPAR] [varchar](200) NULL,
	[CCP_OBSGEN] [varchar](500) NULL,
	[IMPORTE] [decimal](18, 5) NULL,
	[SALDO] [decimal](18, 2) NULL,
	[DIAS] [numeric](18, 0) NULL,
	[CCP_FECHADOCTO] [varchar](10) NULL,
	[CCP_REFER] [varchar](20) NULL,
	[CVEUSU] [varchar](20) NULL,
	[HORAOPE] [varchar](8) NULL,
	[DIASVENCIDOS] [numeric](18, 0) NULL,
	[INTERESES] [decimal](18, 5) NULL,
	[FECHAVENCIDO] [varchar](10) NULL,
	[CCP_GRUPO1] [varchar](20) NULL,
	[CCP_CARTERA] [varchar](20) NULL,
	[GRUPO] [varchar](60) NULL,
	[TELEFONO1] [varchar](18) NULL,
	[CCP_VFTIPODOCTO] [varchar](50) NULL,
	[CCP_VFDOCTO] [varchar](50) NULL,
	[VEH_CATALOGO] [varchar](40) NULL,
	[VEH_ANMODELO] [varchar](4) NULL,
	[VEH_TIPOAUTO] [varchar](60) NULL,
	[VTE_SERIE] [varchar](17) NULL,
	[VENDEDOR_NUEVO] [varchar](240) NULL,
	[NOMBRE_REFERENCIAS] [varchar](250) NULL,
	[REFERENCIA1] [varchar](20) NULL,
	[REFERENCIA2] [varchar](20) NULL,
	[REFERENCIA3] [varchar](50) NULL,
	[CCP_TIPODOCTO] [varchar](20) NULL,
	[CCP_ORIGENCON] [varchar](10) NULL,
	[VEH_NOINVENTA] [numeric](18, 0) NULL,
	[ccp_tipopol] [varchar](10) NULL,
	[ccp_conspol] [numeric](18, 0) NULL,
	[ccp_fechope] [varchar](10) NULL,
	[VENDEDOR_CXC] [varchar](240) NULL,
	[CCP_CONTRARECIBO] [varchar](20) NULL,
	[UNC_DESCRIPCION] [varchar](60) NULL,
	[DPP] [varchar](10) NULL,
	[CCP_PORIVA] [varchar](3) NULL,
	[IVA] [decimal](18, 2) NULL,
	[SaldoSinIva] [decimal](18, 2) NULL,
	[SaldoMasIva] [decimal](18, 2) NULL,
	[PER_RFC] [varchar](13) NULL,
	[doc_estatus] [int] NULL,
	[fec_entrada] [date] NULL,
	[fec_calculo] [date] NULL,
 CONSTRAINT [PK_Documentos] PRIMARY KEY CLUSTERED 
(
	[CCP_IDDOCTO] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ__Document__036656A96A30C649] UNIQUE NONCLUSTERED 
(
	[CCP_IDDOCTO] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[Documentos] ADD  CONSTRAINT [DF__Documento__doc_e__6C190EBB]  DEFAULT ((1)) FOR [doc_estatus]
GO

ALTER TABLE [dbo].[Documentos] ADD  CONSTRAINT [DF__Documento__fec_e__6D0D32F4]  DEFAULT (getdate()) FOR [fec_entrada]
GO



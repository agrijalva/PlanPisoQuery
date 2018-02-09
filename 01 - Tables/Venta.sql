USE [PlanPiso]
GO

/****** Object:  Table [dbo].[Venta]    Script Date: 02/09/2018 13:22:12 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Venta]') AND type in (N'U'))
DROP TABLE [dbo].[Venta]
GO

USE [PlanPiso]
GO

/****** Object:  Table [dbo].[Venta]    Script Date: 02/09/2018 13:22:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Venta](
	[idVenta] [int] IDENTITY(1,1) NOT NULL,
	[idEmpresa] [int] NULL,
	[idSucursal] [int] NULL,
	[CCP_IDDOCTO] [varchar](20) NULL,
	[VTE_TIPODOCTO] [varchar](10) NULL,
	[VTE_DOCTO] [varchar](20) NULL,
	[VTE_IDCLIENTE] [numeric](18, 0) NULL,
	[VTE_FECHDOCTO] [varchar](10) NULL,
	[VTE_HORADOCTO] [varchar](5) NULL,
	[VTE_REFERENCIA1] [varchar](50) NULL,
	[VTE_FORMAPAGO] [varchar](10) NULL,
	[VTE_VTABRUT] [decimal](18, 5) NULL,
	[VTE_IVA] [decimal](18, 5) NULL,
	[VTE_TOTAL] [decimal](18, 5) NULL,
	[VTE_SERIE] [varchar](17) NULL,
	[VTE_CVEUSU] [varchar](10) NULL,
	[VTE_FECHOPE] [varchar](10) NULL,
	[VTE_IVADESG] [varchar](1) NULL,
	[VTE_IVAPLICADO] [varchar](10) NULL,
	[VTE_TIPO] [varchar](10) NULL,
	[VTE_CONSECUTIVO] [numeric](18, 0) NULL,
	[VTE_ANNO] [varchar](4) NULL,
	[VTE_MES] [numeric](18, 0) NULL,
	[fec_entrada] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[idVenta] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Venta] ADD CONSTRAINT DF_Venta DEFAULT GETDATE() FOR [fec_entrada]
GO

SET ANSI_PADDING OFF
GO



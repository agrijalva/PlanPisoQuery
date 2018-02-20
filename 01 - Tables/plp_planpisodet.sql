USE [PlanPiso]
GO

/****** Object:  Table [dbo].[plp_planpisodet]    Script Date: 02/16/2018 11:23:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[plp_planpisodet]') AND type in (N'U'))
DROP TABLE [dbo].[plp_planpisodet]
GO

USE [PlanPiso]
GO

/****** Object:  Table [dbo].[plp_planpisodet]    Script Date: 02/16/2018 11:23:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[plp_planpisodet](
	[pld_idplanpisodet] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[ple_idplanpiso] [numeric](18, 0) NOT NULL,
	[pld_consecutivo] [int] NOT NULL,
	[pld_numcuenta] [varchar](50) NOT NULL,
	[pld_concepto] [varchar](200) NOT NULL,
	[pld_cargo] [decimal](18, 7) NOT NULL,
	[pld_abono] [decimal](18, 7) NOT NULL,
	[pld_idpersona] [numeric](18, 0) NULL,
	[pld_iddocumento] [varchar](20) NULL,
	[pld_tipodocumento] [varchar](20) NULL,
	[pld_vin] [varchar](17) NULL,
	[pld_fechavencimiento] [datetime] NULL,
	[pld_porcentajeiva] [int] NOT NULL,
	[pld_afecta] [varchar](1) NULL,
	[idProvision] [int] NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



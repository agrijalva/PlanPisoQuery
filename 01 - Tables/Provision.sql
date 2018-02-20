USE [PlanPiso]
GO

/****** Object:  Table [dbo].[Provision]    Script Date: 02/16/2018 13:36:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Provision]') AND type in (N'U'))
DROP TABLE [dbo].[Provision]
GO

USE [PlanPiso]
GO

/****** Object:  Table [dbo].[Provision]    Script Date: 02/16/2018 13:36:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Provision](
	[idProvision] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[idEmpresa] [int] NULL,
	[idSucursal] [int] NULL,
	[CCP_DOCUMENTO] [varchar](20) NULL,
	[consecutivo] [numeric](18, 0) NULL,
	[saldoDocumento] [numeric](18, 4) NULL,
	[interesCalculado] [numeric](18, 4) NULL,
	[interesAplicar] [numeric](18, 4) NULL,
	[fechaEntrada] [datetime] NULL,
	[estatus] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[idProvision] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



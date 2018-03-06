USE [PlanPiso]
GO

/****** Object:  Table [dbo].[conciliacionDetalle]    Script Date: 03/05/2018 11:59:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[conciliacionDetalle]') AND type in (N'U'))
DROP TABLE [dbo].[conciliacionDetalle]
GO

USE [PlanPiso]
GO

/****** Object:  Table [dbo].[conciliacionDetalle]    Script Date: 03/05/2018 11:59:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[conciliacionDetalle](
	[idConciliacionDetalle] [int] IDENTITY(1,1) NOT NULL,
	[idConciliacion] [int] NULL,
	[CCP_IDDOCTO] [varchar](20) NULL,
	[VIN] [varchar](17) NULL,
	[interesGrupoAndrade] [numeric](18, 2) NULL,
	[interesFinanciera] [numeric](18, 2) NULL,
	[interesAjuste] [numeric](18, 2) NULL,
	[situacion] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[idConciliacionDetalle] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



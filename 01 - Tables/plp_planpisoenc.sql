USE [PlanPiso]
GO

/****** Object:  Table [dbo].[plp_planpisoenc]    Script Date: 02/16/2018 11:19:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[plp_planpisoenc]') AND type in (N'U'))
DROP TABLE [dbo].[plp_planpisoenc]
GO

USE [PlanPiso]
GO

/****** Object:  Table [dbo].[plp_planpisoenc]    Script Date: 02/16/2018 11:19:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[plp_planpisoenc](
	[ple_idplanpiso] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[pro_idtipoproceso] [int] NOT NULL,
	[ple_idempresa] [int] NOT NULL,
	[ple_idsucursal] [int] NOT NULL,
	[ple_tipopoliza] [varchar](20) NOT NULL,
	[ple_fechapoliza] [datetime] NOT NULL,
	[ple_concepto] [varchar](200) NOT NULL,
	[ple_fechageneracion] [datetime] NULL,
	[ple_conspol] [int] NULL,
	[ple_mes] [int] NULL,
	[ple_año] [varchar](4) NULL,
	[ple_estatus] [int] NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



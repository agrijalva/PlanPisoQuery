USE [PlanPiso]
GO

/****** Object:  Table [dbo].[TmpExcelData]    Script Date: 02/21/2018 11:15:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TmpExcelData]') AND type in (N'U'))
DROP TABLE [dbo].[TmpExcelData]
GO

USE [PlanPiso]
GO

/****** Object:  Table [dbo].[TmpExcelData]    Script Date: 02/21/2018 11:15:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TmpExcelData](
	[numeroSerie] [varchar](25) NULL,
	[valor] [numeric](18, 4) NULL,
	[interes] [numeric](18, 4) NULL,
	[consecutivo] [int] NOT NULL,
	[fecha] [datetime] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



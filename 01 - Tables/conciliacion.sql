USE [PlanPiso]
GO

/****** Object:  Table [dbo].[conciliacion]    Script Date: 03/05/2018 11:56:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[conciliacion]') AND type in (N'U'))
DROP TABLE [dbo].[conciliacion]
GO

USE [PlanPiso]
GO

/****** Object:  Table [dbo].[conciliacion]    Script Date: 03/05/2018 11:56:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[conciliacion](
	[idConciliacion] [int] IDENTITY(1,1) NOT NULL,
	[idEmpresa] [int] NULL,
	[idFinanciera] [int] NULL,
	[periodo] [int] NULL,
	[anio] [numeric](4,0) NULL,
	[idUsuario] [int] NULL,
	[fechaCreacion] [datetime] NULL,
	[estatus] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[idConciliacion] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO



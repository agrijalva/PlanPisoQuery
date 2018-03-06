USE [PlanPiso]
GO

/****** Object:  Table [dbo].[autorizaConciliacion]    Script Date: 03/06/2018 10:23:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[autorizaConciliacion]') AND type in (N'U'))
DROP TABLE [dbo].[autorizaConciliacion]
GO

USE [PlanPiso]
GO

/****** Object:  Table [dbo].[autorizaConciliacion]    Script Date: 03/06/2018 10:23:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[autorizaConciliacion](
	[idAutorizaConciliacion] [int] IDENTITY(1,1) NOT NULL,
	[consecutivo] [int] NULL,
	[estatus] [int] NULL,
	[idUsuarioSolicita] [int] NULL,
	[fechaSolicitud] [datetime] NULL,
	[idUsuarioAutoriza] [int] NULL,
	[fechaAutoriza] [datetime] NULL,
	[token] [varchar](32) NULL,
PRIMARY KEY CLUSTERED 
(
	[idAutorizaConciliacion] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



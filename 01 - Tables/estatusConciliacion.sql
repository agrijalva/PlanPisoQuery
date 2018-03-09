USE [PlanPiso]
GO

/****** Object:  Table [dbo].[estatusConciliacion]    Script Date: 03/07/2018 11:10:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[estatusNotificacion]') AND type in (N'U'))
DROP TABLE [dbo].[estatusNotificacion]
GO

USE [PlanPiso]
GO

/****** Object:  Table [dbo].[estatusNotificacion]    Script Date: 03/07/2018 11:10:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO


CREATE TABLE [dbo].[estatusNotificacion](
	[idEstatusNotificacion] [int] NULL,
	[descripcion] [varchar](250) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


INSERT INTO [dbo].[estatusNotificacion] VALUES ( 0, 'Rechazado' )
INSERT INTO [dbo].[estatusNotificacion] VALUES ( 1, 'En Espera' )
INSERT INTO [dbo].[estatusNotificacion] VALUES ( 2, 'Autorizado' )


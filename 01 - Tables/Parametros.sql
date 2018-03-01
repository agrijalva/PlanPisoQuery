USE [PlanPiso]
GO

/****** Object:  Table [dbo].[Parametros]    Script Date: 02/21/2018 15:04:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Parametros]') AND type in (N'U'))
DROP TABLE [dbo].[Parametros]
GO

USE [PlanPiso]
GO

/****** Object:  Table [dbo].[Parametros]    Script Date: 02/21/2018 15:04:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Parametros](
	[idParametro] [int] IDENTITY(1,1) NOT NULL,
	[par_grupo] [varchar](5) NULL,
	[par_identificador] [varchar](25) NULL,
	[par_descripcion] [varchar](500) NULL,
	[par_StrVal] [varchar](250) NULL,
	[par_IntVal] [numeric](18,0) NULL,
	[par_FloVal] [numeric](18,4) NULL,
	[par_DatVal] [datetime] NULL,
	[idEmpresa] [int] NULL,
	[idSucursal] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[idParametro] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


INSERT INTO [dbo].[Parametros]( [par_grupo], [par_identificador], [par_descripcion], [par_DatVal], [idEmpresa], [idSucursal] )
VALUES( 'CARTE', 'GAAU_FCarga','Fecha base para busqueda de Eventos en BPRO Suzuki', '20180101', 1, 0 );

INSERT INTO [dbo].[Parametros]( [par_grupo], [par_identificador], [par_descripcion], [par_DatVal], [idEmpresa], [idSucursal] )
VALUES( 'CARTE', 'GAAT_FCarga','Fecha base para busqueda de Eventos en BPRO Peugeot', '20180101', 2, 0 );

INSERT INTO [dbo].[Parametros]( [par_grupo], [par_identificador], [par_descripcion], [par_DatVal], [idEmpresa], [idSucursal] )
VALUES( 'CARTE', 'GAHonda_FCarga','Fecha base para busqueda de Eventos en BPRO Honda', '20180101', 3, 0 );

INSERT INTO [dbo].[Parametros]( [par_grupo], [par_identificador], [par_descripcion], [par_DatVal], [idEmpresa], [idSucursal] )
VALUES( 'CARTE', 'GAZM_FCarga','Fecha base para busqueda de Eventos en BPRO Nissan', '20180101', 4, 0 );

INSERT INTO [dbo].[Parametros]( [par_grupo], [par_identificador], [par_descripcion], [par_IntVal], [idEmpresa], [idSucursal] )
VALUES( 'NOTIF', 'ExpirationDay','Días para determinar notificaciones de vigencias', 10, 0, 0 );
USE [PlanPiso]
GO

/****** Object:  Table [dbo].[Traspaso]    Script Date: 02/09/2018 11:35:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Traspaso]') AND type in (N'U'))
DROP TABLE [dbo].[Traspaso]
GO

USE [PlanPiso]
GO

/****** Object:  Table [dbo].[Traspaso]    Script Date: 02/09/2018 11:35:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Traspaso](
	[idTraspaso] [int] IDENTITY(1,1) NOT NULL,
	[idEmpresa] [int] NULL,
	[TRA_NUMTRASPASO] [int] NULL,
	[CCP_IDDOCTO] [varchar](20) NULL,
	[VIN] [varchar](17) NULL,
	[idSucursalEnvia] [int] NULL,
	[idSucursalRecibe] [int] NULL,
	[fechaOperacion] [date] NULL,
	[sitacion] [varchar](10) NULL,
	[fec_entrada] [date] NULL,
 CONSTRAINT [PK__Traspaso__E4A5F5AA2A164134] PRIMARY KEY CLUSTERED 
(
	[idTraspaso] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Traspaso] ADD CONSTRAINT DF_Traspaso DEFAULT GETDATE() FOR [fec_entrada]
GO


SET ANSI_PADDING OFF
GO



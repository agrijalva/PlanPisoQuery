USE [PlanPiso]
GO
/****** Object:  Table [dbo].[LoteInteres]    Script Date: 02/12/2018 18:29:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LoteInteres](
	[loteID] [bigint] IDENTITY(1,1) NOT NULL,
	[esquemaID] [int] NULL,
	[unidadID] [bigint] NOT NULL,
	[interesCalculado] [decimal](18, 4) NOT NULL,
	[interesUsuario] [decimal](18, 4) NOT NULL,
	[pagoPorReduccion] [decimal](18, 4) NULL,
	[estatusCID] [int] NULL,
	[plazo] [int] NULL,
	[fecha_creacion] [datetime] NULL,
 CONSTRAINT [PK_LoteDEtalle] PRIMARY KEY CLUSTERED 
(
	[loteID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Financiera]    Script Date: 02/12/2018 18:29:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Financiera](
	[consecutivo] [int] IDENTITY(1,1) NOT NULL,
	[empresaID] [int] NOT NULL,
	[nombre] [varchar](100) NULL,
	[financieraID] [int] NULL,
	[tipoCID] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Esquema]    Script Date: 02/12/2018 18:29:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Esquema](
	[esquemaID] [int] IDENTITY(1,1) NOT NULL,
	[diasGracia] [int] NOT NULL,
	[plazo] [int] NULL,
	[financieraID] [int] NULL,
	[nombre] [varchar](50) NULL,
	[descripcion] [varchar](250) NULL,
	[interesMoratorio] [decimal](18, 4) NULL,
	[estatusCID] [bit] NULL,
	[creadoPor] [int] NULL,
	[tasaInteres] [decimal](18, 0) NULL,
	[fechaInicio] [date] NULL,
	[fechaFin] [date] NULL,
	[porcentajePenetracion] [decimal](18, 0) NULL,
	[tipoTiieCID] [int] NULL,
	[tiie] [decimal](18, 0) NULL,
	[fechaCreacion] [smalldatetime] NULL,
	[modificadoPor] [int] NULL,
	[fechaModificacion] [smalldatetime] NULL,
 CONSTRAINT [PK_Esquema] PRIMARY KEY CLUSTERED 
(
	[esquemaID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Documentos]    Script Date: 02/12/2018 18:29:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Documentos](
	[idEmpresa] [int] NULL,
	[idSucursal] [int] NULL,
	[idSucursalCompra] [int] NULL,
	[MODULO] [varchar](10) NULL,
	[DES_CARTERA] [varchar](100) NULL,
	[DES_TIPODOCTO] [varchar](60) NULL,
	[CCP_IDDOCTO] [varchar](20) NOT NULL,
	[CCP_NODOCTO] [varchar](4) NULL,
	[CCP_COBRADOR] [varchar](10) NULL,
	[CCP_IDPERSONA] [numeric](18, 0) NULL,
	[Nombre] [varchar](250) NULL,
	[CCP_FECHVEN] [varchar](10) NULL,
	[CCP_FECHPAG] [varchar](10) NULL,
	[CCP_FECHPROMPAG] [varchar](10) NULL,
	[CCP_FECHREV] [varchar](10) NULL,
	[CCP_CONCEPTO] [varchar](10) NULL,
	[CCP_REFERENCIA] [varchar](20) NULL,
	[CCP_OBSPAR] [varchar](200) NULL,
	[CCP_OBSGEN] [varchar](500) NULL,
	[IMPORTE] [decimal](18, 5) NULL,
	[SALDO] [decimal](18, 2) NULL,
	[DIAS] [numeric](18, 0) NULL,
	[CCP_FECHADOCTO] [varchar](10) NULL,
	[CCP_REFER] [varchar](20) NULL,
	[CVEUSU] [varchar](20) NULL,
	[HORAOPE] [varchar](8) NULL,
	[DIASVENCIDOS] [numeric](18, 0) NULL,
	[INTERESES] [decimal](18, 5) NULL,
	[FECHAVENCIDO] [varchar](10) NULL,
	[CCP_GRUPO1] [varchar](20) NULL,
	[CCP_CARTERA] [varchar](20) NULL,
	[GRUPO] [varchar](60) NULL,
	[TELEFONO1] [varchar](18) NULL,
	[CCP_VFTIPODOCTO] [varchar](50) NULL,
	[CCP_VFDOCTO] [varchar](50) NULL,
	[VEH_CATALOGO] [varchar](40) NULL,
	[VEH_ANMODELO] [varchar](4) NULL,
	[VEH_TIPOAUTO] [varchar](60) NULL,
	[VTE_SERIE] [varchar](17) NULL,
	[VENDEDOR_NUEVO] [varchar](240) NULL,
	[NOMBRE_REFERENCIAS] [varchar](250) NULL,
	[REFERENCIA1] [varchar](20) NULL,
	[REFERENCIA2] [varchar](20) NULL,
	[REFERENCIA3] [varchar](50) NULL,
	[CCP_TIPODOCTO] [varchar](20) NULL,
	[CCP_ORIGENCON] [varchar](10) NULL,
	[VEH_NOINVENTA] [numeric](18, 0) NULL,
	[ccp_tipopol] [varchar](10) NULL,
	[ccp_conspol] [numeric](18, 0) NULL,
	[ccp_fechope] [varchar](10) NULL,
	[VENDEDOR_CXC] [varchar](240) NULL,
	[CCP_CONTRARECIBO] [varchar](20) NULL,
	[UNC_DESCRIPCION] [varchar](60) NULL,
	[DPP] [varchar](10) NULL,
	[CCP_PORIVA] [varchar](3) NULL,
	[IVA] [decimal](18, 2) NULL,
	[SaldoSinIva] [decimal](18, 2) NULL,
	[SaldoMasIva] [decimal](18, 2) NULL,
	[PER_RFC] [varchar](13) NULL,
	[doc_estatus] [int] NULL,
	[fec_entrada] [date] NULL,
	[fec_calculo] [date] NULL,
 CONSTRAINT [PK_Documentos] PRIMARY KEY CLUSTERED 
(
	[CCP_IDDOCTO] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ__Document__036656A96A30C649] UNIQUE NONCLUSTERED 
(
	[CCP_IDDOCTO] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CarteraProveedores]    Script Date: 02/12/2018 18:29:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CarteraProveedores](
	[idEmpresa] [int] NULL,
	[idSucursal] [int] NULL,
	[idSucursalCompra] [int] NULL,
	[MODULO] [varchar](10) NULL,
	[DES_CARTERA] [varchar](100) NULL,
	[DES_TIPODOCTO] [varchar](60) NULL,
	[CCP_IDDOCTO] [varchar](20) NULL,
	[CCP_NODOCTO] [varchar](4) NULL,
	[CCP_COBRADOR] [varchar](10) NULL,
	[CCP_IDPERSONA] [numeric](18, 0) NULL,
	[Nombre] [varchar](250) NULL,
	[CCP_FECHVEN] [varchar](10) NULL,
	[CCP_FECHPAG] [varchar](10) NULL,
	[CCP_FECHPROMPAG] [varchar](10) NULL,
	[CCP_FECHREV] [varchar](10) NULL,
	[CCP_CONCEPTO] [varchar](10) NULL,
	[CCP_REFERENCIA] [varchar](20) NULL,
	[CCP_OBSPAR] [varchar](200) NULL,
	[CCP_OBSGEN] [varchar](500) NULL,
	[IMPORTE] [decimal](18, 5) NULL,
	[SALDO] [decimal](18, 2) NULL,
	[DIAS] [numeric](18, 0) NULL,
	[CCP_FECHADOCTO] [varchar](10) NULL,
	[CCP_REFER] [varchar](20) NULL,
	[CVEUSU] [varchar](20) NULL,
	[HORAOPE] [varchar](8) NULL,
	[DIASVENCIDOS] [numeric](18, 0) NULL,
	[INTERESES] [decimal](18, 5) NULL,
	[FECHAVENCIDO] [varchar](10) NULL,
	[CCP_GRUPO1] [varchar](20) NULL,
	[CCP_CARTERA] [varchar](20) NULL,
	[GRUPO] [varchar](60) NULL,
	[TELEFONO1] [varchar](18) NULL,
	[CCP_VFTIPODOCTO] [varchar](50) NULL,
	[CCP_VFDOCTO] [varchar](50) NULL,
	[VEH_CATALOGO] [varchar](40) NULL,
	[VEH_ANMODELO] [varchar](4) NULL,
	[VEH_TIPOAUTO] [varchar](60) NULL,
	[VTE_SERIE] [varchar](17) NULL,
	[VENDEDOR_NUEVO] [varchar](240) NULL,
	[NOMBRE_REFERENCIAS] [varchar](250) NULL,
	[REFERENCIA1] [varchar](20) NULL,
	[REFERENCIA2] [varchar](20) NULL,
	[REFERENCIA3] [varchar](50) NULL,
	[CCP_TIPODOCTO] [varchar](20) NULL,
	[CCP_ORIGENCON] [varchar](10) NULL,
	[VEH_NOINVENTA] [numeric](18, 0) NULL,
	[ccp_tipopol] [varchar](10) NULL,
	[ccp_conspol] [numeric](18, 0) NULL,
	[ccp_fechope] [varchar](10) NULL,
	[VENDEDOR_CXC] [varchar](240) NULL,
	[CCP_CONTRARECIBO] [varchar](20) NULL,
	[UNC_DESCRIPCION] [varchar](60) NULL,
	[DPP] [varchar](10) NULL,
	[CCP_PORIVA] [varchar](3) NULL,
	[IVA] [decimal](18, 2) NULL,
	[SaldoSinIva] [decimal](18, 2) NULL,
	[SaldoMasIva] [decimal](18, 2) NULL,
	[PER_RFC] [varchar](13) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AppCatalogoLista]    Script Date: 02/12/2018 18:29:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AppCatalogoLista](
	[appCatalogoID] [int] NOT NULL,
	[CID] [int] NOT NULL,
	[valor] [varchar](100) NULL,
	[texto] [varchar](100) NULL,
	[visible] [bit] NULL,
 CONSTRAINT [PK_catalogoAppLista] PRIMARY KEY CLUSTERED 
(
	[appCatalogoID] ASC,
	[CID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AppCatalogo]    Script Date: 02/12/2018 18:29:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AppCatalogo](
	[appCatalogoID] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](100) NOT NULL,
	[tabla] [varchar](100) NOT NULL,
	[campo] [varchar](100) NOT NULL,
	[estaActivo] [bit] NOT NULL,
 CONSTRAINT [PK_AppCatalogo] PRIMARY KEY CLUSTERED 
(
	[appCatalogoID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Venta]    Script Date: 02/12/2018 18:29:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Venta](
	[idVenta] [int] IDENTITY(1,1) NOT NULL,
	[idEmpresa] [int] NULL,
	[idSucursal] [int] NULL,
	[CCP_IDDOCTO] [varchar](20) NULL,
	[VTE_TIPODOCTO] [varchar](10) NULL,
	[VTE_DOCTO] [varchar](20) NULL,
	[VTE_IDCLIENTE] [numeric](18, 0) NULL,
	[VTE_FECHDOCTO] [varchar](10) NULL,
	[VTE_HORADOCTO] [varchar](5) NULL,
	[VTE_REFERENCIA1] [varchar](50) NULL,
	[VTE_FORMAPAGO] [varchar](10) NULL,
	[VTE_VTABRUT] [decimal](18, 5) NULL,
	[VTE_IVA] [decimal](18, 5) NULL,
	[VTE_TOTAL] [decimal](18, 5) NULL,
	[VTE_SERIE] [varchar](17) NULL,
	[VTE_CVEUSU] [varchar](10) NULL,
	[VTE_FECHOPE] [varchar](10) NULL,
	[VTE_IVADESG] [varchar](1) NULL,
	[VTE_IVAPLICADO] [varchar](10) NULL,
	[VTE_TIPO] [varchar](10) NULL,
	[VTE_CONSECUTIVO] [numeric](18, 0) NULL,
	[VTE_ANNO] [varchar](4) NULL,
	[VTE_MES] [numeric](18, 0) NULL,
	[fec_entrada] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[idVenta] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Usuario]    Script Date: 02/12/2018 18:29:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Usuario](
	[idUsuario] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[email] [nvarchar](50) NOT NULL,
	[usuario] [nvarchar](50) NOT NULL,
	[password] [nvarchar](50) NOT NULL,
	[nombre] [nvarchar](50) NULL,
 CONSTRAINT [PK_Usuario] PRIMARY KEY CLUSTERED 
(
	[idUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UnidadTemp]    Script Date: 02/12/2018 18:29:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UnidadTemp](
	[unidadID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[vehNumserie] [nvarchar](50) NOT NULL,
	[tipoUnidad] [varchar](6) NOT NULL,
	[colorInterior] [varchar](30) NULL,
	[colorExterior] [varchar](30) NULL,
	[modelo] [varchar](4) NULL,
	[descModelo] [varchar](60) NULL,
	[marca] [varchar](100) NULL,
	[segmento] [varchar](100) NULL,
	[subtipoUnidad] [varchar](100) NULL,
	[uncIdcatalo] [varchar](20) NOT NULL,
	[carLine] [varchar](100) NULL,
	[puertas] [varchar](100) NULL,
	[cilindros] [varchar](100) NULL,
	[uncPotencia] [varchar](15) NULL,
	[combustible] [varchar](100) NULL,
	[capacidad] [varchar](15) NULL,
	[transmision] [varchar](100) NULL,
	[ubicacion] [varchar](100) NULL,
	[tipomotor] [varchar](10) NULL,
	[noMotor] [varchar](25) NULL,
	[procedencia] [varchar](10) NULL,
	[vehNofactplan] [varchar](20) NULL,
	[vehFecremision] [varchar](10) NULL,
	[numPedimento] [varchar](20) NULL,
	[fechaPedimento] [varchar](10) NULL,
	[tipoCompra] [varchar](100) NULL,
	[vehFecrecibo] [varchar](10) NULL,
	[diasInventa] [int] NULL,
	[precioLista] [decimal](18, 5) NULL,
	[valorInventario] [decimal](38, 5) NULL,
	[situacion] [varchar](100) NULL,
	[consCartera] [varchar](50) NULL,
	[idDocto] [varchar](50) NULL,
	[updateBy] [int] NULL,
	[lastUpdate] [smalldatetime] NULL,
	[empresaID] [int] NULL,
	[sucursalID] [int] NULL,
	[esquemaID] [int] NULL,
	[estatusCID] [int] NULL,
	[saldo] [decimal](18, 4) NULL,
	[fechaEfectiva] [date] NULL,
	[fechaCalculo] [date] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UnidadInteres]    Script Date: 02/12/2018 18:29:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UnidadInteres](
	[unidadID] [numeric](18, 0) NOT NULL,
	[diasInteres] [int] NOT NULL,
	[diasRestantes] [int] NOT NULL,
	[InteresCortePagado] [decimal](18, 4) NOT NULL,
	[InteresMesActual] [decimal](18, 4) NOT NULL,
	[InteresAcumuladoFinanciera] [decimal](18, 4) NOT NULL,
	[InteresTotal] [decimal](18, 4) NOT NULL,
 CONSTRAINT [PK_UnidadInteres] PRIMARY KEY CLUSTERED 
(
	[unidadID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Unidad]    Script Date: 02/12/2018 18:29:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Unidad](
	[unidadID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[vehNumserie] [nvarchar](50) NOT NULL,
	[tipoUnidad] [varchar](6) NOT NULL,
	[colorInterior] [varchar](30) NULL,
	[colorExterior] [varchar](30) NULL,
	[modelo] [varchar](4) NULL,
	[descModelo] [varchar](60) NULL,
	[marca] [varchar](100) NULL,
	[segmento] [varchar](100) NULL,
	[subtipoUnidad] [varchar](100) NULL,
	[uncIdcatalo] [varchar](20) NOT NULL,
	[carLine] [varchar](100) NULL,
	[puertas] [varchar](100) NULL,
	[cilindros] [varchar](100) NULL,
	[uncPotencia] [varchar](15) NULL,
	[combustible] [varchar](100) NULL,
	[capacidad] [varchar](15) NULL,
	[transmision] [varchar](100) NULL,
	[ubicacion] [varchar](100) NULL,
	[tipomotor] [varchar](10) NULL,
	[noMotor] [varchar](25) NULL,
	[procedencia] [varchar](10) NULL,
	[vehNofactplan] [varchar](20) NULL,
	[vehFecremision] [varchar](10) NULL,
	[numPedimento] [varchar](20) NULL,
	[fechaPedimento] [varchar](10) NULL,
	[tipoCompra] [varchar](100) NULL,
	[vehFecrecibo] [varchar](10) NULL,
	[diasInventa] [int] NULL,
	[precioLista] [decimal](18, 5) NULL,
	[valorInventario] [decimal](38, 5) NULL,
	[situacion] [varchar](100) NULL,
	[consCartera] [varchar](50) NULL,
	[idDocto] [varchar](50) NULL,
	[updateBy] [int] NULL,
	[lastUpdate] [smalldatetime] NULL,
	[empresaID] [int] NULL,
	[sucursalID] [int] NULL,
	[esquemaID] [int] NULL,
	[estatusCID] [int] NULL,
	[saldo] [decimal](18, 4) NULL,
	[fechaEfectiva] [date] NULL,
	[fechaCalculo] [date] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Traspaso]    Script Date: 02/12/2018 18:29:50 ******/
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
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TmpExcelData]    Script Date: 02/12/2018 18:29:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TmpExcelData](
	[numeroSerie] [varchar](25) NULL,
	[valor] [numeric](18, 4) NULL,
	[interes] [numeric](18, 4) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TipoUsuario]    Script Date: 02/12/2018 18:29:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoUsuario](
	[tipoUsuarioId] [int] IDENTITY(1,1) NOT NULL,
	[tipoUsuario] [nvarchar](50) NULL,
	[activo] [bit] NOT NULL,
 CONSTRAINT [PK_TipoUsuario] PRIMARY KEY CLUSTERED 
(
	[tipoUsuarioId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoUnidad]    Script Date: 02/12/2018 18:29:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoUnidad](
	[tipoUnidadId] [int] IDENTITY(1,1) NOT NULL,
	[tipoUnidad] [nvarchar](50) NULL,
	[activo] [bit] NOT NULL,
 CONSTRAINT [PK_TipoUnidad] PRIMARY KEY CLUSTERED 
(
	[tipoUnidadId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoTiie]    Script Date: 02/12/2018 18:29:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoTiie](
	[tipoTiieId] [int] IDENTITY(1,1) NOT NULL,
	[tipoTiie] [nvarchar](50) NULL,
	[activo] [bit] NOT NULL,
 CONSTRAINT [PK_TipoTiie] PRIMARY KEY CLUSTERED 
(
	[tipoTiieId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoMovimiento]    Script Date: 02/12/2018 18:29:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoMovimiento](
	[tipoMovimientoId] [int] NOT NULL,
	[tipoMovimiento] [nvarchar](50) NULL,
	[activo] [bit] NOT NULL,
 CONSTRAINT [PK_TipoMovimiento] PRIMARY KEY CLUSTERED 
(
	[tipoMovimientoId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoLote]    Script Date: 02/12/2018 18:29:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoLote](
	[tipoLoteId] [int] IDENTITY(1,1) NOT NULL,
	[tipoLote] [nvarchar](50) NULL,
	[activo] [bit] NOT NULL,
 CONSTRAINT [PK_TipoLote] PRIMARY KEY CLUSTERED 
(
	[tipoLoteId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoEsquemaDetalle]    Script Date: 02/12/2018 18:29:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoEsquemaDetalle](
	[TipoEsquemaDetalleId] [int] IDENTITY(1,1) NOT NULL,
	[TipoEsquemaDetalle] [nvarchar](50) NULL,
	[activo] [bit] NOT NULL,
 CONSTRAINT [PK_TipoEsquemaDetalle] PRIMARY KEY CLUSTERED 
(
	[TipoEsquemaDetalleId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tiie]    Script Date: 02/12/2018 18:29:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tiie](
	[tiieID] [bigint] IDENTITY(1,1) NOT NULL,
	[fecha] [smalldatetime] NULL,
	[porcentaje] [numeric](18, 4) NULL,
	[estatusCID] [int] NULL,
	[createBy] [int] NULL,
	[updateBy] [int] NULL,
	[createDate] [smalldatetime] NULL,
	[updateDate] [smalldatetime] NULL,
 CONSTRAINT [PK_Tiie] PRIMARY KEY CLUSTERED 
(
	[tiieID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sucursal]    Script Date: 02/12/2018 18:29:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Sucursal](
	[sucursalID] [int] NOT NULL,
	[empresaID] [int] NOT NULL,
	[catSucNombrecto] [varchar](10) NOT NULL,
	[nombreSucursal] [varchar](150) NOT NULL,
	[nombreBase] [varchar](100) NOT NULL,
	[servidorIP] [varchar](20) NOT NULL,
	[tipo] [varchar](10) NOT NULL,
	[rfc] [varchar](20) NOT NULL,
	[estatusID] [int] NOT NULL,
 CONSTRAINT [PK_Sucursal] PRIMARY KEY CLUSTERED 
(
	[sucursalID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Movimiento]    Script Date: 02/12/2018 18:29:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Movimiento](
	[movimientoID] [bigint] IDENTITY(1,1) NOT NULL,
	[CCP_IDDOCTO] [varchar](20) NOT NULL,
	[VIN] [nvarchar](19) NULL,
	[usuarioID] [int] NOT NULL,
	[empresaID] [int] NOT NULL,
	[sucursalID] [int] NOT NULL,
	[sucursalRecibeID] [int] NULL,
	[financieraID] [int] NOT NULL,
	[esquemaID] [int] NOT NULL,
	[fecha] [smalldatetime] NOT NULL,
	[monto] [decimal](18, 4) NOT NULL,
	[active] [bit] NULL,
	[tipoMovimientoId] [int] NULL,
	[genericID] [int] NULL,
	[fecha_original] [smalldatetime] NULL,
 CONSTRAINT [PK_Movimiento] PRIMARY KEY CLUSTERED 
(
	[movimientoID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Default [DF__Documento__doc_e__6C190EBB]    Script Date: 02/12/2018 18:29:50 ******/
ALTER TABLE [dbo].[Documentos] ADD  CONSTRAINT [DF__Documento__doc_e__6C190EBB]  DEFAULT ((1)) FOR [doc_estatus]
GO
/****** Object:  Default [DF__Documento__fec_e__6D0D32F4]    Script Date: 02/12/2018 18:29:50 ******/
ALTER TABLE [dbo].[Documentos] ADD  CONSTRAINT [DF__Documento__fec_e__6D0D32F4]  DEFAULT (getdate()) FOR [fec_entrada]
GO
/****** Object:  Default [DF_Movimiento_status]    Script Date: 02/12/2018 18:29:50 ******/
ALTER TABLE [dbo].[Movimiento] ADD  CONSTRAINT [DF_Movimiento_status]  DEFAULT ((0)) FOR [active]
GO
/****** Object:  Default [DF_TipoEsquemaDetalle_activo]    Script Date: 02/12/2018 18:29:50 ******/
ALTER TABLE [dbo].[TipoEsquemaDetalle] ADD  CONSTRAINT [DF_TipoEsquemaDetalle_activo]  DEFAULT ((1)) FOR [activo]
GO
/****** Object:  Default [DF_TipoLote_activo]    Script Date: 02/12/2018 18:29:50 ******/
ALTER TABLE [dbo].[TipoLote] ADD  CONSTRAINT [DF_TipoLote_activo]  DEFAULT ((1)) FOR [activo]
GO
/****** Object:  Default [DF_TipoMovimiento_activo]    Script Date: 02/12/2018 18:29:50 ******/
ALTER TABLE [dbo].[TipoMovimiento] ADD  CONSTRAINT [DF_TipoMovimiento_activo]  DEFAULT ((1)) FOR [activo]
GO
/****** Object:  Default [DF_TipoTiie_activo]    Script Date: 02/12/2018 18:29:50 ******/
ALTER TABLE [dbo].[TipoTiie] ADD  CONSTRAINT [DF_TipoTiie_activo]  DEFAULT ((1)) FOR [activo]
GO
/****** Object:  Default [DF_TipoUnidad_activo]    Script Date: 02/12/2018 18:29:50 ******/
ALTER TABLE [dbo].[TipoUnidad] ADD  CONSTRAINT [DF_TipoUnidad_activo]  DEFAULT ((1)) FOR [activo]
GO
/****** Object:  Default [DF_TipoUsuario_activo]    Script Date: 02/12/2018 18:29:50 ******/
ALTER TABLE [dbo].[TipoUsuario] ADD  CONSTRAINT [DF_TipoUsuario_activo]  DEFAULT ((1)) FOR [activo]
GO
/****** Object:  Default [DF_Traspaso]    Script Date: 02/12/2018 18:29:50 ******/
ALTER TABLE [dbo].[Traspaso] ADD  CONSTRAINT [DF_Traspaso]  DEFAULT (getdate()) FOR [fec_entrada]
GO
/****** Object:  Default [DF_Venta]    Script Date: 02/12/2018 18:29:50 ******/
ALTER TABLE [dbo].[Venta] ADD  CONSTRAINT [DF_Venta]  DEFAULT (getdate()) FOR [fec_entrada]
GO
/****** Object:  ForeignKey [FK_Movimiento_Documentos]    Script Date: 02/12/2018 18:29:50 ******/
ALTER TABLE [dbo].[Movimiento]  WITH CHECK ADD  CONSTRAINT [FK_Movimiento_Documentos] FOREIGN KEY([CCP_IDDOCTO])
REFERENCES [dbo].[Documentos] ([CCP_IDDOCTO])
GO
ALTER TABLE [dbo].[Movimiento] CHECK CONSTRAINT [FK_Movimiento_Documentos]
GO
/****** Object:  ForeignKey [FK_Movimiento_Esquema]    Script Date: 02/12/2018 18:29:50 ******/
ALTER TABLE [dbo].[Movimiento]  WITH CHECK ADD  CONSTRAINT [FK_Movimiento_Esquema] FOREIGN KEY([esquemaID])
REFERENCES [dbo].[Esquema] ([esquemaID])
GO
ALTER TABLE [dbo].[Movimiento] CHECK CONSTRAINT [FK_Movimiento_Esquema]
GO
/****** Object:  ForeignKey [FK_Movimiento_TipoMovimiento]    Script Date: 02/12/2018 18:29:50 ******/
ALTER TABLE [dbo].[Movimiento]  WITH CHECK ADD  CONSTRAINT [FK_Movimiento_TipoMovimiento] FOREIGN KEY([tipoMovimientoId])
REFERENCES [dbo].[TipoMovimiento] ([tipoMovimientoId])
GO
ALTER TABLE [dbo].[Movimiento] CHECK CONSTRAINT [FK_Movimiento_TipoMovimiento]
GO

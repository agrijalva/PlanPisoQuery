USE [PlanPiso]
GO
/****** Object:  StoredProcedure [dbo].[SEL_ACTIVE_DATABASES_SP]    Script Date: 02/09/2018 11:32:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER procedure [dbo].[SEL_ACTIVE_DATABASES_SP]

as
begin

	declare @tableConf  Table
(
	idEmpresa  int,
	idSucursal int,
	servidor   varchar(250),
	baseConcentra   varchar(250),
	sqlCmd varchar(8000),
	cargaDiaria varchar(8000)
)


			insert into @tableConf
			select  BP. emp_idempresa as idEmpresa,
					BP.suc_idsucursal as idSucursal,				
					
					'['+ BP.ip_servidor +'].' +'['+ BP.nombre_base+'].'+'[dbo]' as servidor	,
					(select '['+ ip_servidor +'].' +'['+ nombre_base+'].'+'[dbo]'															
					from    [Centralizacionv2].[dbo].[DIG_CAT_BASES_BPRO] 
					where   emp_idempresa = BP.emp_idempresa and tipo=2) as baseConcentra,


					'INS_PRECARGA ' +
					+ char(39) +'['+ BP.ip_servidor +'].' +'['+ BP.nombre_base+'].'+'[dbo]' + char(39) + ','+
					+ char(39) + (select '['+ ip_servidor +'].' +'['+ nombre_base+'].'+'[dbo]' from    [Centralizacionv2].[dbo].[DIG_CAT_BASES_BPRO] where   emp_idempresa = BP.emp_idempresa and tipo=2)  +  char(39) + ','+
					  convert(varchar(5),BP. emp_idempresa) +','+
					  convert(varchar(5),BP.suc_idsucursal) as sqlcmd,

					'INS_CARGADIARIA ' +
					  char(39) +'['+ BP.nombre_base+'].'+'[dbo].' + char(39) + ','+					
					  convert(varchar(5),BP. emp_idempresa) +','+
					  convert(varchar(5),BP.suc_idsucursal) as sqlcmd

			from    [Centralizacionv2].[dbo].[DIG_CAT_BASES_BPRO] BP,
					[ControlAplicaciones].[dbo].[cat_empresas]    CE
			where   BP.emp_idempresa = CE.emp_idempresa
			and		BP.estatus=1 
			and		BP.tipo=1
			and		BP.suc_idsucursal  is not null

			select  * from @tableConf

end
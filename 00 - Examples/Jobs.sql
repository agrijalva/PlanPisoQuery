USE [PlanPiso];

EXEC [GAAU_CARTERAPROVEEDORES_SP];
EXEC [dbo].[BPRO_TRASPASOS_SP] 1;
EXEC [dbo].[BRPO_VENTAS_SP] 1;

EXEC [dbo].[GAAT_CARTERAPROVEEDORES_SP];
EXEC [dbo].[BPRO_TRASPASOS_SP] 2;
EXEC [dbo].[BRPO_VENTAS_SP] 2;

EXEC [dbo].[GAHonda_CARTERAPROVEEDORES_SP];
EXEC [dbo].[BPRO_TRASPASOS_SP] 3;
EXEC [dbo].[BRPO_VENTAS_SP] 3;

EXEC [dbo].[GAZM_CARTERAPROVEEDORES_SP];
EXEC [dbo].[BPRO_TRASPASOS_SP] 4;
EXEC [dbo].[BRPO_VENTAS_SP] 4;

SELECT * FROM GAAU_Concentra..UNI_TRASPASOS where TRA_NUMTRASPASO = 1518;
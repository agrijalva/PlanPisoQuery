/****** Script para el comando SelectTopNRows de SSMS  ******/ 
-- (1)
SELECT TOP 1000 MOV_MES, * FROM [GAAU_Concentra].[dbo].[CON_MOVDET012017] WHERE MOV_CONSPOL = 127 AND MOV_TIPOPOL = 'DIFUN' AND MOV_NUMCTA = '2100-0010-0001-0001';
SELECT consecutivo_contable, * FROM Centralizacionv2..DIG_CAT_BASES_BPRO;
SELECT TOP 100 * FROM [GAAU_Concentra].[dbo].VIS_CONCAR01 WHERE CCP_IDDOCTO = '25817';

SELECT TOP 1000 * FROM [GAAU_Concentra].[dbo].[CON_CAR012018]
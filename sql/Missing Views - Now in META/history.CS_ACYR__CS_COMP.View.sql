USE CCDW_HIST
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [history].[CS_ACYR__CS_COMP] AS
SELECT [CS.STUDENT.ID]
     , [CS.YEAR]
       
     , CAST(LTRIM(RTRIM(CA1.Item)) AS VARCHAR(8)) AS [CS.COMP.ID]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[CS_ACYR]
  
 CROSS APPLY dw_util.DelimitedSplit8K([CS.COMP.ID],', ') CA1
 WHERE COALESCE(TRIM([CS.COMP.ID]),'') != ''
 
GO

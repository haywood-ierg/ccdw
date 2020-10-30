SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
DROP VIEW [history].[SA_ACYR__SA_PELL_DISBS]
GO
CREATE VIEW [history].[SA_ACYR__SA_PELL_DISBS] AS
SELECT [SA.STUDENT.ID]
, [SA.YEAR]
       
, CAST(LTRIM(RTRIM(CA1.Item)) AS DATE) AS [SA.PELL.DISB.REC.DATE]
     , CA1.ItemNumber AS ItemNumber
     , EffectiveDatetime
  FROM [history].[SA_ACYR]
  
CROSS APPLY dw_util.DelimitedSplit8K([SA.PELL.DISB.REC.DATE],', ') CA1
 WHERE COALESCE([SA.PELL.DISB.REC.DATE],'') != ''
GO

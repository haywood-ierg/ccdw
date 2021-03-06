IF OBJECT_ID('history.[STUDENT_ACAD_CRED__STC_STATUSES]', 'V') IS NOT NULL
    DROP VIEW history.[STUDENT_ACAD_CRED__STC_STATUSES]
GO

CREATE VIEW history.[STUDENT_ACAD_CRED__STC_STATUSES] AS 
    SELECT [STUDENT.ACAD.CRED.ID]
         , CAST(LTRIM(RTRIM(CASE WHEN [STC.STATUS.TIME] = 'Invalid Date' THEN '00:00:00'
                                 ELSE CA1.Item END)) AS TIME) AS [STC.STATUS.TIME]
         , CAST(LTRIM(RTRIM(CA2.Item)) AS DATE) AS [STC.STATUS.DATE]
         , CAST(LTRIM(RTRIM(CA3.Item)) AS VARCHAR(15)) AS [STC.STATUS]
         , CAST(LTRIM(RTRIM(CA4.Item)) AS VARCHAR(25)) AS [STC.STATUS.REASON]
         , CA1.ItemNumber AS ItemNumber
         , EffectiveDatetime
      FROM [history].[STUDENT_ACAD_CRED] 
     CROSS APPLY dbo.DelimitedSplit8K([STC.STATUS.TIME], ', ') CA1 
     CROSS APPLY dbo.DelimitedSplit8K([STC.STATUS.DATE], ', ') CA2 
     CROSS APPLY dbo.DelimitedSplit8K([STC.STATUS], ', ') CA3 
     CROSS APPLY dbo.DelimitedSplit8K([STC.STATUS.REASON], ', ') CA4
     WHERE COALESCE ([STC.STATUS], '') != '' 
       AND CA1.ItemNumber = CA2.ItemNumber 
       AND CA1.ItemNumber = CA3.ItemNumber 
       AND CA1.ItemNumber = CA4.ItemNumber
;
DECLARE @InDW BIT = 0;
DECLARE @OnlyWithValidation BIT = 0;
DECLARE @TableName VARCHAR(100) = '';
DECLARE @ColumnName VARCHAR(100) = 'TEDE.TERM.REASON.CODE';

WITH valcodes AS (
	SELECT '$VR.'+v.[VALCODE.ID] AS VALIDATION_CODE_ID
		  ,v.[VAL.PURPOSE] AS VALIDATION_PURPOSE
		  ,[VAL.CODE.LENGTH] AS VALIDATION_CODE_LENGTH
		  ,vv.[VAL.EXTERNAL.REPRESENTATION] AS VALIDATION_EXTERNAL_REPRESENTATION
		  ,vv.[VAL.INTERNAL.CODE] AS VALIDATION_INTERNAL_CODE
		  ,[CurrentFlag]
	  FROM [history].[META__ALL_VALCODES_Current] v
	  LEFT JOIN history.META__ALL_VALCODES__VALS vv
		   ON vv.[VALCODE.ID] = v.[VALCODE.ID]
		   AND vv.EffectiveDatetime = v.EffectiveDatetime
		  --where v.[VALCODE.ID] like '%DATA.TYPES%'
), meta AS (
	SELECT REPLACE(m.SOURCE,'.','_') AS TABLE_NAME
	     , m.[DATA.ELEMENT] AS COLUMN_NAME
		 , m.[ELEMENT.POINTED.TO] AS ELEMENT_POINTED_TO
		 , m.[ELEMENT.POINTED.FROM] AS ELEMENT_POINTED_FROM
		 , m.[ELEMENT.ASSOC.NAME] AS ASSOCIATION
		 , m.PURPOSE
		 , m.[VALIDATION.TABLE] AS VALIDATION_CODE_ID
	FROM [history].[META__ALL_CDD_Current] m
), sqlsvr AS (
    SELECT c.TABLE_NAME
	     , c.COLUMN_NAME
	FROM INFORMATION_SCHEMA.COLUMNS c
   WHERE c.TABLE_SCHEMA = 'input'
), qry1 AS (
	SELECT sqlsvr.TABLE_NAME 
		 , sqlsvr.COLUMN_NAME
		 , meta.ASSOCIATION
		 , meta.PURPOSE
		 , valcodes.VALIDATION_PURPOSE
		 , valcodes.VALIDATION_INTERNAL_CODE
		 , valcodes.VALIDATION_EXTERNAL_REPRESENTATION
	  FROM meta
	 INNER JOIN sqlsvr
		ON (CASE WHEN meta.TABLE_NAME LIKE '%CDD'
		              THEN CASE WHEN sqlsvr.TABLE_NAME = 'META__' + SUBSTRING(meta.TABLE_NAME,1,LEN(meta.TABLE_NAME)-3) + '_CDD' 
			                         THEN 1
				  	            ELSE 0 END
		         WHEN sqlsvr.TABLE_NAME = meta.TABLE_NAME THEN 1
				 ELSE 0 END = 1
		AND sqlsvr.COLUMN_NAME = meta.COLUMN_NAME)
	  LEFT JOIN valcodes
		   ON valcodes.VALIDATION_CODE_ID = meta.VALIDATION_CODE_ID
	 WHERE CASE WHEN @OnlyWithValidation = 1 AND COALESCE(valcodes.VALIDATION_CODE_ID,'') <> '' THEN 1 
				WHEN @OnlyWithValidation = 0 THEN 1 
				ELSE 0 END = 1
	 AND CASE WHEN @TableName = '' OR meta.TABLE_NAME LIKE @TableName THEN 1
			  ELSE 0 END = 1
	 AND CASE WHEN @ColumnName = '' OR meta.COLUMN_NAME LIKE @ColumnName THEN 1
			  ELSE 0 END = 1
), qry AS (
	SELECT sqlsvr.TABLE_NAME 
		 , sqlsvr.COLUMN_NAME
		 , meta.ASSOCIATION
		 , meta.PURPOSE
		 , valcodes.VALIDATION_PURPOSE
		 , valcodes.VALIDATION_INTERNAL_CODE
		 , valcodes.VALIDATION_EXTERNAL_REPRESENTATION
	  FROM meta
	 LEFT JOIN sqlsvr
		ON (CASE WHEN meta.TABLE_NAME LIKE '%CDD'
		              THEN CASE WHEN sqlsvr.TABLE_NAME = 'META__' + SUBSTRING(meta.TABLE_NAME,1,LEN(meta.TABLE_NAME)-3) + '_CDD' 
			                         THEN 1
				  	            ELSE 0 END
		         WHEN sqlsvr.TABLE_NAME = meta.TABLE_NAME THEN 1
				 ELSE 0 END = 1
		AND sqlsvr.COLUMN_NAME = meta.COLUMN_NAME)
	  LEFT JOIN valcodes
		   ON valcodes.VALIDATION_CODE_ID = meta.VALIDATION_CODE_ID
	 WHERE CASE WHEN @OnlyWithValidation = 1 AND COALESCE(valcodes.VALIDATION_CODE_ID,'') <> '' THEN 1 
				WHEN @OnlyWithValidation = 0 THEN 1 
				ELSE 0 END = 1
	 AND CASE WHEN @TableName = '' OR meta.TABLE_NAME LIKE @TableName THEN 1
			  ELSE 0 END = 1
	 AND CASE WHEN @ColumnName = '' OR meta.COLUMN_NAME LIKE @ColumnName THEN 1
			  ELSE 0 END = 1
	 AND CASE WHEN @InDW = 1 AND sqlsvr.TABLE_NAME IS NULL THEN 0 ELSE 1 END = 1  
)
SELECT *
  FROM qry

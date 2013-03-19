/*
All the ODS tables have notes in XML format that map where each column was derived from
This script parses out all the note fields to help crosswalk data from the HP -> ODS
*/
USE ODS
SELECT
  [TableName]
, [ColumnName]
, NULLIF([Description].value('(field/hpsource/@schema)[1]', 'varchar(max)'),'') AS [HP_Schema]
, NULLIF([Description].value('(field/hpsource/@table)[1]', 'varchar(max)'),'')  AS [HP_Table]
, NULLIF([Description].value('(field/hpsource/@field)[1]', 'varchar(max)'),'')  AS [HP_Field]
, NULLIF([Description].value('(field/description)[1]', 'varchar(max)'),'')      AS [Description]
, NULLIF([Description].value('(field/comment)[1]', 'varchar(max)'),'')          AS [Comment]
, NULLIF([Description].value('(field/definition)[1]', 'varchar(max)'),'')       AS [Definition]
, NULLIF([Description].value('(field/key/@table)[1]', 'varchar(max)'),'')       AS [KeyTable]
, NULLIF([Description].value('(field/key/@field)[1]', 'varchar(max)'),'')       AS [KeyField]
FROM [ODS].[dbo].[vw_SchemaMetadata]
ORDER BY TableName, ColumnName

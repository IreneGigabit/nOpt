USE [sikopt]
GO
BEGIN TRANSACTION
GO
ALTER TABLE dbo.case_opt ADD
	rectitle_name varchar(320) NULL,
	send_way varchar(2) NULL,
	receipt_type varchar(1) NULL,
	receipt_title varchar(1) NULL
GO
ALTER TABLE dbo.case_opt SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

BEGIN TRANSACTION
GO
ALTER TABLE dbo.case_opt_log ADD
	rectitle_name varchar(320) NULL,
	send_way varchar(2) NULL,
	receipt_type varchar(1) NULL,
	receipt_title varchar(1) NULL
GO
ALTER TABLE dbo.case_opt_log SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


SELECT DISTINCT 'EXEC sp_refreshview ' + name + '' 
FROM sys.objects so INNER JOIN sys.sql_dependencies sd 
ON so.object_id = sd.object_id 
WHERE type = 'V' 
AND sd.referenced_major_id = object_id('case_opt');
--case_opt
EXEC sp_refreshview vbr_opt
EXEC sp_refreshview vopt_641



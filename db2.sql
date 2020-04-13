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


USE [sindbs]
GO
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Bstep_temp ADD
	send_way varchar(2) NULL
GO
ALTER TABLE dbo.Bstep_temp SET (LOCK_ESCALATION = TABLE)
GO
COMMIT




USE [sindbs]
GO

/****** Object:  Table [dbo].[Bstep_temp]    Script Date: 04/13/2020 14:01:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Bstep_temp](
	[RS_no] [varchar](10) NOT NULL,
	[Branch] [char](1) NULL,
	[Seq] [int] NULL,
	[Seq1] [char](1) NULL,
	[Send_dept] [varchar](1) NULL,
	[Step_Date] [smalldatetime] NULL,
	[Mp_Date] [smalldatetime] NULL,
	[CG] [char](1) NULL,
	[RS] [char](1) NULL,
	[Send_Cl] [varchar](1) NULL,
	[Send_Cl1] [varchar](1) NULL,
	[Send_Sel] [varchar](1) NULL,
	[RS_type] [varchar](10) NULL,
	[RS_Class] [varchar](4) NULL,
	[RS_Code] [varchar](6) NULL,
	[Act_code] [varchar](20) NULL,
	[RS_detail] [varchar](60) NULL,
	[Fees] [int] NULL,
	[Case_no] [varchar](10) NULL,
	[opt_sqlno] [int] NULL,
	[Mark] [varchar](1) NULL,
	[Confirm_date] [datetime] NULL,
	[Confirm_Scode] [varchar](5) NULL,
	[rs_agt_no] [varchar](4) NULL,
	[receipt_type] [varchar](1) NULL,
	[receipt_title] [varchar](1) NULL,
	[rectitle_name] [varchar](320) NULL,
 CONSTRAINT [PK_Bstep_temp] PRIMARY KEY CLUSTERED 
(
	[RS_no] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[Bstep_temp] ADD  CONSTRAINT [DF_Bstep_temp_Mark]  DEFAULT ('N') FOR [Mark]
GO

ALTER TABLE [dbo].[Bstep_temp] ADD  CONSTRAINT [DF_Bstep_temp_rs_agt_no]  DEFAULT (null) FOR [rs_agt_no]
GO






USE [simdbs]
GO

/****** Object:  Table [dbo].[mgt_send]    Script Date: 04/13/2020 14:01:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[mgt_send](
	[tsend_sqlno] [int] IDENTITY(1,1) NOT NULL,
	[seq_area0] [varchar](2) NULL,
	[seq_area] [varchar](2) NULL,
	[seq] [int] NULL,
	[seq1] [varchar](3) NULL,
	[br_in_date] [datetime] NULL,
	[send_grade] [int] NULL,
	[br_step_grade] [smallint] NULL,
	[br_rs_sqlno] [int] NULL,
	[mseq] [int] NULL,
	[mseq1] [varchar](3) NULL,
	[rs_no] [varchar](10) NULL,
	[mrs_no] [varchar](10) NULL,
	[rs_type] [varchar](10) NULL,
	[rs_class] [varchar](4) NULL,
	[rs_class_name] [varchar](100) NULL,
	[rs_code] [varchar](10) NULL,
	[rs_code_name] [varchar](100) NULL,
	[act_code] [varchar](20) NULL,
	[act_code_name] [varchar](100) NULL,
	[rs_detail] [varchar](100) NULL,
	[send_cl] [varchar](20) NULL,
	[send_cl1] [varchar](20) NULL,
	[class_count] [int] NULL,
	[add_count] [int] NULL,
	[new_flag] [varchar](2) NULL,
	[case_new] [varchar](2) NULL,
	[fees] [int] NULL,
	[step_date] [smalldatetime] NULL,
	[mp_date] [smalldatetime] NULL,
	[send_way] [char](3) NULL,
	[cappl_name] [varchar](255) NULL,
	[eappl_name] [varchar](255) NULL,
	[s_mark1] [varchar](1) NULL,
	[s_mark2] [varchar](1) NULL,
	[Country] [varchar](5) NULL,
	[apply_date] [smalldatetime] NULL,
	[apply_no] [varchar](20) NULL,
	[change_no] [varchar](20) NULL,
	[issue_date] [smalldatetime] NULL,
	[issue_no1] [varchar](20) NULL,
	[issue_no2] [varchar](20) NULL,
	[issue_no3] [varchar](20) NULL,
	[open_date] [smalldatetime] NULL,
	[pay_times] [varchar](2) NULL,
	[pay_date] [smalldatetime] NULL,
	[term1] [smalldatetime] NULL,
	[term2] [smalldatetime] NULL,
	[end_date] [smalldatetime] NULL,
	[end_code] [varchar](1) NULL,
	[account] [varchar](2) NULL,
	[source] [varchar](2) NULL,
	[send_status] [varchar](2) NULL,
	[send_rs_sqlno] [int] NULL,
	[branch_date] [datetime] NULL,
	[branch_scode] [varchar](5) NULL,
	[br_back_date] [datetime] NULL,
	[br_back_scode] [varchar](5) NULL,
	[in_date] [datetime] NULL,
	[in_scode] [varchar](5) NULL,
	[conf_date] [datetime] NULL,
	[conf_scode] [varchar](5) NULL,
	[tran_date] [datetime] NULL,
	[tran_scode] [varchar](5) NULL,
	[print_flag] [varchar](10) NULL,
	[mark] [char](1) NULL,
	[agt_no] [char](5) NULL,
	[mg_pr_remark] [text] NULL,
	[receipt_type] [varchar](1) NULL,
	[receipt_title] [varchar](50) NULL,
	[issue_type] [varchar](2) NULL,
	[rsend_date] [datetime] NULL,
	[epay_fee_status] [varchar](2) NULL,
	[epay_fee_rscode] [varchar](5) NULL,
	[epay_fee_rdate] [datetime] NULL,
	[epay_fee_apscode] [varchar](5) NULL,
	[epay_fee_ap_date] [datetime] NULL,
	[epay_sqlno] [int] NULL,
 CONSTRAINT [PK_mgt_send] PRIMARY KEY CLUSTERED 
(
	[tsend_sqlno] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_seq_area0]  DEFAULT ('') FOR [seq_area0]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_seq_area]  DEFAULT ('') FOR [seq_area]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_seq]  DEFAULT (0) FOR [seq]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_seq1]  DEFAULT ('') FOR [seq1]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_br_in_date]  DEFAULT (null) FOR [br_in_date]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_send_grade]  DEFAULT (0) FOR [br_step_grade]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_br_rs_sqlno]  DEFAULT (0) FOR [br_rs_sqlno]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_mseq]  DEFAULT (0) FOR [mseq]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_mseq1]  DEFAULT ('') FOR [mseq1]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_send_no]  DEFAULT ('') FOR [rs_no]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_msend_no]  DEFAULT ('') FOR [mrs_no]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_rs_type]  DEFAULT ('') FOR [rs_type]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_rs_class]  DEFAULT ('') FOR [rs_class]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_rs_class_name]  DEFAULT ('') FOR [rs_class_name]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_rs_code]  DEFAULT ('') FOR [rs_code]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_rs_code_name]  DEFAULT ('') FOR [rs_code_name]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_act_code]  DEFAULT ('') FOR [act_code]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_act_code_name]  DEFAULT ('') FOR [act_code_name]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_rs_detail]  DEFAULT ('') FOR [rs_detail]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_send_cl]  DEFAULT ('') FOR [send_cl]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_send_cl1]  DEFAULT ('') FOR [send_cl1]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_cla_count]  DEFAULT (0) FOR [class_count]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_add_count]  DEFAULT (0) FOR [add_count]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_new_flag]  DEFAULT ('') FOR [new_flag]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_case_new]  DEFAULT ('') FOR [case_new]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_fees]  DEFAULT (0) FOR [fees]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_step_date]  DEFAULT (null) FOR [step_date]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_mp_date]  DEFAULT (null) FOR [mp_date]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_send_way]  DEFAULT ('M') FOR [send_way]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_appl_name]  DEFAULT ('') FOR [cappl_name]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_eappl_name]  DEFAULT ('') FOR [eappl_name]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_s_mark1]  DEFAULT ('') FOR [s_mark1]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_s_mark2]  DEFAULT ('') FOR [s_mark2]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_Country]  DEFAULT ('') FOR [Country]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_apply_date]  DEFAULT (null) FOR [apply_date]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_apply_no]  DEFAULT ('') FOR [apply_no]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_change_no]  DEFAULT ('') FOR [change_no]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_issue_date]  DEFAULT (null) FOR [issue_date]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_issue_no1]  DEFAULT ('') FOR [issue_no1]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_issue_no2]  DEFAULT ('') FOR [issue_no2]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_issue_no3]  DEFAULT ('') FOR [issue_no3]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_open_date]  DEFAULT (null) FOR [open_date]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_pay_times]  DEFAULT ('') FOR [pay_times]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_pay_date]  DEFAULT (null) FOR [pay_date]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_term1]  DEFAULT (null) FOR [term1]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_term2]  DEFAULT (null) FOR [term2]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_end_date]  DEFAULT (null) FOR [end_date]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_end_code]  DEFAULT ('') FOR [end_code]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_account]  DEFAULT ('CH') FOR [account]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_source]  DEFAULT ('B') FOR [source]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_send_status]  DEFAULT ('NN') FOR [send_status]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_sends_sqlno]  DEFAULT (0) FOR [send_rs_sqlno]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_branch_date]  DEFAULT (null) FOR [branch_date]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_branch_scode]  DEFAULT ('') FOR [branch_scode]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_br_back_date]  DEFAULT (null) FOR [br_back_date]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_br_back_scode]  DEFAULT ('') FOR [br_back_scode]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_in_date]  DEFAULT (null) FOR [in_date]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_in_scode]  DEFAULT ('') FOR [in_scode]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_conf_date]  DEFAULT (null) FOR [conf_date]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_conf_scode ]  DEFAULT ('') FOR [conf_scode]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_tran_date]  DEFAULT (null) FOR [tran_date]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_tran_scode]  DEFAULT ('') FOR [tran_scode]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_print_flag]  DEFAULT ('NNNNNN') FOR [print_flag]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_mark]  DEFAULT ('') FOR [mark]
GO

ALTER TABLE [dbo].[mgt_send] ADD  CONSTRAINT [DF_mgt_send_agt_no]  DEFAULT ('') FOR [agt_no]
GO

ALTER TABLE [dbo].[mgt_send] ADD  DEFAULT ('') FOR [mg_pr_remark]
GO

ALTER TABLE [dbo].[mgt_send] ADD  DEFAULT ('') FOR [receipt_type]
GO

ALTER TABLE [dbo].[mgt_send] ADD  DEFAULT ('') FOR [receipt_title]
GO

ALTER TABLE [dbo].[mgt_send] ADD  DEFAULT ('') FOR [issue_type]
GO





USE [simdbs]
GO

/****** Object:  Table [dbo].[mgp_send]    Script Date: 04/13/2020 14:02:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[mgp_send](
	[psend_sqlno] [int] IDENTITY(1,1) NOT NULL,
	[seq_area] [varchar](2) NULL,
	[seq] [int] NULL,
	[seq1] [varchar](3) NULL,
	[br_in_date] [datetime] NULL,
	[send_grade] [int] NULL,
	[br_step_grade] [smallint] NULL,
	[br_rs_sqlno] [int] NULL,
	[Mseq] [int] NULL,
	[Mseq1] [varchar](3) NULL,
	[rs_no] [varchar](10) NULL,
	[mrs_no] [varchar](10) NULL,
	[rs_type] [varchar](10) NULL,
	[rs_class] [varchar](4) NULL,
	[rs_class_name] [varchar](100) NULL,
	[rs_code] [varchar](10) NULL,
	[rs_code_name] [varchar](100) NULL,
	[act_code] [varchar](20) NULL,
	[act_code_name] [varchar](100) NULL,
	[rs_detail] [varchar](100) NULL,
	[send_cl] [varchar](20) NULL,
	[send_cl1] [varchar](60) NULL,
	[fees] [int] NULL,
	[add_count] [int] NULL,
	[step_date] [smalldatetime] NULL,
	[mp_date] [smalldatetime] NULL,
	[send_way] [char](3) NULL,
	[cappl_name] [varchar](350) NULL,
	[eappl_name] [varchar](350) NULL,
	[country] [varchar](5) NULL,
	[apply_date] [smalldatetime] NULL,
	[apply_no] [varchar](30) NULL,
	[change_date] [smalldatetime] NULL,
	[change_no] [varchar](30) NULL,
	[open_date] [smalldatetime] NULL,
	[open_no] [varchar](30) NULL,
	[issue_date] [smalldatetime] NULL,
	[issue_no] [varchar](30) NULL,
	[capply_date] [smalldatetime] NULL,
	[capply_no] [varchar](30) NULL,
	[term1] [smalldatetime] NULL,
	[term2] [smalldatetime] NULL,
	[end_date] [smalldatetime] NULL,
	[end_code] [char](1) NULL,
	[case_type] [varchar](4) NULL,
	[new_flag] [varchar](2) NULL,
	[case_new] [varchar](2) NULL,
	[pay_times] [varchar](4) NULL,
	[pay_date] [datetime] NULL,
	[transfer_flag] [varchar](1) NULL,
	[account] [varchar](2) NOT NULL,
	[source] [varchar](2) NULL,
	[send_status] [varchar](2) NULL,
	[send_rs_sqlno] [int] NULL,
	[branch_date] [datetime] NULL,
	[branch_scode] [varchar](5) NULL,
	[br_back_date] [datetime] NULL,
	[br_back_scode] [varchar](5) NULL,
	[in_date] [datetime] NULL,
	[in_scode] [varchar](5) NULL,
	[conf_date] [datetime] NULL,
	[conf_scode] [varchar](5) NULL,
	[tran_date] [datetime] NULL,
	[tran_scode] [varchar](5) NULL,
	[print_flag] [varchar](10) NULL,
	[mark] [char](1) NULL,
	[agt_no] [char](5) NULL,
	[mg_pr_remark] [text] NULL,
	[spay_times] [varchar](2) NULL,
	[epay_times] [varchar](2) NULL,
	[accept] [varchar](1) NULL,
	[accept_type] [varchar](1) NULL,
	[receipt_type] [varchar](1) NULL,
	[receipt_title] [varchar](50) NULL,
	[rsend_date] [datetime] NULL,
	[epay_fee_status] [varchar](2) NULL,
	[epay_fee_rscode] [varchar](5) NULL,
	[epay_fee_rdate] [datetime] NULL,
	[epay_fee_apscode] [varchar](5) NULL,
	[epay_fee_ap_date] [datetime] NULL,
	[epay_sqlno] [int] NULL,
 CONSTRAINT [PK_mgp_send] PRIMARY KEY CLUSTERED 
(
	[psend_sqlno] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_seq_area]  DEFAULT ('') FOR [seq_area]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_seq]  DEFAULT (0) FOR [seq]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_seq1]  DEFAULT ('') FOR [seq1]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_br_in_date]  DEFAULT (null) FOR [br_in_date]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_send_grade]  DEFAULT (0) FOR [send_grade]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_br_step_grade]  DEFAULT (0) FOR [br_step_grade]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_br_rs_sqlno]  DEFAULT (0) FOR [br_rs_sqlno]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_Mseq1]  DEFAULT ('') FOR [Mseq1]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_rs_no]  DEFAULT ('') FOR [rs_no]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_mrs_no]  DEFAULT ('') FOR [mrs_no]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_rs_type]  DEFAULT ('') FOR [rs_type]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_rs_class]  DEFAULT ('') FOR [rs_class]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_rs_class_name]  DEFAULT ('') FOR [rs_class_name]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_rs_code]  DEFAULT ('') FOR [rs_code]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_rs_code_name]  DEFAULT ('') FOR [rs_code_name]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_act_code]  DEFAULT ('') FOR [act_code]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_act_code_name]  DEFAULT ('') FOR [act_code_name]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_rs_detail]  DEFAULT ('') FOR [rs_detail]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_send_cl]  DEFAULT ('') FOR [send_cl]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_send_cl1]  DEFAULT ('') FOR [send_cl1]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_fees]  DEFAULT (0) FOR [fees]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_add_count]  DEFAULT (0) FOR [add_count]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_step_date]  DEFAULT (null) FOR [step_date]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_mp_date]  DEFAULT (null) FOR [mp_date]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_send_way]  DEFAULT ('M') FOR [send_way]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_cappl_name]  DEFAULT ('') FOR [cappl_name]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_eappl_name]  DEFAULT ('') FOR [eappl_name]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_country]  DEFAULT ('') FOR [country]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_apply_date]  DEFAULT (null) FOR [apply_date]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_apply_no]  DEFAULT ('') FOR [apply_no]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_change_date]  DEFAULT (null) FOR [change_date]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_change_no]  DEFAULT ('') FOR [change_no]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_open_date]  DEFAULT (null) FOR [open_date]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_open_no]  DEFAULT ('') FOR [open_no]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_issue_date]  DEFAULT (null) FOR [issue_date]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_issue_no]  DEFAULT ('') FOR [issue_no]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_capply_date]  DEFAULT (null) FOR [capply_date]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_capply_no]  DEFAULT ('') FOR [capply_no]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_term1]  DEFAULT (null) FOR [term1]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_term2]  DEFAULT (null) FOR [term2]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_end_date]  DEFAULT (null) FOR [end_date]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_end_code]  DEFAULT ('') FOR [end_code]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_new_flag]  DEFAULT ('') FOR [new_flag]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_case_new]  DEFAULT ('') FOR [case_new]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_pay_times]  DEFAULT ('') FOR [pay_times]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_pay_date]  DEFAULT (null) FOR [pay_date]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_transfer_flag]  DEFAULT ('') FOR [transfer_flag]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_account]  DEFAULT ('CH') FOR [account]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_source]  DEFAULT ('B') FOR [source]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_send_status]  DEFAULT ('NN') FOR [send_status]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_send_rs_sqlno]  DEFAULT (0) FOR [send_rs_sqlno]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_branch_date]  DEFAULT (null) FOR [branch_date]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_branch_scode]  DEFAULT ('') FOR [branch_scode]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_br_back_date]  DEFAULT (null) FOR [br_back_date]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_br_back_scode]  DEFAULT ('') FOR [br_back_scode]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_in_date]  DEFAULT (null) FOR [in_date]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_in_scode]  DEFAULT ('') FOR [in_scode]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_conf_date]  DEFAULT (null) FOR [conf_date]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_conf_scode ]  DEFAULT ('') FOR [conf_scode]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_tran_date]  DEFAULT (null) FOR [tran_date]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_tran_scode]  DEFAULT ('') FOR [tran_scode]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_print_flag]  DEFAULT ('NNNNNN') FOR [print_flag]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_mark]  DEFAULT ('') FOR [mark]
GO

ALTER TABLE [dbo].[mgp_send] ADD  CONSTRAINT [DF_mgp_send_agt_no]  DEFAULT ('') FOR [agt_no]
GO

ALTER TABLE [dbo].[mgp_send] ADD  DEFAULT ('') FOR [mg_pr_remark]
GO

ALTER TABLE [dbo].[mgp_send] ADD  DEFAULT ('') FOR [receipt_type]
GO

ALTER TABLE [dbo].[mgp_send] ADD  DEFAULT ('') FOR [receipt_title]
GO





USE [simdbs]
GO

/****** Object:  Table [dbo].[todo_mgt]    Script Date: 04/13/2020 14:02:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[todo_mgt](
	[sqlno] [int] IDENTITY(1,1) NOT NULL,
	[pre_sqlno] [int] NULL,
	[syscode] [varchar](10) NULL,
	[apcode] [varchar](10) NULL,
	[temp_rs_sqlno] [int] NULL,
	[rs_sqlno] [int] NULL,
	[br_rs_sqlno] [int] NULL,
	[seq_area] [varchar](2) NULL,
	[seq] [int] NULL,
	[seq1] [varchar](3) NULL,
	[step_grade] [int] NULL,
	[rs] [char](1) NULL,
	[rs_no] [varchar](10) NULL,
	[in_date] [datetime] NULL,
	[in_scode] [varchar](5) NULL,
	[dowhat] [varchar](10) NULL,
	[job_scode] [varchar](5) NULL,
	[job_team] [varchar](10) NULL,
	[job_status] [varchar](3) NULL,
	[approve_scode] [varchar](5) NULL,
	[approve_desc] [varchar](500) NULL,
	[approve_code] [varchar](3) NULL,
	[resp_date] [datetime] NULL,
	[mark] [varchar](20) NULL,
 CONSTRAINT [PK_todo_mgt] PRIMARY KEY CLUSTERED 
(
	[sqlno] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 70) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[todo_mgt] ADD  CONSTRAINT [DF_todo_mgt_pre_sqlno]  DEFAULT (0) FOR [pre_sqlno]
GO

ALTER TABLE [dbo].[todo_mgt] ADD  CONSTRAINT [DF_todo_mgt_syscode]  DEFAULT ('') FOR [syscode]
GO

ALTER TABLE [dbo].[todo_mgt] ADD  CONSTRAINT [DF_todo_mgt_apcode]  DEFAULT ('') FOR [apcode]
GO

ALTER TABLE [dbo].[todo_mgt] ADD  CONSTRAINT [DF_todo_mgt_temp_rs_sqlno]  DEFAULT (0) FOR [temp_rs_sqlno]
GO

ALTER TABLE [dbo].[todo_mgt] ADD  CONSTRAINT [DF_todo_mgt_rs_sqlno]  DEFAULT (0) FOR [rs_sqlno]
GO

ALTER TABLE [dbo].[todo_mgt] ADD  CONSTRAINT [DF_todo_mgt_seq_area]  DEFAULT ('') FOR [seq_area]
GO

ALTER TABLE [dbo].[todo_mgt] ADD  CONSTRAINT [DF_todo_mgt_seq]  DEFAULT (0) FOR [seq]
GO

ALTER TABLE [dbo].[todo_mgt] ADD  CONSTRAINT [DF_todo_mgt_seq1]  DEFAULT ('') FOR [seq1]
GO

ALTER TABLE [dbo].[todo_mgt] ADD  CONSTRAINT [DF_todo_mgt_step_grade]  DEFAULT (0) FOR [step_grade]
GO

ALTER TABLE [dbo].[todo_mgt] ADD  CONSTRAINT [DF_todo_mgt_rs]  DEFAULT ('') FOR [rs]
GO

ALTER TABLE [dbo].[todo_mgt] ADD  CONSTRAINT [DF_todo_mgt_send_no]  DEFAULT ('') FOR [rs_no]
GO

ALTER TABLE [dbo].[todo_mgt] ADD  CONSTRAINT [DF_todo_mgt_in_scode]  DEFAULT ('') FOR [in_scode]
GO

ALTER TABLE [dbo].[todo_mgt] ADD  CONSTRAINT [DF_todo_mgt_dowhat]  DEFAULT ('') FOR [dowhat]
GO

ALTER TABLE [dbo].[todo_mgt] ADD  CONSTRAINT [DF_todo_mgt_job_scode]  DEFAULT ('') FOR [job_scode]
GO

ALTER TABLE [dbo].[todo_mgt] ADD  CONSTRAINT [DF_todo_mgt_job_team]  DEFAULT ('') FOR [job_team]
GO

ALTER TABLE [dbo].[todo_mgt] ADD  CONSTRAINT [DF_todo_mgt_job_status]  DEFAULT ('') FOR [job_status]
GO

ALTER TABLE [dbo].[todo_mgt] ADD  CONSTRAINT [DF_todo_mgt_approve_scode]  DEFAULT ('') FOR [approve_scode]
GO

ALTER TABLE [dbo].[todo_mgt] ADD  CONSTRAINT [DF_todo_mgt_approve_desc]  DEFAULT ('') FOR [approve_desc]
GO

ALTER TABLE [dbo].[todo_mgt] ADD  CONSTRAINT [DF_todo_mgt_approve_code]  DEFAULT ('') FOR [approve_code]
GO

ALTER TABLE [dbo].[todo_mgt] ADD  CONSTRAINT [DF_todo_mgt_mark]  DEFAULT ('') FOR [mark]
GO





USE [simdbs]
GO

/****** Object:  Table [dbo].[todo_mgp]    Script Date: 04/13/2020 14:02:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[todo_mgp](
	[sqlno] [int] IDENTITY(1,1) NOT NULL,
	[pre_sqlno] [int] NULL,
	[syscode] [varchar](10) NULL,
	[apcode] [varchar](10) NULL,
	[temp_rs_sqlno] [int] NULL,
	[rs_sqlno] [int] NULL,
	[br_rs_sqlno] [int] NULL,
	[seq_area] [varchar](2) NULL,
	[seq] [int] NULL,
	[seq1] [varchar](3) NULL,
	[step_grade] [int] NULL,
	[rs] [char](1) NULL,
	[rs_no] [varchar](10) NULL,
	[in_date] [datetime] NULL,
	[in_scode] [varchar](5) NULL,
	[dowhat] [varchar](10) NULL,
	[job_scode] [varchar](5) NULL,
	[job_team] [varchar](10) NULL,
	[job_status] [varchar](3) NULL,
	[approve_scode] [varchar](5) NULL,
	[approve_desc] [varchar](500) NULL,
	[approve_code] [varchar](3) NULL,
	[resp_date] [datetime] NULL,
	[mark] [varchar](20) NULL,
 CONSTRAINT [PK_todo_mgp] PRIMARY KEY CLUSTERED 
(
	[sqlno] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 70) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[todo_mgp] ADD  CONSTRAINT [DF_todo_mgp_temp_rs_sqlno]  DEFAULT (0) FOR [temp_rs_sqlno]
GO





USE [account]
GO

/****** Object:  Table [dbo].[plus_temp]    Script Date: 04/13/2020 14:09:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[plus_temp](
	[plus_temp_sqlno] [int] IDENTITY(1,1) NOT NULL,
	[class] [varchar](2) NULL,
	[tr_date] [smalldatetime] NULL,
	[tr_scode] [varchar](5) NULL,
	[send_date] [smalldatetime] NULL,
	[branch] [char](1) NULL,
	[dept] [char](1) NULL,
	[case_no] [varchar](10) NULL,
	[rs_no] [varchar](10) NULL,
	[seq] [int] NULL,
	[seq1] [varchar](3) NULL,
	[country] [varchar](2) NULL,
	[cust_seq] [int] NULL,
	[scode] [varchar](5) NULL,
	[case_arcase] [varchar](4) NULL,
	[arcase] [varchar](10) NULL,
	[ar_mark] [char](1) NULL,
	[tr_money] [decimal](11, 2) NULL,
	[mtr_money] [decimal](11, 2) NULL,
	[chk_type] [char](1) NULL,
	[chk_date] [datetime] NULL,
	[plus_sqlno] [int] NULL,
	[mstat_flag] [varchar](2) NULL,
	[mstat_date] [smalldatetime] NULL,
	[msend_sqlno] [int] NULL,
	[mark] [char](1) NULL,
	[mtran_no] [varchar](12) NULL,
	[min_date] [datetime] NULL,
	[mprgid] [varchar](20) NULL,
 CONSTRAINT [PK_plus_temp] PRIMARY KEY CLUSTERED 
(
	[plus_temp_sqlno] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[plus_temp] ADD  CONSTRAINT [DF_plus_temp_class]  DEFAULT ('') FOR [class]
GO

ALTER TABLE [dbo].[plus_temp] ADD  CONSTRAINT [DF_plus_temp_tr_scode]  DEFAULT ('') FOR [tr_scode]
GO

ALTER TABLE [dbo].[plus_temp] ADD  CONSTRAINT [DF_plus_temp_branch]  DEFAULT ('') FOR [branch]
GO

ALTER TABLE [dbo].[plus_temp] ADD  CONSTRAINT [DF_plus_temp_dept]  DEFAULT ('') FOR [dept]
GO

ALTER TABLE [dbo].[plus_temp] ADD  CONSTRAINT [DF_plus_temp_case_no]  DEFAULT ('') FOR [case_no]
GO

ALTER TABLE [dbo].[plus_temp] ADD  CONSTRAINT [DF_plus_temp_rs_no]  DEFAULT ('') FOR [rs_no]
GO

ALTER TABLE [dbo].[plus_temp] ADD  CONSTRAINT [DF_plus_temp_seq]  DEFAULT ((0)) FOR [seq]
GO

ALTER TABLE [dbo].[plus_temp] ADD  CONSTRAINT [DF_plus_temp_seq1]  DEFAULT ('_') FOR [seq1]
GO

ALTER TABLE [dbo].[plus_temp] ADD  CONSTRAINT [DF_plus_temp_country]  DEFAULT ('') FOR [country]
GO

ALTER TABLE [dbo].[plus_temp] ADD  CONSTRAINT [DF_plus_temp_cust_seq]  DEFAULT ((0)) FOR [cust_seq]
GO

ALTER TABLE [dbo].[plus_temp] ADD  CONSTRAINT [DF_plus_temp_scode]  DEFAULT ('') FOR [scode]
GO

ALTER TABLE [dbo].[plus_temp] ADD  CONSTRAINT [DF_plus_temp_case_arcase]  DEFAULT ('') FOR [case_arcase]
GO

ALTER TABLE [dbo].[plus_temp] ADD  CONSTRAINT [DF_plus_temp_arcase]  DEFAULT ('') FOR [arcase]
GO

ALTER TABLE [dbo].[plus_temp] ADD  CONSTRAINT [DF_plus_temp_ar_mark]  DEFAULT ('') FOR [ar_mark]
GO

ALTER TABLE [dbo].[plus_temp] ADD  CONSTRAINT [DF_plus_temp_tr_money]  DEFAULT ((0)) FOR [tr_money]
GO

ALTER TABLE [dbo].[plus_temp] ADD  CONSTRAINT [DF_plus_temp_mtr_money]  DEFAULT ((0)) FOR [mtr_money]
GO

ALTER TABLE [dbo].[plus_temp] ADD  CONSTRAINT [DF_plus_temp_chk_type]  DEFAULT ('') FOR [chk_type]
GO

ALTER TABLE [dbo].[plus_temp] ADD  CONSTRAINT [DF_plus_temp_plus_sqlno]  DEFAULT ((0)) FOR [plus_sqlno]
GO

ALTER TABLE [dbo].[plus_temp] ADD  CONSTRAINT [DF_plus_temp_mstat_flag]  DEFAULT ('') FOR [mstat_flag]
GO

ALTER TABLE [dbo].[plus_temp] ADD  CONSTRAINT [DF_plus_temp_msend_sqlno]  DEFAULT ((0)) FOR [msend_sqlno]
GO

ALTER TABLE [dbo].[plus_temp] ADD  CONSTRAINT [DF_plus_temp_mark]  DEFAULT ('') FOR [mark]
GO





69932	1	2014-12-27 00:00:00	n319	2014-12-29 00:00:00	N	P	14120334	GS14003479	25621	_	T	7221	n1304	WS11	AJ2	N	6100.00	6100.00	Y	2015-01-09 00:00:00.000	326888	YY	2014-12-29 00:00:00	154053	 	NULL	NULL	NULL
69933	1	2014-12-27 00:00:00	n319	2014-12-29 00:00:00	N	P	14120323	GS14003480	27184	_	T	2853	n100	WA3	AN5	D	1000.00	1000.00	Y	2015-01-09 00:00:00.000	326889	YY	2014-12-29 00:00:00	154054	 	NULL	NULL	NULL
69934	1	2014-12-27 00:00:00	n319	2014-12-29 00:00:00	N	P	14120322	GS14003481	27603	_	T	2853	n100	WA3	AN5	D	1000.00	1000.00	Y	2015-01-09 00:00:00.000	326890	YY	2014-12-29 00:00:00	154055	 	NULL	NULL	NULL
69935	1	2014-12-27 00:00:00	n319	2014-12-29 00:00:00	N	P	14110107	GS14003482	28135	_	T	7683	n650	UG1	AA3	N	3000.00	3000.00	Y	2015-01-09 00:00:00.000	326891	YY	2014-12-29 00:00:00	154056	 	NULL	NULL	NULL
69936	1	2014-12-29 00:00:00	n417	2014-12-29 00:00:00	N	T	14120374	GS00033413	65379	_	T	15731	n646	FF0	FF0	N	2500.00	2500.00	Y	2015-01-09 00:00:00.000	326893	YY	2014-12-29 00:00:00	112715	 	NULL	NULL	NULL
69937	1	2014-12-29 00:00:00	n417	2014-12-29 00:00:00	N	T	14120349	GS00033414	65540	_	T	14211	n1384	FD1	FD1	N	2000.00	2000.00	Y	2015-01-09 00:00:00.000	326894	YY	2014-12-29 00:00:00	112716	 	NULL	NULL	NULL
69938	1	2014-12-29 00:00:00	n319	2014-12-29 00:00:00	N	P	14110115	GS14003484	28129	_	T	14289	n113	UG1	AA3	N	3000.00	3000.00	Y	2015-01-09 00:00:00.000	326892	YY	2014-12-29 00:00:00	154058	 	NULL	NULL	NULL
69939	1	2014-12-29 00:00:00	n319	2014-12-30 00:00:00	N	P	14120329	GS14003486	27744	_	T	14469	n1293	WS11	AJ2	N	2700.00	2700.00	Y	2015-01-12 00:00:00.000	326941	YY	2014-12-30 00:00:00	154118	 	NULL	NULL	NULL
69940	1	2014-12-29 00:00:00	n319	2014-12-30 00:00:00	N	P	14120341	GS14003487	27906	_	T	15790	n1304	WS11	AJ2	N	6100.00	6100.00	Y	2015-01-12 00:00:00.000	326942	YY	2014-12-30 00:00:00	154119	 	NULL	NULL	NULL
69941	1	2014-12-29 00:00:00	n319	2014-12-30 00:00:00	N	P	14120352	GS14003489	28058	_	T	15841	n1293	WS11	AJ2	N	6100.00	6100.00	Y	2015-01-12 00:00:00.000	326943	YY	2014-12-30 00:00:00	154121	 	NULL	NULL	NULL
69942	1	2014-12-29 00:00:00	n417	2014-12-30 00:00:00	N	T	14120408	GS00033418	65458	_	T	11939	n547	FF0	FF0	N	5000.00	5000.00	Y	2015-01-12 00:00:00.000	326951	YY	2014-12-30 00:00:00	112786	 	NULL	NULL	NULL
69943	1	2014-12-29 00:00:00	n417	2014-12-30 00:00:00	N	T	14120402	GS00033419	65423	_	T	14892	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-01-12 00:00:00.000	326952	YY	2014-12-30 00:00:00	112790	 	NULL	NULL	NULL
69944	1	2014-12-29 00:00:00	n417	2014-12-30 00:00:00	N	T	14120401	GS00033420	65376	_	T	13176	n428	FF0	FF0	N	5000.00	5000.00	Y	2015-01-12 00:00:00.000	326953	YY	2014-12-30 00:00:00	112791	 	NULL	NULL	NULL
69945	1	2014-12-29 00:00:00	n417	2014-12-30 00:00:00	N	T	14120396	GS00033421	65523	_	T	15480	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-01-12 00:00:00.000	326954	YY	2014-12-30 00:00:00	112792	 	NULL	NULL	NULL
69946	1	2014-12-29 00:00:00	n417	2014-12-30 00:00:00	N	T	14120395	GS00033422	65522	_	T	15480	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-01-12 00:00:00.000	326955	YY	2014-12-30 00:00:00	112793	 	NULL	NULL	NULL
69947	1	2014-12-29 00:00:00	n417	2014-12-30 00:00:00	N	T	14120400	GS00033423	65521	_	T	15480	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-01-12 00:00:00.000	326956	YY	2014-12-30 00:00:00	112794	 	NULL	NULL	NULL
69948	1	2014-12-29 00:00:00	n417	2014-12-30 00:00:00	N	T	14120399	GS00033424	65245	_	T	15480	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-01-12 00:00:00.000	326957	YY	2014-12-30 00:00:00	112795	 	NULL	NULL	NULL
69949	1	2014-12-29 00:00:00	n417	2014-12-30 00:00:00	N	T	14120383	GS00033425	66026	_	T	1646	n428	FE1	FE1	N	2400.00	2400.00	Y	2015-01-12 00:00:00.000	326958	YE	2014-12-30 00:00:00	112796	 	NULL	NULL	NULL
69950	1	2014-12-29 00:00:00	n417	2014-12-30 00:00:00	N	T	14120384	GS00033426	66027	_	T	1646	n428	FE1	FE1	N	2400.00	2400.00	Y	2015-01-12 00:00:00.000	326959	YE	2014-12-30 00:00:00	112797	 	NULL	NULL	NULL
69951	1	2014-12-29 00:00:00	n417	2014-12-30 00:00:00	N	T	14120409	GS00033427	66041	_	T	14650	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-01-12 00:00:00.000	326960	YE	2014-12-30 00:00:00	112801	 	NULL	NULL	NULL
69952	1	2014-12-29 00:00:00	n319	2014-12-30 00:00:00	N	P	14120349	GS14003490	20646	_	T	12406	n650	WS21	AK3	N	3800.00	3800.00	Y	2015-01-12 00:00:00.000	326944	YY	2014-12-30 00:00:00	154126	 	NULL	NULL	NULL
69953	1	2014-12-29 00:00:00	n319	2014-12-30 00:00:00	N	P	14120181	GS14003492	28212	_	T	13042	n650	IG1B	AA21	N	9700.00	9700.00	Y	2015-01-12 00:00:00.000	326945	YY	2014-12-30 00:00:00	154128	 	NULL	NULL	NULL
69954	1	2014-12-30 00:00:00	n417	2014-12-30 00:00:00	N	T	14120385	GS00033428	66028	_	T	6857	n428	FE1	FE1	N	2400.00	2400.00	Y	2015-01-12 00:00:00.000	326961	YE	2014-12-30 00:00:00	112810	 	NULL	NULL	NULL
69955	1	2014-12-30 00:00:00	n417	2014-12-30 00:00:00	N	T	14120386	GS00033429	66029	_	T	6857	n428	FE1	FE1	N	2400.00	2400.00	Y	2015-01-12 00:00:00.000	326962	YE	2014-12-30 00:00:00	112811	 	NULL	NULL	NULL
69956	1	2014-12-30 00:00:00	n417	2014-12-30 00:00:00	N	T	14120387	GS00033430	66030	_	T	6857	n428	FE1	FE1	N	2400.00	2400.00	Y	2015-01-12 00:00:00.000	326963	YE	2014-12-30 00:00:00	112812	 	NULL	NULL	NULL
69957	1	2014-12-30 00:00:00	n417	2014-12-30 00:00:00	N	T	14120388	GS00033431	66031	_	T	6857	n428	FE1	FE1	N	2400.00	2400.00	Y	2015-01-12 00:00:00.000	326964	YE	2014-12-30 00:00:00	112813	 	NULL	NULL	NULL
69958	1	2014-12-30 00:00:00	n417	2014-12-30 00:00:00	N	T	14120389	GS00033432	66032	_	T	6857	n428	FE1	FE1	N	2400.00	2400.00	Y	2015-01-12 00:00:00.000	326965	YE	2014-12-30 00:00:00	112814	 	NULL	NULL	NULL
69959	1	2014-12-30 00:00:00	n417	2014-12-30 00:00:00	N	T	14120390	GS00033433	66033	_	T	6857	n428	FE1	FE1	N	2400.00	2400.00	Y	2015-01-12 00:00:00.000	326966	YE	2014-12-30 00:00:00	112815	 	NULL	NULL	NULL
69960	1	2014-12-30 00:00:00	n417	2014-12-30 00:00:00	N	T	14120391	GS00033434	66034	_	T	6857	n428	FE1	FE1	N	2400.00	2400.00	Y	2015-01-12 00:00:00.000	326967	YE	2014-12-30 00:00:00	112816	 	NULL	NULL	NULL
69961	1	2014-12-30 00:00:00	n417	2014-12-30 00:00:00	N	T	14120375	GS00033435	66023	_	T	12033	n441	FE11	FE11	N	2700.00	2700.00	Y	2015-01-12 00:00:00.000	326968	YE	2014-12-30 00:00:00	112817	 	NULL	NULL	NULL
69962	1	2014-12-30 00:00:00	n417	2014-12-30 00:00:00	N	T	14120376	GS00033436	66024	_	T	12033	n441	FE11	FE11	N	2700.00	2700.00	Y	2015-01-12 00:00:00.000	326969	YE	2014-12-30 00:00:00	112818	 	NULL	NULL	NULL
69963	1	2014-12-30 00:00:00	n417	2014-12-30 00:00:00	N	T	14120403	GS00033437	66035	_	T	12033	n441	FE1	FE1	N	2400.00	2400.00	Y	2015-01-12 00:00:00.000	326970	YE	2014-12-30 00:00:00	112819	 	NULL	NULL	NULL
69964	1	2014-12-30 00:00:00	n417	2014-12-30 00:00:00	N	T	14120378	GS00033438	66036	_	T	12033	n441	FE11	FE11	N	2700.00	2700.00	Y	2015-01-12 00:00:00.000	326971	YE	2014-12-30 00:00:00	112820	 	NULL	NULL	NULL
69965	1	2014-12-30 00:00:00	n417	2014-12-30 00:00:00	N	T	14120404	GS00033439	66037	_	T	12033	n441	FE1	FE1	N	2400.00	2400.00	Y	2015-01-12 00:00:00.000	326972	YE	2014-12-30 00:00:00	112821	 	NULL	NULL	NULL
69966	1	2014-12-30 00:00:00	n417	2014-12-30 00:00:00	N	T	14120405	GS00033440	66038	_	T	12033	n441	FE1	FE1	N	2400.00	2400.00	Y	2015-01-12 00:00:00.000	326973	YE	2014-12-30 00:00:00	112822	 	NULL	NULL	NULL
69967	1	2014-12-30 00:00:00	n417	2014-12-30 00:00:00	N	T	14120407	GS00033441	66039	_	T	12033	n441	FE1	FE1	N	2400.00	2400.00	Y	2015-01-12 00:00:00.000	326974	YE	2014-12-30 00:00:00	112823	 	NULL	NULL	NULL
69968	1	2014-12-30 00:00:00	n417	2014-12-30 00:00:00	N	T	14120406	GS00033442	66040	_	T	12033	n441	FE1	FE1	N	2400.00	2400.00	Y	2015-01-12 00:00:00.000	326975	YE	2014-12-30 00:00:00	112824	 	NULL	NULL	NULL
69969	1	2014-12-30 00:00:00	n319	2014-12-30 00:00:00	N	P	14080154	GS14003494	27922	_	T	4610	n994	IG1B	AA21	N	9700.00	9700.00	Y	2015-01-12 00:00:00.000	326946	YY	2014-12-30 00:00:00	154130	 	NULL	NULL	NULL
69970	1	2014-12-30 00:00:00	n319	2014-12-30 00:00:00	N	P	14120324	GS14003495	28013	_	T	15252	n1304	WS11	AJ2	N	6100.00	6100.00	Y	2015-01-12 00:00:00.000	326947	YY	2014-12-30 00:00:00	154131	 	NULL	NULL	NULL
69971	1	2014-12-30 00:00:00	n319	2014-12-30 00:00:00	N	P	14100338	GS14003496	28103	_	T	15609	n1065	UG1	AA3	N	3000.00	3000.00	N	NULL	0	XX	2014-12-30 00:00:00	154132	 	NULL	NULL	NULL
69972	1	2014-12-30 00:00:00	n319	2014-12-30 00:00:00	N	P	14120357	GS14003498	26034	_	T	15092	n650	WS1	AJ1	N	3500.00	3500.00	Y	2015-01-12 00:00:00.000	326948	YY	2014-12-30 00:00:00	154134	 	NULL	NULL	NULL
69973	1	2014-12-30 00:00:00	n319	2014-12-30 00:00:00	N	P	14120360	GS14003499	28015	_	T	15252	n1304	WS11	AJ2	N	6100.00	6100.00	Y	2015-01-12 00:00:00.000	326949	YY	2014-12-30 00:00:00	154135	 	NULL	NULL	NULL
69974	1	2014-12-30 00:00:00	n319	2014-12-30 00:00:00	N	P	14100164	GS14003501	28072	_	T	4610	n994	IG1B	AA21	N	9700.00	9700.00	Y	2015-01-12 00:00:00.000	326950	YY	2014-12-30 00:00:00	154137	 	NULL	NULL	NULL
69975	1	2014-12-31 00:00:00	n319	2014-12-31 00:00:00	N	P	14120373	GS14003506	25451	_	T	14633	n1304	WS21	AK3	N	2800.00	2800.00	Y	2015-01-12 00:00:00.000	326976	YY	2014-12-31 00:00:00	154217	 	NULL	NULL	NULL
69976	1	2014-12-31 00:00:00	n319	2014-12-31 00:00:00	N	P	14120369	GS14003508	26229	_	T	12498	n113	WS11	AJ2	N	6100.00	6100.00	Y	2015-01-12 00:00:00.000	326977	YY	2014-12-31 00:00:00	154219	 	NULL	NULL	NULL
69977	1	2014-12-31 00:00:00	n319	2014-12-31 00:00:00	N	P	14120361	GS14003510	27972	_	T	12548	n896	WS11	AJ2	N	6100.00	6100.00	Y	2015-01-12 00:00:00.000	326978	YY	2014-12-31 00:00:00	154221	 	NULL	NULL	NULL
69978	1	2014-12-31 00:00:00	n319	2014-12-31 00:00:00	N	P	14120376	GS14003511	27989	_	T	10747	n1065	AC2	AA2	N	2400.00	2400.00	Y	2015-01-12 00:00:00.000	326979	YY	2014-12-31 00:00:00	154222	 	NULL	NULL	NULL
69979	1	2014-12-31 00:00:00	n319	2014-12-31 00:00:00	N	P	14120365	GS14003514	27996	_	T	15820	n896	WS11	AJ2	N	6100.00	6100.00	Y	2015-01-12 00:00:00.000	326980	YY	2014-12-31 00:00:00	154225	 	NULL	NULL	NULL
69980	1	2014-12-31 00:00:00	n319	2014-12-31 00:00:00	N	P	14100384	GS14003515	28114	_	T	13712	n896	IG1E	AA2	N	10500.00	10500.00	Y	2015-01-12 00:00:00.000	326981	YY	2014-12-31 00:00:00	154226	 	NULL	NULL	NULL
69981	1	2014-12-31 00:00:00	n319	2014-12-31 00:00:00	N	P	12100296	GS14003517	26404	_	T	15145	n113	IG1E	AA2	N	10500.00	13700.00	Y	2015-01-12 00:00:00.000	326982	YY	2014-12-31 00:00:00	154228	 	NULL	NULL	NULL
69982	1	2014-12-31 00:00:00	n319	2014-12-31 00:00:00	N	P	14120379	GS14003517	26404	_	T	15145	n113	AC2	AA2	N	3200.00	13700.00	Y	2015-01-12 00:00:00.000	326983	YY	2014-12-31 00:00:00	154228	 	NULL	NULL	NULL
69983	1	2014-12-31 00:00:00	n319	2014-12-31 00:00:00	N	P	14060079	GS14003519	27729	_	T	2853	n100	IG1E	AA2	N	10500.00	19300.00	Y	2015-01-12 00:00:00.000	326984	YY	2014-12-31 00:00:00	154230	 	NULL	NULL	NULL
69984	1	2014-12-31 00:00:00	n319	2014-12-31 00:00:00	N	P	14120382	GS14003519	27729	_	T	2853	n100	AC2	AA2	N	8800.00	19300.00	Y	2015-01-12 00:00:00.000	326985	YY	2014-12-31 00:00:00	154230	 	NULL	NULL	NULL
69985	1	2014-12-31 00:00:00	n319	2014-12-31 00:00:00	N	P	14120050	GS14003521	28182	_	T	15569	n994	IG1B	AA21	N	9700.00	11300.00	Y	2015-01-12 00:00:00.000	326986	YY	2014-12-31 00:00:00	154306	 	NULL	NULL	NULL
69986	1	2014-12-31 00:00:00	n319	2014-12-31 00:00:00	N	P	14120394	GS14003521	28182	_	T	15569	n994	AC2	AA21	N	1600.00	11300.00	Y	2015-01-12 00:00:00.000	326987	YY	2014-12-31 00:00:00	154306	 	NULL	NULL	NULL
69987	1	2015-01-05 00:00:00	n417	2015-01-05 00:00:00	N	T	14120417	GS00033448	65384	_	T	12082	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-01-12 00:00:00.000	326989	YY	2015-01-05 00:00:00	112966	 	NULL	NULL	NULL
69988	1	2015-01-05 00:00:00	n417	2015-01-05 00:00:00	N	T	14120416	GS00033449	65383	_	T	12082	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-01-12 00:00:00.000	326990	YY	2015-01-05 00:00:00	112967	 	NULL	NULL	NULL
69989	1	2015-01-05 00:00:00	n417	2015-01-05 00:00:00	N	T	14120418	GS00033450	65606	_	T	2507	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-01-12 00:00:00.000	326991	YY	2015-01-05 00:00:00	112968	 	NULL	NULL	NULL
69990	1	2015-01-05 00:00:00	n417	2015-01-05 00:00:00	N	T	14080038	GS00033451	64387	_	T	7775	n1350	FR1	FR1	N	4000.00	4000.00	Y	2015-01-12 00:00:00.000	326992	YY	2015-01-05 00:00:00	112969	 	NULL	NULL	NULL
69991	1	2015-01-05 00:00:00	n417	2015-01-05 00:00:00	N	T	14080039	GS00033452	64401	_	T	7775	n1350	FR1	FR1	N	4000.00	4000.00	Y	2015-01-12 00:00:00.000	326993	YY	2015-01-05 00:00:00	112971	 	NULL	NULL	NULL
69992	1	2015-01-05 00:00:00	n417	2015-01-05 00:00:00	N	T	14080040	GS00033453	64402	_	T	7775	n1350	FR1	FR1	N	4000.00	4000.00	Y	2015-01-12 00:00:00.000	326994	YY	2015-01-05 00:00:00	112972	 	NULL	NULL	NULL
69993	1	2015-01-05 00:00:00	n417	2015-01-05 00:00:00	N	T	14080041	GS00033454	64403	_	T	7775	n1350	FR1	FR1	N	4000.00	4000.00	Y	2015-01-12 00:00:00.000	326995	YY	2015-01-05 00:00:00	112973	 	NULL	NULL	NULL
69994	1	2015-01-05 00:00:00	n417	2015-01-05 00:00:00	N	T	14120413	GS00033455	66042	_	T	15348	n530	FE1	FE1	N	2400.00	2400.00	Y	2015-01-12 00:00:00.000	326996	YE	2015-01-05 00:00:00	112974	 	NULL	NULL	NULL
69995	1	2015-01-05 00:00:00	n417	2015-01-05 00:00:00	N	T	14120414	GS00033456	66043	_	T	15348	n530	FE1	FE1	N	2400.00	2400.00	Y	2015-01-12 00:00:00.000	326997	YE	2015-01-05 00:00:00	112975	 	NULL	NULL	NULL
69996	1	2015-01-05 00:00:00	n417	2015-01-05 00:00:00	N	T	14120415	GS00033457	66044	_	T	15348	n530	FE1	FE1	N	2400.00	2400.00	Y	2015-01-12 00:00:00.000	326998	YE	2015-01-05 00:00:00	112976	 	NULL	NULL	NULL
69997	1	2015-01-05 00:00:00	n417	2015-01-06 00:00:00	N	T	15010007	GS00033458	65734	_	T	15686	n646	FF0	FF0	N	10000.00	10000.00	Y	2015-01-12 00:00:00.000	327012	YY	2015-01-06 00:00:00	113001	 	NULL	NULL	NULL
69998	1	2015-01-05 00:00:00	n417	2015-01-06 00:00:00	N	T	15010001	GS00033459	65375	_	T	15722	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-01-12 00:00:00.000	327013	YY	2015-01-06 00:00:00	113002	 	NULL	NULL	NULL
69999	1	2015-01-05 00:00:00	n417	2015-01-06 00:00:00	N	T	15010008	GS00033460	65356	_	T	13821	n646	FF0	FF0	N	2500.00	2500.00	Y	2015-01-12 00:00:00.000	327014	YY	2015-01-06 00:00:00	113003	 	NULL	NULL	NULL
70000	1	2015-01-05 00:00:00	n417	2015-01-06 00:00:00	N	T	15010009	GS00033461	65357	_	T	13821	n646	FF0	FF0	N	2500.00	2500.00	Y	2015-01-12 00:00:00.000	327015	YY	2015-01-06 00:00:00	113004	 	NULL	NULL	NULL
70001	1	2015-01-05 00:00:00	n417	2015-01-06 00:00:00	N	T	14120419	GS00033462	66045	_	T	14059	n530	FE1	FE1	N	2400.00	2400.00	Y	2015-01-12 00:00:00.000	327016	YE	2015-01-06 00:00:00	113027	 	NULL	NULL	NULL
70002	1	2015-01-06 00:00:00	n417	2015-01-06 00:00:00	N	T	15010045	GS00033463	65196	_	T	14993	n1350	FF0	FF0	N	2500.00	2500.00	Y	2015-01-12 00:00:00.000	327017	YY	2015-01-06 00:00:00	113031	 	NULL	NULL	NULL
70003	1	2015-01-06 00:00:00	n417	2015-01-07 00:00:00	N	T	15010047	GS00033467	65526	_	T	15348	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-01-14 00:00:00.000	327064	YY	2015-01-07 00:00:00	113163	 	NULL	NULL	NULL
70004	1	2015-01-06 00:00:00	n417	2015-01-07 00:00:00	N	T	15010048	GS00033468	65527	_	T	15348	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-01-14 00:00:00.000	327065	YY	2015-01-07 00:00:00	113164	 	NULL	NULL	NULL
70005	1	2015-01-06 00:00:00	n417	2015-01-07 00:00:00	N	T	15010072	GS00033469	39211	_	T	7117	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-01-14 00:00:00.000	327066	YY	2015-01-07 00:00:00	113165	 	NULL	NULL	NULL
70006	1	2015-01-07 00:00:00	n417	2015-01-07 00:00:00	N	T	15010010	GS00033471	66046	_	T	12130	n646	FN1	FN1	N	500.00	500.00	Y	2015-01-14 00:00:00.000	327067	YY	2015-01-07 00:00:00	113167	 	NULL	NULL	NULL
70007	1	2015-01-07 00:00:00	n417	2015-01-07 00:00:00	N	T	15010049	GS00033472	66060	_	T	13605	n646	FT1	FT1	N	2000.00	2000.00	Y	2015-01-14 00:00:00.000	327068	YY	2015-01-07 00:00:00	113168	 	NULL	NULL	NULL
70008	1	2015-01-07 00:00:00	n417	2015-01-07 00:00:00	N	T	15010087	GS00033473	64516	_	T	4837	n547	FF0	FF0	N	2500.00	2500.00	Y	2015-01-14 00:00:00.000	327069	YY	2015-01-07 00:00:00	113169	 	NULL	NULL	NULL
70009	1	2015-01-07 00:00:00	n417	2015-01-07 00:00:00	N	T	15010039	GS00033474	66047	_	T	14800	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-01-14 00:00:00.000	327070	YY	2015-01-07 00:00:00	113170	 	NULL	NULL	NULL
70010	1	2015-01-07 00:00:00	n417	2015-01-07 00:00:00	N	T	15010040	GS00033475	66048	_	T	14800	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-01-14 00:00:00.000	327071	YY	2015-01-07 00:00:00	113171	 	NULL	NULL	NULL
70011	1	2015-01-07 00:00:00	n417	2015-01-07 00:00:00	N	T	15010041	GS00033476	66049	_	T	14800	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-01-14 00:00:00.000	327072	YY	2015-01-07 00:00:00	113172	 	NULL	NULL	NULL
70012	1	2015-01-07 00:00:00	n417	2015-01-07 00:00:00	N	T	15010042	GS00033477	66050	_	T	14800	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-01-14 00:00:00.000	327073	YY	2015-01-07 00:00:00	113173	 	NULL	NULL	NULL
70013	1	2015-01-07 00:00:00	n417	2015-01-07 00:00:00	N	T	15010043	GS00033478	66051	_	T	14800	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-01-14 00:00:00.000	327074	YY	2015-01-07 00:00:00	113174	 	NULL	NULL	NULL
70014	1	2015-01-07 00:00:00	n417	2015-01-07 00:00:00	N	T	15010044	GS00033479	66052	_	T	14800	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-01-14 00:00:00.000	327075	YY	2015-01-07 00:00:00	113175	 	NULL	NULL	NULL
70015	1	2015-01-07 00:00:00	n417	2015-01-07 00:00:00	N	T	15010032	GS00033480	66053	_	T	6836	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-01-14 00:00:00.000	327076	YY	2015-01-07 00:00:00	113176	 	NULL	NULL	NULL
70016	1	2015-01-07 00:00:00	n417	2015-01-07 00:00:00	N	T	15010033	GS00033481	66054	_	T	6836	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-01-14 00:00:00.000	327077	YY	2015-01-07 00:00:00	113177	 	NULL	NULL	NULL
70017	1	2015-01-07 00:00:00	n417	2015-01-07 00:00:00	N	T	15010034	GS00033482	66055	_	T	6836	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-01-14 00:00:00.000	327078	YY	2015-01-07 00:00:00	113178	 	NULL	NULL	NULL
70018	1	2015-01-07 00:00:00	n417	2015-01-07 00:00:00	N	T	15010035	GS00033483	66056	_	T	6836	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-01-14 00:00:00.000	327079	YY	2015-01-07 00:00:00	113179	 	NULL	NULL	NULL
70019	1	2015-01-07 00:00:00	n417	2015-01-07 00:00:00	N	T	15010036	GS00033484	66057	_	T	6836	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-01-14 00:00:00.000	327080	YY	2015-01-07 00:00:00	113180	 	NULL	NULL	NULL
70020	1	2015-01-07 00:00:00	n417	2015-01-07 00:00:00	N	T	15010037	GS00033485	66058	_	T	6836	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-01-14 00:00:00.000	327081	YY	2015-01-07 00:00:00	113181	 	NULL	NULL	NULL
70021	1	2015-01-07 00:00:00	n417	2015-01-07 00:00:00	N	T	15010050	GS00033486	66059	_	T	15907	n646	FE1	FE1	N	2400.00	2400.00	Y	2015-01-14 00:00:00.000	327082	YE	2015-01-07 00:00:00	113182	 	NULL	NULL	NULL
70022	1	2014-12-31 00:00:00	n319	2015-01-05 00:00:00	N	P	14120029	GS15000001	27779	_	T	11910	n1125	FR1	AB1	N	7000.00	0.00	Y	2015-01-12 00:00:00.000	326988	YY	2015-01-05 00:00:00	154311	 	NULL	NULL	NULL
70023	1	2015-01-06 00:00:00	n319	2015-01-06 00:00:00	N	P	15010001	GS15000005	23403	_	T	437	n1293	WS21	AK3	N	2800.00	0.00	Y	2015-01-12 00:00:00.000	326999	YY	2015-01-06 00:00:00	154393	 	NULL	NULL	NULL
70024	1	2015-01-06 00:00:00	n319	2015-01-06 00:00:00	N	P	15010006	GS15000006	24224	_	T	13472	n1304	WS1	AJ1	N	8500.00	0.00	Y	2015-01-12 00:00:00.000	327000	YY	2015-01-06 00:00:00	154394	 	NULL	NULL	NULL
70025	1	2015-01-06 00:00:00	n319	2015-01-06 00:00:00	N	P	15010004	GS15000007	24413	_	T	13472	n1304	WS1	AJ1	N	8500.00	0.00	Y	2015-01-12 00:00:00.000	327001	YY	2015-01-06 00:00:00	154395	 	NULL	NULL	NULL
70026	1	2015-01-06 00:00:00	n319	2015-01-06 00:00:00	N	P	15010005	GS15000008	24433	_	T	13472	n1304	WS1	AJ1	N	8500.00	0.00	Y	2015-01-12 00:00:00.000	327002	YY	2015-01-06 00:00:00	154396	 	NULL	NULL	NULL
70027	1	2015-01-06 00:00:00	n319	2015-01-06 00:00:00	N	P	15010003	GS15000009	26116	_	T	13472	n1304	WS1	AJ1	N	8500.00	0.00	Y	2015-01-12 00:00:00.000	327003	YY	2015-01-06 00:00:00	154397	 	NULL	NULL	NULL
70028	1	2015-01-06 00:00:00	n319	2015-01-06 00:00:00	N	P	14120353	GS15000016	27453	_	T	15606	n1293	WA3	AN5	D	1000.00	0.00	Y	2015-01-12 00:00:00.000	327004	YY	2015-01-06 00:00:00	154404	 	NULL	NULL	NULL
70029	1	2015-01-06 00:00:00	n319	2015-01-06 00:00:00	N	P	15010012	GS15000017	27829	_	T	10747	n1065	WS1	AJ1	N	8500.00	0.00	Y	2015-01-12 00:00:00.000	327005	YY	2015-01-06 00:00:00	154405	 	NULL	NULL	NULL
70030	1	2015-01-06 00:00:00	n319	2015-01-06 00:00:00	N	P	15010002	GS15000018	28063	_	T	15430	n1293	WS11	AJ2	N	2700.00	0.00	Y	2015-01-12 00:00:00.000	327006	YY	2015-01-06 00:00:00	154406	 	NULL	NULL	NULL
70031	1	2015-01-06 00:00:00	n319	2015-01-06 00:00:00	N	P	14120056	GS15000020	28185	_	T	15884	n1065	UG1	AA3	N	3000.00	0.00	Y	2015-01-12 00:00:00.000	327007	YY	2015-01-06 00:00:00	154408	 	NULL	NULL	NULL
70032	1	2015-01-06 00:00:00	n319	2015-01-06 00:00:00	N	P	14120183	GS15000022	28213	_	T	15897	n1065	UG1	AA3	N	3000.00	0.00	Y	2015-01-12 00:00:00.000	327008	YY	2015-01-06 00:00:00	154410	 	NULL	NULL	NULL
70033	1	2015-01-06 00:00:00	n319	2015-01-06 00:00:00	N	P	14120368	GS15000023	1029	M	T	12293	n113	WS2	AK2	X	16000.00	0.00	Y	2015-01-12 00:00:00.000	327009	YE	2015-01-06 00:00:00	154411	 	NULL	NULL	NULL
70034	1	2015-01-06 00:00:00	n319	2015-01-06 00:00:00	N	P	14120372	GS15000024	17792	_	T	11966	n650	WS2	AK2	N	8000.00	0.00	Y	2015-01-12 00:00:00.000	327010	YE	2015-01-06 00:00:00	154412	 	NULL	NULL	NULL
70035	1	2015-01-06 00:00:00	n319	2015-01-06 00:00:00	N	P	14120370	GS15000025	21693	_	T	13362	n994	WS2	AK2	N	9000.00	0.00	Y	2015-01-12 00:00:00.000	327011	YE	2015-01-06 00:00:00	154413	 	NULL	NULL	NULL
70036	1	2015-01-07 00:00:00	n319	2015-01-07 00:00:00	N	P	15010019	GS15000028	27768	_	T	14633	n1304	WS11	AJ2	N	6100.00	0.00	Y	2015-01-14 00:00:00.000	327055	YY	2015-01-07 00:00:00	154501	 	NULL	NULL	NULL
70037	1	2015-01-07 00:00:00	n319	2015-01-07 00:00:00	N	P	15010014	GS15000029	25161	_	T	10747	n1065	WS1	AJ1	N	8500.00	0.00	Y	2015-01-14 00:00:00.000	327056	YY	2015-01-07 00:00:00	154502	 	NULL	NULL	NULL
70038	1	2015-01-07 00:00:00	n319	2015-01-07 00:00:00	N	P	15010015	GS15000030	25868	_	T	10747	n1065	WS1	AJ1	N	8500.00	0.00	Y	2015-01-14 00:00:00.000	327057	YY	2015-01-07 00:00:00	154503	 	NULL	NULL	NULL
70039	1	2015-01-07 00:00:00	n319	2015-01-07 00:00:00	N	P	15010016	GS15000031	26733	_	T	10747	n1065	WS1	AJ1	N	8500.00	0.00	Y	2015-01-14 00:00:00.000	327058	YY	2015-01-07 00:00:00	154504	 	NULL	NULL	NULL
70040	1	2015-01-07 00:00:00	n319	2015-01-07 00:00:00	N	P	15010013	GS15000032	27825	_	T	10747	n1065	WS1	AJ1	N	8500.00	0.00	Y	2015-01-14 00:00:00.000	327059	YY	2015-01-07 00:00:00	154505	 	NULL	NULL	NULL
70041	1	2015-01-07 00:00:00	n319	2015-01-07 00:00:00	N	P	14120163	GS15000033	28205	_	T	15851	n1293	DG1	AA4	N	3000.00	0.00	Y	2015-01-14 00:00:00.000	327060	YY	2015-01-07 00:00:00	154506	 	NULL	NULL	NULL
70042	1	2015-01-07 00:00:00	n319	2015-01-07 00:00:00	N	P	14110125	GS15000034	28137	_	T	15785	n113	IG1E	AA2	N	10500.00	0.00	Y	2015-01-14 00:00:00.000	327061	YY	2015-01-07 00:00:00	154507	 	NULL	NULL	NULL
70043	1	2015-01-07 00:00:00	n319	2015-01-07 00:00:00	N	P	15010052	GS15000036	23316	_	T	4785	n1486	WS21	AK3	N	34800.00	0.00	Y	2015-01-14 00:00:00.000	327062	YY	2015-01-07 00:00:00	154510	 	NULL	NULL	NULL
70044	1	2015-01-07 00:00:00	n319	2015-01-07 00:00:00	N	P	15010043	GS15000037	27729	_	T	2853	n100	WA3	AN5	D	1000.00	0.00	Y	2015-01-14 00:00:00.000	327063	YY	2015-01-07 00:00:00	154511	 	NULL	NULL	NULL
70045	1	2015-01-08 00:00:00	n417	2015-01-08 00:00:00	N	T	15010094	GS00033488	65162	_	T	15653	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-01-14 00:00:00.000	327095	YY	2015-01-08 00:00:00	113225	 	NULL	NULL	NULL
70046	1	2015-01-08 00:00:00	n417	2015-01-08 00:00:00	N	T	15010092	GS00033489	65160	_	T	15653	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-01-14 00:00:00.000	327096	YY	2015-01-08 00:00:00	113226	 	NULL	NULL	NULL
70047	1	2015-01-08 00:00:00	n417	2015-01-08 00:00:00	N	T	15010093	GS00033490	65161	_	T	15653	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-01-14 00:00:00.000	327097	YY	2015-01-08 00:00:00	113227	 	NULL	NULL	NULL
70048	1	2015-01-08 00:00:00	n417	2015-01-08 00:00:00	N	T	15010089	GS00033491	65138	_	T	15617	n646	FF0	FF0	N	20000.00	20000.00	Y	2015-01-14 00:00:00.000	327098	YY	2015-01-08 00:00:00	113228	 	NULL	NULL	NULL
70049	1	2015-01-08 00:00:00	n417	2015-01-08 00:00:00	N	T	15010090	GS00033492	65139	_	T	15617	n646	FF0	FF0	N	20000.00	20000.00	Y	2015-01-14 00:00:00.000	327099	YY	2015-01-08 00:00:00	113229	 	NULL	NULL	NULL
70050	1	2015-01-08 00:00:00	n417	2015-01-08 00:00:00	N	T	15010091	GS00033493	65141	_	T	15617	n646	FF0	FF0	N	20000.00	20000.00	Y	2015-01-14 00:00:00.000	327100	YY	2015-01-08 00:00:00	113230	 	NULL	NULL	NULL
70051	1	2015-01-08 00:00:00	n417	2015-01-08 00:00:00	N	T	15010051	GS00033494	52556	_	T	2855	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-01-14 00:00:00.000	327101	YY	2015-01-08 00:00:00	113231	 	NULL	NULL	NULL
70052	1	2015-01-08 00:00:00	n417	2015-01-08 00:00:00	N	T	15010052	GS00033495	52557	_	T	2855	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-01-14 00:00:00.000	327102	YY	2015-01-08 00:00:00	113232	 	NULL	NULL	NULL
70053	1	2015-01-08 00:00:00	n417	2015-01-08 00:00:00	N	T	15010053	GS00033496	52560	_	T	2855	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-01-14 00:00:00.000	327103	YY	2015-01-08 00:00:00	113233	 	NULL	NULL	NULL
70054	1	2015-01-08 00:00:00	n417	2015-01-08 00:00:00	N	T	15010054	GS00033497	52555	_	T	2855	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-01-14 00:00:00.000	327104	YY	2015-01-08 00:00:00	113234	 	NULL	NULL	NULL
70055	1	2015-01-08 00:00:00	n417	2015-01-08 00:00:00	N	T	15010055	GS00033498	52558	_	T	2855	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-01-14 00:00:00.000	327105	YY	2015-01-08 00:00:00	113235	 	NULL	NULL	NULL
70056	1	2015-01-08 00:00:00	n417	2015-01-08 00:00:00	N	T	15010056	GS00033499	52559	_	T	2855	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-01-14 00:00:00.000	327106	YY	2015-01-08 00:00:00	113236	 	NULL	NULL	NULL
70057	1	2015-01-08 00:00:00	n417	2015-01-08 00:00:00	N	T	15010057	GS00033500	52565	_	T	2855	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-01-14 00:00:00.000	327107	YY	2015-01-08 00:00:00	113237	 	NULL	NULL	NULL
70058	1	2015-01-08 00:00:00	n417	2015-01-08 00:00:00	N	T	15010058	GS00033501	52566	_	T	2855	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-01-14 00:00:00.000	327108	YY	2015-01-08 00:00:00	113238	 	NULL	NULL	NULL
70059	1	2015-01-08 00:00:00	n417	2015-01-08 00:00:00	N	T	15010059	GS00033502	52567	_	T	2855	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-01-14 00:00:00.000	327109	YY	2015-01-08 00:00:00	113239	 	NULL	NULL	NULL
70060	1	2015-01-08 00:00:00	n417	2015-01-08 00:00:00	N	T	15010060	GS00033503	52563	_	T	2855	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-01-14 00:00:00.000	327110	YY	2015-01-08 00:00:00	113240	 	NULL	NULL	NULL
70061	1	2015-01-08 00:00:00	n417	2015-01-08 00:00:00	N	T	15010061	GS00033504	52562	_	T	2855	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-01-14 00:00:00.000	327111	YY	2015-01-08 00:00:00	113241	 	NULL	NULL	NULL
70062	1	2015-01-08 00:00:00	n417	2015-01-08 00:00:00	N	T	15010062	GS00033505	52564	_	T	2855	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-01-14 00:00:00.000	327112	YY	2015-01-08 00:00:00	113242	 	NULL	NULL	NULL
70063	1	2015-01-08 00:00:00	n417	2015-01-08 00:00:00	N	T	15010063	GS00033506	52561	_	T	2855	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-01-14 00:00:00.000	327113	YY	2015-01-08 00:00:00	113243	 	NULL	NULL	NULL
70064	1	2015-01-08 00:00:00	n417	2015-01-08 00:00:00	N	T	15010064	GS00033507	53251	_	T	2855	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-01-14 00:00:00.000	327114	YY	2015-01-08 00:00:00	113244	 	NULL	NULL	NULL
70065	1	2015-01-08 08:47:00	n319	2015-01-08 00:00:00	N	P	15010026	GS15000040	25622	_	T	7221	n1304	WS21	AK3	N	8400.00	8400.00	Y	2015-01-14 00:00:00.000	327083	YY	2015-01-08 00:00:00	154587	 	NULL	NULL	NULL
70066	1	2015-01-08 08:48:00	n319	2015-01-08 00:00:00	N	P	15010027	GS15000041	25622	_	T	7221	n1304	LM3	AN2	N	5000.00	5000.00	Y	2015-01-14 00:00:00.000	327084	YY	2015-01-08 00:00:00	154588	 	NULL	NULL	NULL
70067	1	2015-01-08 08:51:00	n319	2015-01-08 00:00:00	N	P	15010068	GS15000042	25797	_	T	14798	n994	IGEA	AA6	N	31200.00	31200.00	Y	2015-01-14 00:00:00.000	327085	YY	2015-01-08 00:00:00	154589	 	NULL	NULL	NULL
70068	1	2015-01-08 08:56:00	n319	2015-01-08 00:00:00	N	P	15010062	GS15000044	27087	_	T	12082	n650	WS21	AK3	N	3400.00	3400.00	Y	2015-01-14 00:00:00.000	327086	YY	2015-01-08 00:00:00	154591	 	NULL	NULL	NULL
70070	1	2015-01-08 08:59:00	n319	2015-01-08 00:00:00	N	P	14120247	GS15000045	27716	_	T	12556	n650	WA3	AN5	D	1000.00	1000.00	Y	2015-01-14 00:00:00.000	327087	YY	2015-01-08 00:00:00	154592	 	NULL	NULL	NULL
70071	1	2015-01-08 08:59:00	n319	2015-01-08 00:00:00	N	P	14120248	GS15000046	27754	_	T	12556	n650	WA3	AN5	D	1000.00	1000.00	Y	2015-01-14 00:00:00.000	327088	YY	2015-01-08 00:00:00	154593	 	NULL	NULL	NULL
70072	1	2015-01-08 09:02:00	n319	2015-01-08 00:00:00	N	P	15010033	GS15000047	27894	_	T	14737	n650	WA3	AN5	D	1000.00	1000.00	Y	2015-01-14 00:00:00.000	327089	YY	2015-01-08 00:00:00	154594	 	NULL	NULL	NULL
70073	1	2015-01-08 09:02:00	n319	2015-01-08 00:00:00	N	P	15010034	GS15000048	27895	_	T	14737	n650	WA3	AN5	D	1000.00	1000.00	Y	2015-01-14 00:00:00.000	327090	YY	2015-01-08 00:00:00	154595	 	NULL	NULL	NULL
70074	1	2015-01-08 00:00:00	n417	2015-01-08 00:00:00	N	T	15010065	GS00033508	53249	_	T	2855	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-01-14 00:00:00.000	327115	YY	2015-01-08 00:00:00	113245	 	NULL	NULL	NULL
70075	1	2015-01-08 09:04:00	n319	2015-01-08 00:00:00	N	P	15010049	GS15000049	27909	_	T	12406	n650	WA3	AN5	D	2000.00	2000.00	Y	2015-01-14 00:00:00.000	327091	YY	2015-01-08 00:00:00	154596	 	NULL	NULL	NULL
70076	1	2015-01-08 00:00:00	n417	2015-01-08 00:00:00	N	T	15010066	GS00033509	53250	_	T	2855	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-01-14 00:00:00.000	327116	YY	2015-01-08 00:00:00	113246	 	NULL	NULL	NULL
70077	1	2015-01-08 09:06:00	n319	2015-01-08 00:00:00	N	P	14080153	GS15000050	27921	_	T	4610	n994	IG1B	AA21	N	9700.00	9700.00	Y	2015-01-14 00:00:00.000	327092	YY	2015-01-08 00:00:00	154597	 	NULL	NULL	NULL
70078	1	2015-01-08 00:00:00	n417	2015-01-08 00:00:00	N	T	15010067	GS00033510	53236	_	T	2855	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-01-14 00:00:00.000	327117	YY	2015-01-08 00:00:00	113247	 	NULL	NULL	NULL
70079	1	2015-01-08 00:00:00	n417	2015-01-08 00:00:00	N	T	15010068	GS00033511	53247	_	T	2855	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-01-14 00:00:00.000	327118	YY	2015-01-08 00:00:00	113248	 	NULL	NULL	NULL
70080	1	2015-01-08 00:00:00	n417	2015-01-08 00:00:00	N	T	15010069	GS00033512	53248	_	T	2855	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-01-14 00:00:00.000	327119	YY	2015-01-08 00:00:00	113249	 	NULL	NULL	NULL
70081	1	2015-01-08 09:09:00	n319	2015-01-08 00:00:00	N	P	14090170	GS15000052	28000	_	T	12000	n1304	IG1B	AA21	N	9700.00	9700.00	Y	2015-01-14 00:00:00.000	327093	YY	2015-01-08 00:00:00	154599	 	NULL	NULL	NULL
70082	1	2015-01-08 00:00:00	n417	2015-01-08 00:00:00	N	T	15010070	GS00033513	53245	_	T	2855	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-01-14 00:00:00.000	327120	YY	2015-01-08 00:00:00	113250	 	NULL	NULL	NULL
70083	1	2015-01-08 00:00:00	n417	2015-01-08 00:00:00	N	T	15010071	GS00033514	53246	_	T	2855	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-01-14 00:00:00.000	327121	YY	2015-01-08 00:00:00	113251	 	NULL	NULL	NULL
70084	1	2015-01-08 09:42:00	n319	2015-01-08 00:00:00	N	P	15010058	GS15000054	20921	_	T	12715	n896	WS2	AK2	N	4000.00	4000.00	N	NULL	0	XX	2015-01-08 00:00:00	154601	 	NULL	NULL	NULL
70085	1	2015-01-08 09:43:00	n319	2015-01-08 00:00:00	N	P	15010063	GS15000055	20989	_	T	12082	n650	WS2	AK2	N	8000.00	8000.00	Y	2015-01-14 00:00:00.000	327094	YE	2015-01-08 00:00:00	154602	 	NULL	NULL	NULL
70086	1	2015-01-08 00:00:00	n417	2015-01-09 00:00:00	N	T	15010147	GS00033515	64768	_	T	5058	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-01-14 00:00:00.000	327131	YY	2015-01-09 00:00:00	113288	 	NULL	NULL	NULL
70087	1	2015-01-08 15:41:00	n319	2015-01-09 00:00:00	N	P	15010041	GS15000057	26218	_	T	15156	n1125	WS21	AK3	N	4500.00	4500.00	Y	2015-01-14 00:00:00.000	327122	YY	2015-01-09 00:00:00	154678	 	NULL	NULL	NULL
70088	1	2015-01-08 00:00:00	n417	2015-01-09 00:00:00	N	T	15010127	GS00033516	64770	_	T	5058	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-01-14 00:00:00.000	327132	YY	2015-01-09 00:00:00	113289	 	NULL	NULL	NULL
70089	1	2015-01-08 00:00:00	n417	2015-01-09 00:00:00	N	T	15010128	GS00033517	64772	_	T	5058	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-01-14 00:00:00.000	327133	YY	2015-01-09 00:00:00	113290	 	NULL	NULL	NULL
70090	1	2015-01-08 15:43:00	n319	2015-01-09 00:00:00	N	P	15010057	GS15000058	27638	_	T	15673	n1293	WS11	AJ2	N	1000.00	1000.00	Y	2015-01-14 00:00:00.000	327123	YY	2015-01-09 00:00:00	154680	 	NULL	NULL	NULL
70091	1	2015-01-08 00:00:00	n417	2015-01-09 00:00:00	N	T	15010102	GS00033518	65655	_	T	13211	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-01-14 00:00:00.000	327134	YY	2015-01-09 00:00:00	113291	 	NULL	NULL	NULL
70092	1	2015-01-08 00:00:00	n417	2015-01-09 00:00:00	N	T	15010100	GS00033521	65248	_	T	14956	n1350	FF0	FF0	N	2500.00	2500.00	Y	2015-01-14 00:00:00.000	327135	YY	2015-01-09 00:00:00	113294	 	NULL	NULL	NULL
70093	1	2015-01-08 00:00:00	n417	2015-01-09 00:00:00	N	T	15010099	GS00033522	64576	_	T	14643	n1350	FF0	FF0	N	2500.00	2500.00	Y	2015-01-14 00:00:00.000	327136	YY	2015-01-09 00:00:00	113295	 	NULL	NULL	NULL
70094	1	2015-01-08 16:47:00	n319	2015-01-09 00:00:00	N	P	15010058	GS15000059	20921	_	T	12715	n896	WS2	AK2	N	4000.00	8000.00	Y	2015-01-14 00:00:00.000	327124	YY	2015-01-09 00:00:00	154689	 	NULL	NULL	NULL
70095	1	2015-01-08 16:47:00	n319	2015-01-09 00:00:00	N	P	15010087	GS15000059	20921	_	T	12715	n896	WS8	AK2	N	4000.00	8000.00	Y	2015-01-14 00:00:00.000	327125	YY	2015-01-09 00:00:00	154689	 	NULL	NULL	NULL
70096	1	2015-01-08 17:01:00	n319	2015-01-09 00:00:00	N	P	15010088	GS15000060	25922	_	T	14375	n896	WS21	AK3	N	1700.00	1700.00	Y	2015-01-14 00:00:00.000	327126	YY	2015-01-09 00:00:00	154690	 	NULL	NULL	NULL
70097	1	2015-01-09 08:51:00	n319	2015-01-09 00:00:00	N	P	14120358	GS15000065	27962	_	T	12406	n650	WA3	AN5	D	2000.00	2000.00	Y	2015-01-14 00:00:00.000	327127	YY	2015-01-09 00:00:00	154695	 	NULL	NULL	NULL
70098	1	2015-01-09 08:53:00	n319	2015-01-09 00:00:00	N	P	14110185	GS15000066	28152	_	T	14105	n1293	UG1	AA3	N	3000.00	3000.00	Y	2015-01-14 00:00:00.000	327128	YY	2015-01-09 00:00:00	154696	 	NULL	NULL	NULL
70099	1	2015-01-09 09:43:00	n319	2015-01-09 00:00:00	N	P	15010093	GS15000069	25926	_	T	14564	n1486	WS1	AJ1	N	8500.00	8500.00	Y	2015-01-14 00:00:00.000	327129	YY	2015-01-09 00:00:00	154700	 	NULL	NULL	NULL
70100	1	2015-01-09 14:00:00	n319	2015-01-09 00:00:00	N	P	14120100	GS15000070	28193	_	T	15892	n1065	UG1	AA3	N	3000.00	3000.00	Y	2015-01-14 00:00:00.000	327130	YY	2015-01-09 00:00:00	154755	 	NULL	NULL	NULL
70101	1	2015-01-09 15:52:00	n319	2015-01-12 00:00:00	N	P	15010077	GS15000071	23802	_	T	14510	n1125	WS21	AK3	N	1700.00	1700.00	Y	2015-01-16 00:00:00.000	327641	YY	2015-01-12 00:00:00	154779	 	NULL	NULL	NULL
70102	1	2015-01-09 15:53:00	n319	2015-01-12 00:00:00	N	P	15010079	GS15000072	27804	_	T	15336	n1125	WA3	AN5	D	3000.00	3000.00	Y	2015-01-16 00:00:00.000	327642	YY	2015-01-12 00:00:00	154780	 	NULL	NULL	NULL
70103	1	2015-01-12 09:07:00	n319	2015-01-12 00:00:00	N	P	15010066	GS15000077	28192	_	T	14269	n994	FC2	AM2	N	2000.00	2000.00	Y	2015-01-16 00:00:00.000	327643	YY	2015-01-12 00:00:00	154800	 	NULL	NULL	NULL
70104	1	2015-01-12 00:00:00	n417	2015-01-12 00:00:00	N	T	15010121	GS00033541	52085	_	T	4830	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-01-16 00:00:00.000	327645	YY	2015-01-12 00:00:00	113463	 	NULL	NULL	NULL
70105	1	2015-01-12 00:00:00	n417	2015-01-12 00:00:00	N	T	15010120	GS00033542	52084	_	T	4830	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-01-16 00:00:00.000	327646	YY	2015-01-12 00:00:00	113464	 	NULL	NULL	NULL
70106	1	2015-01-12 00:00:00	n417	2015-01-12 00:00:00	N	T	15010148	GS00033544	65301	_	T	13981	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-01-16 00:00:00.000	327647	YY	2015-01-12 00:00:00	113467	 	NULL	NULL	NULL
70107	1	2015-01-12 14:08:00	n319	2015-01-12 00:00:00	N	P	15010106	GS15000078	28287	_	T	10747	n1065	IG1E	AA2	N	10500.00	10500.00	Y	2015-01-16 00:00:00.000	327644	YY	2015-01-12 00:00:00	154862	 	NULL	NULL	NULL
70108	1	2015-01-12 15:31:00	n319	2015-01-13 00:00:00	N	P	15010101	GS15000079	1160	M	T	15426	n113	WS11	AJ2	X	2700.00	2700.00	Y	2015-01-16 00:00:00.000	327648	YY	2015-01-13 00:00:00	154867	 	NULL	NULL	NULL
70109	1	2015-01-12 15:32:00	n319	2015-01-13 00:00:00	N	P	15010102	GS15000080	25321	_	T	7568	n100	WS21	AK3	N	5600.00	5600.00	Y	2015-01-16 00:00:00.000	327649	YY	2015-01-13 00:00:00	154868	 	NULL	NULL	NULL
70110	1	2015-01-12 15:34:00	n319	2015-01-13 00:00:00	N	P	14120223	GS15000081	28174	_	T	13708	n896	WA3	AN5	D	1000.00	2000.00	Y	2015-01-16 00:00:00.000	327650	YY	2015-01-13 00:00:00	154869	 	NULL	NULL	NULL
70111	1	2015-01-12 15:34:00	n319	2015-01-13 00:00:00	N	P	15010091	GS15000081	28174	_	T	13708	n896	WA3	AN5	D	1000.00	2000.00	Y	2015-01-16 00:00:00.000	327651	YY	2015-01-13 00:00:00	154869	 	NULL	NULL	NULL
70112	1	2015-01-13 00:00:00	n417	2015-01-13 00:00:00	N	T	15010192	GS00033549	65525	_	T	15348	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-01-16 00:00:00.000	327659	YY	2015-01-13 00:00:00	113540	 	NULL	NULL	NULL
70113	1	2015-01-13 08:53:00	n319	2015-01-13 00:00:00	N	P	14070311	GS15000084	27850	_	T	15587	n1125	IG1E	AA2	N	10500.00	10500.00	Y	2015-01-16 00:00:00.000	327652	YY	2015-01-13 00:00:00	154883	 	NULL	NULL	NULL
70114	1	2015-01-13 08:55:00	n319	2015-01-13 00:00:00	N	P	14100137	GS15000085	28070	_	T	13472	n1304	UG1	AA3	N	3000.00	3000.00	Y	2015-01-16 00:00:00.000	327653	YY	2015-01-13 00:00:00	154884	 	NULL	NULL	NULL
70115	1	2015-01-13 00:00:00	n417	2015-01-13 00:00:00	N	T	15010157	GS00033550	65284	_	T	15705	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-01-16 00:00:00.000	327660	YY	2015-01-13 00:00:00	113541	 	NULL	NULL	NULL
70116	1	2015-01-13 00:00:00	n417	2015-01-13 00:00:00	N	T	15010158	GS00033551	65283	_	T	15705	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-01-16 00:00:00.000	327661	YY	2015-01-13 00:00:00	113542	 	NULL	NULL	NULL
70117	1	2015-01-13 08:57:00	n319	2015-01-13 00:00:00	N	P	14120001	GS15000086	28179	_	T	13124	n1304	IG1E	AA2	N	10500.00	10500.00	Y	2015-01-16 00:00:00.000	327654	YY	2015-01-13 00:00:00	154885	 	NULL	NULL	NULL
70118	1	2015-01-13 00:00:00	n417	2015-01-13 00:00:00	N	T	15010186	GS00033552	65372	_	T	14794	n646	FF0	FF0	N	2500.00	2500.00	Y	2015-01-16 00:00:00.000	327662	YY	2015-01-13 00:00:00	113543	 	NULL	NULL	NULL
70119	1	2015-01-13 00:00:00	n417	2015-01-13 00:00:00	N	T	15010187	GS00033553	65373	_	T	14794	n646	FF0	FF0	N	2500.00	2500.00	Y	2015-01-16 00:00:00.000	327663	YY	2015-01-13 00:00:00	113544	 	NULL	NULL	NULL
70120	1	2015-01-13 00:00:00	n417	2015-01-13 00:00:00	N	T	15010156	GS00033554	52014	_	T	5433	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-01-16 00:00:00.000	327664	YY	2015-01-13 00:00:00	113545	 	NULL	NULL	NULL
70121	1	2015-01-13 00:00:00	n417	2015-01-13 00:00:00	N	T	15010183	GS00033555	52123	_	T	4884	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-01-16 00:00:00.000	327665	YY	2015-01-13 00:00:00	113546	 	NULL	NULL	NULL
70122	1	2015-01-13 09:05:00	n319	2015-01-13 00:00:00	N	P	14120201	GS15000087	28221	_	T	14544	n1125	IG1E	AA21	N	9700.00	9700.00	Y	2015-01-16 00:00:00.000	327655	YY	2015-01-13 00:00:00	154886	 	NULL	NULL	NULL
70123	1	2015-01-13 00:00:00	n417	2015-01-13 00:00:00	N	T	15010123	GS00033556	52501	_	T	4830	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-01-16 00:00:00.000	327666	YY	2015-01-13 00:00:00	113547	 	NULL	NULL	NULL
70124	1	2015-01-13 09:06:00	n319	2015-01-13 00:00:00	N	P	15010082	GS15000088	28205	_	T	15851	n1293	WA3	AN5	D	1000.00	1000.00	Y	2015-01-16 00:00:00.000	327656	YY	2015-01-13 00:00:00	154887	 	NULL	NULL	NULL
70125	1	2015-01-13 00:00:00	n417	2015-01-13 00:00:00	N	T	15010122	GS00033557	52271	_	T	4830	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-01-16 00:00:00.000	327667	YY	2015-01-13 00:00:00	113548	 	NULL	NULL	NULL
70126	1	2015-01-13 00:00:00	n417	2015-01-13 00:00:00	N	T	15010190	GS00033558	66062	_	T	12385	n646	FE1	FE1	N	5400.00	5400.00	Y	2015-01-16 00:00:00.000	327668	YE	2015-01-13 00:00:00	113549	 	NULL	NULL	NULL
70127	1	2015-01-13 00:00:00	n417	2015-01-13 00:00:00	N	T	15010193	GS00033559	66063	_	T	14643	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-01-16 00:00:00.000	327669	YE	2015-01-13 00:00:00	113550	 	NULL	NULL	NULL
70128	1	2015-01-13 00:00:00	n417	2015-01-13 00:00:00	N	T	15010194	GS00033560	66064	_	T	14643	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-01-16 00:00:00.000	327670	YE	2015-01-13 00:00:00	113551	 	NULL	NULL	NULL
70129	1	2015-01-13 00:00:00	n417	2015-01-13 00:00:00	N	T	15010195	GS00033561	66065	_	T	14643	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-01-16 00:00:00.000	327671	YE	2015-01-13 00:00:00	113552	 	NULL	NULL	NULL
70130	1	2015-01-13 09:46:00	n319	2015-01-13 00:00:00	N	P	15010096	GS15000092	1111	M	T	12293	n113	WS2	AK2	X	2500.00	2500.00	Y	2015-01-16 00:00:00.000	327657	YE	2015-01-13 00:00:00	154891	 	NULL	NULL	NULL
70131	1	2015-01-13 09:46:00	n319	2015-01-13 00:00:00	N	P	15010108	GS15000093	21779	_	T	7568	n100	WS2	AK2	N	8000.00	8000.00	Y	2015-01-16 00:00:00.000	327658	YE	2015-01-13 00:00:00	154892	 	NULL	NULL	NULL
70132	1	2015-01-13 00:00:00	n417	2015-01-14 00:00:00	N	T	15010202	GS00033566	65438	_	T	12383	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-01-16 00:00:00.000	327677	YY	2015-01-14 00:00:00	113601	 	NULL	NULL	NULL
70133	1	2015-01-13 00:00:00	n417	2015-01-14 00:00:00	N	T	15010138	GS00033567	65320	_	T	15193	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-01-16 00:00:00.000	327678	YY	2015-01-14 00:00:00	113611	 	NULL	NULL	NULL
70134	1	2015-01-13 00:00:00	n417	2015-01-14 00:00:00	N	T	15010139	GS00033568	65321	_	T	15193	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-01-16 00:00:00.000	327679	YY	2015-01-14 00:00:00	113612	 	NULL	NULL	NULL
70135	1	2015-01-13 00:00:00	n417	2015-01-14 00:00:00	N	T	15010140	GS00033569	65322	_	T	15193	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-01-16 00:00:00.000	327680	YY	2015-01-14 00:00:00	113613	 	NULL	NULL	NULL
70136	1	2015-01-13 00:00:00	n417	2015-01-14 00:00:00	N	T	15010141	GS00033570	65323	_	T	15193	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-01-16 00:00:00.000	327681	YY	2015-01-14 00:00:00	113614	 	NULL	NULL	NULL
70137	1	2015-01-13 00:00:00	n417	2015-01-14 00:00:00	N	T	15010142	GS00033571	65324	_	T	15193	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-01-16 00:00:00.000	327682	YY	2015-01-14 00:00:00	113615	 	NULL	NULL	NULL
70138	1	2015-01-13 00:00:00	n417	2015-01-14 00:00:00	N	T	15010143	GS00033572	65325	_	T	15193	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-01-16 00:00:00.000	327683	YY	2015-01-14 00:00:00	113616	 	NULL	NULL	NULL
70139	1	2015-01-13 00:00:00	n417	2015-01-14 00:00:00	N	T	15010144	GS00033573	65326	_	T	15193	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-01-16 00:00:00.000	327684	YY	2015-01-14 00:00:00	113622	 	NULL	NULL	NULL
70140	1	2015-01-13 00:00:00	n417	2015-01-14 00:00:00	N	T	15010145	GS00033574	65327	_	T	15193	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-01-16 00:00:00.000	327685	YY	2015-01-14 00:00:00	113623	 	NULL	NULL	NULL
70141	1	2015-01-13 00:00:00	n417	2015-01-14 00:00:00	N	T	15010146	GS00033575	64478	_	T	15193	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-01-16 00:00:00.000	327686	YY	2015-01-14 00:00:00	113624	 	NULL	NULL	NULL
70142	1	2015-01-14 00:00:00	n417	2015-01-14 00:00:00	N	T	15010185	GS00033579	65436	_	T	15480	n428	FD1	FD1	N	2000.00	2000.00	Y	2015-01-16 00:00:00.000	327687	YY	2015-01-14 00:00:00	113637	 	NULL	NULL	NULL
70143	1	2015-01-14 08:54:00	n319	2015-01-14 00:00:00	N	P	15010121	GS15000096	25464	_	T	14633	n1304	WS21	AK3	N	2800.00	2800.00	Y	2015-01-16 00:00:00.000	327672	YY	2015-01-14 00:00:00	154992	 	NULL	NULL	NULL
70144	1	2015-01-14 09:04:00	n319	2015-01-14 00:00:00	N	P	15010130	GS15000102	27764	_	T	15660	n994	WS11	AJ2	N	4400.00	4400.00	Y	2015-01-16 00:00:00.000	327673	YY	2015-01-14 00:00:00	154998	 	NULL	NULL	NULL
70145	1	2015-01-14 09:05:00	n319	2015-01-14 00:00:00	N	P	15010131	GS15000103	28074	_	T	15660	n994	WS11	AJ2	N	4400.00	4400.00	Y	2015-01-16 00:00:00.000	327674	YY	2015-01-14 00:00:00	154999	 	NULL	NULL	NULL
70146	1	2015-01-14 09:06:00	n319	2015-01-14 00:00:00	N	P	15010126	GS15000104	28074	_	T	15660	n994	WA3	AN5	D	1000.00	1000.00	Y	2015-01-16 00:00:00.000	327675	YY	2015-01-14 00:00:00	155000	 	NULL	NULL	NULL
70147	1	2015-01-14 09:26:00	n319	2015-01-14 00:00:00	N	P	14080375	GS15000106	27966	_	T	15812	n1125	OG22	BB22	N	15400.00	15400.00	Y	2015-01-16 00:00:00.000	327676	YY	2015-01-14 00:00:00	155002	 	NULL	NULL	NULL
70148	1	2015-01-14 15:19:00	n319	2015-01-15 00:00:00	N	P	15010135	GS15000107	27278	_	T	15579	n1293	WS11	AJ2	N	1000.00	1000.00	Y	2015-01-21 00:00:00.000	327749	YY	2015-01-15 00:00:00	155062	 	NULL	NULL	NULL
70149	1	2015-01-14 15:20:00	n319	2015-01-15 00:00:00	N	P	15010129	GS15000108	1130	M	T	15002	n113	WS11	AJ2	X	2700.00	2700.00	Y	2015-01-21 00:00:00.000	327750	YY	2015-01-15 00:00:00	155063	 	NULL	NULL	NULL
70150	1	2015-01-14 00:00:00	n417	2015-01-15 00:00:00	N	T	15010207	GS00033582	65424	_	T	14892	n428	FN1	FN1	N	500.00	500.00	Y	2015-01-21 00:00:00.000	327758	YY	2015-01-15 00:00:00	113677	 	NULL	NULL	NULL
70151	1	2015-01-14 00:00:00	n417	2015-01-15 00:00:00	N	T	15010225	GS00033583	65267	_	T	15701	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-01-21 00:00:00.000	327759	YY	2015-01-15 00:00:00	113678	 	NULL	NULL	NULL
70152	1	2015-01-14 00:00:00	n417	2015-01-15 00:00:00	N	T	15010221	GS00033584	61236	_	T	13501	n1384	FF2	FF2	N	1500.00	1500.00	Y	2015-01-21 00:00:00.000	327760	YY	2015-01-15 00:00:00	113679	 	NULL	NULL	NULL
70153	1	2015-01-14 16:37:00	n319	2015-01-15 00:00:00	N	P	15010119	GS15000109	16431	_	T	13613	n1486	WS62	AK21	N	9600.00	9600.00	Y	2015-01-21 00:00:00.000	327751	YY	2015-01-15 00:00:00	155084	 	NULL	NULL	NULL
70154	1	2015-01-14 00:00:00	n417	2015-01-15 00:00:00	N	T	15010208	GS00033585	66068	_	T	15896	n530	FE1	FE1	N	2400.00	2400.00	N	NULL	0	XX	2015-01-15 00:00:00	113697	 	NULL	NULL	NULL
70155	1	2015-01-14 00:00:00	n417	2015-01-15 00:00:00	N	T	15010223	GS00033586	66069	_	T	4049	n441	FE11	FE11	N	2700.00	2700.00	Y	2015-01-21 00:00:00.000	327761	YE	2015-01-15 00:00:00	113698	 	NULL	NULL	NULL
70156	1	2015-01-14 00:00:00	n417	2015-01-15 00:00:00	N	T	15010224	GS00033587	66070	_	T	4049	n441	FE11	FE11	N	2700.00	2700.00	Y	2015-01-21 00:00:00.000	327762	YE	2015-01-15 00:00:00	113699	 	NULL	NULL	NULL
70157	1	2015-01-14 17:01:00	n319	2015-01-15 00:00:00	N	P	14100286	GS15000110	28097	_	T	15853	n1293	IG1E	AA2	N	10500.00	10500.00	Y	2015-01-21 00:00:00.000	327752	YY	2015-01-15 00:00:00	155094	 	NULL	NULL	NULL
70158	1	2015-01-14 17:05:00	n319	2015-01-15 00:00:00	N	P	15010132	GS15000112	27067	_	T	2853	n100	AAK	AAK	N	1000.00	1000.00	Y	2015-01-21 00:00:00.000	327753	YY	2015-01-15 00:00:00	155096	 	NULL	NULL	NULL
70159	1	2015-01-15 08:48:00	n319	2015-01-15 00:00:00	N	P	15010138	GS15000114	26552	_	T	11405	n1486	WS11	AJ2	N	2700.00	2700.00	Y	2015-01-21 00:00:00.000	327754	YY	2015-01-15 00:00:00	155098	 	NULL	NULL	NULL
70160	1	2015-01-15 00:00:00	n417	2015-01-15 00:00:00	N	T	15010211	GS00033588	66071	_	T	14956	n1350	FR1	FR1	N	4000.00	4000.00	Y	2015-01-21 00:00:00.000	327763	YY	2015-01-15 00:00:00	113709	 	NULL	NULL	NULL
70161	1	2015-01-15 09:41:00	n319	2015-01-15 00:00:00	N	P	15010145	GS15000115	17348	_	T	4898	n896	WS2	AK2	N	8000.00	8000.00	Y	2015-01-21 00:00:00.000	327755	YE	2015-01-15 00:00:00	155100	 	NULL	NULL	NULL
70162	1	2015-01-15 09:41:00	n319	2015-01-15 00:00:00	N	P	15010144	GS15000116	19053	_	T	4898	n896	WS2	AK2	N	16000.00	16000.00	Y	2015-01-21 00:00:00.000	327756	YE	2015-01-15 00:00:00	155101	 	NULL	NULL	NULL
70163	1	2015-01-15 09:41:00	n319	2015-01-15 00:00:00	N	P	15010141	GS15000117	19380	_	T	13091	n1125	WS2	AK2	N	8000.00	8000.00	Y	2015-01-21 00:00:00.000	327757	YE	2015-01-15 00:00:00	155102	 	NULL	NULL	NULL
70164	1	2015-01-15 00:00:00	n417	2015-01-15 00:00:00	N	T	15010208	GS00033591	66068	_	T	15896	n530	FE1	FE1	N	2400.00	2400.00	Y	2015-01-21 00:00:00.000	327764	YE	2015-01-15 00:00:00	113734	 	NULL	NULL	NULL
70165	1	2015-01-15 00:00:00	n417	2015-01-16 00:00:00	N	T	15010227	GS00033592	52949	_	T	7464	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-01-21 00:00:00.000	327925	YY	2015-01-16 00:00:00	113779	 	NULL	NULL	NULL
70166	1	2015-01-15 00:00:00	n417	2015-01-16 00:00:00	N	T	15010234	GS00033593	65731	_	T	15686	n646	FF0	FF0	N	10000.00	10000.00	Y	2015-01-21 00:00:00.000	327926	YY	2015-01-16 00:00:00	113795	 	NULL	NULL	NULL
70167	1	2015-01-15 00:00:00	n417	2015-01-16 00:00:00	N	T	15010235	GS00033594	65732	_	T	15686	n646	FF0	FF0	N	10000.00	10000.00	Y	2015-01-21 00:00:00.000	327927	YY	2015-01-16 00:00:00	113797	 	NULL	NULL	NULL
70168	1	2015-01-15 00:00:00	n417	2015-01-16 00:00:00	N	T	15010236	GS00033595	65733	_	T	15686	n646	FF0	FF0	N	10000.00	10000.00	Y	2015-01-21 00:00:00.000	327928	YY	2015-01-16 00:00:00	113799	 	NULL	NULL	NULL
70169	1	2015-01-15 00:00:00	n417	2015-01-16 00:00:00	N	T	15010231	GS00033596	61186	_	T	13275	n428	FF2	FF2	N	1500.00	1500.00	Y	2015-01-21 00:00:00.000	327929	YY	2015-01-16 00:00:00	113801	 	NULL	NULL	NULL
70170	1	2015-01-15 00:00:00	n417	2015-01-16 00:00:00	N	T	15010232	GS00033597	61187	_	T	13275	n428	FF2	FF2	N	1500.00	1500.00	Y	2015-01-21 00:00:00.000	327930	YY	2015-01-16 00:00:00	113802	 	NULL	NULL	NULL
70171	1	2015-01-15 00:00:00	n417	2015-01-16 00:00:00	N	T	15010233	GS00033598	61188	_	T	13275	n428	FF2	FF2	N	1500.00	1500.00	Y	2015-01-21 00:00:00.000	327931	YY	2015-01-16 00:00:00	113804	 	NULL	NULL	NULL
70172	1	2015-01-15 00:00:00	n417	2015-01-16 00:00:00	N	T	15010246	GS00033599	65515	_	T	14554	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-01-21 00:00:00.000	327932	YY	2015-01-16 00:00:00	113805	 	NULL	NULL	NULL
70173	1	2015-01-15 00:00:00	n417	2015-01-16 00:00:00	N	T	15010242	GS00033600	64633	_	T	13770	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-01-21 00:00:00.000	327933	YY	2015-01-16 00:00:00	113808	 	NULL	NULL	NULL
70174	1	2015-01-15 15:57:00	n319	2015-01-16 00:00:00	N	P	15010147	GS15000118	25840	_	T	11997	n650	FC1	AL1	N	2000.00	2000.00	Y	2015-01-21 00:00:00.000	327913	YY	2015-01-16 00:00:00	155192	 	NULL	NULL	NULL
70175	1	2015-01-15 16:01:00	n319	2015-01-16 00:00:00	N	P	15010133	GS15000119	25840	_	T	11997	n650	WS11	AJ2	N	6100.00	6100.00	Y	2015-01-21 00:00:00.000	327914	YY	2015-01-16 00:00:00	155193	 	NULL	NULL	NULL
70176	1	2015-01-15 16:17:00	n319	2015-01-16 00:00:00	N	P	15010149	GS15000121	1134	M	T	12293	n113	WS1	AJ1	X	3500.00	3500.00	Y	2015-01-21 00:00:00.000	327915	YY	2015-01-16 00:00:00	155199	 	NULL	NULL	NULL
70177	1	2015-01-15 00:00:00	n417	2015-01-16 00:00:00	N	T	15010220	GS00033601	66072	_	T	14048	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-01-21 00:00:00.000	327934	YE	2015-01-16 00:00:00	113822	 	NULL	NULL	NULL
70178	1	2015-01-15 00:00:00	n417	2015-01-16 00:00:00	N	T	15010219	GS00033602	66073	_	T	14048	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-01-21 00:00:00.000	327935	YE	2015-01-16 00:00:00	113823	 	NULL	NULL	NULL
70179	1	2015-01-16 00:00:00	n417	2015-01-16 00:00:00	N	T	15010212	GS00033603	66074	_	T	14048	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-01-21 00:00:00.000	327936	YE	2015-01-16 00:00:00	113826	 	NULL	NULL	NULL
70180	1	2015-01-16 00:00:00	n417	2015-01-16 00:00:00	N	T	15010213	GS00033604	66075	_	T	14048	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-01-21 00:00:00.000	327937	YE	2015-01-16 00:00:00	113827	 	NULL	NULL	NULL
70181	1	2015-01-16 00:00:00	n417	2015-01-16 00:00:00	N	T	15010215	GS00033605	66076	_	T	14048	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-01-21 00:00:00.000	327938	YE	2015-01-16 00:00:00	113828	 	NULL	NULL	NULL
70182	1	2015-01-16 00:00:00	n417	2015-01-16 00:00:00	N	T	15010216	GS00033606	66077	_	T	14048	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-01-21 00:00:00.000	327939	YE	2015-01-16 00:00:00	113829	 	NULL	NULL	NULL
70183	1	2015-01-16 00:00:00	n417	2015-01-16 00:00:00	N	T	15010214	GS00033607	66078	_	T	14048	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-01-21 00:00:00.000	327940	YE	2015-01-16 00:00:00	113830	 	NULL	NULL	NULL
70184	1	2015-01-16 00:00:00	n417	2015-01-16 00:00:00	N	T	15010217	GS00033608	66079	_	T	14048	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-01-21 00:00:00.000	327941	YE	2015-01-16 00:00:00	113831	 	NULL	NULL	NULL
70185	1	2015-01-16 00:00:00	n417	2015-01-16 00:00:00	N	T	15010218	GS00033609	66080	_	T	14048	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-01-21 00:00:00.000	327942	YE	2015-01-16 00:00:00	113832	 	NULL	NULL	NULL
70186	1	2015-01-16 08:48:00	n319	2015-01-16 00:00:00	N	P	15010159	GS15000122	24661	_	T	13712	n896	WS1	AJ1	N	8500.00	8500.00	Y	2015-01-21 00:00:00.000	327916	YY	2015-01-16 00:00:00	155206	 	NULL	NULL	NULL
70187	1	2015-01-16 08:53:00	n319	2015-01-16 00:00:00	N	P	15010150	GS15000124	26512	_	T	12002	n896	WS1	AJ1	N	23500.00	23500.00	Y	2015-01-21 00:00:00.000	327917	YY	2015-01-16 00:00:00	155208	 	NULL	NULL	NULL
70188	1	2015-01-16 08:55:00	n319	2015-01-16 00:00:00	N	P	15010157	GS15000125	27419	_	T	15610	n994	WS1	AJ1	N	8500.00	8500.00	Y	2015-01-21 00:00:00.000	327918	YY	2015-01-16 00:00:00	155209	 	NULL	NULL	NULL
70189	1	2015-01-16 08:56:00	n319	2015-01-16 00:00:00	N	P	15010156	GS15000126	27421	_	T	15610	n994	WS1	AJ1	N	8500.00	8500.00	Y	2015-01-21 00:00:00.000	327919	YY	2015-01-16 00:00:00	155210	 	NULL	NULL	NULL
70190	1	2015-01-16 00:00:00	n417	2015-01-16 00:00:00	N	T	15010237	GS00033611	66081	_	T	2164	n441	FE41	FE41	N	2700.00	2700.00	Y	2015-01-21 00:00:00.000	327943	YE	2015-01-16 00:00:00	113835	 	NULL	NULL	NULL
70191	1	2015-01-16 08:57:00	n319	2015-01-16 00:00:00	N	P	15010146	GS15000127	28061	_	T	3009	n896	WS11	AJ2	N	2700.00	2700.00	Y	2015-01-21 00:00:00.000	327920	YY	2015-01-16 00:00:00	155211	 	NULL	NULL	NULL
70192	1	2015-01-16 00:00:00	n417	2015-01-16 00:00:00	N	T	15010244	GS00033612	66082	_	T	15195	n646	FR1	FR1	N	4000.00	4000.00	Y	2015-01-21 00:00:00.000	327944	YY	2015-01-16 00:00:00	113836	 	NULL	NULL	NULL
70193	1	2015-01-16 00:00:00	n417	2015-01-16 00:00:00	N	T	15010243	GS00033613	66083	_	T	15195	n646	FR1	FR1	N	4000.00	4000.00	Y	2015-01-21 00:00:00.000	327945	YY	2015-01-16 00:00:00	113837	 	NULL	NULL	NULL
70194	1	2015-01-16 09:00:00	n319	2015-01-16 00:00:00	N	P	14110257	GS15000128	28166	_	T	10747	n1065	UG1	AA3	N	3000.00	3000.00	Y	2015-01-21 00:00:00.000	327921	YY	2015-01-16 00:00:00	155212	 	NULL	NULL	NULL
70195	1	2015-01-16 09:01:00	n319	2015-01-16 00:00:00	N	P	15010151	GS15000129	25367	_	T	15022	n1304	WS1	AJ1	N	8500.00	8500.00	Y	2015-01-21 00:00:00.000	327922	YY	2015-01-16 00:00:00	155213	 	NULL	NULL	NULL
70196	1	2015-01-16 09:04:00	n319	2015-01-16 00:00:00	N	P	14120130	GS15000131	28201	_	T	13124	n1304	IG1E	AA2	N	10500.00	10500.00	Y	2015-01-21 00:00:00.000	327923	YY	2015-01-16 00:00:00	155217	 	NULL	NULL	NULL
70197	1	2015-01-16 09:28:00	n319	2015-01-16 00:00:00	N	P	14120133	GS15000132	28199	_	T	13972	n100	IG1E	AA2	N	10500.00	10500.00	Y	2015-01-21 00:00:00.000	327924	YY	2015-01-16 00:00:00	155219	 	NULL	NULL	NULL
70198	1	2015-01-16 00:00:00	n417	2015-01-19 00:00:00	N	T	15010256	GS00033614	65030	_	T	13176	n428	FF0	FF0	N	5000.00	5000.00	Y	2015-01-21 00:00:00.000	327953	YY	2015-01-19 00:00:00	113855	 	NULL	NULL	NULL
70199	1	2015-01-16 00:00:00	n417	2015-01-19 00:00:00	N	T	15010254	GS00033615	65437	_	T	15480	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-01-21 00:00:00.000	327954	YY	2015-01-19 00:00:00	113856	 	NULL	NULL	NULL
70200	1	2015-01-16 00:00:00	n417	2015-01-19 00:00:00	N	T	15010255	GS00033616	65524	_	T	15480	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-01-21 00:00:00.000	327955	YY	2015-01-19 00:00:00	113857	 	NULL	NULL	NULL
70201	1	2015-01-16 16:30:00	n319	2015-01-19 00:00:00	N	P	15010172	GS15000133	24053	_	T	14589	n650	WS11	AJ2	N	6100.00	6100.00	Y	2015-01-21 00:00:00.000	327946	YY	2015-01-19 00:00:00	155336	 	NULL	NULL	NULL
70202	1	2015-01-16 00:00:00	n417	2015-01-19 00:00:00	N	T	15010270	GS00033620	66084	_	T	7599	n547	FE1	FE1	N	2400.00	2400.00	Y	2015-01-21 00:00:00.000	327956	YE	2015-01-19 00:00:00	113933	 	NULL	NULL	NULL
70203	1	2015-01-19 08:56:00	n319	2015-01-19 00:00:00	N	P	14060172	GS15000136	27726	_	T	12000	n1304	WA3	AN5	N	1000.00	1000.00	Y	2015-01-21 00:00:00.000	327947	YY	2015-01-19 00:00:00	155344	 	NULL	NULL	NULL
70204	1	2015-01-19 08:56:00	n319	2015-01-19 00:00:00	N	P	14060173	GS15000137	27726	_	T	12000	n1304	WA3	AN5	N	1000.00	1000.00	Y	2015-01-21 00:00:00.000	327948	YY	2015-01-19 00:00:00	155345	 	NULL	NULL	NULL
70205	1	2015-01-19 08:58:00	n319	2015-01-19 00:00:00	N	P	15010182	GS15000138	28024	_	T	13971	n1486	WS1	AJ1	N	8500.00	8500.00	Y	2015-01-21 00:00:00.000	327949	YY	2015-01-19 00:00:00	155346	 	NULL	NULL	NULL
70206	1	2015-01-19 09:00:00	n319	2015-01-19 00:00:00	N	P	14110001	GS15000139	28112	_	T	15860	n650	IG1E	AA2	N	10500.00	10500.00	Y	2015-01-21 00:00:00.000	327950	YY	2015-01-19 00:00:00	155347	 	NULL	NULL	NULL
70207	1	2015-01-19 13:36:00	n319	2015-01-19 00:00:00	N	P	14110242	GS15000142	28163	_	T	15356	n1065	UG1	AA3	N	3000.00	3000.00	Y	2015-01-21 00:00:00.000	327951	YY	2015-01-19 00:00:00	155415	 	NULL	NULL	NULL
70208	1	2015-01-19 13:38:00	n319	2015-01-19 00:00:00	N	P	14110282	GS15000143	28167	_	T	15390	n994	WM62	AG12	N	2000.00	2000.00	Y	2015-01-21 00:00:00.000	327952	YY	2015-01-19 00:00:00	155418	 	NULL	NULL	NULL
70209	1	2015-01-19 15:43:00	n319	2015-01-20 00:00:00	N	P	15010183	GS15000145	25345	_	T	13124	n1304	WS11	AJ2	N	6100.00	6100.00	Y	2015-01-22 00:00:00.000	327957	YY	2015-01-20 00:00:00	155430	 	NULL	NULL	NULL
70210	1	2015-01-19 15:44:00	n319	2015-01-20 00:00:00	N	P	15010184	GS15000146	25345	_	T	13124	n1304	WS21	AK3	N	7600.00	7600.00	Y	2015-01-22 00:00:00.000	327958	YY	2015-01-20 00:00:00	155431	 	NULL	NULL	NULL
70211	1	2015-01-19 15:47:00	n319	2015-01-20 00:00:00	N	P	14120283	GS15000147	25353	_	T	10027	n113	FR1	AB1	N	7000.00	7000.00	Y	2015-01-22 00:00:00.000	327959	YY	2015-01-20 00:00:00	155432	 	NULL	NULL	NULL
70212	1	2015-01-19 00:00:00	k1416	2015-01-19 00:00:00	N	T	15010151	BGS0004743	66066	_	T	13362	n1350	DR1	DR1	N	7000.00	7000.00	Y	2015-01-22 00:00:00.000	327967	YY	2015-01-20 00:00:00	113967	 	NULL	NULL	NULL
70213	1	2015-01-19 00:00:00	k1416	2015-01-19 00:00:00	N	T	15010150	BGS0004744	66067	_	T	13362	n1350	DR1	DR1	N	7000.00	7000.00	Y	2015-01-22 00:00:00.000	327968	YY	2015-01-20 00:00:00	113968	 	NULL	NULL	NULL
70214	1	2015-01-20 08:34:00	n319	2015-01-20 00:00:00	N	P	15010197	GS15000149	26292	_	T	14297	n1125	WS11	AJ2	N	2700.00	2700.00	Y	2015-01-22 00:00:00.000	327960	YY	2015-01-20 00:00:00	155457	 	NULL	NULL	NULL
70215	1	2015-01-20 08:36:00	n319	2015-01-20 00:00:00	N	P	14070365	GS15000150	27850	_	T	15587	n1125	WA3	AN5	D	2000.00	2000.00	Y	2015-01-22 00:00:00.000	327961	YY	2015-01-20 00:00:00	155458	 	NULL	NULL	NULL
70216	1	2015-01-20 08:38:00	n319	2015-01-20 00:00:00	N	P	14120143	GS15000151	28202	_	T	13930	n896	IG1E	AA2	N	10500.00	10500.00	Y	2015-01-22 00:00:00.000	327962	YY	2015-01-20 00:00:00	155459	 	NULL	NULL	NULL
70217	1	2015-01-20 09:43:00	n319	2015-01-20 00:00:00	N	P	15010179	GS15000154	28296	_	T	10027	n113	DG1	AA4	N	3000.00	3000.00	Y	2015-01-22 00:00:00.000	327963	YY	2015-01-20 00:00:00	155464	 	NULL	NULL	NULL
70218	1	2015-01-20 09:45:00	n319	2015-01-20 00:00:00	N	P	15010180	GS15000155	28297	_	T	10027	n113	DG1	AA4	N	3000.00	3000.00	Y	2015-01-22 00:00:00.000	327964	YY	2015-01-20 00:00:00	155465	 	NULL	NULL	NULL
70219	1	2015-01-20 09:45:00	n319	2015-01-20 00:00:00	N	P	15010188	GS15000156	18930	_	T	643	n994	WS2	AK2	N	24000.00	24000.00	Y	2015-01-22 00:00:00.000	327965	YE	2015-01-20 00:00:00	155466	 	NULL	NULL	NULL
70220	1	2015-01-20 09:45:00	n319	2015-01-20 00:00:00	N	P	15010167	GS15000157	24961	_	T	7947	n1125	WS2	AK2	N	2500.00	2500.00	Y	2015-01-22 00:00:00.000	327966	YE	2015-01-20 00:00:00	155467	 	NULL	NULL	NULL
70221	1	2015-01-20 15:52:00	n319	2015-01-21 00:00:00	N	P	15010201	GS15000158	26794	_	T	12406	n650	WS11	AJ2	N	6100.00	6100.00	Y	2015-01-23 00:00:00.000	328645	YY	2015-01-21 00:00:00	155545	 	NULL	NULL	NULL
70222	1	2015-01-20 17:20:00	n319	2015-01-21 00:00:00	N	P	14120055	GS15000159	28186	_	T	2745	n100	OG22	BB22	N	8200.00	8200.00	Y	2015-01-23 00:00:00.000	328646	YY	2015-01-21 00:00:00	155552	 	NULL	NULL	NULL
70223	1	2015-01-20 17:22:00	n319	2015-01-21 00:00:00	N	P	14120134	GS15000160	28200	_	T	13972	n100	UG1	AA3	N	3000.00	3000.00	Y	2015-01-23 00:00:00.000	328647	YY	2015-01-21 00:00:00	155553	 	NULL	NULL	NULL
70224	1	2015-01-21 00:00:00	n417	2015-01-21 00:00:00	N	T	15010312	GS00033627	66095	_	T	13318	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-01-23 00:00:00.000	328652	YY	2015-01-21 00:00:00	114037	 	NULL	NULL	NULL
70225	1	2015-01-21 00:00:00	n417	2015-01-21 00:00:00	N	T	15010304	GS00033629	65627	_	T	15764	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-01-23 00:00:00.000	328653	YY	2015-01-21 00:00:00	114039	 	NULL	NULL	NULL
70226	1	2015-01-21 00:00:00	n417	2015-01-21 00:00:00	N	T	15010305	GS00033630	65634	_	T	15764	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-01-23 00:00:00.000	328654	YY	2015-01-21 00:00:00	114040	 	NULL	NULL	NULL
70227	1	2015-01-21 00:00:00	n417	2015-01-21 00:00:00	N	T	15010306	GS00033631	65635	_	T	15764	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-01-23 00:00:00.000	328655	YY	2015-01-21 00:00:00	114041	 	NULL	NULL	NULL
70228	1	2015-01-21 00:00:00	n417	2015-01-21 00:00:00	N	T	15010310	GS00033632	65648	_	T	15764	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-01-23 00:00:00.000	328656	YY	2015-01-21 00:00:00	114042	 	NULL	NULL	NULL
70229	1	2015-01-21 00:00:00	n417	2015-01-21 00:00:00	N	T	15010309	GS00033633	65638	_	T	15764	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-01-23 00:00:00.000	328657	YY	2015-01-21 00:00:00	114043	 	NULL	NULL	NULL
70230	1	2015-01-21 00:00:00	n417	2015-01-21 00:00:00	N	T	15010308	GS00033634	65637	_	T	15764	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-01-23 00:00:00.000	328658	YY	2015-01-21 00:00:00	114044	 	NULL	NULL	NULL
70231	1	2015-01-21 00:00:00	n417	2015-01-21 00:00:00	N	T	15010307	GS00033635	65636	_	T	15764	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-01-23 00:00:00.000	328659	YY	2015-01-21 00:00:00	114045	 	NULL	NULL	NULL
70232	1	2015-01-21 00:00:00	n417	2015-01-21 00:00:00	N	T	15010267	GS00033636	16034	_	T	2904	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-01-23 00:00:00.000	328660	YY	2015-01-21 00:00:00	114046	 	NULL	NULL	NULL
70233	1	2015-01-21 00:00:00	n417	2015-01-21 00:00:00	N	T	15010269	GS00033637	16121	_	T	2904	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-01-23 00:00:00.000	328661	YY	2015-01-21 00:00:00	114047	 	NULL	NULL	NULL
70234	1	2015-01-21 00:00:00	n417	2015-01-21 00:00:00	N	T	15010268	GS00033638	19067	_	T	2904	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-01-23 00:00:00.000	328662	YY	2015-01-21 00:00:00	114048	 	NULL	NULL	NULL
70235	1	2015-01-21 00:00:00	n417	2015-01-21 00:00:00	N	T	15010278	GS00033641	66092	_	T	15576	n646	FE1	FE1	N	2400.00	2400.00	Y	2015-01-23 00:00:00.000	328663	YE	2015-01-21 00:00:00	114051	 	NULL	NULL	NULL
70236	1	2015-01-21 00:00:00	n417	2015-01-21 00:00:00	N	T	15010274	GS00033642	52478	_	T	1976	n646	FR1	FR1	N	4000.00	4000.00	Y	2015-01-23 00:00:00.000	328664	YY	2015-01-21 00:00:00	114052	 	NULL	NULL	NULL
70237	1	2015-01-21 00:00:00	n417	2015-01-21 00:00:00	N	T	15010302	GS00033643	66090	_	T	15916	n428	FE1	FE1	N	13200.00	13200.00	Y	2015-01-23 00:00:00.000	328665	YE	2015-01-21 00:00:00	114053	 	NULL	NULL	NULL
70238	1	2015-01-21 00:00:00	n417	2015-01-21 00:00:00	N	T	15010303	GS00033644	66091	_	T	15916	n428	FE1	FE1	N	7800.00	7800.00	Y	2015-01-23 00:00:00.000	328666	YE	2015-01-21 00:00:00	114054	 	NULL	NULL	NULL
70239	1	2015-01-21 00:00:00	n417	2015-01-21 00:00:00	N	T	15010300	GS00033645	66093	_	T	15908	n1384	FE11	FE11	N	2700.00	2700.00	Y	2015-01-23 00:00:00.000	328667	YE	2015-01-21 00:00:00	114055	 	NULL	NULL	NULL
70240	1	2015-01-21 00:00:00	n417	2015-01-21 00:00:00	N	T	15010301	GS00033646	66094	_	T	15908	n1384	FE11	FE11	N	2700.00	2700.00	Y	2015-01-23 00:00:00.000	328668	YE	2015-01-21 00:00:00	114056	 	NULL	NULL	NULL
70241	1	2015-01-21 08:44:00	n319	2015-01-21 00:00:00	N	P	15010204	GS15000161	20487	_	T	13124	n1304	WS63	AK31	N	19400.00	19400.00	Y	2015-01-23 00:00:00.000	328648	YY	2015-01-21 00:00:00	155554	 	NULL	NULL	NULL
70242	1	2015-01-21 08:46:00	n319	2015-01-21 00:00:00	N	P	15010205	GS15000162	25266	_	T	15135	n1304	WS11	AJ2	N	6100.00	6100.00	Y	2015-01-23 00:00:00.000	328649	YY	2015-01-21 00:00:00	155555	 	NULL	NULL	NULL
70243	1	2015-01-21 00:00:00	n417	2015-01-21 00:00:00	N	T	15010262	GS00033647	66085	_	T	2507	n530	FE1	FE1	N	2400.00	2400.00	Y	2015-01-23 00:00:00.000	328669	YE	2015-01-21 00:00:00	114057	 	NULL	NULL	NULL
70244	1	2015-01-21 08:52:00	n319	2015-01-21 00:00:00	N	P	15010195	GS15000165	28000	_	T	12000	n1304	WA3	AN5	N	1000.00	1000.00	Y	2015-01-23 00:00:00.000	328650	YY	2015-01-21 00:00:00	155558	 	NULL	NULL	NULL
70245	1	2015-01-21 00:00:00	n417	2015-01-21 00:00:00	N	T	15010263	GS00033648	66086	_	T	2507	n530	FE1	FE1	N	2400.00	2400.00	Y	2015-01-23 00:00:00.000	328670	YE	2015-01-21 00:00:00	114058	 	NULL	NULL	NULL
70246	1	2015-01-21 00:00:00	n417	2015-01-21 00:00:00	N	T	15010264	GS00033649	66087	_	T	2507	n530	FE1	FE1	N	2400.00	2400.00	Y	2015-01-23 00:00:00.000	328671	YE	2015-01-21 00:00:00	114059	 	NULL	NULL	NULL
70247	1	2015-01-21 00:00:00	n417	2015-01-21 00:00:00	N	T	15010265	GS00033650	66088	_	T	2507	n530	FE11	FE11	N	2700.00	2700.00	Y	2015-01-23 00:00:00.000	328672	YE	2015-01-21 00:00:00	114060	 	NULL	NULL	NULL
70248	1	2015-01-21 00:00:00	n417	2015-01-21 00:00:00	N	T	15010266	GS00033651	66089	_	T	2507	n530	FE11	FE11	N	2700.00	2700.00	Y	2015-01-23 00:00:00.000	328673	YE	2015-01-21 00:00:00	114061	 	NULL	NULL	NULL
70249	1	2015-01-21 09:42:00	n319	2015-01-21 00:00:00	N	P	14070063	GS15000166	24427	_	T	14681	n1489	FR1	AB1	N	7000.00	7000.00	Y	2015-01-23 00:00:00.000	328651	YY	2015-01-21 00:00:00	155559	 	NULL	NULL	NULL
70250	1	2015-01-21 00:00:00	n417	2015-01-22 00:00:00	N	T	15010296	GS00033652	52534	_	T	11878	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-01-26 00:00:00.000	329475	YY	2015-01-22 00:00:00	114085	 	NULL	NULL	NULL
70251	1	2015-01-21 00:00:00	n417	2015-01-22 00:00:00	N	T	15010286	GS00033653	52916	_	T	11878	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-01-26 00:00:00.000	329476	YY	2015-01-22 00:00:00	114086	 	NULL	NULL	NULL
70252	1	2015-01-21 00:00:00	n417	2015-01-22 00:00:00	N	T	15010287	GS00033654	52915	_	T	11878	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-01-26 00:00:00.000	329477	YY	2015-01-22 00:00:00	114087	 	NULL	NULL	NULL
70253	1	2015-01-21 00:00:00	n417	2015-01-22 00:00:00	N	T	15010288	GS00033655	52253	_	T	11878	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-01-26 00:00:00.000	329478	YY	2015-01-22 00:00:00	114088	 	NULL	NULL	NULL
70254	1	2015-01-21 15:33:00	n319	2015-01-22 00:00:00	N	P	15010222	GS15000167	27595	_	T	14006	n896	WS11	AJ2	N	1000.00	1000.00	Y	2015-01-26 00:00:00.000	329470	YY	2015-01-22 00:00:00	155638	 	NULL	NULL	NULL
70255	1	2015-01-21 16:03:00	n319	2015-01-22 00:00:00	N	P	15010231	GS15000168	26733	_	T	10747	n1065	FC1	AL1	D	2000.00	2000.00	Y	2015-01-26 00:00:00.000	329471	YY	2015-01-22 00:00:00	155645	 	NULL	NULL	NULL
70256	1	2015-01-21 17:07:00	n319	2015-01-22 00:00:00	N	P	15010235	GS15000171	25811	_	T	13687	n1489	WS11	AJ2	N	2700.00	2700.00	Y	2015-01-26 00:00:00.000	329472	YY	2015-01-22 00:00:00	155662	 	NULL	NULL	NULL
70257	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010289	GS00033656	52258	_	T	11878	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-01-26 00:00:00.000	329479	YY	2015-01-22 00:00:00	114119	 	NULL	NULL	NULL
70258	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010290	GS00033657	52254	_	T	11878	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-01-26 00:00:00.000	329480	YY	2015-01-22 00:00:00	114120	 	NULL	NULL	NULL
70259	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010291	GS00033658	52255	_	T	11878	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-01-26 00:00:00.000	329481	YY	2015-01-22 00:00:00	114121	 	NULL	NULL	NULL
70260	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010292	GS00033659	52259	_	T	11878	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-01-26 00:00:00.000	329482	YY	2015-01-22 00:00:00	114122	 	NULL	NULL	NULL
70261	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010293	GS00033660	52260	_	T	11878	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-01-26 00:00:00.000	329483	YY	2015-01-22 00:00:00	114123	 	NULL	NULL	NULL
70262	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010294	GS00033661	52256	_	T	11878	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-01-26 00:00:00.000	329484	YY	2015-01-22 00:00:00	114124	 	NULL	NULL	NULL
70263	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010295	GS00033662	52257	_	T	11878	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-01-26 00:00:00.000	329485	YY	2015-01-22 00:00:00	114125	 	NULL	NULL	NULL
70264	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010285	GS00033663	51315	_	T	11878	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-01-26 00:00:00.000	329486	YY	2015-01-22 00:00:00	114126	 	NULL	NULL	NULL
70265	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010284	GS00033664	51316	_	T	11878	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-01-26 00:00:00.000	329487	YY	2015-01-22 00:00:00	114127	 	NULL	NULL	NULL
70266	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010353	GS00033666	65343	_	T	15721	n1350	FF0	FF0	N	2500.00	2500.00	Y	2015-01-26 00:00:00.000	329488	YY	2015-01-22 00:00:00	114129	 	NULL	NULL	NULL
70267	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010315	GS00033667	64971	_	T	15616	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-01-26 00:00:00.000	329489	YY	2015-01-22 00:00:00	114130	 	NULL	NULL	NULL
70268	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010279	GS00033669	66096	_	T	13321	n1384	FR2	FR2	N	8000.00	8000.00	Y	2015-01-26 00:00:00.000	329490	YY	2015-01-22 00:00:00	114132	 	NULL	NULL	NULL
70269	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010280	GS00033670	66097	_	T	13321	n1384	FR2	FR2	N	8000.00	8000.00	Y	2015-01-26 00:00:00.000	329491	YY	2015-01-22 00:00:00	114133	 	NULL	NULL	NULL
70270	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010281	GS00033671	66098	_	T	13321	n1384	FR2	FR2	N	8000.00	8000.00	Y	2015-01-26 00:00:00.000	329492	YY	2015-01-22 00:00:00	114134	 	NULL	NULL	NULL
70271	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010282	GS00033672	66099	_	T	13321	n1384	FR2	FR2	N	8000.00	8000.00	Y	2015-01-26 00:00:00.000	329493	YY	2015-01-22 00:00:00	114136	 	NULL	NULL	NULL
70272	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010333	GS00033673	66118	_	T	15909	n646	FE11	FE11	N	2700.00	2700.00	Y	2015-01-26 00:00:00.000	329494	YE	2015-01-22 00:00:00	114140	 	NULL	NULL	NULL
70273	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010334	GS00033674	66119	_	T	15909	n646	FE11	FE11	N	2700.00	2700.00	Y	2015-01-26 00:00:00.000	329495	YE	2015-01-22 00:00:00	114141	 	NULL	NULL	NULL
70274	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010335	GS00033675	66120	_	T	15909	n646	FE11	FE11	N	2700.00	2700.00	Y	2015-01-26 00:00:00.000	329496	YE	2015-01-22 00:00:00	114142	 	NULL	NULL	NULL
70275	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010344	GS00033676	66121	_	T	15015	n530	FE1	FE1	N	2400.00	2400.00	Y	2015-01-26 00:00:00.000	329497	YE	2015-01-22 00:00:00	114144	 	NULL	NULL	NULL
70276	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010345	GS00033677	66122	_	T	15015	n530	FE1	FE1	N	2400.00	2400.00	Y	2015-01-26 00:00:00.000	329498	YE	2015-01-22 00:00:00	114145	 	NULL	NULL	NULL
70277	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010354	GS00033678	66123	_	T	15015	n530	FE1	FE1	N	2400.00	2400.00	Y	2015-01-26 00:00:00.000	329499	YE	2015-01-22 00:00:00	114146	 	NULL	NULL	NULL
70278	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010355	GS00033679	66124	_	T	15015	n530	FE1	FE1	N	2400.00	2400.00	Y	2015-01-26 00:00:00.000	329500	YE	2015-01-22 00:00:00	114147	 	NULL	NULL	NULL
70279	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010346	GS00033680	66125	_	T	15015	n530	FE1	FE1	N	2400.00	2400.00	Y	2015-01-26 00:00:00.000	329501	YE	2015-01-22 00:00:00	114148	 	NULL	NULL	NULL
70280	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010347	GS00033681	66126	_	T	15015	n530	FE1	FE1	N	2400.00	2400.00	Y	2015-01-26 00:00:00.000	329502	YE	2015-01-22 00:00:00	114149	 	NULL	NULL	NULL
70281	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010348	GS00033682	66127	_	T	15015	n530	FE1	FE1	N	2400.00	2400.00	Y	2015-01-26 00:00:00.000	329503	YE	2015-01-22 00:00:00	114150	 	NULL	NULL	NULL
70282	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010349	GS00033683	66128	_	T	15015	n530	FE1	FE1	N	2400.00	2400.00	Y	2015-01-26 00:00:00.000	329504	YE	2015-01-22 00:00:00	114151	 	NULL	NULL	NULL
70283	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010350	GS00033684	66129	_	T	15015	n530	FE1	FE1	N	2400.00	2400.00	Y	2015-01-26 00:00:00.000	329505	YE	2015-01-22 00:00:00	114152	 	NULL	NULL	NULL
70284	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010351	GS00033685	66130	_	T	15015	n530	FE1	FE1	N	2400.00	2400.00	Y	2015-01-26 00:00:00.000	329506	YE	2015-01-22 00:00:00	114153	 	NULL	NULL	NULL
70285	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010314	GS00033686	37938	_	T	6889	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-01-26 00:00:00.000	329507	YY	2015-01-22 00:00:00	114154	 	NULL	NULL	NULL
70286	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010316	GS00033687	66101	_	T	14930	n428	FE1	FE1	N	2400.00	2400.00	Y	2015-01-26 00:00:00.000	329508	YE	2015-01-22 00:00:00	114155	 	NULL	NULL	NULL
70287	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010317	GS00033688	66102	_	T	14930	n428	FE1	FE1	N	2400.00	2400.00	Y	2015-01-26 00:00:00.000	329509	YE	2015-01-22 00:00:00	114156	 	NULL	NULL	NULL
70288	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010318	GS00033689	66103	_	T	14930	n428	FE1	FE1	N	2400.00	2400.00	Y	2015-01-26 00:00:00.000	329510	YE	2015-01-22 00:00:00	114157	 	NULL	NULL	NULL
70289	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010319	GS00033690	66104	_	T	14930	n428	FE11	FE11	N	2700.00	2700.00	Y	2015-01-26 00:00:00.000	329511	YE	2015-01-22 00:00:00	114158	 	NULL	NULL	NULL
70290	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010321	GS00033691	66106	_	T	14930	n428	FE1	FE1	N	2400.00	2400.00	Y	2015-01-26 00:00:00.000	329512	YE	2015-01-22 00:00:00	114159	 	NULL	NULL	NULL
70291	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010322	GS00033692	66107	_	T	14930	n428	FE1	FE1	N	2400.00	2400.00	Y	2015-01-26 00:00:00.000	329513	YE	2015-01-22 00:00:00	114160	 	NULL	NULL	NULL
70292	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010323	GS00033693	66108	_	T	14930	n428	FE11	FE11	N	2700.00	2700.00	Y	2015-01-26 00:00:00.000	329514	YE	2015-01-22 00:00:00	114161	 	NULL	NULL	NULL
70293	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010324	GS00033694	66109	_	T	14930	n428	FE1	FE1	N	2600.00	2600.00	Y	2015-01-26 00:00:00.000	329515	YE	2015-01-22 00:00:00	114162	 	NULL	NULL	NULL
70294	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010326	GS00033695	66111	_	T	14930	n428	FE1	FE1	N	2400.00	2400.00	Y	2015-01-26 00:00:00.000	329516	YE	2015-01-22 00:00:00	114163	 	NULL	NULL	NULL
70295	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010327	GS00033696	66112	_	T	14930	n428	FE1	FE1	N	2400.00	2400.00	Y	2015-01-26 00:00:00.000	329517	YE	2015-01-22 00:00:00	114164	 	NULL	NULL	NULL
70296	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010328	GS00033697	66113	_	T	14930	n428	FE1	FE1	N	2400.00	2400.00	Y	2015-01-26 00:00:00.000	329518	YE	2015-01-22 00:00:00	114165	 	NULL	NULL	NULL
70297	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010329	GS00033698	66114	_	T	14930	n428	FE1	FE1	N	2400.00	2400.00	Y	2015-01-26 00:00:00.000	329519	YE	2015-01-22 00:00:00	114166	 	NULL	NULL	NULL
70298	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010330	GS00033699	66115	_	T	14930	n428	FE1	FE1	N	2600.00	2600.00	Y	2015-01-26 00:00:00.000	329520	YE	2015-01-22 00:00:00	114167	 	NULL	NULL	NULL
70299	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010331	GS00033700	66116	_	T	14930	n428	FE1	FE1	N	2400.00	2400.00	Y	2015-01-26 00:00:00.000	329521	YE	2015-01-22 00:00:00	114168	 	NULL	NULL	NULL
70300	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010332	GS00033701	66117	_	T	14930	n428	FE1	FE1	N	2400.00	2400.00	Y	2015-01-26 00:00:00.000	329522	YE	2015-01-22 00:00:00	114169	 	NULL	NULL	NULL
70301	1	2015-01-22 09:19:00	n087	2015-01-22 00:00:00	N	P	14120051	GS15000174	28183	_	T	15569	n994	IG1B	AA21	N	9700.00	12100.00	Y	2015-01-26 00:00:00.000	329473	YY	2015-01-22 00:00:00	155675	 	NULL	NULL	NULL
70302	1	2015-01-22 09:19:00	n087	2015-01-22 00:00:00	N	P	15010238	GS15000174	28183	_	T	15569	n994	AC2	AA21	N	2400.00	12100.00	Y	2015-01-26 00:00:00.000	329474	YY	2015-01-22 00:00:00	155675	 	NULL	NULL	NULL
70303	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010320	GS00033702	66105	_	T	14930	n428	FE11	FE11	N	2700.00	2700.00	Y	2015-01-26 00:00:00.000	329523	YE	2015-01-22 00:00:00	114178	 	NULL	NULL	NULL
70304	1	2015-01-22 00:00:00	n417	2015-01-22 00:00:00	N	T	15010325	GS00033703	66110	_	T	14930	n428	FE11	FE11	N	3500.00	3500.00	Y	2015-01-26 00:00:00.000	329524	YE	2015-01-22 00:00:00	114182	 	NULL	NULL	NULL
70305	1	2015-01-22 00:00:00	k1416	2015-01-22 00:00:00	N	T	14120272	BGS0004759	59041	_	T	13362	n1350	AS1	AS1	N	4000.00	4000.00	Y	2015-01-26 00:00:00.000	329531	YY	2015-01-23 00:00:00	114187	 	NULL	NULL	NULL
70306	1	2015-01-22 00:00:00	n417	2015-01-23 00:00:00	N	T	15010362	GS00033704	66131	_	T	15917	n1384	FE11	FE11	N	3700.00	3700.00	Y	2015-01-26 00:00:00.000	329532	YE	2015-01-23 00:00:00	114210	 	NULL	NULL	NULL
70307	1	2015-01-22 00:00:00	n417	2015-01-23 00:00:00	N	T	15010363	GS00033705	66132	_	T	15917	n1384	FE1	FE1	N	3900.00	3900.00	Y	2015-01-26 00:00:00.000	329533	YE	2015-01-23 00:00:00	114211	 	NULL	NULL	NULL
70308	1	2015-01-23 00:00:00	n417	2015-01-23 00:00:00	N	T	15010359	GS00033706	65460	_	T	14080	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-01-26 00:00:00.000	329534	YY	2015-01-23 00:00:00	114214	 	NULL	NULL	NULL
70309	1	2015-01-23 00:00:00	n417	2015-01-23 00:00:00	N	T	15010341	GS00033707	65502	_	T	14032	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-01-26 00:00:00.000	329535	YY	2015-01-23 00:00:00	114215	 	NULL	NULL	NULL
70310	1	2015-01-23 00:00:00	n417	2015-01-23 00:00:00	N	T	15010370	GS00033708	65464	_	T	15692	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-01-26 00:00:00.000	329536	YY	2015-01-23 00:00:00	114216	 	NULL	NULL	NULL
70311	1	2015-01-23 00:00:00	n417	2015-01-23 00:00:00	N	T	15010368	GS00033709	64968	_	T	15630	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-01-26 00:00:00.000	329537	YY	2015-01-23 00:00:00	114217	 	NULL	NULL	NULL
70312	1	2015-01-23 00:00:00	n417	2015-01-23 00:00:00	N	T	15010366	GS00033710	64674	2	T	13501	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-01-26 00:00:00.000	329538	YY	2015-01-23 00:00:00	114218	 	NULL	NULL	NULL
70313	1	2015-01-23 00:00:00	n417	2015-01-23 00:00:00	N	T	15010367	GS00033711	64679	2	T	13501	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-01-26 00:00:00.000	329539	YY	2015-01-23 00:00:00	114219	 	NULL	NULL	NULL
70314	1	2015-01-23 00:00:00	n417	2015-01-23 00:00:00	N	T	15010369	GS00033713	65353	_	T	15718	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-01-26 00:00:00.000	329540	YY	2015-01-23 00:00:00	114221	 	NULL	NULL	NULL
70315	1	2015-01-23 00:00:00	n417	2015-01-23 00:00:00	N	T	15010371	GS00033714	65352	_	T	15718	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-01-26 00:00:00.000	329541	YY	2015-01-23 00:00:00	114222	 	NULL	NULL	NULL
70316	1	2015-01-23 08:45:00	n319	2015-01-23 00:00:00	N	P	15010168	GS15000175	24840	_	T	13777	n1125	WS21	AK3	N	2800.00	2800.00	Y	2015-01-26 00:00:00.000	329525	YY	2015-01-23 00:00:00	155775	 	NULL	NULL	NULL
70317	1	2015-01-23 00:00:00	n417	2015-01-23 00:00:00	N	T	15010372	GS00033716	59917	_	T	14592	n646	FR1	FR1	N	4000.00	4000.00	Y	2015-01-26 00:00:00.000	329542	YY	2015-01-23 00:00:00	114224	 	NULL	NULL	NULL
70318	1	2015-01-23 00:00:00	n417	2015-01-23 00:00:00	N	T	15010373	GS00033717	59918	_	T	14592	n646	FR1	FR1	N	4000.00	4000.00	Y	2015-01-26 00:00:00.000	329543	YY	2015-01-23 00:00:00	114225	 	NULL	NULL	NULL
70319	1	2015-01-23 08:49:00	n319	2015-01-23 00:00:00	N	P	15010239	GS15000177	27427	_	T	15610	n994	WS1	AJ1	N	8500.00	8500.00	Y	2015-01-26 00:00:00.000	329526	YY	2015-01-23 00:00:00	155777	 	NULL	NULL	NULL
70320	1	2015-01-23 08:55:00	n319	2015-01-23 00:00:00	N	P	14100338	GS15000178	28103	_	T	15609	n1065	UG1	AA3	N	3000.00	3000.00	Y	2015-01-26 00:00:00.000	329527	YY	2015-01-23 00:00:00	155778	 	NULL	NULL	NULL
70321	1	2015-01-23 09:20:00	n319	2015-01-23 00:00:00	N	P	14100379	GS15000179	28113	_	T	15856	n994	UG1	AA3	N	3000.00	3000.00	Y	2015-01-26 00:00:00.000	329528	YY	2015-01-23 00:00:00	155779	 	NULL	NULL	NULL
70322	1	2015-01-23 09:26:00	n319	2015-01-23 00:00:00	N	P	14090265	GS15000180	28027	_	T	13961	n1304	IG1E	AA2	N	10500.00	10500.00	Y	2015-01-26 00:00:00.000	329529	YY	2015-01-23 00:00:00	155780	 	NULL	NULL	NULL
70323	1	2015-01-23 10:43:00	n319	2015-01-23 00:00:00	N	P	14120084	GS15000181	28196	_	T	10747	n1065	UG1	AA3	N	3000.00	3000.00	Y	2015-01-26 00:00:00.000	329530	YY	2015-01-23 00:00:00	155791	 	NULL	NULL	NULL
70324	1	2015-01-23 00:00:00	n417	2015-01-26 00:00:00	N	T	15010385	GS00033719	65173	_	T	4610	n547	FF0	FF0	N	2500.00	2500.00	Y	2015-01-26 00:00:00.000	329584	YY	2015-01-26 00:00:00	114252	 	NULL	NULL	NULL
70325	1	2015-01-23 00:00:00	n417	2015-01-26 00:00:00	N	T	15010374	GS00033720	64860	_	T	15600	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-01-26 00:00:00.000	329585	YY	2015-01-26 00:00:00	114253	 	NULL	NULL	NULL
70326	1	2015-01-23 00:00:00	n417	2015-01-26 00:00:00	N	T	15010375	GS00033721	64861	_	T	15600	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-01-26 00:00:00.000	329586	YY	2015-01-26 00:00:00	114254	 	NULL	NULL	NULL
70327	1	2015-01-23 00:00:00	n417	2015-01-26 00:00:00	N	T	15010383	GS00033722	65469	_	T	2195	n646	FF0	FF0	N	2500.00	2500.00	Y	2015-01-26 00:00:00.000	329587	YY	2015-01-26 00:00:00	114255	 	NULL	NULL	NULL
70328	1	2015-01-23 00:00:00	n417	2015-01-26 00:00:00	N	T	15010382	GS00033723	65470	_	T	2195	n646	FF0	FF0	N	2500.00	2500.00	Y	2015-01-26 00:00:00.000	329588	YY	2015-01-26 00:00:00	114256	 	NULL	NULL	NULL
70329	1	2015-01-23 00:00:00	n417	2015-01-26 00:00:00	N	T	15010381	GS00033724	65471	_	T	2195	n646	FF0	FF0	N	2500.00	2500.00	Y	2015-01-26 00:00:00.000	329589	YY	2015-01-26 00:00:00	114257	 	NULL	NULL	NULL
70330	1	2015-01-23 00:00:00	n417	2015-01-26 00:00:00	N	T	15010380	GS00033725	65473	_	T	2195	n646	FF0	FF0	N	2500.00	2500.00	Y	2015-01-26 00:00:00.000	329590	YY	2015-01-26 00:00:00	114258	 	NULL	NULL	NULL
70331	1	2015-01-23 00:00:00	n417	2015-01-26 00:00:00	N	T	15010379	GS00033726	65474	_	T	2195	n646	FF0	FF0	N	2500.00	2500.00	Y	2015-01-26 00:00:00.000	329591	YY	2015-01-26 00:00:00	114259	 	NULL	NULL	NULL
70332	1	2015-01-23 00:00:00	n417	2015-01-26 00:00:00	N	T	15010378	GS00033727	65475	_	T	2195	n646	FF0	FF0	N	2500.00	2500.00	Y	2015-01-26 00:00:00.000	329592	YY	2015-01-26 00:00:00	114260	 	NULL	NULL	NULL
70333	1	2015-01-23 00:00:00	n417	2015-01-26 00:00:00	N	T	15010377	GS00033728	65476	_	T	2195	n646	FF0	FF0	N	2500.00	2500.00	Y	2015-01-26 00:00:00.000	329593	YY	2015-01-26 00:00:00	114261	 	NULL	NULL	NULL
70334	1	2015-01-23 00:00:00	n417	2015-01-26 00:00:00	N	T	15010376	GS00033729	65479	_	T	2195	n646	FF0	FF0	N	2500.00	2500.00	Y	2015-01-26 00:00:00.000	329594	YY	2015-01-26 00:00:00	114262	 	NULL	NULL	NULL
70335	1	2015-01-23 00:00:00	n417	2015-01-26 00:00:00	N	T	15010390	GS00033730	65528	_	T	12033	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-01-26 00:00:00.000	329595	YY	2015-01-26 00:00:00	114280	 	NULL	NULL	NULL
70336	1	2015-01-26 00:00:00	n417	2015-01-26 00:00:00	N	T	15010391	GS00033732	66134	_	T	7749	n646	FE1	FE1	N	2400.00	2400.00	Y	2015-01-26 00:00:00.000	329596	YE	2015-01-26 00:00:00	114284	 	NULL	NULL	NULL
70337	1	2015-01-26 00:00:00	n417	2015-01-26 00:00:00	N	T	15010387	GS00033733	66133	_	T	15918	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-01-26 00:00:00.000	329597	YE	2015-01-26 00:00:00	114285	 	NULL	NULL	NULL
70338	1	2015-01-26 08:39:00	n319	2015-01-26 00:00:00	N	P	15010240	GS15000182	25255	_	T	14334	n896	WS21	AK3	N	8400.00	8400.00	Y	2015-01-26 00:00:00.000	329579	YY	2015-01-26 00:00:00	155896	 	NULL	NULL	NULL
70339	1	2015-01-26 08:43:00	n319	2015-01-26 00:00:00	N	P	15010247	GS15000183	28083	_	T	13971	n1486	WA3	AN5	D	1000.00	1000.00	Y	2015-01-26 00:00:00.000	329580	YY	2015-01-26 00:00:00	155897	 	NULL	NULL	NULL
70340	1	2015-01-26 08:45:00	n319	2015-01-26 00:00:00	N	P	14120292	GS15000184	28239	_	T	13930	n896	IG1E	AA2	N	10500.00	10500.00	Y	2015-01-26 00:00:00.000	329581	YY	2015-01-26 00:00:00	155898	 	NULL	NULL	NULL
70341	1	2015-01-26 00:00:00	n417	2015-01-26 00:00:00	N	T	15010388	GS00033734	54765	_	T	13409	n646	FC2	FC2	N	500.00	500.00	Y	2015-01-26 00:00:00.000	329598	YY	2015-01-26 00:00:00	114286	 	NULL	NULL	NULL
70342	1	2015-01-26 00:00:00	n417	2015-01-26 00:00:00	N	T	15010389	GS00033735	54766	_	T	13409	n646	FC2	FC2	N	500.00	500.00	Y	2015-01-26 00:00:00.000	329599	YY	2015-01-26 00:00:00	114287	 	NULL	NULL	NULL
70343	1	2015-01-26 09:07:00	n319	2015-01-26 00:00:00	N	P	15010211	GS15000187	27989	_	T	10747	n1065	WS8	AK5	N	500.00	500.00	Y	2015-01-26 00:00:00.000	329582	YY	2015-01-26 00:00:00	155901	 	NULL	NULL	NULL
70344	1	2015-01-26 09:41:00	n319	2015-01-26 00:00:00	N	P	14070391	GS15000191	27871	_	T	4610	n994	IG1B	AA21	N	9700.00	9700.00	Y	2015-01-26 00:00:00.000	329583	YY	2015-01-26 00:00:00	155905	 	NULL	NULL	NULL
70345	1	2015-01-26 15:24:00	n319	2015-01-27 00:00:00	N	P	14120177	GS15000194	28210	_	T	7636	n1304	IG1B	AA21	N	9700.00	9700.00	Y	2015-01-29 00:00:00.000	329602	YY	2015-01-27 00:00:00	155980	 	NULL	NULL	NULL
70346	1	2015-01-27 00:00:00	n417	2015-01-27 00:00:00	N	T	15010399	GS00033736	65716	_	T	15538	n1350	FF0	FF0	N	2500.00	2500.00	Y	2015-01-29 00:00:00.000	329609	YY	2015-01-27 00:00:00	114381	 	NULL	NULL	NULL
70347	1	2015-01-27 00:00:00	n417	2015-01-27 00:00:00	N	T	15010400	GS00033737	65717	_	T	15538	n1350	FF0	FF0	N	2500.00	2500.00	Y	2015-01-29 00:00:00.000	329610	YY	2015-01-27 00:00:00	114382	 	NULL	NULL	NULL
70348	1	2015-01-27 00:00:00	n417	2015-01-27 00:00:00	N	T	15010413	GS00033738	65795	_	T	15824	n646	FF0	FF0	N	2500.00	2500.00	Y	2015-01-29 00:00:00.000	329611	YY	2015-01-27 00:00:00	114383	 	NULL	NULL	NULL
70349	1	2015-01-27 00:00:00	n417	2015-01-27 00:00:00	N	T	15010406	GS00033739	65713	_	T	5682	n1350	FF0	FF0	N	2500.00	2500.00	Y	2015-01-29 00:00:00.000	329612	YY	2015-01-27 00:00:00	114384	 	NULL	NULL	NULL
70350	1	2015-01-27 00:00:00	n417	2015-01-27 00:00:00	N	T	15010405	GS00033740	65712	_	T	5682	n1350	FF0	FF0	N	2500.00	2500.00	Y	2015-01-29 00:00:00.000	329613	YY	2015-01-27 00:00:00	114385	 	NULL	NULL	NULL
70351	1	2015-01-27 08:50:00	n319	2015-01-27 00:00:00	N	P	15010028	GS15000196	28264	_	T	15908	n1486	UG1	AA3	N	3000.00	3000.00	Y	2015-01-29 00:00:00.000	329603	YY	2015-01-27 00:00:00	156023	 	NULL	NULL	NULL
70352	1	2015-01-27 08:51:00	n319	2015-01-27 00:00:00	N	P	15010029	GS15000197	28265	_	T	15908	n1486	DG1	AA4	N	3000.00	3000.00	Y	2015-01-29 00:00:00.000	329604	YY	2015-01-27 00:00:00	156024	 	NULL	NULL	NULL
70353	1	2015-01-27 09:17:00	n319	2015-01-27 00:00:00	N	P	14120052	GS15000199	28184	_	T	15569	n994	IG1B	AA21	N	9700.00	12900.00	Y	2015-01-29 00:00:00.000	329605	YY	2015-01-27 00:00:00	156026	 	NULL	NULL	NULL
70354	1	2015-01-27 09:17:00	n319	2015-01-27 00:00:00	N	P	15010272	GS15000199	28184	_	T	15569	n994	AC2	AA21	N	3200.00	12900.00	Y	2015-01-29 00:00:00.000	329606	YY	2015-01-27 00:00:00	156026	 	NULL	NULL	NULL
70355	1	2015-01-27 09:43:00	n319	2015-01-27 00:00:00	N	P	15010252	GS15000200	22075	_	T	437	n1293	WS2	AK2	N	8000.00	8000.00	Y	2015-01-29 00:00:00.000	329607	YE	2015-01-27 00:00:00	156027	 	NULL	NULL	NULL
70356	1	2015-01-27 09:43:00	n319	2015-01-27 00:00:00	N	P	15010253	GS15000201	22076	_	T	437	n1293	WS2	AK2	N	16000.00	16000.00	Y	2015-01-29 00:00:00.000	329608	YE	2015-01-27 00:00:00	156028	 	NULL	NULL	NULL
70357	1	2015-01-27 00:00:00	n417	2015-01-27 00:00:00	N	T	15010418	GS00033744	47713	_	T	11674	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-01-29 00:00:00.000	329614	YY	2015-01-27 00:00:00	114391	 	NULL	NULL	NULL
70358	1	2015-01-27 00:00:00	n417	2015-01-27 00:00:00	N	T	15010420	GS00033745	66136	_	T	11674	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-01-29 00:00:00.000	329615	YY	2015-01-27 00:00:00	114392	 	NULL	NULL	NULL
70359	1	2015-01-27 00:00:00	n417	2015-01-27 00:00:00	N	T	15010417	GS00033746	66137	_	T	11674	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-01-29 00:00:00.000	329616	YY	2015-01-27 00:00:00	114393	 	NULL	NULL	NULL
70360	1	2015-01-27 00:00:00	n417	2015-01-27 00:00:00	N	T	15010419	GS00033747	47712	_	T	11674	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-01-29 00:00:00.000	329617	YY	2015-01-27 00:00:00	114394	 	NULL	NULL	NULL
70361	1	2015-01-27 00:00:00	n417	2015-01-28 00:00:00	N	T	15010416	GS00033748	66135	_	T	15923	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-01-30 00:00:00.000	329632	YE	2015-01-28 00:00:00	114421	 	NULL	NULL	NULL
70362	1	2015-01-27 15:56:00	n319	2015-01-28 00:00:00	N	P	15010286	GS15000202	27842	_	T	15774	n1293	WS11	AJ2	N	6100.00	6100.00	Y	2015-01-30 00:00:00.000	329618	YY	2015-01-28 00:00:00	156081	 	NULL	NULL	NULL
70363	1	2015-01-28 08:40:00	n319	2015-01-28 00:00:00	N	P	15010267	GS15000203	1133	M	T	12293	n113	WS1	AJ1	X	3500.00	3500.00	Y	2015-01-30 00:00:00.000	329619	YY	2015-01-28 00:00:00	156085	 	NULL	NULL	NULL
70364	1	2015-01-28 08:41:00	n319	2015-01-28 00:00:00	N	P	15010257	GS15000204	27851	_	T	14510	n1125	WS11	AJ2	N	4400.00	4400.00	Y	2015-01-30 00:00:00.000	329620	YY	2015-01-28 00:00:00	156086	 	NULL	NULL	NULL
70365	1	2015-01-28 00:00:00	n417	2015-01-28 00:00:00	N	T	15010421	GS00033749	66138	_	T	15922	n646	FE1	FE1	N	8100.00	8100.00	Y	2015-01-30 00:00:00.000	329633	YE	2015-01-28 00:00:00	114432	 	NULL	NULL	NULL
70366	1	2015-01-28 00:00:00	n417	2015-01-28 00:00:00	N	T	15010425	GS00033750	66139	_	T	12455	n824	FE1	FE1	N	2400.00	2400.00	Y	2015-01-30 00:00:00.000	329634	YE	2015-01-28 00:00:00	114433	 	NULL	NULL	NULL
70367	1	2015-01-28 00:00:00	n417	2015-01-28 00:00:00	N	T	15010426	GS00033751	66140	_	T	12455	n824	FE1	FE1	N	2400.00	2400.00	Y	2015-01-30 00:00:00.000	329635	YE	2015-01-28 00:00:00	114434	 	NULL	NULL	NULL
70368	1	2015-01-28 09:23:00	n319	2015-01-28 00:00:00	N	P	15010279	GS15000205	25892	_	T	10747	n1065	WS1	AJ1	N	8500.00	8500.00	Y	2015-01-30 00:00:00.000	329621	YY	2015-01-28 00:00:00	156087	 	NULL	NULL	NULL
70369	1	2015-01-28 09:24:00	n319	2015-01-28 00:00:00	N	P	15010278	GS15000206	26382	_	T	10747	n1065	WS1	AJ1	N	8500.00	8500.00	Y	2015-01-30 00:00:00.000	329622	YY	2015-01-28 00:00:00	156088	 	NULL	NULL	NULL
70370	1	2015-01-28 09:25:00	n319	2015-01-28 00:00:00	N	P	15010280	GS15000207	26937	_	T	10747	n1065	WS1	AJ1	N	8500.00	8500.00	Y	2015-01-30 00:00:00.000	329623	YY	2015-01-28 00:00:00	156089	 	NULL	NULL	NULL
70371	1	2015-01-28 09:26:00	n319	2015-01-28 00:00:00	N	P	15010274	GS15000208	27657	_	T	10747	n1065	WS1	AJ1	N	8500.00	8500.00	Y	2015-01-30 00:00:00.000	329624	YY	2015-01-28 00:00:00	156090	 	NULL	NULL	NULL
70372	1	2015-01-28 09:27:00	n319	2015-01-28 00:00:00	N	P	15010276	GS15000209	27743	_	T	10747	n1065	WS1	AJ1	N	8500.00	8500.00	Y	2015-01-30 00:00:00.000	329625	YY	2015-01-28 00:00:00	156091	 	NULL	NULL	NULL
70373	1	2015-01-28 09:27:00	n319	2015-01-28 00:00:00	N	P	15010277	GS15000210	27822	_	T	10747	n1065	WS1	AJ1	N	8500.00	8500.00	Y	2015-01-30 00:00:00.000	329626	YY	2015-01-28 00:00:00	156092	 	NULL	NULL	NULL
70374	1	2015-01-28 09:28:00	n319	2015-01-28 00:00:00	N	P	15010275	GS15000211	27826	_	T	10747	n1065	WS1	AJ1	N	8500.00	8500.00	Y	2015-01-30 00:00:00.000	329627	YY	2015-01-28 00:00:00	156093	 	NULL	NULL	NULL
70375	1	2015-01-28 09:29:00	n319	2015-01-28 00:00:00	N	P	15010281	GS15000212	27903	_	T	10747	n1065	WS1	AJ1	N	8500.00	8500.00	Y	2015-01-30 00:00:00.000	329628	YY	2015-01-28 00:00:00	156094	 	NULL	NULL	NULL
70376	1	2015-01-28 09:39:00	n319	2015-01-28 00:00:00	N	P	14110290	GS15000213	28170	_	T	11585	n896	IG1E	AA2	N	10500.00	10500.00	Y	2015-01-30 00:00:00.000	329629	YY	2015-01-28 00:00:00	156095	 	NULL	NULL	NULL
70377	1	2015-01-28 09:46:00	n319	2015-01-28 00:00:00	N	P	15010165	GS15000215	24087	_	T	11959	n1065	FR1	AB1	N	7000.00	8600.00	Y	2015-01-30 00:00:00.000	329630	YY	2015-01-28 00:00:00	156097	 	NULL	NULL	NULL
70378	1	2015-01-28 09:46:00	n319	2015-01-28 00:00:00	N	P	15010293	GS15000215	24087	_	T	11959	n1065	FR12	AB1	N	1600.00	8600.00	Y	2015-01-30 00:00:00.000	329631	YY	2015-01-28 00:00:00	156097	 	NULL	NULL	NULL
70379	1	2015-01-28 00:00:00	n417	2015-01-29 00:00:00	N	T	15010298	GS00033758	16650	_	T	3772	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-01-30 00:00:00.000	329641	YY	2015-01-29 00:00:00	114441	 	NULL	NULL	NULL
70380	1	2015-01-28 00:00:00	n417	2015-01-29 00:00:00	N	T	15010423	GS00033759	53320	_	T	8003	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-01-30 00:00:00.000	329642	YY	2015-01-29 00:00:00	114449	 	NULL	NULL	NULL
70381	1	2015-01-28 00:00:00	n417	2015-01-29 00:00:00	N	T	15010424	GS00033760	53321	_	T	8003	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-01-30 00:00:00.000	329643	YY	2015-01-29 00:00:00	114450	 	NULL	NULL	NULL
70382	1	2015-01-28 00:00:00	n417	2015-01-29 00:00:00	N	T	15010427	GS00033762	66141	_	T	2099	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-01-30 00:00:00.000	329644	YE	2015-01-29 00:00:00	114474	 	NULL	NULL	NULL
70383	1	2015-01-28 00:00:00	n417	2015-01-29 00:00:00	N	T	15010428	GS00033763	66142	_	T	2099	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-01-30 00:00:00.000	329645	YE	2015-01-29 00:00:00	114475	 	NULL	NULL	NULL
70384	1	2015-01-28 00:00:00	n417	2015-01-29 00:00:00	N	T	15010434	GS00033765	66143	_	T	3795	n547	FR1	FR1	N	4000.00	4000.00	Y	2015-01-30 00:00:00.000	329646	YY	2015-01-29 00:00:00	114480	 	NULL	NULL	NULL
70385	1	2015-01-29 09:16:00	n319	2015-01-29 00:00:00	N	P	14100082	GS15000217	24759	_	T	13937	n896	FR1	AB1	N	7000.00	13400.00	Y	2015-01-30 00:00:00.000	329636	YY	2015-01-29 00:00:00	156176	 	NULL	NULL	NULL
70386	1	2015-01-29 09:16:00	n319	2015-01-29 00:00:00	N	P	15010301	GS15000217	24759	_	T	13937	n896	FR12	AB1	N	6400.00	13400.00	Y	2015-01-30 00:00:00.000	329637	YY	2015-01-29 00:00:00	156176	 	NULL	NULL	NULL
70387	1	2015-01-29 09:20:00	n319	2015-01-29 00:00:00	N	P	14120287	GS15000219	28237	_	T	13930	n896	IG1E	AA2	N	10500.00	10500.00	Y	2015-01-30 00:00:00.000	329638	YY	2015-01-29 00:00:00	156178	 	NULL	NULL	NULL
70388	1	2015-01-29 09:22:00	n319	2015-01-29 00:00:00	N	P	15010216	GS15000220	28308	_	T	13708	n896	UG1	AA3	N	3000.00	3000.00	Y	2015-01-30 00:00:00.000	329639	YY	2015-01-29 00:00:00	156179	 	NULL	NULL	NULL
70389	1	2015-01-29 09:41:00	n319	2015-01-29 00:00:00	N	P	15010297	GS15000221	18362	A	T	2853	n100	WS2	AK2	N	8000.00	8000.00	Y	2015-01-30 00:00:00.000	329640	YE	2015-01-29 00:00:00	156180	 	NULL	NULL	NULL
70390	1	2015-01-29 15:32:00	n319	2015-01-30 00:00:00	N	P	15010308	GS15000222	21131	_	T	13639	n100	WS21	AK3	N	11400.00	11400.00	Y	2015-02-06 00:00:00.000	329738	YY	2015-01-30 00:00:00	156251	 	NULL	NULL	NULL
70391	1	2015-01-29 15:33:00	n319	2015-01-30 00:00:00	N	P	15010294	GS15000223	25249	_	T	13124	n1304	WS11	AJ2	N	6100.00	6100.00	Y	2015-02-06 00:00:00.000	329739	YY	2015-01-30 00:00:00	156252	 	NULL	NULL	NULL
70392	1	2015-01-29 15:34:00	n319	2015-01-30 00:00:00	N	P	15010295	GS15000224	25249	_	T	13124	n1304	WS21	AK3	N	7600.00	7600.00	Y	2015-02-06 00:00:00.000	329740	YY	2015-01-30 00:00:00	156253	 	NULL	NULL	NULL
70393	1	2015-01-29 15:39:00	n319	2015-01-30 00:00:00	N	P	15010296	GS15000226	27881	_	T	10747	n1065	WS1	AJ1	N	8500.00	8500.00	Y	2015-02-06 00:00:00.000	329741	YY	2015-01-30 00:00:00	156256	 	NULL	NULL	NULL
70394	1	2015-01-30 00:00:00	n417	2015-01-30 00:00:00	N	T	15010460	GS00033766	64479	_	T	15193	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-02-06 00:00:00.000	329753	YY	2015-01-30 00:00:00	114547	 	NULL	NULL	NULL
70395	1	2015-01-30 00:00:00	n417	2015-01-30 00:00:00	N	T	15010447	GS00033767	65529	_	T	12033	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-02-06 00:00:00.000	329754	YY	2015-01-30 00:00:00	114548	 	NULL	NULL	NULL
70396	1	2015-01-30 00:00:00	n417	2015-01-30 00:00:00	N	T	15010437	GS00033768	65317	_	T	7759	n547	FF0	FF0	N	5000.00	5000.00	Y	2015-02-06 00:00:00.000	329755	YY	2015-01-30 00:00:00	114549	 	NULL	NULL	NULL
70397	1	2015-01-30 00:00:00	n417	2015-01-30 00:00:00	N	T	15010435	GS00033769	65315	_	T	7759	n547	FF0	FF0	N	5000.00	5000.00	Y	2015-02-06 00:00:00.000	329756	YY	2015-01-30 00:00:00	114550	 	NULL	NULL	NULL
70398	1	2015-01-30 00:00:00	n417	2015-01-30 00:00:00	N	T	15010436	GS00033770	65316	_	T	7759	n547	FF0	FF0	N	5000.00	5000.00	Y	2015-02-06 00:00:00.000	329757	YY	2015-01-30 00:00:00	114551	 	NULL	NULL	NULL
70399	1	2015-01-30 00:00:00	n417	2015-01-30 00:00:00	N	T	15010443	GS00033771	65798	_	T	15348	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-02-06 00:00:00.000	329758	YY	2015-01-30 00:00:00	114552	 	NULL	NULL	NULL
70400	1	2015-01-30 00:00:00	n417	2015-01-30 00:00:00	N	T	15010442	GS00033772	65797	_	T	15348	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-02-06 00:00:00.000	329759	YY	2015-01-30 00:00:00	114553	 	NULL	NULL	NULL
70401	1	2015-01-30 08:53:00	n319	2015-01-30 00:00:00	N	P	15010315	GS15000227	28296	_	T	10027	n113	WA3	AN5	D	4000.00	4000.00	Y	2015-02-06 00:00:00.000	329742	YY	2015-01-30 00:00:00	156263	 	NULL	NULL	NULL
70402	1	2015-01-30 08:54:00	n319	2015-01-30 00:00:00	N	P	15010316	GS15000228	28297	_	T	10027	n113	WA3	AN5	D	4000.00	4000.00	Y	2015-02-06 00:00:00.000	329743	YY	2015-01-30 00:00:00	156264	 	NULL	NULL	NULL
70403	1	2015-01-30 00:00:00	n417	2015-01-30 00:00:00	N	T	15010446	GS00033773	65747	_	T	6865	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-02-06 00:00:00.000	329760	YY	2015-01-30 00:00:00	114554	 	NULL	NULL	NULL
70404	1	2015-01-30 00:00:00	n417	2015-01-30 00:00:00	N	T	15010445	GS00033774	65746	_	T	6865	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-02-06 00:00:00.000	329761	YY	2015-01-30 00:00:00	114555	 	NULL	NULL	NULL
70405	1	2015-01-30 08:56:00	n319	2015-01-30 00:00:00	N	P	15010109	GS15000229	25483	_	T	12621	n1304	FR1	AB1	N	7000.00	7000.00	Y	2015-02-06 00:00:00.000	329744	YY	2015-01-30 00:00:00	156265	 	NULL	NULL	NULL
70406	1	2015-01-30 00:00:00	n417	2015-01-30 00:00:00	N	T	15010438	GS00033775	66144	_	T	6684	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-02-06 00:00:00.000	329762	YE	2015-01-30 00:00:00	114560	 	NULL	NULL	NULL
70407	1	2015-01-30 09:12:00	n319	2015-01-30 00:00:00	N	P	15010319	GS15000230	28334	_	T	10747	n1065	IG1E	AA2	N	10500.00	10500.00	Y	2015-02-06 00:00:00.000	329745	YY	2015-01-30 00:00:00	156266	 	NULL	NULL	NULL
70408	1	2015-01-30 09:14:00	n319	2015-01-30 00:00:00	N	P	15010320	GS15000231	28335	_	T	10747	n1065	IG1E	AA2	N	10500.00	10500.00	Y	2015-02-06 00:00:00.000	329746	YY	2015-01-30 00:00:00	156267	 	NULL	NULL	NULL
70409	1	2015-01-30 09:22:00	n319	2015-01-30 00:00:00	N	P	15010142	GS15000232	25962	_	T	11959	n1065	FR1	AB1	N	7000.00	12600.00	Y	2015-02-06 00:00:00.000	329747	YY	2015-01-30 00:00:00	156271	 	NULL	NULL	NULL
70410	1	2015-01-30 09:22:00	n319	2015-01-30 00:00:00	N	P	15010318	GS15000232	25962	_	T	11959	n1065	FR12	AB1	N	5600.00	12600.00	Y	2015-02-06 00:00:00.000	329748	YY	2015-01-30 00:00:00	156271	 	NULL	NULL	NULL
70411	1	2015-01-30 09:41:00	n319	2015-01-30 00:00:00	N	P	15010307	GS15000233	27135	_	T	15511	n1125	WS21	AK3	N	3400.00	3400.00	Y	2015-02-06 00:00:00.000	329749	YY	2015-01-30 00:00:00	156277	 	NULL	NULL	NULL
70412	1	2015-01-30 09:44:00	n319	2015-01-30 00:00:00	N	P	15010311	GS15000234	1152	M	T	15318	n113	WS2	AK2	X	8000.00	8000.00	Y	2015-02-06 00:00:00.000	329750	YE	2015-01-30 00:00:00	156278	 	NULL	NULL	NULL
70413	1	2015-01-30 09:44:00	n319	2015-01-30 00:00:00	N	P	15010317	GS15000235	20320	_	T	7489	n650	WS2	AK2	N	8000.00	8000.00	Y	2015-02-06 00:00:00.000	329751	YE	2015-01-30 00:00:00	156279	 	NULL	NULL	NULL
70414	1	2015-01-30 13:51:00	n319	2015-01-30 00:00:00	N	P	14120344	GS15000237	28246	_	T	15569	n994	IG1B	AA21	N	9700.00	9700.00	Y	2015-02-06 00:00:00.000	329752	YY	2015-01-30 00:00:00	156342	 	NULL	NULL	NULL
70415	1	2015-01-30 00:00:00	n417	2015-02-02 00:00:00	N	T	15010441	GS00033778	52131	_	T	12891	n646	FR1	FR1	N	4000.00	4000.00	Y	2015-02-06 00:00:00.000	329781	YY	2015-02-02 00:00:00	114628	 	NULL	NULL	NULL
70416	1	2015-01-30 00:00:00	n417	2015-02-02 00:00:00	N	T	15010439	GS00033779	52132	_	T	12891	n646	FR1	FR1	N	4000.00	4000.00	Y	2015-02-06 00:00:00.000	329782	YY	2015-02-02 00:00:00	114629	 	NULL	NULL	NULL
70417	1	2015-01-30 00:00:00	n417	2015-02-02 00:00:00	N	T	15010440	GS00033780	52133	_	T	12891	n646	FR1	FR1	N	4000.00	4000.00	Y	2015-02-06 00:00:00.000	329783	YY	2015-02-02 00:00:00	114630	 	NULL	NULL	NULL
70418	1	2015-01-30 00:00:00	n417	2015-02-02 00:00:00	N	T	14120094	GS00033781	65967	_	T	15882	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-02-06 00:00:00.000	329784	YY	2015-02-02 00:00:00	114631	 	NULL	NULL	NULL
70419	1	2015-01-30 15:56:00	n319	2015-02-02 00:00:00	N	P	15010271	GS15000238	25503	_	T	9	n994	WS21	AK3	N	2800.00	2800.00	Y	2015-02-06 00:00:00.000	329764	YY	2015-02-02 00:00:00	156369	 	NULL	NULL	NULL
70420	1	2015-01-30 16:00:00	n319	2015-02-02 00:00:00	N	P	15010053	GS15000240	28276	_	T	7683	n650	UG1	AA3	N	3000.00	3000.00	Y	2015-02-06 00:00:00.000	329765	YY	2015-02-02 00:00:00	156371	 	NULL	NULL	NULL
70421	1	2015-01-30 16:04:00	n319	2015-02-02 00:00:00	N	P	15010321	GS15000241	26750	_	T	3791	n650	WS11	AJ2	N	6100.00	6100.00	Y	2015-02-06 00:00:00.000	329766	YY	2015-02-02 00:00:00	156372	 	NULL	NULL	NULL
70422	1	2015-02-02 08:45:00	n319	2015-02-02 00:00:00	N	P	15010199	GS15000242	25676	_	T	13444	n650	FR1	AB1	N	7000.00	7000.00	Y	2015-02-06 00:00:00.000	329767	YY	2015-02-02 00:00:00	156380	 	NULL	NULL	NULL
70423	1	2015-02-02 00:00:00	n417	2015-02-02 00:00:00	N	T	15010468	GS00033784	66146	_	T	13981	n428	FE1	FE1	N	2400.00	2400.00	Y	2015-02-06 00:00:00.000	329785	YE	2015-02-02 00:00:00	114641	 	NULL	NULL	NULL
70424	1	2015-02-02 00:00:00	n417	2015-02-02 00:00:00	N	T	15010470	GS00033785	66147	_	T	13981	n428	FE1	FE1	N	2400.00	2400.00	Y	2015-02-06 00:00:00.000	329786	YE	2015-02-02 00:00:00	114642	 	NULL	NULL	NULL
70425	1	2015-02-02 14:17:00	n319	2015-02-02 00:00:00	N	P	14120191	GS15000245	28219	_	T	4610	n994	IG1B	AA21	N	9700.00	9700.00	Y	2015-02-06 00:00:00.000	329768	YY	2015-02-02 00:00:00	156438	 	NULL	NULL	NULL
70426	1	2015-02-02 14:20:00	n319	2015-02-02 00:00:00	N	P	14070068	GS15000246	27795	_	T	15610	n994	IG1B	AA21	N	9700.00	17700.00	Y	2015-02-06 00:00:00.000	329769	YY	2015-02-02 00:00:00	156440	 	NULL	NULL	NULL
70427	1	2015-02-02 14:20:00	n319	2015-02-02 00:00:00	N	P	15020023	GS15000246	27795	_	T	15610	n994	AC2	AA21	N	8000.00	17700.00	Y	2015-02-06 00:00:00.000	329770	YY	2015-02-02 00:00:00	156440	 	NULL	NULL	NULL
70428	1	2015-02-02 14:21:00	n319	2015-02-02 00:00:00	N	P	14070069	GS15000247	27796	_	T	15610	n994	UG1	AA3	N	3000.00	3000.00	Y	2015-02-06 00:00:00.000	329771	YY	2015-02-02 00:00:00	156442	 	NULL	NULL	NULL
70429	1	2015-02-02 14:24:00	n319	2015-02-02 00:00:00	N	P	14120384	GS15000248	28254	_	T	14032	n994	IG1B	AA21	N	9700.00	21700.00	Y	2015-02-06 00:00:00.000	329772	YY	2015-02-02 00:00:00	156445	 	NULL	NULL	NULL
70430	1	2015-02-02 14:24:00	n319	2015-02-02 00:00:00	N	P	15020022	GS15000248	28254	_	T	14032	n994	AC2	AA21	N	12000.00	21700.00	Y	2015-02-06 00:00:00.000	329773	YY	2015-02-02 00:00:00	156445	 	NULL	NULL	NULL
70431	1	2015-02-02 14:26:00	n319	2015-02-02 00:00:00	N	P	14120385	GS15000249	28255	_	T	14032	n994	UG1	AA3	N	3000.00	3000.00	Y	2015-02-06 00:00:00.000	329774	YY	2015-02-02 00:00:00	156447	 	NULL	NULL	NULL
70432	1	2015-02-02 14:28:00	n319	2015-02-02 00:00:00	N	P	14120386	GS15000250	28256	_	T	14032	n994	IG1B	AA21	N	9700.00	10500.00	Y	2015-02-06 00:00:00.000	329775	YY	2015-02-02 00:00:00	156448	 	NULL	NULL	NULL
70433	1	2015-02-02 14:28:00	n319	2015-02-02 00:00:00	N	P	15020021	GS15000250	28256	_	T	14032	n994	AC2	AA21	N	800.00	10500.00	Y	2015-02-06 00:00:00.000	329776	YY	2015-02-02 00:00:00	156448	 	NULL	NULL	NULL
70434	1	2015-02-02 14:30:00	n319	2015-02-02 00:00:00	N	P	14120387	GS15000251	28257	_	T	14032	n994	UG1	AA3	N	3000.00	3000.00	Y	2015-02-06 00:00:00.000	329777	YY	2015-02-02 00:00:00	156449	 	NULL	NULL	NULL
70435	1	2015-02-02 14:32:00	n319	2015-02-02 00:00:00	N	P	14120388	GS15000252	28258	_	T	14032	n994	IG1B	AA21	N	9700.00	12900.00	Y	2015-02-06 00:00:00.000	329778	YY	2015-02-02 00:00:00	156450	 	NULL	NULL	NULL
70436	1	2015-02-02 14:32:00	n319	2015-02-02 00:00:00	N	P	15020020	GS15000252	28258	_	T	14032	n994	AC2	AA21	N	3200.00	12900.00	Y	2015-02-06 00:00:00.000	329779	YY	2015-02-02 00:00:00	156450	 	NULL	NULL	NULL
70437	1	2015-02-02 14:34:00	n319	2015-02-02 00:00:00	N	P	14120389	GS15000253	28259	_	T	14032	n994	UG1	AA3	N	3000.00	3000.00	Y	2015-02-06 00:00:00.000	329780	YY	2015-02-02 00:00:00	156451	 	NULL	NULL	NULL
70438	1	2015-02-02 15:41:00	n319	2015-02-03 00:00:00	N	P	15010324	GS15000254	21620	_	T	13956	n994	WS21	AK3	N	11400.00	11400.00	Y	2015-02-06 00:00:00.000	329788	YY	2015-02-03 00:00:00	156456	 	NULL	NULL	NULL
70439	1	2015-02-02 15:45:00	n319	2015-02-03 00:00:00	N	P	15020005	GS15000255	27708	_	T	9950	n100	WS11	AJ2	N	6100.00	6100.00	Y	2015-02-06 00:00:00.000	329789	YY	2015-02-03 00:00:00	156457	 	NULL	NULL	NULL
70440	1	2015-02-02 00:00:00	n417	2015-02-03 00:00:00	N	T	15020001	GS00033786	65250	_	T	14956	n1350	FF0	FF0	N	2500.00	2500.00	Y	2015-02-06 00:00:00.000	329802	YY	2015-02-03 00:00:00	114693	 	NULL	NULL	NULL
70441	1	2015-02-02 00:00:00	n417	2015-02-03 00:00:00	N	T	15020002	GS00033787	65577	_	T	15772	n646	FF0	FF0	N	7500.00	7500.00	Y	2015-02-06 00:00:00.000	329803	YY	2015-02-03 00:00:00	114694	 	NULL	NULL	NULL
70442	1	2015-02-02 00:00:00	n417	2015-02-03 00:00:00	N	T	15010467	GS00033788	66150	_	T	6653	n428	FT2	FT2	N	4000.00	2000.00	Y	2015-02-06 00:00:00.000	329804	YY	2015-02-03 00:00:00	114695	 	NULL	NULL	NULL
70443	1	2015-02-02 00:00:00	n417	2015-02-03 00:00:00	N	T	15020003	GS00033790	1235	M	T	15925	n547	FE1	FE1	X	2400.00	2400.00	Y	2015-02-06 00:00:00.000	329805	YE	2015-02-03 00:00:00	114697	 	NULL	NULL	NULL
70444	1	2015-02-02 17:09:00	n319	2015-02-03 00:00:00	N	P	14080263	GS15000257	27941	_	T	7636	n1304	UG1	AA3	N	3000.00	3000.00	Y	2015-02-06 00:00:00.000	329790	YY	2015-02-03 00:00:00	156496	 	NULL	NULL	NULL
70445	1	2015-02-03 08:51:00	n319	2015-02-03 00:00:00	N	P	15020007	GS15000258	1132	M	T	12293	n113	WS1	AJ1	X	3500.00	3500.00	Y	2015-02-06 00:00:00.000	329791	YY	2015-02-03 00:00:00	156500	 	NULL	NULL	NULL
70446	1	2015-02-03 08:55:00	n319	2015-02-03 00:00:00	N	P	14100307	GS15000260	25240	_	T	11405	n1486	FR1	AB1	N	7000.00	7000.00	Y	2015-02-06 00:00:00.000	329792	YY	2015-02-03 00:00:00	156502	 	NULL	NULL	NULL
70447	1	2015-02-03 08:57:00	n319	2015-02-03 00:00:00	N	P	15020004	GS15000261	25857	_	T	15023	n1125	WS21	AK3	N	1700.00	1700.00	Y	2015-02-06 00:00:00.000	329793	YY	2015-02-03 00:00:00	156503	 	NULL	NULL	NULL
70448	1	2015-02-03 09:01:00	n319	2015-02-03 00:00:00	N	P	15020001	GS15000262	26900	_	T	14510	n1125	WS11	AJ2	N	1000.00	1000.00	Y	2015-02-06 00:00:00.000	329794	YY	2015-02-03 00:00:00	156504	 	NULL	NULL	NULL
70449	1	2015-02-03 09:02:00	n319	2015-02-03 00:00:00	N	P	15020002	GS15000263	26901	_	T	14510	n1125	WS11	AJ2	N	1000.00	1000.00	Y	2015-02-06 00:00:00.000	329795	YY	2015-02-03 00:00:00	156505	 	NULL	NULL	NULL
70450	1	2015-02-03 09:03:00	n319	2015-02-03 00:00:00	N	P	15020003	GS15000264	27215	_	T	15556	n1125	WS21	AK3	N	3400.00	3400.00	Y	2015-02-06 00:00:00.000	329796	YY	2015-02-03 00:00:00	156506	 	NULL	NULL	NULL
70451	1	2015-02-03 09:06:00	n319	2015-02-03 00:00:00	N	P	15010124	GS15000265	28278	_	T	14374	n1304	WS11	AJ2	N	6100.00	6100.00	Y	2015-02-06 00:00:00.000	329797	YY	2015-02-03 00:00:00	156507	 	NULL	NULL	NULL
70452	1	2015-02-03 09:07:00	n319	2015-02-03 00:00:00	N	P	15010125	GS15000266	28279	_	T	14374	n1304	WS11	AJ2	N	6100.00	6100.00	Y	2015-02-06 00:00:00.000	329798	YY	2015-02-03 00:00:00	156508	 	NULL	NULL	NULL
70453	1	2015-02-03 00:00:00	n417	2015-02-03 00:00:00	N	T	15010471	GS00033791	66148	_	T	15503	n428	FE1	FE1	N	2400.00	2400.00	Y	2015-02-06 00:00:00.000	329806	YE	2015-02-03 00:00:00	114701	 	NULL	NULL	NULL
70454	1	2015-02-03 00:00:00	n417	2015-02-03 00:00:00	N	T	15010472	GS00033792	66149	_	T	15503	n428	FE1	FE1	N	2400.00	2400.00	Y	2015-02-06 00:00:00.000	329807	YE	2015-02-03 00:00:00	114702	 	NULL	NULL	NULL
70455	1	2015-02-03 09:24:00	n319	2015-02-03 00:00:00	N	P	15010333	GS15000268	28338	_	T	10747	n1065	IG1E	AA2	N	10500.00	10500.00	Y	2015-02-06 00:00:00.000	329799	YY	2015-02-03 00:00:00	156511	 	NULL	NULL	NULL
70456	1	2015-02-03 09:43:00	n319	2015-02-03 00:00:00	N	P	15010326	GS15000269	19778	_	T	13438	n994	WS2	AK2	N	6000.00	6000.00	Y	2015-02-06 00:00:00.000	329800	YE	2015-02-03 00:00:00	156512	 	NULL	NULL	NULL
70457	1	2015-02-03 09:43:00	n319	2015-02-03 00:00:00	N	P	15020006	GS15000270	25461	_	T	2745	n100	WS2	AK2	N	12000.00	12000.00	Y	2015-02-06 00:00:00.000	329801	YE	2015-02-03 00:00:00	156513	 	NULL	NULL	NULL
70458	1	2015-02-03 00:00:00	n417	2015-02-04 00:00:00	N	T	15020011	GS00033793	65029	_	T	827	n428	FF0	FF0	N	7500.00	7500.00	Y	2015-02-09 00:00:00.000	329842	YY	2015-02-04 00:00:00	114707	 	NULL	NULL	NULL
70459	1	2015-02-03 00:00:00	n417	2015-02-04 00:00:00	N	T	15020008	GS00033794	65540	2	T	14211	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-02-09 00:00:00.000	329843	YY	2015-02-04 00:00:00	114708	 	NULL	NULL	NULL
70460	1	2015-02-03 15:13:00	n319	2015-02-04 00:00:00	N	P	15020017	GS15000271	23543	_	T	12621	n1304	WS11	AJ2	N	2700.00	2700.00	Y	2015-02-09 00:00:00.000	329820	YY	2015-02-04 00:00:00	156590	 	NULL	NULL	NULL
70461	1	2015-02-03 15:15:00	n319	2015-02-04 00:00:00	N	P	15020018	GS15000272	25776	_	T	12621	n1304	WS11	AJ2	N	2700.00	2700.00	Y	2015-02-09 00:00:00.000	329821	YY	2015-02-04 00:00:00	156592	 	NULL	NULL	NULL
70462	1	2015-02-03 15:16:00	n319	2015-02-04 00:00:00	N	P	15020019	GS15000273	25860	_	T	12621	n1304	WS11	AJ2	N	2700.00	2700.00	Y	2015-02-09 00:00:00.000	329822	YY	2015-02-04 00:00:00	156593	 	NULL	NULL	NULL
70463	1	2015-02-03 17:44:00	n319	2015-02-04 00:00:00	N	P	14110250	GS15000278	28164	_	T	7636	n1304	UG1	AA3	N	3000.00	3000.00	Y	2015-02-09 00:00:00.000	329823	YY	2015-02-04 00:00:00	156614	 	NULL	NULL	NULL
70464	1	2015-02-04 00:00:00	n417	2015-02-04 00:00:00	N	T	15020019	GS00033795	65247	_	T	13937	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-02-09 00:00:00.000	329844	YY	2015-02-04 00:00:00	114738	 	NULL	NULL	NULL
70465	1	2015-02-04 00:00:00	n417	2015-02-04 00:00:00	N	T	15020018	GS00033796	49618	_	T	12022	n1384	FI1	FI1	N	500.00	500.00	Y	2015-02-09 00:00:00.000	329845	YY	2015-02-04 00:00:00	114739	 	NULL	NULL	NULL
70466	1	2015-02-04 08:45:00	n087	2015-02-04 00:00:00	N	P	14120362	GS15000280	27972	_	T	12548	n896	LM3	AN2	N	5000.00	5000.00	Y	2015-02-09 00:00:00.000	329824	YY	2015-02-04 00:00:00	156624	 	NULL	NULL	NULL
70467	1	2015-02-04 08:48:00	n087	2015-02-04 00:00:00	N	P	15020031	GS15000281	26505	_	T	13042	n650	WS11	AJ2	N	6100.00	6100.00	Y	2015-02-09 00:00:00.000	329825	YY	2015-02-04 00:00:00	156626	 	NULL	NULL	NULL
70468	1	2015-02-04 08:49:00	n087	2015-02-04 00:00:00	N	P	15020032	GS15000282	26506	_	T	13042	n650	WS11	AJ2	N	6100.00	6100.00	Y	2015-02-09 00:00:00.000	329826	YY	2015-02-04 00:00:00	156627	 	NULL	NULL	NULL
70469	1	2015-02-04 08:50:00	n087	2015-02-04 00:00:00	N	P	15020033	GS15000283	26507	_	T	13042	n650	WS11	AJ2	N	6100.00	6100.00	Y	2015-02-09 00:00:00.000	329827	YY	2015-02-04 00:00:00	156628	 	NULL	NULL	NULL
70470	1	2015-02-04 08:52:00	n087	2015-02-04 00:00:00	N	P	15010221	GS15000284	28308	_	T	13708	n896	WA3	AN5	D	1000.00	1000.00	Y	2015-02-09 00:00:00.000	329828	YY	2015-02-04 00:00:00	156629	 	NULL	NULL	NULL
70471	1	2015-02-04 08:58:00	n087	2015-02-04 00:00:00	N	P	14090171	GS15000285	28001	_	T	7636	n1304	IG1B	AA21	N	9700.00	9700.00	Y	2015-02-09 00:00:00.000	329829	YY	2015-02-04 00:00:00	156630	 	NULL	NULL	NULL
70472	1	2015-02-04 00:00:00	n417	2015-02-04 00:00:00	N	T	15020016	GS00033797	52938	_	T	5436	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-02-09 00:00:00.000	329846	YY	2015-02-04 00:00:00	114740	 	NULL	NULL	NULL
70473	1	2015-02-04 00:00:00	n417	2015-02-04 00:00:00	N	T	15020014	GS00033800	65739	_	T	15807	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-02-09 00:00:00.000	329847	YY	2015-02-04 00:00:00	114743	 	NULL	NULL	NULL
70474	1	2015-02-04 00:00:00	n417	2015-02-04 00:00:00	N	T	15020013	GS00033801	65738	_	T	15807	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-02-09 00:00:00.000	329848	YY	2015-02-04 00:00:00	114744	 	NULL	NULL	NULL
70475	1	2015-02-04 09:14:00	n087	2015-02-04 00:00:00	N	P	15020034	GS15000286	22004	_	T	13472	n1304	WS1	AJ1	N	8500.00	8500.00	Y	2015-02-09 00:00:00.000	329830	YY	2015-02-04 00:00:00	156631	 	NULL	NULL	NULL
70476	1	2015-02-04 09:15:00	n087	2015-02-04 00:00:00	N	P	15020035	GS15000287	24773	_	T	13472	n1304	WS1	AJ1	N	8500.00	8500.00	Y	2015-02-09 00:00:00.000	329831	YY	2015-02-04 00:00:00	156632	 	NULL	NULL	NULL
70477	1	2015-02-04 09:16:00	n087	2015-02-04 00:00:00	N	P	15020037	GS15000288	25654	_	T	13472	n1304	WS1	AJ1	N	8500.00	8500.00	Y	2015-02-09 00:00:00.000	329832	YY	2015-02-04 00:00:00	156633	 	NULL	NULL	NULL
70478	1	2015-02-04 09:17:00	n087	2015-02-04 00:00:00	N	P	15020038	GS15000289	24967	_	T	13472	n1304	WS1	AJ1	N	8500.00	8500.00	Y	2015-02-09 00:00:00.000	329833	YY	2015-02-04 00:00:00	156634	 	NULL	NULL	NULL
70479	1	2015-02-04 09:17:00	n087	2015-02-04 00:00:00	N	P	15020036	GS15000290	26073	_	T	13472	n1304	WS1	AJ1	N	8500.00	8500.00	Y	2015-02-09 00:00:00.000	329834	YY	2015-02-04 00:00:00	156635	 	NULL	NULL	NULL
70480	1	2015-02-04 09:21:00	n087	2015-02-04 00:00:00	N	P	13080023	GS15000291	27014	_	T	2853	n100	IG1E	AA2	N	10500.00	10500.00	Y	2015-02-09 00:00:00.000	329835	YY	2015-02-04 00:00:00	156636	 	NULL	NULL	NULL
70482	1	2015-02-04 09:30:00	n087	2015-02-04 00:00:00	N	P	14120264	GS15000292	28228	_	T	15903	n1304	IG1E	AA2	N	10500.00	16100.00	Y	2015-02-09 00:00:00.000	329836	YY	2015-02-04 00:00:00	156637	 	NULL	NULL	NULL
70483	1	2015-02-04 09:30:00	n087	2015-02-04 00:00:00	N	P	15020039	GS15000292	28228	_	T	15903	n1304		AA2	N	5600.00	16100.00	Y	2015-02-09 00:00:00.000	329837	YY	2015-02-04 00:00:00	156637	 	NULL	NULL	NULL
70484	1	2015-02-04 09:32:00	n087	2015-02-04 00:00:00	N	P	14120265	GS15000293	28229	_	T	15903	n1304	UG1	AA3	N	3000.00	3000.00	Y	2015-02-09 00:00:00.000	329838	YY	2015-02-04 00:00:00	156638	 	NULL	NULL	NULL
70485	1	2015-02-04 09:35:00	n087	2015-02-04 00:00:00	N	P	14110251	GS15000294	28165	_	T	7636	n1304	UG1	AA3	N	3000.00	3000.00	Y	2015-02-09 00:00:00.000	329839	YY	2015-02-04 00:00:00	156639	 	NULL	NULL	NULL
70486	1	2015-02-04 11:55:00	n087	2015-02-04 00:00:00	N	P	15010337	GS15000297	26757	_	T	12002	n896	WS1	AJ1	N	23500.00	23500.00	Y	2015-02-09 00:00:00.000	329840	YY	2015-02-04 00:00:00	156665	 	NULL	NULL	NULL
70487	1	2015-02-04 14:25:00	n087	2015-02-04 00:00:00	N	P	15020054	GS15000298	28344	_	T	10747	n1065	IG1E	AA2	N	10500.00	10500.00	Y	2015-02-09 00:00:00.000	329841	YY	2015-02-04 00:00:00	156686	 	NULL	NULL	NULL
70488	1	2015-02-04 00:00:00	n417	2015-02-05 00:00:00	N	T	15020029	GS00033802	66152	_	T	11638	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-02-09 00:00:00.000	329852	YY	2015-02-05 00:00:00	114778	 	NULL	NULL	NULL
70489	1	2015-02-04 00:00:00	k1416	2015-02-04 00:00:00	N	T	15010465	BGS0004784	66145	_	T	2164	n441	DR1	DR1	N	7000.00	7000.00	Y	2015-02-09 00:00:00.000	329853	YY	2015-02-05 00:00:00	114790	 	NULL	NULL	NULL
70490	1	2015-02-04 00:00:00	n417	2015-02-05 00:00:00	N	T	15020036	GS00033803	65599	_	T	15295	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-02-09 00:00:00.000	329854	YY	2015-02-05 00:00:00	114793	 	NULL	NULL	NULL
70491	1	2015-02-04 00:00:00	n417	2015-02-05 00:00:00	N	T	15020035	GS00033804	61588	_	T	14965	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-02-09 00:00:00.000	329855	YY	2015-02-05 00:00:00	114794	 	NULL	NULL	NULL
70492	1	2015-02-04 00:00:00	n417	2015-02-05 00:00:00	N	T	15020031	GS00033805	65452	_	T	14800	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-02-09 00:00:00.000	329856	YY	2015-02-05 00:00:00	114795	 	NULL	NULL	NULL
70493	1	2015-02-04 00:00:00	n417	2015-02-05 00:00:00	N	T	15020032	GS00033806	65454	_	T	14800	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-02-09 00:00:00.000	329857	YY	2015-02-05 00:00:00	114796	 	NULL	NULL	NULL
70494	1	2015-02-04 00:00:00	n417	2015-02-05 00:00:00	N	T	15020033	GS00033807	65455	_	T	14800	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-02-09 00:00:00.000	329858	YY	2015-02-05 00:00:00	114797	 	NULL	NULL	NULL
70495	1	2015-02-04 00:00:00	n417	2015-02-05 00:00:00	N	T	15020034	GS00033808	65456	_	T	14800	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-02-09 00:00:00.000	329859	YY	2015-02-05 00:00:00	114798	 	NULL	NULL	NULL
70496	1	2015-02-05 08:46:00	n319	2015-02-05 00:00:00	N	P	15010152	GS15000301	26974	_	T	4610	n994	FC1	AL1	N	2000.00	2000.00	Y	2015-02-09 00:00:00.000	329849	YY	2015-02-05 00:00:00	156703	 	NULL	NULL	NULL
70497	1	2015-02-05 08:53:00	n319	2015-02-05 00:00:00	N	P	14120309	GS15000303	28244	_	T	15905	n1125	IG1E	AA2	N	10500.00	10500.00	Y	2015-02-09 00:00:00.000	329850	YY	2015-02-05 00:00:00	156705	 	NULL	NULL	NULL
70498	1	2015-02-05 09:42:00	n319	2015-02-05 00:00:00	N	P	15020041	GS15000305	1019	M	T	12222	n113	WS2	AK2	X	16000.00	16000.00	Y	2015-02-09 00:00:00.000	329851	YE	2015-02-05 00:00:00	156707	 	NULL	NULL	NULL
70499	1	2015-02-05 00:00:00	n417	2015-02-06 00:00:00	N	T	15020038	GS00033809	65363	_	T	14975	n646	FF0	FF0	N	2500.00	2500.00	Y	2015-02-11 00:00:00.000	329880	YY	2015-02-06 00:00:00	114809	 	NULL	NULL	NULL
70500	1	2015-02-05 00:00:00	n417	2015-02-06 00:00:00	N	T	15020043	GS00033811	65743	_	T	14643	n1350	FF0	FF0	N	2500.00	2500.00	Y	2015-02-11 00:00:00.000	329881	YY	2015-02-06 00:00:00	114843	 	NULL	NULL	NULL
70501	1	2015-02-05 00:00:00	n417	2015-02-06 00:00:00	N	T	15020045	GS00033812	65303	_	T	13981	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-02-11 00:00:00.000	329882	YY	2015-02-06 00:00:00	114844	 	NULL	NULL	NULL
70502	1	2015-02-05 00:00:00	n417	2015-02-06 00:00:00	N	T	15020050	GS00033813	65243	_	T	15480	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-02-11 00:00:00.000	329883	YY	2015-02-06 00:00:00	114845	 	NULL	NULL	NULL
70503	1	2015-02-05 00:00:00	n417	2015-02-06 00:00:00	N	T	15020051	GS00033814	65244	_	T	15480	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-02-11 00:00:00.000	329884	YY	2015-02-06 00:00:00	114846	 	NULL	NULL	NULL
70504	1	2015-02-05 00:00:00	n417	2015-02-06 00:00:00	N	T	15020049	GS00033815	65246	_	T	15480	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-02-11 00:00:00.000	329885	YY	2015-02-06 00:00:00	114847	 	NULL	NULL	NULL
70505	1	2015-02-05 00:00:00	n417	2015-02-06 00:00:00	N	T	15020039	GS00033817	66153	_	T	14703	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-02-11 00:00:00.000	329886	YE	2015-02-06 00:00:00	114854	 	NULL	NULL	NULL
70506	1	2015-02-05 15:37:00	n319	2015-02-06 00:00:00	N	P	14110171	GS15000307	28147	_	T	15252	n1304	UG1	AA3	N	3000.00	3000.00	Y	2015-02-11 00:00:00.000	329867	YY	2015-02-06 00:00:00	156809	 	NULL	NULL	NULL
70507	1	2015-02-06 00:00:00	n417	2015-02-06 00:00:00	N	T	15020056	GS00033818	65195	_	T	14993	n1350	FF0	FF0	N	2500.00	2500.00	Y	2015-02-11 00:00:00.000	329887	YY	2015-02-06 00:00:00	114878	 	NULL	NULL	NULL
70508	1	2015-02-06 08:49:00	n319	2015-02-06 00:00:00	N	P	15020046	GS15000308	27902	_	T	15786	n1125	WA3	AN5	D	1000.00	1000.00	Y	2015-02-11 00:00:00.000	329868	YY	2015-02-06 00:00:00	156848	 	NULL	NULL	NULL
70509	1	2015-02-06 08:50:00	n319	2015-02-06 00:00:00	N	P	15020057	GS15000309	28047	_	T	14032	n994	WS1	AJ1	N	8500.00	8500.00	Y	2015-02-11 00:00:00.000	329869	YY	2015-02-06 00:00:00	156849	 	NULL	NULL	NULL
70510	1	2015-02-06 08:51:00	n319	2015-02-06 00:00:00	N	P	15020056	GS15000310	28049	_	T	14032	n994	WS1	AJ1	N	8500.00	8500.00	Y	2015-02-11 00:00:00.000	329870	YY	2015-02-06 00:00:00	156850	 	NULL	NULL	NULL
70511	1	2015-02-06 08:53:00	n319	2015-02-06 00:00:00	N	P	14120162	GS15000311	28206	_	T	15598	n1125	UG1	AA3	N	3000.00	3000.00	Y	2015-02-11 00:00:00.000	329871	YY	2015-02-06 00:00:00	156851	 	NULL	NULL	NULL
70512	1	2015-02-06 09:43:00	n319	2015-02-06 00:00:00	N	P	14120082	GS15000315	28194	_	T	10747	n1065	UG1	AA3	N	3000.00	3000.00	Y	2015-02-11 00:00:00.000	329872	YY	2015-02-06 00:00:00	156855	 	NULL	NULL	NULL
70513	1	2015-02-06 09:45:00	n319	2015-02-06 00:00:00	N	P	14120083	GS15000316	28195	_	T	10747	n1065	UG1	AA3	N	3000.00	3000.00	Y	2015-02-11 00:00:00.000	329873	YY	2015-02-06 00:00:00	156856	 	NULL	NULL	NULL
70514	1	2015-02-06 09:45:00	n319	2015-02-06 00:00:00	N	P	15020066	GS15000317	19297	_	T	13271	n113	WS2	AK2	N	8000.00	8000.00	Y	2015-02-11 00:00:00.000	329874	YE	2015-02-06 00:00:00	156857	 	NULL	NULL	NULL
70515	1	2015-02-06 09:49:00	n319	2015-02-06 00:00:00	N	P	15010084	GS15000318	27332	_	T	15569	n994	FR1	AB1	N	7000.00	11800.00	Y	2015-02-11 00:00:00.000	329875	YY	2015-02-06 00:00:00	156858	 	NULL	NULL	NULL
70516	1	2015-02-06 09:49:00	n319	2015-02-06 00:00:00	N	P	15020060	GS15000318	27332	_	T	15569	n994	FR12	AB1	N	4800.00	11800.00	Y	2015-02-11 00:00:00.000	329876	YY	2015-02-06 00:00:00	156858	 	NULL	NULL	NULL
70517	1	2015-02-06 00:00:00	n417	2015-02-09 00:00:00	N	T	15020058	GS00033819	65249	_	T	14956	n1350	FF0	FF0	N	2500.00	2500.00	Y	2015-02-11 00:00:00.000	329895	YY	2015-02-09 00:00:00	114891	 	NULL	NULL	NULL
70518	1	2015-02-06 11:21:00	n319	2015-02-06 00:00:00	N	P	15010244	GS15000320	28318	_	T	15919	n1065	IG1E	AA2	N	10500.00	15300.00	Y	2015-02-11 00:00:00.000	329877	YY	2015-02-06 00:00:00	156871	 	NULL	NULL	NULL
70519	1	2015-02-06 11:21:00	n319	2015-02-06 00:00:00	N	P	15020074	GS15000320	28318	_	T	15919	n1065	AC2	AA2	N	4800.00	15300.00	Y	2015-02-11 00:00:00.000	329878	YY	2015-02-06 00:00:00	156871	 	NULL	NULL	NULL
70520	1	2015-02-06 11:22:00	n319	2015-02-06 00:00:00	N	P	15020048	GS15000321	28342	_	T	15919	n1065	UG1	AA3	N	3000.00	3000.00	Y	2015-02-11 00:00:00.000	329879	YY	2015-02-06 00:00:00	156872	 	NULL	NULL	NULL
70521	1	2015-02-06 15:12:00	n319	2015-02-09 00:00:00	N	P	15020040	GS15000323	1136	M	T	12293	n113	IGEA	AA6	X	7000.00	7000.00	Y	2015-02-11 00:00:00.000	329888	YY	2015-02-09 00:00:00	156937	 	NULL	NULL	NULL
70522	1	2015-02-06 15:13:00	n319	2015-02-09 00:00:00	N	P	15020075	GS15000324	23970	_	T	13648	n650	WS21	AK3	N	2800.00	2800.00	Y	2015-02-11 00:00:00.000	329889	YY	2015-02-09 00:00:00	156938	 	NULL	NULL	NULL
70523	1	2015-02-06 15:14:00	n319	2015-02-09 00:00:00	N	P	15020061	GS15000325	25866	_	T	13930	n896	WS1	AJ1	N	23500.00	23500.00	Y	2015-02-11 00:00:00.000	329890	YY	2015-02-09 00:00:00	156941	 	NULL	NULL	NULL
70524	1	2015-02-09 00:00:00	n417	2015-02-09 00:00:00	N	T	15020063	GS00033822	51750	_	T	11491	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-02-11 00:00:00.000	329896	YY	2015-02-09 00:00:00	114938	 	NULL	NULL	NULL
70525	1	2015-02-09 08:43:00	n319	2015-02-09 00:00:00	N	P	15020065	GS15000326	1145	M	T	14865	n113	WS21	AK3	X	18100.00	18100.00	Y	2015-02-11 00:00:00.000	329891	YY	2015-02-09 00:00:00	156956	 	NULL	NULL	NULL
70527	1	2015-02-09 08:50:00	n319	2015-02-09 00:00:00	N	P	15010032	GS15000328	26201	_	T	15145	n113	FR1	AB1	N	20600.00	20600.00	Y	2015-02-11 00:00:00.000	329892	YY	2015-02-09 00:00:00	156958	 	NULL	NULL	NULL
70528	1	2015-02-09 08:58:00	n319	2015-02-09 00:00:00	N	P	15010074	GS15000333	28281	_	T	15336	n1125	IG1E	AA2	N	10500.00	10500.00	Y	2015-02-11 00:00:00.000	329893	YY	2015-02-09 00:00:00	156963	 	NULL	NULL	NULL
70529	1	2015-02-09 08:59:00	n319	2015-02-09 00:00:00	N	P	15010078	GS15000334	28282	_	T	15336	n1125	UG1	AA3	N	3000.00	3000.00	Y	2015-02-11 00:00:00.000	329894	YY	2015-02-09 00:00:00	156964	 	NULL	NULL	NULL
70530	1	2015-02-10 08:39:00	n319	2015-02-10 00:00:00	N	P	15020076	GS15000339	24578	_	T	14717	n1304	WS21	AK3	N	8400.00	8400.00	Y	2015-02-12 00:00:00.000	330518	YY	2015-02-10 00:00:00	157067	 	NULL	NULL	NULL
70531	1	2015-02-10 08:42:00	n319	2015-02-10 00:00:00	N	P	15020105	GS15000340	24845	_	T	14794	n1125	WS21	AK3	N	1600.00	1600.00	Y	2015-02-12 00:00:00.000	330519	YY	2015-02-10 00:00:00	157068	 	NULL	NULL	NULL
70532	1	2015-02-10 08:44:00	n319	2015-02-10 00:00:00	N	P	15020106	GS15000341	24846	_	T	14794	n1125	WS21	AK3	N	1600.00	1600.00	Y	2015-02-12 00:00:00.000	330520	YY	2015-02-10 00:00:00	157069	 	NULL	NULL	NULL
70533	1	2015-02-10 08:47:00	n319	2015-02-10 00:00:00	N	P	15010225	GS15000342	26576	_	T	14972	n994	BA8	AB8	N	1000.00	1000.00	Y	2015-02-12 00:00:00.000	330521	YY	2015-02-10 00:00:00	157070	 	NULL	NULL	NULL
70534	1	2015-02-10 08:50:00	n319	2015-02-10 00:00:00	N	P	15020089	GS15000344	27393	_	T	15569	n994	WA3	AN5	D	1000.00	1000.00	Y	2015-02-12 00:00:00.000	330522	YY	2015-02-10 00:00:00	157072	 	NULL	NULL	NULL
70535	1	2015-02-10 08:50:00	n319	2015-02-10 00:00:00	N	P	15020090	GS15000345	27393	_	T	15569	n994	WA3	AN5	D	1000.00	1000.00	Y	2015-02-12 00:00:00.000	330523	YY	2015-02-10 00:00:00	157073	 	NULL	NULL	NULL
70536	1	2015-02-10 08:52:00	n319	2015-02-10 00:00:00	N	P	15020098	GS15000346	27925	_	T	15152	n1065	WS11	AJ2	N	6100.00	6100.00	Y	2015-02-12 00:00:00.000	330524	YY	2015-02-10 00:00:00	157074	 	NULL	NULL	NULL
70537	1	2015-02-10 08:53:00	n319	2015-02-10 00:00:00	N	P	14120204	GS15000347	28220	_	T	12331	n896	UG1	AA3	N	3000.00	3000.00	Y	2015-02-12 00:00:00.000	330525	YY	2015-02-10 00:00:00	157075	 	NULL	NULL	NULL
70538	1	2015-02-10 08:55:00	n319	2015-02-10 00:00:00	N	P	14120291	GS15000348	28238	_	T	13930	n896	IG1E	AA2	N	10500.00	10500.00	Y	2015-02-12 00:00:00.000	330526	YY	2015-02-10 00:00:00	157076	 	NULL	NULL	NULL
70539	1	2015-02-10 00:00:00	n417	2015-02-10 00:00:00	N	T	15020082	GS00033827	65791	_	T	7683	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-02-12 00:00:00.000	330527	YY	2015-02-10 00:00:00	114980	 	NULL	NULL	NULL
70540	1	2015-02-10 00:00:00	n417	2015-02-10 00:00:00	N	T	15020081	GS00033828	65789	_	T	7683	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-02-12 00:00:00.000	330528	YY	2015-02-10 00:00:00	114981	 	NULL	NULL	NULL
70541	1	2015-02-10 00:00:00	n417	2015-02-10 00:00:00	N	T	15020080	GS00033831	65809	_	T	13211	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-02-12 00:00:00.000	330529	YY	2015-02-10 00:00:00	114984	 	NULL	NULL	NULL
70542	1	2015-02-10 00:00:00	n417	2015-02-10 00:00:00	N	T	15020083	GS00033832	66157	_	T	2560	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-02-12 00:00:00.000	330530	YY	2015-02-10 00:00:00	114985	 	NULL	NULL	NULL
70543	1	2015-02-10 00:00:00	n417	2015-02-10 00:00:00	N	T	15020074	GS00033833	66160	_	T	13104	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-02-12 00:00:00.000	330531	YY	2015-02-10 00:00:00	114986	 	NULL	NULL	NULL
70544	1	2015-02-10 00:00:00	n417	2015-02-10 00:00:00	N	T	15020117	GS00033834	51675	_	T	12750	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-02-12 00:00:00.000	330532	YY	2015-02-10 00:00:00	114987	 	NULL	NULL	NULL
70545	1	2015-02-10 00:00:00	n417	2015-02-10 00:00:00	N	T	15020154	GS00033836	65451	_	T	14570	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-02-12 00:00:00.000	330533	YY	2015-02-10 00:00:00	114989	 	NULL	NULL	NULL
70546	1	2015-02-10 00:00:00	n417	2015-02-10 00:00:00	N	T	15020073	GS00033837	66156	_	T	15928	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-02-12 00:00:00.000	330534	YE	2015-02-10 00:00:00	114990	 	NULL	NULL	NULL
70547	1	2015-02-10 00:00:00	n417	2015-02-10 00:00:00	N	T	15020078	GS00033838	66154	_	T	15908	n1384	FE11	FE11	N	2700.00	2700.00	Y	2015-02-12 00:00:00.000	330535	YE	2015-02-10 00:00:00	114991	 	NULL	NULL	NULL
70548	1	2015-02-10 00:00:00	n417	2015-02-10 00:00:00	N	T	15020079	GS00033839	66155	_	T	15908	n1384	FE11	FE11	N	2700.00	2700.00	Y	2015-02-12 00:00:00.000	330536	YE	2015-02-10 00:00:00	114992	 	NULL	NULL	NULL
70549	1	2015-02-10 17:18:00	n319	2015-02-11 00:00:00	N	P	14120144	GS15000349	28203	_	T	13930	n896	IG1E	AA2	N	10500.00	10500.00	Y	2015-02-12 00:00:00.000	330537	YY	2015-02-11 00:00:00	157169	 	NULL	NULL	NULL
70550	1	2015-02-11 00:00:00	n417	2015-02-11 00:00:00	N	T	15020165	GS00033841	51706	_	T	12786	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-02-12 00:00:00.000	330545	YY	2015-02-11 00:00:00	115058	 	NULL	NULL	NULL
70551	1	2015-02-11 00:00:00	n417	2015-02-11 00:00:00	N	T	15020170	GS00033843	65092	_	T	15194	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-02-12 00:00:00.000	330546	YY	2015-02-11 00:00:00	115060	 	NULL	NULL	NULL
70552	1	2015-02-11 00:00:00	n417	2015-02-11 00:00:00	N	T	15020171	GS00033844	65093	_	T	15194	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-02-12 00:00:00.000	330547	YY	2015-02-11 00:00:00	115061	 	NULL	NULL	NULL
70553	1	2015-02-11 00:00:00	n417	2015-02-11 00:00:00	N	T	15020172	GS00033845	65094	_	T	15194	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-02-12 00:00:00.000	330548	YY	2015-02-11 00:00:00	115062	 	NULL	NULL	NULL
70554	1	2015-02-11 00:00:00	n417	2015-02-11 00:00:00	N	T	15020173	GS00033846	65095	_	T	15194	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-02-12 00:00:00.000	330549	YY	2015-02-11 00:00:00	115063	 	NULL	NULL	NULL
70555	1	2015-02-11 00:00:00	n417	2015-02-11 00:00:00	N	T	15020174	GS00033847	65096	_	T	15194	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-02-12 00:00:00.000	330550	YY	2015-02-11 00:00:00	115064	 	NULL	NULL	NULL
70556	1	2015-02-11 00:00:00	n417	2015-02-11 00:00:00	N	T	15020175	GS00033848	65097	_	T	15194	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-02-12 00:00:00.000	330551	YY	2015-02-11 00:00:00	115065	 	NULL	NULL	NULL
70557	1	2015-02-11 00:00:00	n417	2015-02-11 00:00:00	N	T	15020163	GS00033849	65804	_	T	15554	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-02-12 00:00:00.000	330552	YY	2015-02-11 00:00:00	115066	 	NULL	NULL	NULL
70558	1	2015-02-11 00:00:00	n417	2015-02-11 00:00:00	N	T	15020164	GS00033850	65806	_	T	15554	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-02-12 00:00:00.000	330553	YY	2015-02-11 00:00:00	115067	 	NULL	NULL	NULL
70559	1	2015-02-11 00:00:00	n417	2015-02-11 00:00:00	N	T	15020087	GS00033851	52874	_	T	12288	n1350	FR1	FR1	N	4000.00	4000.00	Y	2015-02-12 00:00:00.000	330554	YY	2015-02-11 00:00:00	115068	 	NULL	NULL	NULL
70560	1	2015-02-11 00:00:00	n417	2015-02-11 00:00:00	N	T	15020145	GS00033855	52444	_	T	2510	n547	FR1	FR1	N	4000.00	4000.00	Y	2015-02-12 00:00:00.000	330555	YY	2015-02-11 00:00:00	115072	 	NULL	NULL	NULL
70561	1	2015-02-11 00:00:00	n417	2015-02-11 00:00:00	N	T	15020146	GS00033856	53640	_	T	2510	n547	FR1	FR1	N	4000.00	4000.00	Y	2015-02-12 00:00:00.000	330556	YY	2015-02-11 00:00:00	115073	 	NULL	NULL	NULL
70562	1	2015-02-11 00:00:00	n417	2015-02-11 00:00:00	N	T	15020147	GS00033857	52495	_	T	2510	n547	FR1	FR1	N	4000.00	4000.00	Y	2015-02-12 00:00:00.000	330557	YY	2015-02-11 00:00:00	115074	 	NULL	NULL	NULL
70563	1	2015-02-11 00:00:00	n417	2015-02-11 00:00:00	N	T	15020148	GS00033858	52496	_	T	2510	n547	FR1	FR1	N	4000.00	4000.00	Y	2015-02-12 00:00:00.000	330558	YY	2015-02-11 00:00:00	115075	 	NULL	NULL	NULL
70564	1	2015-02-11 00:00:00	n417	2015-02-11 00:00:00	N	T	15020149	GS00033859	52497	_	T	2510	n547	FR1	FR1	N	4000.00	4000.00	Y	2015-02-12 00:00:00.000	330559	YY	2015-02-11 00:00:00	115076	 	NULL	NULL	NULL
70565	1	2015-02-11 00:00:00	n417	2015-02-11 00:00:00	N	T	15020150	GS00033860	52498	_	T	2510	n547	FR1	FR1	N	4000.00	4000.00	Y	2015-02-12 00:00:00.000	330560	YY	2015-02-11 00:00:00	115077	 	NULL	NULL	NULL
70566	1	2015-02-11 00:00:00	n417	2015-02-11 00:00:00	N	T	15020151	GS00033861	52499	_	T	2510	n547	FR1	FR1	N	4000.00	4000.00	Y	2015-02-12 00:00:00.000	330561	YY	2015-02-11 00:00:00	115078	 	NULL	NULL	NULL
70567	1	2015-02-11 00:00:00	n417	2015-02-11 00:00:00	N	T	15020152	GS00033862	52275	_	T	2510	n547	FR1	FR1	N	4000.00	4000.00	Y	2015-02-12 00:00:00.000	330562	YY	2015-02-11 00:00:00	115079	 	NULL	NULL	NULL
70568	1	2015-02-11 08:47:00	n319	2015-02-11 00:00:00	N	P	15020107	GS15000350	20434	_	T	13124	n1304	WS21	AK3	N	27800.00	27800.00	Y	2015-02-12 00:00:00.000	330538	YY	2015-02-11 00:00:00	157170	 	NULL	NULL	NULL
70569	1	2015-02-11 08:50:00	n319	2015-02-11 00:00:00	N	P	14120351	GS15000351	25969	_	T	4610	n994	FR1	AB1	N	7000.00	11800.00	Y	2015-02-12 00:00:00.000	330539	YY	2015-02-11 00:00:00	157171	 	NULL	NULL	NULL
70570	1	2015-02-11 08:50:00	n319	2015-02-11 00:00:00	N	P	15020111	GS15000351	25969	_	T	4610	n994	FR12	AB1	N	4800.00	11800.00	Y	2015-02-12 00:00:00.000	330540	YY	2015-02-11 00:00:00	157171	 	NULL	NULL	NULL
70571	1	2015-02-11 08:52:00	n319	2015-02-11 00:00:00	N	P	15020104	GS15000352	26325	_	T	15192	n1304	WS11	AJ2	N	2700.00	2700.00	Y	2015-02-12 00:00:00.000	330541	YY	2015-02-11 00:00:00	157172	 	NULL	NULL	NULL
70572	1	2015-02-11 08:53:00	n319	2015-02-11 00:00:00	N	P	15020099	GS15000353	27511	_	T	15569	n994	WA3	AN5	D	1000.00	1000.00	Y	2015-02-12 00:00:00.000	330542	YY	2015-02-11 00:00:00	157173	 	NULL	NULL	NULL
70573	1	2015-02-11 08:55:00	n319	2015-02-11 00:00:00	N	P	15020103	GS15000354	27558	_	T	15610	n994	WS1	AJ1	N	8500.00	8500.00	Y	2015-02-12 00:00:00.000	330543	YY	2015-02-11 00:00:00	157174	 	NULL	NULL	NULL
70574	1	2015-02-11 08:56:00	n319	2015-02-11 00:00:00	N	P	15020100	GS15000355	27691	_	T	15569	n994	WA3	AN5	D	1000.00	1000.00	Y	2015-02-12 00:00:00.000	330544	YY	2015-02-11 00:00:00	157175	 	NULL	NULL	NULL
70575	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020166	GS00033863	65547	_	T	15777	n646	FF0	FF0	N	2500.00	2500.00	Y	2015-02-16 00:00:00.000	330685	YY	2015-02-12 00:00:00	115154	 	NULL	NULL	NULL
70576	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020167	GS00033864	65546	_	T	15777	n646	FF0	FF0	N	7500.00	7500.00	Y	2015-02-16 00:00:00.000	330686	YY	2015-02-12 00:00:00	115205	 	NULL	NULL	NULL
70577	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020089	GS00033866	66163	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330687	YE	2015-02-12 00:00:00	115271	 	NULL	NULL	NULL
70578	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020090	GS00033867	66164	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330688	YE	2015-02-12 00:00:00	115272	 	NULL	NULL	NULL
70579	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020091	GS00033868	66165	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330689	YE	2015-02-12 00:00:00	115273	 	NULL	NULL	NULL
70580	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020120	GS00033869	66166	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330690	YE	2015-02-12 00:00:00	115274	 	NULL	NULL	NULL
70581	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020093	GS00033870	66167	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330691	YE	2015-02-12 00:00:00	115290	 	NULL	NULL	NULL
70582	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020094	GS00033871	66168	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330692	YE	2015-02-12 00:00:00	115291	 	NULL	NULL	NULL
70583	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020092	GS00033872	66169	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330693	YE	2015-02-12 00:00:00	115292	 	NULL	NULL	NULL
70584	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020095	GS00033873	66170	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330694	YE	2015-02-12 00:00:00	115293	 	NULL	NULL	NULL
70585	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020096	GS00033874	66171	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330695	YE	2015-02-12 00:00:00	115294	 	NULL	NULL	NULL
70586	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020097	GS00033875	66172	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330696	YE	2015-02-12 00:00:00	115295	 	NULL	NULL	NULL
70587	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020098	GS00033876	66173	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330697	YE	2015-02-12 00:00:00	115296	 	NULL	NULL	NULL
70588	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020099	GS00033877	66174	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330698	YE	2015-02-12 00:00:00	115301	 	NULL	NULL	NULL
70589	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020100	GS00033878	66175	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330699	YE	2015-02-12 00:00:00	115304	 	NULL	NULL	NULL
70590	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020101	GS00033879	66176	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330700	YE	2015-02-12 00:00:00	115305	 	NULL	NULL	NULL
70591	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020102	GS00033880	66177	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330701	YE	2015-02-12 00:00:00	115306	 	NULL	NULL	NULL
70592	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020144	GS00033881	66178	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330702	YE	2015-02-12 00:00:00	115307	 	NULL	NULL	NULL
70593	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020103	GS00033882	66179	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330703	YE	2015-02-12 00:00:00	115308	 	NULL	NULL	NULL
70594	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020125	GS00033883	66180	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330704	YE	2015-02-12 00:00:00	115309	 	NULL	NULL	NULL
70595	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020126	GS00033884	66181	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330705	YE	2015-02-12 00:00:00	115310	 	NULL	NULL	NULL
70596	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020127	GS00033885	66182	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330706	YE	2015-02-12 00:00:00	115315	 	NULL	NULL	NULL
70597	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020128	GS00033886	66183	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330707	YE	2015-02-12 00:00:00	115316	 	NULL	NULL	NULL
70598	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020129	GS00033887	66184	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330708	YE	2015-02-12 00:00:00	115318	 	NULL	NULL	NULL
70599	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020130	GS00033888	66185	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330709	YE	2015-02-12 00:00:00	115320	 	NULL	NULL	NULL
70600	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020131	GS00033889	66186	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330710	YE	2015-02-12 00:00:00	115321	 	NULL	NULL	NULL
70601	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020132	GS00033890	66187	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330711	YE	2015-02-12 00:00:00	115322	 	NULL	NULL	NULL
70602	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020133	GS00033891	66188	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330712	YE	2015-02-12 00:00:00	115323	 	NULL	NULL	NULL
70603	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020134	GS00033892	66189	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330713	YE	2015-02-12 00:00:00	115324	 	NULL	NULL	NULL
70604	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020135	GS00033893	66190	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330714	YE	2015-02-12 00:00:00	115325	 	NULL	NULL	NULL
70605	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020136	GS00033894	66191	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330715	YE	2015-02-12 00:00:00	115326	 	NULL	NULL	NULL
70606	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020137	GS00033895	66192	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330716	YE	2015-02-12 00:00:00	115327	 	NULL	NULL	NULL
70607	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020138	GS00033896	66193	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330717	YE	2015-02-12 00:00:00	115328	 	NULL	NULL	NULL
70608	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020139	GS00033897	66194	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330718	YE	2015-02-12 00:00:00	115329	 	NULL	NULL	NULL
70609	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020140	GS00033898	66195	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330719	YE	2015-02-12 00:00:00	115330	 	NULL	NULL	NULL
70610	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020141	GS00033899	66196	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330720	YE	2015-02-12 00:00:00	115331	 	NULL	NULL	NULL
70611	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020142	GS00033900	66197	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330721	YE	2015-02-12 00:00:00	115332	 	NULL	NULL	NULL
70612	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020143	GS00033901	66198	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330722	YE	2015-02-12 00:00:00	115333	 	NULL	NULL	NULL
70613	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020104	GS00033902	66199	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330723	YE	2015-02-12 00:00:00	115334	 	NULL	NULL	NULL
70614	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020105	GS00033903	66200	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330724	YE	2015-02-12 00:00:00	115335	 	NULL	NULL	NULL
70615	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020106	GS00033904	66201	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330725	YE	2015-02-12 00:00:00	115336	 	NULL	NULL	NULL
70616	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020107	GS00033905	66202	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330726	YE	2015-02-12 00:00:00	115341	 	NULL	NULL	NULL
70617	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020108	GS00033906	66203	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330727	YE	2015-02-12 00:00:00	115342	 	NULL	NULL	NULL
70618	1	2015-02-11 15:43:00	n319	2015-02-12 00:00:00	N	P	15020112	GS15000359	24847	_	T	14794	n1125	WS21	AK3	N	1600.00	1600.00	Y	2015-02-16 00:00:00.000	330667	YY	2015-02-12 00:00:00	157264	 	NULL	NULL	NULL
70619	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020109	GS00033907	66204	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330728	YE	2015-02-12 00:00:00	115343	 	NULL	NULL	NULL
70620	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020110	GS00033908	66205	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330729	YE	2015-02-12 00:00:00	115344	 	NULL	NULL	NULL
70621	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020111	GS00033909	66206	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330730	YE	2015-02-12 00:00:00	115345	 	NULL	NULL	NULL
70622	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020112	GS00033910	66207	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330731	YE	2015-02-12 00:00:00	115346	 	NULL	NULL	NULL
70623	1	2015-02-11 15:47:00	n319	2015-02-12 00:00:00	N	P	15020113	GS15000362	27288	_	T	14794	n1125	WS21	AK3	N	3400.00	3400.00	Y	2015-02-16 00:00:00.000	330668	YY	2015-02-12 00:00:00	157267	 	NULL	NULL	NULL
70624	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020113	GS00033911	66208	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330732	YE	2015-02-12 00:00:00	115347	 	NULL	NULL	NULL
70625	1	2015-02-11 15:48:00	n319	2015-02-12 00:00:00	N	P	15020114	GS15000363	27290	_	T	14794	n1125	WS11	AJ2	N	1000.00	1000.00	Y	2015-02-16 00:00:00.000	330669	YY	2015-02-12 00:00:00	157268	 	NULL	NULL	NULL
70626	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020114	GS00033912	66209	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330733	YE	2015-02-12 00:00:00	115348	 	NULL	NULL	NULL
70627	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020115	GS00033913	66210	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330734	YE	2015-02-12 00:00:00	115349	 	NULL	NULL	NULL
70628	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020116	GS00033914	66211	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330735	YE	2015-02-12 00:00:00	115350	 	NULL	NULL	NULL
70629	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020118	GS00033915	66212	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330736	YE	2015-02-12 00:00:00	115351	 	NULL	NULL	NULL
70630	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020119	GS00033916	66213	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330737	YE	2015-02-12 00:00:00	115354	 	NULL	NULL	NULL
70631	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020121	GS00033917	66214	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330738	YE	2015-02-12 00:00:00	115355	 	NULL	NULL	NULL
70632	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020122	GS00033918	66215	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330739	YE	2015-02-12 00:00:00	115356	 	NULL	NULL	NULL
70633	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020123	GS00033919	66216	_	T	15930	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-16 00:00:00.000	330740	YE	2015-02-12 00:00:00	115357	 	NULL	NULL	NULL
70634	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020176	GS00033920	64465	_	T	15193	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-02-16 00:00:00.000	330741	YY	2015-02-12 00:00:00	115359	 	NULL	NULL	NULL
70635	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020177	GS00033921	64466	_	T	15193	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-02-16 00:00:00.000	330742	YY	2015-02-12 00:00:00	115360	 	NULL	NULL	NULL
70636	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020178	GS00033922	64475	_	T	15193	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-02-16 00:00:00.000	330743	YY	2015-02-12 00:00:00	115361	 	NULL	NULL	NULL
70637	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020179	GS00033923	64476	_	T	15193	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-02-16 00:00:00.000	330744	YY	2015-02-12 00:00:00	115362	 	NULL	NULL	NULL
70638	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020180	GS00033924	64477	_	T	15193	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-02-16 00:00:00.000	330745	YY	2015-02-12 00:00:00	115363	 	NULL	NULL	NULL
70639	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020181	GS00033925	65318	_	T	15193	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-02-16 00:00:00.000	330746	YY	2015-02-12 00:00:00	115364	 	NULL	NULL	NULL
70640	1	2015-02-11 00:00:00	n417	2015-02-12 00:00:00	N	T	15020182	GS00033926	65319	_	T	15193	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-02-16 00:00:00.000	330747	YY	2015-02-12 00:00:00	115365	 	NULL	NULL	NULL
70641	1	2015-02-11 17:06:00	n319	2015-02-12 00:00:00	N	P	14090046	GS15000365	27973	_	T	13042	n650	IG1B	AA21	N	9700.00	9700.00	Y	2015-02-16 00:00:00.000	330670	YY	2015-02-12 00:00:00	157289	 	NULL	NULL	NULL
70642	1	2015-02-11 17:08:00	n319	2015-02-12 00:00:00	N	P	14090369	GS15000366	28038	_	T	13444	n650	IG1E	AA2	N	10500.00	10500.00	Y	2015-02-16 00:00:00.000	330671	YY	2015-02-12 00:00:00	157293	 	NULL	NULL	NULL
70643	1	2015-02-11 17:09:00	n319	2015-02-12 00:00:00	N	P	14090370	GS15000367	28039	_	T	13444	n650	IG1E	AA2	N	10500.00	10500.00	Y	2015-02-16 00:00:00.000	330672	YY	2015-02-12 00:00:00	157297	 	NULL	NULL	NULL
70644	1	2015-02-11 17:21:00	n319	2015-02-12 00:00:00	N	P	15020028	GS15000369	28341	_	T	3570	n1489	DG1	AA4	N	3000.00	3000.00	Y	2015-02-16 00:00:00.000	330673	YY	2015-02-12 00:00:00	157307	 	NULL	NULL	NULL
70645	1	2015-02-12 08:43:00	n319	2015-02-12 00:00:00	N	P	15020125	GS15000370	22049	_	T	15148	n1065	WS1	AJ1	N	8500.00	8500.00	Y	2015-02-16 00:00:00.000	330674	YY	2015-02-12 00:00:00	157308	 	NULL	NULL	NULL
70646	1	2015-02-12 08:45:00	n319	2015-02-12 00:00:00	N	P	15020136	GS15000372	27533	_	T	1206	n896	WS1	AJ1	N	8500.00	8500.00	Y	2015-02-16 00:00:00.000	330675	YY	2015-02-12 00:00:00	157310	 	NULL	NULL	NULL
70647	1	2015-02-12 08:49:00	n319	2015-02-12 00:00:00	N	P	15020129	GS15000374	27918	_	T	13708	n896	WS11	AJ2	N	6100.00	6100.00	Y	2015-02-16 00:00:00.000	330676	YY	2015-02-12 00:00:00	157312	 	NULL	NULL	NULL
70648	1	2015-02-12 08:51:00	n319	2015-02-12 00:00:00	N	P	15020133	GS15000375	28356	_	T	10747	n1065	IG1E	AA2	N	10500.00	10500.00	Y	2015-02-16 00:00:00.000	330677	YY	2015-02-12 00:00:00	157313	 	NULL	NULL	NULL
70649	1	2015-02-12 09:14:00	n319	2015-02-12 00:00:00	N	P	15020148	GS15000376	27774	_	T	3570	n1489	WS1	AJ1	N	1800.00	1800.00	Y	2015-02-16 00:00:00.000	330678	YY	2015-02-12 00:00:00	157320	 	NULL	NULL	NULL
70650	1	2015-02-12 09:15:00	n319	2015-02-12 00:00:00	N	P	15020149	GS15000377	27775	_	T	3570	n1489	WS1	AJ1	N	1800.00	1800.00	Y	2015-02-16 00:00:00.000	330679	YY	2015-02-12 00:00:00	157321	 	NULL	NULL	NULL
70651	1	2015-02-12 09:46:00	n319	2015-02-12 00:00:00	N	P	15020121	GS15000380	1053	M	T	12293	n113	WS2	AK2	X	8000.00	8000.00	Y	2015-02-16 00:00:00.000	330680	YE	2015-02-12 00:00:00	157328	 	NULL	NULL	NULL
70652	1	2015-02-12 09:46:00	n319	2015-02-12 00:00:00	N	P	15020140	GS15000381	24387	_	T	13972	n100	WS2	AK2	N	4000.00	4000.00	Y	2015-02-16 00:00:00.000	330681	YE	2015-02-12 00:00:00	157329	 	NULL	NULL	NULL
70653	1	2015-02-12 09:46:00	n319	2015-02-12 00:00:00	N	P	15020143	GS15000382	25226	_	T	13972	n100	WS2	AK2	N	4000.00	4000.00	Y	2015-02-16 00:00:00.000	330682	YE	2015-02-12 00:00:00	157330	 	NULL	NULL	NULL
70654	1	2015-02-12 09:46:00	n319	2015-02-12 00:00:00	N	P	15020141	GS15000383	25466	_	T	13972	n100	WS2	AK2	N	4000.00	4000.00	Y	2015-02-16 00:00:00.000	330683	YE	2015-02-12 00:00:00	157331	 	NULL	NULL	NULL
70655	1	2015-02-12 09:46:00	n319	2015-02-12 00:00:00	N	P	15020142	GS15000384	25476	_	T	13972	n100	WS2	AK2	N	4000.00	4000.00	Y	2015-02-16 00:00:00.000	330684	YE	2015-02-12 00:00:00	157332	 	NULL	NULL	NULL
70656	1	2015-02-12 15:17:00	n319	2015-02-13 00:00:00	N	P	15020147	GS15000385	25710	_	T	12556	n1489	WS11	AJ2	N	2700.00	2700.00	Y	2015-02-16 00:00:00.000	330748	YY	2015-02-13 00:00:00	157443	 	NULL	NULL	NULL
70657	1	2015-02-12 15:32:00	n319	2015-02-13 00:00:00	N	P	15020144	GS15000390	28073	_	T	13972	n100	WS1	AJ1	N	3500.00	3500.00	Y	2015-02-16 00:00:00.000	330749	YY	2015-02-13 00:00:00	157449	 	NULL	NULL	NULL
70658	1	2015-02-12 15:34:00	n319	2015-02-13 00:00:00	N	P	15010037	GS15000391	28271	_	T	14737	n650	DG1	AA4	N	3000.00	3000.00	Y	2015-02-16 00:00:00.000	330750	YY	2015-02-13 00:00:00	157450	 	NULL	NULL	NULL
70659	1	2015-02-12 15:36:00	n319	2015-02-13 00:00:00	N	P	15010038	GS15000392	28272	_	T	14737	n650	DG1	AA4	N	3000.00	3000.00	Y	2015-02-16 00:00:00.000	330751	YY	2015-02-13 00:00:00	157451	 	NULL	NULL	NULL
70660	1	2015-02-12 16:14:00	n319	2015-02-13 00:00:00	N	P	15020168	GS15000393	28083	_	T	13971	n1486	WS1	AJ1	N	8500.00	8500.00	Y	2015-02-16 00:00:00.000	330752	YY	2015-02-13 00:00:00	157461	 	NULL	NULL	NULL
70661	1	2015-02-12 17:00:00	n319	2015-02-13 00:00:00	N	P	15020126	GS15000395	27745	_	T	15881	n1304	WS1	AJ1	N	8500.00	8500.00	Y	2015-02-16 00:00:00.000	330753	YY	2015-02-13 00:00:00	157471	 	NULL	NULL	NULL
70662	1	2015-02-13 08:46:00	n319	2015-02-13 00:00:00	N	P	15020175	GS15000397	26385	_	T	14633	n1304	WS11	AJ2	N	6100.00	6100.00	Y	2015-02-16 00:00:00.000	330754	YY	2015-02-13 00:00:00	157473	 	NULL	NULL	NULL
70663	1	2015-02-13 00:00:00	n029	2015-02-13 00:00:00	N	T	15020191	GS00033927	65826	_	T	12943	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-02-16 00:00:00.000	330756	YY	2015-02-13 00:00:00	115454	 	NULL	NULL	NULL
70664	1	2015-02-13 00:00:00	n029	2015-02-13 00:00:00	N	T	15020193	GS00033928	65760	_	T	13770	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-02-16 00:00:00.000	330757	YY	2015-02-13 00:00:00	115455	 	NULL	NULL	NULL
70665	1	2015-02-13 09:42:00	n319	2015-02-13 00:00:00	N	P	15020165	GS15000404	14633	_	T	11412	n113	WS2	AK2	N	16000.00	16000.00	Y	2015-02-16 00:00:00.000	330755	YE	2015-02-13 00:00:00	157487	 	NULL	NULL	NULL
70666	1	2015-02-13 16:22:00	n319	2015-02-16 00:00:00	N	P	15010008	GS15000406	28266	_	T	14886	n1125	UG1	AA3	N	3000.00	3000.00	Y	2015-02-25 00:00:00.000	331515	YY	2015-02-16 00:00:00	157604	 	NULL	NULL	NULL
70667	1	2015-02-16 00:00:00	n417	2015-02-16 00:00:00	N	T	15020207	GS00033929	66240	_	T	15932	n1384	FT1	FT1	N	2000.00	2000.00	Y	2015-02-25 00:00:00.000	331529	YY	2015-02-16 00:00:00	115525	 	NULL	NULL	NULL
70668	1	2015-02-16 08:38:00	n319	2015-02-16 00:00:00	N	P	15020188	GS15000408	1089	M	T	12293	n113	WS11	AJ2	X	2700.00	2700.00	Y	2015-02-25 00:00:00.000	331516	YY	2015-02-16 00:00:00	157615	 	NULL	NULL	NULL
70669	1	2015-02-16 08:39:00	n319	2015-02-16 00:00:00	N	P	15020122	GS15000409	1169	M	T	15548	n113	AC2	AAD	X	13600.00	13600.00	Y	2015-02-25 00:00:00.000	331517	YY	2015-02-16 00:00:00	157616	 	NULL	NULL	NULL
70670	1	2015-02-16 00:00:00	n417	2015-02-16 00:00:00	N	T	15020208	GS00033930	66238	_	T	15664	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-02-25 00:00:00.000	331530	YY	2015-02-16 00:00:00	115527	 	NULL	NULL	NULL
70671	1	2015-02-16 00:00:00	n417	2015-02-16 00:00:00	N	T	15020209	GS00033931	66239	_	T	15664	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-02-25 00:00:00.000	331531	YY	2015-02-16 00:00:00	115528	 	NULL	NULL	NULL
70672	1	2015-02-16 08:42:00	n319	2015-02-16 00:00:00	N	P	15020160	GS15000410	1170	M	T	15548	n113	AC2	AAD	X	1600.00	1600.00	Y	2015-02-25 00:00:00.000	331518	YY	2015-02-16 00:00:00	157617	 	NULL	NULL	NULL
70673	1	2015-02-16 08:43:00	n319	2015-02-16 00:00:00	N	P	15020173	GS15000411	21049	_	T	2054	n113	WS11	AJ2	N	6100.00	6100.00	Y	2015-02-25 00:00:00.000	331519	YY	2015-02-16 00:00:00	157618	 	NULL	NULL	NULL
70674	1	2015-02-16 00:00:00	n417	2015-02-16 00:00:00	N	T	15020201	GS00033933	62762	_	T	4411	n646	FR1	FR1	N	4000.00	4000.00	Y	2015-02-25 00:00:00.000	331532	YY	2015-02-16 00:00:00	115530	 	NULL	NULL	NULL
70675	1	2015-02-16 08:52:00	n319	2015-02-16 00:00:00	N	P	15020197	GS15000415	27423	_	T	15524	n994	WS1	AJ1	N	8500.00	8500.00	Y	2015-02-25 00:00:00.000	331520	YY	2015-02-16 00:00:00	157622	 	NULL	NULL	NULL
70676	1	2015-02-16 00:00:00	n417	2015-02-16 00:00:00	N	T	15020202	GS00033934	62759	_	T	4411	n646	FR1	FR1	N	4000.00	4000.00	Y	2015-02-25 00:00:00.000	331533	YY	2015-02-16 00:00:00	115531	 	NULL	NULL	NULL
70677	1	2015-02-16 00:00:00	n417	2015-02-16 00:00:00	N	T	15020203	GS00033935	62752	_	T	4411	n646	FR1	FR1	N	4000.00	4000.00	Y	2015-02-25 00:00:00.000	331534	YY	2015-02-16 00:00:00	115532	 	NULL	NULL	NULL
70678	1	2015-02-16 00:00:00	n417	2015-02-16 00:00:00	N	T	15020204	GS00033936	62757	_	T	4411	n646	FR1	FR1	N	4000.00	4000.00	Y	2015-02-25 00:00:00.000	331535	YY	2015-02-16 00:00:00	115533	 	NULL	NULL	NULL
70679	1	2015-02-16 08:55:00	n319	2015-02-16 00:00:00	N	P	15020198	GS15000417	27783	_	T	4762	n650	WS11	AJ2	N	6100.00	6100.00	Y	2015-02-25 00:00:00.000	331521	YY	2015-02-16 00:00:00	157624	 	NULL	NULL	NULL
70680	1	2015-02-16 00:00:00	n417	2015-02-16 00:00:00	N	T	15020205	GS00033937	62755	_	T	4411	n646	FR1	FR1	N	4000.00	4000.00	Y	2015-02-25 00:00:00.000	331536	YY	2015-02-16 00:00:00	115534	 	NULL	NULL	NULL
70681	1	2015-02-16 00:00:00	n417	2015-02-16 00:00:00	N	T	15020206	GS00033938	62763	_	T	4411	n646	FR1	FR1	N	4000.00	4000.00	Y	2015-02-25 00:00:00.000	331537	YY	2015-02-16 00:00:00	115535	 	NULL	NULL	NULL
70682	1	2015-02-16 08:59:00	n319	2015-02-16 00:00:00	N	P	14120161	GS15000419	28204	_	T	12406	n650	IG1B	AA21	N	9700.00	9700.00	Y	2015-02-25 00:00:00.000	331522	YY	2015-02-16 00:00:00	157626	 	NULL	NULL	NULL
70683	1	2015-02-16 00:00:00	n417	2015-02-16 00:00:00	N	T	15020195	GS00033939	66234	_	T	1646	n428	FT1	FT1	N	2000.00	2000.00	Y	2015-02-25 00:00:00.000	331538	YY	2015-02-16 00:00:00	115536	 	NULL	NULL	NULL
70684	1	2015-02-16 09:01:00	n319	2015-02-16 00:00:00	N	P	15010024	GS15000420	28269	_	T	14737	n650	IG1E	AA2	N	10500.00	12100.00	Y	2015-02-25 00:00:00.000	331523	YY	2015-02-16 00:00:00	157627	 	NULL	NULL	NULL
70685	1	2015-02-16 09:01:00	n319	2015-02-16 00:00:00	N	P	15020190	GS15000420	28269	_	T	14737	n650	AC2	AA2	N	1600.00	12100.00	Y	2015-02-25 00:00:00.000	331524	YY	2015-02-16 00:00:00	157627	 	NULL	NULL	NULL
70686	1	2015-02-16 09:03:00	n319	2015-02-16 00:00:00	N	P	15010025	GS15000421	28270	_	T	14737	n650	UG1	AA3	N	3000.00	3000.00	Y	2015-02-25 00:00:00.000	331525	YY	2015-02-16 00:00:00	157628	 	NULL	NULL	NULL
70687	1	2015-02-16 09:04:00	n319	2015-02-16 00:00:00	N	P	15010054	GS15000422	28277	_	T	7683	n650	UG1	AA3	N	3000.00	3000.00	Y	2015-02-25 00:00:00.000	331526	YY	2015-02-16 00:00:00	157629	 	NULL	NULL	NULL
70688	1	2015-02-16 00:00:00	n417	2015-02-16 00:00:00	N	T	15020197	GS00033940	66236	_	T	1646	n428	FT1	FT1	N	2000.00	2000.00	Y	2015-02-25 00:00:00.000	331539	YY	2015-02-16 00:00:00	115537	 	NULL	NULL	NULL
70689	1	2015-02-16 00:00:00	n417	2015-02-16 00:00:00	N	T	15020196	GS00033941	66235	_	T	1646	n428	FT1	FT1	N	2000.00	2000.00	Y	2015-02-25 00:00:00.000	331540	YY	2015-02-16 00:00:00	115538	 	NULL	NULL	NULL
70690	1	2015-02-16 00:00:00	n417	2015-02-16 00:00:00	N	T	15020198	GS00033942	53808	_	T	4952	n547	FR1	FR1	N	4000.00	4000.00	Y	2015-02-25 00:00:00.000	331541	YY	2015-02-16 00:00:00	115539	 	NULL	NULL	NULL
70691	1	2015-02-16 00:00:00	n417	2015-02-16 00:00:00	N	T	15020213	GS00033943	66237	_	T	15503	n428	FE1	FE1	N	2400.00	2400.00	Y	2015-02-25 00:00:00.000	331557	YE	2015-02-17 00:00:00	115540	 	NULL	NULL	NULL
70692	1	2015-02-16 00:00:00	n417	2015-02-16 00:00:00	N	T	15020194	GS00033944	66218	_	T	3890	n824	FC6	FC6	N	8000.00	500.00	Y	2015-02-25 00:00:00.000	331542	YY	2015-02-16 00:00:00	115541	 	NULL	NULL	NULL
70693	1	2015-02-16 09:45:00	n319	2015-02-16 00:00:00	N	P	14100045	GS15000425	28059	_	T	13884	n650	IG1E	AA2	N	10500.00	12100.00	Y	2015-02-25 00:00:00.000	331527	YY	2015-02-16 00:00:00	157639	 	NULL	NULL	NULL
70694	1	2015-02-16 09:45:00	n319	2015-02-16 00:00:00	N	P	15020201	GS15000425	28059	_	T	13884	n650	AC2	AA2	N	1600.00	12100.00	Y	2015-02-25 00:00:00.000	331528	YY	2015-02-16 00:00:00	157639	 	NULL	NULL	NULL
70695	1	2015-02-17 00:00:00	n417	2015-02-17 00:00:00	N	T	15020190	GS00033960	65796	_	T	15348	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-02-25 00:00:00.000	331558	YY	2015-02-17 00:00:00	115640	 	NULL	NULL	NULL
70696	1	2015-02-17 00:00:00	n417	2015-02-17 00:00:00	N	T	15020221	GS00033961	65543	_	T	15766	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-02-25 00:00:00.000	331559	YY	2015-02-17 00:00:00	115641	 	NULL	NULL	NULL
70697	1	2015-02-17 00:00:00	n417	2015-02-17 00:00:00	N	T	15020220	GS00033962	65156	_	T	15645	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-02-25 00:00:00.000	331560	YY	2015-02-17 00:00:00	115642	 	NULL	NULL	NULL
70698	1	2015-02-17 00:00:00	n417	2015-02-17 00:00:00	N	T	15020233	GS00033963	36706	_	T	4049	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-02-25 00:00:00.000	331561	YY	2015-02-17 00:00:00	115643	 	NULL	NULL	NULL
70699	1	2015-02-17 00:00:00	n417	2015-02-17 00:00:00	N	T	15020234	GS00033964	52128	_	T	4049	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-02-25 00:00:00.000	331562	YY	2015-02-17 00:00:00	115644	 	NULL	NULL	NULL
70700	1	2015-02-17 00:00:00	n417	2015-02-17 00:00:00	N	T	15020235	GS00033965	52129	_	T	4049	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-02-25 00:00:00.000	331563	YY	2015-02-17 00:00:00	115645	 	NULL	NULL	NULL
70701	1	2015-02-17 00:00:00	n417	2015-02-17 00:00:00	N	T	15020236	GS00033966	52130	_	T	4049	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-02-25 00:00:00.000	331564	YY	2015-02-17 00:00:00	115646	 	NULL	NULL	NULL
70702	1	2015-02-17 00:00:00	n417	2015-02-17 00:00:00	N	T	15020237	GS00033967	52329	_	T	4049	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-02-25 00:00:00.000	331565	YY	2015-02-17 00:00:00	115647	 	NULL	NULL	NULL
70703	1	2015-02-17 00:00:00	n417	2015-02-17 00:00:00	N	T	15020238	GS00033968	52334	_	T	4049	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-02-25 00:00:00.000	331566	YY	2015-02-17 00:00:00	115648	 	NULL	NULL	NULL
70704	1	2015-02-17 00:00:00	n417	2015-02-17 00:00:00	N	T	15020239	GS00033969	52330	_	T	4049	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-02-25 00:00:00.000	331567	YY	2015-02-17 00:00:00	115649	 	NULL	NULL	NULL
70705	1	2015-02-17 00:00:00	n417	2015-02-17 00:00:00	N	T	15020240	GS00033970	52333	_	T	4049	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-02-25 00:00:00.000	331568	YY	2015-02-17 00:00:00	115650	 	NULL	NULL	NULL
70706	1	2015-02-17 00:00:00	n417	2015-02-17 00:00:00	N	T	15020241	GS00033971	52339	_	T	4049	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-02-25 00:00:00.000	331569	YY	2015-02-17 00:00:00	115651	 	NULL	NULL	NULL
70707	1	2015-02-17 00:00:00	n417	2015-02-17 00:00:00	N	T	15020242	GS00033972	52340	_	T	4049	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-02-25 00:00:00.000	331570	YY	2015-02-17 00:00:00	115652	 	NULL	NULL	NULL
70708	1	2015-02-17 00:00:00	n417	2015-02-17 00:00:00	N	T	15020243	GS00033973	52511	_	T	4049	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-02-25 00:00:00.000	331571	YY	2015-02-17 00:00:00	115653	 	NULL	NULL	NULL
70709	1	2015-02-17 00:00:00	n417	2015-02-17 00:00:00	N	T	15020244	GS00033974	52512	_	T	4049	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-02-25 00:00:00.000	331572	YY	2015-02-17 00:00:00	115654	 	NULL	NULL	NULL
70710	1	2015-02-17 08:41:00	n319	2015-02-17 00:00:00	N	P	15020199	GS15000429	1187	M	T	14881	n1065	IG1E	AA2	X	10500.00	10500.00	Y	2015-02-25 00:00:00.000	331543	YY	2015-02-17 00:00:00	157784	 	NULL	NULL	NULL
70711	1	2015-02-17 00:00:00	n417	2015-02-17 00:00:00	N	T	15020245	GS00033975	52513	_	T	4049	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-02-25 00:00:00.000	331573	YY	2015-02-17 00:00:00	115655	 	NULL	NULL	NULL
70712	1	2015-02-17 00:00:00	n417	2015-02-17 00:00:00	N	T	15020246	GS00033976	52515	_	T	4049	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-02-25 00:00:00.000	331574	YY	2015-02-17 00:00:00	115656	 	NULL	NULL	NULL
70713	1	2015-02-17 00:00:00	n417	2015-02-17 00:00:00	N	T	15020247	GS00033977	52516	_	T	4049	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-02-25 00:00:00.000	331575	YY	2015-02-17 00:00:00	115657	 	NULL	NULL	NULL
70714	1	2015-02-17 00:00:00	n417	2015-02-17 00:00:00	N	T	15020248	GS00033978	52517	_	T	4049	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-02-25 00:00:00.000	331576	YY	2015-02-17 00:00:00	115658	 	NULL	NULL	NULL
70715	1	2015-02-17 00:00:00	n417	2015-02-17 00:00:00	N	T	15020249	GS00033979	52519	_	T	4049	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-02-25 00:00:00.000	331577	YY	2015-02-17 00:00:00	115659	 	NULL	NULL	NULL
70716	1	2015-02-17 00:00:00	n417	2015-02-17 00:00:00	N	T	15020250	GS00033980	52382	_	T	4049	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-02-25 00:00:00.000	331578	YY	2015-02-17 00:00:00	115660	 	NULL	NULL	NULL
70717	1	2015-02-17 00:00:00	n417	2015-02-17 00:00:00	N	T	15020251	GS00033981	52384	_	T	4049	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-02-25 00:00:00.000	331579	YY	2015-02-17 00:00:00	115661	 	NULL	NULL	NULL
70718	1	2015-02-17 00:00:00	n417	2015-02-17 00:00:00	N	T	15020252	GS00033982	52385	_	T	4049	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-02-25 00:00:00.000	331580	YY	2015-02-17 00:00:00	115662	 	NULL	NULL	NULL
70719	1	2015-02-17 08:53:00	n319	2015-02-17 00:00:00	N	P	15020203	GS15000434	27417	_	T	4623	n1125	WS11	AJ2	N	1000.00	1000.00	Y	2015-02-25 00:00:00.000	331544	YY	2015-02-17 00:00:00	157789	 	NULL	NULL	NULL
70720	1	2015-02-17 08:54:00	n319	2015-02-17 00:00:00	N	P	15020200	GS15000435	27435	_	T	15510	n1125	WA3	AN5	D	1000.00	1000.00	Y	2015-02-25 00:00:00.000	331545	YY	2015-02-17 00:00:00	157790	 	NULL	NULL	NULL
70721	1	2015-02-17 00:00:00	n417	2015-02-17 00:00:00	N	T	15020253	GS00033983	52518	_	T	4049	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-02-25 00:00:00.000	331581	YY	2015-02-17 00:00:00	115663	 	NULL	NULL	NULL
70722	1	2015-02-17 00:00:00	n417	2015-02-17 00:00:00	N	T	15020254	GS00033984	52752	_	T	4049	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-02-25 00:00:00.000	331582	YY	2015-02-17 00:00:00	115664	 	NULL	NULL	NULL
70723	1	2015-02-17 08:56:00	n319	2015-02-17 00:00:00	N	P	15020204	GS15000436	27613	_	T	11640	n1125	WS11	AJ2	N	2700.00	2700.00	Y	2015-02-25 00:00:00.000	331546	YY	2015-02-17 00:00:00	157791	 	NULL	NULL	NULL
70724	1	2015-02-17 00:00:00	n417	2015-02-17 00:00:00	N	T	15020255	GS00033985	52694	_	T	4049	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-02-25 00:00:00.000	331583	YY	2015-02-17 00:00:00	115665	 	NULL	NULL	NULL
70725	1	2015-02-17 00:00:00	n417	2015-02-17 00:00:00	N	T	15020256	GS00033986	52663	_	T	4049	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-02-25 00:00:00.000	331584	YY	2015-02-17 00:00:00	115666	 	NULL	NULL	NULL
70726	1	2015-02-17 08:57:00	n319	2015-02-17 00:00:00	N	P	15020202	GS15000437	27757	_	T	14544	n1125	WS11	AJ2	N	2700.00	2700.00	Y	2015-02-25 00:00:00.000	331547	YY	2015-02-17 00:00:00	157792	 	NULL	NULL	NULL
70727	1	2015-02-17 00:00:00	n417	2015-02-17 00:00:00	N	T	15020257	GS00033987	52660	_	T	4049	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-02-25 00:00:00.000	331585	YY	2015-02-17 00:00:00	115667	 	NULL	NULL	NULL
70728	1	2015-02-17 09:01:00	n319	2015-02-17 00:00:00	N	P	14090204	GS15000440	28010	_	T	4610	n994	IG1B	AA21	N	9700.00	9700.00	Y	2015-02-25 00:00:00.000	331548	YY	2015-02-17 00:00:00	157795	 	NULL	NULL	NULL
70729	1	2015-02-17 00:00:00	n417	2015-02-17 00:00:00	N	T	15020225	GS00033988	66241	_	T	12083	n441	FE1	FE1	N	13200.00	13200.00	Y	2015-02-25 00:00:00.000	331586	YE	2015-02-17 00:00:00	115668	 	NULL	NULL	NULL
70730	1	2015-02-17 00:00:00	n417	2015-02-17 00:00:00	N	T	15020226	GS00033989	66242	_	T	12083	n441	FE1	FE1	N	13200.00	13200.00	Y	2015-02-25 00:00:00.000	331587	YE	2015-02-17 00:00:00	115669	 	NULL	NULL	NULL
70731	1	2015-02-17 09:05:00	n319	2015-02-17 00:00:00	N	P	15010031	GS15000442	28268	_	T	3834	n113	UG1	AA3	N	3000.00	3000.00	Y	2015-02-25 00:00:00.000	331549	YY	2015-02-17 00:00:00	157797	 	NULL	NULL	NULL
70732	1	2015-02-17 09:07:00	n319	2015-02-17 00:00:00	N	P	15020206	GS15000443	26221	_	T	15158	n113	WS11	AJ2	N	6100.00	6100.00	Y	2015-02-25 00:00:00.000	331550	YY	2015-02-17 00:00:00	157798	 	NULL	NULL	NULL
70733	1	2015-02-17 00:00:00	n417	2015-02-17 00:00:00	N	T	15020223	GS00033990	66243	_	T	12083	n441	FE1	FE1	N	18600.00	18600.00	Y	2015-02-25 00:00:00.000	331588	YE	2015-02-17 00:00:00	115670	 	NULL	NULL	NULL
70734	1	2015-02-17 00:00:00	n417	2015-02-17 00:00:00	N	T	15020224	GS00033991	66244	_	T	12083	n441	FE1	FE1	N	10500.00	10500.00	Y	2015-02-25 00:00:00.000	331589	YE	2015-02-17 00:00:00	115671	 	NULL	NULL	NULL
70735	1	2015-02-17 09:28:00	n319	2015-02-17 00:00:00	N	P	15010072	GS15000445	28280	_	T	15797	n1489	IG1E	AA2	N	10500.00	10500.00	Y	2015-02-25 00:00:00.000	331551	YY	2015-02-17 00:00:00	157800	 	NULL	NULL	NULL
70736	1	2015-02-17 09:29:00	n319	2015-02-17 00:00:00	N	P	15020211	GS15000446	27956	_	T	10027	n113	WS11	AJ2	N	4400.00	4400.00	Y	2015-02-25 00:00:00.000	331552	YY	2015-02-17 00:00:00	157801	 	NULL	NULL	NULL
70737	1	2015-02-17 09:34:00	n319	2015-02-17 00:00:00	N	P	15020212	GS15000447	25191	_	T	13712	n896	WS1	AJ1	N	6000.00	6000.00	Y	2015-02-25 00:00:00.000	331553	YY	2015-02-17 00:00:00	157802	 	NULL	NULL	NULL
70738	1	2015-02-17 09:35:00	n319	2015-02-17 00:00:00	N	P	15020213	GS15000448	27939	_	T	13712	n896	WS1	AJ1	N	2600.00	2600.00	Y	2015-02-25 00:00:00.000	331554	YY	2015-02-17 00:00:00	157803	 	NULL	NULL	NULL
70739	1	2015-02-17 11:33:00	n319	2015-02-17 00:00:00	N	P	15010140	GS15000449	28292	_	T	15933	n1125	IG1E	AA2	N	10500.00	10500.00	Y	2015-02-25 00:00:00.000	331555	YY	2015-02-17 00:00:00	157838	 	NULL	NULL	NULL
70740	1	2015-02-17 11:35:00	n319	2015-02-17 00:00:00	N	P	15020180	GS15000450	28370	_	T	15933	n1125	UG1	AA3	N	3000.00	3000.00	Y	2015-02-25 00:00:00.000	331556	YY	2015-02-17 00:00:00	157840	 	NULL	NULL	NULL
70741	1	2015-02-17 00:00:00	n417	2015-02-24 00:00:00	N	T	15020282	GS00033994	64963	_	T	15608	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-02-25 00:00:00.000	331593	YY	2015-02-24 00:00:00	115693	 	NULL	NULL	NULL
70742	1	2015-02-17 16:01:00	n319	2015-02-24 00:00:00	N	P	15020215	GS15000452	27014	_	T	2853	n100	WA3	AN5	D	1000.00	1000.00	Y	2015-02-25 00:00:00.000	331590	YY	2015-02-24 00:00:00	157882	 	NULL	NULL	NULL
70743	1	2015-02-24 00:00:00	n417	2015-02-24 00:00:00	N	T	15020271	GS00033996	65762	_	T	7597	n547	FF0	FF0	N	2500.00	2500.00	Y	2015-02-25 00:00:00.000	331594	YY	2015-02-24 00:00:00	115704	 	NULL	NULL	NULL
70744	1	2015-02-24 00:00:00	n417	2015-02-24 00:00:00	N	T	15020272	GS00033997	65763	_	T	7597	n547	FF0	FF0	N	2500.00	2500.00	Y	2015-02-25 00:00:00.000	331595	YY	2015-02-24 00:00:00	115705	 	NULL	NULL	NULL
70745	1	2015-02-24 00:00:00	n417	2015-02-24 00:00:00	N	T	15020264	GS00033998	66246	_	T	15927	n646	FE1	FE1	N	2400.00	2400.00	Y	2015-02-25 00:00:00.000	331596	YE	2015-02-24 00:00:00	115710	 	NULL	NULL	NULL
70746	1	2015-02-24 00:00:00	n417	2015-02-24 00:00:00	N	T	15020274	GS00033999	66250	_	T	7813	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-25 00:00:00.000	331597	YE	2015-02-24 00:00:00	115711	 	NULL	NULL	NULL
70747	1	2015-02-24 00:00:00	n417	2015-02-24 00:00:00	N	T	15020275	GS00034000	66251	_	T	7813	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-25 00:00:00.000	331598	YE	2015-02-24 00:00:00	115712	 	NULL	NULL	NULL
70748	1	2015-02-24 00:00:00	n417	2015-02-24 00:00:00	N	T	15020276	GS00034001	66252	_	T	7813	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-02-25 00:00:00.000	331599	YE	2015-02-24 00:00:00	115713	 	NULL	NULL	NULL
70749	1	2015-02-24 00:00:00	n417	2015-02-24 00:00:00	N	T	15020269	GS00034002	66247	_	T	15931	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-02-25 00:00:00.000	331600	YE	2015-02-24 00:00:00	115714	 	NULL	NULL	NULL
70750	1	2015-02-24 00:00:00	n417	2015-02-24 00:00:00	N	T	15020270	GS00034003	66248	_	T	15931	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-02-25 00:00:00.000	331601	YE	2015-02-24 00:00:00	115715	 	NULL	NULL	NULL
70751	1	2015-02-24 00:00:00	n417	2015-02-24 00:00:00	N	T	15020268	GS00034004	66249	_	T	15931	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-02-25 00:00:00.000	331602	YE	2015-02-24 00:00:00	115716	 	NULL	NULL	NULL
70752	1	2015-02-24 00:00:00	n417	2015-02-24 00:00:00	N	T	15020258	GS00034005	51464	_	T	5406	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-02-25 00:00:00.000	331603	YY	2015-02-24 00:00:00	115717	 	NULL	NULL	NULL
70753	1	2015-02-24 00:00:00	n417	2015-02-24 00:00:00	N	T	15020259	GS00034006	37804	_	T	5406	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-02-25 00:00:00.000	331604	YY	2015-02-24 00:00:00	115718	 	NULL	NULL	NULL
70754	1	2015-02-24 00:00:00	n417	2015-02-24 00:00:00	N	T	15020260	GS00034007	51700	_	T	5406	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-02-25 00:00:00.000	331605	YY	2015-02-24 00:00:00	115719	 	NULL	NULL	NULL
70755	1	2015-02-24 00:00:00	n417	2015-02-24 00:00:00	N	T	15020261	GS00034008	66253	_	T	14577	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-02-25 00:00:00.000	331606	YY	2015-02-24 00:00:00	115720	 	NULL	NULL	NULL
70756	1	2015-02-24 00:00:00	n417	2015-02-24 00:00:00	N	T	15020262	GS00034009	66254	_	T	14577	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-02-25 00:00:00.000	331607	YY	2015-02-24 00:00:00	115721	 	NULL	NULL	NULL
70757	1	2015-02-24 00:00:00	n417	2015-02-24 00:00:00	N	T	15020263	GS00034010	66255	_	T	14577	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-02-25 00:00:00.000	331608	YY	2015-02-24 00:00:00	115722	 	NULL	NULL	NULL
70758	1	2015-02-24 00:00:00	n417	2015-02-24 00:00:00	N	T	15020265	GS00034011	66256	_	T	15934	n646	FR1	FR1	N	4000.00	4000.00	Y	2015-02-25 00:00:00.000	331609	YY	2015-02-24 00:00:00	115723	 	NULL	NULL	NULL
70759	1	2015-02-24 09:22:00	n319	2015-02-24 00:00:00	N	P	15010288	GS15000454	28326	_	T	13930	n896	IG1E	AA2	N	10500.00	10500.00	Y	2015-02-25 00:00:00.000	331591	YY	2015-02-24 00:00:00	157884	 	NULL	NULL	NULL
70760	1	2015-02-24 00:00:00	n417	2015-02-24 00:00:00	N	T	15020266	GS00034012	66257	_	T	15934	n646	FR1	FR1	N	4000.00	4000.00	Y	2015-02-25 00:00:00.000	331610	YY	2015-02-24 00:00:00	115724	 	NULL	NULL	NULL
70761	1	2015-02-24 13:36:00	n319	2015-02-24 00:00:00	N	P	15020229	GS15000455	28373	_	T	10747	n1065	IG1E	AA2	N	10500.00	10500.00	Y	2015-02-25 00:00:00.000	331592	YY	2015-02-24 00:00:00	157935	 	NULL	NULL	NULL
70762	1	2015-02-24 15:30:00	n319	2015-02-25 00:00:00	N	P	15020220	GS15000456	24759	_	T	13937	n896	WS8	AK5	N	500.00	500.00	Y	2015-02-26 00:00:00.000	331647	YY	2015-02-25 00:00:00	157981	 	NULL	NULL	NULL
70763	1	2015-02-24 15:31:00	n319	2015-02-25 00:00:00	N	P	15020217	GS15000457	26257	_	T	15012	n1125	WS1	AJ1	N	8500.00	8500.00	Y	2015-02-26 00:00:00.000	331648	YY	2015-02-25 00:00:00	157982	 	NULL	NULL	NULL
70764	1	2015-02-24 00:00:00	n417	2015-02-25 00:00:00	N	T	15020290	GS00034013	65140	_	T	15617	n646	FF0	FF0	N	20000.00	20000.00	Y	2015-02-26 00:00:00.000	331662	YY	2015-02-25 00:00:00	115792	 	NULL	NULL	NULL
70765	1	2015-02-24 00:00:00	n417	2015-02-25 00:00:00	N	T	15020283	GS00034014	65783	_	T	15349	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-02-26 00:00:00.000	331663	YY	2015-02-25 00:00:00	115793	 	NULL	NULL	NULL
70766	1	2015-02-24 00:00:00	n417	2015-02-25 00:00:00	N	T	15020284	GS00034015	65784	_	T	15349	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-02-26 00:00:00.000	331664	YY	2015-02-25 00:00:00	115794	 	NULL	NULL	NULL
70767	1	2015-02-25 08:39:00	n319	2015-02-25 00:00:00	N	P	15020239	GS15000458	26125	_	T	10747	n1065	WS1	AJ1	N	8500.00	8500.00	Y	2015-02-26 00:00:00.000	331649	YY	2015-02-25 00:00:00	157997	 	NULL	NULL	NULL
70768	1	2015-02-25 08:40:00	n319	2015-02-25 00:00:00	N	P	15020238	GS15000459	26126	_	T	10747	n1065	WS1	AJ1	N	8500.00	8500.00	Y	2015-02-26 00:00:00.000	331650	YY	2015-02-25 00:00:00	157998	 	NULL	NULL	NULL
70769	1	2015-02-25 08:41:00	n319	2015-02-25 00:00:00	N	P	15020241	GS15000460	27433	_	T	10747	n1065	WS1	AJ1	N	8500.00	8500.00	Y	2015-02-26 00:00:00.000	331651	YY	2015-02-25 00:00:00	157999	 	NULL	NULL	NULL
70770	1	2015-02-25 08:42:00	n319	2015-02-25 00:00:00	N	P	15020240	GS15000461	27693	_	T	10747	n1065	WS1	AJ1	N	8500.00	8500.00	Y	2015-02-26 00:00:00.000	331652	YY	2015-02-25 00:00:00	158000	 	NULL	NULL	NULL
70771	1	2015-02-25 08:43:00	n319	2015-02-25 00:00:00	N	P	15020234	GS15000462	27820	_	T	10747	n1065	WS1	AJ1	N	8500.00	8500.00	Y	2015-02-26 00:00:00.000	331653	YY	2015-02-25 00:00:00	158001	 	NULL	NULL	NULL
70772	1	2015-02-25 08:43:00	n319	2015-02-25 00:00:00	N	P	15020235	GS15000463	27821	_	T	10747	n1065	WS1	AJ1	N	8500.00	8500.00	Y	2015-02-26 00:00:00.000	331654	YY	2015-02-25 00:00:00	158002	 	NULL	NULL	NULL
70773	1	2015-02-25 08:47:00	n319	2015-02-25 00:00:00	N	P	15020230	GS15000464	27827	_	T	10747	n1065	WS1	AJ1	N	8500.00	8500.00	Y	2015-02-26 00:00:00.000	331655	YY	2015-02-25 00:00:00	158003	 	NULL	NULL	NULL
70774	1	2015-02-25 08:48:00	n319	2015-02-25 00:00:00	N	P	15020231	GS15000465	27828	_	T	10747	n1065	WS1	AJ1	N	8500.00	8500.00	Y	2015-02-26 00:00:00.000	331656	YY	2015-02-25 00:00:00	158004	 	NULL	NULL	NULL
70775	1	2015-02-25 08:49:00	n319	2015-02-25 00:00:00	N	P	15020242	GS15000466	27834	_	T	10747	n1065	WS1	AJ1	N	8500.00	8500.00	Y	2015-02-26 00:00:00.000	331657	YY	2015-02-25 00:00:00	158005	 	NULL	NULL	NULL
70776	1	2015-02-25 08:50:00	n319	2015-02-25 00:00:00	N	P	15020237	GS15000467	28028	_	T	10747	n1065	WS1	AJ1	N	8500.00	8500.00	Y	2015-02-26 00:00:00.000	331658	YY	2015-02-25 00:00:00	158006	 	NULL	NULL	NULL
70777	1	2015-02-25 08:50:00	n319	2015-02-25 00:00:00	N	P	15020236	GS15000468	28029	_	T	10747	n1065	WS1	AJ1	N	8500.00	8500.00	Y	2015-02-26 00:00:00.000	331659	YY	2015-02-25 00:00:00	158007	 	NULL	NULL	NULL
70778	1	2015-02-25 09:13:00	n319	2015-02-25 00:00:00	N	P	15020224	GS15000470	28133	_	T	13708	n896	WS11	AJ2	N	2700.00	2700.00	Y	2015-02-26 00:00:00.000	331660	YY	2015-02-25 00:00:00	158010	 	NULL	NULL	NULL
70779	1	2015-02-25 00:00:00	n417	2015-02-26 00:00:00	N	T	15020288	GS00034016	65517	_	T	15773	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-03-09 00:00:00.000	331832	YY	2015-02-26 00:00:00	115804	 	NULL	NULL	NULL
70780	1	2015-02-25 00:00:00	n417	2015-02-26 00:00:00	N	T	15020289	GS00034017	65518	_	T	15773	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-03-09 00:00:00.000	331833	YY	2015-02-26 00:00:00	115805	 	NULL	NULL	NULL
70781	1	2015-02-25 00:00:00	n417	2015-02-26 00:00:00	N	T	15020287	GS00034018	65519	_	T	15773	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-03-09 00:00:00.000	331834	YY	2015-02-26 00:00:00	115819	 	NULL	NULL	NULL
70782	1	2015-02-25 00:00:00	n417	2015-02-26 00:00:00	N	T	15020286	GS00034019	65520	_	T	15773	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-03-09 00:00:00.000	331835	YY	2015-02-26 00:00:00	115821	 	NULL	NULL	NULL
70783	1	2015-02-25 14:22:00	n319	2015-02-25 00:00:00	N	P	15020258	GS15000471	28378	_	T	10747	n1065	IG1E	AA2	N	10500.00	10500.00	Y	2015-02-26 00:00:00.000	331661	YY	2015-02-25 00:00:00	158096	 	NULL	NULL	NULL
70784	1	2015-02-25 15:48:00	n319	2015-02-26 00:00:00	N	P	15020218	GS15000472	27698	_	T	15606	n1489	WA3	AN5	D	1000.00	1000.00	Y	2015-03-09 00:00:00.000	331817	YY	2015-02-26 00:00:00	158112	 	NULL	NULL	NULL
70785	1	2015-02-25 15:49:00	n319	2015-02-26 00:00:00	N	P	15020246	GS15000473	27736	_	T	3570	n1489	WS1	AJ1	N	1800.00	1800.00	Y	2015-03-09 00:00:00.000	331818	YY	2015-02-26 00:00:00	158113	 	NULL	NULL	NULL
70786	1	2015-02-25 15:50:00	n319	2015-02-26 00:00:00	N	P	15020247	GS15000474	27737	_	T	3570	n1489	WS1	AJ1	N	1800.00	1800.00	Y	2015-03-09 00:00:00.000	331819	YY	2015-02-26 00:00:00	158114	 	NULL	NULL	NULL
70787	1	2015-02-25 16:05:00	n319	2015-02-26 00:00:00	N	P	15020245	GS15000475	25925	_	T	14564	n1486	FC1	AL1	N	2000.00	2000.00	Y	2015-03-09 00:00:00.000	331820	YY	2015-02-26 00:00:00	158116	 	NULL	NULL	NULL
70788	1	2015-02-25 16:06:00	n319	2015-02-26 00:00:00	N	P	15020244	GS15000476	26451	_	T	14564	n1486	FC1	AL1	N	2000.00	2000.00	Y	2015-03-09 00:00:00.000	331821	YY	2015-02-26 00:00:00	158118	 	NULL	NULL	NULL
70789	1	2015-02-26 08:56:00	n319	2015-02-26 00:00:00	N	P	15020253	GS15000478	27130	_	T	4610	n994	WA3	AN5	D	1000.00	1000.00	Y	2015-03-09 00:00:00.000	331822	YY	2015-02-26 00:00:00	158131	 	NULL	NULL	NULL
70790	1	2015-02-26 08:57:00	n319	2015-02-26 00:00:00	N	P	15020252	GS15000479	27761	_	T	15747	n994	WA3	AN5	D	1000.00	1000.00	Y	2015-03-09 00:00:00.000	331823	YY	2015-02-26 00:00:00	158132	 	NULL	NULL	NULL
70791	1	2015-02-26 09:06:00	n319	2015-02-26 00:00:00	N	P	15020254	GS15000480	23961	_	T	14555	n1304	WS21	AK3	N	2800.00	2800.00	Y	2015-03-09 00:00:00.000	331824	YY	2015-02-26 00:00:00	158133	 	NULL	NULL	NULL
70792	1	2015-02-26 09:10:00	n319	2015-02-26 00:00:00	N	P	14120402	GS15000481	28249	_	T	12611	n650	IG1E	AA2	N	10500.00	12900.00	Y	2015-03-09 00:00:00.000	331825	YY	2015-02-26 00:00:00	158134	 	NULL	NULL	NULL
70793	1	2015-02-26 09:10:00	n319	2015-02-26 00:00:00	N	P	15020262	GS15000481	28249	_	T	12611	n650	AC2	AA2	N	2400.00	12900.00	Y	2015-03-09 00:00:00.000	331826	YY	2015-02-26 00:00:00	158134	 	NULL	NULL	NULL
70794	1	2015-02-26 09:13:00	n319	2015-02-26 00:00:00	N	P	15010289	GS15000482	28325	_	T	13930	n896	IG1E	AA2	N	10500.00	10500.00	Y	2015-03-09 00:00:00.000	331827	YY	2015-02-26 00:00:00	158135	 	NULL	NULL	NULL
70795	1	2015-02-26 09:24:00	n319	2015-02-26 00:00:00	N	P	15020259	GS15000483	25317	_	T	14871	n896	WS21	AK3	N	8400.00	8400.00	Y	2015-03-09 00:00:00.000	331828	YY	2015-02-26 00:00:00	158136	 	NULL	NULL	NULL
70796	1	2015-02-26 09:41:00	n319	2015-02-26 00:00:00	N	P	15020255	GS15000485	1018	M	T	12293	n113	WS2	AK2	X	8000.00	8000.00	Y	2015-03-09 00:00:00.000	331829	YE	2015-02-26 00:00:00	158138	 	NULL	NULL	NULL
70797	1	2015-02-26 09:41:00	n319	2015-02-26 00:00:00	N	P	15020256	GS15000486	1032	M	T	12293	n113	WS2	AK2	X	8000.00	8000.00	Y	2015-03-09 00:00:00.000	331830	YE	2015-02-26 00:00:00	158139	 	NULL	NULL	NULL
70798	1	2015-02-26 00:00:00	n417	2015-03-02 00:00:00	N	T	15020075	GS00034027	66161	_	T	13104	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-03-09 00:00:00.000	331841	YY	2015-03-02 00:00:00	115909	 	NULL	NULL	NULL
70799	1	2015-02-26 11:22:00	n319	2015-02-26 00:00:00	N	P	15020088	GS15000487	28350	_	T	15937	n1486	IG1E	AA2	N	10500.00	10500.00	Y	2015-03-09 00:00:00.000	331831	YY	2015-02-26 00:00:00	158160	 	NULL	NULL	NULL
70800	1	2015-02-26 00:00:00	n417	2015-03-02 00:00:00	N	T	15020312	GS00034028	65818	_	T	15842	n547	FF0	FF0	N	7500.00	7500.00	Y	2015-03-09 00:00:00.000	331842	YY	2015-03-02 00:00:00	115966	 	NULL	NULL	NULL
70801	1	2015-02-26 00:00:00	n417	2015-03-02 00:00:00	N	T	15020277	GS00034029	38316	_	T	2915	n646	FR1	FR1	N	4000.00	4000.00	Y	2015-03-09 00:00:00.000	331843	YY	2015-03-02 00:00:00	115969	 	NULL	NULL	NULL
70802	1	2015-02-26 15:52:00	n319	2015-03-02 00:00:00	N	P	15020257	GS15000488	1086	M	T	12293	n113	WS1	AJ1	X	3500.00	3500.00	Y	2015-03-09 00:00:00.000	331836	YY	2015-03-02 00:00:00	158238	 	NULL	NULL	NULL
70803	1	2015-02-26 15:53:00	n319	2015-03-02 00:00:00	N	P	15020268	GS15000489	27831	_	T	15762	n1489	WS11	AJ2	N	6100.00	6100.00	Y	2015-03-09 00:00:00.000	331837	YY	2015-03-02 00:00:00	158239	 	NULL	NULL	NULL
70804	1	2015-02-26 15:54:00	n319	2015-03-02 00:00:00	N	P	15020269	GS15000490	27832	_	T	15762	n1489	WS11	AJ2	N	6100.00	6100.00	Y	2015-03-09 00:00:00.000	331838	YY	2015-03-02 00:00:00	158240	 	NULL	NULL	NULL
70805	1	2015-03-02 00:00:00	n029	2015-03-02 00:00:00	N	T	15020310	GS00034030	52310	_	T	4220	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-03-09 00:00:00.000	331844	YY	2015-03-02 00:00:00	115995	 	NULL	NULL	NULL
70806	1	2015-03-02 00:00:00	n029	2015-03-02 00:00:00	N	T	15020280	GS00034031	17678	_	T	2915	n646	FR1	FR1	N	4000.00	4000.00	Y	2015-03-09 00:00:00.000	331845	YY	2015-03-02 00:00:00	115996	 	NULL	NULL	NULL
70807	1	2015-03-02 00:00:00	n029	2015-03-02 00:00:00	N	T	15020279	GS00034032	17679	_	T	2915	n646	FR1	FR1	N	4000.00	4000.00	Y	2015-03-09 00:00:00.000	331846	YY	2015-03-02 00:00:00	115997	 	NULL	NULL	NULL
70808	1	2015-03-02 00:00:00	n029	2015-03-02 00:00:00	N	T	15020278	GS00034033	17680	_	T	2915	n646	FR1	FR1	N	4000.00	4000.00	Y	2015-03-09 00:00:00.000	331847	YY	2015-03-02 00:00:00	115998	 	NULL	NULL	NULL
70809	1	2015-03-02 08:47:00	n087	2015-03-02 00:00:00	N	P	15020270	GS15000493	25176	_	T	13712	n896	WS1	AJ1	N	6000.00	6000.00	Y	2015-03-09 00:00:00.000	331839	YY	2015-03-02 00:00:00	158266	 	NULL	NULL	NULL
70810	1	2015-03-02 09:37:00	n087	2015-03-02 00:00:00	N	P	15010114	GS15000496	28288	_	T	13225	n896	UG1	AA3	N	3000.00	3000.00	Y	2015-03-09 00:00:00.000	331840	YY	2015-03-02 00:00:00	158269	 	NULL	NULL	NULL
70811	1	2015-03-02 00:00:00	n029	2015-03-03 00:00:00	N	T	15020324	GS00034034	65292	_	T	15695	n441	FF0	FF0	N	15000.00	15000.00	Y	2015-03-09 00:00:00.000	331861	YY	2015-03-03 00:00:00	116044	 	NULL	NULL	NULL
70812	1	2015-03-02 00:00:00	n029	2015-03-03 00:00:00	N	T	15020328	GS00034035	65274	_	T	15695	n441	FF0	FF0	N	12500.00	12500.00	Y	2015-03-09 00:00:00.000	331862	YY	2015-03-03 00:00:00	116045	 	NULL	NULL	NULL
70813	1	2015-03-02 00:00:00	n029	2015-03-03 00:00:00	N	T	15020327	GS00034036	65355	_	T	15695	n441	FF0	FF0	N	15000.00	15000.00	N	NULL	0	XX	2015-03-03 00:00:00	116046	 	NULL	NULL	NULL
70814	1	2015-03-02 00:00:00	n029	2015-03-03 00:00:00	N	T	15020326	GS00034037	65354	_	T	15695	n441	FF0	FF0	N	15000.00	15000.00	N	NULL	0	XX	2015-03-03 00:00:00	116047	 	NULL	NULL	NULL
70815	1	2015-03-02 00:00:00	n029	2015-03-03 00:00:00	N	T	15020325	GS00034038	65293	_	T	15695	n441	FF0	FF0	N	12500.00	12500.00	Y	2015-03-09 00:00:00.000	331863	YY	2015-03-03 00:00:00	116048	 	NULL	NULL	NULL
70816	1	2015-03-02 00:00:00	n029	2015-03-03 00:00:00	N	T	15020323	GS00034039	65538	_	T	13712	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-03-09 00:00:00.000	331864	YY	2015-03-03 00:00:00	116049	 	NULL	NULL	NULL
70817	1	2015-03-02 00:00:00	n029	2015-03-03 00:00:00	N	T	15030007	GS00034040	65166	_	T	15662	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-03-09 00:00:00.000	331865	YY	2015-03-03 00:00:00	116050	 	NULL	NULL	NULL
70818	1	2015-03-02 00:00:00	n029	2015-03-03 00:00:00	N	T	15020322	GS00034044	66258	_	T	12563	n646	FR1	FR1	N	4000.00	4000.00	Y	2015-03-09 00:00:00.000	331866	YY	2015-03-03 00:00:00	116054	 	NULL	NULL	NULL
70819	1	2015-03-02 00:00:00	n029	2015-03-03 00:00:00	N	T	15020306	GS00034045	41687	_	T	6316	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-03-09 00:00:00.000	331867	YY	2015-03-03 00:00:00	116055	 	NULL	NULL	NULL
70820	1	2015-03-02 00:00:00	n029	2015-03-03 00:00:00	N	T	15020307	GS00034046	37715	_	T	6316	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-03-09 00:00:00.000	331868	YY	2015-03-03 00:00:00	116056	 	NULL	NULL	NULL
70821	1	2015-03-02 00:00:00	n029	2015-03-03 00:00:00	N	T	15020308	GS00034047	37614	_	T	6316	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-03-09 00:00:00.000	331869	YY	2015-03-03 00:00:00	116057	 	NULL	NULL	NULL
70822	1	2015-03-03 08:51:00	n319	2015-03-03 00:00:00	N	P	15030006	GS15000497	23974	_	T	13648	n650	WS21	AK3	N	2800.00	2800.00	Y	2015-03-09 00:00:00.000	331848	YY	2015-03-03 00:00:00	158350	 	NULL	NULL	NULL
70823	1	2015-03-03 08:52:00	n319	2015-03-03 00:00:00	N	P	15030007	GS15000498	24209	_	T	13648	n650	WS21	AK3	N	2800.00	2800.00	Y	2015-03-09 00:00:00.000	331849	YY	2015-03-03 00:00:00	158351	 	NULL	NULL	NULL
70824	1	2015-03-03 08:53:00	n319	2015-03-03 00:00:00	N	P	15030008	GS15000499	25976	_	T	13648	n650	WS21	AK3	N	1700.00	1700.00	Y	2015-03-09 00:00:00.000	331850	YY	2015-03-03 00:00:00	158352	 	NULL	NULL	NULL
70825	1	2015-03-03 08:54:00	n319	2015-03-03 00:00:00	N	P	15030009	GS15000500	25977	_	T	13648	n650	WS21	AK3	N	1700.00	1700.00	Y	2015-03-09 00:00:00.000	331851	YY	2015-03-03 00:00:00	158353	 	NULL	NULL	NULL
70826	1	2015-03-03 08:56:00	n319	2015-03-03 00:00:00	N	P	15010309	GS15000501	26189	_	T	2853	n100	FR1	AB1	N	7000.00	11800.00	Y	2015-03-09 00:00:00.000	331852	YY	2015-03-03 00:00:00	158354	 	NULL	NULL	NULL
70827	1	2015-03-03 08:56:00	n319	2015-03-03 00:00:00	N	P	15030010	GS15000501	26189	_	T	2853	n100	FR12	AB1	N	4800.00	11800.00	Y	2015-03-09 00:00:00.000	331853	YY	2015-03-03 00:00:00	158354	 	NULL	NULL	NULL
70828	1	2015-03-03 08:57:00	n319	2015-03-03 00:00:00	N	P	15010310	GS15000502	26189	_	T	2853	n100	AB8	AB8	N	1000.00	1000.00	Y	2015-03-09 00:00:00.000	331854	YY	2015-03-03 00:00:00	158355	 	NULL	NULL	NULL
70829	1	2015-03-03 08:59:00	n319	2015-03-03 00:00:00	N	P	15030017	GS15000503	27382	_	T	99999	n994	WS1	AJ1	N	8500.00	8500.00	Y	2015-03-09 00:00:00.000	331855	YY	2015-03-03 00:00:00	158357	 	NULL	NULL	NULL
70830	1	2015-03-03 09:01:00	n319	2015-03-03 00:00:00	N	P	15020272	GS15000504	27902	_	T	15786	n1125	WS11	AJ2	N	2700.00	2700.00	Y	2015-03-09 00:00:00.000	331856	YY	2015-03-03 00:00:00	158362	 	NULL	NULL	NULL
70831	1	2015-03-03 09:05:00	n319	2015-03-03 00:00:00	N	P	14110208	GS15000506	28155	_	T	15877	n994	IG1B	AA21	N	9700.00	9700.00	Y	2015-03-09 00:00:00.000	331857	YY	2015-03-03 00:00:00	158366	 	NULL	NULL	NULL
70832	1	2015-03-03 09:07:00	n319	2015-03-03 00:00:00	N	P	15010090	GS15000507	28285	_	T	4610	n994	UG1	AA3	N	3000.00	3000.00	Y	2015-03-09 00:00:00.000	331858	YY	2015-03-03 00:00:00	158368	 	NULL	NULL	NULL
70833	1	2015-03-03 09:09:00	n319	2015-03-03 00:00:00	N	P	15010246	GS15000508	28320	_	T	10554	n100	UG1	AA3	N	3000.00	3000.00	Y	2015-03-09 00:00:00.000	331859	YY	2015-03-03 00:00:00	158372	 	NULL	NULL	NULL
70834	1	2015-03-03 09:43:00	n319	2015-03-03 00:00:00	N	P	15030004	GS15000509	18116	_	T	12406	n650	WS2	AK2	N	16000.00	16000.00	Y	2015-03-09 00:00:00.000	331860	YE	2015-03-03 00:00:00	158402	 	NULL	NULL	NULL
70835	1	2015-03-03 16:46:00	n319	2015-03-04 00:00:00	N	P	15030003	GS15000510	26321	_	T	13472	n1304	WS1	AJ1	N	8500.00	8500.00	Y	2015-03-09 00:00:00.000	331871	YY	2015-03-04 00:00:00	158517	 	NULL	NULL	NULL
70836	1	2015-03-03 16:47:00	n319	2015-03-04 00:00:00	N	P	15030021	GS15000511	26595	_	T	15311	n1065	WS11	AJ2	N	6100.00	6100.00	Y	2015-03-09 00:00:00.000	331872	YY	2015-03-04 00:00:00	158518	 	NULL	NULL	NULL
70837	1	2015-03-03 16:48:00	n319	2015-03-04 00:00:00	N	P	15030023	GS15000512	27860	_	T	15780	n1125	WS11	AJ2	N	2700.00	2700.00	Y	2015-03-09 00:00:00.000	331873	YY	2015-03-04 00:00:00	158519	 	NULL	NULL	NULL
70838	1	2015-03-03 16:51:00	n319	2015-03-04 00:00:00	N	P	14120320	GS15000513	27893	_	T	10027	n113	WS11	AJ2	N	4400.00	4400.00	Y	2015-03-09 00:00:00.000	331874	YY	2015-03-04 00:00:00	158520	 	NULL	NULL	NULL
70839	1	2015-03-03 00:00:00	n029	2015-03-04 00:00:00	N	T	15030010	GS00034055	54372	_	T	13325	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-03-09 00:00:00.000	331879	YY	2015-03-04 00:00:00	116142	 	NULL	NULL	NULL
70840	1	2015-03-03 00:00:00	n029	2015-03-04 00:00:00	N	T	15020327	GS00034056	65355	_	T	15695	n441	FF0	FF0	N	12500.00	12500.00	Y	2015-03-09 00:00:00.000	331880	YY	2015-03-04 00:00:00	116143	 	NULL	NULL	NULL
70841	1	2015-03-03 00:00:00	n029	2015-03-04 00:00:00	N	T	15020326	GS00034057	65354	_	T	15695	n441	FF0	FF0	N	12500.00	12500.00	Y	2015-03-09 00:00:00.000	331881	YY	2015-03-04 00:00:00	116144	 	NULL	NULL	NULL
70842	1	2015-03-03 17:14:00	n319	2015-03-04 00:00:00	N	P	15030002	GS15000516	27654	_	T	13472	n1304	WS1	AJ1	N	8500.00	8500.00	Y	2015-03-09 00:00:00.000	331875	YY	2015-03-04 00:00:00	158523	 	NULL	NULL	NULL
70843	1	2015-03-03 17:15:00	n319	2015-03-04 00:00:00	N	P	15030001	GS15000517	27746	_	T	13472	n1304	WS1	AJ1	N	8500.00	8500.00	Y	2015-03-09 00:00:00.000	331876	YY	2015-03-04 00:00:00	158524	 	NULL	NULL	NULL
70844	1	2015-03-04 00:00:00	n029	2015-03-04 00:00:00	N	T	15030002	GS00034061	66266	_	T	15938	n646	FE1	FE1	N	2400.00	2400.00	Y	2015-03-09 00:00:00.000	331882	YE	2015-03-04 00:00:00	116148	 	NULL	NULL	NULL
70845	1	2015-03-04 00:00:00	n029	2015-03-04 00:00:00	N	T	15030013	GS00034062	66259	_	T	3669	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-03-09 00:00:00.000	331883	YY	2015-03-04 00:00:00	116154	 	NULL	NULL	NULL
70846	1	2015-03-04 08:48:00	n319	2015-03-04 00:00:00	N	P	15030022	GS15000518	25221	_	T	12374	n1304	WS11	AJ2	N	17500.00	17500.00	Y	2015-03-09 00:00:00.000	331877	YY	2015-03-04 00:00:00	158525	 	NULL	NULL	NULL
70847	1	2015-03-04 00:00:00	n029	2015-03-04 00:00:00	N	T	15030014	GS00034063	66260	_	T	3669	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-03-09 00:00:00.000	331884	YY	2015-03-04 00:00:00	116155	 	NULL	NULL	NULL
70848	1	2015-03-04 08:56:00	n319	2015-03-04 00:00:00	N	P	15020062	GS15000522	28347	_	T	14374	n1304	UG1	AA3	N	3000.00	3000.00	Y	2015-03-09 00:00:00.000	331878	YY	2015-03-04 00:00:00	158529	 	NULL	NULL	NULL
70849	1	2015-03-04 00:00:00	n029	2015-03-04 00:00:00	N	T	15030012	GS00034064	52941	_	T	13066	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-03-09 00:00:00.000	331885	YY	2015-03-04 00:00:00	116156	 	NULL	NULL	NULL
70850	1	2015-03-04 00:00:00	n029	2015-03-04 00:00:00	N	T	15030011	GS00034065	52942	_	T	13066	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-03-09 00:00:00.000	331886	YY	2015-03-04 00:00:00	116157	 	NULL	NULL	NULL
70851	1	2015-03-04 16:00:00	n319	2015-03-05 00:00:00	N	P	15030041	GS15000524	28134	_	T	7683	n650	WS1	AJ1	N	3500.00	3500.00	Y	2015-03-09 00:00:00.000	331887	YY	2015-03-05 00:00:00	158608	 	NULL	NULL	NULL
70852	1	2015-03-04 00:00:00	n029	2015-03-05 00:00:00	N	T	15030046	GS00034068	65157	_	T	15645	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-03-09 00:00:00.000	331893	YY	2015-03-05 00:00:00	116205	 	NULL	NULL	NULL
70853	1	2015-03-04 00:00:00	n029	2015-03-05 00:00:00	N	T	15030047	GS00034069	65158	_	T	15645	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-03-09 00:00:00.000	331894	YY	2015-03-05 00:00:00	116206	 	NULL	NULL	NULL
70854	1	2015-03-04 00:00:00	n029	2015-03-05 00:00:00	N	T	15030048	GS00034070	65159	_	T	15645	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-03-09 00:00:00.000	331895	YY	2015-03-05 00:00:00	116207	 	NULL	NULL	NULL
70855	1	2015-03-04 00:00:00	n029	2015-03-05 00:00:00	N	T	15030032	GS00034071	49189	_	T	827	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-03-09 00:00:00.000	331896	YY	2015-03-05 00:00:00	116208	 	NULL	NULL	NULL
70856	1	2015-03-04 00:00:00	n029	2015-03-05 00:00:00	N	T	15030022	GS00034072	15679	_	T	827	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-03-09 00:00:00.000	331897	YY	2015-03-05 00:00:00	116209	 	NULL	NULL	NULL
70857	1	2015-03-04 00:00:00	n029	2015-03-05 00:00:00	N	T	15030023	GS00034073	15677	_	T	827	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-03-09 00:00:00.000	331898	YY	2015-03-05 00:00:00	116210	 	NULL	NULL	NULL
70858	1	2015-03-04 00:00:00	n029	2015-03-05 00:00:00	N	T	15030024	GS00034074	66261	_	T	827	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-03-09 00:00:00.000	331899	YY	2015-03-05 00:00:00	116213	 	NULL	NULL	NULL
70859	1	2015-03-04 00:00:00	n029	2015-03-05 00:00:00	N	T	15030025	GS00034075	66262	_	T	827	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-03-09 00:00:00.000	331900	YY	2015-03-05 00:00:00	116214	 	NULL	NULL	NULL
70860	1	2015-03-04 00:00:00	n029	2015-03-05 00:00:00	N	T	15030026	GS00034076	66263	_	T	827	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-03-09 00:00:00.000	331901	YY	2015-03-05 00:00:00	116215	 	NULL	NULL	NULL
70861	1	2015-03-04 00:00:00	n029	2015-03-05 00:00:00	N	T	15030027	GS00034077	66264	_	T	827	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-03-09 00:00:00.000	331902	YY	2015-03-05 00:00:00	116216	 	NULL	NULL	NULL
70862	1	2015-03-04 00:00:00	n029	2015-03-05 00:00:00	N	T	15030028	GS00034078	66265	_	T	827	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-03-09 00:00:00.000	331903	YY	2015-03-05 00:00:00	116217	 	NULL	NULL	NULL
70863	1	2015-03-04 00:00:00	n029	2015-03-05 00:00:00	N	T	15030029	GS00034079	15684	_	T	827	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-03-09 00:00:00.000	331904	YY	2015-03-05 00:00:00	116218	 	NULL	NULL	NULL
70864	1	2015-03-04 00:00:00	n029	2015-03-05 00:00:00	N	T	15030030	GS00034080	15682	_	T	827	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-03-09 00:00:00.000	331905	YY	2015-03-05 00:00:00	116219	 	NULL	NULL	NULL
70865	1	2015-03-04 00:00:00	n029	2015-03-05 00:00:00	N	T	15030031	GS00034081	15680	_	T	827	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-03-09 00:00:00.000	331906	YY	2015-03-05 00:00:00	116220	 	NULL	NULL	NULL
70866	1	2015-03-05 00:00:00	n029	2015-03-05 00:00:00	N	T	15030021	GS00034082	66267	_	T	15480	n428	FE1	FE1	N	2400.00	2400.00	Y	2015-03-09 00:00:00.000	331907	YE	2015-03-05 00:00:00	116221	 	NULL	NULL	NULL
70867	1	2015-03-05 00:00:00	n029	2015-03-05 00:00:00	N	T	15030015	GS00034083	66279	_	T	15445	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-03-09 00:00:00.000	331908	YE	2015-03-05 00:00:00	116222	 	NULL	NULL	NULL
70868	1	2015-03-05 00:00:00	n029	2015-03-05 00:00:00	N	T	15030016	GS00034084	66280	_	T	15445	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-03-09 00:00:00.000	331909	YE	2015-03-05 00:00:00	116223	 	NULL	NULL	NULL
70869	1	2015-03-05 08:42:00	n319	2015-03-05 00:00:00	N	P	15030054	GS15000528	25206	_	T	6465	n994	WS21	AK3	N	8400.00	8400.00	Y	2015-03-09 00:00:00.000	331888	YY	2015-03-05 00:00:00	158621	 	NULL	NULL	NULL
70870	1	2015-03-05 08:43:00	n319	2015-03-05 00:00:00	N	P	15030055	GS15000529	25242	_	T	6465	n994	WS21	AK3	N	8400.00	8400.00	Y	2015-03-09 00:00:00.000	331889	YY	2015-03-05 00:00:00	158622	 	NULL	NULL	NULL
70871	1	2015-03-05 08:44:00	n319	2015-03-05 00:00:00	N	P	15030056	GS15000530	25243	_	T	6465	n994	WS21	AK3	N	8400.00	8400.00	Y	2015-03-09 00:00:00.000	331890	YY	2015-03-05 00:00:00	158623	 	NULL	NULL	NULL
70872	1	2015-03-05 00:00:00	n029	2015-03-05 00:00:00	N	T	15030037	GS00034085	66270	_	T	7759	n547	FE1	FE1	N	5400.00	5400.00	Y	2015-03-09 00:00:00.000	331910	YE	2015-03-05 00:00:00	116224	 	NULL	NULL	NULL
70873	1	2015-03-05 09:42:00	n319	2015-03-05 00:00:00	N	P	15030036	GS15000531	1051	M	T	12154	n113	WS2	AK2	X	8000.00	8000.00	Y	2015-03-09 00:00:00.000	331891	YE	2015-03-05 00:00:00	158624	 	NULL	NULL	NULL
70874	1	2015-03-05 09:42:00	n319	2015-03-05 00:00:00	N	P	15030043	GS15000532	18316	_	T	2853	n100	WS2	AK2	N	48000.00	48000.00	Y	2015-03-09 00:00:00.000	331892	YE	2015-03-05 00:00:00	158625	 	NULL	NULL	NULL
70875	1	2015-03-05 00:00:00	n029	2015-03-06 00:00:00	N	T	15030038	GS00034086	66281	_	T	15772	n646	FE1	FE1	N	5400.00	5400.00	Y	2015-03-09 00:00:00.000	331915	YE	2015-03-06 00:00:00	116264	 	NULL	NULL	NULL
70876	1	2015-03-05 00:00:00	n029	2015-03-06 00:00:00	N	T	15030043	GS00034087	66282	_	T	15772	n646	FE1	FE1	N	5400.00	5400.00	Y	2015-03-09 00:00:00.000	331916	YE	2015-03-06 00:00:00	116265	 	NULL	NULL	NULL
70877	1	2015-03-05 00:00:00	n029	2015-03-06 00:00:00	N	T	15030045	GS00034088	66283	_	T	7701	n646	FE1	FE1	N	5100.00	5100.00	Y	2015-03-09 00:00:00.000	331917	YE	2015-03-06 00:00:00	116266	 	NULL	NULL	NULL
70878	1	2015-03-05 00:00:00	n029	2015-03-06 00:00:00	N	T	15030057	GS00034090	65758	_	T	13770	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-03-09 00:00:00.000	331918	YY	2015-03-06 00:00:00	116268	 	NULL	NULL	NULL
70879	1	2015-03-05 00:00:00	n029	2015-03-06 00:00:00	N	T	15030049	GS00034091	52125	_	T	5197	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-03-09 00:00:00.000	331919	YY	2015-03-06 00:00:00	116269	 	NULL	NULL	NULL
70880	1	2015-03-05 00:00:00	n029	2015-03-06 00:00:00	N	T	15030050	GS00034092	52718	_	T	6609	n646	FR1	FR1	N	4000.00	4000.00	Y	2015-03-09 00:00:00.000	331920	YY	2015-03-06 00:00:00	116270	 	NULL	NULL	NULL
70881	1	2015-03-05 00:00:00	n029	2015-03-06 00:00:00	N	T	15030035	GS00034093	65536	_	T	15667	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-03-09 00:00:00.000	331921	YY	2015-03-06 00:00:00	116271	 	NULL	NULL	NULL
70882	1	2015-03-05 00:00:00	n029	2015-03-06 00:00:00	N	T	15030036	GS00034094	65537	_	T	15667	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-03-09 00:00:00.000	331922	YY	2015-03-06 00:00:00	116272	 	NULL	NULL	NULL
70883	1	2015-03-05 00:00:00	n029	2015-03-06 00:00:00	N	T	15020329	GS00034095	66268	_	T	15940	n646	FT1	FT1	N	2000.00	2000.00	Y	2015-03-09 00:00:00.000	331923	YY	2015-03-06 00:00:00	116275	 	NULL	NULL	NULL
70884	1	2015-03-05 00:00:00	n029	2015-03-06 00:00:00	N	T	15020330	GS00034096	66269	_	T	15940	n646	FT1	FT1	N	2000.00	2000.00	Y	2015-03-09 00:00:00.000	331924	YY	2015-03-06 00:00:00	116278	 	NULL	NULL	NULL
70885	1	2015-03-05 00:00:00	n029	2015-03-06 00:00:00	N	T	15020331	GS00034097	66271	_	T	15940	n646	FT1	FT1	N	2000.00	2000.00	Y	2015-03-09 00:00:00.000	331925	YY	2015-03-06 00:00:00	116280	 	NULL	NULL	NULL
70886	1	2015-03-05 00:00:00	n029	2015-03-06 00:00:00	N	T	15020332	GS00034098	66272	_	T	15940	n646	FT1	FT1	N	2000.00	2000.00	Y	2015-03-09 00:00:00.000	331926	YY	2015-03-06 00:00:00	116281	 	NULL	NULL	NULL
70887	1	2015-03-05 00:00:00	n029	2015-03-06 00:00:00	N	T	15020333	GS00034099	66273	_	T	15940	n646	FT1	FT1	N	2000.00	2000.00	Y	2015-03-09 00:00:00.000	331927	YY	2015-03-06 00:00:00	116282	 	NULL	NULL	NULL
70888	1	2015-03-05 00:00:00	n029	2015-03-06 00:00:00	N	T	15020334	GS00034100	66274	_	T	15940	n646	FT1	FT1	N	2000.00	2000.00	Y	2015-03-09 00:00:00.000	331928	YY	2015-03-06 00:00:00	116283	 	NULL	NULL	NULL
70889	1	2015-03-05 00:00:00	n029	2015-03-06 00:00:00	N	T	15020335	GS00034101	66275	_	T	15940	n646	FT1	FT1	N	2000.00	2000.00	Y	2015-03-09 00:00:00.000	331929	YY	2015-03-06 00:00:00	116286	 	NULL	NULL	NULL
70890	1	2015-03-05 00:00:00	n029	2015-03-06 00:00:00	N	T	15020336	GS00034102	66276	_	T	15940	n646	FT1	FT1	N	2000.00	2000.00	Y	2015-03-09 00:00:00.000	331930	YY	2015-03-06 00:00:00	116287	 	NULL	NULL	NULL
70891	1	2015-03-05 00:00:00	n029	2015-03-06 00:00:00	N	T	15020337	GS00034103	66277	_	T	15940	n646	FT1	FT1	N	2000.00	2000.00	Y	2015-03-09 00:00:00.000	331931	YY	2015-03-06 00:00:00	116288	 	NULL	NULL	NULL
70892	1	2015-03-05 00:00:00	n029	2015-03-06 00:00:00	N	T	15020338	GS00034104	66278	_	T	15940	n646	FT1	FT1	N	2000.00	2000.00	Y	2015-03-09 00:00:00.000	331932	YY	2015-03-06 00:00:00	116289	 	NULL	NULL	NULL
70893	1	2015-03-05 00:00:00	k1416	2015-03-05 00:00:00	N	T	15020295	BGS0004829	66162	_	T	6067	n428	FB2	FB2	N	600.00	600.00	Y	2015-03-09 00:00:00.000	331933	YY	2015-03-06 00:00:00	116305	 	NULL	NULL	NULL
70894	1	2015-03-06 00:00:00	n029	2015-03-06 00:00:00	N	T	15030060	GS00034105	66284	_	T	15377	n428	FE1	FE1	N	2400.00	2400.00	Y	2015-03-09 00:00:00.000	331934	YE	2015-03-06 00:00:00	116314	 	NULL	NULL	NULL
70895	1	2015-03-06 09:04:00	n319	2015-03-06 00:00:00	N	P	14100011	GS15000535	25824	_	T	11405	n1486	FR1	AB1	N	7000.00	7000.00	Y	2015-03-09 00:00:00.000	331911	YY	2015-03-06 00:00:00	158723	 	NULL	NULL	NULL
70896	1	2015-03-06 09:12:00	n319	2015-03-06 00:00:00	N	P	15010051	GS15000538	28275	_	T	12000	n1304	IG1B	AA21	N	9700.00	15800.00	Y	2015-03-09 00:00:00.000	331912	YY	2015-03-06 00:00:00	158726	 	NULL	NULL	NULL
70897	1	2015-03-06 09:12:00	n319	2015-03-06 00:00:00	N	P	15030071	GS15000538	28275	_	T	12000	n1304	AC2	AA21	N	6100.00	15800.00	Y	2015-03-09 00:00:00.000	331913	YY	2015-03-06 00:00:00	158726	 	NULL	NULL	NULL
70898	1	2015-03-06 11:39:00	n319	2015-03-06 00:00:00	N	P	14110236	GS15000539	28161	_	T	13472	n1304	UG1	AA3	N	3000.00	3000.00	Y	2015-03-09 00:00:00.000	331914	YY	2015-03-06 00:00:00	158775	 	NULL	NULL	NULL
70899	1	2015-03-06 15:32:00	n319	2015-03-09 00:00:00	N	P	15030061	GS15000540	24188	_	T	11405	n1486	WS11	AJ2	N	2700.00	2700.00	Y	2015-03-13 00:00:00.000	332179	YY	2015-03-09 00:00:00	158836	 	NULL	NULL	NULL
70900	1	2015-03-09 00:00:00	n029	2015-03-09 00:00:00	N	T	15030069	GS00034106	65200	_	T	15348	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-03-13 00:00:00.000	332187	YY	2015-03-09 00:00:00	116360	 	NULL	NULL	NULL
70901	1	2015-03-09 08:44:00	n319	2015-03-09 00:00:00	N	P	15030089	GS15000543	25809	_	T	7900	n650	WS21	AK3	N	8400.00	8400.00	Y	2015-03-13 00:00:00.000	332180	YY	2015-03-09 00:00:00	158852	 	NULL	NULL	NULL
70902	1	2015-03-09 08:50:00	n319	2015-03-09 00:00:00	N	P	15030084	GS15000545	27353	_	T	4610	n994	WA3	AN5	D	1000.00	1000.00	Y	2015-03-13 00:00:00.000	332181	YY	2015-03-09 00:00:00	158854	 	NULL	NULL	NULL
70903	1	2015-03-09 08:51:00	n319	2015-03-09 00:00:00	N	P	15030085	GS15000546	27466	_	T	4610	n994	WA3	AN5	D	1000.00	1000.00	Y	2015-03-13 00:00:00.000	332182	YY	2015-03-09 00:00:00	158855	 	NULL	NULL	NULL
70904	1	2015-03-09 08:53:00	n319	2015-03-09 00:00:00	N	P	15030064	GS15000547	28087	_	T	14374	n1304	WS11	AJ2	N	6100.00	6100.00	Y	2015-03-13 00:00:00.000	332183	YY	2015-03-09 00:00:00	158856	 	NULL	NULL	NULL
70905	1	2015-03-09 08:53:00	n319	2015-03-09 00:00:00	N	P	15030065	GS15000548	28088	_	T	14374	n1304	WS11	AJ2	N	6100.00	6100.00	Y	2015-03-13 00:00:00.000	332184	YY	2015-03-09 00:00:00	158857	 	NULL	NULL	NULL
70906	1	2015-03-09 08:54:00	n319	2015-03-09 00:00:00	N	P	15030066	GS15000549	28092	_	T	14374	n1304	WS11	AJ2	N	6100.00	6100.00	Y	2015-03-13 00:00:00.000	332185	YY	2015-03-09 00:00:00	158858	 	NULL	NULL	NULL
70907	1	2015-03-09 00:00:00	n029	2015-03-09 00:00:00	N	T	15030066	GS00034107	52969	_	T	5122	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-03-13 00:00:00.000	332188	YY	2015-03-09 00:00:00	116361	 	NULL	NULL	NULL
70908	1	2015-03-09 00:00:00	n029	2015-03-09 00:00:00	N	T	15030065	GS00034108	52180	_	T	5122	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-03-13 00:00:00.000	332189	YY	2015-03-09 00:00:00	116362	 	NULL	NULL	NULL
70909	1	2015-03-09 09:16:00	n319	2015-03-09 00:00:00	N	P	15020139	GS15000553	28357	_	T	15785	n113	UG1	AA3	N	3000.00	3000.00	Y	2015-03-13 00:00:00.000	332186	YY	2015-03-09 00:00:00	158862	 	NULL	NULL	NULL
70910	1	2015-03-09 00:00:00	n029	2015-03-09 00:00:00	N	T	15030052	GS00034109	66285	_	T	15800	n1384	FE11	FE11	N	2700.00	2700.00	Y	2015-03-13 00:00:00.000	332190	YE	2015-03-09 00:00:00	116363	 	NULL	NULL	NULL
70911	1	2015-03-09 00:00:00	n029	2015-03-09 00:00:00	N	T	15030051	GS00034110	66286	_	T	15800	n1384	FE11	FE11	N	2700.00	2700.00	Y	2015-03-13 00:00:00.000	332191	YE	2015-03-09 00:00:00	116364	 	NULL	NULL	NULL
70912	1	2015-03-09 00:00:00	n029	2015-03-09 00:00:00	N	T	15030053	GS00034111	66287	_	T	15800	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-03-13 00:00:00.000	332192	YE	2015-03-09 00:00:00	116365	 	NULL	NULL	NULL
70913	1	2015-03-09 00:00:00	n029	2015-03-09 00:00:00	N	T	15030054	GS00034112	66288	_	T	15800	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-03-13 00:00:00.000	332193	YE	2015-03-09 00:00:00	116366	 	NULL	NULL	NULL
70914	1	2015-03-09 14:53:00	n319	2015-03-10 00:00:00	N	P	15030096	GS15000554	1153	M	T	15318	n113	WS21	AK3	X	3800.00	3800.00	Y	2015-03-13 00:00:00.000	332194	YY	2015-03-10 00:00:00	158947	 	NULL	NULL	NULL
70915	1	2015-03-09 14:55:00	n319	2015-03-10 00:00:00	N	P	15030072	GS15000555	25756	_	T	14976	n1125	WS21	AK3	N	1700.00	1700.00	Y	2015-03-13 00:00:00.000	332195	YY	2015-03-10 00:00:00	158948	 	NULL	NULL	NULL
70916	1	2015-03-09 14:58:00	n319	2015-03-10 00:00:00	N	P	15030087	GS15000556	26251	_	T	11997	n1486	FC1	AL1	N	2000.00	2000.00	Y	2015-03-13 00:00:00.000	332196	YY	2015-03-10 00:00:00	158952	 	NULL	NULL	NULL
70917	1	2015-03-09 14:59:00	n319	2015-03-10 00:00:00	N	P	15030078	GS15000557	26251	_	T	11997	n1486	WS11	AJ2	N	6100.00	6100.00	Y	2015-03-13 00:00:00.000	332197	YY	2015-03-10 00:00:00	158955	 	NULL	NULL	NULL
70918	1	2015-03-09 15:01:00	n319	2015-03-10 00:00:00	N	P	15030086	GS15000558	26829	_	T	11997	n1486	FC1	AL1	N	2000.00	2000.00	Y	2015-03-13 00:00:00.000	332198	YY	2015-03-10 00:00:00	158958	 	NULL	NULL	NULL
70919	1	2015-03-09 15:02:00	n319	2015-03-10 00:00:00	N	P	15030077	GS15000559	26829	_	T	11997	n1486	WS11	AJ2	N	6100.00	6100.00	Y	2015-03-13 00:00:00.000	332199	YY	2015-03-10 00:00:00	158959	 	NULL	NULL	NULL
70920	1	2015-03-09 15:10:00	n319	2015-03-10 00:00:00	N	P	15030093	GS15000561	28268	_	T	3834	n113	WA3	AN5	D	1000.00	1000.00	Y	2015-03-13 00:00:00.000	332200	YY	2015-03-10 00:00:00	158962	 	NULL	NULL	NULL
70921	1	2015-03-09 00:00:00	n029	2015-03-10 00:00:00	N	T	15030077	GS00034114	65258	_	T	15693	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-03-13 00:00:00.000	332211	YY	2015-03-10 00:00:00	116438	 	NULL	NULL	NULL
70922	1	2015-03-09 00:00:00	n029	2015-03-10 00:00:00	N	T	15030063	GS00034117	52682	_	T	12076	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-03-13 00:00:00.000	332212	YY	2015-03-10 00:00:00	116441	 	NULL	NULL	NULL
70923	1	2015-03-09 00:00:00	n029	2015-03-10 00:00:00	N	T	15030064	GS00034118	52684	_	T	12076	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-03-13 00:00:00.000	332213	YY	2015-03-10 00:00:00	116442	 	NULL	NULL	NULL
70924	1	2015-03-09 00:00:00	n029	2015-03-10 00:00:00	N	T	15030085	GS00034119	52095	_	T	5364	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-03-13 00:00:00.000	332214	YY	2015-03-10 00:00:00	116447	 	NULL	NULL	NULL
70925	1	2015-03-09 00:00:00	n029	2015-03-10 00:00:00	N	T	15030070	GS00034120	52030	_	T	12876	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-03-13 00:00:00.000	332215	YY	2015-03-10 00:00:00	116448	 	NULL	NULL	NULL
70926	1	2015-03-09 00:00:00	n029	2015-03-10 00:00:00	N	T	15030071	GS00034121	54221	_	T	13308	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-03-13 00:00:00.000	332216	YY	2015-03-10 00:00:00	116449	 	NULL	NULL	NULL
70927	1	2015-03-09 00:00:00	n029	2015-03-10 00:00:00	N	T	15030072	GS00034122	54222	_	T	13308	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-03-13 00:00:00.000	332217	YY	2015-03-10 00:00:00	116450	 	NULL	NULL	NULL
70928	1	2015-03-09 00:00:00	n029	2015-03-10 00:00:00	N	T	15030073	GS00034123	54218	_	T	13308	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-03-13 00:00:00.000	332218	YY	2015-03-10 00:00:00	116451	 	NULL	NULL	NULL
70929	1	2015-03-09 00:00:00	n029	2015-03-10 00:00:00	N	T	15030074	GS00034124	54219	_	T	13308	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-03-13 00:00:00.000	332219	YY	2015-03-10 00:00:00	116452	 	NULL	NULL	NULL
70930	1	2015-03-09 00:00:00	n029	2015-03-10 00:00:00	N	T	15030075	GS00034125	54220	_	T	13308	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-03-13 00:00:00.000	332220	YY	2015-03-10 00:00:00	116453	 	NULL	NULL	NULL
70931	1	2015-03-09 00:00:00	n029	2015-03-10 00:00:00	N	T	15030076	GS00034126	54223	_	T	13308	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-03-13 00:00:00.000	332221	YY	2015-03-10 00:00:00	116454	 	NULL	NULL	NULL
70932	1	2015-03-09 17:06:00	n319	2015-03-10 00:00:00	N	P	14110297	GS15000562	28171	_	T	15875	n1125	IG1E	AA2	N	10500.00	10500.00	Y	2015-03-13 00:00:00.000	332201	YY	2015-03-10 00:00:00	158977	 	NULL	NULL	NULL
70933	1	2015-03-10 00:00:00	n029	2015-03-10 00:00:00	N	T	15030080	GS00034127	66289	_	T	13403	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-03-13 00:00:00.000	332222	YY	2015-03-10 00:00:00	116458	 	NULL	NULL	NULL
70934	1	2015-03-10 00:00:00	n029	2015-03-10 00:00:00	N	T	15030081	GS00034128	66290	_	T	13403	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-03-13 00:00:00.000	332223	YY	2015-03-10 00:00:00	116459	 	NULL	NULL	NULL
70935	1	2015-03-10 00:00:00	n029	2015-03-10 00:00:00	N	T	15030082	GS00034129	66291	_	T	13403	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-03-13 00:00:00.000	332224	YY	2015-03-10 00:00:00	116460	 	NULL	NULL	NULL
70936	1	2015-03-10 08:40:00	n319	2015-03-10 00:00:00	N	P	15030081	GS15000564	26762	_	T	13067	n896	WA3	AN5	D	1000.00	1000.00	Y	2015-03-13 00:00:00.000	332202	YY	2015-03-10 00:00:00	158979	 	NULL	NULL	NULL
70937	1	2015-03-10 08:42:00	n319	2015-03-10 00:00:00	N	P	14110298	GS15000565	28172	_	T	15875	n1125	IG1E	AA2	N	10500.00	10500.00	Y	2015-03-13 00:00:00.000	332203	YY	2015-03-10 00:00:00	158980	 	NULL	NULL	NULL
70938	1	2015-03-10 09:10:00	n319	2015-03-10 00:00:00	N	P	15030116	GS15000567	21564	A	T	12556	n1489	WS21	AK3	N	11400.00	11400.00	Y	2015-03-13 00:00:00.000	332204	YY	2015-03-10 00:00:00	158982	 	NULL	NULL	NULL
70939	1	2015-03-10 09:16:00	n319	2015-03-10 00:00:00	N	P	15010212	GS15000568	28306	_	T	15800	n1489	IG1E	AA2	N	10500.00	18500.00	Y	2015-03-13 00:00:00.000	332205	YY	2015-03-10 00:00:00	158983	 	NULL	NULL	NULL
70940	1	2015-03-10 09:16:00	n319	2015-03-10 00:00:00	N	P	15030112	GS15000568	28306	_	T	15800	n1489	AC2	AA2	N	8000.00	18500.00	Y	2015-03-13 00:00:00.000	332206	YY	2015-03-10 00:00:00	158983	 	NULL	NULL	NULL
70941	1	2015-03-10 09:24:00	n319	2015-03-10 00:00:00	N	P	14110299	GS15000569	28173	_	T	15875	n1125	IG1E	AA2	N	10500.00	20100.00	Y	2015-03-13 00:00:00.000	332207	YY	2015-03-10 00:00:00	158984	 	NULL	NULL	NULL
70942	1	2015-03-10 09:24:00	n319	2015-03-10 00:00:00	N	P	15030117	GS15000569	28173	_	T	15875	n1125	AC2	AA2	N	9600.00	20100.00	Y	2015-03-13 00:00:00.000	332208	YY	2015-03-10 00:00:00	158984	 	NULL	NULL	NULL
70943	1	2015-03-10 09:46:00	n319	2015-03-10 00:00:00	N	P	15030114	GS15000571	18772	_	T	12556	n1489	WS2	AK2	N	8000.00	8000.00	Y	2015-03-13 00:00:00.000	332209	YE	2015-03-10 00:00:00	158986	 	NULL	NULL	NULL
70944	1	2015-03-10 09:46:00	n319	2015-03-10 00:00:00	N	P	15030080	GS15000572	20886	_	T	13824	n650	WS2	AK2	N	5000.00	5000.00	Y	2015-03-13 00:00:00.000	332210	YE	2015-03-10 00:00:00	158987	 	NULL	NULL	NULL
70945	1	2015-03-10 15:28:00	n319	2015-03-11 00:00:00	N	P	15030118	GS15000579	26282	_	T	2853	n100	WS1	AJ1	N	8500.00	8500.00	Y	2015-03-16 00:00:00.000	332239	YY	2015-03-11 00:00:00	159092	 	NULL	NULL	NULL
70946	1	2015-03-10 00:00:00	n029	2015-03-11 00:00:00	N	T	15030092	GS00034130	65400	_	T	15224	n1350	FF0	FF0	N	2500.00	2500.00	Y	2015-03-16 00:00:00.000	332245	YY	2015-03-11 00:00:00	116509	 	NULL	NULL	NULL
70947	1	2015-03-10 00:00:00	n029	2015-03-11 00:00:00	N	T	15030093	GS00034131	65402	_	T	15224	n1350	FF0	FF0	N	2500.00	2500.00	Y	2015-03-16 00:00:00.000	332246	YY	2015-03-11 00:00:00	116510	 	NULL	NULL	NULL
70948	1	2015-03-10 16:42:00	n319	2015-03-11 00:00:00	N	P	15030102	GS15000581	24793	_	T	12000	n1304	WS11	AJ2	N	6100.00	6100.00	Y	2015-03-16 00:00:00.000	332240	YY	2015-03-11 00:00:00	159109	 	NULL	NULL	NULL
70949	1	2015-03-10 16:44:00	n319	2015-03-11 00:00:00	N	P	14120173	GS15000582	27685	_	T	13961	n1304	FC2	AM2	N	2000.00	2000.00	Y	2015-03-16 00:00:00.000	332241	YY	2015-03-11 00:00:00	159110	 	NULL	NULL	NULL
70950	1	2015-03-11 08:49:00	n319	2015-03-11 00:00:00	N	P	15010287	GS15000586	28324	_	T	12548	n896	UG1	AA3	N	3000.00	3000.00	Y	2015-03-16 00:00:00.000	332242	YY	2015-03-11 00:00:00	159114	 	NULL	NULL	NULL
70951	1	2015-03-11 00:00:00	n029	2015-03-11 00:00:00	N	T	15030090	GS00034134	66294	_	T	4785	n646	FE11	FE11	N	2700.00	2700.00	Y	2015-03-16 00:00:00.000	332247	YE	2015-03-11 00:00:00	116518	 	NULL	NULL	NULL
70952	1	2015-03-11 00:00:00	n029	2015-03-11 00:00:00	N	T	15030091	GS00034135	66295	_	T	4785	n646	FE11	FE11	N	2700.00	2700.00	Y	2015-03-16 00:00:00.000	332248	YE	2015-03-11 00:00:00	116519	 	NULL	NULL	NULL
70953	1	2015-03-11 10:51:00	n319	2015-03-11 00:00:00	N	P	15020167	GS15000587	28361	_	T	13472	n1304	IG1B	AA21	N	9700.00	13700.00	Y	2015-03-16 00:00:00.000	332243	YY	2015-03-11 00:00:00	159126	 	NULL	NULL	NULL
70954	1	2015-03-11 10:51:00	n319	2015-03-11 00:00:00	N	P	15030128	GS15000587	28361	_	T	13472	n1304	AC2	AA21	N	4000.00	13700.00	Y	2015-03-16 00:00:00.000	332244	YY	2015-03-11 00:00:00	159126	 	NULL	NULL	NULL
70955	1	2015-03-11 15:22:00	n319	2015-03-12 00:00:00	N	P	14060009	GS15000594	27718	_	T	13910	n1304	UG1	AA3	N	3000.00	3000.00	Y	2015-03-16 00:00:00.000	332249	YY	2015-03-12 00:00:00	159194	 	NULL	NULL	NULL
70956	1	2015-03-11 00:00:00	n029	2015-03-12 00:00:00	N	T	15030097	GS00034136	66296	_	T	15943	n1350	FT1	FT1	N	2000.00	2000.00	Y	2015-03-16 00:00:00.000	332254	YY	2015-03-12 00:00:00	116572	 	NULL	NULL	NULL
70957	1	2015-03-11 00:00:00	n029	2015-03-12 00:00:00	N	T	15030100	GS00034137	66297	_	T	6316	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-03-16 00:00:00.000	332255	YE	2015-03-12 00:00:00	116573	 	NULL	NULL	NULL
70958	1	2015-03-11 00:00:00	n029	2015-03-12 00:00:00	N	T	15030101	GS00034138	66298	_	T	6316	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-03-16 00:00:00.000	332256	YE	2015-03-12 00:00:00	116574	 	NULL	NULL	NULL
70959	1	2015-03-12 08:43:00	n319	2015-03-12 00:00:00	N	P	15030097	GS15000596	1148	M	T	15318	n113	WS11	AJ2	X	2700.00	2700.00	Y	2015-03-16 00:00:00.000	332250	YY	2015-03-12 00:00:00	159235	 	NULL	NULL	NULL
70960	1	2015-03-12 08:44:00	n319	2015-03-12 00:00:00	N	P	15030122	GS15000597	23385	_	T	14338	n113	WS21	AK3	N	2800.00	2800.00	Y	2015-03-16 00:00:00.000	332251	YY	2015-03-12 00:00:00	159236	 	NULL	NULL	NULL
70961	1	2015-03-12 08:49:00	n319	2015-03-12 00:00:00	N	P	15030029	GS15000600	28382	_	T	15941	n1304	IG1E	AA2	N	10500.00	10500.00	Y	2015-03-16 00:00:00.000	332252	YY	2015-03-12 00:00:00	159239	 	NULL	NULL	NULL
70962	1	2015-03-12 09:37:00	n319	2015-03-12 00:00:00	N	P	15010042	GS15000602	28273	_	T	5093	n1065	UG1	AA3	N	3000.00	3000.00	Y	2015-03-16 00:00:00.000	332253	YY	2015-03-12 00:00:00	159243	 	NULL	NULL	NULL
70963	1	2015-03-12 15:52:00	n319	2015-03-13 00:00:00	N	P	15030134	GS15000603	22162	_	T	13271	n113	WS21	AK3	N	800.00	800.00	Y	2015-03-18 00:00:00.000	332926	YY	2015-03-13 00:00:00	159343	 	NULL	NULL	NULL
70964	1	2015-03-12 00:00:00	k1416	2015-03-12 00:00:00	N	T	15020267	BGS0004841	66245	_	T	15389	n1384	FB2	FB2	N	2500.00	2500.00	Y	2015-03-18 00:00:00.000	332931	YY	2015-03-13 00:00:00	116629	 	NULL	NULL	NULL
70965	1	2015-03-12 00:00:00	n029	2015-03-13 00:00:00	N	T	15030110	GS00034139	65546	_	T	15777	n646	FL1	FL1	N	2000.00	2000.00	Y	2015-03-18 00:00:00.000	332932	YY	2015-03-13 00:00:00	116646	 	NULL	NULL	NULL
70966	1	2015-03-12 00:00:00	n029	2015-03-13 00:00:00	N	T	15030111	GS00034140	65547	_	T	15777	n646	FL1	FL1	N	2000.00	2000.00	Y	2015-03-18 00:00:00.000	332933	YY	2015-03-13 00:00:00	116647	 	NULL	NULL	NULL
70967	1	2015-03-12 17:29:00	n319	2015-03-13 00:00:00	N	P	15030150	GS15000604	27964	_	T	15867	n1489	WS11	AJ2	N	6100.00	6100.00	Y	2015-03-18 00:00:00.000	332927	YY	2015-03-13 00:00:00	159349	 	NULL	NULL	NULL
70968	1	2015-03-13 00:00:00	n029	2015-03-13 00:00:00	N	T	15030113	GS00034147	66299	_	T	14205	n646	FE1	FE1	N	5100.00	5100.00	Y	2015-03-18 00:00:00.000	332934	YE	2015-03-13 00:00:00	116654	 	NULL	NULL	NULL
70969	1	2015-03-13 08:46:00	n319	2015-03-13 00:00:00	N	P	14080027	GS15000607	27889	_	T	15587	n1125	UG1	AA3	N	3000.00	3000.00	Y	2015-03-18 00:00:00.000	332928	YY	2015-03-13 00:00:00	159352	 	NULL	NULL	NULL
70970	1	2015-03-13 08:53:00	n319	2015-03-13 00:00:00	N	P	15010173	GS15000610	28295	_	T	13042	n650	IG1B	AA21	N	9700.00	9700.00	Y	2015-03-18 00:00:00.000	332929	YY	2015-03-13 00:00:00	159355	 	NULL	NULL	NULL
70971	1	2015-03-13 09:38:00	n319	2015-03-13 00:00:00	N	P	15030149	GS15000612	21886	_	T	13362	n994	WS2	AK2	N	24000.00	24000.00	Y	2015-03-18 00:00:00.000	332930	YE	2015-03-13 00:00:00	159357	 	NULL	NULL	NULL
70972	1	2015-03-13 15:01:00	n319	2015-03-16 00:00:00	N	P	15030153	GS15000613	25723	_	T	14793	n896	WS21	AK3	N	8400.00	8400.00	Y	2015-03-19 00:00:00.000	332938	YY	2015-03-16 00:00:00	159452	 	NULL	NULL	NULL
70973	1	2015-03-13 00:00:00	n029	2015-03-16 00:00:00	N	T	15030130	GS00034150	66300	_	T	7759	n547	FE1	FE1	N	5400.00	5400.00	Y	2015-03-19 00:00:00.000	332941	YE	2015-03-16 00:00:00	116704	 	NULL	NULL	NULL
70974	1	2015-03-13 00:00:00	n029	2015-03-16 00:00:00	N	T	15020084	GS00034151	66158	_	T	2560	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-03-19 00:00:00.000	332942	YY	2015-03-16 00:00:00	116705	 	NULL	NULL	NULL
70975	1	2015-03-13 17:07:00	n319	2015-03-16 00:00:00	N	P	15030161	GS15000614	21168	_	T	13144	n650	WS21	AK3	N	3800.00	3800.00	Y	2015-03-19 00:00:00.000	332939	YY	2015-03-16 00:00:00	159466	 	NULL	NULL	NULL
70976	1	2015-03-16 08:48:00	n319	2015-03-16 00:00:00	N	P	15030155	GS15000616	27429	_	T	15612	n994	WS1	AJ1	N	8500.00	8500.00	Y	2015-03-19 00:00:00.000	332940	YY	2015-03-16 00:00:00	159468	 	NULL	NULL	NULL
70977	1	2015-03-17 00:00:00	n029	2015-03-17 00:00:00	N	T	15030131	GS00034154	52483	_	T	12967	n646	FR1	FR1	N	4000.00	4000.00	Y	2015-03-19 00:00:00.000	332954	YY	2015-03-17 00:00:00	116756	 	NULL	NULL	NULL
70978	1	2015-03-17 00:00:00	n029	2015-03-17 00:00:00	N	T	15030135	GS00034155	52692	_	T	12033	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-03-19 00:00:00.000	332955	YY	2015-03-17 00:00:00	116757	 	NULL	NULL	NULL
70979	1	2015-03-17 00:00:00	n029	2015-03-17 00:00:00	N	T	15030133	GS00034156	64697	_	T	12033	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-03-19 00:00:00.000	332956	YY	2015-03-17 00:00:00	116758	 	NULL	NULL	NULL
70980	1	2015-03-17 08:56:00	n319	2015-03-17 00:00:00	N	P	14120188	GS15000621	28215	_	T	15877	n994	IG1B	AA21	N	9700.00	9700.00	Y	2015-03-19 00:00:00.000	332943	YY	2015-03-17 00:00:00	159545	 	NULL	NULL	NULL
70981	1	2015-03-17 09:02:00	n319	2015-03-17 00:00:00	N	P	15020027	GS15000622	28340	_	T	3570	n1489	DG1	AA4	N	3000.00	3000.00	N	NULL	0	XX	2015-03-17 00:00:00	159546	 	NULL	NULL	NULL
70982	1	2015-03-17 09:13:00	n319	2015-03-17 00:00:00	N	P	14100163	GS15000623	28071	_	T	4610	n994	IG1B	AA21	N	9700.00	9700.00	Y	2015-03-19 00:00:00.000	332944	YY	2015-03-17 00:00:00	159547	 	NULL	NULL	NULL
70983	1	2015-03-17 09:30:00	n319	2015-03-17 00:00:00	N	P	14120236	GS15000625	28224	_	T	15569	n994	IG1B	AA21	N	9700.00	12100.00	Y	2015-03-19 00:00:00.000	332945	YY	2015-03-17 00:00:00	159549	 	NULL	NULL	NULL
70984	1	2015-03-17 09:30:00	n319	2015-03-17 00:00:00	N	P	15030171	GS15000625	28224	_	T	15569	n994	AC2	AA21	N	2400.00	12100.00	Y	2015-03-19 00:00:00.000	332946	YY	2015-03-17 00:00:00	159549	 	NULL	NULL	NULL
70985	1	2015-03-17 09:35:00	n319	2015-03-17 00:00:00	N	P	15030170	GS15000626	17825	_	T	13549	n896	WS2	AK2	N	16000.00	16000.00	Y	2015-03-19 00:00:00.000	332947	YE	2015-03-17 00:00:00	159550	 	NULL	NULL	NULL
70986	1	2015-03-17 09:35:00	n319	2015-03-17 00:00:00	N	P	15030158	GS15000627	17854	_	T	12406	n650	WS2	AK2	N	16000.00	16000.00	Y	2015-03-19 00:00:00.000	332948	YE	2015-03-17 00:00:00	159551	 	NULL	NULL	NULL
70987	1	2015-03-17 09:35:00	n319	2015-03-17 00:00:00	N	P	15030159	GS15000628	19629	_	T	12853	n650	WS2	AK2	N	8000.00	8000.00	Y	2015-03-19 00:00:00.000	332949	YE	2015-03-17 00:00:00	159552	 	NULL	NULL	NULL
70988	1	2015-03-17 09:35:00	n319	2015-03-17 00:00:00	N	P	15030160	GS15000629	20222	_	T	11392	n650	WS2	AK2	N	16000.00	16000.00	Y	2015-03-19 00:00:00.000	332950	YE	2015-03-17 00:00:00	159553	 	NULL	NULL	NULL
70989	1	2015-03-17 09:35:00	n319	2015-03-17 00:00:00	N	P	15030164	GS15000630	23446	_	T	11976	n1304	WS2	AK2	N	4000.00	4000.00	Y	2015-03-19 00:00:00.000	332951	YE	2015-03-17 00:00:00	159554	 	NULL	NULL	NULL
70990	1	2015-03-17 09:35:00	n319	2015-03-17 00:00:00	N	P	15030165	GS15000631	23448	_	T	11976	n1304	WS2	AK2	N	4000.00	4000.00	Y	2015-03-19 00:00:00.000	332952	YE	2015-03-17 00:00:00	159555	 	NULL	NULL	NULL
70991	1	2015-03-17 09:35:00	n319	2015-03-17 00:00:00	N	P	15030169	GS15000632	25360	_	T	14890	n1304	WS2	AK2	N	8000.00	8000.00	Y	2015-03-19 00:00:00.000	332953	YE	2015-03-17 00:00:00	159556	 	NULL	NULL	NULL
70992	1	2015-03-17 00:00:00	n029	2015-03-18 00:00:00	N	T	15030152	GS00034157	65755	_	T	15823	n646	FF0	FF0	N	2500.00	2500.00	Y	2015-03-19 00:00:00.000	332965	YY	2015-03-18 00:00:00	116831	 	NULL	NULL	NULL
70993	1	2015-03-17 00:00:00	n029	2015-03-18 00:00:00	N	T	15030145	GS00034158	65660	_	T	15755	n1350	FF0	FF0	N	2500.00	2500.00	Y	2015-03-19 00:00:00.000	332966	YY	2015-03-18 00:00:00	116835	 	NULL	NULL	NULL
70994	1	2015-03-17 00:00:00	n029	2015-03-18 00:00:00	N	T	15030144	GS00034159	65659	_	T	15755	n1350	FF0	FF0	N	2500.00	2500.00	Y	2015-03-19 00:00:00.000	332967	YY	2015-03-18 00:00:00	116839	 	NULL	NULL	NULL
70995	1	2015-03-17 00:00:00	n029	2015-03-18 00:00:00	N	T	15030143	GS00034160	65658	_	T	15755	n1350	FF0	FF0	N	2500.00	2500.00	Y	2015-03-19 00:00:00.000	332968	YY	2015-03-18 00:00:00	116842	 	NULL	NULL	NULL
70996	1	2015-03-17 00:00:00	n029	2015-03-18 00:00:00	N	T	15030150	GS00034161	65759	_	T	13770	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-03-19 00:00:00.000	332969	YY	2015-03-18 00:00:00	116843	 	NULL	NULL	NULL
70997	1	2015-03-17 00:00:00	n029	2015-03-18 00:00:00	N	T	15030151	GS00034162	65761	_	T	13770	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-03-19 00:00:00.000	332970	YY	2015-03-18 00:00:00	116844	 	NULL	NULL	NULL
70998	1	2015-03-17 00:00:00	n029	2015-03-18 00:00:00	N	T	15030142	GS00034163	52485	_	T	12966	n646	FR1	FR1	N	4000.00	4000.00	Y	2015-03-19 00:00:00.000	332971	YY	2015-03-18 00:00:00	116845	 	NULL	NULL	NULL
70999	1	2015-03-17 00:00:00	n029	2015-03-18 00:00:00	N	T	15030141	GS00034164	52486	_	T	12966	n646	FR1	FR1	N	4000.00	4000.00	Y	2015-03-19 00:00:00.000	332972	YY	2015-03-18 00:00:00	116846	 	NULL	NULL	NULL
71000	1	2015-03-18 08:31:00	n087	2015-03-18 00:00:00	N	P	15030180	GS15000633	27911	_	T	15295	n1065	WS11	AJ2	N	6100.00	6100.00	Y	2015-03-19 00:00:00.000	332957	YY	2015-03-18 00:00:00	159673	 	NULL	NULL	NULL
71001	1	2015-03-18 08:36:00	n087	2015-03-18 00:00:00	N	P	15030044	GS15000634	24775	_	T	14681	n1489	FR1	AB1	N	7000.00	24600.00	Y	2015-03-19 00:00:00.000	332958	YY	2015-03-18 00:00:00	159674	 	NULL	NULL	NULL
71002	1	2015-03-18 08:36:00	n087	2015-03-18 00:00:00	N	P	15030179	GS15000634	24775	_	T	14681	n1489	FR12	AB1	N	17600.00	24600.00	Y	2015-03-19 00:00:00.000	332959	YY	2015-03-18 00:00:00	159674	 	NULL	NULL	NULL
71003	1	2015-03-18 08:40:00	n087	2015-03-18 00:00:00	N	P	15030174	GS15000635	27796	_	T	15610	n994	WS1	AJ1	N	8500.00	8500.00	Y	2015-03-19 00:00:00.000	332960	YY	2015-03-18 00:00:00	159675	 	NULL	NULL	NULL
71004	1	2015-03-18 00:00:00	n029	2015-03-18 00:00:00	N	T	15030140	GS00034165	66303	_	T	2507	n530	FE1	FE1	N	2400.00	2400.00	Y	2015-03-19 00:00:00.000	332973	YE	2015-03-18 00:00:00	116850	 	NULL	NULL	NULL
71005	1	2015-03-18 00:00:00	n029	2015-03-18 00:00:00	N	T	15030162	GS00034166	66304	_	T	15950	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-03-19 00:00:00.000	332974	YE	2015-03-18 00:00:00	116851	 	NULL	NULL	NULL
71006	1	2015-03-18 00:00:00	n029	2015-03-18 00:00:00	N	T	15030163	GS00034167	66305	_	T	15950	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-03-19 00:00:00.000	332975	YE	2015-03-18 00:00:00	116852	 	NULL	NULL	NULL
71007	1	2015-03-18 09:14:00	n087	2015-03-18 00:00:00	N	P	14120391	GS15000637	28263	_	T	14032	n994	UG1	AA3	N	3000.00	3000.00	Y	2015-03-19 00:00:00.000	332961	YY	2015-03-18 00:00:00	159677	 	NULL	NULL	NULL
71008	1	2015-03-18 09:22:00	n087	2015-03-18 00:00:00	N	P	14120277	GS15000640	28234	_	T	10747	n1065	UG1	AA3	N	3000.00	3000.00	Y	2015-03-19 00:00:00.000	332962	YY	2015-03-18 00:00:00	159680	 	NULL	NULL	NULL
71009	1	2015-03-18 09:32:00	n087	2015-03-18 00:00:00	N	P	14120390	GS15000641	28262	_	T	14032	n994	IG1B	AA21	N	9700.00	12100.00	Y	2015-03-19 00:00:00.000	332963	YY	2015-03-18 00:00:00	159681	 	NULL	NULL	NULL
71010	1	2015-03-18 09:32:00	n087	2015-03-18 00:00:00	N	P	15030192	GS15000641	28262	_	T	14032	n994	AC2	AA21	N	2400.00	12100.00	Y	2015-03-19 00:00:00.000	332964	YY	2015-03-18 00:00:00	159681	 	NULL	NULL	NULL
71011	1	2015-03-18 16:46:00	n087	2015-03-19 00:00:00	N	P	15030197	GS15000642	27957	_	T	13868	n1065	WS11	AJ2	N	6100.00	6100.00	Y	2015-03-24 00:00:00.000	333082	YY	2015-03-19 00:00:00	159759	 	NULL	NULL	NULL
71012	1	2015-03-18 16:48:00	n087	2015-03-19 00:00:00	N	P	15030193	GS15000643	28162	_	T	15519	n1065	WS11	AJ2	N	17500.00	17500.00	Y	2015-03-24 00:00:00.000	333083	YY	2015-03-19 00:00:00	159760	 	NULL	NULL	NULL
71013	1	2015-03-18 00:00:00	n029	2015-03-19 00:00:00	N	T	15030155	GS00034168	64632	_	T	1705	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-03-24 00:00:00.000	333101	YY	2015-03-19 00:00:00	116886	 	NULL	NULL	NULL
71014	1	2015-03-18 00:00:00	n029	2015-03-19 00:00:00	N	T	15030146	GS00034169	52362	_	T	12884	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-03-24 00:00:00.000	333102	YY	2015-03-19 00:00:00	116887	 	NULL	NULL	NULL
71015	1	2015-03-19 00:00:00	n029	2015-03-19 00:00:00	N	T	15030160	GS00034170	65753	_	T	2157	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-03-24 00:00:00.000	333103	YY	2015-03-19 00:00:00	116892	 	NULL	NULL	NULL
71016	1	2015-03-19 00:00:00	n029	2015-03-19 00:00:00	N	T	15030161	GS00034171	65754	_	T	2157	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-03-24 00:00:00.000	333104	YY	2015-03-19 00:00:00	116893	 	NULL	NULL	NULL
71017	1	2015-03-19 00:00:00	n029	2015-03-19 00:00:00	N	T	15030156	GS00034172	65810	_	T	13211	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-03-24 00:00:00.000	333105	YY	2015-03-19 00:00:00	116894	 	NULL	NULL	NULL
71018	1	2015-03-19 00:00:00	n029	2015-03-19 00:00:00	N	T	15030157	GS00034173	65811	_	T	13211	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-03-24 00:00:00.000	333106	YY	2015-03-19 00:00:00	116895	 	NULL	NULL	NULL
71019	1	2015-03-19 00:00:00	n029	2015-03-19 00:00:00	N	T	15030158	GS00034174	65812	_	T	13211	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-03-24 00:00:00.000	333107	YY	2015-03-19 00:00:00	116896	 	NULL	NULL	NULL
71020	1	2015-03-19 00:00:00	n029	2015-03-19 00:00:00	N	T	15030159	GS00034175	65813	_	T	13211	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-03-24 00:00:00.000	333108	YY	2015-03-19 00:00:00	116897	 	NULL	NULL	NULL
71021	1	2015-03-19 00:00:00	n029	2015-03-19 00:00:00	N	T	15030154	GS00034176	53922	_	T	13090	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-03-24 00:00:00.000	333109	YY	2015-03-19 00:00:00	116898	 	NULL	NULL	NULL
71022	1	2015-03-19 00:00:00	n029	2015-03-19 00:00:00	N	T	15030153	GS00034177	53923	_	T	13090	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-03-24 00:00:00.000	333110	YY	2015-03-19 00:00:00	116899	 	NULL	NULL	NULL
71023	1	2015-03-19 08:50:00	n319	2015-03-19 00:00:00	N	P	15030183	GS15000647	23990	_	T	14564	n1486	FC2	AM2	N	2000.00	2000.00	Y	2015-03-24 00:00:00.000	333084	YY	2015-03-19 00:00:00	159764	 	NULL	NULL	NULL
71024	1	2015-03-19 08:51:00	n319	2015-03-19 00:00:00	N	P	15030184	GS15000648	25790	_	T	14564	n1486	FC2	AM2	N	2000.00	2000.00	Y	2015-03-24 00:00:00.000	333085	YY	2015-03-19 00:00:00	159765	 	NULL	NULL	NULL
71025	1	2015-03-19 08:53:00	n319	2015-03-19 00:00:00	N	P	15030185	GS15000649	25791	_	T	14564	n1486	FC2	AM2	N	2000.00	2000.00	Y	2015-03-24 00:00:00.000	333086	YY	2015-03-19 00:00:00	159766	 	NULL	NULL	NULL
71026	1	2015-03-19 08:54:00	n319	2015-03-19 00:00:00	N	P	15030186	GS15000650	25792	_	T	14564	n1486	FC2	AM2	N	2000.00	2000.00	Y	2015-03-24 00:00:00.000	333087	YY	2015-03-19 00:00:00	159767	 	NULL	NULL	NULL
71027	1	2015-03-19 08:55:00	n319	2015-03-19 00:00:00	N	P	15030188	GS15000651	25926	_	T	14564	n1486	FC2	AM2	N	2000.00	2000.00	Y	2015-03-24 00:00:00.000	333088	YY	2015-03-19 00:00:00	159768	 	NULL	NULL	NULL
71028	1	2015-03-19 08:56:00	n319	2015-03-19 00:00:00	N	P	15030187	GS15000652	26087	_	T	14564	n1486	FC2	AM2	N	2000.00	2000.00	Y	2015-03-24 00:00:00.000	333089	YY	2015-03-19 00:00:00	159769	 	NULL	NULL	NULL
71029	1	2015-03-19 08:58:00	n319	2015-03-19 00:00:00	N	P	15020138	GS15000653	26042	_	T	15096	n113	FR1	AB1	N	10200.00	10200.00	Y	2015-03-24 00:00:00.000	333090	YY	2015-03-19 00:00:00	159770	 	NULL	NULL	NULL
71030	1	2015-03-19 09:01:00	n319	2015-03-19 00:00:00	N	P	15030175	GS15000655	27594	_	T	15569	n994	WA3	AN5	D	1000.00	1000.00	Y	2015-03-24 00:00:00.000	333091	YY	2015-03-19 00:00:00	159772	 	NULL	NULL	NULL
71031	1	2015-03-19 09:04:00	n319	2015-03-19 00:00:00	N	P	14070155	GS15000656	27800	_	T	15610	n994	IG1B	AA21	N	9700.00	17700.00	Y	2015-03-24 00:00:00.000	333092	YY	2015-03-19 00:00:00	159773	 	NULL	NULL	NULL
71032	1	2015-03-19 09:04:00	n319	2015-03-19 00:00:00	N	P	15030204	GS15000656	27800	_	T	15610	n994	AC2	AA21	N	8000.00	17700.00	Y	2015-03-24 00:00:00.000	333093	YY	2015-03-19 00:00:00	159773	 	NULL	NULL	NULL
71033	1	2015-03-19 09:05:00	n319	2015-03-19 00:00:00	N	P	14070156	GS15000657	27801	_	T	15610	n994	UG1	AA3	N	3000.00	3000.00	Y	2015-03-24 00:00:00.000	333094	YY	2015-03-19 00:00:00	159774	 	NULL	NULL	NULL
71034	1	2015-03-19 09:29:00	n319	2015-03-19 00:00:00	N	P	15030213	GS15000658	26371	_	T	15212	n1065	WS11	AJ2	N	2700.00	2700.00	Y	2015-03-24 00:00:00.000	333095	YY	2015-03-19 00:00:00	159783	 	NULL	NULL	NULL
71035	1	2015-03-19 09:32:00	n319	2015-03-19 00:00:00	N	P	14120315	GS15000660	28243	_	T	15609	n1065	UG1	AA3	N	3000.00	3000.00	Y	2015-03-24 00:00:00.000	333096	YY	2015-03-19 00:00:00	159787	 	NULL	NULL	NULL
71036	1	2015-03-19 09:34:00	n319	2015-03-19 00:00:00	N	P	15010242	GS15000661	28316	_	T	10747	n1065	IG1E	AA2	N	10500.00	20900.00	Y	2015-03-24 00:00:00.000	333097	YY	2015-03-19 00:00:00	159789	 	NULL	NULL	NULL
71037	1	2015-03-19 09:34:00	n319	2015-03-19 00:00:00	N	P	15030196	GS15000661	28316	_	T	10747	n1065	AC2	AA2	N	10400.00	20900.00	Y	2015-03-24 00:00:00.000	333098	YY	2015-03-19 00:00:00	159789	 	NULL	NULL	NULL
71038	1	2015-03-19 09:36:00	n319	2015-03-19 00:00:00	N	P	15010243	GS15000662	28317	_	T	10747	n1065	UG1	AA3	N	3000.00	3000.00	Y	2015-03-24 00:00:00.000	333099	YY	2015-03-19 00:00:00	159791	 	NULL	NULL	NULL
71039	1	2015-03-19 09:38:00	n319	2015-03-19 00:00:00	N	P	15030014	GS15000663	28381	_	T	10747	n1065	UG1	AA3	N	3000.00	3000.00	Y	2015-03-24 00:00:00.000	333100	YY	2015-03-19 00:00:00	159794	 	NULL	NULL	NULL
71040	1	2015-03-19 15:27:00	n319	2015-03-20 00:00:00	N	P	15030172	GS15000664	27020	_	T	12621	n1304	WA3	AN5	D	1000.00	1000.00	Y	2015-03-25 00:00:00.000	333161	YY	2015-03-20 00:00:00	159881	 	NULL	NULL	NULL
71041	1	2015-03-19 15:30:00	n319	2015-03-20 00:00:00	N	P	15030189	GS15000666	27478	_	T	15631	n1304	WS11	AJ2	N	2700.00	2700.00	Y	2015-03-25 00:00:00.000	333162	YY	2015-03-20 00:00:00	159883	 	NULL	NULL	NULL
71042	1	2015-03-19 16:23:00	n319	2015-03-20 00:00:00	N	P	15030219	GS15000667	27831	_	T	15762	n1489	WA3	AN5	D	1000.00	1000.00	Y	2015-03-25 00:00:00.000	333163	YY	2015-03-20 00:00:00	159891	 	NULL	NULL	NULL
71043	1	2015-03-19 00:00:00	n029	2015-03-20 00:00:00	N	T	15030168	GS00034178	66306	_	T	13403	n530	FE1	FE1	N	2400.00	2400.00	Y	2015-03-25 00:00:00.000	333173	YE	2015-03-20 00:00:00	116961	 	NULL	NULL	NULL
71044	1	2015-03-20 08:49:00	n319	2015-03-20 00:00:00	N	P	15030209	GS15000669	24396	_	T	13708	n896	WS21	AK3	N	2800.00	2800.00	Y	2015-03-25 00:00:00.000	333164	YY	2015-03-20 00:00:00	159893	 	NULL	NULL	NULL
71045	1	2015-03-20 08:56:00	n319	2015-03-20 00:00:00	N	P	15030223	GS15000673	27380	_	T	99999	n994	WA3	AN5	D	2000.00	2000.00	Y	2015-03-25 00:00:00.000	333165	YY	2015-03-20 00:00:00	159897	 	NULL	NULL	NULL
71046	1	2015-03-20 08:58:00	n319	2015-03-20 00:00:00	N	P	15010214	GS15000674	28302	_	T	15865	n896	IG1E	AA2	N	10500.00	10500.00	Y	2015-03-25 00:00:00.000	333166	YY	2015-03-20 00:00:00	159898	 	NULL	NULL	NULL
71047	1	2015-03-20 09:00:00	n319	2015-03-20 00:00:00	N	P	15010217	GS15000675	28303	_	T	15865	n896	IG1E	AA2	N	10500.00	10500.00	Y	2015-03-25 00:00:00.000	333167	YY	2015-03-20 00:00:00	159899	 	NULL	NULL	NULL
71048	1	2015-03-20 09:01:00	n319	2015-03-20 00:00:00	N	P	15030221	GS15000676	28350	_	T	15937	n1486	WA3	AN5	D	2000.00	2000.00	Y	2015-03-25 00:00:00.000	333168	YY	2015-03-20 00:00:00	159900	 	NULL	NULL	NULL
71049	1	2015-03-20 09:43:00	n319	2015-03-20 00:00:00	N	P	15030224	GS15000677	1035	M	T	12222	n113	WS2	AK2	X	3000.00	3000.00	Y	2015-03-25 00:00:00.000	333169	YE	2015-03-20 00:00:00	159908	 	NULL	NULL	NULL
71050	1	2015-03-20 09:43:00	n319	2015-03-20 00:00:00	N	P	15030225	GS15000678	1036	M	T	12222	n113	WS2	AK2	X	3000.00	3000.00	Y	2015-03-25 00:00:00.000	333170	YE	2015-03-20 00:00:00	159909	 	NULL	NULL	NULL
71051	1	2015-03-20 09:43:00	n319	2015-03-20 00:00:00	N	P	15030226	GS15000679	1038	M	T	12222	n113	WS2	AK2	X	3000.00	3000.00	Y	2015-03-25 00:00:00.000	333171	YE	2015-03-20 00:00:00	159910	 	NULL	NULL	NULL
71052	1	2015-03-20 00:00:00	n029	2015-03-23 00:00:00	N	T	15030174	GS00034182	65616	_	T	15600	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-03-25 00:00:00.000	333187	YY	2015-03-23 00:00:00	116987	 	NULL	NULL	NULL
71053	1	2015-03-20 00:00:00	n029	2015-03-23 00:00:00	N	T	15030175	GS00034183	65617	_	T	15600	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-03-25 00:00:00.000	333188	YY	2015-03-23 00:00:00	116988	 	NULL	NULL	NULL
71054	1	2015-03-20 14:12:00	n319	2015-03-20 00:00:00	N	P	15030249	GS15000683	28413	_	T	10747	n1065	IG1E	AA2	N	10500.00	10500.00	Y	2015-03-25 00:00:00.000	333172	YY	2015-03-20 00:00:00	159980	 	NULL	NULL	NULL
71055	1	2015-03-20 16:02:00	n319	2015-03-23 00:00:00	N	P	15030231	GS15000684	27769	_	T	15748	n1125	WA3	AN5	D	1000.00	1000.00	Y	2015-03-25 00:00:00.000	333174	YY	2015-03-23 00:00:00	160020	 	NULL	NULL	NULL
71056	1	2015-03-20 16:03:00	n319	2015-03-23 00:00:00	N	P	15030232	GS15000685	27770	_	T	15748	n1125	WA3	AN5	D	1000.00	1000.00	Y	2015-03-25 00:00:00.000	333175	YY	2015-03-23 00:00:00	160022	 	NULL	NULL	NULL
71057	1	2015-03-20 16:04:00	n319	2015-03-23 00:00:00	N	P	15030218	GS15000686	27889	_	T	15587	n1125	WA3	AN5	D	2000.00	2000.00	Y	2015-03-25 00:00:00.000	333176	YY	2015-03-23 00:00:00	160023	 	NULL	NULL	NULL
71058	1	2015-03-20 16:06:00	n319	2015-03-23 00:00:00	N	P	15030245	GS15000687	28075	_	T	7683	n650	WS1	AJ1	N	3500.00	3500.00	Y	2015-03-25 00:00:00.000	333177	YY	2015-03-23 00:00:00	160024	 	NULL	NULL	NULL
71059	1	2015-03-20 16:07:00	n319	2015-03-23 00:00:00	N	P	15030246	GS15000688	28135	_	T	7683	n650	WS1	AJ1	N	3500.00	3500.00	Y	2015-03-25 00:00:00.000	333178	YY	2015-03-23 00:00:00	160025	 	NULL	NULL	NULL
71060	1	2015-03-20 16:08:00	n319	2015-03-23 00:00:00	N	P	15030243	GS15000689	28204	_	T	12406	n650	WA3	AN5	D	1000.00	1000.00	Y	2015-03-25 00:00:00.000	333179	YY	2015-03-23 00:00:00	160028	 	NULL	NULL	NULL
71061	1	2015-03-20 17:24:00	n319	2015-03-23 00:00:00	N	P	14120140	GS15000690	28209	_	T	10747	n1065	UG1	AA3	N	3000.00	3000.00	Y	2015-03-25 00:00:00.000	333180	YY	2015-03-23 00:00:00	160031	 	NULL	NULL	NULL
71062	1	2015-03-20 17:26:00	n319	2015-03-23 00:00:00	N	P	15010210	GS15000691	28305	_	T	10747	n1065	IG1E	AA2	N	10500.00	12100.00	Y	2015-03-25 00:00:00.000	333181	YY	2015-03-23 00:00:00	160032	 	NULL	NULL	NULL
71063	1	2015-03-20 17:26:00	n319	2015-03-23 00:00:00	N	P	15030233	GS15000691	28305	_	T	10747	n1065	AC2	AA2	N	1600.00	12100.00	Y	2015-03-25 00:00:00.000	333182	YY	2015-03-23 00:00:00	160032	 	NULL	NULL	NULL
71065	1	2015-03-20 17:30:00	n319	2015-03-23 00:00:00	N	P	15030182	GS15000692	28236	_	T	10747	n1065	AC2	AA2	N	800.00	800.00	Y	2015-03-25 00:00:00.000	333183	YY	2015-03-23 00:00:00	160033	 	NULL	NULL	NULL
71066	1	2015-03-23 08:46:00	n319	2015-03-23 00:00:00	N	P	14100360	GS15000696	28108	_	T	15632	n896	IG1E	AA2	N	10500.00	10500.00	Y	2015-03-25 00:00:00.000	333184	YY	2015-03-23 00:00:00	160038	 	NULL	NULL	NULL
71067	1	2015-03-23 08:47:00	n319	2015-03-23 00:00:00	N	P	14100361	GS15000697	28109	_	T	15632	n896	UG1	AA3	N	3000.00	3000.00	Y	2015-03-25 00:00:00.000	333185	YY	2015-03-23 00:00:00	160039	 	NULL	NULL	NULL
71068	1	2015-03-23 09:28:00	n319	2015-03-23 00:00:00	N	P	15030274	GS15000699	28276	_	T	7683	n650	WS1	AJ1	N	3500.00	3500.00	Y	2015-03-25 00:00:00.000	333186	YY	2015-03-23 00:00:00	160041	 	NULL	NULL	NULL
71069	1	2015-03-24 00:00:00	n029	2015-03-24 00:00:00	N	T	15030180	GS00034190	65578	_	T	15772	n646	FF0	FF0	N	5000.00	5000.00	Y	2015-03-25 00:00:00.000	333192	YY	2015-03-24 00:00:00	117066	 	NULL	NULL	NULL
71070	1	2015-03-24 00:00:00	n029	2015-03-24 00:00:00	N	T	15030197	GS00034191	65665	_	T	15799	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-03-25 00:00:00.000	333193	YY	2015-03-24 00:00:00	117067	 	NULL	NULL	NULL
71071	1	2015-03-24 00:00:00	n029	2015-03-24 00:00:00	N	T	15030198	GS00034192	65666	_	T	15799	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-03-25 00:00:00.000	333194	YY	2015-03-24 00:00:00	117068	 	NULL	NULL	NULL
71072	1	2015-03-24 00:00:00	n029	2015-03-24 00:00:00	N	T	15030199	GS00034193	65669	_	T	15799	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-03-25 00:00:00.000	333195	YY	2015-03-24 00:00:00	117069	 	NULL	NULL	NULL
71073	1	2015-03-24 00:00:00	n029	2015-03-24 00:00:00	N	T	15030200	GS00034194	65670	_	T	15799	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-03-25 00:00:00.000	333196	YY	2015-03-24 00:00:00	117070	 	NULL	NULL	NULL
71074	1	2015-03-24 00:00:00	n029	2015-03-24 00:00:00	N	T	15030201	GS00034195	65677	_	T	15799	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-03-25 00:00:00.000	333197	YY	2015-03-24 00:00:00	117071	 	NULL	NULL	NULL
71075	1	2015-03-24 00:00:00	n029	2015-03-24 00:00:00	N	T	15030202	GS00034196	65678	_	T	15799	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-03-25 00:00:00.000	333198	YY	2015-03-24 00:00:00	117072	 	NULL	NULL	NULL
71076	1	2015-03-24 00:00:00	n029	2015-03-24 00:00:00	N	T	15030203	GS00034197	65685	_	T	15799	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-03-25 00:00:00.000	333199	YY	2015-03-24 00:00:00	117073	 	NULL	NULL	NULL
71077	1	2015-03-24 00:00:00	n029	2015-03-24 00:00:00	N	T	15030204	GS00034198	65686	_	T	15799	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-03-25 00:00:00.000	333200	YY	2015-03-24 00:00:00	117074	 	NULL	NULL	NULL
71078	1	2015-03-24 00:00:00	n029	2015-03-24 00:00:00	N	T	15030181	GS00034200	66307	_	T	4623	n530	FE1	FE1	N	2400.00	2400.00	Y	2015-03-25 00:00:00.000	333201	YE	2015-03-24 00:00:00	117076	 	NULL	NULL	NULL
71079	1	2015-03-24 00:00:00	n029	2015-03-24 00:00:00	N	T	15030182	GS00034201	66308	_	T	15947	n646	FE11	FE11	N	2700.00	2700.00	Y	2015-03-25 00:00:00.000	333202	YE	2015-03-24 00:00:00	117077	 	NULL	NULL	NULL
71080	1	2015-03-24 09:00:00	n319	2015-03-24 00:00:00	N	P	14120397	GS15000701	28250	_	T	13472	n1304	UG1	AA3	N	3000.00	3000.00	Y	2015-03-25 00:00:00.000	333189	YY	2015-03-24 00:00:00	160125	 	NULL	NULL	NULL
71081	1	2015-03-24 00:00:00	n029	2015-03-24 00:00:00	N	T	15030205	GS00034202	65397	_	T	15691	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-03-25 00:00:00.000	333203	YY	2015-03-24 00:00:00	117080	 	NULL	NULL	NULL
71082	1	2015-03-24 09:23:00	n319	2015-03-24 00:00:00	N	P	15030279	GS15000703	27090	_	T	15501	n1065	WS11	AJ2	N	1000.00	1000.00	Y	2015-03-25 00:00:00.000	333190	YY	2015-03-24 00:00:00	160127	 	NULL	NULL	NULL
71083	1	2015-03-24 09:43:00	n319	2015-03-24 00:00:00	N	P	15030239	GS15000705	22011	_	T	3665	n1304	WS2	AK2	N	8000.00	8000.00	Y	2015-03-25 00:00:00.000	333191	YE	2015-03-24 00:00:00	160129	 	NULL	NULL	NULL
71084	1	2015-03-24 15:25:00	n319	2015-03-25 00:00:00	N	P	15030284	GS15000706	25365	_	T	4837	n1489	WS1	AJ1	N	8500.00	8500.00	Y	2015-03-26 00:00:00.000	333217	YY	2015-03-25 00:00:00	160193	 	NULL	NULL	NULL
71085	1	2015-03-24 15:26:00	n319	2015-03-25 00:00:00	N	P	15030276	GS15000707	27480	_	T	13930	n896	WA3	AN5	D	1000.00	1000.00	Y	2015-03-26 00:00:00.000	333218	YY	2015-03-25 00:00:00	160194	 	NULL	NULL	NULL
71086	1	2015-03-24 15:33:00	n319	2015-03-25 00:00:00	N	P	15020170	GS15000709	28359	_	T	13972	n100	IG1E	AA2	N	10500.00	10500.00	Y	2015-03-26 00:00:00.000	333219	YY	2015-03-25 00:00:00	160196	 	NULL	NULL	NULL
71087	1	2015-03-24 00:00:00	n029	2015-03-25 00:00:00	N	T	15030207	GS00034204	65430	_	T	15695	n441	FF0	FF0	N	12500.00	12500.00	Y	2015-03-26 00:00:00.000	333228	YY	2015-03-25 00:00:00	117141	 	NULL	NULL	NULL
71088	1	2015-03-24 00:00:00	n029	2015-03-25 00:00:00	N	T	15030208	GS00034205	65431	_	T	15695	n441	FF0	FF0	N	12500.00	12500.00	Y	2015-03-26 00:00:00.000	333229	YY	2015-03-25 00:00:00	117142	 	NULL	NULL	NULL
71089	1	2015-03-24 00:00:00	n029	2015-03-25 00:00:00	N	T	15030212	GS00034208	66309	_	T	12778	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-03-26 00:00:00.000	333230	YE	2015-03-25 00:00:00	117145	 	NULL	NULL	NULL
71090	1	2015-03-25 08:44:00	n319	2015-03-25 00:00:00	N	P	15030288	GS15000712	1095	M	T	12293	n113	WS21	AK3	X	1700.00	1700.00	Y	2015-03-26 00:00:00.000	333220	YY	2015-03-25 00:00:00	160210	 	NULL	NULL	NULL
71091	1	2015-03-25 08:50:00	n319	2015-03-25 00:00:00	N	P	15010254	GS15000715	28319	_	T	13319	n896	UG1	AA3	N	3000.00	3000.00	Y	2015-03-26 00:00:00.000	333221	YY	2015-03-25 00:00:00	160213	 	NULL	NULL	NULL
71092	1	2015-03-25 08:52:00	n319	2015-03-25 00:00:00	N	P	15020053	GS15000716	28345	_	T	13319	n896	UG1	AA3	N	3000.00	3000.00	Y	2015-03-26 00:00:00.000	333222	YY	2015-03-25 00:00:00	160214	 	NULL	NULL	NULL
71093	1	2015-03-25 00:00:00	n029	2015-03-25 00:00:00	N	T	15030183	GS00034209	66310	_	T	15806	n441	FE11	FE11	N	2400.00	2400.00	Y	2015-03-26 00:00:00.000	333231	YE	2015-03-25 00:00:00	117149	 	NULL	NULL	NULL
71094	1	2015-03-25 00:00:00	n029	2015-03-25 00:00:00	N	T	15030215	GS00034210	66311	_	T	15806	n441	FE1	FE1	N	2400.00	2400.00	Y	2015-03-26 00:00:00.000	333232	YE	2015-03-25 00:00:00	117150	 	NULL	NULL	NULL
71095	1	2015-03-25 09:26:00	n319	2015-03-25 00:00:00	N	P	15030278	GS15000717	28255	_	T	14032	n994	WS1	AJ1	N	8500.00	8500.00	Y	2015-03-26 00:00:00.000	333223	YY	2015-03-25 00:00:00	160215	 	NULL	NULL	NULL
71096	1	2015-03-25 09:38:00	n319	2015-03-25 00:00:00	N	P	15030292	GS15000718	27998	_	T	13042	n650	WA3	AN5	D	1000.00	1000.00	Y	2015-03-26 00:00:00.000	333224	YY	2015-03-25 00:00:00	160216	 	NULL	NULL	NULL
71097	1	2015-03-25 09:40:00	n319	2015-03-25 00:00:00	N	P	14120392	GS15000719	28260	_	T	14032	n994	IG1B	AA21	N	9700.00	25700.00	Y	2015-03-26 00:00:00.000	333225	YY	2015-03-25 00:00:00	160217	 	NULL	NULL	NULL
71098	1	2015-03-25 09:40:00	n319	2015-03-25 00:00:00	N	P	15030301	GS15000719	28260	_	T	14032	n994	AC2	AA21	N	16000.00	25700.00	Y	2015-03-26 00:00:00.000	333226	YY	2015-03-25 00:00:00	160217	 	NULL	NULL	NULL
71099	1	2015-03-25 09:41:00	n319	2015-03-25 00:00:00	N	P	14120393	GS15000720	28261	_	T	14032	n994	UG1	AA3	N	3000.00	3000.00	Y	2015-03-26 00:00:00.000	333227	YY	2015-03-25 00:00:00	160218	 	NULL	NULL	NULL
71100	1	2015-03-25 00:00:00	n029	2015-03-26 00:00:00	N	T	15030221	GS00034211	65790	_	T	7683	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-03-27 00:00:00.000	333262	YY	2015-03-26 00:00:00	117188	 	NULL	NULL	NULL
71101	1	2015-03-25 00:00:00	n029	2015-03-26 00:00:00	N	T	15030222	GS00034212	65792	_	T	7683	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-03-27 00:00:00.000	333263	YY	2015-03-26 00:00:00	117189	 	NULL	NULL	NULL
71102	1	2015-03-25 00:00:00	k1416	2015-03-25 00:00:00	N	T	15030136	BGS0004870	66301	_	T	15224	n1350	DR1	DR1	N	7000.00	7000.00	Y	2015-03-27 00:00:00.000	333264	YY	2015-03-26 00:00:00	117192	 	NULL	NULL	NULL
71103	1	2015-03-25 00:00:00	k1416	2015-03-25 00:00:00	N	T	15030137	BGS0004871	66302	_	T	15224	n1350	DR1	DR1	N	7000.00	7000.00	Y	2015-03-27 00:00:00.000	333265	YY	2015-03-26 00:00:00	117193	 	NULL	NULL	NULL
71104	1	2015-03-25 00:00:00	n029	2015-03-26 00:00:00	N	T	15030218	GS00034215	66312	_	T	7576	n646	FA1	FA1	N	12000.00	12000.00	Y	2015-03-27 00:00:00.000	333266	YY	2015-03-26 00:00:00	117195	 	NULL	NULL	NULL
71105	1	2015-03-25 00:00:00	n029	2015-03-26 00:00:00	N	T	15030232	GS00034216	66320	_	T	15349	n824	FE1	FE1	N	2400.00	2400.00	Y	2015-03-27 00:00:00.000	333267	YE	2015-03-26 00:00:00	117196	 	NULL	NULL	NULL
71106	1	2015-03-25 00:00:00	n029	2015-03-26 00:00:00	N	T	15030185	GS00034217	66313	_	T	14970	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-03-27 00:00:00.000	333268	YE	2015-03-26 00:00:00	117197	 	NULL	NULL	NULL
71107	1	2015-03-25 00:00:00	n029	2015-03-26 00:00:00	N	T	15030186	GS00034218	66314	_	T	14970	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-03-27 00:00:00.000	333269	YE	2015-03-26 00:00:00	117198	 	NULL	NULL	NULL
71108	1	2015-03-25 00:00:00	n029	2015-03-26 00:00:00	N	T	15030187	GS00034219	66315	_	T	14970	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-03-27 00:00:00.000	333270	YE	2015-03-26 00:00:00	117199	 	NULL	NULL	NULL
71109	1	2015-03-26 00:00:00	n029	2015-03-26 00:00:00	N	T	15030188	GS00034220	66316	_	T	14970	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-03-27 00:00:00.000	333271	YE	2015-03-26 00:00:00	117218	 	NULL	NULL	NULL
71110	1	2015-03-26 00:00:00	n029	2015-03-26 00:00:00	N	T	15030189	GS00034221	66317	_	T	14970	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-03-27 00:00:00.000	333272	YE	2015-03-26 00:00:00	117219	 	NULL	NULL	NULL
71111	1	2015-03-26 00:00:00	n029	2015-03-26 00:00:00	N	T	15030190	GS00034222	66318	_	T	14970	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-03-27 00:00:00.000	333273	YE	2015-03-26 00:00:00	117220	 	NULL	NULL	NULL
71112	1	2015-03-26 00:00:00	n029	2015-03-26 00:00:00	N	T	15030191	GS00034223	66319	_	T	14970	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-03-27 00:00:00.000	333274	YE	2015-03-26 00:00:00	117221	 	NULL	NULL	NULL
71113	1	2015-03-26 08:51:00	n319	2015-03-26 00:00:00	N	P	15030307	GS15000722	25662	_	T	13042	n650	WS11	AJ2	N	6100.00	6100.00	Y	2015-03-27 00:00:00.000	333243	YY	2015-03-26 00:00:00	160327	 	NULL	NULL	NULL
71114	1	2015-03-26 09:09:00	n319	2015-03-26 00:00:00	N	P	15030315	GS15000725	25160	_	T	10747	n1065	WS1	AJ1	N	8500.00	8500.00	Y	2015-03-27 00:00:00.000	333244	YY	2015-03-26 00:00:00	160330	 	NULL	NULL	NULL
71115	1	2015-03-26 09:17:00	n319	2015-03-26 00:00:00	N	P	15030309	GS15000729	27917	_	T	15791	n1125	WS11	AJ2	N	2700.00	2700.00	Y	2015-03-27 00:00:00.000	333245	YY	2015-03-26 00:00:00	160335	 	NULL	NULL	NULL
71116	1	2015-03-26 09:18:00	n319	2015-03-26 00:00:00	N	P	14120064	GS15000730	28190	_	T	15890	n1304	UG1	AA3	N	3000.00	3000.00	Y	2015-03-27 00:00:00.000	333246	YY	2015-03-26 00:00:00	160336	 	NULL	NULL	NULL
71117	1	2015-03-26 09:19:00	n319	2015-03-26 00:00:00	N	P	14120065	GS15000731	28191	_	T	15890	n1304	UG1	AA3	N	3000.00	3000.00	Y	2015-03-27 00:00:00.000	333247	YY	2015-03-26 00:00:00	160337	 	NULL	NULL	NULL
71118	1	2015-03-26 09:21:00	n319	2015-03-26 00:00:00	N	P	15010089	GS15000732	28286	_	T	4610	n994	IG1B	AA21	N	9700.00	12100.00	Y	2015-03-27 00:00:00.000	333248	YY	2015-03-26 00:00:00	160338	 	NULL	NULL	NULL
71119	1	2015-03-26 09:21:00	n319	2015-03-26 00:00:00	N	P	15030322	GS15000732	28286	_	T	4610	n994	AC2	AA21	N	2400.00	12100.00	Y	2015-03-27 00:00:00.000	333249	YY	2015-03-26 00:00:00	160338	 	NULL	NULL	NULL
71120	1	2015-03-26 09:23:00	n319	2015-03-26 00:00:00	N	P	15010219	GS15000733	28310	_	T	15915	n113	IG1E	AA2	N	10500.00	13700.00	Y	2015-03-27 00:00:00.000	333250	YY	2015-03-26 00:00:00	160339	 	NULL	NULL	NULL
71121	1	2015-03-26 09:23:00	n319	2015-03-26 00:00:00	N	P	15030310	GS15000733	28310	_	T	15915	n113	AC2	AA2	N	3200.00	13700.00	Y	2015-03-27 00:00:00.000	333251	YY	2015-03-26 00:00:00	160339	 	NULL	NULL	NULL
71122	1	2015-03-26 09:24:00	n319	2015-03-26 00:00:00	N	P	15020043	GS15000734	28343	_	T	11997	n1486	UG1	AA3	N	3000.00	3000.00	Y	2015-03-27 00:00:00.000	333252	YY	2015-03-26 00:00:00	160340	 	NULL	NULL	NULL
71123	1	2015-03-26 09:27:00	n319	2015-03-26 00:00:00	N	P	15020162	GS15000735	28366	_	T	15748	n1125	IG1E	AA2	N	10500.00	10500.00	Y	2015-03-27 00:00:00.000	333253	YY	2015-03-26 00:00:00	160341	 	NULL	NULL	NULL
71124	1	2015-03-26 09:28:00	n319	2015-03-26 00:00:00	N	P	15020163	GS15000736	28367	_	T	15748	n1125	UG1	AA3	N	3000.00	3000.00	Y	2015-03-27 00:00:00.000	333254	YY	2015-03-26 00:00:00	160342	 	NULL	NULL	NULL
71125	1	2015-03-26 09:30:00	n319	2015-03-26 00:00:00	N	P	15030106	GS15000737	28397	_	T	10747	n1065	UG1	AA3	N	3000.00	3000.00	Y	2015-03-27 00:00:00.000	333255	YY	2015-03-26 00:00:00	160343	 	NULL	NULL	NULL
71126	1	2015-03-26 09:32:00	n319	2015-03-26 00:00:00	N	P	15030139	GS15000738	28402	_	T	15945	n1125	UG1	AA3	N	3000.00	3000.00	Y	2015-03-27 00:00:00.000	333256	YY	2015-03-26 00:00:00	160344	 	NULL	NULL	NULL
71127	1	2015-03-26 09:39:00	n319	2015-03-26 00:00:00	N	P	15030303	GS15000739	1009	M	T	12293	n113	WS2	AK2	X	16000.00	16000.00	Y	2015-03-27 00:00:00.000	333257	YE	2015-03-26 00:00:00	160345	 	NULL	NULL	NULL
71128	1	2015-03-26 09:39:00	n319	2015-03-26 00:00:00	N	P	15030304	GS15000740	1085	M	T	12293	n113	WS2	AK2	X	2500.00	2500.00	Y	2015-03-27 00:00:00.000	333258	YE	2015-03-26 00:00:00	160346	 	NULL	NULL	NULL
71129	1	2015-03-26 09:39:00	n319	2015-03-26 00:00:00	N	P	15030314	GS15000741	19777	_	T	3554	n896	WS2	AK2	N	8000.00	8000.00	Y	2015-03-27 00:00:00.000	333259	YE	2015-03-26 00:00:00	160347	 	NULL	NULL	NULL
71130	1	2015-03-26 09:39:00	n319	2015-03-26 00:00:00	N	P	15030313	GS15000742	20339	_	T	3554	n896	WS2	AK2	N	8000.00	8000.00	Y	2015-03-27 00:00:00.000	333260	YE	2015-03-26 00:00:00	160348	 	NULL	NULL	NULL
71131	1	2015-03-26 11:46:00	n319	2015-03-26 00:00:00	N	P	15030212	GS15000743	28412	_	T	15260	n1489	UG1	AA3	N	3000.00	3000.00	Y	2015-03-27 00:00:00.000	333261	YY	2015-03-26 00:00:00	160393	 	NULL	NULL	NULL
71132	1	2015-03-26 00:00:00	n029	2015-03-27 00:00:00	N	T	15030233	GS00034224	66321	_	T	84	n646	FE1	FE1	N	2400.00	2400.00	Y	2015-03-30 00:00:00.000	333382	YE	2015-03-27 00:00:00	117264	 	NULL	NULL	NULL
71133	1	2015-03-26 00:00:00	n029	2015-03-27 00:00:00	N	T	15030304	GS00034225	65878	_	T	11978	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-03-30 00:00:00.000	333383	YY	2015-03-27 00:00:00	117266	 	NULL	NULL	NULL
71134	1	2015-03-26 00:00:00	n029	2015-03-27 00:00:00	N	T	15030305	GS00034226	65879	_	T	11978	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-03-30 00:00:00.000	333384	YY	2015-03-27 00:00:00	117269	 	NULL	NULL	NULL
71135	1	2015-03-26 00:00:00	n029	2015-03-27 00:00:00	N	T	15030306	GS00034227	66332	_	T	14800	n824	FE1	FE1	N	2400.00	2400.00	Y	2015-03-30 00:00:00.000	333385	YE	2015-03-27 00:00:00	117270	 	NULL	NULL	NULL
71136	1	2015-03-26 00:00:00	n029	2015-03-27 00:00:00	N	T	15030309	GS00034228	66333	_	T	14800	n824	FE1	FE1	N	2400.00	2400.00	Y	2015-03-30 00:00:00.000	333386	YE	2015-03-27 00:00:00	117271	 	NULL	NULL	NULL
71137	1	2015-03-26 00:00:00	n029	2015-03-27 00:00:00	N	T	15030307	GS00034229	66334	_	T	14800	n824	FE1	FE1	N	2400.00	2400.00	Y	2015-03-30 00:00:00.000	333387	YE	2015-03-27 00:00:00	117272	 	NULL	NULL	NULL
71138	1	2015-03-26 00:00:00	n029	2015-03-27 00:00:00	N	T	15030308	GS00034230	66335	_	T	14800	n824	FE1	FE1	N	2400.00	2400.00	Y	2015-03-30 00:00:00.000	333388	YE	2015-03-27 00:00:00	117273	 	NULL	NULL	NULL
71139	1	2015-03-26 00:00:00	n029	2015-03-27 00:00:00	N	T	15030248	GS00034231	66322	_	T	14895	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-03-30 00:00:00.000	333389	YY	2015-03-27 00:00:00	117274	 	NULL	NULL	NULL
71140	1	2015-03-26 00:00:00	n029	2015-03-27 00:00:00	N	T	15030249	GS00034232	66323	_	T	14895	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-03-30 00:00:00.000	333390	YY	2015-03-27 00:00:00	117275	 	NULL	NULL	NULL
71141	1	2015-03-26 00:00:00	n029	2015-03-27 00:00:00	N	T	15030250	GS00034233	66324	_	T	14895	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-03-30 00:00:00.000	333391	YY	2015-03-27 00:00:00	117276	 	NULL	NULL	NULL
71142	1	2015-03-26 00:00:00	n029	2015-03-27 00:00:00	N	T	15030251	GS00034234	66325	_	T	14895	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-03-30 00:00:00.000	333392	YY	2015-03-27 00:00:00	117277	 	NULL	NULL	NULL
71143	1	2015-03-26 00:00:00	n029	2015-03-27 00:00:00	N	T	15030252	GS00034235	66326	_	T	14895	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-03-30 00:00:00.000	333393	YY	2015-03-27 00:00:00	117278	 	NULL	NULL	NULL
71144	1	2015-03-26 00:00:00	n029	2015-03-27 00:00:00	N	T	15030253	GS00034236	66327	_	T	14895	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-03-30 00:00:00.000	333394	YY	2015-03-27 00:00:00	117279	 	NULL	NULL	NULL
71145	1	2015-03-26 00:00:00	n029	2015-03-27 00:00:00	N	T	15030254	GS00034237	66328	_	T	14895	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-03-30 00:00:00.000	333395	YY	2015-03-27 00:00:00	117280	 	NULL	NULL	NULL
71146	1	2015-03-26 00:00:00	n029	2015-03-27 00:00:00	N	T	15030255	GS00034238	66329	_	T	14895	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-03-30 00:00:00.000	333396	YY	2015-03-27 00:00:00	117281	 	NULL	NULL	NULL
71147	1	2015-03-26 00:00:00	n029	2015-03-27 00:00:00	N	T	15030256	GS00034239	66330	_	T	14895	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-03-30 00:00:00.000	333397	YY	2015-03-27 00:00:00	117282	 	NULL	NULL	NULL
71148	1	2015-03-26 00:00:00	n029	2015-03-27 00:00:00	N	T	15030257	GS00034240	66331	_	T	14895	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-03-30 00:00:00.000	333398	YY	2015-03-27 00:00:00	117283	 	NULL	NULL	NULL
71149	1	2015-03-26 00:00:00	n029	2015-03-27 00:00:00	N	T	15030315	GS00034241	65865	_	T	15859	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-03-30 00:00:00.000	333399	YY	2015-03-27 00:00:00	117284	 	NULL	NULL	NULL
71150	1	2015-03-26 00:00:00	n029	2015-03-27 00:00:00	N	T	15030316	GS00034242	65866	_	T	15859	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-03-30 00:00:00.000	333400	YY	2015-03-27 00:00:00	117285	 	NULL	NULL	NULL
71151	1	2015-03-26 00:00:00	n029	2015-03-27 00:00:00	N	T	15030314	GS00034243	65576	_	T	13176	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-03-30 00:00:00.000	333401	YY	2015-03-27 00:00:00	117286	 	NULL	NULL	NULL
71152	1	2015-03-26 00:00:00	n029	2015-03-27 00:00:00	N	T	15030313	GS00034244	65579	_	T	13176	n428	FF0	FF0	N	5000.00	5000.00	Y	2015-03-30 00:00:00.000	333402	YY	2015-03-27 00:00:00	117287	 	NULL	NULL	NULL
71153	1	2015-03-26 00:00:00	n029	2015-03-27 00:00:00	N	T	15030312	GS00034245	65580	_	T	827	n428	FF0	FF0	N	10000.00	10000.00	Y	2015-03-30 00:00:00.000	333403	YY	2015-03-27 00:00:00	117288	 	NULL	NULL	NULL
71154	1	2015-03-26 16:20:00	n319	2015-03-27 00:00:00	N	P	15030321	GS15000744	22008	_	T	12556	n1489	WS11	AJ2	N	6100.00	6100.00	Y	2015-03-30 00:00:00.000	333363	YY	2015-03-27 00:00:00	160458	 	NULL	NULL	NULL
71155	1	2015-03-26 00:00:00	n029	2015-03-27 00:00:00	N	T	15030311	GS00034246	65575	_	T	827	n428	FF0	FF0	N	12500.00	12500.00	Y	2015-03-30 00:00:00.000	333404	YY	2015-03-27 00:00:00	117289	 	NULL	NULL	NULL
71156	1	2015-03-26 00:00:00	n029	2015-03-27 00:00:00	N	T	15030310	GS00034247	65574	_	T	827	n428	FF0	FF0	N	12500.00	12500.00	Y	2015-03-30 00:00:00.000	333405	YY	2015-03-27 00:00:00	117290	 	NULL	NULL	NULL
71157	1	2015-03-27 08:49:00	n319	2015-03-27 00:00:00	N	P	15030335	GS15000745	25899	_	T	10747	n1065	WS1	AJ1	N	8500.00	8500.00	Y	2015-03-30 00:00:00.000	333364	YY	2015-03-27 00:00:00	160459	 	NULL	NULL	NULL
71158	1	2015-03-27 00:00:00	n417	2015-03-27 00:00:00	N	T	15030318	GS00034248	65745	_	T	6865	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-03-30 00:00:00.000	333406	YY	2015-03-27 00:00:00	117310	 	NULL	NULL	NULL
71159	1	2015-03-27 00:00:00	n417	2015-03-27 00:00:00	N	T	15030319	GS00034249	65765	_	T	13221	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-03-30 00:00:00.000	333407	YY	2015-03-27 00:00:00	117312	 	NULL	NULL	NULL
71160	1	2015-03-27 08:52:00	n319	2015-03-27 00:00:00	N	P	15010256	GS15000746	25940	_	T	13926	n896	FR1	AB1	N	7000.00	7000.00	Y	2015-03-30 00:00:00.000	333365	YY	2015-03-27 00:00:00	160461	 	NULL	NULL	NULL
71161	1	2015-03-27 00:00:00	n417	2015-03-27 00:00:00	N	T	15030320	GS00034250	65766	_	T	13221	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-03-30 00:00:00.000	333408	YY	2015-03-27 00:00:00	117313	 	NULL	NULL	NULL
71162	1	2015-03-27 00:00:00	n417	2015-03-27 00:00:00	N	T	15030321	GS00034251	65767	_	T	13221	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-03-30 00:00:00.000	333409	YY	2015-03-27 00:00:00	117314	 	NULL	NULL	NULL
71163	1	2015-03-27 00:00:00	n417	2015-03-27 00:00:00	N	T	15030322	GS00034252	65768	_	T	13221	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-03-30 00:00:00.000	333410	YY	2015-03-27 00:00:00	117315	 	NULL	NULL	NULL
71164	1	2015-03-27 00:00:00	n417	2015-03-27 00:00:00	N	T	15030323	GS00034253	65769	_	T	13221	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-03-30 00:00:00.000	333411	YY	2015-03-27 00:00:00	117316	 	NULL	NULL	NULL
71165	1	2015-03-27 00:00:00	n417	2015-03-27 00:00:00	N	T	15030324	GS00034254	65774	_	T	13221	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-03-30 00:00:00.000	333412	YY	2015-03-27 00:00:00	117317	 	NULL	NULL	NULL
71166	1	2015-03-27 00:00:00	n417	2015-03-27 00:00:00	N	T	15030325	GS00034255	65775	_	T	13221	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-03-30 00:00:00.000	333413	YY	2015-03-27 00:00:00	117318	 	NULL	NULL	NULL
71167	1	2015-03-27 00:00:00	n417	2015-03-27 00:00:00	N	T	15030326	GS00034256	65776	_	T	13221	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-03-30 00:00:00.000	333414	YY	2015-03-27 00:00:00	117319	 	NULL	NULL	NULL
71168	1	2015-03-27 00:00:00	n417	2015-03-27 00:00:00	N	T	15030327	GS00034257	65777	_	T	13221	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-03-30 00:00:00.000	333415	YY	2015-03-27 00:00:00	117320	 	NULL	NULL	NULL
71169	1	2015-03-27 00:00:00	n417	2015-03-27 00:00:00	N	T	15030328	GS00034258	65778	_	T	13221	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-03-30 00:00:00.000	333416	YY	2015-03-27 00:00:00	117321	 	NULL	NULL	NULL
71170	1	2015-03-27 09:04:00	n319	2015-03-27 00:00:00	N	P	15030334	GS15000748	26124	_	T	10747	n1065	WS1	AJ1	N	8500.00	8500.00	Y	2015-03-30 00:00:00.000	333366	YY	2015-03-27 00:00:00	160465	 	NULL	NULL	NULL
71171	1	2015-03-27 09:08:00	n319	2015-03-27 00:00:00	N	P	15030333	GS15000749	27824	_	T	10747	n1065	WS1	AJ1	N	8500.00	8500.00	Y	2015-03-30 00:00:00.000	333367	YY	2015-03-27 00:00:00	160466	 	NULL	NULL	NULL
71172	1	2015-03-27 09:08:00	n319	2015-03-27 00:00:00	N	P	15030332	GS15000750	27914	_	T	10747	n1065	WS1	AJ1	N	8500.00	8500.00	Y	2015-03-30 00:00:00.000	333368	YY	2015-03-27 00:00:00	160467	 	NULL	NULL	NULL
71173	1	2015-03-27 09:09:00	n319	2015-03-27 00:00:00	N	P	15030337	GS15000751	27946	_	T	10747	n1065	WS1	AJ1	N	8500.00	8500.00	Y	2015-03-30 00:00:00.000	333369	YY	2015-03-27 00:00:00	160468	 	NULL	NULL	NULL
71174	1	2015-03-27 09:10:00	n319	2015-03-27 00:00:00	N	P	15030336	GS15000752	28005	_	T	10747	n1065	WS1	AJ1	N	8500.00	8500.00	Y	2015-03-30 00:00:00.000	333370	YY	2015-03-27 00:00:00	160469	 	NULL	NULL	NULL
71175	1	2015-03-27 09:14:00	n319	2015-03-27 00:00:00	N	P	15030234	GS15000753	26281	_	T	11806	n1065	FR1	AB1	N	7000.00	7800.00	Y	2015-03-30 00:00:00.000	333371	YY	2015-03-27 00:00:00	160470	 	NULL	NULL	NULL
71176	1	2015-03-27 09:14:00	n319	2015-03-27 00:00:00	N	P	15030356	GS15000753	26281	_	T	11806	n1065	FR12	AB1	N	800.00	7800.00	Y	2015-03-30 00:00:00.000	333372	YY	2015-03-27 00:00:00	160470	 	NULL	NULL	NULL
71177	1	2015-03-27 09:15:00	n319	2015-03-27 00:00:00	N	P	15030343	GS15000754	27959	_	T	15814	n1065	WS11	AJ2	N	6100.00	6100.00	Y	2015-03-30 00:00:00.000	333373	YY	2015-03-27 00:00:00	160471	 	NULL	NULL	NULL
71178	1	2015-03-27 09:19:00	n319	2015-03-27 00:00:00	N	P	14120129	GS15000755	28198	_	T	10747	n1065	UG1	AA3	N	3000.00	3000.00	Y	2015-03-30 00:00:00.000	333374	YY	2015-03-27 00:00:00	160472	 	NULL	NULL	NULL
71179	1	2015-03-27 09:26:00	n319	2015-03-27 00:00:00	N	P	15030104	GS15000759	28395	_	T	10747	n1065	UG1	AA3	N	3000.00	3000.00	Y	2015-03-30 00:00:00.000	333375	YY	2015-03-27 00:00:00	160476	 	NULL	NULL	NULL
71180	1	2015-03-27 09:27:00	n319	2015-03-27 00:00:00	N	P	15030105	GS15000760	28396	_	T	10747	n1065	UG1	AA3	N	3000.00	3000.00	Y	2015-03-30 00:00:00.000	333376	YY	2015-03-27 00:00:00	160477	 	NULL	NULL	NULL
71181	1	2015-03-27 09:37:00	n319	2015-03-27 00:00:00	N	P	14090021	GS15000761	27968	_	T	12406	n650	IG1B	AA21	N	9700.00	12100.00	Y	2015-03-30 00:00:00.000	333377	YY	2015-03-27 00:00:00	160478	 	NULL	NULL	NULL
71182	1	2015-03-27 09:37:00	n319	2015-03-27 00:00:00	N	P	15030344	GS15000761	27968	_	T	12406	n650	AC2	AA21	N	2400.00	12100.00	Y	2015-03-30 00:00:00.000	333378	YY	2015-03-27 00:00:00	160478	 	NULL	NULL	NULL
71183	1	2015-03-27 09:38:00	n319	2015-03-27 00:00:00	N	P	14090022	GS15000762	27969	_	T	12406	n650	IG1B	AA21	N	9700.00	10500.00	Y	2015-03-30 00:00:00.000	333379	YY	2015-03-27 00:00:00	160479	 	NULL	NULL	NULL
71184	1	2015-03-27 09:38:00	n319	2015-03-27 00:00:00	N	P	15030312	GS15000762	27969	_	T	12406	n650	AC2	AA21	N	800.00	10500.00	Y	2015-03-30 00:00:00.000	333380	YY	2015-03-27 00:00:00	160479	 	NULL	NULL	NULL
71185	1	2015-03-27 13:49:00	n319	2015-03-27 00:00:00	N	P	15030370	GS15000763	28445	_	T	10747	n1065	IG1E	AA2	N	10500.00	10500.00	Y	2015-03-30 00:00:00.000	333381	YY	2015-03-27 00:00:00	160541	 	NULL	NULL	NULL
71186	1	2015-03-27 15:08:00	n319	2015-03-30 00:00:00	N	P	15030340	GS15000764	24752	_	T	13091	n1125	WS11	AJ2	N	6100.00	6100.00	Y	2015-03-31 00:00:00.000	334081	YY	2015-03-30 00:00:00	160576	 	NULL	NULL	NULL
71187	1	2015-03-27 15:14:00	n319	2015-03-30 00:00:00	N	P	15030330	GS15000765	26055	_	T	15102	n1125	WS11	AJ2	N	2700.00	2700.00	Y	2015-03-31 00:00:00.000	334082	YY	2015-03-30 00:00:00	160577	 	NULL	NULL	NULL
71188	1	2015-03-27 15:15:00	n319	2015-03-30 00:00:00	N	P	15030323	GS15000766	26377	_	T	15868	n1125	WS1	AJ1	N	3500.00	3500.00	Y	2015-03-31 00:00:00.000	334083	YY	2015-03-30 00:00:00	160578	 	NULL	NULL	NULL
71189	1	2015-03-27 15:18:00	n319	2015-03-30 00:00:00	N	P	15030350	GS15000767	27142	_	T	15524	n994	WS1	AJ1	N	8500.00	8500.00	Y	2015-03-31 00:00:00.000	334084	YY	2015-03-30 00:00:00	160580	 	NULL	NULL	NULL
71190	1	2015-03-27 15:23:00	n319	2015-03-30 00:00:00	N	P	15030359	GS15000770	27961	_	T	12406	n650	WA3	AN5	D	1000.00	1000.00	Y	2015-03-31 00:00:00.000	334085	YY	2015-03-30 00:00:00	160583	 	NULL	NULL	NULL
71191	1	2015-03-27 15:24:00	n319	2015-03-30 00:00:00	N	P	15030324	GS15000771	27985	_	T	15867	n1489	WS11	AJ2	N	2700.00	2700.00	Y	2015-03-31 00:00:00.000	334086	YY	2015-03-30 00:00:00	160584	 	NULL	NULL	NULL
71192	1	2015-03-27 15:26:00	n319	2015-03-30 00:00:00	N	P	15030325	GS15000772	27991	_	T	15867	n1489	WS11	AJ2	N	2700.00	2700.00	Y	2015-03-31 00:00:00.000	334087	YY	2015-03-30 00:00:00	160585	 	NULL	NULL	NULL
71193	1	2015-03-27 15:28:00	n319	2015-03-30 00:00:00	N	P	15030326	GS15000773	27995	_	T	15867	n1489	WS11	AJ2	N	2700.00	2700.00	Y	2015-03-31 00:00:00.000	334088	YY	2015-03-30 00:00:00	160586	 	NULL	NULL	NULL
71194	1	2015-03-27 15:29:00	n319	2015-03-30 00:00:00	N	P	15030329	GS15000774	28019	_	T	15867	n1489	WS11	AJ2	N	2700.00	2700.00	Y	2015-03-31 00:00:00.000	334089	YY	2015-03-30 00:00:00	160587	 	NULL	NULL	NULL
71195	1	2015-03-27 15:30:00	n319	2015-03-30 00:00:00	N	P	15030328	GS15000775	28023	_	T	15867	n1489	WS11	AJ2	N	2700.00	2700.00	Y	2015-03-31 00:00:00.000	334090	YY	2015-03-30 00:00:00	160588	 	NULL	NULL	NULL
71196	1	2015-03-27 15:32:00	n319	2015-03-30 00:00:00	N	P	15030327	GS15000776	28130	_	T	15867	n1489	WS11	AJ2	N	2700.00	2700.00	Y	2015-03-31 00:00:00.000	334091	YY	2015-03-30 00:00:00	160589	 	NULL	NULL	NULL
71197	1	2015-03-27 15:33:00	n319	2015-03-30 00:00:00	N	P	15030286	GS15000777	28108	_	T	15632	n896	WA3	AN5	D	1000.00	1000.00	Y	2015-03-31 00:00:00.000	334092	YY	2015-03-30 00:00:00	160590	 	NULL	NULL	NULL
71198	1	2015-03-27 15:35:00	n319	2015-03-30 00:00:00	N	P	15030372	GS15000778	28127	_	T	14879	n650	WS11	AJ2	N	6100.00	6100.00	Y	2015-03-31 00:00:00.000	334093	YY	2015-03-30 00:00:00	160591	 	NULL	NULL	NULL
71199	1	2015-03-27 17:11:00	n319	2015-03-30 00:00:00	N	P	14070171	GS15000779	27812	_	T	15610	n994	IG1B	AA21	N	9700.00	17700.00	Y	2015-03-31 00:00:00.000	334094	YY	2015-03-30 00:00:00	160606	 	NULL	NULL	NULL
71200	1	2015-03-27 17:11:00	n319	2015-03-30 00:00:00	N	P	15030379	GS15000779	27812	_	T	15610	n994	AC2	AA21	N	8000.00	17700.00	Y	2015-03-31 00:00:00.000	334095	YY	2015-03-30 00:00:00	160606	 	NULL	NULL	NULL
71201	1	2015-03-27 17:15:00	n319	2015-03-30 00:00:00	N	P	14070172	GS15000780	27813	_	T	15610	n994	UG1	AA3	N	3000.00	3000.00	Y	2015-03-31 00:00:00.000	334096	YY	2015-03-30 00:00:00	160607	 	NULL	NULL	NULL
71202	1	2015-03-30 00:00:00	n029	2015-03-30 00:00:00	N	T	15030351	GS00034264	66336	_	T	14570	n441	FE11	FE11	N	2700.00	2700.00	Y	2015-03-31 00:00:00.000	334102	YE	2015-03-30 00:00:00	117374	 	NULL	NULL	NULL
71203	1	2015-03-30 00:00:00	n029	2015-03-30 00:00:00	N	T	15030297	GS00034267	52361	_	T	7683	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-03-31 00:00:00.000	334103	YY	2015-03-30 00:00:00	117377	 	NULL	NULL	NULL
71204	1	2015-03-30 00:00:00	n029	2015-03-30 00:00:00	N	T	15030298	GS00034268	52801	_	T	7683	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-03-31 00:00:00.000	334104	YY	2015-03-30 00:00:00	117378	 	NULL	NULL	NULL
71205	1	2015-03-30 00:00:00	n029	2015-03-30 00:00:00	N	T	15030299	GS00034269	52800	_	T	7683	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-03-31 00:00:00.000	334105	YY	2015-03-30 00:00:00	117379	 	NULL	NULL	NULL
71206	1	2015-03-30 00:00:00	n029	2015-03-30 00:00:00	N	T	15030300	GS00034270	52854	_	T	7683	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-03-31 00:00:00.000	334106	YY	2015-03-30 00:00:00	117380	 	NULL	NULL	NULL
71207	1	2015-03-30 00:00:00	n029	2015-03-30 00:00:00	N	T	15030301	GS00034271	52799	_	T	7683	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-03-31 00:00:00.000	334107	YY	2015-03-30 00:00:00	117381	 	NULL	NULL	NULL
71208	1	2015-03-30 00:00:00	n029	2015-03-30 00:00:00	N	T	15030302	GS00034272	52797	_	T	7683	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-03-31 00:00:00.000	334108	YY	2015-03-30 00:00:00	117382	 	NULL	NULL	NULL
71209	1	2015-03-30 00:00:00	n029	2015-03-30 00:00:00	N	T	15030303	GS00034273	51213	_	T	7683	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-03-31 00:00:00.000	334109	YY	2015-03-30 00:00:00	117383	 	NULL	NULL	NULL
71210	1	2015-03-30 08:43:00	n319	2015-03-30 00:00:00	N	P	15030347	GS15000781	21780	_	T	12715	n896	WS21	AK3	N	3800.00	3800.00	Y	2015-03-31 00:00:00.000	334097	YY	2015-03-30 00:00:00	160608	 	NULL	NULL	NULL
71211	1	2015-03-30 08:44:00	n319	2015-03-30 00:00:00	N	P	15030368	GS15000782	23447	_	T	11976	n1304	WS2	AK2	N	4000.00	4000.00	Y	2015-03-31 00:00:00.000	334098	YY	2015-03-30 00:00:00	160609	 	NULL	NULL	NULL
71212	1	2015-03-30 08:46:00	n319	2015-03-30 00:00:00	N	P	15030369	GS15000783	24893	_	T	13712	n896	WS1	AJ1	N	3500.00	3500.00	Y	2015-03-31 00:00:00.000	334099	YY	2015-03-30 00:00:00	160610	 	NULL	NULL	NULL
71213	1	2015-03-30 08:47:00	n319	2015-03-30 00:00:00	N	P	15030387	GS15000784	26080	_	T	13930	n896	WS1	AJ1	N	23500.00	23500.00	Y	2015-03-31 00:00:00.000	334100	YY	2015-03-30 00:00:00	160611	 	NULL	NULL	NULL
71214	1	2015-03-30 09:03:00	n319	2015-03-30 00:00:00	N	P	14120399	GS15000787	28252	_	T	13472	n1304	UG1	AA3	N	3000.00	3000.00	Y	2015-03-31 00:00:00.000	334101	YY	2015-03-30 00:00:00	160614	 	NULL	NULL	NULL
71215	1	2015-03-30 16:35:00	n319	2015-03-31 00:00:00	N	P	15030385	GS15000789	28057	_	T	15840	n113	WS11	AJ2	N	6100.00	6100.00	Y	2015-04-09 00:00:00.000	334235	YY	2015-03-31 00:00:00	160722	 	NULL	NULL	NULL
71216	1	2015-03-30 00:00:00	n029	2015-03-31 00:00:00	N	T	15030347	GS00034275	65436	1	T	15480	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-04-09 00:00:00.000	334252	YY	2015-03-31 00:00:00	117487	 	NULL	NULL	NULL
71217	1	2015-03-30 00:00:00	n029	2015-03-31 00:00:00	N	T	15030349	GS00034276	65842	_	T	7418	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-04-09 00:00:00.000	334253	YY	2015-03-31 00:00:00	117488	 	NULL	NULL	NULL
71218	1	2015-03-30 00:00:00	n029	2015-03-31 00:00:00	N	T	15030352	GS00034277	65817	_	T	15831	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-04-09 00:00:00.000	334254	YY	2015-03-31 00:00:00	117489	 	NULL	NULL	NULL
71219	1	2015-03-31 08:39:00	n319	2015-03-31 00:00:00	N	P	15030393	GS15000791	21778	_	T	7684	n896	WS21	AK3	N	1700.00	1700.00	Y	2015-04-09 00:00:00.000	334236	YY	2015-03-31 00:00:00	160726	 	NULL	NULL	NULL
71220	1	2015-03-31 08:44:00	n319	2015-03-31 00:00:00	N	P	15030392	GS15000794	27742	_	T	13930	n896	WS1	AJ1	N	9400.00	9400.00	Y	2015-04-09 00:00:00.000	334237	YY	2015-03-31 00:00:00	160729	 	NULL	NULL	NULL
71221	1	2015-03-31 09:10:00	n319	2015-03-31 00:00:00	N	P	15010178	GS15000796	1163	M	T	12293	n113	FR1	AB1	X	7000.00	13900.00	Y	2015-04-09 00:00:00.000	334238	YY	2015-03-31 00:00:00	160731	 	NULL	NULL	NULL
71222	1	2015-03-31 09:10:00	n319	2015-03-31 00:00:00	N	P	15030354	GS15000796	1163	M	T	12293	n113	FR12	AB1	X	6900.00	13900.00	Y	2015-04-09 00:00:00.000	334239	YY	2015-03-31 00:00:00	160731	 	NULL	NULL	NULL
71223	1	2015-03-31 09:12:00	n319	2015-03-31 00:00:00	N	P	15030398	GS15000798	26155	_	T	12406	n650	WS11	AJ2	N	6100.00	6100.00	Y	2015-04-09 00:00:00.000	334240	YY	2015-03-31 00:00:00	160733	 	NULL	NULL	NULL
71224	1	2015-03-31 09:13:00	n319	2015-03-31 00:00:00	N	P	15030399	GS15000799	26183	_	T	12406	n650	WS11	AJ2	N	6100.00	6100.00	Y	2015-04-09 00:00:00.000	334241	YY	2015-03-31 00:00:00	160734	 	NULL	NULL	NULL
71225	1	2015-03-31 09:13:00	n319	2015-03-31 00:00:00	N	P	15030397	GS15000800	28037	_	T	15833	n1489	WS11	AJ2	N	6100.00	6100.00	Y	2015-04-09 00:00:00.000	334242	YY	2015-03-31 00:00:00	160735	 	NULL	NULL	NULL
71226	1	2015-03-31 09:26:00	n319	2015-03-31 00:00:00	N	P	15030386	GS15000802	1176	M	T	15548	n113	AC2	AAD	X	8800.00	8800.00	Y	2015-04-09 00:00:00.000	334243	YY	2015-03-31 00:00:00	160737	 	NULL	NULL	NULL
71227	1	2015-03-31 09:37:00	n319	2015-03-31 00:00:00	N	P	15030400	GS15000804	18225	_	T	12406	n650	WS2	AK2	N	16000.00	16000.00	Y	2015-04-09 00:00:00.000	334244	YE	2015-03-31 00:00:00	160739	 	NULL	NULL	NULL
71228	1	2015-03-31 09:37:00	n319	2015-03-31 00:00:00	N	P	15030401	GS15000805	18226	_	T	12853	n650	WS2	AK2	N	8000.00	8000.00	Y	2015-04-09 00:00:00.000	334245	YE	2015-03-31 00:00:00	160740	 	NULL	NULL	NULL
71229	1	2015-03-31 09:37:00	n319	2015-03-31 00:00:00	N	P	15030373	GS15000806	18909	_	T	13095	n650	WS2	AK2	N	8000.00	8000.00	Y	2015-04-09 00:00:00.000	334246	YE	2015-03-31 00:00:00	160741	 	NULL	NULL	NULL
71230	1	2015-03-31 09:37:00	n319	2015-03-31 00:00:00	N	P	15030402	GS15000807	19828	_	T	12406	n650	WS2	AK2	N	8000.00	8000.00	Y	2015-04-09 00:00:00.000	334247	YE	2015-03-31 00:00:00	160742	 	NULL	NULL	NULL
71231	1	2015-03-31 09:37:00	n319	2015-03-31 00:00:00	N	P	15030389	GS15000808	20880	_	T	13824	n650	WS2	AK2	N	8000.00	8000.00	Y	2015-04-09 00:00:00.000	334248	YE	2015-03-31 00:00:00	160743	 	NULL	NULL	NULL
71232	1	2015-03-31 09:37:00	n319	2015-03-31 00:00:00	N	P	15030390	GS15000809	20884	_	T	13824	n650	WS2	AK2	N	8000.00	8000.00	Y	2015-04-09 00:00:00.000	334249	YE	2015-03-31 00:00:00	160744	 	NULL	NULL	NULL
71233	1	2015-03-31 09:37:00	n319	2015-03-31 00:00:00	N	P	15030391	GS15000810	20885	_	T	13824	n650	WS2	AK2	N	8000.00	8000.00	Y	2015-04-09 00:00:00.000	334250	YE	2015-03-31 00:00:00	160745	 	NULL	NULL	NULL
71234	1	2015-03-31 09:37:00	n319	2015-03-31 00:00:00	N	P	15030371	GS15000811	22137	_	T	13792	n650	WS2	AK2	N	16000.00	16000.00	Y	2015-04-09 00:00:00.000	334251	YE	2015-03-31 00:00:00	160746	 	NULL	NULL	NULL
71235	1	2015-03-31 00:00:00	n029	2015-04-01 00:00:00	N	T	15030368	GS00034281	61235	_	T	13501	n1384	FF2	FF2	N	1500.00	1500.00	Y	2015-04-09 00:00:00.000	334260	YY	2015-04-01 00:00:00	117551	 	NULL	NULL	NULL
71236	1	2015-03-31 00:00:00	n029	2015-04-01 00:00:00	N	T	15030369	GS00034282	61237	_	T	13501	n1384	FF2	FF2	N	1500.00	1500.00	Y	2015-04-09 00:00:00.000	334261	YY	2015-04-01 00:00:00	117552	 	NULL	NULL	NULL
71237	1	2015-03-31 00:00:00	n029	2015-04-01 00:00:00	N	T	15030383	GS00034283	65709	_	T	5682	n1350	FF0	FF0	N	2500.00	2500.00	Y	2015-04-09 00:00:00.000	334262	YY	2015-04-01 00:00:00	117553	 	NULL	NULL	NULL
71238	1	2015-03-31 00:00:00	n029	2015-04-01 00:00:00	N	T	15030384	GS00034284	65710	_	T	5682	n1350	FF0	FF0	N	2500.00	2500.00	Y	2015-04-09 00:00:00.000	334263	YY	2015-04-01 00:00:00	117558	 	NULL	NULL	NULL
71239	1	2015-03-31 16:04:00	n319	2015-04-01 00:00:00	N	P	15030409	GS15000812	25665	_	T	14953	n896	WS21	AK3	N	8400.00	8400.00	Y	2015-04-09 00:00:00.000	334255	YY	2015-04-01 00:00:00	160864	 	NULL	NULL	NULL
71240	1	2015-03-31 00:00:00	n029	2015-04-01 00:00:00	N	T	15030385	GS00034285	65711	_	T	5682	n1350	FF0	FF0	N	2500.00	2500.00	Y	2015-04-09 00:00:00.000	334264	YY	2015-04-01 00:00:00	117559	 	NULL	NULL	NULL
71241	1	2015-03-31 00:00:00	n029	2015-04-01 00:00:00	N	T	15030263	GS00034286	52146	_	T	4220	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-04-09 00:00:00.000	334265	YY	2015-04-01 00:00:00	117560	 	NULL	NULL	NULL
71242	1	2015-03-31 00:00:00	n029	2015-04-01 00:00:00	N	T	15030264	GS00034287	52619	_	T	4220	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-04-09 00:00:00.000	334266	YY	2015-04-01 00:00:00	117561	 	NULL	NULL	NULL
71243	1	2015-03-31 00:00:00	n029	2015-04-01 00:00:00	N	T	15030265	GS00034288	52618	_	T	4220	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-04-09 00:00:00.000	334267	YY	2015-04-01 00:00:00	117562	 	NULL	NULL	NULL
71244	1	2015-03-31 00:00:00	n029	2015-04-01 00:00:00	N	T	15030266	GS00034289	52757	_	T	4220	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-04-09 00:00:00.000	334268	YY	2015-04-01 00:00:00	117563	 	NULL	NULL	NULL
71245	1	2015-03-31 00:00:00	n029	2015-04-01 00:00:00	N	T	15030267	GS00034290	52756	_	T	4220	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-04-09 00:00:00.000	334269	YY	2015-04-01 00:00:00	117564	 	NULL	NULL	NULL
71246	1	2015-03-31 00:00:00	n029	2015-04-01 00:00:00	N	T	15030268	GS00034291	52760	_	T	4220	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-04-09 00:00:00.000	334270	YY	2015-04-01 00:00:00	117565	 	NULL	NULL	NULL
71247	1	2015-03-31 00:00:00	n029	2015-04-01 00:00:00	N	T	15030269	GS00034292	52762	_	T	4220	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-04-09 00:00:00.000	334271	YY	2015-04-01 00:00:00	117566	 	NULL	NULL	NULL
71248	1	2015-03-31 00:00:00	n029	2015-04-01 00:00:00	N	T	15030270	GS00034293	52763	_	T	4220	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-04-09 00:00:00.000	334272	YY	2015-04-01 00:00:00	117567	 	NULL	NULL	NULL
71249	1	2015-03-31 00:00:00	n029	2015-04-01 00:00:00	N	T	15030271	GS00034294	52765	_	T	4220	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-04-09 00:00:00.000	334273	YY	2015-04-01 00:00:00	117568	 	NULL	NULL	NULL
71250	1	2015-03-31 00:00:00	n029	2015-04-01 00:00:00	N	T	15030272	GS00034295	52766	_	T	4220	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-04-09 00:00:00.000	334274	YY	2015-04-01 00:00:00	117569	 	NULL	NULL	NULL
71251	1	2015-03-31 00:00:00	n029	2015-04-01 00:00:00	N	T	15030273	GS00034296	52767	_	T	4220	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-04-09 00:00:00.000	334275	YY	2015-04-01 00:00:00	117570	 	NULL	NULL	NULL
71252	1	2015-03-31 00:00:00	n029	2015-04-01 00:00:00	N	T	15030274	GS00034297	52769	_	T	4220	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-04-09 00:00:00.000	334276	YY	2015-04-01 00:00:00	117571	 	NULL	NULL	NULL
71253	1	2015-03-31 00:00:00	n029	2015-04-01 00:00:00	N	T	15030275	GS00034298	52758	_	T	4220	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-04-09 00:00:00.000	334277	YY	2015-04-01 00:00:00	117572	 	NULL	NULL	NULL
71254	1	2015-03-31 00:00:00	n029	2015-04-01 00:00:00	N	T	15030276	GS00034299	52759	_	T	4220	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-04-09 00:00:00.000	334278	YY	2015-04-01 00:00:00	117573	 	NULL	NULL	NULL
71255	1	2015-03-31 00:00:00	n029	2015-04-01 00:00:00	N	T	15030277	GS00034300	52761	_	T	4220	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-04-09 00:00:00.000	334279	YY	2015-04-01 00:00:00	117574	 	NULL	NULL	NULL
71256	1	2015-03-31 00:00:00	n029	2015-04-01 00:00:00	N	T	15030278	GS00034301	52764	_	T	4220	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-04-09 00:00:00.000	334280	YY	2015-04-01 00:00:00	117575	 	NULL	NULL	NULL
71257	1	2015-03-31 00:00:00	n029	2015-04-01 00:00:00	N	T	15030279	GS00034302	52768	_	T	4220	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-04-09 00:00:00.000	334281	YY	2015-04-01 00:00:00	117576	 	NULL	NULL	NULL
71258	1	2015-03-31 00:00:00	n029	2015-04-01 00:00:00	N	T	15030280	GS00034303	52851	_	T	4220	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-04-09 00:00:00.000	334282	YY	2015-04-01 00:00:00	117577	 	NULL	NULL	NULL
71259	1	2015-03-31 00:00:00	n029	2015-04-01 00:00:00	N	T	15030281	GS00034304	49428	_	T	4220	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-04-09 00:00:00.000	334283	YY	2015-04-01 00:00:00	117578	 	NULL	NULL	NULL
71260	1	2015-03-31 00:00:00	n029	2015-04-01 00:00:00	N	T	15030282	GS00034305	48610	_	T	4220	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-04-09 00:00:00.000	334284	YY	2015-04-01 00:00:00	117579	 	NULL	NULL	NULL
71261	1	2015-03-31 00:00:00	n029	2015-04-01 00:00:00	N	T	15010101	GS00034306	53181	_	T	11944	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-04-09 00:00:00.000	334285	YY	2015-04-01 00:00:00	117587	 	NULL	NULL	NULL
71262	1	2015-03-31 00:00:00	n029	2015-04-01 00:00:00	N	T	15030083	GS00034307	66292	_	T	13403	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-04-09 00:00:00.000	334286	YY	2015-04-01 00:00:00	117594	 	NULL	NULL	NULL
71263	1	2015-03-31 00:00:00	n029	2015-04-01 00:00:00	N	T	15030084	GS00034308	66293	_	T	13403	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-04-09 00:00:00.000	334287	YY	2015-04-01 00:00:00	117597	 	NULL	NULL	NULL
71264	1	2015-03-31 00:00:00	n029	2015-04-01 00:00:00	N	T	14080043	GS00034309	64404	_	T	7775	n1350	FR1	FR1	N	4000.00	4000.00	Y	2015-04-09 00:00:00.000	334288	YY	2015-04-01 00:00:00	117598	 	NULL	NULL	NULL
71265	1	2015-03-31 00:00:00	n029	2015-04-01 00:00:00	N	T	14080044	GS00034310	64405	_	T	7775	n1350	FR1	FR1	N	4000.00	4000.00	Y	2015-04-09 00:00:00.000	334289	YY	2015-04-01 00:00:00	117599	 	NULL	NULL	NULL
71266	1	2015-03-31 00:00:00	n029	2015-04-01 00:00:00	N	T	14080042	GS00034311	64406	_	T	7775	n1350	FR1	FR1	N	4000.00	4000.00	Y	2015-04-09 00:00:00.000	334290	YY	2015-04-01 00:00:00	117600	 	NULL	NULL	NULL
71267	1	2015-03-31 17:22:00	n319	2015-04-01 00:00:00	N	P	15030410	GS15000816	25856	_	T	15023	n1125	WS21	AK3	N	2800.00	2800.00	Y	2015-04-09 00:00:00.000	334256	YY	2015-04-01 00:00:00	160872	 	NULL	NULL	NULL
71268	1	2015-04-01 00:00:00	n029	2015-04-01 00:00:00	N	T	15030388	GS00034312	66337	_	T	16012	n824	FE1	FE1	N	2400.00	2400.00	Y	2015-04-09 00:00:00.000	334291	YE	2015-04-01 00:00:00	117610	 	NULL	NULL	NULL
71269	1	2015-04-01 00:00:00	n029	2015-04-01 00:00:00	N	T	15030387	GS00034313	66338	_	T	16012	n824	FE1	FE1	N	2400.00	2400.00	Y	2015-04-09 00:00:00.000	334292	YE	2015-04-01 00:00:00	117611	 	NULL	NULL	NULL
71270	1	2015-04-01 08:40:00	n319	2015-04-01 00:00:00	N	P	15030411	GS15000817	25443	_	T	14900	n1304	WS21	AK3	N	2400.00	2400.00	Y	2015-04-09 00:00:00.000	334257	YY	2015-04-01 00:00:00	160873	 	NULL	NULL	NULL
71271	1	2015-04-01 08:45:00	n319	2015-04-01 00:00:00	N	P	15010334	GS15000819	28339	_	T	13124	n1304	IG1E	AA2	N	10500.00	11300.00	Y	2015-04-09 00:00:00.000	334258	YY	2015-04-01 00:00:00	160875	 	NULL	NULL	NULL
71272	1	2015-04-01 08:45:00	n319	2015-04-01 00:00:00	N	P	15030422	GS15000819	28339	_	T	13124	n1304	AC2	AA2	N	800.00	11300.00	Y	2015-04-09 00:00:00.000	334259	YY	2015-04-01 00:00:00	160875	 	NULL	NULL	NULL
71273	1	2015-04-02 00:00:00	n029	2015-04-02 00:00:00	N	T	15030386	GS00034314	65663	_	T	14786	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-04-09 00:00:00.000	334301	YY	2015-04-02 00:00:00	117642	 	NULL	NULL	NULL
71274	1	2015-04-02 00:00:00	n029	2015-04-02 00:00:00	N	T	15040011	GS00034315	65814	_	T	13211	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-04-09 00:00:00.000	334302	YY	2015-04-02 00:00:00	117643	 	NULL	NULL	NULL
71275	1	2015-04-02 00:00:00	n029	2015-04-02 00:00:00	N	T	15040012	GS00034316	65815	_	T	13211	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-04-09 00:00:00.000	334303	YY	2015-04-02 00:00:00	117644	 	NULL	NULL	NULL
71276	1	2015-04-02 00:00:00	n029	2015-04-02 00:00:00	N	T	15040013	GS00034317	65816	_	T	13211	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-04-09 00:00:00.000	334304	YY	2015-04-02 00:00:00	117645	 	NULL	NULL	NULL
71277	1	2015-04-02 00:00:00	n029	2015-04-02 00:00:00	N	T	15030389	GS00034318	65254	_	T	7938	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-04-09 00:00:00.000	334305	YY	2015-04-02 00:00:00	117646	 	NULL	NULL	NULL
71278	1	2015-04-02 00:00:00	n029	2015-04-02 00:00:00	N	T	15030390	GS00034319	65255	_	T	7938	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-04-09 00:00:00.000	334306	YY	2015-04-02 00:00:00	117647	 	NULL	NULL	NULL
71279	1	2015-04-02 08:33:00	n319	2015-04-02 00:00:00	N	P	15040004	GS15000821	26008	_	T	13002	n650	WS11	AJ2	N	17500.00	17500.00	Y	2015-04-09 00:00:00.000	334293	YY	2015-04-02 00:00:00	160967	 	NULL	NULL	NULL
71280	1	2015-04-02 08:37:00	n319	2015-04-02 00:00:00	N	P	14110284	GS15000822	28175	_	T	15856	n994	UG1	AA3	N	3000.00	3000.00	Y	2015-04-09 00:00:00.000	334294	YY	2015-04-02 00:00:00	160968	 	NULL	NULL	NULL
71281	1	2015-04-02 08:39:00	n319	2015-04-02 00:00:00	N	P	14120400	GS15000823	28253	_	T	13472	n1304	UG1	AA3	N	3000.00	3000.00	Y	2015-04-09 00:00:00.000	334295	YY	2015-04-02 00:00:00	160969	 	NULL	NULL	NULL
71282	1	2015-04-02 00:00:00	n029	2015-04-02 00:00:00	N	T	15040010	GS00034327	66339	_	T	14776	n428	FE1	FE1	N	2400.00	2400.00	Y	2015-04-09 00:00:00.000	334307	YE	2015-04-02 00:00:00	117655	 	NULL	NULL	NULL
71283	1	2015-04-02 09:31:00	n319	2015-04-02 00:00:00	N	P	15040010	GS15000827	25228	_	T	7546	n1304	WS21	AK3	N	2400.00	2400.00	Y	2015-04-09 00:00:00.000	334296	YY	2015-04-02 00:00:00	160973	 	NULL	NULL	NULL
71284	1	2015-04-02 00:00:00	n029	2015-04-07 00:00:00	N	T	15040014	GS00034328	65434	_	T	7318	n646	FF0	FF0	N	2500.00	2500.00	Y	2015-04-15 00:00:00.000	334468	YY	2015-04-07 00:00:00	117681	 	NULL	NULL	NULL
71285	1	2015-04-02 11:33:00	n319	2015-04-02 00:00:00	N	P	14120343	GS15000829	28245	_	T	15569	n994	IG1B	AA21	N	9700.00	19300.00	Y	2015-04-09 00:00:00.000	334297	YY	2015-04-02 00:00:00	161017	 	NULL	NULL	NULL
71286	1	2015-04-02 11:33:00	n319	2015-04-02 00:00:00	N	P	15040024	GS15000829	28245	_	T	15569	n994	AC2	AA21	N	9600.00	19300.00	Y	2015-04-09 00:00:00.000	334298	YY	2015-04-02 00:00:00	161017	 	NULL	NULL	NULL
71287	1	2015-04-02 11:38:00	n319	2015-04-02 00:00:00	N	P	15030058	GS15000830	28387	_	T	10747	n1065	UG1	AA3	N	3000.00	3000.00	Y	2015-04-09 00:00:00.000	334299	YY	2015-04-02 00:00:00	161021	 	NULL	NULL	NULL
71288	1	2015-04-02 11:40:00	n319	2015-04-02 00:00:00	N	P	15040023	GS15000831	28455	_	T	10747	n1065	IG1E	AA2	N	10500.00	10500.00	Y	2015-04-09 00:00:00.000	334300	YY	2015-04-02 00:00:00	161024	 	NULL	NULL	NULL
71289	1	2015-04-02 00:00:00	n029	2015-04-07 00:00:00	N	T	15040015	GS00034332	66340	_	T	13555	n646	FE1	FE1	N	2400.00	2400.00	Y	2015-04-15 00:00:00.000	334469	YE	2015-04-07 00:00:00	117703	 	NULL	NULL	NULL
71290	1	2015-04-02 00:00:00	n029	2015-04-07 00:00:00	N	T	15040021	GS00034333	66341	_	T	14952	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-04-15 00:00:00.000	334470	YY	2015-04-07 00:00:00	117707	 	NULL	NULL	NULL
71291	1	2015-04-02 00:00:00	n029	2015-04-07 00:00:00	N	T	15040017	GS00034334	52248	_	T	11571	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-04-15 00:00:00.000	334471	YY	2015-04-07 00:00:00	117708	 	NULL	NULL	NULL
71292	1	2015-04-02 15:04:00	n319	2015-04-07 00:00:00	N	P	15040022	GS15000832	23477	_	T	12082	n650	WS11	AJ2	N	6100.00	6100.00	Y	2015-04-15 00:00:00.000	334458	YY	2015-04-07 00:00:00	161087	 	NULL	NULL	NULL
71293	1	2015-04-02 15:27:00	n319	2015-04-07 00:00:00	N	P	15040014	GS15000833	27974	_	T	14794	n1125	WS11	AJ2	N	1000.00	1000.00	Y	2015-04-15 00:00:00.000	334459	YY	2015-04-07 00:00:00	161091	 	NULL	NULL	NULL
71294	1	2015-04-02 15:28:00	n319	2015-04-07 00:00:00	N	P	15040015	GS15000834	27975	_	T	14794	n1125	WS11	AJ2	N	1000.00	1000.00	Y	2015-04-15 00:00:00.000	334460	YY	2015-04-07 00:00:00	161092	 	NULL	NULL	NULL
71295	1	2015-04-02 15:29:00	n319	2015-04-07 00:00:00	N	P	15040016	GS15000835	27976	_	T	14794	n1125	WS11	AJ2	N	1000.00	1000.00	Y	2015-04-15 00:00:00.000	334461	YY	2015-04-07 00:00:00	161094	 	NULL	NULL	NULL
71296	1	2015-04-02 15:30:00	n319	2015-04-07 00:00:00	N	P	15040017	GS15000836	27977	_	T	14794	n1125	WS11	AJ2	N	1000.00	1000.00	Y	2015-04-15 00:00:00.000	334462	YY	2015-04-07 00:00:00	161096	 	NULL	NULL	NULL
71297	1	2015-04-02 15:31:00	n319	2015-04-07 00:00:00	N	P	15040018	GS15000837	27978	_	T	14794	n1125	WS11	AJ2	N	1000.00	1000.00	Y	2015-04-15 00:00:00.000	334463	YY	2015-04-07 00:00:00	161097	 	NULL	NULL	NULL
71298	1	2015-04-02 15:32:00	n319	2015-04-07 00:00:00	N	P	15040019	GS15000838	27979	_	T	14794	n1125	WS11	AJ2	N	1000.00	1000.00	Y	2015-04-15 00:00:00.000	334464	YY	2015-04-07 00:00:00	161098	 	NULL	NULL	NULL
71299	1	2015-04-02 15:33:00	n319	2015-04-07 00:00:00	N	P	15040020	GS15000839	27980	_	T	14794	n1125	WS11	AJ2	N	1000.00	1000.00	Y	2015-04-15 00:00:00.000	334465	YY	2015-04-07 00:00:00	161100	 	NULL	NULL	NULL
71300	1	2015-04-02 15:34:00	n319	2015-04-07 00:00:00	N	P	15040021	GS15000840	27981	_	T	14794	n1125	WS11	AJ2	N	1000.00	1000.00	Y	2015-04-15 00:00:00.000	334466	YY	2015-04-07 00:00:00	161101	 	NULL	NULL	NULL
71301	1	2015-04-02 15:35:00	n319	2015-04-07 00:00:00	N	P	15040012	GS15000841	28257	_	T	14032	n994	WS1	AJ1	N	8500.00	8500.00	Y	2015-04-15 00:00:00.000	334467	YY	2015-04-07 00:00:00	161103	 	NULL	NULL	NULL
71302	1	2015-04-02 00:00:00	n029	2015-04-07 00:00:00	N	T	15040025	GS00034336	65539	_	T	14211	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-04-15 00:00:00.000	334472	YY	2015-04-07 00:00:00	117732	 	NULL	NULL	NULL
71303	1	2015-04-07 00:00:00	n029	2015-04-07 00:00:00	N	T	15040018	GS00034337	66342	_	T	13827	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-04-15 00:00:00.000	334473	YY	2015-04-07 00:00:00	117735	 	NULL	NULL	NULL
71304	1	2015-04-07 00:00:00	n029	2015-04-07 00:00:00	N	T	15040019	GS00034338	66343	_	T	13827	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-04-15 00:00:00.000	334474	YY	2015-04-07 00:00:00	117736	 	NULL	NULL	NULL
71305	1	2015-04-07 00:00:00	n029	2015-04-07 00:00:00	N	T	15040022	GS00034339	66344	_	T	15946	n646	FE11	FE11	N	8700.00	8700.00	Y	2015-04-15 00:00:00.000	334475	YE	2015-04-07 00:00:00	117737	 	NULL	NULL	NULL
71306	1	2015-04-07 00:00:00	n029	2015-04-07 00:00:00	N	T	15040023	GS00034340	66345	_	T	15946	n646	FE11	FE11	N	8700.00	8700.00	Y	2015-04-15 00:00:00.000	334476	YE	2015-04-07 00:00:00	117744	 	NULL	NULL	NULL
71307	1	2015-04-08 00:00:00	n029	2015-04-08 00:00:00	N	T	15040046	GS00034342	66346	_	T	15743	n646	FE11	FE11	N	2700.00	2700.00	Y	2015-04-15 00:00:00.000	334486	YE	2015-04-08 00:00:00	117810	 	NULL	NULL	NULL
71308	1	2015-04-08 08:51:00	n319	2015-04-08 00:00:00	N	P	15030208	GS15000852	26943	_	T	14219	n1486	FR1	AB1	N	7000.00	7000.00	Y	2015-04-15 00:00:00.000	334477	YY	2015-04-08 00:00:00	161225	 	NULL	NULL	NULL
71309	1	2015-04-08 08:53:00	n319	2015-04-08 00:00:00	N	P	15040035	GS15000854	27471	_	T	11640	n1125	WA3	AN5	D	1000.00	1000.00	Y	2015-04-15 00:00:00.000	334478	YY	2015-04-08 00:00:00	161227	 	NULL	NULL	NULL
71310	1	2015-04-08 08:54:00	n319	2015-04-08 00:00:00	N	P	15040034	GS15000855	27618	_	T	11640	n1125	WA3	AN5	D	1000.00	1000.00	Y	2015-04-15 00:00:00.000	334479	YY	2015-04-08 00:00:00	161228	 	NULL	NULL	NULL
71311	1	2015-04-08 08:56:00	n319	2015-04-08 00:00:00	N	P	14110206	GS15000856	28153	_	T	15877	n994	IG1B	AA21	N	9700.00	9700.00	Y	2015-04-15 00:00:00.000	334480	YY	2015-04-08 00:00:00	161229	 	NULL	NULL	NULL
71312	1	2015-04-08 08:57:00	n319	2015-04-08 00:00:00	N	P	14110207	GS15000857	28154	_	T	15877	n994	IG1B	AA21	N	9700.00	9700.00	Y	2015-04-15 00:00:00.000	334481	YY	2015-04-08 00:00:00	161230	 	NULL	NULL	NULL
71313	1	2015-04-08 09:02:00	n319	2015-04-08 00:00:00	N	P	15010120	GS15000859	28291	_	T	8406	n100	IG1E	AA2	N	10500.00	11300.00	Y	2015-04-15 00:00:00.000	334482	YY	2015-04-08 00:00:00	161232	 	NULL	NULL	NULL
71314	1	2015-04-08 09:02:00	n319	2015-04-08 00:00:00	N	P	15040033	GS15000859	28291	_	T	8406	n100	AC2	AA2	N	800.00	11300.00	Y	2015-04-15 00:00:00.000	334483	YY	2015-04-08 00:00:00	161232	 	NULL	NULL	NULL
71315	1	2015-04-08 09:17:00	n319	2015-04-08 00:00:00	N	P	14120276	GS15000860	28231	_	T	12000	n1304	IG1B	AA21	N	9700.00	10500.00	Y	2015-04-15 00:00:00.000	334484	YY	2015-04-08 00:00:00	161233	 	NULL	NULL	NULL
71316	1	2015-04-08 09:17:00	n319	2015-04-08 00:00:00	N	P	15040055	GS15000860	28231	_	T	12000	n1304	AC2	AA21	N	800.00	10500.00	Y	2015-04-15 00:00:00.000	334485	YY	2015-04-08 00:00:00	161233	 	NULL	NULL	NULL
71317	1	2015-04-08 15:09:00	n319	2015-04-09 00:00:00	N	P	15040037	GS15000862	28308	_	T	13708	n896	WA3	AN5	D	1000.00	1000.00	Y	2015-04-15 00:00:00.000	334487	YY	2015-04-09 00:00:00	161331	 	NULL	NULL	NULL
71318	1	2015-04-08 15:43:00	n319	2015-04-09 00:00:00	N	P	15030194	GS15000863	24948	_	T	11959	n1065	FR1	AB1	N	13400.00	13400.00	Y	2015-04-15 00:00:00.000	334488	YY	2015-04-09 00:00:00	161334	 	NULL	NULL	NULL
71319	1	2015-04-09 08:59:00	n319	2015-04-09 00:00:00	N	P	15040057	GS15000865	23716	_	T	14134	n896	WS1	AJ1	N	63500.00	63500.00	Y	2015-04-15 00:00:00.000	334489	YY	2015-04-09 00:00:00	161374	 	NULL	NULL	NULL
71320	1	2015-04-09 09:14:00	n319	2015-04-09 00:00:00	N	P	15040032	GS15000866	27574	_	T	15389	n1489	WA3	AN5	D	3000.00	3000.00	Y	2015-04-15 00:00:00.000	334490	YY	2015-04-09 00:00:00	161375	 	NULL	NULL	NULL
71321	1	2015-04-09 09:16:00	n319	2015-04-09 00:00:00	N	P	15030215	GS15000867	28091	_	T	3570	n1489	WS1	AJ1	N	3500.00	3500.00	Y	2015-04-15 00:00:00.000	334491	YY	2015-04-09 00:00:00	161376	 	NULL	NULL	NULL
71322	1	2015-04-09 09:18:00	n319	2015-04-09 00:00:00	N	P	15020027	GS15000868	28340	_	T	3570	n1489	DG1	AA4	N	3000.00	3000.00	Y	2015-04-15 00:00:00.000	334492	YY	2015-04-09 00:00:00	161377	 	NULL	NULL	NULL
71323	1	2015-04-09 09:32:00	n319	2015-04-09 00:00:00	N	P	15030277	GS15000869	28414	_	T	15919	n1065	UG1	AA3	N	3000.00	3000.00	Y	2015-04-15 00:00:00.000	334493	YY	2015-04-09 00:00:00	161378	 	NULL	NULL	NULL
71324	1	2015-04-09 09:39:00	n319	2015-04-09 00:00:00	N	P	15040056	GS15000870	17964	_	T	12336	n896	WS2	AK2	N	160000.00	160000.00	N	NULL	0	XX	2015-04-09 00:00:00	161379	 	NULL	NULL	NULL
71325	1	2015-04-09 09:39:00	n319	2015-04-09 00:00:00	N	P	15040039	GS15000871	18310	_	T	12406	n650	WS2	AK2	N	16000.00	16000.00	Y	2015-04-15 00:00:00.000	334494	YE	2015-04-09 00:00:00	161380	 	NULL	NULL	NULL
71326	1	2015-04-09 09:39:00	n319	2015-04-09 00:00:00	N	P	15040042	GS15000872	23585	_	T	13972	n100	WS2	AK2	N	4000.00	4000.00	Y	2015-04-15 00:00:00.000	334495	YE	2015-04-09 00:00:00	161381	 	NULL	NULL	NULL
71327	1	2015-04-09 09:39:00	n319	2015-04-09 00:00:00	N	P	15040043	GS15000873	24451	_	T	13972	n100	WS2	AK2	N	4000.00	4000.00	Y	2015-04-15 00:00:00.000	334496	YE	2015-04-09 00:00:00	161382	 	NULL	NULL	NULL
71328	1	2015-04-09 09:39:00	n319	2015-04-09 00:00:00	N	P	15040044	GS15000874	25707	_	T	13972	n100	WS2	AK2	N	4000.00	4000.00	Y	2015-04-15 00:00:00.000	334497	YE	2015-04-09 00:00:00	161383	 	NULL	NULL	NULL
71329	1	2015-04-09 09:44:00	n319	2015-04-09 00:00:00	N	P	14110209	GS15000875	28156	_	T	15877	n994	IG1B	AA21	N	9700.00	13700.00	Y	2015-04-15 00:00:00.000	334498	YY	2015-04-09 00:00:00	161384	 	NULL	NULL	NULL
71330	1	2015-04-09 09:44:00	n319	2015-04-09 00:00:00	N	P	15040084	GS15000875	28156	_	T	15877	n994	AC2	AA21	N	4000.00	13700.00	Y	2015-04-15 00:00:00.000	334499	YY	2015-04-09 00:00:00	161384	 	NULL	NULL	NULL
71331	1	2015-04-09 14:25:00	n319	2015-04-09 00:00:00	N	P	15040056	GS15000877	17964	_	T	12336	n896	WS2	AK2	N	144000.00	144000.00	Y	2015-04-15 00:00:00.000	334500	YY	2015-04-09 00:00:00	161448	 	NULL	NULL	NULL
71332	1	2015-04-10 08:51:00	n319	2015-04-10 00:00:00	N	P	15040088	GS15000880	20518	_	T	13002	n650	WS21	AK3	N	3800.00	3800.00	Y	2015-04-15 00:00:00.000	334501	YY	2015-04-10 00:00:00	161467	 	NULL	NULL	NULL
71333	1	2015-04-10 09:00:00	n319	2015-04-10 00:00:00	N	P	15040091	GS15000883	28174	_	T	13708	n896	WS11	AJ2	N	2700.00	2700.00	Y	2015-04-15 00:00:00.000	334502	YY	2015-04-10 00:00:00	161470	 	NULL	NULL	NULL
71334	1	2015-04-10 09:22:00	n319	2015-04-10 00:00:00	N	P	15040102	GS15000884	1174	M	T	15548	n113	AC2	AAD	X	12800.00	12800.00	Y	2015-04-15 00:00:00.000	334503	YY	2015-04-10 00:00:00	161471	 	NULL	NULL	NULL
71335	1	2015-04-10 09:24:00	n319	2015-04-10 00:00:00	N	P	15040101	GS15000885	25481	_	T	13091	n1125	WS11	AJ2	N	6100.00	6100.00	Y	2015-04-15 00:00:00.000	334504	YY	2015-04-10 00:00:00	161472	 	NULL	NULL	NULL
71336	1	2015-04-10 13:33:00	n319	2015-04-10 00:00:00	N	P	15030235	GS15000879	1173	M	T	15548	n113	AC2	AAD	X	11200.00	11200.00	Y	2015-04-15 00:00:00.000	334505	YY	2015-04-10 00:00:00	161466	 	NULL	NULL	NULL
71337	1	2015-04-10 14:04:00	n319	2015-04-10 00:00:00	N	P	15010169	GS15000888	28298	_	T	16015	n1125	IG1E	AA2	N	24900.00	25400.00	Y	2015-04-15 00:00:00.000	334506	YY	2015-04-10 00:00:00	161575	 	NULL	NULL	NULL
71338	1	2015-04-10 14:04:00	n319	2015-04-10 00:00:00	N	P	15040103	GS15000888	28298	_	T	16015	n1125	AC1	AA2	N	500.00	25400.00	Y	2015-04-15 00:00:00.000	334507	YY	2015-04-10 00:00:00	161575	 	NULL	NULL	NULL
71339	1	2015-04-10 14:06:00	n319	2015-04-10 00:00:00	N	P	15010170	GS15000889	28299	_	T	16015	n1125	UG1	AA3	N	3000.00	3000.00	Y	2015-04-15 00:00:00.000	334508	YY	2015-04-10 00:00:00	161577	 	NULL	NULL	NULL
71340	1	2015-04-10 00:00:00	n029	2015-04-13 00:00:00	N	T	15040056	GS00034349	64847	_	T	6138	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-04-20 00:00:00.000	335047	YY	2015-04-13 00:00:00	118107	 	NULL	NULL	NULL
71341	1	2015-04-10 00:00:00	n029	2015-04-13 00:00:00	N	T	15040057	GS00034350	64848	_	T	6138	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-04-20 00:00:00.000	335048	YY	2015-04-13 00:00:00	118108	 	NULL	NULL	NULL
71342	1	2015-04-10 00:00:00	n029	2015-04-13 00:00:00	N	T	15040055	GS00034351	65399	_	T	15224	n1350	FF0	FF0	N	2500.00	2500.00	Y	2015-04-20 00:00:00.000	335049	YY	2015-04-13 00:00:00	118109	 	NULL	NULL	NULL
71343	1	2015-04-10 00:00:00	n029	2015-04-13 00:00:00	N	T	15040054	GS00034352	65600	_	T	15295	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-04-20 00:00:00.000	335050	YY	2015-04-13 00:00:00	118110	 	NULL	NULL	NULL
71344	1	2015-04-10 00:00:00	n029	2015-04-13 00:00:00	N	T	15040058	GS00034354	65472	_	T	3308	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-04-20 00:00:00.000	335051	YY	2015-04-13 00:00:00	118118	 	NULL	NULL	NULL
71345	1	2015-04-10 00:00:00	n029	2015-04-13 00:00:00	N	T	15040066	GS00034358	66362	_	T	12033	n441	FE1	FE1	N	2400.00	2400.00	Y	2015-04-20 00:00:00.000	335052	YE	2015-04-13 00:00:00	118125	 	NULL	NULL	NULL
71346	1	2015-04-10 00:00:00	n029	2015-04-13 00:00:00	N	T	15040071	GS00034359	66363	_	T	12033	n441	FE1	FE1	N	2400.00	2400.00	Y	2015-04-20 00:00:00.000	335053	YE	2015-04-13 00:00:00	118126	 	NULL	NULL	NULL
71347	1	2015-04-13 08:42:00	n319	2015-04-13 00:00:00	N	P	15040107	GS15000891	21619	_	T	13956	n994	WS11	AJ2	N	6100.00	6100.00	Y	2015-04-20 00:00:00.000	335040	YY	2015-04-13 00:00:00	161606	 	NULL	NULL	NULL
71348	1	2015-04-13 08:44:00	n319	2015-04-13 00:00:00	N	P	15040106	GS15000892	26020	_	T	258	n1486	WS1	AJ1	N	8500.00	8500.00	Y	2015-04-20 00:00:00.000	335041	YY	2015-04-13 00:00:00	161607	 	NULL	NULL	NULL
71349	1	2015-04-13 08:45:00	n319	2015-04-13 00:00:00	N	P	15040105	GS15000893	26360	_	T	258	n1486	WS1	AJ1	N	8500.00	8500.00	Y	2015-04-20 00:00:00.000	335042	YY	2015-04-13 00:00:00	161608	 	NULL	NULL	NULL
71350	1	2015-04-13 08:47:00	n319	2015-04-13 00:00:00	N	P	15020051	GS15000894	28346	_	T	12000	n1304	IG1B	AA21	N	9700.00	9700.00	Y	2015-04-20 00:00:00.000	335043	YY	2015-04-13 00:00:00	161609	 	NULL	NULL	NULL
71351	1	2015-04-13 08:49:00	n319	2015-04-13 00:00:00	N	P	15030152	GS15000895	28406	_	T	13042	n650	IG1B	AA21	N	9700.00	9700.00	Y	2015-04-20 00:00:00.000	335044	YY	2015-04-13 00:00:00	161610	 	NULL	NULL	NULL
71352	1	2015-04-13 09:37:00	n319	2015-04-13 00:00:00	N	P	15040096	GS15000896	24241	_	T	12715	n896	WS21	AK3	N	1700.00	1700.00	Y	2015-04-20 00:00:00.000	335045	YY	2015-04-13 00:00:00	161611	 	NULL	NULL	NULL
71353	1	2015-04-13 10:43:00	n319	2015-04-13 00:00:00	N	P	15020157	GS15000897	28358	_	T	10747	n1065	UG1	AA3	N	3000.00	3000.00	Y	2015-04-20 00:00:00.000	335046	YY	2015-04-13 00:00:00	161613	 	NULL	NULL	NULL
71354	1	2015-04-13 00:00:00	n029	2015-04-14 00:00:00	N	T	15040094	GS00034362	66364	_	T	6316	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-04-20 00:00:00.000	335057	YE	2015-04-14 00:00:00	118169	 	NULL	NULL	NULL
71355	1	2015-04-13 00:00:00	n029	2015-04-14 00:00:00	N	T	15040090	GS00034363	38222	_	T	6945	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-04-20 00:00:00.000	335058	YY	2015-04-14 00:00:00	118170	 	NULL	NULL	NULL
71356	1	2015-04-14 00:00:00	n029	2015-04-14 00:00:00	N	T	15040096	GS00034366	65619	_	T	15348	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-04-20 00:00:00.000	335059	YY	2015-04-14 00:00:00	118185	 	NULL	NULL	NULL
71357	1	2015-04-14 00:00:00	n029	2015-04-14 00:00:00	N	T	15040097	GS00034367	65620	_	T	15348	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-04-20 00:00:00.000	335060	YY	2015-04-14 00:00:00	118186	 	NULL	NULL	NULL
71358	1	2015-04-14 08:45:00	n087	2015-04-14 00:00:00	N	P	15040124	GS15000898	28138	_	T	15869	n1304	WS1	AJ1	N	20500.00	20500.00	Y	2015-04-20 00:00:00.000	335054	YY	2015-04-14 00:00:00	161702	 	NULL	NULL	NULL
71359	1	2015-04-14 13:39:00	n087	2015-04-14 00:00:00	N	P	15040133	GS15000901	1188	M	T	14881	n113	IG1E	AA2	X	10500.00	10500.00	Y	2015-04-20 00:00:00.000	335055	YY	2015-04-14 00:00:00	161767	 	NULL	NULL	NULL
71360	1	2015-04-14 13:49:00	n087	2015-04-14 00:00:00	N	P	15040138	GS15000902	25465	_	T	9950	n100	WS21	AK3	N	2800.00	2800.00	Y	2015-04-20 00:00:00.000	335056	YY	2015-04-14 00:00:00	161770	 	NULL	NULL	NULL
71361	1	2015-04-14 00:00:00	n029	2015-04-15 00:00:00	N	T	15040115	GS00034368	65422	_	T	14892	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-04-21 00:00:00.000	335090	YY	2015-04-15 00:00:00	118243	 	NULL	NULL	NULL
71362	1	2015-04-14 00:00:00	n029	2015-04-15 00:00:00	N	T	15040114	GS00034369	65855	_	T	15283	n646	FF0	FF0	N	2500.00	2500.00	Y	2015-04-21 00:00:00.000	335091	YY	2015-04-15 00:00:00	118245	 	NULL	NULL	NULL
71363	1	2015-04-14 00:00:00	n029	2015-04-15 00:00:00	N	T	15040102	GS00034370	65313	_	T	15714	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-04-21 00:00:00.000	335092	YY	2015-04-15 00:00:00	118246	 	NULL	NULL	NULL
71364	1	2015-04-14 00:00:00	n029	2015-04-15 00:00:00	N	T	15040110	GS00034371	65937	_	T	15804	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-04-21 00:00:00.000	335093	YY	2015-04-15 00:00:00	118247	 	NULL	NULL	NULL
71365	1	2015-04-14 00:00:00	n029	2015-04-15 00:00:00	N	T	15040100	GS00034372	65306	_	T	15709	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-04-21 00:00:00.000	335094	YY	2015-04-15 00:00:00	118248	 	NULL	NULL	NULL
71366	1	2015-04-14 00:00:00	n029	2015-04-15 00:00:00	N	T	15040101	GS00034373	65307	_	T	15709	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-04-21 00:00:00.000	335095	YY	2015-04-15 00:00:00	118249	 	NULL	NULL	NULL
71367	1	2015-04-15 08:38:00	n319	2015-04-15 00:00:00	N	P	15040131	GS15000904	1034	Z	T	15748	n1125	WA3	AN5	D	1000.00	1000.00	Y	2015-04-21 00:00:00.000	335082	YY	2015-04-15 00:00:00	161797	 	NULL	NULL	NULL
71368	1	2015-04-15 08:39:00	n319	2015-04-15 00:00:00	N	P	15040132	GS15000905	1035	Z	T	15748	n1125	WA3	AN5	D	1000.00	1000.00	Y	2015-04-21 00:00:00.000	335083	YY	2015-04-15 00:00:00	161798	 	NULL	NULL	NULL
71369	1	2015-04-15 08:41:00	n319	2015-04-15 00:00:00	N	P	15040141	GS15000906	27999	_	T	14737	n650	WA3	AN5	D	1000.00	1000.00	Y	2015-04-21 00:00:00.000	335084	YY	2015-04-15 00:00:00	161799	 	NULL	NULL	NULL
71370	1	2015-04-15 08:43:00	n319	2015-04-15 00:00:00	N	P	15010328	GS15000907	28337	_	T	10554	n100	UG1	AA3	N	3000.00	3000.00	Y	2015-04-21 00:00:00.000	335085	YY	2015-04-15 00:00:00	161800	 	NULL	NULL	NULL
71371	1	2015-04-15 08:45:00	n319	2015-04-15 00:00:00	N	P	15020210	GS15000908	28371	_	T	10747	n1065	UG1	AA3	N	3000.00	3000.00	Y	2015-04-21 00:00:00.000	335086	YY	2015-04-15 00:00:00	161801	 	NULL	NULL	NULL
71372	1	2015-04-15 09:01:00	n319	2015-04-15 00:00:00	N	P	15040128	GS15000909	27020	_	T	12621	n1304	WA3	AN5	N	1000.00	1000.00	Y	2015-04-21 00:00:00.000	335087	YY	2015-04-15 00:00:00	161802	 	NULL	NULL	NULL
71373	1	2015-04-15 09:05:00	n319	2015-04-15 00:00:00	N	P	15040148	GS15000911	28264	_	T	15908	n1486	WS11	AJ2	N	6100.00	6100.00	Y	2015-04-21 00:00:00.000	335088	YY	2015-04-15 00:00:00	161804	 	NULL	NULL	NULL
71374	1	2015-04-15 09:08:00	n319	2015-04-15 00:00:00	N	P	15030147	GS15000913	28405	_	T	3554	n896	UG1	AA3	N	3000.00	3000.00	Y	2015-04-21 00:00:00.000	335089	YY	2015-04-15 00:00:00	161806	 	NULL	NULL	NULL
71375	1	2015-04-15 00:00:00	n029	2015-04-16 00:00:00	N	T	15040118	GS00034379	65883	_	T	13403	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-04-21 00:00:00.000	335101	YY	2015-04-16 00:00:00	118292	 	NULL	NULL	NULL
71376	1	2015-04-15 00:00:00	n029	2015-04-16 00:00:00	N	T	15040119	GS00034380	65884	_	T	13403	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-04-21 00:00:00.000	335102	YY	2015-04-16 00:00:00	118293	 	NULL	NULL	NULL
71377	1	2015-04-15 00:00:00	n029	2015-04-16 00:00:00	N	T	15040072	GS00034381	52690	_	T	8048	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-04-21 00:00:00.000	335103	YY	2015-04-16 00:00:00	118294	 	NULL	NULL	NULL
71378	1	2015-04-15 00:00:00	n029	2015-04-16 00:00:00	N	T	15040106	GS00034382	52848	_	T	84	n646	FR1	FR1	N	4000.00	4000.00	Y	2015-04-21 00:00:00.000	335104	YY	2015-04-16 00:00:00	118295	 	NULL	NULL	NULL
71379	1	2015-04-15 00:00:00	n029	2015-04-16 00:00:00	N	T	15040107	GS00034383	52959	_	T	84	n646	FR1	FR1	N	4000.00	4000.00	Y	2015-04-21 00:00:00.000	335105	YY	2015-04-16 00:00:00	118296	 	NULL	NULL	NULL
71380	1	2015-04-15 00:00:00	n029	2015-04-16 00:00:00	N	T	15040108	GS00034384	53205	_	T	84	n646	FR1	FR1	N	4000.00	4000.00	Y	2015-04-21 00:00:00.000	335106	YY	2015-04-16 00:00:00	118297	 	NULL	NULL	NULL
71381	1	2015-04-15 00:00:00	n029	2015-04-16 00:00:00	N	T	15040109	GS00034385	53206	_	T	84	n646	FR1	FR1	N	4000.00	4000.00	Y	2015-04-21 00:00:00.000	335107	YY	2015-04-16 00:00:00	118298	 	NULL	NULL	NULL
71382	1	2015-04-15 00:00:00	n029	2015-04-16 00:00:00	N	T	15040141	GS00034386	52635	_	T	12991	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-04-21 00:00:00.000	335108	YY	2015-04-16 00:00:00	118302	 	NULL	NULL	NULL
71383	1	2015-04-15 00:00:00	n029	2015-04-16 00:00:00	N	T	15040142	GS00034387	52636	_	T	12991	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-04-21 00:00:00.000	335109	YY	2015-04-16 00:00:00	118303	 	NULL	NULL	NULL
71384	1	2015-04-15 00:00:00	n029	2015-04-16 00:00:00	N	T	15040133	GS00034388	52625	_	T	12990	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-04-21 00:00:00.000	335110	YY	2015-04-16 00:00:00	118304	 	NULL	NULL	NULL
71385	1	2015-04-15 00:00:00	n029	2015-04-16 00:00:00	N	T	15040134	GS00034389	52628	_	T	12990	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-04-21 00:00:00.000	335111	YY	2015-04-16 00:00:00	118305	 	NULL	NULL	NULL
71386	1	2015-04-15 00:00:00	n029	2015-04-16 00:00:00	N	T	15040135	GS00034390	52629	_	T	12990	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-04-21 00:00:00.000	335112	YY	2015-04-16 00:00:00	118306	 	NULL	NULL	NULL
71387	1	2015-04-15 00:00:00	n029	2015-04-16 00:00:00	N	T	15040136	GS00034391	52626	_	T	12990	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-04-21 00:00:00.000	335113	YY	2015-04-16 00:00:00	118307	 	NULL	NULL	NULL
71388	1	2015-04-15 00:00:00	n029	2015-04-16 00:00:00	N	T	15040137	GS00034392	52631	_	T	12990	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-04-21 00:00:00.000	335114	YY	2015-04-16 00:00:00	118308	 	NULL	NULL	NULL
71389	1	2015-04-15 00:00:00	n029	2015-04-16 00:00:00	N	T	15040138	GS00034393	52634	_	T	12990	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-04-21 00:00:00.000	335115	YY	2015-04-16 00:00:00	118309	 	NULL	NULL	NULL
71390	1	2015-04-15 00:00:00	n029	2015-04-16 00:00:00	N	T	15040139	GS00034394	52630	_	T	12990	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-04-21 00:00:00.000	335116	YY	2015-04-16 00:00:00	118310	 	NULL	NULL	NULL
71391	1	2015-04-15 00:00:00	n029	2015-04-16 00:00:00	N	T	15040140	GS00034395	52632	_	T	12990	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-04-21 00:00:00.000	335117	YY	2015-04-16 00:00:00	118311	 	NULL	NULL	NULL
71392	1	2015-04-15 00:00:00	n029	2015-04-16 00:00:00	N	T	15040126	GS00034396	54218	_	T	13308	n824	FL1	FL1	N	2000.00	2000.00	Y	2015-04-21 00:00:00.000	335118	YY	2015-04-16 00:00:00	118312	 	NULL	NULL	NULL
71393	1	2015-04-15 00:00:00	n029	2015-04-16 00:00:00	N	T	15040127	GS00034397	54219	_	T	13308	n824	FL1	FL1	N	2000.00	2000.00	Y	2015-04-21 00:00:00.000	335119	YY	2015-04-16 00:00:00	118313	 	NULL	NULL	NULL
71394	1	2015-04-15 00:00:00	n029	2015-04-16 00:00:00	N	T	15040128	GS00034398	54220	_	T	13308	n824	FL1	FL1	N	2000.00	2000.00	Y	2015-04-21 00:00:00.000	335120	YY	2015-04-16 00:00:00	118314	 	NULL	NULL	NULL
71395	1	2015-04-15 00:00:00	n029	2015-04-16 00:00:00	N	T	15040130	GS00034399	54221	_	T	13308	n824	FL1	FL1	N	2000.00	2000.00	Y	2015-04-21 00:00:00.000	335121	YY	2015-04-16 00:00:00	118315	 	NULL	NULL	NULL
71396	1	2015-04-15 00:00:00	n029	2015-04-16 00:00:00	N	T	15040131	GS00034400	54222	_	T	13308	n824	FL1	FL1	N	2000.00	2000.00	Y	2015-04-21 00:00:00.000	335122	YY	2015-04-16 00:00:00	118319	 	NULL	NULL	NULL
71397	1	2015-04-15 00:00:00	n029	2015-04-16 00:00:00	N	T	15040129	GS00034401	54223	_	T	13308	n824	FL1	FL1	N	2000.00	2000.00	Y	2015-04-21 00:00:00.000	335123	YY	2015-04-16 00:00:00	118320	 	NULL	NULL	NULL
71398	1	2015-04-16 08:48:00	n319	2015-04-16 00:00:00	N	P	15040164	GS15000924	25781	_	T	12000	n1304	AC2	AAD	N	12800.00	12800.00	Y	2015-04-21 00:00:00.000	335096	YY	2015-04-16 00:00:00	161899	 	NULL	NULL	NULL
71399	1	2015-04-16 09:43:00	n319	2015-04-16 00:00:00	N	P	14110210	GS15000927	28157	_	T	15877	n994	IG1B	AA21	N	9700.00	9700.00	Y	2015-04-21 00:00:00.000	335097	YY	2015-04-16 00:00:00	161906	 	NULL	NULL	NULL
71400	1	2015-04-16 09:43:00	n319	2015-04-16 00:00:00	N	P	15040158	GS15000928	1059	M	T	12293	n113	WS2	AK2	X	5000.00	5000.00	Y	2015-04-21 00:00:00.000	335098	YE	2015-04-16 00:00:00	161907	 	NULL	NULL	NULL
71401	1	2015-04-16 09:43:00	n319	2015-04-16 00:00:00	N	P	15040135	GS15000929	14337	_	T	7793	n1304	WS2	AK2	N	16000.00	16000.00	Y	2015-04-21 00:00:00.000	335099	YE	2015-04-16 00:00:00	161908	 	NULL	NULL	NULL
71402	1	2015-04-16 09:43:00	n319	2015-04-16 00:00:00	N	P	15040162	GS15000930	20080	_	T	13332	n113	WS2	AK2	N	8000.00	8000.00	Y	2015-04-21 00:00:00.000	335100	YE	2015-04-16 00:00:00	161909	 	NULL	NULL	NULL
71403	1	2015-04-16 00:00:00	n029	2015-04-17 00:00:00	N	T	15040144	GS00034402	66365	_	T	3116	n530	FE1	FE1	N	2400.00	2400.00	Y	2015-04-21 00:00:00.000	335132	YE	2015-04-17 00:00:00	118347	 	NULL	NULL	NULL
71404	1	2015-04-16 15:38:00	n319	2015-04-17 00:00:00	N	P	15030024	GS15000931	28383	_	T	15772	n1125	UG1	AA3	N	3000.00	3000.00	Y	2015-04-21 00:00:00.000	335124	YY	2015-04-17 00:00:00	161979	 	NULL	NULL	NULL
71405	1	2015-04-16 00:00:00	n029	2015-04-17 00:00:00	N	T	15040151	GS00034403	65786	_	T	15252	n547	FF0	FF0	N	2500.00	2500.00	Y	2015-04-21 00:00:00.000	335133	YY	2015-04-17 00:00:00	118397	 	NULL	NULL	NULL
71406	1	2015-04-16 00:00:00	n029	2015-04-17 00:00:00	N	T	15040148	GS00034404	65748	_	T	6865	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-04-21 00:00:00.000	335134	YY	2015-04-17 00:00:00	118398	 	NULL	NULL	NULL
71407	1	2015-04-16 00:00:00	n029	2015-04-17 00:00:00	N	T	15040157	GS00034405	66366	_	T	15121	n530	FE1	FE1	N	2400.00	2400.00	Y	2015-04-21 00:00:00.000	335135	YE	2015-04-17 00:00:00	118399	 	NULL	NULL	NULL
71408	1	2015-04-16 00:00:00	n029	2015-04-17 00:00:00	N	T	15040158	GS00034406	66367	_	T	15121	n530	FE1	FE1	N	2400.00	2400.00	Y	2015-04-21 00:00:00.000	335136	YE	2015-04-17 00:00:00	118400	 	NULL	NULL	NULL
71409	1	2015-04-16 00:00:00	n029	2015-04-17 00:00:00	N	T	15040159	GS00034407	66368	_	T	15121	n530	FE1	FE1	N	2400.00	2400.00	Y	2015-04-21 00:00:00.000	335137	YE	2015-04-17 00:00:00	118401	 	NULL	NULL	NULL
71410	1	2015-04-16 00:00:00	n029	2015-04-17 00:00:00	N	T	15040161	GS00034408	66369	_	T	15121	n530	FE1	FE1	N	2400.00	2400.00	Y	2015-04-21 00:00:00.000	335138	YE	2015-04-17 00:00:00	118402	 	NULL	NULL	NULL
71411	1	2015-04-16 00:00:00	n029	2015-04-17 00:00:00	N	T	15040160	GS00034409	66370	_	T	15121	n530	FE1	FE1	N	2400.00	2400.00	Y	2015-04-21 00:00:00.000	335139	YE	2015-04-17 00:00:00	118403	 	NULL	NULL	NULL
71412	1	2015-04-17 08:38:00	n319	2015-04-17 00:00:00	N	P	15040184	GS15000933	28113	_	T	15856	n994	WS11	AJ2	N	6100.00	6100.00	Y	2015-04-21 00:00:00.000	335125	YY	2015-04-17 00:00:00	161995	 	NULL	NULL	NULL
71413	1	2015-04-17 08:44:00	n319	2015-04-17 00:00:00	N	P	15010305	GS15000934	28332	_	T	14737	n650	IG1E	AA2	N	10500.00	15800.00	Y	2015-04-21 00:00:00.000	335126	YY	2015-04-17 00:00:00	161996	 	NULL	NULL	NULL
71414	1	2015-04-17 08:44:00	n319	2015-04-17 00:00:00	N	P	15040183	GS15000934	28332	_	T	14737	n650	AC1	AA2	N	5300.00	15800.00	Y	2015-04-21 00:00:00.000	335127	YY	2015-04-17 00:00:00	161996	 	NULL	NULL	NULL
71415	1	2015-04-17 00:00:00	n029	2015-04-17 00:00:00	N	T	15040175	GS00034410	53170	_	T	13119	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-04-21 00:00:00.000	335140	YY	2015-04-17 00:00:00	118404	 	NULL	NULL	NULL
71416	1	2015-04-17 08:46:00	n319	2015-04-17 00:00:00	N	P	15010306	GS15000935	28333	_	T	14737	n650	UG1	AA3	N	3000.00	3000.00	Y	2015-04-21 00:00:00.000	335128	YY	2015-04-17 00:00:00	161997	 	NULL	NULL	NULL
71417	1	2015-04-17 00:00:00	n029	2015-04-17 00:00:00	N	T	15040176	GS00034411	53172	_	T	13119	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-04-21 00:00:00.000	335141	YY	2015-04-17 00:00:00	118405	 	NULL	NULL	NULL
71418	1	2015-04-17 00:00:00	n029	2015-04-17 00:00:00	N	T	15040177	GS00034412	53173	_	T	13119	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-04-21 00:00:00.000	335142	YY	2015-04-17 00:00:00	118406	 	NULL	NULL	NULL
71419	1	2015-04-17 09:07:00	n319	2015-04-17 00:00:00	N	P	15040188	GS15000936	28225	_	T	10747	n1065	AC2	AA2	N	1600.00	1600.00	Y	2015-04-21 00:00:00.000	335129	YY	2015-04-17 00:00:00	161998	 	NULL	NULL	NULL
71420	1	2015-04-17 09:08:00	n319	2015-04-17 00:00:00	N	P	15040189	GS15000937	28225	_	T	10747	n1065	AC2	AE21	N	4800.00	4800.00	Y	2015-04-21 00:00:00.000	335130	YY	2015-04-17 00:00:00	161999	 	NULL	NULL	NULL
71421	1	2015-04-17 09:42:00	n319	2015-04-17 00:00:00	N	P	15040175	GS15000939	19544	_	T	2853	n100	WS2	AK2	N	8000.00	8000.00	Y	2015-04-21 00:00:00.000	335131	YE	2015-04-17 00:00:00	162001	 	NULL	NULL	NULL
71422	1	2015-04-17 00:00:00	n029	2015-04-20 00:00:00	N	T	15040167	GS00034415	49969	_	T	2459	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-04-22 00:00:00.000	335226	YY	2015-04-20 00:00:00	118457	 	NULL	NULL	NULL
71423	1	2015-04-17 00:00:00	n029	2015-04-20 00:00:00	N	T	15040168	GS00034416	49970	_	T	2459	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-04-22 00:00:00.000	335227	YY	2015-04-20 00:00:00	118458	 	NULL	NULL	NULL
71424	1	2015-04-17 00:00:00	n029	2015-04-20 00:00:00	N	T	15040155	GS00034417	66373	_	T	7418	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-04-22 00:00:00.000	335228	YE	2015-04-20 00:00:00	118459	 	NULL	NULL	NULL
71425	1	2015-04-17 00:00:00	n029	2015-04-20 00:00:00	N	T	15040156	GS00034418	66374	_	T	7418	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-04-22 00:00:00.000	335229	YE	2015-04-20 00:00:00	118460	 	NULL	NULL	NULL
71426	1	2015-04-17 00:00:00	n029	2015-04-20 00:00:00	N	T	15040169	GS00034419	66371	_	T	13821	n646	FE11	FE11	N	2700.00	2700.00	Y	2015-04-22 00:00:00.000	335230	YE	2015-04-20 00:00:00	118461	 	NULL	NULL	NULL
71427	1	2015-04-17 00:00:00	n029	2015-04-20 00:00:00	N	T	15040170	GS00034420	66372	_	T	13821	n646	FE11	FE11	N	2700.00	2700.00	Y	2015-04-22 00:00:00.000	335231	YE	2015-04-20 00:00:00	118462	 	NULL	NULL	NULL
71428	1	2015-04-17 00:00:00	n029	2015-04-20 00:00:00	N	T	15040181	GS00034421	64799	_	T	15516	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-04-22 00:00:00.000	335232	YY	2015-04-20 00:00:00	118463	 	NULL	NULL	NULL
71429	1	2015-04-17 17:13:00	n319	2015-04-20 00:00:00	N	P	15040159	GS15000940	1094	M	T	12293	n113	WS1	AJ1	X	3500.00	3500.00	Y	2015-04-22 00:00:00.000	335219	YY	2015-04-20 00:00:00	162136	 	NULL	NULL	NULL
71430	1	2015-04-17 17:16:00	n319	2015-04-20 00:00:00	N	P	15040190	GS15000942	24838	_	T	13777	n1125	WS21	AK3	N	2800.00	2800.00	Y	2015-04-22 00:00:00.000	335220	YY	2015-04-20 00:00:00	162138	 	NULL	NULL	NULL
71431	1	2015-04-17 17:17:00	n319	2015-04-20 00:00:00	N	P	15040193	GS15000943	26158	_	T	2853	n100	WS1	AJ1	N	8500.00	8500.00	Y	2015-04-22 00:00:00.000	335221	YY	2015-04-20 00:00:00	162139	 	NULL	NULL	NULL
71432	1	2015-04-20 00:00:00	n029	2015-04-20 00:00:00	N	T	15040182	GS00034422	66376	_	T	7971	n824	FE1	FE1	N	2400.00	2400.00	Y	2015-04-22 00:00:00.000	335233	YE	2015-04-20 00:00:00	118464	 	NULL	NULL	NULL
71433	1	2015-04-20 00:00:00	n029	2015-04-20 00:00:00	N	T	15040183	GS00034423	66377	_	T	7971	n824	FE1	FE1	N	2400.00	2400.00	Y	2015-04-22 00:00:00.000	335234	YE	2015-04-20 00:00:00	118465	 	NULL	NULL	NULL
71434	1	2015-04-20 00:00:00	n029	2015-04-20 00:00:00	N	T	15040184	GS00034424	66378	_	T	7971	n824	FE1	FE1	N	2400.00	2400.00	Y	2015-04-22 00:00:00.000	335235	YE	2015-04-20 00:00:00	118466	 	NULL	NULL	NULL
71435	1	2015-04-20 08:47:00	n319	2015-04-20 00:00:00	N	P	15040161	GS15000947	28484	_	T	12406	n650	IG1B	AA21	N	12100.00	12100.00	Y	2015-04-22 00:00:00.000	335222	YY	2015-04-20 00:00:00	162143	 	NULL	NULL	NULL
71436	1	2015-04-20 09:01:00	n319	2015-04-20 00:00:00	N	P	15040187	GS15000948	27959	_	T	15814	n1065	WA3	AN5	D	1000.00	1000.00	Y	2015-04-22 00:00:00.000	335223	YY	2015-04-20 00:00:00	162144	 	NULL	NULL	NULL
71437	1	2015-04-20 09:14:00	n319	2015-04-20 00:00:00	N	P	15040196	GS15000951	28213	_	T	15897	n1065	WS11	AJ2	N	2700.00	2700.00	Y	2015-04-22 00:00:00.000	335224	YY	2015-04-20 00:00:00	162147	 	NULL	NULL	NULL
71438	1	2015-04-20 00:00:00	n029	2015-04-20 00:00:00	N	T	15040171	GS00034427	52305	_	T	936	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-04-22 00:00:00.000	335236	YY	2015-04-20 00:00:00	118478	 	NULL	NULL	NULL
71439	1	2015-04-20 00:00:00	n029	2015-04-20 00:00:00	N	T	15040174	GS00034428	52306	_	T	936	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-04-22 00:00:00.000	335237	YY	2015-04-20 00:00:00	118479	 	NULL	NULL	NULL
71440	1	2015-04-20 09:17:00	n319	2015-04-20 00:00:00	N	P	15040207	GS15000953	28181	_	T	10747	n1065	AC2	AE21	N	7200.00	7200.00	Y	2015-04-22 00:00:00.000	335225	YY	2015-04-20 00:00:00	162149	 	NULL	NULL	NULL
71441	1	2015-04-20 00:00:00	n029	2015-04-20 00:00:00	N	T	15040172	GS00034429	52307	_	T	936	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-04-22 00:00:00.000	335238	YY	2015-04-20 00:00:00	118480	 	NULL	NULL	NULL
71442	1	2015-04-20 00:00:00	n029	2015-04-20 00:00:00	N	T	15040173	GS00034430	52308	_	T	936	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-04-22 00:00:00.000	335239	YY	2015-04-20 00:00:00	118481	 	NULL	NULL	NULL
71443	1	2015-04-20 00:00:00	n029	2015-04-21 00:00:00	N	T	15040201	GS00034431	66386	_	T	2164	n441	FE1	FE1	N	2400.00	2400.00	Y	2015-04-22 00:00:00.000	335254	YE	2015-04-21 00:00:00	118531	 	NULL	NULL	NULL
71444	1	2015-04-20 00:00:00	n029	2015-04-21 00:00:00	N	T	15040191	GS00034432	66379	_	T	12455	n824	FE1	FE1	N	2400.00	2400.00	Y	2015-04-22 00:00:00.000	335255	YE	2015-04-21 00:00:00	118532	 	NULL	NULL	NULL
71445	1	2015-04-20 00:00:00	n029	2015-04-21 00:00:00	N	T	15040185	GS00034434	66375	_	T	1562	n547	FR1	FR1	N	4000.00	4000.00	Y	2015-04-22 00:00:00.000	335256	YY	2015-04-21 00:00:00	118546	 	NULL	NULL	NULL
71446	1	2015-04-20 00:00:00	n029	2015-04-21 00:00:00	N	T	15040207	GS00034435	52298	_	T	12924	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-04-22 00:00:00.000	335257	YY	2015-04-21 00:00:00	118547	 	NULL	NULL	NULL
71447	1	2015-04-20 00:00:00	n029	2015-04-21 00:00:00	N	T	15040206	GS00034436	52299	_	T	12924	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-04-22 00:00:00.000	335258	YY	2015-04-21 00:00:00	118548	 	NULL	NULL	NULL
71448	1	2015-04-20 17:00:00	n319	2015-04-21 00:00:00	N	P	15040199	GS15000955	25265	_	T	12000	n1304	WS11	AJ2	N	6100.00	6100.00	Y	2015-04-22 00:00:00.000	335240	YY	2015-04-21 00:00:00	162240	 	NULL	NULL	NULL
71449	1	2015-04-20 00:00:00	n029	2015-04-21 00:00:00	N	T	15040208	GS00034437	52300	_	T	12924	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-04-22 00:00:00.000	335259	YY	2015-04-21 00:00:00	118549	 	NULL	NULL	NULL
71450	1	2015-04-20 17:21:00	n319	2015-04-21 00:00:00	N	P	15020159	GS15000956	26266	_	T	4610	n994	FR1	AB1	N	7000.00	10200.00	Y	2015-04-22 00:00:00.000	335241	YY	2015-04-21 00:00:00	162241	 	NULL	NULL	NULL
71451	1	2015-04-20 17:21:00	n319	2015-04-21 00:00:00	N	P	15040212	GS15000956	26266	_	T	4610	n994	FR12	AB1	N	3200.00	10200.00	Y	2015-04-22 00:00:00.000	335242	YY	2015-04-21 00:00:00	162241	 	NULL	NULL	NULL
71452	1	2015-04-20 17:23:00	n319	2015-04-21 00:00:00	N	P	15040194	GS15000957	28074	_	T	15660	n994	LM3	AN2	N	9800.00	9800.00	Y	2015-04-22 00:00:00.000	335243	YY	2015-04-21 00:00:00	162242	 	NULL	NULL	NULL
71453	1	2015-04-21 00:00:00	n029	2015-04-21 00:00:00	N	T	15040194	GS00034438	66382	_	T	16018	n824	FE1	FE1	N	2400.00	2400.00	Y	2015-04-22 00:00:00.000	335260	YE	2015-04-21 00:00:00	118550	 	NULL	NULL	NULL
71454	1	2015-04-21 00:00:00	n029	2015-04-21 00:00:00	N	T	15040195	GS00034439	66383	_	T	16018	n824	FE1	FE1	N	2400.00	2400.00	Y	2015-04-22 00:00:00.000	335261	YE	2015-04-21 00:00:00	118552	 	NULL	NULL	NULL
71455	1	2015-04-21 00:00:00	n029	2015-04-21 00:00:00	N	T	15040196	GS00034440	66384	_	T	16018	n824	FE1	FE1	N	2400.00	2400.00	Y	2015-04-22 00:00:00.000	335262	YE	2015-04-21 00:00:00	118553	 	NULL	NULL	NULL
71456	1	2015-04-21 00:00:00	n029	2015-04-21 00:00:00	N	T	15040197	GS00034441	66385	_	T	16018	n824	FE1	FE1	N	2400.00	2400.00	Y	2015-04-22 00:00:00.000	335263	YE	2015-04-21 00:00:00	118554	 	NULL	NULL	NULL
71457	1	2015-04-21 08:40:00	n319	2015-04-21 00:00:00	N	P	14090382	GS15000959	28051	_	T	13444	n650	IG1E	AA2	N	10500.00	10500.00	Y	2015-04-22 00:00:00.000	335244	YY	2015-04-21 00:00:00	162244	 	NULL	NULL	NULL
71458	1	2015-04-21 08:41:00	n319	2015-04-21 00:00:00	N	P	14090383	GS15000960	28052	_	T	13444	n650	IG1E	AA2	N	10500.00	10500.00	Y	2015-04-22 00:00:00.000	335245	YY	2015-04-21 00:00:00	162245	 	NULL	NULL	NULL
71459	1	2015-04-21 00:00:00	n029	2015-04-21 00:00:00	N	T	15040192	GS00034442	66380	_	T	16018	n824	FE1	FE1	N	2400.00	2400.00	Y	2015-04-22 00:00:00.000	335264	YE	2015-04-21 00:00:00	118557	 	NULL	NULL	NULL
71460	1	2015-04-21 08:43:00	n319	2015-04-21 00:00:00	N	P	14090384	GS15000961	28053	_	T	13444	n650	IG1E	AA2	N	10500.00	10500.00	Y	2015-04-22 00:00:00.000	335246	YY	2015-04-21 00:00:00	162246	 	NULL	NULL	NULL
71461	1	2015-04-21 00:00:00	n029	2015-04-21 00:00:00	N	T	15040193	GS00034443	66381	_	T	16018	n824	FE1	FE1	N	2400.00	2400.00	Y	2015-04-22 00:00:00.000	335265	YE	2015-04-21 00:00:00	118558	 	NULL	NULL	NULL
71462	1	2015-04-21 08:45:00	n319	2015-04-21 00:00:00	N	P	14100161	GS15000962	28065	_	T	4610	n994	IG1B	AA21	N	9700.00	9700.00	Y	2015-04-22 00:00:00.000	335247	YY	2015-04-21 00:00:00	162247	 	NULL	NULL	NULL
71463	1	2015-04-21 08:47:00	n319	2015-04-21 00:00:00	N	P	15020194	GS15000963	28363	_	T	15935	n1486	IG1E	AA2	N	10500.00	10500.00	Y	2015-04-22 00:00:00.000	335248	YY	2015-04-21 00:00:00	162248	 	NULL	NULL	NULL
71464	1	2015-04-21 08:51:00	n319	2015-04-21 00:00:00	N	P	15040197	GS15000965	28491	_	T	10747	n1065	DG1	AA4	N	3000.00	3000.00	Y	2015-04-22 00:00:00.000	335249	YY	2015-04-21 00:00:00	162250	 	NULL	NULL	NULL
71465	1	2015-04-21 00:00:00	n029	2015-04-21 00:00:00	N	T	15040220	GS00034444	65541	_	T	15766	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-04-22 00:00:00.000	335266	YY	2015-04-21 00:00:00	118559	 	NULL	NULL	NULL
71466	1	2015-04-21 09:33:00	n319	2015-04-21 00:00:00	N	P	15020092	GS15000966	28353	_	T	15929	n896	IG1E	AA2	N	10500.00	10500.00	Y	2015-04-22 00:00:00.000	335250	YY	2015-04-21 00:00:00	162251	 	NULL	NULL	NULL
71467	1	2015-04-21 09:34:00	n319	2015-04-21 00:00:00	N	P	15020093	GS15000967	28354	_	T	15929	n896	IG1E	AA2	N	10500.00	10500.00	Y	2015-04-22 00:00:00.000	335251	YY	2015-04-21 00:00:00	162252	 	NULL	NULL	NULL
71468	1	2015-04-21 09:38:00	n319	2015-04-21 00:00:00	N	P	15020094	GS15000968	28355	_	T	15929	n896	IG1E	AA2	N	10500.00	10500.00	Y	2015-04-22 00:00:00.000	335252	YY	2015-04-21 00:00:00	162253	 	NULL	NULL	NULL
71469	1	2015-04-21 09:40:00	n319	2015-04-21 00:00:00	N	P	15040192	GS15000969	19278	_	T	2853	n100	WS2	AK2	N	8000.00	8000.00	Y	2015-04-22 00:00:00.000	335253	YE	2015-04-21 00:00:00	162254	 	NULL	NULL	NULL
71470	1	2015-04-21 15:55:00	n319	2015-04-22 00:00:00	N	P	15030070	GS15000970	1187	M	T	14881	n113	AC1	AA2	X	1000.00	1000.00	Y	2015-04-27 00:00:00.000	335428	YY	2015-04-22 00:00:00	162332	 	NULL	NULL	NULL
71471	1	2015-04-21 15:57:00	n319	2015-04-22 00:00:00	N	P	15040219	GS15000972	27813	_	T	15610	n994	WS1	AJ1	N	8500.00	8500.00	Y	2015-04-27 00:00:00.000	335429	YY	2015-04-22 00:00:00	162334	 	NULL	NULL	NULL
71472	1	2015-04-21 00:00:00	n029	2015-04-22 00:00:00	N	T	15040225	GS00034445	66393	_	T	14794	n646	FE1	FE1	N	2400.00	2400.00	Y	2015-04-27 00:00:00.000	335436	YE	2015-04-22 00:00:00	118681	 	NULL	NULL	NULL
71473	1	2015-04-21 00:00:00	n029	2015-04-22 00:00:00	N	T	15040209	GS00034446	66387	_	T	15348	n530	FE1	FE1	N	2400.00	2400.00	Y	2015-04-27 00:00:00.000	335437	YE	2015-04-22 00:00:00	118682	 	NULL	NULL	NULL
71474	1	2015-04-21 00:00:00	n029	2015-04-22 00:00:00	N	T	15040210	GS00034447	66388	_	T	15348	n530	FE1	FE1	N	2400.00	2400.00	Y	2015-04-27 00:00:00.000	335438	YE	2015-04-22 00:00:00	118683	 	NULL	NULL	NULL
71475	1	2015-04-21 00:00:00	n029	2015-04-22 00:00:00	N	T	15040211	GS00034448	66389	_	T	15348	n530	FE1	FE1	N	2400.00	2400.00	Y	2015-04-27 00:00:00.000	335439	YE	2015-04-22 00:00:00	118684	 	NULL	NULL	NULL
71476	1	2015-04-21 00:00:00	n029	2015-04-22 00:00:00	N	T	15040222	GS00034449	66390	_	T	15473	n428	FE1	FE1	N	13600.00	13600.00	Y	2015-04-27 00:00:00.000	335440	YE	2015-04-22 00:00:00	118685	 	NULL	NULL	NULL
71477	1	2015-04-21 00:00:00	n029	2015-04-22 00:00:00	N	T	15040223	GS00034450	66391	_	T	15473	n428	FE1	FE1	N	13600.00	13600.00	Y	2015-04-27 00:00:00.000	335441	YE	2015-04-22 00:00:00	118686	 	NULL	NULL	NULL
71478	1	2015-04-22 00:00:00	n029	2015-04-22 00:00:00	N	T	15040224	GS00034451	66392	_	T	15473	n428	FE1	FE1	N	13600.00	13600.00	Y	2015-04-27 00:00:00.000	335442	YE	2015-04-22 00:00:00	118689	 	NULL	NULL	NULL
71479	1	2015-04-22 00:00:00	n029	2015-04-22 00:00:00	N	T	15040219	GS00034452	52755	_	T	4049	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-04-27 00:00:00.000	335443	YY	2015-04-22 00:00:00	118690	 	NULL	NULL	NULL
71480	1	2015-04-22 00:00:00	n029	2015-04-22 00:00:00	N	T	15040214	GS00034453	52754	_	T	4049	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-04-27 00:00:00.000	335444	YY	2015-04-22 00:00:00	118691	 	NULL	NULL	NULL
71481	1	2015-04-22 00:00:00	n029	2015-04-22 00:00:00	N	T	15040218	GS00034454	52753	_	T	4049	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-04-27 00:00:00.000	335445	YY	2015-04-22 00:00:00	118692	 	NULL	NULL	NULL
71482	1	2015-04-22 00:00:00	n029	2015-04-22 00:00:00	N	T	15040213	GS00034455	52751	_	T	4049	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-04-27 00:00:00.000	335446	YY	2015-04-22 00:00:00	118693	 	NULL	NULL	NULL
71483	1	2015-04-22 00:00:00	n029	2015-04-22 00:00:00	N	T	15040217	GS00034456	38325	_	T	4049	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-04-27 00:00:00.000	335447	YY	2015-04-22 00:00:00	118694	 	NULL	NULL	NULL
71484	1	2015-04-22 00:00:00	n029	2015-04-22 00:00:00	N	T	15040216	GS00034457	52948	_	T	4049	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-04-27 00:00:00.000	335448	YY	2015-04-22 00:00:00	118695	 	NULL	NULL	NULL
71485	1	2015-04-22 00:00:00	n029	2015-04-22 00:00:00	N	T	15040212	GS00034458	38326	_	T	4049	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-04-27 00:00:00.000	335449	YY	2015-04-22 00:00:00	118696	 	NULL	NULL	NULL
71486	1	2015-04-22 00:00:00	n029	2015-04-22 00:00:00	N	T	15040215	GS00034459	52902	_	T	4049	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-04-27 00:00:00.000	335450	YY	2015-04-22 00:00:00	118697	 	NULL	NULL	NULL
71487	1	2015-04-22 08:51:00	n319	2015-04-22 00:00:00	N	P	15040223	GS15000976	27762	_	T	6808	n994	WA3	AN5	D	1000.00	1000.00	Y	2015-04-27 00:00:00.000	335430	YY	2015-04-22 00:00:00	162340	 	NULL	NULL	NULL
71488	1	2015-04-22 08:52:00	n319	2015-04-22 00:00:00	N	P	15030384	GS15000977	28448	_	T	15172	n1304	UG1	AA3	N	3000.00	3000.00	Y	2015-04-27 00:00:00.000	335431	YY	2015-04-22 00:00:00	162341	 	NULL	NULL	NULL
71489	1	2015-04-22 09:02:00	n319	2015-04-22 00:00:00	N	P	14100233	GS15000978	28084	_	T	15851	n1065	IG1E	AA21	N	9700.00	9700.00	Y	2015-04-27 00:00:00.000	335432	YY	2015-04-22 00:00:00	162342	 	NULL	NULL	NULL
71490	1	2015-04-22 09:07:00	n319	2015-04-22 00:00:00	N	P	15040226	GS15000979	24857	_	T	4837	n1489	WS1	AJ1	N	8500.00	8500.00	Y	2015-04-27 00:00:00.000	335433	YY	2015-04-22 00:00:00	162343	 	NULL	NULL	NULL
71491	1	2015-04-22 09:11:00	n319	2015-04-22 00:00:00	N	P	15040230	GS15000980	28147	_	T	15252	n1304	WS11	AJ2	N	6100.00	6100.00	Y	2015-04-27 00:00:00.000	335434	YY	2015-04-22 00:00:00	162344	 	NULL	NULL	NULL
71492	1	2015-04-22 09:30:00	n319	2015-04-22 00:00:00	N	P	15040231	GS15000981	26399	_	T	10747	n1065	AC2	AAD	N	2400.00	2400.00	Y	2015-04-27 00:00:00.000	335435	YY	2015-04-22 00:00:00	162348	 	NULL	NULL	NULL
71493	1	2015-04-22 00:00:00	n029	2015-04-23 00:00:00	N	T	15040226	GS00034460	65744	_	T	15819	n646	FF0	FF0	N	2500.00	2500.00	Y	2015-04-27 00:00:00.000	335458	YY	2015-04-23 00:00:00	118703	 	NULL	NULL	NULL
71494	1	2015-04-22 16:53:00	n319	2015-04-23 00:00:00	N	P	15030190	GS15000982	28408	_	T	15951	n113	UG1	AA3	N	3000.00	3000.00	Y	2015-04-27 00:00:00.000	335451	YY	2015-04-23 00:00:00	162446	 	NULL	NULL	NULL
71495	1	2015-04-22 17:18:00	n319	2015-04-23 00:00:00	N	P	15040245	GS15000983	27664	_	T	4436	n113	WA3	AN5	D	2000.00	2000.00	Y	2015-04-27 00:00:00.000	335452	YY	2015-04-23 00:00:00	162447	 	NULL	NULL	NULL
71496	1	2015-04-22 17:19:00	n319	2015-04-23 00:00:00	N	P	15040238	GS15000984	27866	_	T	3570	n1489	WS1	AJ1	N	1800.00	1800.00	Y	2015-04-27 00:00:00.000	335453	YY	2015-04-23 00:00:00	162448	 	NULL	NULL	NULL
71497	1	2015-04-22 17:23:00	n319	2015-04-23 00:00:00	N	P	15040246	GS15000986	28011	_	T	4436	n113	WA3	AN5	D	2000.00	2000.00	Y	2015-04-27 00:00:00.000	335454	YY	2015-04-23 00:00:00	162450	 	NULL	NULL	NULL
71498	1	2015-04-22 17:25:00	n319	2015-04-23 00:00:00	N	P	15040220	GS15000987	28405	_	T	3554	n896	WA3	AN5	D	1000.00	1000.00	Y	2015-04-27 00:00:00.000	335455	YY	2015-04-23 00:00:00	162451	 	NULL	NULL	NULL
71499	1	2015-04-23 00:00:00	n029	2015-04-23 00:00:00	N	T	15040238	GS00034461	65846	_	T	15628	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-04-27 00:00:00.000	335459	YY	2015-04-23 00:00:00	118730	 	NULL	NULL	NULL
71500	1	2015-04-23 00:00:00	n029	2015-04-23 00:00:00	N	T	15040239	GS00034462	65847	_	T	15628	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-04-27 00:00:00.000	335460	YY	2015-04-23 00:00:00	118731	 	NULL	NULL	NULL
71501	1	2015-04-23 09:02:00	n087	2015-04-23 00:00:00	N	P	15040244	GS15000991	28103	_	T	15609	n1065	WS11	AJ2	N	2700.00	2700.00	Y	2015-04-27 00:00:00.000	335456	YY	2015-04-23 00:00:00	162477	 	NULL	NULL	NULL
71502	1	2015-04-23 09:19:00	n087	2015-04-23 00:00:00	N	P	15030298	GS15000993	28441	_	T	15390	n994	UG1	AA3	N	3000.00	3000.00	Y	2015-04-27 00:00:00.000	335457	YY	2015-04-23 00:00:00	162479	 	NULL	NULL	NULL
71503	1	2015-04-23 00:00:00	n029	2015-04-24 00:00:00	N	T	15040242	GS00034465	66397	_	T	7654	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-04-28 00:00:00.000	335613	YY	2015-04-24 00:00:00	118759	 	NULL	NULL	NULL
71504	1	2015-04-23 00:00:00	n029	2015-04-24 00:00:00	N	T	15040234	GS00034466	66394	_	T	14445	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-04-28 00:00:00.000	335614	YY	2015-04-24 00:00:00	118760	 	NULL	NULL	NULL
71505	1	2015-04-23 00:00:00	n029	2015-04-24 00:00:00	N	T	15040235	GS00034467	66395	_	T	14445	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-04-28 00:00:00.000	335615	YY	2015-04-24 00:00:00	118761	 	NULL	NULL	NULL
71506	1	2015-04-23 00:00:00	n029	2015-04-24 00:00:00	N	T	15040236	GS00034468	66396	_	T	14445	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-04-28 00:00:00.000	335616	YY	2015-04-24 00:00:00	118762	 	NULL	NULL	NULL
71507	1	2015-04-23 00:00:00	n029	2015-04-24 00:00:00	N	T	15040247	GS00034469	65981	_	T	13211	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-04-28 00:00:00.000	335617	YY	2015-04-24 00:00:00	118779	 	NULL	NULL	NULL
71508	1	2015-04-23 00:00:00	n029	2015-04-24 00:00:00	N	T	15040248	GS00034470	65982	_	T	13211	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-04-28 00:00:00.000	335618	YY	2015-04-24 00:00:00	118780	 	NULL	NULL	NULL
71509	1	2015-04-23 00:00:00	n029	2015-04-24 00:00:00	N	T	15040251	GS00034471	65484	_	T	827	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-04-28 00:00:00.000	335619	YY	2015-04-24 00:00:00	118783	 	NULL	NULL	NULL
71510	1	2015-04-23 00:00:00	n029	2015-04-24 00:00:00	N	T	15040249	GS00034472	65427	_	T	13344	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-04-28 00:00:00.000	335620	YY	2015-04-24 00:00:00	118815	 	NULL	NULL	NULL
71511	1	2015-04-23 00:00:00	n029	2015-04-24 00:00:00	N	T	15040250	GS00034473	65428	_	T	13344	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-04-28 00:00:00.000	335621	YY	2015-04-24 00:00:00	118816	 	NULL	NULL	NULL
71512	1	2015-04-24 08:55:00	n319	2015-04-24 00:00:00	N	P	15040250	GS15000995	1179	M	T	15548	n113	AC2	AAD	X	800.00	800.00	Y	2015-04-28 00:00:00.000	335605	YY	2015-04-24 00:00:00	162598	 	NULL	NULL	NULL
71513	1	2015-04-24 08:58:00	n319	2015-04-24 00:00:00	N	P	15040248	GS15000997	27474	_	T	12406	n650	WS11	AJ2	N	6100.00	6100.00	Y	2015-04-28 00:00:00.000	335606	YY	2015-04-24 00:00:00	162600	 	NULL	NULL	NULL
71514	1	2015-04-24 09:07:00	n319	2015-04-24 00:00:00	N	P	14120380	GS15000999	28247	_	T	15906	n1304	IG1E	AA2	N	10500.00	10500.00	Y	2015-04-28 00:00:00.000	335607	YY	2015-04-24 00:00:00	162602	 	NULL	NULL	NULL
71515	1	2015-04-24 09:08:00	n319	2015-04-24 00:00:00	N	P	14120381	GS15001000	28248	_	T	15906	n1304	UG1	AA3	N	3000.00	3000.00	Y	2015-04-28 00:00:00.000	335608	YY	2015-04-24 00:00:00	162603	 	NULL	NULL	NULL
71516	1	2015-04-24 09:11:00	n319	2015-04-24 00:00:00	N	P	15030018	GS15001001	28384	_	T	13472	n1304	IG1B	AA21	N	9700.00	9700.00	Y	2015-04-28 00:00:00.000	335609	YY	2015-04-24 00:00:00	162604	 	NULL	NULL	NULL
71517	1	2015-04-24 09:13:00	n319	2015-04-24 00:00:00	N	P	15030062	GS15001002	28390	_	T	15942	n113	IG1E	AA2	N	10500.00	10500.00	Y	2015-04-28 00:00:00.000	335610	YY	2015-04-24 00:00:00	162605	 	NULL	NULL	NULL
71518	1	2015-04-24 09:15:00	n319	2015-04-24 00:00:00	N	P	15030063	GS15001003	28391	_	T	15942	n113	UG1	AA3	N	3000.00	3000.00	Y	2015-04-28 00:00:00.000	335611	YY	2015-04-24 00:00:00	162606	 	NULL	NULL	NULL
71519	1	2015-04-24 09:16:00	n319	2015-04-24 00:00:00	N	P	14110158	GS15001004	28145	_	T	13124	n1304	IG1E	AA1	N	3500.00	3500.00	Y	2015-04-28 00:00:00.000	335612	YY	2015-04-24 00:00:00	162607	 	NULL	NULL	NULL
71520	1	2015-04-24 15:52:00	n319	2015-04-27 00:00:00	N	P	14090385	GS15001009	28054	_	T	11997	n1486	IG1E	AA2	N	10500.00	10500.00	Y	2015-04-28 00:00:00.000	335622	YY	2015-04-27 00:00:00	162716	 	NULL	NULL	NULL
71521	1	2015-04-27 00:00:00	n029	2015-04-27 00:00:00	N	T	15040243	GS00034474	66398	_	T	1705	n428	DO1	DO1	N	4000.00	4000.00	Y	2015-04-28 00:00:00.000	335625	YY	2015-04-27 00:00:00	118853	 	NULL	NULL	NULL
71522	1	2015-04-27 00:00:00	n029	2015-04-27 00:00:00	N	T	15040254	GS00034476	66399	_	T	13271	n646	FE1	FE1	N	2400.00	2400.00	Y	2015-04-28 00:00:00.000	335626	YE	2015-04-27 00:00:00	118856	 	NULL	NULL	NULL
71523	1	2015-04-27 00:00:00	n029	2015-04-27 00:00:00	N	T	15040253	GS00034477	66400	_	T	7701	n646	FE1	FE1	N	11100.00	11100.00	Y	2015-04-28 00:00:00.000	335627	YE	2015-04-27 00:00:00	118857	 	NULL	NULL	NULL
71524	1	2015-04-27 09:06:00	n319	2015-04-27 00:00:00	N	P	15040255	GS15001012	28288	_	T	13225	n896	WS11	AJ2	N	6100.00	6100.00	Y	2015-04-28 00:00:00.000	335623	YY	2015-04-27 00:00:00	162722	 	NULL	NULL	NULL
71540	1	2015-04-27 09:37:00	n319	2015-04-27 00:00:00	N	P	15010291	GS15001014	28328	_	T	15924	n896	UG1	AA3	N	3000.00	3000.00	Y	2015-04-28 00:00:00.000	335624	YY	2015-04-27 00:00:00	162724	 	NULL	NULL	NULL
71571	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040255	GS00034478	66401	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336141	YE	2015-04-29 00:00:00	118858	 	NULL	NULL	NULL
71572	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040256	GS00034479	66402	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336142	YE	2015-04-29 00:00:00	118859	 	NULL	NULL	NULL
71573	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040257	GS00034480	66403	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336143	YE	2015-04-29 00:00:00	118860	 	NULL	NULL	NULL
71574	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040258	GS00034481	66404	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336144	YE	2015-04-29 00:00:00	118861	 	NULL	NULL	NULL
71575	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040389	GS00034522	66445	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336145	YE	2015-04-29 00:00:00	118902	 	NULL	NULL	NULL
71576	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040279	GS00034502	66425	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336146	YE	2015-04-29 00:00:00	118882	 	NULL	NULL	NULL
71577	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040280	GS00034503	66426	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336147	YE	2015-04-29 00:00:00	118883	 	NULL	NULL	NULL
71578	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040281	GS00034504	66427	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336148	YE	2015-04-29 00:00:00	118884	 	NULL	NULL	NULL
71579	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040282	GS00034505	66428	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336149	YE	2015-04-29 00:00:00	118885	 	NULL	NULL	NULL
71580	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040283	GS00034506	66429	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336150	YE	2015-04-29 00:00:00	118886	 	NULL	NULL	NULL
71581	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040284	GS00034507	66430	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336151	YE	2015-04-29 00:00:00	118887	 	NULL	NULL	NULL
71582	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040285	GS00034508	66431	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336152	YE	2015-04-29 00:00:00	118888	 	NULL	NULL	NULL
71583	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040286	GS00034509	66432	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336153	YE	2015-04-29 00:00:00	118889	 	NULL	NULL	NULL
71584	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040287	GS00034510	66433	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336154	YE	2015-04-29 00:00:00	118890	 	NULL	NULL	NULL
71585	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040288	GS00034511	66434	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336155	YE	2015-04-29 00:00:00	118891	 	NULL	NULL	NULL
71586	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040379	GS00034512	66435	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336156	YE	2015-04-29 00:00:00	118892	 	NULL	NULL	NULL
71587	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040380	GS00034513	66436	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336157	YE	2015-04-29 00:00:00	118893	 	NULL	NULL	NULL
71588	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040381	GS00034514	66437	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336158	YE	2015-04-29 00:00:00	118894	 	NULL	NULL	NULL
71589	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040382	GS00034515	66438	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336159	YE	2015-04-29 00:00:00	118895	 	NULL	NULL	NULL
71590	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040383	GS00034516	66439	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336160	YE	2015-04-29 00:00:00	118896	 	NULL	NULL	NULL
71591	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040384	GS00034517	66440	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336161	YE	2015-04-29 00:00:00	118897	 	NULL	NULL	NULL
71592	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040385	GS00034518	66441	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336162	YE	2015-04-29 00:00:00	118898	 	NULL	NULL	NULL
71593	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040386	GS00034519	66442	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336163	YE	2015-04-29 00:00:00	118899	 	NULL	NULL	NULL
71594	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040387	GS00034520	66443	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336164	YE	2015-04-29 00:00:00	118900	 	NULL	NULL	NULL
71595	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040388	GS00034521	66444	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336165	YE	2015-04-29 00:00:00	118901	 	NULL	NULL	NULL
71596	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040266	GS00034489	66412	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336166	YE	2015-04-29 00:00:00	118869	 	NULL	NULL	NULL
71597	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040265	GS00034488	66411	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336167	YE	2015-04-29 00:00:00	118868	 	NULL	NULL	NULL
71598	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040264	GS00034487	66410	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336168	YE	2015-04-29 00:00:00	118867	 	NULL	NULL	NULL
71599	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040259	GS00034482	66405	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336169	YE	2015-04-29 00:00:00	118862	 	NULL	NULL	NULL
71600	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040278	GS00034501	66424	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336170	YE	2015-04-29 00:00:00	118881	 	NULL	NULL	NULL
71601	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040277	GS00034500	66423	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336171	YE	2015-04-29 00:00:00	118880	 	NULL	NULL	NULL
71602	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040260	GS00034483	66406	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336172	YE	2015-04-29 00:00:00	118863	 	NULL	NULL	NULL
71603	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040261	GS00034484	66407	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336173	YE	2015-04-29 00:00:00	118864	 	NULL	NULL	NULL
71604	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040262	GS00034485	66408	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336174	YE	2015-04-29 00:00:00	118865	 	NULL	NULL	NULL
71605	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040263	GS00034486	66409	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336175	YE	2015-04-29 00:00:00	118866	 	NULL	NULL	NULL
71606	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040267	GS00034490	66413	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336176	YE	2015-04-29 00:00:00	118870	 	NULL	NULL	NULL
71607	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040268	GS00034491	66414	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336177	YE	2015-04-29 00:00:00	118871	 	NULL	NULL	NULL
71608	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040276	GS00034499	66422	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336178	YE	2015-04-29 00:00:00	118879	 	NULL	NULL	NULL
71609	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040275	GS00034498	66421	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336179	YE	2015-04-29 00:00:00	118878	 	NULL	NULL	NULL
71610	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040274	GS00034497	66420	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336180	YE	2015-04-29 00:00:00	118877	 	NULL	NULL	NULL
71611	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040273	GS00034496	66419	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336181	YE	2015-04-29 00:00:00	118876	 	NULL	NULL	NULL
71612	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040271	GS00034494	66417	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336182	YE	2015-04-29 00:00:00	118874	 	NULL	NULL	NULL
71613	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040269	GS00034492	66415	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336183	YE	2015-04-29 00:00:00	118872	 	NULL	NULL	NULL
71614	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040270	GS00034493	66416	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336184	YE	2015-04-29 00:00:00	118873	 	NULL	NULL	NULL
71615	1	2015-04-27 00:00:00	n029	2015-04-29 00:00:00	N	T	15040272	GS00034495	66418	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336185	YE	2015-04-29 00:00:00	118875	 	NULL	NULL	NULL
71616	1	2015-04-27 16:00:00	n319	2015-04-28 00:00:00	N	P	15040279	GS15001016	26853	_	T	2853	n100	WS1	AJ1	N	8500.00	8500.00	Y	2015-04-30 00:00:00.000	336124	YY	2015-04-28 00:00:00	162825	 	NULL	NULL	NULL
71617	1	2015-04-27 16:01:00	n319	2015-04-28 00:00:00	N	P	15040256	GS15001017	27781	_	T	15753	n1486	WA3	AN5	D	1000.00	1000.00	Y	2015-04-30 00:00:00.000	336125	YY	2015-04-28 00:00:00	162827	 	NULL	NULL	NULL
71618	1	2015-04-27 16:03:00	n319	2015-04-28 00:00:00	N	P	15040280	GS15001018	28094	_	T	15785	n113	WS11	AJ2	N	6100.00	6100.00	Y	2015-04-30 00:00:00.000	336126	YY	2015-04-28 00:00:00	162828	 	NULL	NULL	NULL
71619	1	2015-04-28 00:00:00	n029	2015-04-28 00:00:00	N	T	15040390	GS00034524	66537	_	T	16020	n824	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336135	YE	2015-04-28 00:00:00	118961	 	NULL	NULL	NULL
71620	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040323	GS00034525	66491	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336186	YE	2015-04-29 00:00:00	118962	 	NULL	NULL	NULL
71621	1	2015-04-28 00:00:00	n029	2015-04-28 00:00:00	N	T	15040405	GS00034526	65483	_	T	13894	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-04-30 00:00:00.000	336136	YY	2015-04-28 00:00:00	118964	 	NULL	NULL	NULL
71622	1	2015-04-28 08:45:00	n319	2015-04-28 00:00:00	N	P	15030203	GS15001020	26681	_	T	7683	n650	RR1	AAK	N	1000.00	1000.00	Y	2015-04-30 00:00:00.000	336127	YY	2015-04-28 00:00:00	162846	 	NULL	NULL	NULL
71623	1	2015-04-28 08:50:00	n319	2015-04-28 00:00:00	N	P	15010075	GS15001022	28284	_	T	15336	n1125	IG1E	AA2	N	10500.00	10500.00	Y	2015-04-30 00:00:00.000	336128	YY	2015-04-28 00:00:00	162850	 	NULL	NULL	NULL
71624	1	2015-04-28 08:54:00	n319	2015-04-28 00:00:00	N	P	15010241	GS15001023	28321	_	T	15196	n650	IG1E	AA2	N	11300.00	11300.00	Y	2015-04-30 00:00:00.000	336129	YY	2015-04-28 00:00:00	162851	 	NULL	NULL	NULL
71625	1	2015-04-28 09:05:00	n319	2015-04-28 00:00:00	N	P	15040291	GS15001024	25532	_	T	10747	n1065	WS1	AJ1	N	8500.00	8500.00	Y	2015-04-30 00:00:00.000	336130	YY	2015-04-28 00:00:00	162852	 	NULL	NULL	NULL
71626	1	2015-04-28 09:07:00	n319	2015-04-28 00:00:00	N	P	15040289	GS15001026	28193	_	T	15892	n1065	WS11	AJ2	N	2700.00	2700.00	Y	2015-04-30 00:00:00.000	336131	YY	2015-04-28 00:00:00	162854	 	NULL	NULL	NULL
71627	1	2015-04-28 00:00:00	n029	2015-04-28 00:00:00	N	T	15040401	GS00034527	66538	_	T	13211	n428	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336137	YE	2015-04-28 00:00:00	118967	 	NULL	NULL	NULL
71628	1	2015-04-28 09:38:00	n319	2015-04-28 00:00:00	N	P	15040295	GS15001029	1135	M	T	12293	n113	IGEA	AA6	X	7000.00	7000.00	Y	2015-04-30 00:00:00.000	336132	YY	2015-04-28 00:00:00	162859	 	NULL	NULL	NULL
71629	1	2015-04-28 09:42:00	n319	2015-04-28 00:00:00	N	P	15040288	GS15001030	25267	_	T	13712	n896	WS1	AJ1	N	3500.00	3500.00	Y	2015-04-30 00:00:00.000	336133	YY	2015-04-28 00:00:00	162860	 	NULL	NULL	NULL
71630	1	2015-04-28 09:43:00	n319	2015-04-28 00:00:00	N	P	15040285	GS15001031	1101	M	T	14599	n113	WS2	AK2	X	2500.00	2500.00	Y	2015-04-30 00:00:00.000	336134	YE	2015-04-28 00:00:00	162862	 	NULL	NULL	NULL
71631	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040324	GS00034529	66492	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336187	YE	2015-04-29 00:00:00	118971	 	NULL	NULL	NULL
71632	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040325	GS00034530	66493	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336188	YE	2015-04-29 00:00:00	118972	 	NULL	NULL	NULL
71633	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040326	GS00034531	66494	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336189	YE	2015-04-29 00:00:00	118973	 	NULL	NULL	NULL
71634	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040327	GS00034532	66495	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336190	YE	2015-04-29 00:00:00	118974	 	NULL	NULL	NULL
71635	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040328	GS00034533	66496	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336191	YE	2015-04-29 00:00:00	118984	 	NULL	NULL	NULL
71636	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040329	GS00034534	66497	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336192	YE	2015-04-29 00:00:00	118987	 	NULL	NULL	NULL
71637	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040330	GS00034535	66498	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336193	YE	2015-04-29 00:00:00	118988	 	NULL	NULL	NULL
71638	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040331	GS00034536	66499	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336194	YE	2015-04-29 00:00:00	118989	 	NULL	NULL	NULL
71639	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040332	GS00034537	66500	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336195	YE	2015-04-29 00:00:00	118990	 	NULL	NULL	NULL
71640	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040333	GS00034538	66501	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336196	YE	2015-04-29 00:00:00	118991	 	NULL	NULL	NULL
71641	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040334	GS00034539	66502	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336197	YE	2015-04-29 00:00:00	118992	 	NULL	NULL	NULL
71642	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040335	GS00034540	66503	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336198	YE	2015-04-29 00:00:00	118993	 	NULL	NULL	NULL
71643	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040336	GS00034541	66504	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336199	YE	2015-04-29 00:00:00	118994	 	NULL	NULL	NULL
71644	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040337	GS00034542	66505	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336200	YE	2015-04-29 00:00:00	118995	 	NULL	NULL	NULL
71645	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040338	GS00034543	66506	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336201	YE	2015-04-29 00:00:00	118996	 	NULL	NULL	NULL
71646	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040339	GS00034544	66507	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336202	YE	2015-04-29 00:00:00	118997	 	NULL	NULL	NULL
71647	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040340	GS00034545	66508	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336203	YE	2015-04-29 00:00:00	118998	 	NULL	NULL	NULL
71648	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040341	GS00034546	66509	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336204	YE	2015-04-29 00:00:00	118999	 	NULL	NULL	NULL
71649	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040342	GS00034547	66510	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336205	YE	2015-04-29 00:00:00	119000	 	NULL	NULL	NULL
71650	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040343	GS00034548	66511	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336206	YE	2015-04-29 00:00:00	119001	 	NULL	NULL	NULL
71651	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040344	GS00034549	66512	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336207	YE	2015-04-29 00:00:00	119002	 	NULL	NULL	NULL
71652	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040345	GS00034550	66513	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336208	YE	2015-04-29 00:00:00	119003	 	NULL	NULL	NULL
71653	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040346	GS00034551	66514	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336209	YE	2015-04-29 00:00:00	119004	 	NULL	NULL	NULL
71654	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040347	GS00034552	66515	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336210	YE	2015-04-29 00:00:00	119006	 	NULL	NULL	NULL
71655	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040348	GS00034553	66516	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336211	YE	2015-04-29 00:00:00	119009	 	NULL	NULL	NULL
71656	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040349	GS00034554	66517	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336212	YE	2015-04-29 00:00:00	119011	 	NULL	NULL	NULL
71657	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040350	GS00034555	66518	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336213	YE	2015-04-29 00:00:00	119092	 	NULL	NULL	NULL
71658	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040351	GS00034556	66519	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336214	YE	2015-04-29 00:00:00	119098	 	NULL	NULL	NULL
71659	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040352	GS00034557	66520	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336215	YE	2015-04-29 00:00:00	119099	 	NULL	NULL	NULL
71660	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040353	GS00034558	66521	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336216	YE	2015-04-29 00:00:00	119100	 	NULL	NULL	NULL
71661	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040354	GS00034559	66522	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336217	YE	2015-04-29 00:00:00	119101	 	NULL	NULL	NULL
71662	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040355	GS00034560	66523	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336218	YE	2015-04-29 00:00:00	119102	 	NULL	NULL	NULL
71663	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040356	GS00034561	66524	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336219	YE	2015-04-29 00:00:00	119103	 	NULL	NULL	NULL
71664	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040357	GS00034562	66525	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336220	YE	2015-04-29 00:00:00	119104	 	NULL	NULL	NULL
71665	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040358	GS00034563	66526	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336221	YE	2015-04-29 00:00:00	119105	 	NULL	NULL	NULL
71666	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040359	GS00034564	66527	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336222	YE	2015-04-29 00:00:00	119106	 	NULL	NULL	NULL
71667	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040360	GS00034565	66528	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336223	YE	2015-04-29 00:00:00	119107	 	NULL	NULL	NULL
71668	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040361	GS00034566	66529	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336224	YE	2015-04-29 00:00:00	119108	 	NULL	NULL	NULL
71669	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040362	GS00034567	66530	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336225	YE	2015-04-29 00:00:00	119109	 	NULL	NULL	NULL
71670	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040363	GS00034568	66531	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336226	YE	2015-04-29 00:00:00	119110	 	NULL	NULL	NULL
71671	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040364	GS00034569	66532	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336227	YE	2015-04-29 00:00:00	119111	 	NULL	NULL	NULL
71672	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040365	GS00034570	66533	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336228	YE	2015-04-29 00:00:00	119113	 	NULL	NULL	NULL
71673	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040366	GS00034571	66534	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336229	YE	2015-04-29 00:00:00	119114	 	NULL	NULL	NULL
71674	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040367	GS00034572	66535	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336230	YE	2015-04-29 00:00:00	119115	 	NULL	NULL	NULL
71675	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040289	GS00034573	66446	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336231	YE	2015-04-29 00:00:00	119123	 	NULL	NULL	NULL
71676	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040290	GS00034574	66447	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336232	YE	2015-04-29 00:00:00	119124	 	NULL	NULL	NULL
71677	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040291	GS00034575	66448	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336233	YE	2015-04-29 00:00:00	119125	 	NULL	NULL	NULL
71678	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040292	GS00034576	66449	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336234	YE	2015-04-29 00:00:00	119126	 	NULL	NULL	NULL
71679	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040293	GS00034577	66450	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336235	YE	2015-04-29 00:00:00	119127	 	NULL	NULL	NULL
71680	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040294	GS00034578	66451	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336236	YE	2015-04-29 00:00:00	119128	 	NULL	NULL	NULL
71681	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040295	GS00034579	66452	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336237	YE	2015-04-29 00:00:00	119129	 	NULL	NULL	NULL
71682	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040296	GS00034580	66453	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336238	YE	2015-04-29 00:00:00	119130	 	NULL	NULL	NULL
71683	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040297	GS00034581	66454	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336239	YE	2015-04-29 00:00:00	119131	 	NULL	NULL	NULL
71684	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040298	GS00034582	66455	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336240	YE	2015-04-29 00:00:00	119132	 	NULL	NULL	NULL
71685	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040299	GS00034583	66456	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336241	YE	2015-04-29 00:00:00	119133	 	NULL	NULL	NULL
71686	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040300	GS00034584	66457	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336242	YE	2015-04-29 00:00:00	119134	 	NULL	NULL	NULL
71687	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040301	GS00034585	66458	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336243	YE	2015-04-29 00:00:00	119135	 	NULL	NULL	NULL
71688	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040302	GS00034586	66459	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336244	YE	2015-04-29 00:00:00	119136	 	NULL	NULL	NULL
71689	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040303	GS00034587	66460	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336245	YE	2015-04-29 00:00:00	119137	 	NULL	NULL	NULL
71690	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040304	GS00034588	66461	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336246	YE	2015-04-29 00:00:00	119138	 	NULL	NULL	NULL
71691	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040305	GS00034589	66462	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336247	YE	2015-04-29 00:00:00	119139	 	NULL	NULL	NULL
71692	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040306	GS00034590	66463	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336248	YE	2015-04-29 00:00:00	119140	 	NULL	NULL	NULL
71693	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040307	GS00034591	66464	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336249	YE	2015-04-29 00:00:00	119141	 	NULL	NULL	NULL
71694	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040308	GS00034592	66465	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336250	YE	2015-04-29 00:00:00	119142	 	NULL	NULL	NULL
71695	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040309	GS00034593	66466	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336251	YE	2015-04-29 00:00:00	119143	 	NULL	NULL	NULL
71696	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040310	GS00034594	66467	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336252	YE	2015-04-29 00:00:00	119144	 	NULL	NULL	NULL
71697	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040311	GS00034595	66468	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336253	YE	2015-04-29 00:00:00	119145	 	NULL	NULL	NULL
71698	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040312	GS00034596	66469	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336254	YE	2015-04-29 00:00:00	119146	 	NULL	NULL	NULL
71699	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040313	GS00034597	66470	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336255	YE	2015-04-29 00:00:00	119147	 	NULL	NULL	NULL
71700	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040314	GS00034598	66471	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336256	YE	2015-04-29 00:00:00	119148	 	NULL	NULL	NULL
71701	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040315	GS00034599	66472	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336257	YE	2015-04-29 00:00:00	119149	 	NULL	NULL	NULL
71702	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040316	GS00034600	66473	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336258	YE	2015-04-29 00:00:00	119150	 	NULL	NULL	NULL
71703	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040317	GS00034601	66474	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336259	YE	2015-04-29 00:00:00	119151	 	NULL	NULL	NULL
71704	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040318	GS00034602	66475	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336260	YE	2015-04-29 00:00:00	119152	 	NULL	NULL	NULL
71705	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040319	GS00034603	66476	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336261	YE	2015-04-29 00:00:00	119153	 	NULL	NULL	NULL
71706	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040320	GS00034604	66477	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336262	YE	2015-04-29 00:00:00	119154	 	NULL	NULL	NULL
71707	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040321	GS00034605	66478	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336263	YE	2015-04-29 00:00:00	119155	 	NULL	NULL	NULL
71708	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040322	GS00034606	66479	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336264	YE	2015-04-29 00:00:00	119156	 	NULL	NULL	NULL
71709	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040369	GS00034607	66481	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336265	YE	2015-04-29 00:00:00	119157	 	NULL	NULL	NULL
71710	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040370	GS00034608	66482	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336266	YE	2015-04-29 00:00:00	119158	 	NULL	NULL	NULL
71711	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040371	GS00034609	66483	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336267	YE	2015-04-29 00:00:00	119159	 	NULL	NULL	NULL
71712	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040372	GS00034610	66484	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336268	YE	2015-04-29 00:00:00	119160	 	NULL	NULL	NULL
71713	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040373	GS00034611	66485	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336269	YE	2015-04-29 00:00:00	119161	 	NULL	NULL	NULL
71714	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040376	GS00034612	66488	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336270	YE	2015-04-29 00:00:00	119162	 	NULL	NULL	NULL
71715	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040377	GS00034613	66489	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336271	YE	2015-04-29 00:00:00	119163	 	NULL	NULL	NULL
71716	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040378	GS00034614	66490	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336272	YE	2015-04-29 00:00:00	119164	 	NULL	NULL	NULL
71717	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040375	GS00034615	66487	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336273	YE	2015-04-29 00:00:00	119165	 	NULL	NULL	NULL
71718	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040374	GS00034616	66486	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336274	YE	2015-04-29 00:00:00	119166	 	NULL	NULL	NULL
71719	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040368	GS00034617	66480	_	T	13826	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-04-30 00:00:00.000	336275	YE	2015-04-29 00:00:00	119167	 	NULL	NULL	NULL
71720	1	2015-04-28 15:49:00	n319	2015-04-29 00:00:00	N	P	14080177	GS15001033	27916	_	T	15791	n1125	IG1E	AA2	N	10500.00	10500.00	Y	2015-04-30 00:00:00.000	336138	YY	2015-04-29 00:00:00	163189	 	NULL	NULL	NULL
71721	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040403	GS00034618	66539	_	T	16029	n428	FE1	FE1	N	7800.00	7800.00	Y	2015-04-30 00:00:00.000	336276	YE	2015-04-29 00:00:00	119177	 	NULL	NULL	NULL
71722	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040404	GS00034619	66540	_	T	16029	n428	FE1	FE1	N	7800.00	7800.00	Y	2015-04-30 00:00:00.000	336277	YE	2015-04-29 00:00:00	119178	 	NULL	NULL	NULL
71723	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040424	GS00034621	65612	_	T	15771	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-04-30 00:00:00.000	336278	YY	2015-04-29 00:00:00	119180	 	NULL	NULL	NULL
71724	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040423	GS00034622	65613	_	T	15771	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-04-30 00:00:00.000	336279	YY	2015-04-29 00:00:00	119181	 	NULL	NULL	NULL
71725	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040425	GS00034623	65614	_	T	15771	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-04-30 00:00:00.000	336280	YY	2015-04-29 00:00:00	119182	 	NULL	NULL	NULL
71726	1	2015-04-28 00:00:00	n029	2015-04-29 00:00:00	N	T	15040426	GS00034624	65615	_	T	15771	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-04-30 00:00:00.000	336281	YY	2015-04-29 00:00:00	119183	 	NULL	NULL	NULL
71727	1	2015-04-29 00:00:00	n029	2015-04-29 00:00:00	N	T	15040402	GS00034625	66541	_	T	806	n441	FE11	FE11	N	2700.00	2700.00	Y	2015-04-30 00:00:00.000	336282	YE	2015-04-29 00:00:00	119190	 	NULL	NULL	NULL
71728	1	2015-04-29 08:51:00	n319	2015-04-29 00:00:00	N	P	15010200	GS15001034	28300	_	T	11997	n1486	IG1E	AA2	N	10500.00	10500.00	Y	2015-04-30 00:00:00.000	336139	YY	2015-04-29 00:00:00	163196	 	NULL	NULL	NULL
71729	1	2015-04-29 09:38:00	n319	2015-04-29 00:00:00	N	P	15040297	GS15001035	26074	_	T	13472	n1304	WS1	AJ1	N	8500.00	8500.00	Y	2015-04-30 00:00:00.000	336140	YY	2015-04-29 00:00:00	163197	 	NULL	NULL	NULL
71730	1	2015-04-29 00:00:00	n029	2015-04-30 00:00:00	N	T	15040443	GS00034626	65850	_	T	11861	n646	FF0	FF0	N	5000.00	5000.00	Y	2015-05-06 00:00:00.000	336743	YY	2015-04-30 00:00:00	119225	 	NULL	NULL	NULL
71731	1	2015-04-29 00:00:00	n029	2015-04-30 00:00:00	N	T	15040432	GS00034627	64312	_	T	15494	n646	FF0	FF0	N	2500.00	2500.00	Y	2015-05-06 00:00:00.000	336744	YY	2015-04-30 00:00:00	119226	 	NULL	NULL	NULL
71732	1	2015-04-29 00:00:00	n029	2015-04-30 00:00:00	N	T	15040431	GS00034628	52234	_	T	12907	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-05-06 00:00:00.000	336745	YY	2015-04-30 00:00:00	119227	 	NULL	NULL	NULL
71733	1	2015-04-29 00:00:00	n029	2015-04-30 00:00:00	N	T	15040428	GS00034629	52410	_	T	2157	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-05-06 00:00:00.000	336746	YY	2015-04-30 00:00:00	119228	 	NULL	NULL	NULL
71734	1	2015-04-29 00:00:00	n029	2015-04-30 00:00:00	N	T	15040429	GS00034630	52794	_	T	13031	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-05-06 00:00:00.000	336747	YY	2015-04-30 00:00:00	119229	 	NULL	NULL	NULL
71735	1	2015-04-29 00:00:00	n029	2015-04-30 00:00:00	N	T	15040430	GS00034631	52795	_	T	13031	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-05-06 00:00:00.000	336748	YY	2015-04-30 00:00:00	119230	 	NULL	NULL	NULL
71736	1	2015-04-29 16:58:00	n319	2015-04-30 00:00:00	N	P	15040061	GS15001036	28461	_	T	15589	n1486	DG1	AA4	N	3000.00	3000.00	Y	2015-05-06 00:00:00.000	336733	YY	2015-04-30 00:00:00	163603	 	NULL	NULL	NULL
71737	1	2015-04-29 17:23:00	n319	2015-04-30 00:00:00	N	P	15040323	GS15001037	25903	_	T	7900	n650	WS21	AK3	N	8400.00	8400.00	Y	2015-05-06 00:00:00.000	336734	YY	2015-04-30 00:00:00	163606	 	NULL	NULL	NULL
71738	1	2015-04-30 00:00:00	n029	2015-04-30 00:00:00	N	T	15040441	GS00034635	66548	_	T	14476	n428	FE1	FE1	N	5100.00	5100.00	Y	2015-05-06 00:00:00.000	336749	YE	2015-04-30 00:00:00	119246	 	NULL	NULL	NULL
71739	1	2015-04-30 00:00:00	n029	2015-04-30 00:00:00	N	T	15040451	GS00034636	66550	_	T	13920	n824	FE1	FE1	N	2400.00	2400.00	Y	2015-05-06 00:00:00.000	336750	YE	2015-04-30 00:00:00	119249	 	NULL	NULL	NULL
71740	1	2015-04-30 00:00:00	n029	2015-04-30 00:00:00	N	T	15040434	GS00034637	66545	_	T	14656	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-05-06 00:00:00.000	336751	YE	2015-04-30 00:00:00	119250	 	NULL	NULL	NULL
71741	1	2015-04-30 08:47:00	n319	2015-04-30 00:00:00	N	P	14120398	GS15001040	28251	_	T	13472	n1304	UG1	AA3	N	3000.00	3000.00	Y	2015-05-06 00:00:00.000	336735	YY	2015-04-30 00:00:00	163609	 	NULL	NULL	NULL
71742	1	2015-04-30 00:00:00	n029	2015-04-30 00:00:00	N	T	15040433	GS00034638	66544	_	T	7759	n547	FE1	FE1	N	5400.00	5400.00	Y	2015-05-06 00:00:00.000	336752	YE	2015-04-30 00:00:00	119251	 	NULL	NULL	NULL
71743	1	2015-04-30 00:00:00	n029	2015-04-30 00:00:00	N	T	15040437	GS00034639	66542	_	T	16025	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-05-06 00:00:00.000	336753	YE	2015-04-30 00:00:00	119252	 	NULL	NULL	NULL
71744	1	2015-04-30 00:00:00	n029	2015-04-30 00:00:00	N	T	15040438	GS00034640	66543	_	T	16025	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-05-06 00:00:00.000	336754	YE	2015-04-30 00:00:00	119253	 	NULL	NULL	NULL
71745	1	2015-04-30 00:00:00	n029	2015-04-30 00:00:00	N	T	15040435	GS00034641	66546	_	T	7418	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-05-06 00:00:00.000	336755	YE	2015-04-30 00:00:00	119254	 	NULL	NULL	NULL
71746	1	2015-04-30 00:00:00	n029	2015-04-30 00:00:00	N	T	15040436	GS00034642	66547	_	T	7418	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-05-06 00:00:00.000	336756	YE	2015-04-30 00:00:00	119255	 	NULL	NULL	NULL
71747	1	2015-04-30 09:18:00	n319	2015-04-30 00:00:00	N	P	15040313	GS15001041	22062	_	T	12556	n1489	WS21	AK3	N	11400.00	11400.00	Y	2015-05-06 00:00:00.000	336736	YY	2015-04-30 00:00:00	163610	 	NULL	NULL	NULL
71748	1	2015-04-30 09:19:00	n319	2015-04-30 00:00:00	N	P	15040312	GS15001042	22070	_	T	12556	n1489	WS21	AK3	N	11400.00	11400.00	Y	2015-05-06 00:00:00.000	336737	YY	2015-04-30 00:00:00	163611	 	NULL	NULL	NULL
71749	1	2015-04-30 09:19:00	n319	2015-04-30 00:00:00	N	P	15040268	GS15001043	27437	_	T	15579	n1489	WS21	AK3	N	1700.00	1700.00	Y	2015-05-06 00:00:00.000	336738	YY	2015-04-30 00:00:00	163612	 	NULL	NULL	NULL
71750	1	2015-04-30 09:29:00	n319	2015-04-30 00:00:00	N	P	15030374	GS15001045	28446	_	T	15598	n1125	IG1E	AA2	N	10500.00	15000.00	Y	2015-05-06 00:00:00.000	336739	YY	2015-04-30 00:00:00	163614	 	NULL	NULL	NULL
71751	1	2015-04-30 09:29:00	n319	2015-04-30 00:00:00	N	P	15040330	GS15001045	28446	_	T	15598	n1125	AC1	AA2	N	4500.00	15000.00	Y	2015-05-06 00:00:00.000	336740	YY	2015-04-30 00:00:00	163614	 	NULL	NULL	NULL
71752	1	2015-04-30 09:30:00	n319	2015-04-30 00:00:00	N	P	15030375	GS15001046	28447	_	T	15598	n1125	UG1	AA3	N	3000.00	3000.00	Y	2015-05-06 00:00:00.000	336741	YY	2015-04-30 00:00:00	163615	 	NULL	NULL	NULL
71753	1	2015-04-30 09:41:00	n319	2015-04-30 00:00:00	N	P	15040307	GS15001047	19353	_	T	2193	n100	WS2	AK2	N	8000.00	8000.00	Y	2015-05-06 00:00:00.000	336742	YE	2015-04-30 00:00:00	163616	 	NULL	NULL	NULL
71754	1	2015-04-30 00:00:00	n029	2015-05-01 00:00:00	N	T	15040455	GS00034643	66551	_	T	16027	n530	FE1	FE1	N	2400.00	2400.00	Y	2015-05-06 00:00:00.000	336761	YE	2015-05-01 00:00:00	119280	 	NULL	NULL	NULL
71755	1	2015-04-30 00:00:00	n029	2015-05-01 00:00:00	N	T	15040452	GS00034644	65983	_	T	13211	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-05-06 00:00:00.000	336762	YY	2015-05-01 00:00:00	119281	 	NULL	NULL	NULL
71756	1	2015-04-30 00:00:00	n029	2015-05-01 00:00:00	N	T	15040453	GS00034645	65570	_	T	14956	n1350	FF0	FF0	N	2500.00	2500.00	Y	2015-05-06 00:00:00.000	336763	YY	2015-05-01 00:00:00	119282	 	NULL	NULL	NULL
71757	1	2015-04-30 00:00:00	n029	2015-05-01 00:00:00	N	T	15040454	GS00034646	65573	_	T	14956	n1350	FF0	FF0	N	2500.00	2500.00	Y	2015-05-06 00:00:00.000	336764	YY	2015-05-01 00:00:00	119283	 	NULL	NULL	NULL
71758	1	2015-04-30 00:00:00	n029	2015-05-01 00:00:00	N	T	15020085	GS00034647	66159	_	T	2560	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-05-06 00:00:00.000	336765	YY	2015-05-01 00:00:00	119284	 	NULL	NULL	NULL
71759	1	2015-04-30 00:00:00	n029	2015-05-01 00:00:00	N	T	15040439	GS00034648	66552	_	T	14529	n1384	FC2	FC2	N	500.00	500.00	Y	2015-05-06 00:00:00.000	336766	YY	2015-05-01 00:00:00	119300	 	NULL	NULL	NULL
71760	1	2015-04-30 00:00:00	n029	2015-05-01 00:00:00	N	T	15040442	GS00034649	66553	_	T	14366	n1384	FC6	FC6	N	3500.00	500.00	Y	2015-05-06 00:00:00.000	336767	YY	2015-05-01 00:00:00	119314	 	NULL	NULL	NULL
71761	1	2015-04-30 00:00:00	n029	2015-05-01 00:00:00	N	T	15040448	GS00034656	44568	_	T	7681	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-05-06 00:00:00.000	336768	YY	2015-05-01 00:00:00	119327	 	NULL	NULL	NULL
71762	1	2015-04-30 00:00:00	n029	2015-05-01 00:00:00	N	T	15040449	GS00034657	44572	_	T	7681	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-05-06 00:00:00.000	336769	YY	2015-05-01 00:00:00	119334	 	NULL	NULL	NULL
71763	1	2015-04-30 15:09:00	n319	2015-05-01 00:00:00	N	P	15040272	GS15001048	24303	_	T	13124	n1304	WS11	AJ2	N	6100.00	6100.00	Y	2015-05-06 00:00:00.000	336757	YY	2015-05-01 00:00:00	163682	 	NULL	NULL	NULL
71764	1	2015-04-30 15:10:00	n319	2015-05-01 00:00:00	N	P	15040273	GS15001049	24303	_	T	13124	n1304	WS21	AK3	N	7600.00	7600.00	Y	2015-05-06 00:00:00.000	336758	YY	2015-05-01 00:00:00	163683	 	NULL	NULL	NULL
71765	1	2015-04-30 00:00:00	n029	2015-05-01 00:00:00	N	T	15040450	GS00034658	44574	_	T	7681	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-05-06 00:00:00.000	336770	YY	2015-05-01 00:00:00	119339	 	NULL	NULL	NULL
71766	1	2015-04-30 15:12:00	n319	2015-05-01 00:00:00	N	P	15040292	GS15001050	26413	_	T	13930	n896	WS1	AJ1	N	23500.00	23500.00	Y	2015-05-06 00:00:00.000	336759	YY	2015-05-01 00:00:00	163684	 	NULL	NULL	NULL
71767	1	2015-04-30 00:00:00	n029	2015-05-01 00:00:00	N	T	15040458	GS00034660	65401	_	T	15224	n1350	FF0	FF0	N	2500.00	2500.00	Y	2015-05-06 00:00:00.000	336771	YY	2015-05-01 00:00:00	119360	 	NULL	NULL	NULL
71768	1	2015-05-01 09:13:00	n319	2015-05-01 00:00:00	N	P	14120190	GS15001052	28217	_	T	15877	n994	IG1B	AA21	N	9700.00	9700.00	Y	2015-05-06 00:00:00.000	336760	YY	2015-05-01 00:00:00	163704	 	NULL	NULL	NULL
71769	1	2015-05-01 00:00:00	n029	2015-05-04 00:00:00	N	T	15040459	GS00034661	65886	_	T	13403	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-05-06 00:00:00.000	336780	YY	2015-05-04 00:00:00	119412	 	NULL	NULL	NULL
71770	1	2015-05-01 00:00:00	n029	2015-05-04 00:00:00	N	T	15050018	GS00034662	65692	_	T	15799	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-05-06 00:00:00.000	336781	YY	2015-05-04 00:00:00	119413	 	NULL	NULL	NULL
71771	1	2015-05-01 00:00:00	n029	2015-05-04 00:00:00	N	T	15050017	GS00034663	65691	_	T	15799	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-05-06 00:00:00.000	336782	YY	2015-05-04 00:00:00	119414	 	NULL	NULL	NULL
71772	1	2015-05-01 00:00:00	n029	2015-05-04 00:00:00	N	T	15050016	GS00034664	65690	_	T	15799	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-05-06 00:00:00.000	336783	YY	2015-05-04 00:00:00	119415	 	NULL	NULL	NULL
71773	1	2015-05-01 00:00:00	n029	2015-05-04 00:00:00	N	T	15050015	GS00034665	65689	_	T	15799	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-05-06 00:00:00.000	336784	YY	2015-05-04 00:00:00	119416	 	NULL	NULL	NULL
71774	1	2015-05-01 00:00:00	n029	2015-05-04 00:00:00	N	T	15050014	GS00034666	65688	_	T	15799	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-05-06 00:00:00.000	336785	YY	2015-05-04 00:00:00	119417	 	NULL	NULL	NULL
71775	1	2015-05-01 00:00:00	n029	2015-05-04 00:00:00	N	T	15050013	GS00034667	65687	_	T	15799	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-05-06 00:00:00.000	336786	YY	2015-05-04 00:00:00	119418	 	NULL	NULL	NULL
71776	1	2015-05-01 00:00:00	n029	2015-05-04 00:00:00	N	T	15050012	GS00034668	65683	_	T	15799	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-05-06 00:00:00.000	336787	YY	2015-05-04 00:00:00	119419	 	NULL	NULL	NULL
71777	1	2015-05-01 00:00:00	n029	2015-05-04 00:00:00	N	T	15050011	GS00034669	65682	_	T	15799	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-05-06 00:00:00.000	336788	YY	2015-05-04 00:00:00	119420	 	NULL	NULL	NULL
71778	1	2015-05-01 00:00:00	n029	2015-05-04 00:00:00	N	T	15050010	GS00034670	65681	_	T	15799	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-05-06 00:00:00.000	336789	YY	2015-05-04 00:00:00	119421	 	NULL	NULL	NULL
71779	1	2015-05-04 00:00:00	n029	2015-05-04 00:00:00	N	T	15050009	GS00034671	65680	_	T	15799	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-05-06 00:00:00.000	336790	YY	2015-05-04 00:00:00	119422	 	NULL	NULL	NULL
71780	1	2015-05-04 00:00:00	n029	2015-05-04 00:00:00	N	T	15050008	GS00034672	65679	_	T	15799	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-05-06 00:00:00.000	336791	YY	2015-05-04 00:00:00	119423	 	NULL	NULL	NULL
71781	1	2015-05-04 00:00:00	n029	2015-05-04 00:00:00	N	T	15050007	GS00034673	65675	_	T	15799	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-05-06 00:00:00.000	336792	YY	2015-05-04 00:00:00	119424	 	NULL	NULL	NULL
71782	1	2015-05-04 00:00:00	n029	2015-05-04 00:00:00	N	T	15050006	GS00034674	65674	_	T	15799	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-05-06 00:00:00.000	336793	YY	2015-05-04 00:00:00	119425	 	NULL	NULL	NULL
71783	1	2015-05-04 00:00:00	n029	2015-05-04 00:00:00	N	T	15050005	GS00034675	65673	_	T	15799	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-05-06 00:00:00.000	336794	YY	2015-05-04 00:00:00	119426	 	NULL	NULL	NULL
71784	1	2015-05-04 00:00:00	n029	2015-05-04 00:00:00	N	T	15050004	GS00034676	65672	_	T	15799	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-05-06 00:00:00.000	336795	YY	2015-05-04 00:00:00	119427	 	NULL	NULL	NULL
71785	1	2015-05-04 00:00:00	n029	2015-05-04 00:00:00	N	T	15050003	GS00034677	65671	_	T	15799	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-05-06 00:00:00.000	336796	YY	2015-05-04 00:00:00	119428	 	NULL	NULL	NULL
71786	1	2015-05-04 00:00:00	n029	2015-05-04 00:00:00	N	T	15050002	GS00034678	65668	_	T	15799	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-05-06 00:00:00.000	336797	YY	2015-05-04 00:00:00	119429	 	NULL	NULL	NULL
71787	1	2015-05-04 00:00:00	n029	2015-05-04 00:00:00	N	T	15050001	GS00034679	65667	_	T	15799	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-05-06 00:00:00.000	336798	YY	2015-05-04 00:00:00	119430	 	NULL	NULL	NULL
71788	1	2015-05-04 00:00:00	n029	2015-05-04 00:00:00	N	T	15040469	GS00034680	66562	_	T	15948	n646	FT1	FT1	N	2000.00	2000.00	Y	2015-05-06 00:00:00.000	336799	YY	2015-05-04 00:00:00	119431	 	NULL	NULL	NULL
71789	1	2015-05-04 00:00:00	n029	2015-05-04 00:00:00	N	T	15040461	GS00034681	66560	_	T	7597	n547	FE1	FE1	N	2400.00	2400.00	Y	2015-05-06 00:00:00.000	336800	YE	2015-05-04 00:00:00	119432	 	NULL	NULL	NULL
71790	1	2015-05-04 00:00:00	n029	2015-05-04 00:00:00	N	T	15040462	GS00034682	66561	_	T	7597	n547	FE1	FE1	N	2400.00	2400.00	Y	2015-05-06 00:00:00.000	336801	YE	2015-05-04 00:00:00	119433	 	NULL	NULL	NULL
71791	1	2015-05-04 00:00:00	n029	2015-05-04 00:00:00	N	T	15040463	GS00034683	66563	_	T	16033	n1384	FE1	FE1	N	4900.00	4900.00	Y	2015-05-06 00:00:00.000	336802	YE	2015-05-04 00:00:00	119434	 	NULL	NULL	NULL
71792	1	2015-05-04 00:00:00	n029	2015-05-04 00:00:00	N	T	15040464	GS00034684	66564	_	T	16033	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-05-06 00:00:00.000	336803	YE	2015-05-04 00:00:00	119440	 	NULL	NULL	NULL
71793	1	2015-05-04 00:00:00	n029	2015-05-04 00:00:00	N	T	15040465	GS00034685	66565	_	T	16030	n646	FE1	FE1	N	8400.00	8400.00	Y	2015-05-06 00:00:00.000	336804	YE	2015-05-04 00:00:00	119442	 	NULL	NULL	NULL
71794	1	2015-05-04 08:43:00	n319	2015-05-04 00:00:00	N	P	15050003	GS15001055	27927	_	T	7078	n1486	WS1	AJ1	N	8500.00	8500.00	Y	2015-05-06 00:00:00.000	336772	YY	2015-05-04 00:00:00	163762	 	NULL	NULL	NULL
71795	1	2015-05-04 00:00:00	n029	2015-05-04 00:00:00	N	T	15040466	GS00034686	66566	_	T	16030	n646	FE11	FE11	N	5700.00	5700.00	Y	2015-05-06 00:00:00.000	336805	YE	2015-05-04 00:00:00	119443	 	NULL	NULL	NULL
71796	1	2015-05-04 00:00:00	n029	2015-05-04 00:00:00	N	T	15040467	GS00034687	66567	_	T	16030	n646	FE1	FE1	N	5400.00	5400.00	Y	2015-05-06 00:00:00.000	336806	YE	2015-05-04 00:00:00	119444	 	NULL	NULL	NULL
71797	1	2015-05-04 00:00:00	n029	2015-05-04 00:00:00	N	T	15040468	GS00034688	66568	_	T	16030	n646	FE1	FE1	N	5400.00	5400.00	Y	2015-05-06 00:00:00.000	336807	YE	2015-05-04 00:00:00	119445	 	NULL	NULL	NULL
71798	1	2015-05-04 08:49:00	n319	2015-05-04 00:00:00	N	P	15050012	GS15001059	28277	_	T	7683	n650	WS1	AJ1	N	3500.00	3500.00	Y	2015-05-06 00:00:00.000	336773	YY	2015-05-04 00:00:00	163766	 	NULL	NULL	NULL
71799	1	2015-05-04 08:50:00	n319	2015-05-04 00:00:00	N	P	15050014	GS15001060	28300	_	T	11997	n1486	WA3	AN5	D	1000.00	1000.00	Y	2015-05-06 00:00:00.000	336774	YY	2015-05-04 00:00:00	163767	 	NULL	NULL	NULL
71800	1	2015-05-04 08:53:00	n319	2015-05-04 00:00:00	N	P	15050005	GS15001062	28353	_	T	15929	n896	WA3	AN5	D	1000.00	1000.00	Y	2015-05-06 00:00:00.000	336775	YY	2015-05-04 00:00:00	163769	 	NULL	NULL	NULL
71801	1	2015-05-04 08:54:00	n319	2015-05-04 00:00:00	N	P	15050006	GS15001063	28354	_	T	15929	n896	WA3	AN5	D	1000.00	1000.00	Y	2015-05-06 00:00:00.000	336776	YY	2015-05-04 00:00:00	163770	 	NULL	NULL	NULL
71802	1	2015-05-04 08:55:00	n319	2015-05-04 00:00:00	N	P	15050007	GS15001064	28355	_	T	15929	n896	WA3	AN5	D	1000.00	1000.00	Y	2015-05-06 00:00:00.000	336777	YY	2015-05-04 00:00:00	163771	 	NULL	NULL	NULL
71804	1	2015-05-04 11:48:00	n319	2015-05-04 00:00:00	N	P	15050020	GS15001066	28518	_	T	14374	n1304	WS11	AJ2	N	6100.00	6100.00	Y	2015-05-06 00:00:00.000	336778	YY	2015-05-04 00:00:00	163773	 	NULL	NULL	NULL
71805	1	2015-05-04 14:30:00	n319	2015-05-04 00:00:00	N	P	15050023	GS15001067	28521	_	T	10747	n1065	IG1E	AA2	N	10500.00	10500.00	Y	2015-05-06 00:00:00.000	336779	YY	2015-05-04 00:00:00	163824	 	NULL	NULL	NULL
71806	1	2015-05-04 16:05:00	n319	2015-05-05 00:00:00	N	P	15050022	GS15001068	21656	_	T	12406	n650	WS21	AK3	N	3800.00	3800.00	Y	2015-05-06 00:00:00.000	336808	YY	2015-05-05 00:00:00	163833	 	NULL	NULL	NULL
71807	1	2015-05-04 16:06:00	n319	2015-05-05 00:00:00	N	P	15050029	GS15001069	27992	_	T	13920	n650	WS11	AJ2	N	6100.00	6100.00	Y	2015-05-06 00:00:00.000	336809	YY	2015-05-05 00:00:00	163834	 	NULL	NULL	NULL
71808	1	2015-05-04 16:08:00	n319	2015-05-05 00:00:00	N	P	15040205	GS15001070	28496	_	T	15589	n1486	DG1	AA4	N	3000.00	3000.00	Y	2015-05-06 00:00:00.000	336810	YY	2015-05-05 00:00:00	163836	 	NULL	NULL	NULL
71809	1	2015-05-05 00:00:00	n029	2015-05-05 00:00:00	N	T	15050020	GS00034690	65909	_	T	4837	n547	FF0	FF0	N	7500.00	7500.00	Y	2015-05-06 00:00:00.000	336815	YY	2015-05-05 00:00:00	119494	 	NULL	NULL	NULL
71810	1	2015-05-05 09:01:00	n319	2015-05-05 00:00:00	N	P	15050030	GS15001072	28461	_	T	15589	n1486	WA3	AN5	D	1000.00	1000.00	Y	2015-05-06 00:00:00.000	336811	YY	2015-05-05 00:00:00	163867	 	NULL	NULL	NULL
71811	1	2015-05-05 09:50:00	n319	2015-05-05 00:00:00	N	P	15050031	GS15001073	20523	_	T	13688	n113	WS2	AK2	N	8000.00	8000.00	Y	2015-05-06 00:00:00.000	336812	YE	2015-05-05 00:00:00	163868	 	NULL	NULL	NULL
71812	1	2015-05-05 10:32:00	n319	2015-05-05 00:00:00	N	P	15020205	GS15001074	28375	_	T	13937	n896	IG1E	AA2	N	10500.00	18500.00	Y	2015-05-06 00:00:00.000	336813	YY	2015-05-05 00:00:00	163870	 	NULL	NULL	NULL
71813	1	2015-05-05 10:32:00	n319	2015-05-05 00:00:00	N	P	15050035	GS15001074	28375	_	T	13937	n896	AC1	AA2	N	8000.00	18500.00	Y	2015-05-06 00:00:00.000	336814	YY	2015-05-05 00:00:00	163870	 	NULL	NULL	NULL
71814	1	2015-05-05 14:45:00	n319	2015-05-06 00:00:00	N	P	15050036	GS15001075	27535	_	T	11764	n1304	WS11	AJ2	N	1000.00	1000.00	Y	2015-05-11 00:00:00.000	336927	YY	2015-05-06 00:00:00	163918	 	NULL	NULL	NULL
71815	1	2015-05-05 14:46:00	n319	2015-05-06 00:00:00	N	P	15050008	GS15001076	27832	_	T	15762	n1489	WA3	AN5	D	1000.00	1000.00	Y	2015-05-11 00:00:00.000	336928	YY	2015-05-06 00:00:00	163919	 	NULL	NULL	NULL
71816	1	2015-05-05 00:00:00	n029	2015-05-06 00:00:00	N	T	15050027	GS00034693	65618	_	T	15348	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-05-11 00:00:00.000	336941	YY	2015-05-06 00:00:00	119526	 	NULL	NULL	NULL
71817	1	2015-05-05 00:00:00	n029	2015-05-06 00:00:00	N	T	15050024	GS00034694	65507	_	T	4049	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-05-11 00:00:00.000	336942	YY	2015-05-06 00:00:00	119530	 	NULL	NULL	NULL
71818	1	2015-05-05 00:00:00	n029	2015-05-06 00:00:00	N	T	15050025	GS00034695	65508	_	T	4049	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-05-11 00:00:00.000	336943	YY	2015-05-06 00:00:00	119531	 	NULL	NULL	NULL
71819	1	2015-05-05 00:00:00	n029	2015-05-06 00:00:00	N	T	15050026	GS00034696	65510	_	T	4049	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-05-11 00:00:00.000	336944	YY	2015-05-06 00:00:00	119532	 	NULL	NULL	NULL
71820	1	2015-05-05 00:00:00	n029	2015-05-06 00:00:00	N	T	15050038	GS00034698	52409	_	T	3116	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-05-11 00:00:00.000	336945	YY	2015-05-06 00:00:00	119534	 	NULL	NULL	NULL
71821	1	2015-05-05 00:00:00	n029	2015-05-06 00:00:00	N	T	15050043	GS00034699	44557	_	T	7681	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-05-11 00:00:00.000	336946	YY	2015-05-06 00:00:00	119535	 	NULL	NULL	NULL
71822	1	2015-05-05 00:00:00	n029	2015-05-06 00:00:00	N	T	15050044	GS00034700	44570	_	T	7681	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-05-11 00:00:00.000	336947	YY	2015-05-06 00:00:00	119539	 	NULL	NULL	NULL
71823	1	2015-05-05 00:00:00	n029	2015-05-06 00:00:00	N	T	15050045	GS00034701	53190	_	T	5406	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-05-11 00:00:00.000	336948	YY	2015-05-06 00:00:00	119540	 	NULL	NULL	NULL
71824	1	2015-05-05 00:00:00	n029	2015-05-06 00:00:00	N	T	15050028	GS00034702	52591	_	T	11602	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-05-11 00:00:00.000	336949	YY	2015-05-06 00:00:00	119545	 	NULL	NULL	NULL
71825	1	2015-05-05 00:00:00	n029	2015-05-06 00:00:00	N	T	15050029	GS00034703	52593	_	T	11602	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-05-11 00:00:00.000	336950	YY	2015-05-06 00:00:00	119546	 	NULL	NULL	NULL
71826	1	2015-05-05 00:00:00	n029	2015-05-06 00:00:00	N	T	15050030	GS00034704	52594	_	T	11602	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-05-11 00:00:00.000	336951	YY	2015-05-06 00:00:00	119547	 	NULL	NULL	NULL
71827	1	2015-05-05 00:00:00	n029	2015-05-06 00:00:00	N	T	15050031	GS00034705	52595	_	T	11602	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-05-11 00:00:00.000	336952	YY	2015-05-06 00:00:00	119548	 	NULL	NULL	NULL
71828	1	2015-05-05 00:00:00	n029	2015-05-06 00:00:00	N	T	15050032	GS00034706	52592	_	T	11602	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-05-11 00:00:00.000	336953	YY	2015-05-06 00:00:00	119549	 	NULL	NULL	NULL
71829	1	2015-05-05 00:00:00	n029	2015-05-06 00:00:00	N	T	15050033	GS00034707	52596	_	T	11602	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-05-11 00:00:00.000	336954	YY	2015-05-06 00:00:00	119550	 	NULL	NULL	NULL
71830	1	2015-05-05 00:00:00	n029	2015-05-06 00:00:00	N	T	15050034	GS00034708	52597	_	T	11602	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-05-11 00:00:00.000	336955	YY	2015-05-06 00:00:00	119551	 	NULL	NULL	NULL
71831	1	2015-05-05 17:06:00	n319	2015-05-06 00:00:00	N	P	15050042	GS15001077	26332	_	T	15196	n650	WS11	AJ2	N	6100.00	6100.00	Y	2015-05-11 00:00:00.000	336929	YY	2015-05-06 00:00:00	163945	 	NULL	NULL	NULL
71832	1	2015-05-05 17:38:00	n319	2015-05-06 00:00:00	N	P	15040338	GS15001079	25296	_	T	14666	n113	WS21	AK3	N	1700.00	1700.00	Y	2015-05-11 00:00:00.000	336930	YY	2015-05-06 00:00:00	163947	 	NULL	NULL	NULL
71833	1	2015-05-05 17:39:00	n319	2015-05-06 00:00:00	N	P	15040314	GS15001080	28058	_	T	15841	n1489	WA3	AN4	N	1000.00	1000.00	Y	2015-05-11 00:00:00.000	336931	YY	2015-05-06 00:00:00	163948	 	NULL	NULL	NULL
71834	1	2015-05-06 09:00:00	n087	2015-05-06 00:00:00	N	P	15040209	GS15001083	28499	_	T	12000	n1304	IG1B	AA21	N	9700.00	9700.00	Y	2015-05-11 00:00:00.000	336932	YY	2015-05-06 00:00:00	163951	 	NULL	NULL	NULL
71835	1	2015-05-06 09:07:00	n087	2015-05-06 00:00:00	N	P	14080003	GS15001084	27882	_	T	12000	n1304	IG1B	AA21	N	9700.00	9700.00	Y	2015-05-11 00:00:00.000	336933	YY	2015-05-06 00:00:00	163952	 	NULL	NULL	NULL
71836	1	2015-05-06 09:12:00	n087	2015-05-06 00:00:00	N	P	15050037	GS15001086	27793	_	T	14171	n1304	WA3	AN5	D	2000.00	2000.00	Y	2015-05-11 00:00:00.000	336934	YY	2015-05-06 00:00:00	163954	 	NULL	NULL	NULL
71837	1	2015-05-06 09:16:00	n087	2015-05-06 00:00:00	N	P	15040269	GS15001087	28508	_	T	16026	n113	IG1E	AA2	N	10500.00	24600.00	Y	2015-05-11 00:00:00.000	336935	YY	2015-05-06 00:00:00	163955	 	NULL	NULL	NULL
71838	1	2015-05-06 09:16:00	n087	2015-05-06 00:00:00	N	P	15050043	GS15001087	28508	_	T	16026	n113	AC2	AA2	N	14100.00	24600.00	Y	2015-05-11 00:00:00.000	336936	YY	2015-05-06 00:00:00	163955	 	NULL	NULL	NULL
71839	1	2015-05-06 09:21:00	n087	2015-05-06 00:00:00	N	P	15050027	GS15001088	26826	_	T	13124	n1304	WS11	AJ2	N	6100.00	6100.00	Y	2015-05-11 00:00:00.000	336937	YY	2015-05-06 00:00:00	163956	 	NULL	NULL	NULL
71840	1	2015-05-06 09:22:00	n087	2015-05-06 00:00:00	N	P	15050028	GS15001089	26826	_	T	13124	n1304	WS21	AK3	N	7600.00	7600.00	Y	2015-05-11 00:00:00.000	336938	YY	2015-05-06 00:00:00	163957	 	NULL	NULL	NULL
71841	1	2015-05-06 09:48:00	n087	2015-05-06 00:00:00	N	P	15030412	GS15001090	28449	_	T	10921	n100	UG1	AA3	N	3000.00	3000.00	Y	2015-05-11 00:00:00.000	336939	YY	2015-05-06 00:00:00	163958	 	NULL	NULL	NULL
71843	1	2015-05-06 15:14:00	n087	2015-05-06 00:00:00	N	P	15050058	GS15001091	28524	_	T	10747	n1065	IG1E	AA2	N	10500.00	10500.00	Y	2015-05-11 00:00:00.000	336940	YY	2015-05-06 00:00:00	164016	 	NULL	NULL	NULL
71844	1	2015-05-06 00:00:00	n029	2015-05-07 00:00:00	N	T	15050053	GS00034709	65676	_	T	15799	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-05-11 00:00:00.000	336970	YY	2015-05-07 00:00:00	119652	 	NULL	NULL	NULL
71845	1	2015-05-06 00:00:00	n029	2015-05-07 00:00:00	N	T	15050052	GS00034710	65684	_	T	15799	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-05-11 00:00:00.000	336971	YY	2015-05-07 00:00:00	119653	 	NULL	NULL	NULL
71846	1	2015-05-06 00:00:00	n029	2015-05-07 00:00:00	N	T	15050054	GS00034711	65736	_	T	7181	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-05-11 00:00:00.000	336972	YY	2015-05-07 00:00:00	119654	 	NULL	NULL	NULL
71847	1	2015-05-06 00:00:00	n029	2015-05-07 00:00:00	N	T	15050055	GS00034712	65770	_	T	13221	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-05-11 00:00:00.000	336973	YY	2015-05-07 00:00:00	119655	 	NULL	NULL	NULL
71848	1	2015-05-06 00:00:00	n029	2015-05-07 00:00:00	N	T	15050056	GS00034713	65771	_	T	13221	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-05-11 00:00:00.000	336974	YY	2015-05-07 00:00:00	119656	 	NULL	NULL	NULL
71849	1	2015-05-06 00:00:00	n029	2015-05-07 00:00:00	N	T	15050057	GS00034714	65772	_	T	13221	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-05-11 00:00:00.000	336975	YY	2015-05-07 00:00:00	119657	 	NULL	NULL	NULL
71850	1	2015-05-06 00:00:00	n029	2015-05-07 00:00:00	N	T	15050058	GS00034715	65773	_	T	13221	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-05-11 00:00:00.000	336976	YY	2015-05-07 00:00:00	119658	 	NULL	NULL	NULL
71851	1	2015-05-06 00:00:00	n029	2015-05-07 00:00:00	N	T	15050059	GS00034716	65779	_	T	13221	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-05-11 00:00:00.000	336977	YY	2015-05-07 00:00:00	119659	 	NULL	NULL	NULL
71852	1	2015-05-06 00:00:00	n029	2015-05-07 00:00:00	N	T	15050060	GS00034717	65780	_	T	13221	n824	FF0	FF0	N	2500.00	2500.00	Y	2015-05-11 00:00:00.000	336978	YY	2015-05-07 00:00:00	119660	 	NULL	NULL	NULL
71853	1	2015-05-06 00:00:00	n029	2015-05-07 00:00:00	N	T	15050050	GS00034719	66569	_	T	16036	n824	FE1	FE1	N	2400.00	2400.00	Y	2015-05-11 00:00:00.000	336979	YE	2015-05-07 00:00:00	119662	 	NULL	NULL	NULL
71854	1	2015-05-07 08:41:00	n319	2015-05-07 00:00:00	N	P	15050055	GS15001092	26120	_	T	12000	n1304	WS1	AJ1	N	8500.00	8500.00	Y	2015-05-11 00:00:00.000	336956	YY	2015-05-07 00:00:00	164062	 	NULL	NULL	NULL
71855	1	2015-05-07 08:50:00	n319	2015-05-07 00:00:00	N	P	15050051	GS15001096	26729	_	T	15352	n994	WS11	AJ2	N	2700.00	2700.00	Y	2015-05-11 00:00:00.000	336957	YY	2015-05-07 00:00:00	164066	 	NULL	NULL	NULL
71856	1	2015-05-07 09:31:00	n319	2015-05-07 00:00:00	N	P	15030068	GS15001098	28392	_	T	15942	n113	IG1E	AA2	N	10500.00	10500.00	Y	2015-05-11 00:00:00.000	336958	YY	2015-05-07 00:00:00	164068	 	NULL	NULL	NULL
71857	1	2015-05-07 09:32:00	n319	2015-05-07 00:00:00	N	P	15030069	GS15001099	28393	_	T	15942	n113	UG1	AA3	N	3000.00	3000.00	Y	2015-05-11 00:00:00.000	336959	YY	2015-05-07 00:00:00	164069	 	NULL	NULL	NULL
71858	1	2015-05-07 09:39:00	n319	2015-05-07 00:00:00	N	P	15040210	GS15001100	28500	_	T	12000	n1304	IG1B	AA21	N	9700.00	10500.00	Y	2015-05-11 00:00:00.000	336960	YY	2015-05-07 00:00:00	164070	 	NULL	NULL	NULL
71859	1	2015-05-07 09:39:00	n319	2015-05-07 00:00:00	N	P	15050060	GS15001100	28500	_	T	12000	n1304	AC2	AA21	N	800.00	10500.00	Y	2015-05-11 00:00:00.000	336961	YY	2015-05-07 00:00:00	164070	 	NULL	NULL	NULL
71860	1	2015-05-07 09:42:00	n319	2015-05-07 00:00:00	N	P	15050062	GS15001101	25807	_	T	15005	n113	WS21	AK3	N	8400.00	8400.00	Y	2015-05-11 00:00:00.000	336962	YY	2015-05-07 00:00:00	164071	 	NULL	NULL	NULL
71861	1	2015-05-07 09:43:00	n319	2015-05-07 00:00:00	N	P	15050063	GS15001102	25808	_	T	15005	n113	WS21	AK3	N	8400.00	8400.00	Y	2015-05-11 00:00:00.000	336963	YY	2015-05-07 00:00:00	164072	 	NULL	NULL	NULL
71862	1	2015-05-07 09:45:00	n319	2015-05-07 00:00:00	N	P	15050061	GS15001103	1081	M	T	12293	n113	WS2	AK2	X	5000.00	5000.00	Y	2015-05-11 00:00:00.000	336964	YE	2015-05-07 00:00:00	164073	 	NULL	NULL	NULL
71863	1	2015-05-07 09:45:00	n319	2015-05-07 00:00:00	N	P	15050054	GS15001104	20926	_	T	555	n1486	WS2	AK2	N	3000.00	3000.00	Y	2015-05-11 00:00:00.000	336965	YE	2015-05-07 00:00:00	164074	 	NULL	NULL	NULL
71864	1	2015-05-07 09:45:00	n319	2015-05-07 00:00:00	N	P	15050066	GS15001105	21494	_	T	13696	n994	WS2	AK2	N	16000.00	16000.00	Y	2015-05-11 00:00:00.000	336966	YE	2015-05-07 00:00:00	164075	 	NULL	NULL	NULL
71865	1	2015-05-07 09:48:00	n319	2015-05-07 00:00:00	N	P	15040171	GS15001106	28488	_	T	13937	n896	IG1E	AA2	N	10500.00	22200.00	Y	2015-05-11 00:00:00.000	336967	YY	2015-05-07 00:00:00	164076	 	NULL	NULL	NULL
71866	1	2015-05-07 09:48:00	n319	2015-05-07 00:00:00	N	P	15050065	GS15001106	28488	_	T	13937	n896	AC2	AA2	N	11700.00	22200.00	Y	2015-05-11 00:00:00.000	336968	YY	2015-05-07 00:00:00	164076	 	NULL	NULL	NULL
71867	1	2015-05-07 09:57:00	n319	2015-05-07 00:00:00	N	P	15030222	GS15001107	27545	_	T	15647	n896	RR1	AAD	N	300.00	300.00	Y	2015-05-11 00:00:00.000	336969	YY	2015-05-07 00:00:00	164077	 	NULL	NULL	NULL
71868	1	2015-05-07 00:00:00	n029	2015-05-08 00:00:00	N	T	15050065	GS00034720	66570	_	T	14366	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-05-14 00:00:00.000	337286	YE	2015-05-08 00:00:00	119711	 	NULL	NULL	NULL
71869	1	2015-05-07 00:00:00	n029	2015-05-08 00:00:00	N	T	15050068	GS00034721	66571	_	T	16022	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-05-14 00:00:00.000	337287	YE	2015-05-08 00:00:00	119712	 	NULL	NULL	NULL
71870	1	2015-05-07 00:00:00	n029	2015-05-08 00:00:00	N	T	15050069	GS00034722	66572	_	T	16022	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-05-14 00:00:00.000	337288	YE	2015-05-08 00:00:00	119713	 	NULL	NULL	NULL
71871	1	2015-05-07 00:00:00	n029	2015-05-08 00:00:00	N	T	15050070	GS00034723	66573	_	T	16022	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-05-14 00:00:00.000	337289	YE	2015-05-08 00:00:00	119714	 	NULL	NULL	NULL
71872	1	2015-05-07 00:00:00	n029	2015-05-08 00:00:00	N	T	15050079	GS00034724	65741	_	T	14643	n1350	FF0	FF0	N	2500.00	2500.00	Y	2015-05-14 00:00:00.000	337290	YY	2015-05-08 00:00:00	119720	 	NULL	NULL	NULL
71873	1	2015-05-07 00:00:00	n029	2015-05-08 00:00:00	N	T	15050062	GS00034725	65890	_	T	15239	n646	FF0	FF0	N	2500.00	2500.00	Y	2015-05-14 00:00:00.000	337291	YY	2015-05-08 00:00:00	119721	 	NULL	NULL	NULL
71874	1	2015-05-07 00:00:00	n029	2015-05-08 00:00:00	N	T	15050080	GS00034726	65750	_	T	4837	n547	FF0	FF0	N	2500.00	2500.00	Y	2015-05-14 00:00:00.000	337292	YY	2015-05-08 00:00:00	119722	 	NULL	NULL	NULL
71875	1	2015-05-08 08:33:00	n319	2015-05-08 00:00:00	N	P	15050076	GS15001110	25738	_	T	13472	n1304	WS1	AJ1	N	8500.00	8500.00	Y	2015-05-14 00:00:00.000	337271	YY	2015-05-08 00:00:00	164177	 	NULL	NULL	NULL
71876	1	2015-05-08 08:36:00	n319	2015-05-08 00:00:00	N	P	15050074	GS15001112	26060	_	T	13472	n1304	WS1	AJ1	N	8500.00	8500.00	Y	2015-05-14 00:00:00.000	337272	YY	2015-05-08 00:00:00	164179	 	NULL	NULL	NULL
71877	1	2015-05-08 08:37:00	n319	2015-05-08 00:00:00	N	P	15050073	GS15001113	26322	_	T	13472	n1304	WS1	AJ1	N	8500.00	8500.00	Y	2015-05-14 00:00:00.000	337273	YY	2015-05-08 00:00:00	164180	 	NULL	NULL	NULL
71878	1	2015-05-08 08:43:00	n319	2015-05-08 00:00:00	N	P	15030202	GS15001115	26679	_	T	7683	n650	RR1	AAK	N	1000.00	1000.00	Y	2015-05-14 00:00:00.000	337274	YY	2015-05-08 00:00:00	164182	 	NULL	NULL	NULL
71879	1	2015-05-08 08:50:00	n319	2015-05-08 00:00:00	N	P	15050077	GS15001118	27673	_	T	13472	n1304	WS1	AJ1	N	3400.00	3400.00	Y	2015-05-14 00:00:00.000	337275	YY	2015-05-08 00:00:00	164185	 	NULL	NULL	NULL
71880	1	2015-05-08 08:52:00	n319	2015-05-08 00:00:00	N	P	15050072	GS15001120	27982	_	T	13472	n1304	WS1	AJ1	N	8500.00	8500.00	Y	2015-05-14 00:00:00.000	337276	YY	2015-05-08 00:00:00	164187	 	NULL	NULL	NULL
71881	1	2015-05-08 08:53:00	n319	2015-05-08 00:00:00	N	P	15050071	GS15001121	27983	_	T	13472	n1304	WS1	AJ1	N	8500.00	8500.00	Y	2015-05-14 00:00:00.000	337277	YY	2015-05-08 00:00:00	164188	 	NULL	NULL	NULL
71882	1	2015-05-08 08:54:00	n319	2015-05-08 00:00:00	N	P	15050070	GS15001122	27984	_	T	13472	n1304	WS1	AJ1	N	8500.00	8500.00	Y	2015-05-14 00:00:00.000	337278	YY	2015-05-08 00:00:00	164189	 	NULL	NULL	NULL
71883	1	2015-05-08 08:55:00	n319	2015-05-08 00:00:00	N	P	15050075	GS15001123	28070	_	T	13472	n1304	WS1	AJ1	N	8500.00	8500.00	Y	2015-05-14 00:00:00.000	337279	YY	2015-05-08 00:00:00	164190	 	NULL	NULL	NULL
71884	1	2015-05-08 08:57:00	n319	2015-05-08 00:00:00	N	P	14120187	GS15001124	28214	_	T	15877	n994	IG1B	AA21	N	9700.00	9700.00	Y	2015-05-14 00:00:00.000	337280	YY	2015-05-08 00:00:00	164191	 	NULL	NULL	NULL
71885	1	2015-05-08 09:03:00	n319	2015-05-08 00:00:00	N	P	15020166	GS15001127	28360	_	T	13472	n1304	IG1B	AA21	N	9700.00	9700.00	Y	2015-05-14 00:00:00.000	337281	YY	2015-05-08 00:00:00	164194	 	NULL	NULL	NULL
71886	1	2015-05-08 09:06:00	n319	2015-05-08 00:00:00	N	P	15050046	GS15001128	28497	_	T	15857	n1125	FR1	AB1	N	300.00	300.00	Y	2015-05-14 00:00:00.000	337282	YY	2015-05-08 00:00:00	164195	 	NULL	NULL	NULL
71887	1	2015-05-08 09:25:00	n319	2015-05-08 00:00:00	N	P	15050090	GS15001129	23461	_	T	14375	n896	WS21	AK3	N	2800.00	2800.00	Y	2015-05-14 00:00:00.000	337283	YY	2015-05-08 00:00:00	164199	 	NULL	NULL	NULL
71888	1	2015-05-08 09:40:00	n319	2015-05-08 00:00:00	N	P	15050091	GS15001130	21009	_	T	13631	n896	WS2	AK2	N	8000.00	8000.00	Y	2015-05-14 00:00:00.000	337284	YE	2015-05-08 00:00:00	164200	 	NULL	NULL	NULL
71889	1	2015-05-08 09:40:00	n319	2015-05-08 00:00:00	N	P	15050084	GS15001131	22119	_	T	1206	n896	WS2	AK2	N	8000.00	8000.00	Y	2015-05-14 00:00:00.000	337285	YE	2015-05-08 00:00:00	164201	 	NULL	NULL	NULL
71890	1	2015-05-08 15:30:00	n319	2015-05-11 00:00:00	N	P	15050056	GS15001132	28496	_	T	15589	n1486	WA3	AN5	D	1000.00	1000.00	Y	2015-05-14 00:00:00.000	337293	YY	2015-05-11 00:00:00	164277	 	NULL	NULL	NULL
71891	1	2015-05-08 00:00:00	n029	2015-05-11 00:00:00	N	T	15050081	GS00034727	65433	_	T	15440	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-05-14 00:00:00.000	337303	YY	2015-05-11 00:00:00	119777	 	NULL	NULL	NULL
71892	1	2015-05-08 00:00:00	n029	2015-05-11 00:00:00	N	T	15050072	GS00034728	65899	_	T	15800	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-05-14 00:00:00.000	337304	YY	2015-05-11 00:00:00	119780	 	NULL	NULL	NULL
71893	1	2015-05-08 00:00:00	n029	2015-05-11 00:00:00	N	T	15050073	GS00034729	65901	_	T	15800	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-05-14 00:00:00.000	337305	YY	2015-05-11 00:00:00	119783	 	NULL	NULL	NULL
71894	1	2015-05-08 00:00:00	n029	2015-05-11 00:00:00	N	T	15050074	GS00034730	65902	_	T	15800	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-05-14 00:00:00.000	337306	YY	2015-05-11 00:00:00	119785	 	NULL	NULL	NULL
71895	1	2015-05-08 00:00:00	n029	2015-05-11 00:00:00	N	T	15050075	GS00034731	65903	_	T	15800	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-05-14 00:00:00.000	337307	YY	2015-05-11 00:00:00	119786	 	NULL	NULL	NULL
71896	1	2015-05-08 00:00:00	n029	2015-05-11 00:00:00	N	T	15050076	GS00034732	65904	_	T	15800	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-05-14 00:00:00.000	337308	YY	2015-05-11 00:00:00	119787	 	NULL	NULL	NULL
71897	1	2015-05-08 00:00:00	n029	2015-05-11 00:00:00	N	T	15050071	GS00034733	65897	_	T	15800	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-05-14 00:00:00.000	337309	YY	2015-05-11 00:00:00	119788	 	NULL	NULL	NULL
71898	1	2015-05-08 00:00:00	n029	2015-05-11 00:00:00	N	T	15050077	GS00034734	65905	_	T	15800	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-05-14 00:00:00.000	337310	YY	2015-05-11 00:00:00	119789	 	NULL	NULL	NULL
71899	1	2015-05-11 08:46:00	n319	2015-05-11 00:00:00	N	P	14060008	GS15001137	27719	_	T	13910	n1304	UG1	AA3	N	3000.00	3000.00	Y	2015-05-14 00:00:00.000	337294	YY	2015-05-11 00:00:00	164290	 	NULL	NULL	NULL
71900	1	2015-05-11 08:48:00	n319	2015-05-11 00:00:00	N	P	15050059	GS15001138	28525	_	T	13124	n1304	IG1B	AA21	N	9700.00	9700.00	Y	2015-05-14 00:00:00.000	337295	YY	2015-05-11 00:00:00	164291	 	NULL	NULL	NULL
71901	1	2015-05-11 08:52:00	n319	2015-05-11 00:00:00	N	P	14090371	GS15001139	28040	_	T	11997	n1486	IG1E	AA2	N	10500.00	10500.00	Y	2015-05-14 00:00:00.000	337296	YY	2015-05-11 00:00:00	164292	 	NULL	NULL	NULL
71902	1	2015-05-11 08:53:00	n319	2015-05-11 00:00:00	N	P	14090372	GS15001140	28041	_	T	11997	n1486	IG1E	AA2	N	10500.00	10500.00	Y	2015-05-14 00:00:00.000	337297	YY	2015-05-11 00:00:00	164293	 	NULL	NULL	NULL
71903	1	2015-05-11 09:15:00	n319	2015-05-11 00:00:00	N	P	15050094	GS15001141	21666	_	T	13344	n1125	WS21	AK3	N	3800.00	3800.00	Y	2015-05-14 00:00:00.000	337298	YY	2015-05-11 00:00:00	164294	 	NULL	NULL	NULL
71904	1	2015-05-11 09:18:00	n319	2015-05-11 00:00:00	N	P	15020184	GS15001142	28368	_	T	4623	n1125	DG1	AA4	N	3000.00	3000.00	Y	2015-05-14 00:00:00.000	337299	YY	2015-05-11 00:00:00	164295	 	NULL	NULL	NULL
71905	1	2015-05-11 09:19:00	n319	2015-05-11 00:00:00	N	P	15020185	GS15001143	28369	_	T	4623	n1125	DG1	AA4	N	3000.00	3000.00	Y	2015-05-14 00:00:00.000	337300	YY	2015-05-11 00:00:00	164296	 	NULL	NULL	NULL
71906	1	2015-05-11 09:30:00	n319	2015-05-11 00:00:00	N	P	15020189	GS15001144	28362	_	T	15569	n994	IG1B	AA21	N	9700.00	20100.00	Y	2015-05-14 00:00:00.000	337301	YY	2015-05-11 00:00:00	164297	 	NULL	NULL	NULL
71907	1	2015-05-11 09:30:00	n319	2015-05-11 00:00:00	N	P	15050095	GS15001144	28362	_	T	15569	n994	AC2	AA21	N	10400.00	20100.00	Y	2015-05-14 00:00:00.000	337302	YY	2015-05-11 00:00:00	164297	 	NULL	NULL	NULL
71908	1	2015-05-11 15:30:00	n319	2015-05-12 00:00:00	N	P	15050092	GS15001147	28343	_	T	11997	n1486	WS11	AJ2	N	6100.00	6100.00	Y	2015-05-14 00:00:00.000	337311	YY	2015-05-12 00:00:00	164417	 	NULL	NULL	NULL
71909	1	2015-05-11 16:53:00	n319	2015-05-12 00:00:00	N	P	15050100	GS15001150	27245	_	T	15343	n1489	WS11	AJ2	N	1000.00	1000.00	Y	2015-05-14 00:00:00.000	337312	YY	2015-05-12 00:00:00	164433	 	NULL	NULL	NULL
71910	1	2015-05-11 17:07:00	n319	2015-05-12 00:00:00	N	P	14110277	GS15001153	28168	_	T	15425	n1304	IG1B	AA21	N	9700.00	9700.00	Y	2015-05-14 00:00:00.000	337313	YY	2015-05-12 00:00:00	164436	 	NULL	NULL	NULL
71911	1	2015-05-11 17:17:00	n319	2015-05-12 00:00:00	N	P	15030217	GS15001154	28411	_	T	12000	n1304	IG1B	AA21	N	9700.00	9700.00	Y	2015-05-14 00:00:00.000	337314	YY	2015-05-12 00:00:00	164437	 	NULL	NULL	NULL
71912	1	2015-05-11 17:19:00	n319	2015-05-12 00:00:00	N	P	15040090	GS15001155	28462	_	T	11463	n650	IG1E	AA2	N	10500.00	10500.00	Y	2015-05-14 00:00:00.000	337315	YY	2015-05-12 00:00:00	164438	 	NULL	NULL	NULL
71913	1	2015-05-12 00:00:00	n029	2015-05-12 00:00:00	N	T	15050100	GS00034737	65726	_	T	15813	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-05-14 00:00:00.000	337323	YY	2015-05-12 00:00:00	119869	 	NULL	NULL	NULL
71914	1	2015-05-12 00:00:00	n029	2015-05-12 00:00:00	N	T	15050066	GS00034738	66574	_	T	13071	n646	FR1	FR1	N	4000.00	4000.00	Y	2015-05-14 00:00:00.000	337324	YY	2015-05-12 00:00:00	119870	 	NULL	NULL	NULL
71915	1	2015-05-12 00:00:00	n029	2015-05-12 00:00:00	N	T	15050067	GS00034739	52978	_	T	13071	n646	FR1	FR1	N	4000.00	4000.00	Y	2015-05-14 00:00:00.000	337325	YY	2015-05-12 00:00:00	119871	 	NULL	NULL	NULL
71916	1	2015-05-12 00:00:00	n029	2015-05-12 00:00:00	N	T	15050099	GS00034742	52739	_	T	12369	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-05-14 00:00:00.000	337326	YY	2015-05-12 00:00:00	119875	 	NULL	NULL	NULL
71917	1	2015-05-12 00:00:00	n029	2015-05-12 00:00:00	N	T	15050093	GS00034743	66577	_	T	13648	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-05-14 00:00:00.000	337327	YE	2015-05-12 00:00:00	119876	 	NULL	NULL	NULL
71918	1	2015-05-12 00:00:00	n029	2015-05-12 00:00:00	N	T	15050094	GS00034744	66578	_	T	13648	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-05-14 00:00:00.000	337328	YE	2015-05-12 00:00:00	119877	 	NULL	NULL	NULL
71919	1	2015-05-12 08:48:00	n319	2015-05-12 00:00:00	N	P	15040051	GS15001156	28458	_	T	15569	n994	IG1B	AA21	N	9700.00	12900.00	Y	2015-05-14 00:00:00.000	337316	YY	2015-05-12 00:00:00	164439	 	NULL	NULL	NULL
71920	1	2015-05-12 08:48:00	n319	2015-05-12 00:00:00	N	P	15050114	GS15001156	28458	_	T	15569	n994	AC2	AA21	N	3200.00	12900.00	Y	2015-05-14 00:00:00.000	337317	YY	2015-05-12 00:00:00	164439	 	NULL	NULL	NULL
71921	1	2015-05-12 00:00:00	n029	2015-05-12 00:00:00	N	T	15050095	GS00034745	66579	_	T	13648	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-05-14 00:00:00.000	337329	YE	2015-05-12 00:00:00	119878	 	NULL	NULL	NULL
71922	1	2015-05-12 00:00:00	n029	2015-05-12 00:00:00	N	T	15050096	GS00034746	66580	_	T	13648	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-05-14 00:00:00.000	337330	YE	2015-05-12 00:00:00	119879	 	NULL	NULL	NULL
71923	1	2015-05-12 00:00:00	n029	2015-05-12 00:00:00	N	T	15050097	GS00034747	66581	_	T	13648	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-05-14 00:00:00.000	337331	YE	2015-05-12 00:00:00	119880	 	NULL	NULL	NULL
71924	1	2015-05-12 00:00:00	n029	2015-05-12 00:00:00	N	T	15050098	GS00034748	66582	_	T	13648	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-05-14 00:00:00.000	337332	YE	2015-05-12 00:00:00	119881	 	NULL	NULL	NULL
71925	1	2015-05-12 00:00:00	n029	2015-05-12 00:00:00	N	T	15050082	GS00034749	66575	_	T	15420	n530	FE1	FE1	N	12000.00	12000.00	Y	2015-05-14 00:00:00.000	337333	YE	2015-05-12 00:00:00	119882	 	NULL	NULL	NULL
71926	1	2015-05-12 00:00:00	n029	2015-05-12 00:00:00	N	T	15050083	GS00034750	66576	_	T	15420	n530	FE1	FE1	N	12000.00	12000.00	Y	2015-05-14 00:00:00.000	337334	YE	2015-05-12 00:00:00	119883	 	NULL	NULL	NULL
71927	1	2015-05-12 09:20:00	n319	2015-05-12 00:00:00	N	P	15040111	GS15001157	28466	_	T	15895	n1125	IG1E	AA2	N	10500.00	10500.00	Y	2015-05-14 00:00:00.000	337318	YY	2015-05-12 00:00:00	164440	 	NULL	NULL	NULL
71928	1	2015-05-12 09:22:00	n319	2015-05-12 00:00:00	N	P	15040112	GS15001158	28467	_	T	15895	n1125	UG1	AA3	N	3000.00	3000.00	Y	2015-05-14 00:00:00.000	337319	YY	2015-05-12 00:00:00	164441	 	NULL	NULL	NULL
71929	1	2015-05-12 09:42:00	n319	2015-05-12 00:00:00	N	P	15050102	GS15001159	1049	M	T	12154	n113	WS2	AK2	X	8000.00	8000.00	Y	2015-05-14 00:00:00.000	337320	YE	2015-05-12 00:00:00	164442	 	NULL	NULL	NULL
71930	1	2015-05-12 09:42:00	n319	2015-05-12 00:00:00	N	P	15050113	GS15001160	20881	_	T	13824	n650	WS2	AK2	N	5000.00	5000.00	Y	2015-05-14 00:00:00.000	337321	YE	2015-05-12 00:00:00	164443	 	NULL	NULL	NULL
71931	1	2015-05-12 14:05:00	n319	2015-05-12 00:00:00	N	P	15050122	GS15001161	28533	_	T	10747	n1065	IG1E	AA2	N	10500.00	10500.00	Y	2015-05-14 00:00:00.000	337322	YY	2015-05-12 00:00:00	164510	 	NULL	NULL	NULL
71932	1	2015-05-12 15:39:00	n319	2015-05-13 00:00:00	N	P	15050126	GS15001162	26827	_	T	13648	n650	WS11	AJ2	N	2700.00	2700.00	Y	2015-05-18 00:00:00.000	337770	YY	2015-05-13 00:00:00	164541	 	NULL	NULL	NULL
71933	1	2015-05-12 15:40:00	n319	2015-05-13 00:00:00	N	P	15050117	GS15001163	28332	_	T	14737	n650	WA3	AN5	D	1000.00	1000.00	Y	2015-05-18 00:00:00.000	337771	YY	2015-05-13 00:00:00	164542	 	NULL	NULL	NULL
71934	1	2015-05-12 00:00:00	n029	2015-05-13 00:00:00	N	T	15050111	GS00034751	65232	_	T	12563	n646	FF0	FF0	N	2500.00	2500.00	Y	2015-05-18 00:00:00.000	337779	YY	2015-05-13 00:00:00	119916	 	NULL	NULL	NULL
71935	1	2015-05-12 00:00:00	n029	2015-05-13 00:00:00	N	T	15050107	GS00034752	52494	_	T	2510	n547	FR1	FR1	N	4000.00	4000.00	Y	2015-05-18 00:00:00.000	337780	YY	2015-05-13 00:00:00	119917	 	NULL	NULL	NULL
71936	1	2015-05-12 00:00:00	n029	2015-05-13 00:00:00	N	T	15030105	GS00034754	66296	_	T	15943	n1350	FR1	FR1	N	4000.00	4000.00	Y	2015-05-18 00:00:00.000	337781	YY	2015-05-13 00:00:00	119919	 	NULL	NULL	NULL
71937	1	2015-05-13 00:00:00	n029	2015-05-13 00:00:00	N	T	15050115	GS00034758	64846	_	T	6138	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-05-18 00:00:00.000	337782	YY	2015-05-13 00:00:00	119923	 	NULL	NULL	NULL
71938	1	2015-05-13 00:00:00	n029	2015-05-13 00:00:00	N	T	15050102	GS00034759	52816	_	T	11978	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-05-18 00:00:00.000	337783	YY	2015-05-13 00:00:00	119924	 	NULL	NULL	NULL
71939	1	2015-05-13 00:00:00	n029	2015-05-13 00:00:00	N	T	15050105	GS00034760	53116	_	T	11978	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-05-18 00:00:00.000	337784	YY	2015-05-13 00:00:00	119927	 	NULL	NULL	NULL
71940	1	2015-05-13 00:00:00	n029	2015-05-13 00:00:00	N	T	15050104	GS00034761	53117	_	T	11978	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-05-18 00:00:00.000	337785	YY	2015-05-13 00:00:00	119930	 	NULL	NULL	NULL
71941	1	2015-05-13 00:00:00	n029	2015-05-13 00:00:00	N	T	15050106	GS00034762	53118	_	T	11978	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-05-18 00:00:00.000	337786	YY	2015-05-13 00:00:00	119933	 	NULL	NULL	NULL
71942	1	2015-05-13 00:00:00	n029	2015-05-13 00:00:00	N	T	15050103	GS00034763	53119	_	T	11978	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-05-18 00:00:00.000	337787	YY	2015-05-13 00:00:00	119934	 	NULL	NULL	NULL
71943	1	2015-05-13 00:00:00	n029	2015-05-13 00:00:00	N	T	15050110	GS00034764	66583	_	T	14554	n441	FE1	FE1	N	2400.00	2400.00	Y	2015-05-18 00:00:00.000	337788	YE	2015-05-13 00:00:00	119935	 	NULL	NULL	NULL
71944	1	2015-05-13 08:42:00	n319	2015-05-13 00:00:00	N	P	15030263	GS15001164	25708	_	T	13472	n1304	FR1	AB1	N	7000.00	8600.00	Y	2015-05-18 00:00:00.000	337772	YY	2015-05-13 00:00:00	164544	 	NULL	NULL	NULL
71945	1	2015-05-13 08:42:00	n319	2015-05-13 00:00:00	N	P	15050108	GS15001164	25708	_	T	13472	n1304	FR12	AB1	N	1600.00	8600.00	Y	2015-05-18 00:00:00.000	337773	YY	2015-05-13 00:00:00	164544	 	NULL	NULL	NULL
71946	1	2015-05-13 08:44:00	n319	2015-05-13 00:00:00	N	P	15040325	GS15001165	25798	_	T	13472	n1304	FR1	AB1	N	7000.00	7000.00	Y	2015-05-18 00:00:00.000	337774	YY	2015-05-13 00:00:00	164545	 	NULL	NULL	NULL
71947	1	2015-05-13 08:46:00	n319	2015-05-13 00:00:00	N	P	15050109	GS15001166	28292	_	T	15933	n1125	WA3	AN5	D	1000.00	1000.00	Y	2015-05-18 00:00:00.000	337775	YY	2015-05-13 00:00:00	164546	 	NULL	NULL	NULL
71948	1	2015-05-13 08:51:00	n319	2015-05-13 00:00:00	N	P	15040126	GS15001167	28479	_	T	10747	n1065	UG1	AA3	N	3000.00	3000.00	Y	2015-05-18 00:00:00.000	337776	YY	2015-05-13 00:00:00	164547	 	NULL	NULL	NULL
71949	1	2015-05-13 09:27:00	n319	2015-05-13 00:00:00	N	P	14120263	GS15001170	28230	_	T	12374	n1304	IG1	AA1	N	3500.00	3500.00	Y	2015-05-18 00:00:00.000	337777	YY	2015-05-13 00:00:00	164550	 	NULL	NULL	NULL
71950	1	2015-05-13 10:26:00	n319	2015-05-13 00:00:00	N	P	15010076	GS15001172	28283	_	T	15336	n1125	IG1E	AA2	N	10500.00	10500.00	Y	2015-05-18 00:00:00.000	337778	YY	2015-05-13 00:00:00	164557	 	NULL	NULL	NULL
71951	1	2015-05-13 15:09:00	n319	2015-05-14 00:00:00	N	P	15050125	GS15001175	28263	_	T	14032	n994	WS1	AJ1	N	8500.00	8500.00	Y	2015-05-18 00:00:00.000	337789	YY	2015-05-14 00:00:00	164619	 	NULL	NULL	NULL
71952	1	2015-05-13 15:11:00	n319	2015-05-14 00:00:00	N	P	15050068	GS15001176	28281	_	T	15336	n1125	WA3	AN5	D	2000.00	2000.00	Y	2015-05-18 00:00:00.000	337790	YY	2015-05-14 00:00:00	164621	 	NULL	NULL	NULL
71953	1	2015-05-13 15:12:00	n319	2015-05-14 00:00:00	N	P	15050069	GS15001177	28282	_	T	15336	n1125	WA3	AN5	D	1000.00	1000.00	Y	2015-05-18 00:00:00.000	337791	YY	2015-05-14 00:00:00	164622	 	NULL	NULL	NULL
71954	1	2015-05-13 15:20:00	n319	2015-05-14 00:00:00	N	P	15030137	GS15001180	28403	_	T	15944	n1125	IG1E	AA2	N	10500.00	10500.00	Y	2015-05-18 00:00:00.000	337792	YY	2015-05-14 00:00:00	164626	 	NULL	NULL	NULL
71955	1	2015-05-13 15:21:00	n319	2015-05-14 00:00:00	N	P	15030138	GS15001181	28404	_	T	15944	n1125	UG1	AA3	N	3000.00	3000.00	Y	2015-05-18 00:00:00.000	337793	YY	2015-05-14 00:00:00	164627	 	NULL	NULL	NULL
71956	1	2015-05-14 00:00:00	n029	2015-05-14 00:00:00	N	T	15050118	GS00034765	66584	_	T	14716	n824	FE1	FE1	N	4900.00	4900.00	Y	2015-05-18 00:00:00.000	337799	YE	2015-05-14 00:00:00	120022	 	NULL	NULL	NULL
71957	1	2015-05-14 00:00:00	n029	2015-05-14 00:00:00	N	T	15050121	GS00034766	66585	_	T	14716	n824	FE1	FE1	N	2400.00	2400.00	Y	2015-05-18 00:00:00.000	337800	YE	2015-05-14 00:00:00	120023	 	NULL	NULL	NULL
71958	1	2015-05-14 00:00:00	n029	2015-05-14 00:00:00	N	T	15050122	GS00034767	66586	_	T	14716	n824	FE1	FE1	N	2400.00	2400.00	Y	2015-05-18 00:00:00.000	337801	YE	2015-05-14 00:00:00	120024	 	NULL	NULL	NULL
71959	1	2015-05-14 00:00:00	n029	2015-05-14 00:00:00	N	T	15050119	GS00034768	66587	_	T	14716	n824	FE1	FE1	N	4900.00	4900.00	Y	2015-05-18 00:00:00.000	337802	YE	2015-05-14 00:00:00	120025	 	NULL	NULL	NULL
71960	1	2015-05-14 00:00:00	n029	2015-05-14 00:00:00	N	T	15050120	GS00034769	66588	_	T	14716	n824	FE1	FE1	N	2400.00	2400.00	Y	2015-05-18 00:00:00.000	337803	YE	2015-05-14 00:00:00	120026	 	NULL	NULL	NULL
71961	1	2015-05-14 00:00:00	n029	2015-05-14 00:00:00	N	T	15050123	GS00034770	66589	_	T	14716	n824	FE1	FE1	N	2400.00	2400.00	Y	2015-05-18 00:00:00.000	337804	YE	2015-05-14 00:00:00	120027	 	NULL	NULL	NULL
71962	1	2015-05-14 09:26:00	n319	2015-05-14 00:00:00	N	P	15030282	GS15001184	28438	_	T	13124	n1304	IG1E	AA2	N	10500.00	11000.00	Y	2015-05-18 00:00:00.000	337794	YY	2015-05-14 00:00:00	164659	 	NULL	NULL	NULL
71963	1	2015-05-14 09:26:00	n319	2015-05-14 00:00:00	N	P	15050146	GS15001184	28438	_	T	13124	n1304	AC1	AA2	N	500.00	11000.00	Y	2015-05-18 00:00:00.000	337795	YY	2015-05-14 00:00:00	164659	 	NULL	NULL	NULL
71964	1	2015-05-14 09:40:00	n319	2015-05-14 00:00:00	N	P	15050099	GS15001185	19026	_	T	13265	n1125	WS2	AK2	N	16000.00	16000.00	Y	2015-05-18 00:00:00.000	337796	YE	2015-05-14 00:00:00	164674	 	NULL	NULL	NULL
71965	1	2015-05-14 09:40:00	n319	2015-05-14 00:00:00	N	P	15050148	GS15001186	25519	_	T	3554	n896	WS2	AK2	N	4000.00	4000.00	Y	2015-05-18 00:00:00.000	337797	YE	2015-05-14 00:00:00	164675	 	NULL	NULL	NULL
71966	1	2015-05-14 09:40:00	n319	2015-05-14 00:00:00	N	P	15050151	GS15001187	25957	_	T	13712	n896	WS2	AK2	N	4000.00	4000.00	Y	2015-05-18 00:00:00.000	337798	YE	2015-05-14 00:00:00	164676	 	NULL	NULL	NULL
71967	1	2015-05-14 15:13:00	n319	2015-05-15 00:00:00	N	P	15050158	GS15001188	25535	_	T	13648	n650	WS21	AK3	N	2800.00	2800.00	Y	2015-05-19 00:00:00.000	338207	YY	2015-05-15 00:00:00	164744	 	NULL	NULL	NULL
71968	1	2015-05-14 15:14:00	n319	2015-05-15 00:00:00	N	P	15050159	GS15001189	26447	_	T	13648	n650	WS21	AK3	N	1700.00	1700.00	Y	2015-05-19 00:00:00.000	338208	YY	2015-05-15 00:00:00	164745	 	NULL	NULL	NULL
71969	1	2015-05-14 15:15:00	n319	2015-05-15 00:00:00	N	P	15050132	GS15001190	28333	_	T	14737	n650	WA3	AN5	D	1000.00	1000.00	Y	2015-05-19 00:00:00.000	338209	YY	2015-05-15 00:00:00	164746	 	NULL	NULL	NULL
71970	1	2015-05-14 15:17:00	n319	2015-05-15 00:00:00	N	P	15040122	GS15001191	28465	_	T	13444	n650	IG1E	AA2	N	10500.00	10500.00	Y	2015-05-19 00:00:00.000	338210	YY	2015-05-15 00:00:00	164747	 	NULL	NULL	NULL
71971	1	2015-05-14 17:04:00	n319	2015-05-15 00:00:00	N	P	15050145	GS15001192	22087	_	T	12621	n1304	WS11	AJ2	N	2700.00	2700.00	Y	2015-05-19 00:00:00.000	338211	YY	2015-05-15 00:00:00	164762	 	NULL	NULL	NULL
71972	1	2015-05-14 17:05:00	n319	2015-05-15 00:00:00	N	P	15050131	GS15001193	27763	_	T	15749	n1489	WA3	AN5	D	1000.00	1000.00	Y	2015-05-19 00:00:00.000	338212	YY	2015-05-15 00:00:00	164763	 	NULL	NULL	NULL
71973	1	2015-05-14 17:08:00	n319	2015-05-15 00:00:00	N	P	14080264	GS15001194	27942	_	T	7636	n1304	UG1	AA3	N	3000.00	3000.00	Y	2015-05-19 00:00:00.000	338213	YY	2015-05-15 00:00:00	164764	 	NULL	NULL	NULL
71974	1	2015-05-15 08:37:00	n319	2015-05-15 00:00:00	N	P	15040264	GS15001196	25632	_	T	11959	n1065	FR1	AB1	N	8600.00	8600.00	Y	2015-05-19 00:00:00.000	338214	YY	2015-05-15 00:00:00	164767	 	NULL	NULL	NULL
71975	1	2015-05-15 08:41:00	n319	2015-05-15 00:00:00	N	P	15050129	GS15001198	28466	_	T	15895	n1125	WA3	AN5	D	1000.00	1000.00	Y	2015-05-19 00:00:00.000	338215	YY	2015-05-15 00:00:00	164769	 	NULL	NULL	NULL
71976	1	2015-05-15 08:43:00	n319	2015-05-15 00:00:00	N	P	15040177	GS15001199	28488	_	T	13937	n896	WA3	AN5	D	1000.00	1000.00	Y	2015-05-19 00:00:00.000	338216	YY	2015-05-15 00:00:00	164770	 	NULL	NULL	NULL
71977	1	2015-05-15 00:00:00	n029	2015-05-15 00:00:00	N	T	15050127	GS00034771	66590	_	T	14366	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-05-19 00:00:00.000	338221	YE	2015-05-15 00:00:00	120057	 	NULL	NULL	NULL
71978	1	2015-05-15 00:00:00	n029	2015-05-15 00:00:00	N	T	15050128	GS00034772	65601	_	T	15295	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-05-19 00:00:00.000	338222	YY	2015-05-15 00:00:00	120058	 	NULL	NULL	NULL
71979	1	2015-05-15 00:00:00	n029	2015-05-15 00:00:00	N	T	15050129	GS00034773	65602	_	T	15295	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-05-19 00:00:00.000	338223	YY	2015-05-15 00:00:00	120059	 	NULL	NULL	NULL
71980	1	2015-05-15 00:00:00	n029	2015-05-15 00:00:00	N	T	15050130	GS00034776	65856	_	T	15801	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-05-19 00:00:00.000	338224	YY	2015-05-15 00:00:00	120062	 	NULL	NULL	NULL
71981	1	2015-05-15 00:00:00	n029	2015-05-15 00:00:00	N	T	15050131	GS00034777	65869	_	T	15801	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-05-19 00:00:00.000	338225	YY	2015-05-15 00:00:00	120063	 	NULL	NULL	NULL
71982	1	2015-05-15 09:34:00	n319	2015-05-15 00:00:00	N	P	15050163	GS15001201	27498	_	T	14374	n1304	WS21	AK3	N	1700.00	1700.00	Y	2015-05-19 00:00:00.000	338217	YY	2015-05-15 00:00:00	164772	 	NULL	NULL	NULL
71983	1	2015-05-15 09:36:00	n319	2015-05-15 00:00:00	N	P	15050116	GS15001202	27889	_	T	15587	n1125	WS11	AJ2	N	6100.00	6100.00	Y	2015-05-19 00:00:00.000	338218	YY	2015-05-15 00:00:00	164773	 	NULL	NULL	NULL
71984	1	2015-05-15 09:50:00	n319	2015-05-15 00:00:00	N	P	15050157	GS15001204	26011	_	T	13712	n896	WS2	AK2	N	2500.00	2500.00	Y	2015-05-19 00:00:00.000	338219	YE	2015-05-15 00:00:00	164775	 	NULL	NULL	NULL
71985	1	2015-05-15 09:50:00	n319	2015-05-15 00:00:00	N	P	15050156	GS15001205	26040	_	T	13712	n896	WS2	AK2	N	2500.00	2500.00	Y	2015-05-19 00:00:00.000	338220	YE	2015-05-15 00:00:00	164776	 	NULL	NULL	NULL
71986	1	2015-05-15 17:26:00	n319	2015-05-18 00:00:00	N	P	15050047	GS15001208	28498	_	T	15857	n1125	RR1	AAD	N	300.00	300.00	Y	2015-05-22 00:00:00.000	338362	YY	2015-05-18 00:00:00	164876	 	NULL	NULL	NULL
71987	1	2015-05-18 00:00:00	n029	2015-05-18 00:00:00	N	T	15030132	GS00034778	53098	_	T	12033	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-05-22 00:00:00.000	338368	YY	2015-05-18 00:00:00	120170	 	NULL	NULL	NULL
71988	1	2015-05-18 00:00:00	n029	2015-05-18 00:00:00	N	T	15030134	GS00034779	53099	_	T	12033	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-05-22 00:00:00.000	338369	YY	2015-05-18 00:00:00	120171	 	NULL	NULL	NULL
71989	1	2015-05-18 08:24:00	n087	2015-05-18 00:00:00	N	P	15050049	GS15001209	28522	_	T	4623	n1125	DG1	AA4	N	3000.00	3000.00	Y	2015-05-22 00:00:00.000	338363	YY	2015-05-18 00:00:00	164877	 	NULL	NULL	NULL
71990	1	2015-05-18 08:26:00	n087	2015-05-18 00:00:00	N	P	15050050	GS15001210	28523	_	T	4623	n1125	DG1	AA4	N	3000.00	3000.00	Y	2015-05-22 00:00:00.000	338364	YY	2015-05-18 00:00:00	164878	 	NULL	NULL	NULL
71991	1	2015-05-18 08:28:00	n087	2015-05-18 00:00:00	N	P	15050064	GS15001211	28526	_	T	555	n1486	UG1	AA3	N	3000.00	3000.00	Y	2015-05-22 00:00:00.000	338365	YY	2015-05-18 00:00:00	164879	 	NULL	NULL	NULL
71992	1	2015-05-18 08:32:00	n087	2015-05-18 00:00:00	N	P	15050185	GS15001212	27344	_	T	15569	n994	AC2	AAD	N	2400.00	2400.00	Y	2015-05-22 00:00:00.000	338366	YY	2015-05-18 00:00:00	164880	 	NULL	NULL	NULL
71993	1	2015-05-18 09:08:00	n087	2015-05-18 00:00:00	N	P	15050179	GS15001215	27718	_	T	13910	n1304	WS11	AJ2	N	6100.00	6100.00	Y	2015-05-22 00:00:00.000	338367	YY	2015-05-18 00:00:00	164883	 	NULL	NULL	NULL
71994	1	2015-05-18 00:00:00	n029	2015-05-19 00:00:00	N	T	15050147	GS00034781	66592	_	T	14952	n824	FE1	FE1	N	2400.00	2400.00	Y	2015-05-22 00:00:00.000	338375	YE	2015-05-19 00:00:00	120194	 	NULL	NULL	NULL
71995	1	2015-05-18 00:00:00	n029	2015-05-19 00:00:00	N	T	15050145	GS00034782	51903	_	T	12752	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-05-22 00:00:00.000	338376	YY	2015-05-19 00:00:00	120195	 	NULL	NULL	NULL
71996	1	2015-05-18 00:00:00	n029	2015-05-19 00:00:00	N	T	15050138	GS00034783	38605	_	T	6659	n646	FR1	FR1	N	4000.00	4000.00	Y	2015-05-22 00:00:00.000	338377	YY	2015-05-19 00:00:00	120196	 	NULL	NULL	NULL
71997	1	2015-05-18 00:00:00	n029	2015-05-19 00:00:00	N	T	15050139	GS00034784	38606	_	T	6659	n646	FR1	FR1	N	4000.00	4000.00	Y	2015-05-22 00:00:00.000	338378	YY	2015-05-19 00:00:00	120197	 	NULL	NULL	NULL
71998	1	2015-05-18 00:00:00	n029	2015-05-19 00:00:00	N	T	15050140	GS00034785	38607	_	T	6659	n646	FR1	FR1	N	4000.00	4000.00	Y	2015-05-22 00:00:00.000	338379	YY	2015-05-19 00:00:00	120199	 	NULL	NULL	NULL
71999	1	2015-05-18 00:00:00	n029	2015-05-19 00:00:00	N	T	15050141	GS00034786	39691	_	T	6659	n646	FR1	FR1	N	4000.00	4000.00	Y	2015-05-22 00:00:00.000	338380	YY	2015-05-19 00:00:00	120211	 	NULL	NULL	NULL
72000	1	2015-05-18 00:00:00	n029	2015-05-19 00:00:00	N	T	15050142	GS00034787	44107	_	T	6659	n646	FR1	FR1	N	4000.00	4000.00	Y	2015-05-22 00:00:00.000	338381	YY	2015-05-19 00:00:00	120213	 	NULL	NULL	NULL
72001	1	2015-05-18 00:00:00	n029	2015-05-19 00:00:00	N	T	15050146	GS00034788	66593	_	T	14800	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-05-22 00:00:00.000	338382	YY	2015-05-19 00:00:00	120216	 	NULL	NULL	NULL
72002	1	2015-05-18 00:00:00	n029	2015-05-19 00:00:00	N	T	15050135	GS00034789	38206	_	T	6939	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-05-22 00:00:00.000	338383	YY	2015-05-19 00:00:00	120217	 	NULL	NULL	NULL
72003	1	2015-05-19 00:00:00	n029	2015-05-19 00:00:00	N	T	15050152	GS00034790	62375	_	T	15117	n1350	FR1	FR1	N	4000.00	4000.00	Y	2015-05-22 00:00:00.000	338384	YY	2015-05-19 00:00:00	120233	 	NULL	NULL	NULL
72004	1	2015-05-19 08:43:00	n319	2015-05-19 00:00:00	N	P	15050192	GS15001218	28140	_	T	12000	n1304	WA3	AN5	N	1000.00	1000.00	Y	2015-05-22 00:00:00.000	338370	YY	2015-05-19 00:00:00	165075	 	NULL	NULL	NULL
72005	1	2015-05-19 08:44:00	n319	2015-05-19 00:00:00	N	P	15050193	GS15001219	28140	_	T	12000	n1304	WA3	AN5	N	1000.00	1000.00	Y	2015-05-22 00:00:00.000	338371	YY	2015-05-19 00:00:00	165076	 	NULL	NULL	NULL
72006	1	2015-05-19 08:52:00	n319	2015-05-19 00:00:00	N	P	15020250	GS15001222	28379	_	T	13930	n896	IG1E	AA2	N	10500.00	10500.00	Y	2015-05-22 00:00:00.000	338372	YY	2015-05-19 00:00:00	165079	 	NULL	NULL	NULL
72007	1	2015-05-19 00:00:00	n029	2015-05-19 00:00:00	N	T	15050148	GS00034791	66594	_	T	16045	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-05-22 00:00:00.000	338385	YE	2015-05-19 00:00:00	120244	 	NULL	NULL	NULL
72008	1	2015-05-19 00:00:00	n029	2015-05-19 00:00:00	N	T	15050149	GS00034792	66595	_	T	16045	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-05-22 00:00:00.000	338386	YE	2015-05-19 00:00:00	120245	 	NULL	NULL	NULL
72009	1	2015-05-19 00:00:00	n029	2015-05-19 00:00:00	N	T	15050150	GS00034793	66596	_	T	16045	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-05-22 00:00:00.000	338387	YE	2015-05-19 00:00:00	120246	 	NULL	NULL	NULL
72010	1	2015-05-19 00:00:00	n029	2015-05-19 00:00:00	N	T	15050151	GS00034794	66597	_	T	16045	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-05-22 00:00:00.000	338388	YE	2015-05-19 00:00:00	120247	 	NULL	NULL	NULL
72011	1	2015-05-19 09:41:00	n319	2015-05-19 00:00:00	N	P	15050215	GS15001229	19272	_	T	13265	n1125	WS2	AK2	N	8000.00	8000.00	Y	2015-05-22 00:00:00.000	338373	YE	2015-05-19 00:00:00	165087	 	NULL	NULL	NULL
72012	1	2015-05-19 11:11:00	n319	2015-05-19 00:00:00	N	P	15020012	GS15001221	28335	_	T	10747	n1065	AC2	AE21	N	3200.00	3200.00	Y	2015-05-22 00:00:00.000	338374	YY	2015-05-19 00:00:00	165078	 	NULL	NULL	NULL
72013	1	2015-05-19 00:00:00	n029	2015-05-20 00:00:00	N	T	15050164	GS00034795	66598	_	T	15743	n646	FE11	FE11	N	5400.00	5400.00	Y	2015-05-22 00:00:00.000	338399	YE	2015-05-20 00:00:00	120291	 	NULL	NULL	NULL
72014	1	2015-05-19 00:00:00	n029	2015-05-20 00:00:00	N	T	15050178	GS00034796	65742	_	T	14643	n1350	FF0	FF0	N	2500.00	2500.00	Y	2015-05-22 00:00:00.000	338400	YY	2015-05-20 00:00:00	120292	 	NULL	NULL	NULL
72015	1	2015-05-19 00:00:00	n029	2015-05-20 00:00:00	N	T	15050174	GS00034797	65737	_	T	15779	n646	FF0	FF0	N	2500.00	2500.00	Y	2015-05-22 00:00:00.000	338401	YY	2015-05-20 00:00:00	120293	 	NULL	NULL	NULL
72016	1	2015-05-19 00:00:00	n029	2015-05-20 00:00:00	N	T	15050159	GS00034798	65805	_	T	15554	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-05-22 00:00:00.000	338402	YY	2015-05-20 00:00:00	120294	 	NULL	NULL	NULL
72017	1	2015-05-19 00:00:00	n029	2015-05-20 00:00:00	N	T	15050160	GS00034799	65807	_	T	15554	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-05-22 00:00:00.000	338403	YY	2015-05-20 00:00:00	120295	 	NULL	NULL	NULL
72018	1	2015-05-19 00:00:00	n029	2015-05-20 00:00:00	N	T	15050158	GS00034800	53858	_	T	13221	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-05-22 00:00:00.000	338404	YY	2015-05-20 00:00:00	120300	 	NULL	NULL	NULL
72019	1	2015-05-19 00:00:00	n029	2015-05-20 00:00:00	N	T	15050161	GS00034801	53166	_	T	13105	n646	FR1	FR1	N	4000.00	4000.00	Y	2015-05-22 00:00:00.000	338405	YY	2015-05-20 00:00:00	120306	 	NULL	NULL	NULL
72020	1	2015-05-19 00:00:00	n029	2015-05-20 00:00:00	N	T	15050162	GS00034802	53112	_	T	13098	n646	FR1	FR1	N	4000.00	4000.00	Y	2015-05-22 00:00:00.000	338406	YY	2015-05-20 00:00:00	120307	 	NULL	NULL	NULL
72021	1	2015-05-19 16:42:00	n319	2015-05-20 00:00:00	N	P	15050214	GS15001230	27062	_	T	13042	n650	WS11	AJ2	N	6100.00	6100.00	Y	2015-05-22 00:00:00.000	338389	YY	2015-05-20 00:00:00	165181	 	NULL	NULL	NULL
72022	1	2015-05-19 00:00:00	n029	2015-05-20 00:00:00	N	T	15050180	GS00034803	65953	_	T	15634	n1350	FF0	FF0	N	2500.00	2500.00	Y	2015-05-22 00:00:00.000	338407	YY	2015-05-20 00:00:00	120327	 	NULL	NULL	NULL
72023	1	2015-05-19 00:00:00	n029	2015-05-20 00:00:00	N	T	15050181	GS00034804	65954	_	T	15634	n1350	FF0	FF0	N	2500.00	2500.00	Y	2015-05-22 00:00:00.000	338408	YY	2015-05-20 00:00:00	120328	 	NULL	NULL	NULL
72024	1	2015-05-19 16:44:00	n319	2015-05-20 00:00:00	N	P	15030059	GS15001231	28388	_	T	12000	n1304	IG1B	AA21	N	9700.00	9700.00	Y	2015-05-22 00:00:00.000	338390	YY	2015-05-20 00:00:00	165182	 	NULL	NULL	NULL
72025	1	2015-05-19 00:00:00	n029	2015-05-20 00:00:00	N	T	15050182	GS00034805	65956	_	T	15634	n1350	FF0	FF0	N	2500.00	2500.00	Y	2015-05-22 00:00:00.000	338409	YY	2015-05-20 00:00:00	120329	 	NULL	NULL	NULL
72026	1	2015-05-19 00:00:00	n029	2015-05-20 00:00:00	N	T	15050183	GS00034806	66599	_	T	14476	n428	FE1	FE1	N	2400.00	2400.00	Y	2015-05-22 00:00:00.000	338410	YE	2015-05-20 00:00:00	120334	 	NULL	NULL	NULL
72027	1	2015-05-19 00:00:00	n029	2015-05-20 00:00:00	N	T	15050184	GS00034807	66600	_	T	14476	n428	FE1	FE1	N	2400.00	2400.00	Y	2015-05-22 00:00:00.000	338411	YE	2015-05-20 00:00:00	120335	 	NULL	NULL	NULL
72028	1	2015-05-20 08:43:00	n319	2015-05-20 00:00:00	N	P	15050164	GS15001233	1127	M	T	12575	n113	WS1	AJ1	X	3500.00	3500.00	Y	2015-05-22 00:00:00.000	338391	YY	2015-05-20 00:00:00	165184	 	NULL	NULL	NULL
72029	1	2015-05-20 08:44:00	n319	2015-05-20 00:00:00	N	P	15050180	GS15001234	1128	M	T	15002	n113	WS21	AK3	X	5600.00	5600.00	Y	2015-05-22 00:00:00.000	338392	YY	2015-05-20 00:00:00	165185	 	NULL	NULL	NULL
72030	1	2015-05-20 08:45:00	n319	2015-05-20 00:00:00	N	P	15050103	GS15001235	1169	M	T	15548	n113	WS1	AJ1	X	3500.00	3500.00	Y	2015-05-22 00:00:00.000	338393	YY	2015-05-20 00:00:00	165186	 	NULL	NULL	NULL
72031	1	2015-05-20 08:49:00	n319	2015-05-20 00:00:00	N	P	15050188	GS15001238	27601	_	T	13930	n896	WS1	AJ1	N	23500.00	23500.00	Y	2015-05-22 00:00:00.000	338394	YY	2015-05-20 00:00:00	165189	 	NULL	NULL	NULL
72032	1	2015-05-20 08:57:00	n319	2015-05-20 00:00:00	N	P	15030124	GS15001239	28400	_	T	10747	n1065	UG1	AA3	N	3000.00	3000.00	Y	2015-05-22 00:00:00.000	338395	YY	2015-05-20 00:00:00	165190	 	NULL	NULL	NULL
72033	1	2015-05-20 09:31:00	n319	2015-05-20 00:00:00	N	P	15050221	GS15001241	23445	_	T	15782	n1125	WS2	AK2	N	4000.00	4000.00	Y	2015-05-22 00:00:00.000	338396	YY	2015-05-20 00:00:00	165192	 	NULL	NULL	NULL
72034	1	2015-05-20 09:52:00	n319	2015-05-20 00:00:00	N	P	15040181	GS15001246	28494	_	T	15942	n113	IG1E	AA2	N	10500.00	10500.00	Y	2015-05-22 00:00:00.000	338397	YY	2015-05-20 00:00:00	165200	 	NULL	NULL	NULL
72035	1	2015-05-20 09:53:00	n319	2015-05-20 00:00:00	N	P	15040182	GS15001247	28495	_	T	15942	n113	UG1	AA3	N	3000.00	3000.00	Y	2015-05-22 00:00:00.000	338398	YY	2015-05-20 00:00:00	165201	 	NULL	NULL	NULL
72036	1	2015-05-20 00:00:00	n029	2015-05-21 00:00:00	N	T	15050185	GS00034808	66015	_	T	15348	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-05-25 00:00:00.000	338468	YY	2015-05-21 00:00:00	120341	 	NULL	NULL	NULL
72037	1	2015-05-20 16:50:00	n319	2015-05-21 00:00:00	N	P	15050231	GS15001249	27371	_	T	13444	n650	WS11	AJ2	N	2700.00	2700.00	Y	2015-05-25 00:00:00.000	338460	YY	2015-05-21 00:00:00	165282	 	NULL	NULL	NULL
72038	1	2015-05-21 00:00:00	n029	2015-05-21 00:00:00	N	T	15050186	GS00034809	66603	_	T	16042	n646	FE1	FE1	N	2400.00	2400.00	Y	2015-05-25 00:00:00.000	338469	YE	2015-05-21 00:00:00	120401	 	NULL	NULL	NULL
72039	1	2015-05-21 00:00:00	n029	2015-05-21 00:00:00	N	T	15050187	GS00034810	66601	_	T	13403	n530	FE1	FE1	N	2400.00	2400.00	Y	2015-05-25 00:00:00.000	338470	YE	2015-05-21 00:00:00	120402	 	NULL	NULL	NULL
72040	1	2015-05-21 00:00:00	n029	2015-05-21 00:00:00	N	T	15050188	GS00034811	66602	_	T	13403	n530	FE1	FE1	N	2400.00	2400.00	Y	2015-05-25 00:00:00.000	338471	YE	2015-05-21 00:00:00	120403	 	NULL	NULL	NULL
72041	1	2015-05-21 08:45:00	n319	2015-05-21 00:00:00	N	P	15050233	GS15001252	26956	_	T	15223	n1304	WS11	AJ2	N	6100.00	6100.00	Y	2015-05-25 00:00:00.000	338461	YY	2015-05-21 00:00:00	165285	 	NULL	NULL	NULL
72042	1	2015-05-21 08:47:00	n319	2015-05-21 00:00:00	N	P	15050220	GS15001253	27366	_	T	14544	n1125	WS21	AK3	N	1700.00	1700.00	Y	2015-05-25 00:00:00.000	338462	YY	2015-05-21 00:00:00	165287	 	NULL	NULL	NULL
72043	1	2015-05-21 08:49:00	n319	2015-05-21 00:00:00	N	P	15040239	GS15001254	28505	_	T	13708	n896	UG1	AA3	N	3000.00	3000.00	Y	2015-05-25 00:00:00.000	338463	YY	2015-05-21 00:00:00	165289	 	NULL	NULL	NULL
72044	1	2015-05-21 09:06:00	n319	2015-05-21 00:00:00	N	P	15030414	GS15001256	1175	M	T	15548	n113	AC2	AAD	X	11200.00	11200.00	Y	2015-05-25 00:00:00.000	338464	YY	2015-05-21 00:00:00	165292	 	NULL	NULL	NULL
72045	1	2015-05-21 09:36:00	n319	2015-05-21 00:00:00	N	P	15040221	GS15001257	28502	_	T	13444	n650	IG1E	AA2	N	10500.00	10500.00	Y	2015-05-25 00:00:00.000	338465	YY	2015-05-21 00:00:00	165293	 	NULL	NULL	NULL
72046	1	2015-05-21 09:38:00	n319	2015-05-21 00:00:00	N	P	15050085	GS15001258	28528	_	T	13708	n896	IG1E	AA2	N	10500.00	10500.00	Y	2015-05-25 00:00:00.000	338466	YY	2015-05-21 00:00:00	165294	 	NULL	NULL	NULL
72047	1	2015-05-21 09:40:00	n319	2015-05-21 00:00:00	N	P	15050242	GS15001259	20888	_	T	13824	n650	WS2	AK2	N	5000.00	5000.00	Y	2015-05-25 00:00:00.000	338467	YE	2015-05-21 00:00:00	165295	 	NULL	NULL	NULL
72048	1	2015-05-21 00:00:00	n029	2015-05-22 00:00:00	N	T	15050199	GS00034812	66604	_	T	15420	n530	FE1	FE1	N	12000.00	12000.00	Y	2015-05-27 00:00:00.000	338525	YE	2015-05-22 00:00:00	120474	 	NULL	NULL	NULL
72049	1	2015-05-21 00:00:00	n029	2015-05-22 00:00:00	N	T	15050165	GS00034815	61238	_	T	13501	n1384	FF2	FF2	N	1500.00	1500.00	Y	2015-05-27 00:00:00.000	338526	YY	2015-05-22 00:00:00	120477	 	NULL	NULL	NULL
72050	1	2015-05-21 00:00:00	n029	2015-05-22 00:00:00	N	T	15050166	GS00034816	61261	_	T	13501	n1384	FF2	FF2	N	1500.00	1500.00	Y	2015-05-27 00:00:00.000	338527	YY	2015-05-22 00:00:00	120478	 	NULL	NULL	NULL
72051	1	2015-05-21 00:00:00	n029	2015-05-22 00:00:00	N	T	15050216	GS00034817	52488	_	T	4610	n547	FR1	FR1	N	4000.00	4000.00	Y	2015-05-27 00:00:00.000	338528	YY	2015-05-22 00:00:00	120479	 	NULL	NULL	NULL
72052	1	2015-05-21 00:00:00	n029	2015-05-22 00:00:00	N	T	15050217	GS00034818	52489	_	T	4610	n547	FR1	FR1	N	4000.00	4000.00	Y	2015-05-27 00:00:00.000	338529	YY	2015-05-22 00:00:00	120480	 	NULL	NULL	NULL
72053	1	2015-05-21 00:00:00	n029	2015-05-22 00:00:00	N	T	15050218	GS00034819	52490	_	T	4610	n547	FR1	FR1	N	4000.00	4000.00	Y	2015-05-27 00:00:00.000	338530	YY	2015-05-22 00:00:00	120481	 	NULL	NULL	NULL
72054	1	2015-05-21 00:00:00	n029	2015-05-22 00:00:00	N	T	15050219	GS00034820	52487	_	T	4610	n547	FR1	FR1	N	4000.00	4000.00	Y	2015-05-27 00:00:00.000	338531	YY	2015-05-22 00:00:00	120482	 	NULL	NULL	NULL
72055	1	2015-05-21 00:00:00	n029	2015-05-22 00:00:00	N	T	15050220	GS00034821	53138	_	T	4610	n547	FR1	FR1	N	4000.00	4000.00	Y	2015-05-27 00:00:00.000	338532	YY	2015-05-22 00:00:00	120483	 	NULL	NULL	NULL
72056	1	2015-05-21 00:00:00	n029	2015-05-22 00:00:00	N	T	15050221	GS00034822	53139	_	T	4610	n547	FR1	FR1	N	4000.00	4000.00	Y	2015-05-27 00:00:00.000	338533	YY	2015-05-22 00:00:00	120484	 	NULL	NULL	NULL
72057	1	2015-05-21 00:00:00	n029	2015-05-22 00:00:00	N	T	15050222	GS00034823	52875	_	T	4610	n547	FR1	FR1	N	4000.00	4000.00	Y	2015-05-27 00:00:00.000	338534	YY	2015-05-22 00:00:00	120485	 	NULL	NULL	NULL
72058	1	2015-05-22 00:00:00	n029	2015-05-22 00:00:00	N	T	15050212	GS00034824	66131	_	T	15917	n1384	FN1	FN1	N	1000.00	1000.00	Y	2015-05-27 00:00:00.000	338535	YY	2015-05-22 00:00:00	120486	 	NULL	NULL	NULL
72059	1	2015-05-22 00:00:00	n029	2015-05-22 00:00:00	N	T	15050213	GS00034825	66131	_	T	15917	n1384	FN1	FN1	N	1000.00	1000.00	Y	2015-05-27 00:00:00.000	338536	YY	2015-05-22 00:00:00	120487	 	NULL	NULL	NULL
72060	1	2015-05-22 00:00:00	n029	2015-05-22 00:00:00	N	T	15050214	GS00034826	66132	_	T	15917	n1384	FN1	FN1	N	1000.00	1000.00	Y	2015-05-27 00:00:00.000	338537	YY	2015-05-22 00:00:00	120488	 	NULL	NULL	NULL
72061	1	2015-05-22 00:00:00	n029	2015-05-22 00:00:00	N	T	15050215	GS00034827	66132	_	T	15917	n1384	FN1	FN1	N	1000.00	1000.00	Y	2015-05-27 00:00:00.000	338538	YY	2015-05-22 00:00:00	120489	 	NULL	NULL	NULL
72062	1	2015-05-22 00:00:00	n029	2015-05-22 00:00:00	N	T	15050189	GS00034828	66605	_	T	15733	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-05-27 00:00:00.000	338539	YE	2015-05-22 00:00:00	120493	 	NULL	NULL	NULL
72063	1	2015-05-22 00:00:00	n029	2015-05-22 00:00:00	N	T	15050190	GS00034829	66606	_	T	15733	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-05-27 00:00:00.000	338540	YE	2015-05-22 00:00:00	120494	 	NULL	NULL	NULL
72064	1	2015-05-22 00:00:00	n029	2015-05-22 00:00:00	N	T	15050191	GS00034830	66607	_	T	15733	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-05-27 00:00:00.000	338541	YE	2015-05-22 00:00:00	120495	 	NULL	NULL	NULL
72065	1	2015-05-22 00:00:00	n029	2015-05-22 00:00:00	N	T	15050192	GS00034831	66608	_	T	15733	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-05-27 00:00:00.000	338542	YE	2015-05-22 00:00:00	120496	 	NULL	NULL	NULL
72066	1	2015-05-22 00:00:00	n029	2015-05-22 00:00:00	N	T	15050193	GS00034832	66609	_	T	15733	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-05-27 00:00:00.000	338543	YE	2015-05-22 00:00:00	120497	 	NULL	NULL	NULL
72067	1	2015-05-22 00:00:00	n029	2015-05-22 00:00:00	N	T	15050194	GS00034833	66610	_	T	15733	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-05-27 00:00:00.000	338544	YE	2015-05-22 00:00:00	120498	 	NULL	NULL	NULL
72068	1	2015-05-22 00:00:00	n029	2015-05-22 00:00:00	N	T	15050195	GS00034834	66611	_	T	15733	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-05-27 00:00:00.000	338545	YE	2015-05-22 00:00:00	120499	 	NULL	NULL	NULL
72069	1	2015-05-22 00:00:00	n029	2015-05-22 00:00:00	N	T	15050196	GS00034835	66612	_	T	15733	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-05-27 00:00:00.000	338546	YE	2015-05-22 00:00:00	120501	 	NULL	NULL	NULL
72070	1	2015-05-22 00:00:00	n029	2015-05-22 00:00:00	N	T	15050200	GS00034836	66613	_	T	13321	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-05-27 00:00:00.000	338547	YE	2015-05-22 00:00:00	120502	 	NULL	NULL	NULL
72071	1	2015-05-22 00:00:00	n029	2015-05-22 00:00:00	N	T	15050201	GS00034837	66614	_	T	13321	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-05-27 00:00:00.000	338548	YE	2015-05-22 00:00:00	120503	 	NULL	NULL	NULL
72072	1	2015-05-22 00:00:00	n029	2015-05-22 00:00:00	N	T	15050202	GS00034838	66615	_	T	13321	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-05-27 00:00:00.000	338549	YE	2015-05-22 00:00:00	120505	 	NULL	NULL	NULL
72073	1	2015-05-22 00:00:00	n029	2015-05-22 00:00:00	N	T	15050203	GS00034839	66616	_	T	13321	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-05-27 00:00:00.000	338550	YE	2015-05-22 00:00:00	120506	 	NULL	NULL	NULL
72074	1	2015-05-22 00:00:00	n029	2015-05-22 00:00:00	N	T	15050204	GS00034840	66617	_	T	13321	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-05-27 00:00:00.000	338551	YE	2015-05-22 00:00:00	120507	 	NULL	NULL	NULL
72075	1	2015-05-22 00:00:00	n029	2015-05-22 00:00:00	N	T	15050205	GS00034841	66618	_	T	13321	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-05-27 00:00:00.000	338552	YE	2015-05-22 00:00:00	120508	 	NULL	NULL	NULL
72076	1	2015-05-22 09:11:00	n319	2015-05-22 00:00:00	N	P	14100216	GS15001265	28076	_	T	15850	n896	IG1E	AA2	N	10500.00	10500.00	Y	2015-05-27 00:00:00.000	338520	YY	2015-05-22 00:00:00	165375	 	NULL	NULL	NULL
72077	1	2015-05-22 00:00:00	n029	2015-05-22 00:00:00	N	T	15050206	GS00034842	66619	_	T	13321	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-05-27 00:00:00.000	338553	YE	2015-05-22 00:00:00	120509	 	NULL	NULL	NULL
72078	1	2015-05-22 09:13:00	n319	2015-05-22 00:00:00	N	P	14100217	GS15001266	28077	_	T	15850	n896	IG1E	AA2	N	10500.00	10500.00	Y	2015-05-27 00:00:00.000	338521	YY	2015-05-22 00:00:00	165376	 	NULL	NULL	NULL
72079	1	2015-05-22 00:00:00	n029	2015-05-22 00:00:00	N	T	15050207	GS00034843	66620	_	T	13321	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-05-27 00:00:00.000	338554	YE	2015-05-22 00:00:00	120510	 	NULL	NULL	NULL
72080	1	2015-05-22 09:34:00	n319	2015-05-22 00:00:00	N	P	15040316	GS15001269	28516	_	T	16032	n994	IG1B	AA21	N	9700.00	11300.00	Y	2015-05-27 00:00:00.000	338522	YY	2015-05-22 00:00:00	165380	 	NULL	NULL	NULL
72081	1	2015-05-22 09:34:00	n319	2015-05-22 00:00:00	N	P	15050254	GS15001269	28516	_	T	16032	n994	AC2	AA21	N	1600.00	11300.00	Y	2015-05-27 00:00:00.000	338523	YY	2015-05-22 00:00:00	165380	 	NULL	NULL	NULL
72082	1	2015-05-22 09:41:00	n319	2015-05-22 00:00:00	N	P	15050246	GS15001270	22058	_	T	13002	n650	WS2	AK2	N	8000.00	8000.00	Y	2015-05-27 00:00:00.000	338524	YE	2015-05-22 00:00:00	165381	 	NULL	NULL	NULL
72083	1	2015-05-22 16:44:00	n319	2015-05-25 00:00:00	N	P	15050257	GS15001271	27937	_	T	15800	n1489	WS1	AJ1	N	3500.00	3500.00	Y	2015-05-27 00:00:00.000	338555	YY	2015-05-25 00:00:00	165451	 	NULL	NULL	NULL
72084	1	2015-05-25 00:00:00	n029	2015-05-25 00:00:00	N	T	15050265	GS00034845	66621	_	T	14554	n441	FE1	FE1	N	2400.00	2400.00	Y	2015-05-27 00:00:00.000	338558	YE	2015-05-25 00:00:00	120583	 	NULL	NULL	NULL
72085	1	2015-05-25 00:00:00	n029	2015-05-25 00:00:00	N	T	15050267	GS00034846	66622	_	T	16038	n441	FE1	FE1	N	2400.00	2400.00	Y	2015-05-27 00:00:00.000	338559	YE	2015-05-25 00:00:00	120584	 	NULL	NULL	NULL
72086	1	2015-05-25 00:00:00	n029	2015-05-25 00:00:00	N	T	15050266	GS00034847	66623	_	T	16038	n441	FE1	FE1	N	2400.00	2400.00	Y	2015-05-27 00:00:00.000	338560	YE	2015-05-25 00:00:00	120585	 	NULL	NULL	NULL
72087	1	2015-05-25 08:40:00	n319	2015-05-25 00:00:00	N	P	15040290	GS15001273	28510	_	T	16028	n1065	UG1	AA3	N	3000.00	3000.00	Y	2015-05-27 00:00:00.000	338556	YY	2015-05-25 00:00:00	165453	 	NULL	NULL	NULL
72088	1	2015-05-25 09:42:00	n319	2015-05-25 00:00:00	N	P	15040052	GS15001277	28459	_	T	15569	n994	IG1B	AA21	N	9700.00	9700.00	Y	2015-05-27 00:00:00.000	338557	YY	2015-05-25 00:00:00	165457	 	NULL	NULL	NULL
72089	1	2015-05-25 15:33:00	n319	2015-05-26 00:00:00	N	P	15040003	GS15001280	28451	_	T	4314	n1304	UG1	AA3	N	3000.00	3000.00	Y	2015-05-28 00:00:00.000	338903	YY	2015-05-26 00:00:00	165529	 	NULL	NULL	NULL
72090	1	2015-05-26 08:41:00	n319	2015-05-26 00:00:00	N	P	15030200	GS15001282	28409	_	T	12548	n896	IG1E	AA2	N	10500.00	10500.00	Y	2015-05-28 00:00:00.000	338904	YY	2015-05-26 00:00:00	165577	 	NULL	NULL	NULL
72091	1	2015-05-26 08:43:00	n319	2015-05-26 00:00:00	N	P	15030201	GS15001283	28410	_	T	12548	n896	UG1	AA3	N	3000.00	3000.00	Y	2015-05-28 00:00:00.000	338905	YY	2015-05-26 00:00:00	165578	 	NULL	NULL	NULL
72092	1	2015-05-26 08:49:00	n319	2015-05-26 00:00:00	N	P	15050283	GS15001284	25315	_	T	437	n1065	WS21	AK3	N	8400.00	8400.00	Y	2015-05-28 00:00:00.000	338906	YY	2015-05-26 00:00:00	165580	 	NULL	NULL	NULL
72093	1	2015-05-26 08:50:00	n319	2015-05-26 00:00:00	N	P	15050271	GS15001285	27406	_	T	15519	n1065	WS11	AJ2	N	17500.00	17500.00	Y	2015-05-28 00:00:00.000	338907	YY	2015-05-26 00:00:00	165581	 	NULL	NULL	NULL
72094	1	2015-05-26 08:51:00	n319	2015-05-26 00:00:00	N	P	15050284	GS15001286	28185	_	T	15884	n1065	WS11	AJ2	N	2700.00	2700.00	Y	2015-05-28 00:00:00.000	338908	YY	2015-05-26 00:00:00	165582	 	NULL	NULL	NULL
72095	1	2015-05-26 09:06:00	n319	2015-05-26 00:00:00	N	P	15050294	GS15001287	23973	_	T	13648	n650	WS21	AK3	N	1700.00	1700.00	Y	2015-05-28 00:00:00.000	338909	YY	2015-05-26 00:00:00	165583	 	NULL	NULL	NULL
72096	1	2015-05-26 09:07:00	n319	2015-05-26 00:00:00	N	P	15050295	GS15001288	24383	_	T	13648	n650	WS21	AK3	N	2800.00	2800.00	Y	2015-05-28 00:00:00.000	338910	YY	2015-05-26 00:00:00	165584	 	NULL	NULL	NULL
72097	1	2015-05-26 09:08:00	n319	2015-05-26 00:00:00	N	P	15050296	GS15001289	26419	_	T	13648	n650	WS21	AK3	N	1700.00	1700.00	Y	2015-05-28 00:00:00.000	338911	YY	2015-05-26 00:00:00	165585	 	NULL	NULL	NULL
72098	1	2015-05-26 09:09:00	n319	2015-05-26 00:00:00	N	P	15050297	GS15001290	26677	_	T	13648	n650	WS21	AK3	N	1700.00	1700.00	Y	2015-05-28 00:00:00.000	338912	YY	2015-05-26 00:00:00	165586	 	NULL	NULL	NULL
72099	1	2015-05-26 09:43:00	n319	2015-05-26 00:00:00	N	P	15040050	GS15001294	28457	_	T	15569	n994	IG1B	AA21	N	9700.00	9700.00	Y	2015-05-28 00:00:00.000	338913	YY	2015-05-26 00:00:00	165590	 	NULL	NULL	NULL
72100	1	2015-05-26 09:44:00	n319	2015-05-26 00:00:00	N	P	15050277	GS15001295	1079	M	T	12293	n113	WS2	AK2	X	5000.00	5000.00	Y	2015-05-28 00:00:00.000	338914	YE	2015-05-26 00:00:00	165591	 	NULL	NULL	NULL
72101	1	2015-05-26 09:44:00	n319	2015-05-26 00:00:00	N	P	15050298	GS15001296	18138	_	T	13265	n1125	WS2	AK2	N	16000.00	16000.00	Y	2015-05-28 00:00:00.000	338915	YE	2015-05-26 00:00:00	165592	 	NULL	NULL	NULL
72102	1	2015-05-26 09:44:00	n319	2015-05-26 00:00:00	N	P	15050243	GS15001297	20266	_	T	12406	n650	WS2	AK2	N	5000.00	5000.00	Y	2015-05-28 00:00:00.000	338916	YE	2015-05-26 00:00:00	165593	 	NULL	NULL	NULL
72103	1	2015-05-26 13:35:00	n319	2015-05-26 00:00:00	N	P	15050235	GS15001298	28558	_	T	14737	n650	DG1	AA4	N	3000.00	3000.00	Y	2015-05-28 00:00:00.000	338917	YY	2015-05-26 00:00:00	165648	 	NULL	NULL	NULL
72104	1	2015-05-26 13:36:00	n319	2015-05-26 00:00:00	N	P	15050236	GS15001299	28559	_	T	14737	n650	DG1	AA4	N	3000.00	3000.00	Y	2015-05-28 00:00:00.000	338918	YY	2015-05-26 00:00:00	165649	 	NULL	NULL	NULL
72105	1	2015-05-26 00:00:00	n029	2015-05-27 00:00:00	N	T	15050280	GS00034851	65980	_	T	15886	n646	FF0	FF0	N	12500.00	12500.00	Y	2015-05-28 00:00:00.000	338934	YY	2015-05-27 00:00:00	120733	 	NULL	NULL	NULL
72106	1	2015-05-26 13:37:00	n319	2015-05-26 00:00:00	N	P	15050237	GS15001300	28560	_	T	14737	n650	DG1	AA4	N	3000.00	3000.00	Y	2015-05-28 00:00:00.000	338919	YY	2015-05-26 00:00:00	165650	 	NULL	NULL	NULL
72107	1	2015-05-26 13:38:00	n319	2015-05-26 00:00:00	N	P	15050288	GS15001301	28571	_	T	14737	n650	DG1	AA4	N	3000.00	3000.00	Y	2015-05-28 00:00:00.000	338920	YY	2015-05-26 00:00:00	165651	 	NULL	NULL	NULL
72108	1	2015-05-26 00:00:00	n029	2015-05-27 00:00:00	N	T	15050281	GS00034852	52824	_	T	6637	n1350	FR1	FR1	N	4000.00	4000.00	Y	2015-05-28 00:00:00.000	338935	YY	2015-05-27 00:00:00	120734	 	NULL	NULL	NULL
72109	1	2015-05-26 13:39:00	n319	2015-05-26 00:00:00	N	P	15050289	GS15001302	28572	_	T	14737	n650	DG1	AA4	N	3000.00	3000.00	Y	2015-05-28 00:00:00.000	338921	YY	2015-05-26 00:00:00	165652	 	NULL	NULL	NULL
72110	1	2015-05-26 13:42:00	n319	2015-05-26 00:00:00	N	P	15050291	GS15001303	28573	_	T	10747	n1065	UG1	AA3	N	3000.00	3000.00	Y	2015-05-28 00:00:00.000	338922	YY	2015-05-26 00:00:00	165653	 	NULL	NULL	NULL
72111	1	2015-05-26 13:44:00	n319	2015-05-26 00:00:00	N	P	15050292	GS15001304	28574	_	T	10747	n1065	UG1	AA3	N	3000.00	3000.00	Y	2015-05-28 00:00:00.000	338923	YY	2015-05-26 00:00:00	165654	 	NULL	NULL	NULL
72112	1	2015-05-26 13:45:00	n319	2015-05-26 00:00:00	N	P	15050300	GS15001305	28575	_	T	10747	n1065	UG1	AA3	N	3000.00	3000.00	Y	2015-05-28 00:00:00.000	338924	YY	2015-05-26 00:00:00	165655	 	NULL	NULL	NULL
72113	1	2015-05-26 17:06:00	n319	2015-05-27 00:00:00	N	P	15030042	GS15001307	28386	_	T	13639	n100	IG1E	AA2	N	10500.00	12100.00	Y	2015-05-28 00:00:00.000	338925	YY	2015-05-27 00:00:00	165674	 	NULL	NULL	NULL
72114	1	2015-05-26 17:06:00	n319	2015-05-27 00:00:00	N	P	15050302	GS15001307	28386	_	T	13639	n100	AC2	AA2	N	1600.00	12100.00	Y	2015-05-28 00:00:00.000	338926	YY	2015-05-27 00:00:00	165674	 	NULL	NULL	NULL
72115	1	2015-05-26 17:10:00	n319	2015-05-27 00:00:00	N	P	14110003	GS15001309	28115	_	T	13444	n650	IG1E	AA2	N	10500.00	10500.00	Y	2015-05-28 00:00:00.000	338927	YY	2015-05-27 00:00:00	165676	 	NULL	NULL	NULL
72116	1	2015-05-26 17:12:00	n319	2015-05-27 00:00:00	N	P	15040337	GS15001310	28515	_	T	15569	n994	IG1B	AA21	N	9700.00	11300.00	Y	2015-05-28 00:00:00.000	338928	YY	2015-05-27 00:00:00	165677	 	NULL	NULL	NULL
72117	1	2015-05-26 17:12:00	n319	2015-05-27 00:00:00	N	P	15050306	GS15001310	28515	_	T	15569	n994	AC2	AA21	N	1600.00	11300.00	Y	2015-05-28 00:00:00.000	338929	YY	2015-05-27 00:00:00	165677	 	NULL	NULL	NULL
72118	1	2015-05-27 00:00:00	n029	2015-05-27 00:00:00	N	T	15050277	GS00034853	66624	_	T	7341	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-05-28 00:00:00.000	338936	YY	2015-05-27 00:00:00	120768	 	NULL	NULL	NULL
72119	1	2015-05-27 00:00:00	n029	2015-05-27 00:00:00	N	T	15050287	GS00034854	64854	_	T	6138	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-05-28 00:00:00.000	338937	YY	2015-05-27 00:00:00	120769	 	NULL	NULL	NULL
72120	1	2015-05-27 00:00:00	n029	2015-05-27 00:00:00	N	T	15050273	GS00034855	66625	_	T	15361	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-05-28 00:00:00.000	338938	YY	2015-05-27 00:00:00	120770	 	NULL	NULL	NULL
72121	1	2015-05-27 00:00:00	n029	2015-05-27 00:00:00	N	T	15050274	GS00034856	66626	_	T	15361	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-05-28 00:00:00.000	338939	YY	2015-05-27 00:00:00	120771	 	NULL	NULL	NULL
72122	1	2015-05-27 00:00:00	n029	2015-05-27 00:00:00	N	T	15050275	GS00034857	66627	_	T	15361	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-05-28 00:00:00.000	338940	YY	2015-05-27 00:00:00	120772	 	NULL	NULL	NULL
72123	1	2015-05-27 00:00:00	n029	2015-05-27 00:00:00	N	T	15050276	GS00034858	66628	_	T	15361	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-05-28 00:00:00.000	338941	YY	2015-05-27 00:00:00	120773	 	NULL	NULL	NULL
72124	1	2015-05-27 00:00:00	n029	2015-05-27 00:00:00	N	T	15050286	GS00034859	66629	_	T	16051	n441	FE1	FE1	N	2400.00	2400.00	Y	2015-05-28 00:00:00.000	338942	YE	2015-05-27 00:00:00	120774	 	NULL	NULL	NULL
72125	1	2015-05-27 08:41:00	n319	2015-05-27 00:00:00	N	P	15050250	GS15001313	28505	_	T	13708	n896	WA3	AN5	D	1000.00	1000.00	Y	2015-05-28 00:00:00.000	338930	YY	2015-05-27 00:00:00	165680	 	NULL	NULL	NULL
72126	1	2015-05-27 09:31:00	n319	2015-05-27 00:00:00	N	P	15050251	GS15001314	28528	_	T	13708	n896	WA3	AN5	D	2000.00	3000.00	Y	2015-05-28 00:00:00.000	338931	YY	2015-05-27 00:00:00	165684	 	NULL	NULL	NULL
72127	1	2015-05-27 09:31:00	n319	2015-05-27 00:00:00	N	P	15050309	GS15001314	28528	_	T	13708	n896	WA3	AN5	D	1000.00	3000.00	Y	2015-05-28 00:00:00.000	338932	YY	2015-05-27 00:00:00	165684	 	NULL	NULL	NULL
72128	1	2015-05-27 15:30:00	n319	2015-05-27 00:00:00	N	P	15050319	GS15001315	28577	_	T	4610	n994	IG1B	AA21	N	9700.00	9700.00	Y	2015-05-28 00:00:00.000	338933	YY	2015-05-27 00:00:00	165751	 	NULL	NULL	NULL
72129	1	2015-05-27 15:48:00	n319	2015-05-28 00:00:00	N	P	15050266	GS15001316	27763	_	T	15749	n1489	WA3	AN5	D	1000.00	1000.00	Y	2015-05-29 00:00:00.000	339348	YY	2015-05-28 00:00:00	165752	 	NULL	NULL	NULL
72130	1	2015-05-27 15:51:00	n319	2015-05-28 00:00:00	N	P	15050265	GS15001317	27831	_	T	15762	n1489	WA3	AN5	D	1000.00	1000.00	Y	2015-05-29 00:00:00.000	339349	YY	2015-05-28 00:00:00	165753	 	NULL	NULL	NULL
72131	1	2015-05-28 00:00:00	n029	2015-05-28 00:00:00	N	T	15050293	GS00034860	64960	_	T	15608	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-05-29 00:00:00.000	339354	YY	2015-05-28 00:00:00	120828	 	NULL	NULL	NULL
72132	1	2015-05-28 00:00:00	n029	2015-05-28 00:00:00	N	T	15050294	GS00034861	65917	_	T	15193	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-05-29 00:00:00.000	339355	YY	2015-05-28 00:00:00	120829	 	NULL	NULL	NULL
72133	1	2015-05-28 00:00:00	n029	2015-05-28 00:00:00	N	T	15050295	GS00034862	65919	_	T	15193	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-05-29 00:00:00.000	339356	YY	2015-05-28 00:00:00	120830	 	NULL	NULL	NULL
72134	1	2015-05-28 00:00:00	n029	2015-05-28 00:00:00	N	T	15050296	GS00034863	65920	_	T	15193	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-05-29 00:00:00.000	339357	YY	2015-05-28 00:00:00	120831	 	NULL	NULL	NULL
72135	1	2015-05-28 08:39:00	n319	2015-05-28 00:00:00	N	P	15050324	GS15001318	21497	_	T	11793	n650	WS21	AK3	N	3800.00	3800.00	Y	2015-05-29 00:00:00.000	339350	YY	2015-05-28 00:00:00	165765	 	NULL	NULL	NULL
72136	1	2015-05-28 08:41:00	n319	2015-05-28 00:00:00	N	P	15050312	GS15001319	28163	_	T	16010	n1065	WS11	AJ2	N	6100.00	6100.00	Y	2015-05-29 00:00:00.000	339351	YY	2015-05-28 00:00:00	165766	 	NULL	NULL	NULL
72137	1	2015-05-28 08:46:00	n319	2015-05-28 00:00:00	N	P	15050305	GS15001321	28576	_	T	10747	n1065	UG1	AA3	N	3000.00	3000.00	Y	2015-05-29 00:00:00.000	339352	YY	2015-05-28 00:00:00	165768	 	NULL	NULL	NULL
72138	1	2015-05-28 09:42:00	n319	2015-05-28 00:00:00	N	P	15050329	GS15001322	23456	_	T	3554	n896	WS2	AK2	N	5000.00	5000.00	Y	2015-05-29 00:00:00.000	339353	YE	2015-05-28 00:00:00	165769	 	NULL	NULL	NULL
72139	1	2015-05-28 17:12:00	n319	2015-05-29 00:00:00	N	P	15050326	GS15001325	28579	_	T	16052	n1065	WA3	AN5	D	1000.00	1000.00	Y	2015-06-04 00:00:00.000	339579	YY	2015-05-29 00:00:00	165886	 	NULL	NULL	NULL
72140	1	2015-05-29 00:00:00	n029	2015-05-29 00:00:00	N	T	15050305	GS00034864	65918	_	T	15193	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-06-04 00:00:00.000	339588	YY	2015-05-29 00:00:00	120902	 	NULL	NULL	NULL
72141	1	2015-05-29 00:00:00	n029	2015-05-29 00:00:00	N	T	15050292	GS00034865	66630	_	T	7576	n646	FA1	FA1	N	15000.00	15000.00	Y	2015-06-04 00:00:00.000	339589	YY	2015-05-29 00:00:00	120905	 	NULL	NULL	NULL
72142	1	2015-05-29 00:00:00	n029	2015-05-29 00:00:00	N	T	15050297	GS00034867	52463	_	T	6085	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-06-04 00:00:00.000	339590	YY	2015-05-29 00:00:00	120907	 	NULL	NULL	NULL
72143	1	2015-05-29 08:49:00	n319	2015-05-29 00:00:00	N	P	15050182	GS15001328	28549	_	T	16044	n113	UG1	AA3	N	3000.00	3000.00	Y	2015-06-04 00:00:00.000	339580	YY	2015-05-29 00:00:00	165897	 	NULL	NULL	NULL
72144	1	2015-05-29 00:00:00	n029	2015-05-29 00:00:00	N	T	15050298	GS00034868	66631	_	T	6857	n428	FE1	FE1	N	8600.00	8600.00	Y	2015-06-04 00:00:00.000	339591	YE	2015-05-29 00:00:00	120908	 	NULL	NULL	NULL
72145	1	2015-05-29 09:30:00	n319	2015-05-29 00:00:00	N	P	15050356	GS15001329	27113	_	T	15502	n1304	WS11	AJ2	N	2700.00	2700.00	Y	2015-06-04 00:00:00.000	339581	YY	2015-05-29 00:00:00	165898	 	NULL	NULL	NULL
72146	1	2015-05-29 09:34:00	n319	2015-05-29 00:00:00	N	P	14070300	GS15001331	27847	_	T	15610	n994	IG1B	AA21	N	9700.00	18500.00	Y	2015-06-04 00:00:00.000	339582	YY	2015-05-29 00:00:00	165900	 	NULL	NULL	NULL
72147	1	2015-05-29 09:34:00	n319	2015-05-29 00:00:00	N	P	15050362	GS15001331	27847	_	T	15610	n994	AC2	AA21	N	8800.00	18500.00	Y	2015-06-04 00:00:00.000	339583	YY	2015-05-29 00:00:00	165900	 	NULL	NULL	NULL
72148	1	2015-05-29 09:35:00	n319	2015-05-29 00:00:00	N	P	14070301	GS15001332	27848	_	T	15610	n994	UG1	AA3	N	3000.00	3000.00	Y	2015-06-04 00:00:00.000	339584	YY	2015-05-29 00:00:00	165901	 	NULL	NULL	NULL
72149	1	2015-05-29 09:37:00	n319	2015-05-29 00:00:00	N	P	15010228	GS15001333	28315	_	T	15877	n994	IG1B	AA21	N	9700.00	9700.00	Y	2015-06-04 00:00:00.000	339585	YY	2015-05-29 00:00:00	165902	 	NULL	NULL	NULL
72150	1	2015-05-29 09:38:00	n319	2015-05-29 00:00:00	N	P	15040002	GS15001334	28454	_	T	12000	n1304	IG1B	AA21	N	9700.00	9700.00	Y	2015-06-04 00:00:00.000	339586	YY	2015-05-29 00:00:00	165903	 	NULL	NULL	NULL
72151	1	2015-05-29 09:46:00	n319	2015-05-29 00:00:00	N	P	15040094	GS15001335	28464	_	T	16014	n113	OG22	BB22	N	8200.00	8200.00	Y	2015-06-04 00:00:00.000	339587	YY	2015-05-29 00:00:00	165906	 	NULL	NULL	NULL
72152	1	2015-05-29 00:00:00	n029	2015-06-01 00:00:00	N	T	15050300	GS00034869	66638	_	T	13505	n428	FE1	FE1	N	13800.00	13800.00	Y	2015-06-04 00:00:00.000	339606	YE	2015-06-01 00:00:00	121008	 	NULL	NULL	NULL
72153	1	2015-05-29 15:47:00	n319	2015-06-01 00:00:00	N	P	15050367	GS15001336	25993	_	T	10747	n1065	WS1	AJ1	N	8500.00	8500.00	Y	2015-06-04 00:00:00.000	339592	YY	2015-06-01 00:00:00	166015	 	NULL	NULL	NULL
72154	1	2015-05-29 15:48:00	n319	2015-06-01 00:00:00	N	P	15050368	GS15001337	26433	_	T	10747	n1065	WS1	AJ1	N	8500.00	8500.00	Y	2015-06-04 00:00:00.000	339593	YY	2015-06-01 00:00:00	166016	 	NULL	NULL	NULL
72155	1	2015-05-29 15:49:00	n319	2015-06-01 00:00:00	N	P	15050321	GS15001338	27070	_	T	15464	n1489	WS21	AK3	N	1700.00	1700.00	Y	2015-06-04 00:00:00.000	339594	YY	2015-06-01 00:00:00	166018	 	NULL	NULL	NULL
72156	1	2015-05-29 00:00:00	n029	2015-06-01 00:00:00	N	T	15050309	GS00034870	66635	_	T	15348	n530	FE1	FE1	N	2400.00	2400.00	Y	2015-06-04 00:00:00.000	339607	YE	2015-06-01 00:00:00	121013	 	NULL	NULL	NULL
72157	1	2015-05-29 15:52:00	n319	2015-06-01 00:00:00	N	P	15040144	GS15001340	28480	_	T	10747	n1065	UG1	AA3	N	3000.00	3000.00	Y	2015-06-04 00:00:00.000	339595	YY	2015-06-01 00:00:00	166020	 	NULL	NULL	NULL
72158	1	2015-05-29 15:55:00	n319	2015-06-01 00:00:00	N	P	15040155	GS15001341	28485	_	T	10747	n1065	UG1	AA3	N	3000.00	3000.00	Y	2015-06-04 00:00:00.000	339596	YY	2015-06-01 00:00:00	166022	 	NULL	NULL	NULL
72159	1	2015-05-29 15:56:00	n319	2015-06-01 00:00:00	N	P	15050354	GS15001342	28484	_	T	12406	n650	WA3	AN5	D	1000.00	1000.00	Y	2015-06-04 00:00:00.000	339597	YY	2015-06-01 00:00:00	166023	 	NULL	NULL	NULL
72160	1	2015-05-29 16:00:00	n319	2015-06-01 00:00:00	N	P	15050370	GS15001343	28576	_	T	10747	n1065	WM1	AF1	D	300.00	300.00	Y	2015-06-04 00:00:00.000	339598	YY	2015-06-01 00:00:00	166024	 	NULL	NULL	NULL
72161	1	2015-05-29 00:00:00	n029	2015-06-01 00:00:00	N	T	15050310	GS00034871	66636	_	T	15348	n530	FE1	FE1	N	2400.00	2400.00	Y	2015-06-04 00:00:00.000	339608	YE	2015-06-01 00:00:00	121015	 	NULL	NULL	NULL
72162	1	2015-05-29 00:00:00	n029	2015-06-01 00:00:00	N	T	15050311	GS00034872	66637	_	T	15348	n530	FE1	FE1	N	2400.00	2400.00	Y	2015-06-04 00:00:00.000	339609	YE	2015-06-01 00:00:00	121016	 	NULL	NULL	NULL
72163	1	2015-05-29 00:00:00	n029	2015-06-01 00:00:00	N	T	15050306	GS00034873	66632	_	T	15348	n530	FE1	FE1	N	2400.00	2400.00	Y	2015-06-04 00:00:00.000	339610	YE	2015-06-01 00:00:00	121017	 	NULL	NULL	NULL
72164	1	2015-05-29 00:00:00	n029	2015-06-01 00:00:00	N	T	15050307	GS00034874	66633	_	T	15348	n530	FE1	FE1	N	2400.00	2400.00	Y	2015-06-04 00:00:00.000	339611	YE	2015-06-01 00:00:00	121018	 	NULL	NULL	NULL
72165	1	2015-05-29 00:00:00	n029	2015-06-01 00:00:00	N	T	15050308	GS00034875	66634	_	T	15348	n530	FE1	FE1	N	2400.00	2400.00	Y	2015-06-04 00:00:00.000	339612	YE	2015-06-01 00:00:00	121019	 	NULL	NULL	NULL
72166	1	2015-05-29 00:00:00	n029	2015-06-01 00:00:00	N	T	15020309	GS00034876	38379	_	T	6316	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-06-04 00:00:00.000	339613	YY	2015-06-01 00:00:00	121020	 	NULL	NULL	NULL
72167	1	2015-05-29 00:00:00	n029	2015-06-01 00:00:00	N	T	15050314	GS00034877	52620	_	T	2507	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-06-04 00:00:00.000	339614	YY	2015-06-01 00:00:00	121021	 	NULL	NULL	NULL
72168	1	2015-05-29 00:00:00	n029	2015-06-01 00:00:00	N	T	15050315	GS00034878	38146	_	T	2507	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-06-04 00:00:00.000	339615	YY	2015-06-01 00:00:00	121022	 	NULL	NULL	NULL
72169	1	2015-05-29 00:00:00	n029	2015-06-01 00:00:00	N	T	15050316	GS00034879	52688	_	T	2507	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-06-04 00:00:00.000	339616	YY	2015-06-01 00:00:00	121023	 	NULL	NULL	NULL
72170	1	2015-06-01 08:49:00	n319	2015-06-01 00:00:00	N	P	15050375	GS15001345	28175	_	T	15856	n994	WS11	AJ2	N	6100.00	6100.00	Y	2015-06-04 00:00:00.000	339599	YY	2015-06-01 00:00:00	166028	 	NULL	NULL	NULL
72171	1	2015-06-01 08:53:00	n319	2015-06-01 00:00:00	N	P	15010322	GS15001347	28336	_	T	13472	n1304	UG1	AA3	N	3000.00	3000.00	Y	2015-06-04 00:00:00.000	339600	YY	2015-06-01 00:00:00	166030	 	NULL	NULL	NULL
72172	1	2015-06-01 08:57:00	n319	2015-06-01 00:00:00	N	P	15030287	GS15001349	28439	_	T	12000	n1304	IG1B	AA21	N	9700.00	9700.00	Y	2015-06-04 00:00:00.000	339601	YY	2015-06-01 00:00:00	166032	 	NULL	NULL	NULL
72173	1	2015-06-01 09:45:00	n319	2015-06-01 00:00:00	N	P	14100329	GS15001351	28101	_	T	14032	n994	IG1B	AA21	N	9700.00	12100.00	Y	2015-06-04 00:00:00.000	339602	YY	2015-06-01 00:00:00	166034	 	NULL	NULL	NULL
72174	1	2015-06-01 09:45:00	n319	2015-06-01 00:00:00	N	P	15060002	GS15001351	28101	_	T	14032	n994	AC2	AA21	N	2400.00	12100.00	Y	2015-06-04 00:00:00.000	339603	YY	2015-06-01 00:00:00	166034	 	NULL	NULL	NULL
72175	1	2015-06-01 09:46:00	n319	2015-06-01 00:00:00	N	P	14100330	GS15001352	28102	_	T	14032	n994	UG1	AA3	N	3000.00	3000.00	Y	2015-06-04 00:00:00.000	339604	YY	2015-06-01 00:00:00	166035	 	NULL	NULL	NULL
72176	1	2015-06-01 09:47:00	n319	2015-06-01 00:00:00	N	P	15050391	GS15001353	25816	_	T	14953	n896	WS21	AK3	N	8400.00	8400.00	Y	2015-06-04 00:00:00.000	339605	YY	2015-06-01 00:00:00	166036	 	NULL	NULL	NULL
72177	1	2015-06-01 00:00:00	n029	2015-06-02 00:00:00	N	T	15050318	GS00034883	65831	_	T	15832	n646	FF0	FF0	N	7500.00	7500.00	Y	2015-06-05 00:00:00.000	339636	YY	2015-06-02 00:00:00	121050	 	NULL	NULL	NULL
72178	1	2015-06-02 00:00:00	n029	2015-06-02 00:00:00	N	T	15060045	GS00034884	65598	_	T	15295	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-06-05 00:00:00.000	339637	YY	2015-06-02 00:00:00	121068	 	NULL	NULL	NULL
72179	1	2015-06-02 00:00:00	n029	2015-06-02 00:00:00	N	T	15060007	GS00034885	65964	_	T	15348	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-06-05 00:00:00.000	339638	YY	2015-06-02 00:00:00	121069	 	NULL	NULL	NULL
72180	1	2015-06-02 00:00:00	n029	2015-06-02 00:00:00	N	T	15060008	GS00034886	65965	_	T	15348	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-06-05 00:00:00.000	339639	YY	2015-06-02 00:00:00	121070	 	NULL	NULL	NULL
72181	1	2015-06-02 00:00:00	n029	2015-06-02 00:00:00	N	T	15060046	GS00034887	66639	_	T	14558	n824	FE11	FE11	N	2700.00	2700.00	Y	2015-06-05 00:00:00.000	339640	YE	2015-06-02 00:00:00	121071	 	NULL	NULL	NULL
72182	1	2015-06-02 00:00:00	n029	2015-06-02 00:00:00	N	T	15060047	GS00034888	66640	_	T	14558	n824	FE11	FE11	N	2700.00	2700.00	Y	2015-06-05 00:00:00.000	339641	YE	2015-06-02 00:00:00	121072	 	NULL	NULL	NULL
72183	1	2015-06-02 00:00:00	n029	2015-06-02 00:00:00	N	T	15060048	GS00034889	66641	_	T	14558	n824	FE11	FE11	N	2700.00	2700.00	Y	2015-06-05 00:00:00.000	339642	YE	2015-06-02 00:00:00	121073	 	NULL	NULL	NULL
72184	1	2015-06-02 00:00:00	n029	2015-06-02 00:00:00	N	T	15060039	GS00034890	53272	_	T	5681	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-06-05 00:00:00.000	339643	YY	2015-06-02 00:00:00	121074	 	NULL	NULL	NULL
72185	1	2015-06-02 08:36:00	n319	2015-06-02 00:00:00	N	P	15060004	GS15001354	23317	_	T	12000	n1304	WS11	AJ2	N	6100.00	6100.00	Y	2015-06-05 00:00:00.000	339624	YY	2015-06-02 00:00:00	166116	 	NULL	NULL	NULL
72186	1	2015-06-02 08:39:00	n319	2015-06-02 00:00:00	N	P	15040271	GS15001356	26331	_	T	15196	n650	FR1	AB1	N	7000.00	7000.00	Y	2015-06-05 00:00:00.000	339625	YY	2015-06-02 00:00:00	166118	 	NULL	NULL	NULL
72187	1	2015-06-02 08:45:00	n319	2015-06-02 00:00:00	N	P	15060007	GS15001359	27686	_	T	12000	n1304	WS11	AJ2	N	6100.00	6100.00	Y	2015-06-05 00:00:00.000	339626	YY	2015-06-02 00:00:00	166121	 	NULL	NULL	NULL
72188	1	2015-06-02 08:46:00	n319	2015-06-02 00:00:00	N	P	15020228	GS15001360	28374	_	T	10747	n1065	UG1	AA3	N	3000.00	3000.00	Y	2015-06-05 00:00:00.000	339627	YY	2015-06-02 00:00:00	166122	 	NULL	NULL	NULL
72189	1	2015-06-02 08:49:00	n319	2015-06-02 00:00:00	N	P	15030060	GS15001361	28389	_	T	10747	n1065	IG1E	AA2	N	10500.00	10500.00	Y	2015-06-05 00:00:00.000	339628	YY	2015-06-02 00:00:00	166123	 	NULL	NULL	NULL
72190	1	2015-06-02 08:50:00	n319	2015-06-02 00:00:00	N	P	15050171	GS15001362	28546	_	T	13444	n650	IG1E	AA2	N	10500.00	10500.00	Y	2015-06-05 00:00:00.000	339629	YY	2015-06-02 00:00:00	166124	 	NULL	NULL	NULL
72191	1	2015-06-02 09:44:00	n319	2015-06-02 00:00:00	N	P	15050333	GS15001363	19442	_	T	13332	n113	WS2	AK2	N	16000.00	16000.00	Y	2015-06-05 00:00:00.000	339630	YE	2015-06-02 00:00:00	166125	 	NULL	NULL	NULL
72192	1	2015-06-02 09:44:00	n319	2015-06-02 00:00:00	N	P	15050385	GS15001364	20314	_	T	9	n994	WS2	AK2	N	8000.00	8000.00	Y	2015-06-05 00:00:00.000	339631	YE	2015-06-02 00:00:00	166126	 	NULL	NULL	NULL
72193	1	2015-06-02 09:44:00	n319	2015-06-02 00:00:00	N	P	15050386	GS15001365	20316	_	T	9	n994	WS2	AK2	N	8000.00	8000.00	Y	2015-06-05 00:00:00.000	339632	YE	2015-06-02 00:00:00	166127	 	NULL	NULL	NULL
72194	1	2015-06-02 09:44:00	n319	2015-06-02 00:00:00	N	P	15050369	GS15001366	27438	_	T	15605	n1065	WS2	AK2	N	9000.00	9000.00	Y	2015-06-05 00:00:00.000	339633	YE	2015-06-02 00:00:00	166128	 	NULL	NULL	NULL
72195	1	2015-06-02 12:13:00	n319	2015-06-02 00:00:00	N	P	15040008	GS15001367	28452	_	T	13472	n1304	IG1B	AA21	N	9700.00	19300.00	Y	2015-06-05 00:00:00.000	339634	YY	2015-06-02 00:00:00	166158	 	NULL	NULL	NULL
72196	1	2015-06-02 12:13:00	n319	2015-06-02 00:00:00	N	P	15060013	GS15001367	28452	_	T	13472	n1304	AC2	AA21	N	9600.00	19300.00	Y	2015-06-05 00:00:00.000	339635	YY	2015-06-02 00:00:00	166158	 	NULL	NULL	NULL
72197	1	2015-06-02 00:00:00	n029	2015-06-03 00:00:00	N	T	15060054	GS00034892	66649	_	T	16055	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-06-08 00:00:00.000	339652	YE	2015-06-03 00:00:00	121142	 	NULL	NULL	NULL
72198	1	2015-06-02 00:00:00	n029	2015-06-03 00:00:00	N	T	15060055	GS00034893	66650	_	T	15361	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-06-08 00:00:00.000	339653	YE	2015-06-03 00:00:00	121143	 	NULL	NULL	NULL
72199	1	2015-06-02 00:00:00	n029	2015-06-03 00:00:00	N	T	15060058	GS00034895	65972	_	T	4610	n547	FF0	FF0	N	2500.00	2500.00	Y	2015-06-08 00:00:00.000	339654	YY	2015-06-03 00:00:00	121145	 	NULL	NULL	NULL
72200	1	2015-06-02 00:00:00	n029	2015-06-03 00:00:00	N	T	15060057	GS00034896	65974	_	T	4610	n547	FF0	FF0	N	2500.00	2500.00	Y	2015-06-08 00:00:00.000	339655	YY	2015-06-03 00:00:00	121146	 	NULL	NULL	NULL
72201	1	2015-06-02 00:00:00	n029	2015-06-03 00:00:00	N	T	15060019	GS00034897	53628	_	T	13157	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-06-08 00:00:00.000	339656	YY	2015-06-03 00:00:00	121147	 	NULL	NULL	NULL
72202	1	2015-06-02 00:00:00	n029	2015-06-03 00:00:00	N	T	15060042	GS00034898	39202	_	T	7120	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-06-08 00:00:00.000	339657	YY	2015-06-03 00:00:00	121150	 	NULL	NULL	NULL
72203	1	2015-06-02 00:00:00	n029	2015-06-03 00:00:00	N	T	15060043	GS00034899	66642	_	T	15430	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-06-08 00:00:00.000	339658	YY	2015-06-03 00:00:00	121154	 	NULL	NULL	NULL
72204	1	2015-06-02 00:00:00	n029	2015-06-03 00:00:00	N	T	15060044	GS00034900	66643	_	T	15430	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-06-08 00:00:00.000	339659	YY	2015-06-03 00:00:00	121159	 	NULL	NULL	NULL
72205	1	2015-06-02 00:00:00	n029	2015-06-03 00:00:00	N	T	15060029	GS00034901	52922	_	T	13059	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-06-08 00:00:00.000	339660	YY	2015-06-03 00:00:00	121162	 	NULL	NULL	NULL
72206	1	2015-06-02 00:00:00	n029	2015-06-03 00:00:00	N	T	15060065	GS00034902	66653	_	T	7759	n547	FE1	FE1	N	5400.00	5400.00	Y	2015-06-08 00:00:00.000	339661	YE	2015-06-03 00:00:00	121163	 	NULL	NULL	NULL
72207	1	2015-06-02 00:00:00	n029	2015-06-03 00:00:00	N	T	15060030	GS00034903	52921	_	T	13059	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-06-08 00:00:00.000	339662	YY	2015-06-03 00:00:00	121164	 	NULL	NULL	NULL
72208	1	2015-06-02 17:12:00	n319	2015-06-03 00:00:00	N	P	15060006	GS15001368	26298	_	T	12556	n1489	WS11	AJ2	N	6100.00	6100.00	Y	2015-06-08 00:00:00.000	339646	YY	2015-06-03 00:00:00	166207	 	NULL	NULL	NULL
72209	1	2015-06-03 00:00:00	n029	2015-06-03 00:00:00	N	T	15060009	GS00034904	66644	_	T	14577	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-06-08 00:00:00.000	339663	YY	2015-06-03 00:00:00	121165	 	NULL	NULL	NULL
72210	1	2015-06-03 00:00:00	n029	2015-06-03 00:00:00	N	T	15060040	GS00034905	52900	_	T	11579	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-06-08 00:00:00.000	339664	YY	2015-06-03 00:00:00	121166	 	NULL	NULL	NULL
72211	1	2015-06-03 00:00:00	n029	2015-06-03 00:00:00	N	T	15060041	GS00034906	52901	_	T	11579	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-06-08 00:00:00.000	339665	YY	2015-06-03 00:00:00	121167	 	NULL	NULL	NULL
72212	1	2015-06-03 00:00:00	n029	2015-06-03 00:00:00	N	T	15060020	GS00034907	52571	_	T	6857	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-06-08 00:00:00.000	339666	YY	2015-06-03 00:00:00	121168	 	NULL	NULL	NULL
72213	1	2015-06-03 00:00:00	n029	2015-06-03 00:00:00	N	T	15060021	GS00034908	52570	_	T	6857	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-06-08 00:00:00.000	339667	YY	2015-06-03 00:00:00	121169	 	NULL	NULL	NULL
72214	1	2015-06-03 00:00:00	n029	2015-06-03 00:00:00	N	T	15060022	GS00034909	52572	_	T	6857	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-06-08 00:00:00.000	339668	YY	2015-06-03 00:00:00	121170	 	NULL	NULL	NULL
72215	1	2015-06-03 00:00:00	n029	2015-06-03 00:00:00	N	T	15060023	GS00034910	52569	_	T	6857	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-06-08 00:00:00.000	339669	YY	2015-06-03 00:00:00	121171	 	NULL	NULL	NULL
72216	1	2015-06-03 00:00:00	n029	2015-06-03 00:00:00	N	T	15060024	GS00034911	52573	_	T	6857	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-06-08 00:00:00.000	339670	YY	2015-06-03 00:00:00	121172	 	NULL	NULL	NULL
72217	1	2015-06-03 08:56:00	n319	2015-06-03 00:00:00	N	P	15060015	GS15001369	26508	_	T	13042	n650	WS11	AJ2	N	6100.00	6100.00	Y	2015-06-08 00:00:00.000	339647	YY	2015-06-03 00:00:00	166208	 	NULL	NULL	NULL
72218	1	2015-06-03 08:56:00	n319	2015-06-03 00:00:00	N	P	15060022	GS15001370	27076	_	T	15496	n650	WS11	AJ2	N	6100.00	6100.00	Y	2015-06-08 00:00:00.000	339648	YY	2015-06-03 00:00:00	166209	 	NULL	NULL	NULL
72219	1	2015-06-03 08:57:00	n319	2015-06-03 00:00:00	N	P	15060016	GS15001371	27232	_	T	15023	n1125	WS21	AK3	N	1700.00	1700.00	Y	2015-06-08 00:00:00.000	339649	YY	2015-06-03 00:00:00	166210	 	NULL	NULL	NULL
72220	1	2015-06-03 08:58:00	n319	2015-06-03 00:00:00	N	P	15060017	GS15001372	27233	_	T	15023	n1125	WS21	AK3	N	1700.00	1700.00	Y	2015-06-08 00:00:00.000	339650	YY	2015-06-03 00:00:00	166211	 	NULL	NULL	NULL
72221	1	2015-06-03 08:59:00	n319	2015-06-03 00:00:00	N	P	15060018	GS15001373	27234	_	T	15023	n1125	WS21	AK3	N	1700.00	1700.00	Y	2015-06-08 00:00:00.000	339651	YY	2015-06-03 00:00:00	166212	 	NULL	NULL	NULL
72222	1	2015-06-03 15:34:00	n319	2015-06-04 00:00:00	N	P	15060027	GS15001374	24777	_	T	13712	n896	WS1	AJ1	N	8500.00	8500.00	Y	2015-06-08 00:00:00.000	339671	YY	2015-06-04 00:00:00	166290	 	NULL	NULL	NULL
72223	1	2015-06-03 00:00:00	n029	2015-06-04 00:00:00	N	T	15060070	GS00034912	66654	_	T	3463	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-06-08 00:00:00.000	339681	YE	2015-06-04 00:00:00	121219	 	NULL	NULL	NULL
72224	1	2015-06-03 00:00:00	n029	2015-06-04 00:00:00	N	T	15060073	GS00034913	66655	_	T	13965	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-06-08 00:00:00.000	339682	YY	2015-06-04 00:00:00	121220	 	NULL	NULL	NULL
72225	1	2015-06-03 00:00:00	n029	2015-06-04 00:00:00	N	T	15060066	GS00034914	65505	_	T	15754	n646	FF0	FF0	N	2500.00	2500.00	Y	2015-06-08 00:00:00.000	339683	YY	2015-06-04 00:00:00	121221	 	NULL	NULL	NULL
72226	1	2015-06-03 00:00:00	n029	2015-06-04 00:00:00	N	T	15060053	GS00034915	66652	_	T	4756	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-06-08 00:00:00.000	339684	YY	2015-06-04 00:00:00	121222	 	NULL	NULL	NULL
72227	1	2015-06-03 00:00:00	n029	2015-06-04 00:00:00	N	T	15060052	GS00034916	66651	_	T	4756	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-06-08 00:00:00.000	339685	YY	2015-06-04 00:00:00	121224	 	NULL	NULL	NULL
72228	1	2015-06-03 00:00:00	n029	2015-06-04 00:00:00	N	T	15060025	GS00034917	66645	_	T	265	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-06-08 00:00:00.000	339686	YY	2015-06-04 00:00:00	121227	 	NULL	NULL	NULL
72229	1	2015-06-03 00:00:00	n029	2015-06-04 00:00:00	N	T	15060026	GS00034918	66646	_	T	265	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-06-08 00:00:00.000	339687	YY	2015-06-04 00:00:00	121228	 	NULL	NULL	NULL
72230	1	2015-06-03 00:00:00	n029	2015-06-04 00:00:00	N	T	15060027	GS00034919	66647	_	T	265	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-06-08 00:00:00.000	339688	YY	2015-06-04 00:00:00	121229	 	NULL	NULL	NULL
72231	1	2015-06-03 00:00:00	n029	2015-06-04 00:00:00	N	T	15060028	GS00034920	66648	_	T	265	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-06-08 00:00:00.000	339689	YY	2015-06-04 00:00:00	121230	 	NULL	NULL	NULL
72232	1	2015-06-03 00:00:00	n029	2015-06-04 00:00:00	N	T	15060072	GS00034921	53003	_	T	13090	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-06-08 00:00:00.000	339690	YY	2015-06-04 00:00:00	121244	 	NULL	NULL	NULL
72233	1	2015-06-03 00:00:00	n029	2015-06-04 00:00:00	N	T	15060071	GS00034922	53004	_	T	13090	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-06-08 00:00:00.000	339691	YY	2015-06-04 00:00:00	121245	 	NULL	NULL	NULL
72234	1	2015-06-03 17:27:00	n319	2015-06-04 00:00:00	N	P	15060040	GS15001376	28412	_	T	15260	n1489	WS11	AJ2	N	6100.00	6100.00	Y	2015-06-08 00:00:00.000	339672	YY	2015-06-04 00:00:00	166303	 	NULL	NULL	NULL
72235	1	2015-06-03 17:30:00	n319	2015-06-04 00:00:00	N	P	15050137	GS15001377	28539	_	T	3570	n1489	DG1	AA4	N	3000.00	3000.00	Y	2015-06-08 00:00:00.000	339673	YY	2015-06-04 00:00:00	166304	 	NULL	NULL	NULL
72236	1	2015-06-03 17:31:00	n319	2015-06-04 00:00:00	N	P	15050138	GS15001378	28540	_	T	3570	n1489	DG1	AA4	N	3000.00	3000.00	Y	2015-06-08 00:00:00.000	339674	YY	2015-06-04 00:00:00	166305	 	NULL	NULL	NULL
72237	1	2015-06-04 00:00:00	n029	2015-06-04 00:00:00	N	T	15060031	GS00034923	52852	_	T	7683	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-06-08 00:00:00.000	339692	YY	2015-06-04 00:00:00	121246	 	NULL	NULL	NULL
72238	1	2015-06-04 00:00:00	n029	2015-06-04 00:00:00	N	T	15060032	GS00034924	52853	_	T	7683	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-06-08 00:00:00.000	339693	YY	2015-06-04 00:00:00	121247	 	NULL	NULL	NULL
72239	1	2015-06-04 00:00:00	n029	2015-06-04 00:00:00	N	T	15060033	GS00034925	52803	_	T	7683	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-06-08 00:00:00.000	339694	YY	2015-06-04 00:00:00	121248	 	NULL	NULL	NULL
72240	1	2015-06-04 00:00:00	n029	2015-06-04 00:00:00	N	T	15060034	GS00034926	52802	_	T	7683	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-06-08 00:00:00.000	339695	YY	2015-06-04 00:00:00	121249	 	NULL	NULL	NULL
72241	1	2015-06-04 00:00:00	n029	2015-06-04 00:00:00	N	T	15060035	GS00034927	52805	_	T	7683	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-06-08 00:00:00.000	339696	YY	2015-06-04 00:00:00	121250	 	NULL	NULL	NULL
72242	1	2015-06-04 00:00:00	n029	2015-06-04 00:00:00	N	T	15060036	GS00034928	52804	_	T	7683	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-06-08 00:00:00.000	339697	YY	2015-06-04 00:00:00	121251	 	NULL	NULL	NULL
72243	1	2015-06-04 00:00:00	n029	2015-06-04 00:00:00	N	T	15060037	GS00034929	52807	_	T	7683	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-06-08 00:00:00.000	339698	YY	2015-06-04 00:00:00	121253	 	NULL	NULL	NULL
72244	1	2015-06-04 00:00:00	n029	2015-06-04 00:00:00	N	T	15060038	GS00034930	52806	_	T	7683	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-06-08 00:00:00.000	339699	YY	2015-06-04 00:00:00	121254	 	NULL	NULL	NULL
72245	1	2015-06-04 08:55:00	n319	2015-06-04 00:00:00	N	P	14080216	GS15001381	27932	_	T	13472	n1304	IG1B	AA21	N	9700.00	11300.00	Y	2015-06-08 00:00:00.000	339675	YY	2015-06-04 00:00:00	166308	 	NULL	NULL	NULL
72246	1	2015-06-04 08:55:00	n319	2015-06-04 00:00:00	N	P	15060043	GS15001381	27932	_	T	13472	n1304	AC2	AA21	N	1600.00	11300.00	Y	2015-06-08 00:00:00.000	339676	YY	2015-06-04 00:00:00	166308	 	NULL	NULL	NULL
72247	1	2015-06-04 00:00:00	n029	2015-06-04 00:00:00	N	T	15060061	GS00034931	66656	_	T	16057	n547	FE1	FE1	N	33300.00	33300.00	Y	2015-06-08 00:00:00.000	339700	YE	2015-06-04 00:00:00	121255	 	NULL	NULL	NULL
72248	1	2015-06-04 00:00:00	n029	2015-06-04 00:00:00	N	T	15060062	GS00034932	66657	_	T	16057	n547	FE1	FE1	N	33300.00	33300.00	Y	2015-06-08 00:00:00.000	339701	YE	2015-06-04 00:00:00	121256	 	NULL	NULL	NULL
72249	1	2015-06-04 09:42:00	n319	2015-06-04 00:00:00	N	P	15060021	GS15001384	19546	_	T	2193	n100	WS2	AK2	N	8000.00	8000.00	Y	2015-06-08 00:00:00.000	339677	YE	2015-06-04 00:00:00	166311	 	NULL	NULL	NULL
72250	1	2015-06-04 09:42:00	n319	2015-06-04 00:00:00	N	P	15060030	GS15001385	23399	_	T	7947	n1125	WS2	AK2	N	2500.00	2500.00	Y	2015-06-08 00:00:00.000	339678	YE	2015-06-04 00:00:00	166312	 	NULL	NULL	NULL
72251	1	2015-06-04 09:42:00	n319	2015-06-04 00:00:00	N	P	15060026	GS15001386	25696	_	T	13712	n896	WS2	AK2	N	4000.00	4000.00	Y	2015-06-08 00:00:00.000	339679	YE	2015-06-04 00:00:00	166313	 	NULL	NULL	NULL
72252	1	2015-06-04 09:42:00	n319	2015-06-04 00:00:00	N	P	15060036	GS15001387	26734	_	T	10554	n100	WS2	AK2	N	2500.00	2500.00	Y	2015-06-08 00:00:00.000	339680	YE	2015-06-04 00:00:00	166314	 	NULL	NULL	NULL
72253	1	2015-06-04 14:28:00	n319	2015-06-05 00:00:00	N	P	15060045	GS15001388	1090	M	T	12293	n113	WS1	AJ1	X	3500.00	3500.00	Y	2015-06-08 00:00:00.000	339702	YY	2015-06-05 00:00:00	166362	 	NULL	NULL	NULL
72254	1	2015-06-04 14:28:00	n319	2015-06-05 00:00:00	N	P	15060044	GS15001389	1113	M	T	12293	n113	WS1	AJ1	X	3500.00	3500.00	Y	2015-06-08 00:00:00.000	339703	YY	2015-06-05 00:00:00	166363	 	NULL	NULL	NULL
72255	1	2015-06-04 14:47:00	n319	2015-06-05 00:00:00	N	P	15020225	GS15001393	28376	_	T	13472	n1304	IG1B	AA21	N	9700.00	12900.00	Y	2015-06-08 00:00:00.000	339704	YY	2015-06-05 00:00:00	166386	 	NULL	NULL	NULL
72256	1	2015-06-04 14:47:00	n319	2015-06-05 00:00:00	N	P	15060042	GS15001393	28376	_	T	13472	n1304	AC2	AA21	N	3200.00	12900.00	Y	2015-06-08 00:00:00.000	339705	YY	2015-06-05 00:00:00	166386	 	NULL	NULL	NULL
72257	1	2015-06-04 14:48:00	n319	2015-06-05 00:00:00	N	P	15020226	GS15001394	28377	_	T	13472	n1304	UG1	AA3	N	3000.00	3000.00	Y	2015-06-08 00:00:00.000	339706	YY	2015-06-05 00:00:00	166389	 	NULL	NULL	NULL
72258	1	2015-06-04 16:40:00	n319	2015-06-05 00:00:00	N	P	15050136	GS15001397	28538	_	T	3570	n1489	DG1	AA4	N	3000.00	3000.00	Y	2015-06-08 00:00:00.000	339707	YY	2015-06-05 00:00:00	166418	 	NULL	NULL	NULL
72259	1	2015-06-04 00:00:00	n029	2015-06-05 00:00:00	N	T	15060082	GS00034935	65963	_	T	15348	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-06-08 00:00:00.000	339715	YY	2015-06-05 00:00:00	121340	 	NULL	NULL	NULL
72260	1	2015-06-04 00:00:00	n029	2015-06-05 00:00:00	N	T	15060081	GS00034936	65973	_	T	4610	n547	FF0	FF0	N	2500.00	2500.00	Y	2015-06-08 00:00:00.000	339716	YY	2015-06-05 00:00:00	121341	 	NULL	NULL	NULL
72261	1	2015-06-04 00:00:00	n029	2015-06-05 00:00:00	N	T	15060079	GS00034937	65968	_	T	13403	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-06-08 00:00:00.000	339717	YY	2015-06-05 00:00:00	121342	 	NULL	NULL	NULL
72262	1	2015-06-04 00:00:00	n029	2015-06-05 00:00:00	N	T	15060080	GS00034938	65969	_	T	13403	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-06-08 00:00:00.000	339718	YY	2015-06-05 00:00:00	121343	 	NULL	NULL	NULL
72263	1	2015-06-04 00:00:00	n029	2015-06-05 00:00:00	N	T	15060083	GS00034939	66667	_	T	6362	n547	FE1	FE1	N	2400.00	2400.00	Y	2015-06-08 00:00:00.000	339719	YE	2015-06-05 00:00:00	121344	 	NULL	NULL	NULL
72264	1	2015-06-04 00:00:00	n029	2015-06-05 00:00:00	N	T	15060084	GS00034940	66668	_	T	6362	n547	FE1	FE1	N	2400.00	2400.00	Y	2015-06-08 00:00:00.000	339720	YE	2015-06-05 00:00:00	121345	 	NULL	NULL	NULL
72265	1	2015-06-04 00:00:00	n029	2015-06-05 00:00:00	N	T	15060085	GS00034941	66669	_	T	6362	n547	FE1	FE1	N	2400.00	2400.00	Y	2015-06-08 00:00:00.000	339721	YE	2015-06-05 00:00:00	121346	 	NULL	NULL	NULL
72266	1	2015-06-05 08:50:00	n319	2015-06-05 00:00:00	N	P	15010224	GS15001398	26576	_	T	14972	n994	FR1	AB1	N	7000.00	13400.00	Y	2015-06-08 00:00:00.000	339708	YY	2015-06-05 00:00:00	166440	 	NULL	NULL	NULL
72267	1	2015-06-05 08:50:00	n319	2015-06-05 00:00:00	N	P	15060098	GS15001398	26576	_	T	14972	n994	FR12	AB1	N	6400.00	13400.00	Y	2015-06-08 00:00:00.000	339709	YY	2015-06-05 00:00:00	166440	 	NULL	NULL	NULL
72268	1	2015-06-05 08:59:00	n319	2015-06-05 00:00:00	N	P	15060084	GS15001401	28229	_	T	15903	n1304	WS11	AJ2	N	6100.00	6100.00	Y	2015-06-08 00:00:00.000	339710	YY	2015-06-05 00:00:00	166443	 	NULL	NULL	NULL
72269	1	2015-06-05 09:00:00	n319	2015-06-05 00:00:00	N	P	15040157	GS15001402	28483	_	T	16016	n113	UG1	AA3	N	3000.00	3000.00	Y	2015-06-08 00:00:00.000	339711	YY	2015-06-05 00:00:00	166444	 	NULL	NULL	NULL
72270	1	2015-06-05 00:00:00	n417	2015-06-05 00:00:00	N	T	15060010	GS00034942	66658	_	T	14476	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-06-08 00:00:00.000	339722	YY	2015-06-05 00:00:00	121349	 	NULL	NULL	NULL
72271	1	2015-06-05 00:00:00	n417	2015-06-05 00:00:00	N	T	15060011	GS00034943	66659	_	T	14476	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-06-08 00:00:00.000	339723	YY	2015-06-05 00:00:00	121350	 	NULL	NULL	NULL
72272	1	2015-06-05 00:00:00	n417	2015-06-05 00:00:00	N	T	15060012	GS00034944	66660	_	T	14476	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-06-08 00:00:00.000	339724	YY	2015-06-05 00:00:00	121351	 	NULL	NULL	NULL
72273	1	2015-06-05 00:00:00	n417	2015-06-05 00:00:00	N	T	15060013	GS00034945	66661	_	T	14476	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-06-08 00:00:00.000	339725	YY	2015-06-05 00:00:00	121352	 	NULL	NULL	NULL
72274	1	2015-06-05 00:00:00	n417	2015-06-05 00:00:00	N	T	15060014	GS00034946	66662	_	T	14476	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-06-08 00:00:00.000	339726	YY	2015-06-05 00:00:00	121353	 	NULL	NULL	NULL
72275	1	2015-06-05 00:00:00	n417	2015-06-05 00:00:00	N	T	15060015	GS00034947	66663	_	T	14476	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-06-08 00:00:00.000	339727	YY	2015-06-05 00:00:00	121355	 	NULL	NULL	NULL
72276	1	2015-06-05 00:00:00	n417	2015-06-05 00:00:00	N	T	15060016	GS00034948	66664	_	T	14476	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-06-08 00:00:00.000	339728	YY	2015-06-05 00:00:00	121356	 	NULL	NULL	NULL
72277	1	2015-06-05 11:26:00	n319	2015-06-05 00:00:00	N	P	15060102	GS15001403	28634	_	T	10747	n1065	IG1E	AA2	N	10500.00	10500.00	Y	2015-06-08 00:00:00.000	339712	YY	2015-06-05 00:00:00	166469	 	NULL	NULL	NULL
72278	1	2015-06-05 11:28:00	n319	2015-06-05 00:00:00	N	P	15060103	GS15001404	28635	_	T	10747	n1065	IG1E	AA2	N	10500.00	10500.00	Y	2015-06-08 00:00:00.000	339713	YY	2015-06-05 00:00:00	166472	 	NULL	NULL	NULL
72279	1	2015-06-05 11:31:00	n319	2015-06-05 00:00:00	N	P	15060104	GS15001405	28636	_	T	10747	n1065	IG1E	AA2	N	10500.00	10500.00	Y	2015-06-08 00:00:00.000	339714	YY	2015-06-05 00:00:00	166474	 	NULL	NULL	NULL
72280	1	2015-06-05 00:00:00	n029	2015-06-08 00:00:00	N	T	15060088	GS00034949	66671	_	T	16056	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-06-10 00:00:00.000	339832	YE	2015-06-08 00:00:00	121406	 	NULL	NULL	NULL
72281	1	2015-06-08 08:48:00	n319	2015-06-08 00:00:00	N	P	15060091	GS15001408	27675	_	T	15569	n994	WA3	AN5	D	1000.00	1000.00	Y	2015-06-10 00:00:00.000	339821	YY	2015-06-08 00:00:00	166532	 	NULL	NULL	NULL
72282	1	2015-06-08 08:48:00	n319	2015-06-08 00:00:00	N	P	15060092	GS15001409	27675	_	T	15569	n994	WA3	AN5	D	1000.00	1000.00	Y	2015-06-10 00:00:00.000	339822	YY	2015-06-08 00:00:00	166533	 	NULL	NULL	NULL
72283	1	2015-06-08 08:51:00	n319	2015-06-08 00:00:00	N	P	15060090	GS15001411	28286	_	T	4610	n994	WA3	AN5	D	1000.00	1000.00	Y	2015-06-10 00:00:00.000	339823	YY	2015-06-08 00:00:00	166535	 	NULL	NULL	NULL
72284	1	2015-06-08 08:53:00	n319	2015-06-08 00:00:00	N	P	15020251	GS15001412	28380	_	T	13930	n896	IG1E	AA2	N	10500.00	11300.00	Y	2015-06-10 00:00:00.000	339824	YY	2015-06-08 00:00:00	166536	 	NULL	NULL	NULL
72285	1	2015-06-08 08:53:00	n319	2015-06-08 00:00:00	N	P	15060110	GS15001412	28380	_	T	13930	n896	AC2	AA2	N	800.00	11300.00	Y	2015-06-10 00:00:00.000	339825	YY	2015-06-08 00:00:00	166536	 	NULL	NULL	NULL
72286	1	2015-06-08 08:56:00	n319	2015-06-08 00:00:00	N	P	15040146	GS15001413	28481	_	T	12000	n1304	IG1B	AA21	N	9700.00	14500.00	Y	2015-06-10 00:00:00.000	339826	YY	2015-06-08 00:00:00	166537	 	NULL	NULL	NULL
72287	1	2015-06-08 08:56:00	n319	2015-06-08 00:00:00	N	P	15060097	GS15001413	28481	_	T	12000	n1304	AC2	AA21	N	4800.00	14500.00	Y	2015-06-10 00:00:00.000	339827	YY	2015-06-08 00:00:00	166537	 	NULL	NULL	NULL
72288	1	2015-06-08 08:58:00	n319	2015-06-08 00:00:00	N	P	15050371	GS15001414	28591	_	T	10747	n1065	UG1	AA3	N	3000.00	3000.00	Y	2015-06-10 00:00:00.000	339828	YY	2015-06-08 00:00:00	166538	 	NULL	NULL	NULL
72289	1	2015-06-08 00:00:00	n417	2015-06-08 00:00:00	N	T	15060089	GS00034950	66670	_	T	437	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-06-10 00:00:00.000	339833	YE	2015-06-08 00:00:00	121411	 	NULL	NULL	NULL
72290	1	2015-06-08 00:00:00	n417	2015-06-08 00:00:00	N	T	15060090	GS00034951	66672	_	T	15933	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-06-10 00:00:00.000	339834	YE	2015-06-08 00:00:00	121412	 	NULL	NULL	NULL
72291	1	2015-06-08 00:00:00	n417	2015-06-08 00:00:00	N	T	15060091	GS00034952	66673	_	T	15933	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-06-10 00:00:00.000	339835	YE	2015-06-08 00:00:00	121413	 	NULL	NULL	NULL
72292	1	2015-06-08 09:45:00	n319	2015-06-08 00:00:00	N	P	15060113	GS15001416	28319	_	T	13319	n896	WS11	AJ2	N	2700.00	2700.00	Y	2015-06-10 00:00:00.000	339829	YY	2015-06-08 00:00:00	166540	 	NULL	NULL	NULL
72293	1	2015-06-08 09:47:00	n319	2015-06-08 00:00:00	N	P	15060111	GS15001417	28324	_	T	12548	n896	WS11	AJ2	N	6100.00	6100.00	Y	2015-06-10 00:00:00.000	339830	YY	2015-06-08 00:00:00	166541	 	NULL	NULL	NULL
72294	1	2015-06-08 09:48:00	n319	2015-06-08 00:00:00	N	P	15060112	GS15001418	28345	_	T	13319	n896	WS11	AJ2	N	2700.00	2700.00	Y	2015-06-10 00:00:00.000	339831	YY	2015-06-08 00:00:00	166542	 	NULL	NULL	NULL
72295	1	2015-06-08 16:47:00	n319	2015-06-09 00:00:00	N	P	15060122	GS15001419	28320	_	T	10554	n100	WS1	AJ1	N	8500.00	8500.00	Y	2015-06-10 00:00:00.000	339836	YY	2015-06-09 00:00:00	166636	 	NULL	NULL	NULL
72296	1	2015-06-09 00:00:00	n029	2015-06-09 00:00:00	N	T	15060077	GS00034954	65891	_	T	13792	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-06-10 00:00:00.000	339846	YY	2015-06-09 00:00:00	121474	 	NULL	NULL	NULL
72297	1	2015-06-09 00:00:00	n029	2015-06-09 00:00:00	N	T	15060078	GS00034955	65892	_	T	13792	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-06-10 00:00:00.000	339847	YY	2015-06-09 00:00:00	121475	 	NULL	NULL	NULL
72298	1	2015-06-09 08:44:00	n319	2015-06-09 00:00:00	N	P	15060115	GS15001420	25207	_	T	6465	n994	WS21	AK3	N	2400.00	2400.00	Y	2015-06-10 00:00:00.000	339837	YY	2015-06-09 00:00:00	166637	 	NULL	NULL	NULL
72299	1	2015-06-09 08:45:00	n319	2015-06-09 00:00:00	N	P	15060121	GS15001421	26571	_	T	13712	n896	WS1	AJ1	N	3500.00	3500.00	Y	2015-06-10 00:00:00.000	339838	YY	2015-06-09 00:00:00	166638	 	NULL	NULL	NULL
72300	1	2015-06-09 08:47:00	n319	2015-06-09 00:00:00	N	P	15060114	GS15001422	27349	_	T	15569	n994	WS1	AJ1	N	8500.00	8500.00	Y	2015-06-10 00:00:00.000	339839	YY	2015-06-09 00:00:00	166639	 	NULL	NULL	NULL
72301	1	2015-06-09 08:47:00	n319	2015-06-09 00:00:00	N	P	15060109	GS15001423	28370	_	T	15933	n1125	WS11	AJ2	N	2700.00	2700.00	Y	2015-06-10 00:00:00.000	339840	YY	2015-06-09 00:00:00	166640	 	NULL	NULL	NULL
72302	1	2015-06-09 09:07:00	n319	2015-06-09 00:00:00	N	P	15060051	GS15001424	28295	_	T	13042	n650	WA3	AN5	N	1000.00	1000.00	Y	2015-06-10 00:00:00.000	339841	YY	2015-06-09 00:00:00	166641	 	NULL	NULL	NULL
72303	1	2015-06-09 09:16:00	n319	2015-06-09 00:00:00	N	P	15060134	GS15001425	1149	M	T	15318	n113	WS11	AJ2	X	2700.00	2700.00	Y	2015-06-10 00:00:00.000	339842	YY	2015-06-09 00:00:00	166642	 	NULL	NULL	NULL
72304	1	2015-06-09 09:17:00	n319	2015-06-09 00:00:00	N	P	15060130	GS15001426	1157	M	T	15318	n113	WS21	AK3	X	2800.00	2800.00	Y	2015-06-10 00:00:00.000	339843	YY	2015-06-09 00:00:00	166643	 	NULL	NULL	NULL
72305	1	2015-06-09 09:28:00	n319	2015-06-09 00:00:00	N	P	15060133	GS15001428	1158	M	T	15318	n113	WS11	AJ2	X	2700.00	2700.00	Y	2015-06-10 00:00:00.000	339844	YY	2015-06-09 00:00:00	166645	 	NULL	NULL	NULL
72306	1	2015-06-09 09:30:00	n319	2015-06-09 00:00:00	N	P	15060127	GS15001430	28200	_	T	13972	n100	WS1	AJ1	N	3500.00	3500.00	Y	2015-06-10 00:00:00.000	339845	YY	2015-06-09 00:00:00	166647	 	NULL	NULL	NULL
72307	1	2015-06-09 16:04:00	n319	2015-06-10 00:00:00	N	P	15060137	GS15001434	27263	_	T	15569	n994	WS1	AJ1	N	8500.00	8500.00	Y	2015-06-15 00:00:00.000	340245	YY	2015-06-10 00:00:00	166740	 	NULL	NULL	NULL
72308	1	2015-06-09 16:06:00	n319	2015-06-10 00:00:00	N	P	15060138	GS15001435	28261	_	T	14032	n994	WS1	AJ1	N	6000.00	6000.00	Y	2015-06-15 00:00:00.000	340246	YY	2015-06-10 00:00:00	166741	 	NULL	NULL	NULL
72309	1	2015-06-09 16:07:00	n319	2015-06-10 00:00:00	N	P	15040270	GS15001436	28288	_	T	13225	n896	LM3	AN2	N	5000.00	5000.00	Y	2015-06-15 00:00:00.000	340247	YY	2015-06-10 00:00:00	166742	 	NULL	NULL	NULL
72310	1	2015-06-09 00:00:00	n029	2015-06-10 00:00:00	N	T	15060100	GS00034958	65727	_	T	15813	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-06-15 00:00:00.000	340254	YY	2015-06-10 00:00:00	121528	 	NULL	NULL	NULL
72311	1	2015-06-09 00:00:00	n029	2015-06-10 00:00:00	N	T	15060104	GS00034959	65436	2	T	15480	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-06-15 00:00:00.000	340255	YY	2015-06-10 00:00:00	121529	 	NULL	NULL	NULL
72312	1	2015-06-09 00:00:00	n029	2015-06-10 00:00:00	N	T	15060108	GS00034961	53184	_	T	11181	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-06-15 00:00:00.000	340256	YY	2015-06-10 00:00:00	121539	 	NULL	NULL	NULL
72313	1	2015-06-09 00:00:00	n029	2015-06-10 00:00:00	N	T	15060099	GS00034962	66675	_	T	15473	n428	FE1	FE1	N	5100.00	5100.00	Y	2015-06-15 00:00:00.000	340257	YE	2015-06-10 00:00:00	121547	 	NULL	NULL	NULL
72314	1	2015-06-09 00:00:00	n029	2015-06-10 00:00:00	N	T	15060098	GS00034963	66674	_	T	84	n646	FE1	FE1	N	2400.00	2400.00	Y	2015-06-15 00:00:00.000	340258	YE	2015-06-10 00:00:00	121550	 	NULL	NULL	NULL
72315	1	2015-06-09 00:00:00	n029	2015-06-10 00:00:00	N	T	15060107	GS00034964	66677	_	T	13841	n428	FE1	FE1	N	2400.00	2400.00	Y	2015-06-15 00:00:00.000	340259	YE	2015-06-10 00:00:00	121552	 	NULL	NULL	NULL
72316	1	2015-06-09 17:20:00	n319	2015-06-10 00:00:00	N	P	15060150	GS15001438	28273	_	T	5093	n1065	WS11	AJ2	N	2700.00	2700.00	Y	2015-06-15 00:00:00.000	340248	YY	2015-06-10 00:00:00	166745	 	NULL	NULL	NULL
72317	1	2015-06-09 17:24:00	n319	2015-06-10 00:00:00	N	P	15060151	GS15001439	27126	_	T	14101	n1489	WS1	AJ1	N	8500.00	8500.00	Y	2015-06-15 00:00:00.000	340249	YY	2015-06-10 00:00:00	166746	 	NULL	NULL	NULL
72318	1	2015-06-09 17:29:00	n319	2015-06-10 00:00:00	N	P	15030261	GS15001442	28419	_	T	3570	n1489	DG1	AA4	N	3000.00	3000.00	Y	2015-06-15 00:00:00.000	340250	YY	2015-06-10 00:00:00	166749	 	NULL	NULL	NULL
72319	1	2015-06-09 17:30:00	n319	2015-06-10 00:00:00	N	P	15050139	GS15001443	28541	_	T	3570	n1489	DG1	AA4	N	3000.00	3000.00	Y	2015-06-15 00:00:00.000	340251	YY	2015-06-10 00:00:00	166750	 	NULL	NULL	NULL
72320	1	2015-06-09 17:32:00	n319	2015-06-10 00:00:00	N	P	15060039	GS15001444	28600	_	T	3570	n1489	DG3	AA41	N	3000.00	3000.00	Y	2015-06-15 00:00:00.000	340252	YY	2015-06-10 00:00:00	166751	 	NULL	NULL	NULL
72321	1	2015-06-10 08:39:00	n087	2015-06-10 00:00:00	N	P	15050330	GS15001446	22247	1	T	14243	n1486	WM64	AG14	N	2000.00	2000.00	Y	2015-06-15 00:00:00.000	340253	YY	2015-06-10 00:00:00	166753	 	NULL	NULL	NULL
72322	1	2015-06-11 00:00:00	n029	2015-06-11 00:00:00	N	T	15060116	GS00034968	66026	_	T	1646	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-06-15 00:00:00.000	340270	YY	2015-06-11 00:00:00	121605	 	NULL	NULL	NULL
72323	1	2015-06-11 00:00:00	n029	2015-06-11 00:00:00	N	T	15060117	GS00034969	66030	_	T	6857	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-06-15 00:00:00.000	340271	YY	2015-06-11 00:00:00	121606	 	NULL	NULL	NULL
72324	1	2015-06-11 00:00:00	n029	2015-06-11 00:00:00	N	T	15060118	GS00034970	66031	_	T	6857	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-06-15 00:00:00.000	340272	YY	2015-06-11 00:00:00	121607	 	NULL	NULL	NULL
72325	1	2015-06-11 00:00:00	n029	2015-06-11 00:00:00	N	T	15060120	GS00034972	64698	_	T	12033	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-06-15 00:00:00.000	340273	YY	2015-06-11 00:00:00	121609	 	NULL	NULL	NULL
72326	1	2015-06-11 00:00:00	n029	2015-06-11 00:00:00	N	T	15060109	GS00034973	66678	_	T	16061	n646	FE11	FE11	N	2700.00	2700.00	Y	2015-06-15 00:00:00.000	340274	YE	2015-06-11 00:00:00	121610	 	NULL	NULL	NULL
72327	1	2015-06-11 00:00:00	n029	2015-06-11 00:00:00	N	T	15050302	GS00034974	66679	_	T	12033	n441	FE1	FE1	N	2400.00	2400.00	Y	2015-06-15 00:00:00.000	340275	YE	2015-06-11 00:00:00	121611	 	NULL	NULL	NULL
72328	1	2015-06-11 00:00:00	n029	2015-06-11 00:00:00	N	T	15050303	GS00034975	66680	_	T	12033	n441	FE1	FE1	N	2400.00	2400.00	Y	2015-06-15 00:00:00.000	340276	YE	2015-06-11 00:00:00	121612	 	NULL	NULL	NULL
72329	1	2015-06-11 00:00:00	n029	2015-06-11 00:00:00	N	T	15050304	GS00034976	66681	_	T	12033	n441	FE1	FE1	N	2400.00	2400.00	Y	2015-06-15 00:00:00.000	340277	YE	2015-06-11 00:00:00	121613	 	NULL	NULL	NULL
72330	1	2015-06-11 08:47:00	n319	2015-06-11 00:00:00	N	P	15060163	GS15001451	23309	_	T	13002	n650	AC2	AE21	N	3200.00	3200.00	Y	2015-06-15 00:00:00.000	340260	YY	2015-06-11 00:00:00	166852	 	NULL	NULL	NULL
72331	1	2015-06-11 08:53:00	n319	2015-06-11 00:00:00	N	P	15060159	GS15001453	27894	_	T	14737	n650	WA3	AN5	D	1000.00	1000.00	Y	2015-06-15 00:00:00.000	340261	YY	2015-06-11 00:00:00	166854	 	NULL	NULL	NULL
72332	1	2015-06-11 08:54:00	n319	2015-06-11 00:00:00	N	P	15060160	GS15001454	27895	_	T	14737	n650	WA3	AN5	D	1000.00	1000.00	Y	2015-06-15 00:00:00.000	340262	YY	2015-06-11 00:00:00	166855	 	NULL	NULL	NULL
72333	1	2015-06-11 08:55:00	n319	2015-06-11 00:00:00	N	P	15060165	GS15001455	28220	_	T	12331	n896	WS11	AJ2	N	14500.00	14500.00	Y	2015-06-15 00:00:00.000	340263	YY	2015-06-11 00:00:00	166856	 	NULL	NULL	NULL
72334	1	2015-06-11 08:56:00	n319	2015-06-11 00:00:00	N	P	15060157	GS15001456	28269	_	T	14737	n650	WA3	AN5	D	1000.00	1000.00	Y	2015-06-15 00:00:00.000	340264	YY	2015-06-11 00:00:00	166857	 	NULL	NULL	NULL
72335	1	2015-06-11 08:57:00	n319	2015-06-11 00:00:00	N	P	15060158	GS15001457	28270	_	T	14737	n650	WA3	AN5	D	1000.00	1000.00	Y	2015-06-15 00:00:00.000	340265	YY	2015-06-11 00:00:00	166858	 	NULL	NULL	NULL
72336	1	2015-06-11 08:58:00	n319	2015-06-11 00:00:00	N	P	15060161	GS15001458	28332	_	T	14737	n650	WA3	AN5	D	1000.00	1000.00	Y	2015-06-15 00:00:00.000	340266	YY	2015-06-11 00:00:00	166859	 	NULL	NULL	NULL
72337	1	2015-06-11 08:59:00	n319	2015-06-11 00:00:00	N	P	15060162	GS15001459	28333	_	T	14737	n650	WA3	AN5	D	1000.00	1000.00	Y	2015-06-15 00:00:00.000	340267	YY	2015-06-11 00:00:00	166860	 	NULL	NULL	NULL
72338	1	2015-06-11 09:01:00	n319	2015-06-11 00:00:00	N	P	15040252	GS15001460	28506	_	T	16021	n1125	IG1E	AA2	N	10500.00	10500.00	Y	2015-06-15 00:00:00.000	340268	YY	2015-06-11 00:00:00	166861	 	NULL	NULL	NULL
72339	1	2015-06-11 09:02:00	n319	2015-06-11 00:00:00	N	P	15040253	GS15001461	28507	_	T	16021	n1125	UG1	AA3	N	3000.00	3000.00	Y	2015-06-15 00:00:00.000	340269	YY	2015-06-11 00:00:00	166862	 	NULL	NULL	NULL
72340	1	2015-06-11 00:00:00	n029	2015-06-11 00:00:00	N	T	15060121	GS00034977	1236	M	T	15925	n547	FE11	FE11	X	18000.00	18000.00	Y	2015-06-15 00:00:00.000	340278	YE	2015-06-11 00:00:00	121654	 	NULL	NULL	NULL
72341	1	2015-06-11 00:00:00	n029	2015-06-11 00:00:00	N	T	15060122	GS00034978	1237	M	T	15925	n547	FE11	FE11	X	18000.00	18000.00	Y	2015-06-15 00:00:00.000	340279	YE	2015-06-11 00:00:00	121655	 	NULL	NULL	NULL
72342	1	2015-06-11 00:00:00	n029	2015-06-12 00:00:00	N	T	15060119	GS00034979	66682	_	T	16065	n646	FE1	FE1	N	2400.00	2400.00	Y	2015-06-18 00:00:00.000	340352	YE	2015-06-12 00:00:00	121674	 	NULL	NULL	NULL
72343	1	2015-06-11 00:00:00	n029	2015-06-12 00:00:00	N	T	15060115	GS00034980	66683	_	T	2164	n441	FE1	FE1	N	2400.00	2400.00	Y	2015-06-18 00:00:00.000	340353	YE	2015-06-12 00:00:00	121675	 	NULL	NULL	NULL
72344	1	2015-06-11 15:17:00	n319	2015-06-12 00:00:00	N	P	15060166	GS15001463	27664	_	T	4436	n113	WM1	AF1	N	300.00	300.00	Y	2015-06-18 00:00:00.000	340342	YY	2015-06-12 00:00:00	166952	 	NULL	NULL	NULL
72345	1	2015-06-11 00:00:00	n029	2015-06-12 00:00:00	N	T	15060114	GS00034981	66684	_	T	2164	n441	FE1	FE1	N	2400.00	2400.00	Y	2015-06-18 00:00:00.000	340354	YE	2015-06-12 00:00:00	121676	 	NULL	NULL	NULL
72346	1	2015-06-11 15:19:00	n319	2015-06-12 00:00:00	N	P	15060164	GS15001464	28357	_	T	15785	n113	WS11	AJ2	N	6100.00	6100.00	Y	2015-06-18 00:00:00.000	340343	YY	2015-06-12 00:00:00	166953	 	NULL	NULL	NULL
72347	1	2015-06-11 15:21:00	n319	2015-06-12 00:00:00	N	P	15040163	GS15001465	28486	_	T	12406	n650	IG1B	AA21	N	9700.00	9700.00	Y	2015-06-18 00:00:00.000	340344	YY	2015-06-12 00:00:00	166954	 	NULL	NULL	NULL
72348	1	2015-06-12 08:48:00	n319	2015-06-12 00:00:00	N	P	15050240	GS15001468	27840	_	T	12433	n650	WM51	AE21	N	800.00	800.00	Y	2015-06-18 00:00:00.000	340345	YY	2015-06-12 00:00:00	166983	 	NULL	NULL	NULL
72349	1	2015-06-12 08:50:00	n319	2015-06-12 00:00:00	N	P	15010050	GS15001469	28274	_	T	12000	n1304	IG1B	AA21	N	9700.00	9700.00	Y	2015-06-18 00:00:00.000	340346	YY	2015-06-12 00:00:00	166984	 	NULL	NULL	NULL
72350	1	2015-06-12 08:54:00	n319	2015-06-12 00:00:00	N	P	15050165	GS15001470	28544	_	T	15057	n113	UG1	AA3	N	3000.00	3000.00	Y	2015-06-18 00:00:00.000	340347	YY	2015-06-12 00:00:00	166985	 	NULL	NULL	NULL
72351	1	2015-06-12 08:56:00	n319	2015-06-12 00:00:00	N	P	15050176	GS15001471	28548	_	T	11997	n1486	IG1E	AA2	N	10500.00	10500.00	Y	2015-06-18 00:00:00.000	340348	YY	2015-06-12 00:00:00	166986	 	NULL	NULL	NULL
72352	1	2015-06-12 08:57:00	n319	2015-06-12 00:00:00	N	P	15050249	GS15001472	28562	_	T	16048	n113	UG1	AA3	N	3000.00	3000.00	Y	2015-06-18 00:00:00.000	340349	YY	2015-06-12 00:00:00	166987	 	NULL	NULL	NULL
72353	1	2015-06-12 08:59:00	n319	2015-06-12 00:00:00	N	P	15050140	GS15001473	28542	_	T	3570	n1489	DG1	AA4	N	3000.00	3000.00	Y	2015-06-18 00:00:00.000	340350	YY	2015-06-12 00:00:00	166988	 	NULL	NULL	NULL
72354	1	2015-06-12 09:11:00	n319	2015-06-12 00:00:00	N	P	15060177	GS15001474	26510	_	T	12002	n896	WS1	AJ1	N	23500.00	23500.00	Y	2015-06-18 00:00:00.000	340351	YY	2015-06-12 00:00:00	166990	 	NULL	NULL	NULL
72355	1	2015-06-12 15:22:00	n319	2015-06-15 00:00:00	N	P	15040299	GS15001475	28512	_	T	13225	n896	UG1	AA3	N	3000.00	3000.00	Y	2015-06-18 00:00:00.000	340355	YY	2015-06-15 00:00:00	167074	 	NULL	NULL	NULL
72356	1	2015-06-15 00:00:00	n029	2015-06-15 00:00:00	N	T	15060137	GS00034986	65657	_	T	15755	n1350	FF0	FF0	N	2500.00	2500.00	Y	2015-06-18 00:00:00.000	340363	YY	2015-06-15 00:00:00	121761	 	NULL	NULL	NULL
72357	1	2015-06-15 08:51:00	n319	2015-06-15 00:00:00	N	P	14120189	GS15001479	28216	_	T	15877	n994	IG1B	AA21	N	9700.00	9700.00	Y	2015-06-18 00:00:00.000	340356	YY	2015-06-15 00:00:00	167081	 	NULL	NULL	NULL
72358	1	2015-06-15 09:11:00	n319	2015-06-15 00:00:00	N	P	15040036	GS15001480	28456	_	T	16011	n1125	IG1E	AA2	N	10500.00	11300.00	Y	2015-06-18 00:00:00.000	340357	YY	2015-06-15 00:00:00	167082	 	NULL	NULL	NULL
72359	1	2015-06-15 09:11:00	n319	2015-06-15 00:00:00	N	P	15060182	GS15001480	28456	_	T	16011	n1125	AC2	AA2	N	800.00	11300.00	Y	2015-06-18 00:00:00.000	340358	YY	2015-06-15 00:00:00	167082	 	NULL	NULL	NULL
72360	1	2015-06-15 09:14:00	n319	2015-06-15 00:00:00	N	P	15010208	GS15001481	28304	_	T	13639	n100	IG1E	AA2	N	10500.00	10500.00	Y	2015-06-18 00:00:00.000	340359	YY	2015-06-15 00:00:00	167083	 	NULL	NULL	NULL
72361	1	2015-06-15 09:15:00	n319	2015-06-15 00:00:00	N	P	15060170	GS15001482	28017	_	T	15867	n1489	WS11	AJ2	N	2700.00	2700.00	Y	2015-06-18 00:00:00.000	340360	YY	2015-06-15 00:00:00	167084	 	NULL	NULL	NULL
72362	1	2015-06-15 09:16:00	n319	2015-06-15 00:00:00	N	P	15060179	GS15001483	28021	_	T	15867	n1489	WS11	AJ2	N	2700.00	2700.00	Y	2015-06-18 00:00:00.000	340361	YY	2015-06-15 00:00:00	167085	 	NULL	NULL	NULL
72363	1	2015-06-15 09:17:00	n319	2015-06-15 00:00:00	N	P	15060172	GS15001484	28042	_	T	15867	n1489	WS11	AJ2	N	2700.00	2700.00	Y	2015-06-18 00:00:00.000	340362	YY	2015-06-15 00:00:00	167086	 	NULL	NULL	NULL
72364	1	2015-06-15 00:00:00	n029	2015-06-16 00:00:00	N	T	15050317	GS00034989	53214	_	T	2507	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-06-18 00:00:00.000	340375	YY	2015-06-16 00:00:00	121788	 	NULL	NULL	NULL
72365	1	2015-06-15 00:00:00	n029	2015-06-16 00:00:00	N	T	15050039	GS00034990	38351	_	T	3116	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-06-18 00:00:00.000	340376	YY	2015-06-16 00:00:00	121789	 	NULL	NULL	NULL
72366	1	2015-06-15 00:00:00	n029	2015-06-16 00:00:00	N	T	15050040	GS00034991	39934	_	T	3116	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-06-18 00:00:00.000	340377	YY	2015-06-16 00:00:00	121790	 	NULL	NULL	NULL
72367	1	2015-06-15 00:00:00	n029	2015-06-16 00:00:00	N	T	15050041	GS00034992	53168	_	T	3116	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-06-18 00:00:00.000	340378	YY	2015-06-16 00:00:00	121791	 	NULL	NULL	NULL
72368	1	2015-06-15 00:00:00	n029	2015-06-16 00:00:00	N	T	15060017	GS00034993	66665	_	T	14476	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-06-18 00:00:00.000	340379	YY	2015-06-16 00:00:00	121792	 	NULL	NULL	NULL
72369	1	2015-06-15 00:00:00	n029	2015-06-16 00:00:00	N	T	15060018	GS00034994	66666	_	T	14476	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-06-18 00:00:00.000	340380	YY	2015-06-16 00:00:00	121794	 	NULL	NULL	NULL
72370	1	2015-06-15 00:00:00	n029	2015-06-16 00:00:00	N	T	15060049	GS00034995	53464	_	T	13170	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-06-18 00:00:00.000	340381	YY	2015-06-16 00:00:00	121795	 	NULL	NULL	NULL
72371	1	2015-06-15 00:00:00	n029	2015-06-16 00:00:00	N	T	15060051	GS00034996	38613	_	T	1806	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-06-18 00:00:00.000	340382	YY	2015-06-16 00:00:00	121796	 	NULL	NULL	NULL
72372	1	2015-06-15 00:00:00	n029	2015-06-16 00:00:00	N	T	15060050	GS00034997	38615	_	T	1806	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-06-18 00:00:00.000	340383	YY	2015-06-16 00:00:00	121797	 	NULL	NULL	NULL
72373	1	2015-06-15 00:00:00	n029	2015-06-16 00:00:00	N	T	15060131	GS00034998	65926	_	T	15348	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-06-18 00:00:00.000	340384	YY	2015-06-16 00:00:00	121798	 	NULL	NULL	NULL
72374	1	2015-06-15 00:00:00	n029	2015-06-16 00:00:00	N	T	15060139	GS00034999	65987	_	T	15899	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-06-18 00:00:00.000	340385	YY	2015-06-16 00:00:00	121799	 	NULL	NULL	NULL
72375	1	2015-06-15 00:00:00	n029	2015-06-16 00:00:00	N	T	15060141	GS00035000	65993	_	T	15899	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-06-18 00:00:00.000	340386	YY	2015-06-16 00:00:00	121800	 	NULL	NULL	NULL
72376	1	2015-06-15 00:00:00	n029	2015-06-16 00:00:00	N	T	15060140	GS00035001	65999	_	T	15899	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-06-18 00:00:00.000	340387	YY	2015-06-16 00:00:00	121801	 	NULL	NULL	NULL
72377	1	2015-06-15 00:00:00	n029	2015-06-16 00:00:00	N	T	15060142	GS00035002	66005	_	T	15899	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-06-18 00:00:00.000	340388	YY	2015-06-16 00:00:00	121802	 	NULL	NULL	NULL
72378	1	2015-06-15 00:00:00	n029	2015-06-16 00:00:00	N	T	15060145	GS00035003	52934	_	T	13063	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-06-18 00:00:00.000	340389	YY	2015-06-16 00:00:00	121803	 	NULL	NULL	NULL
72379	1	2015-06-15 15:37:00	n319	2015-06-16 00:00:00	N	P	15050079	GS15001488	28527	_	T	16037	n1125	UG1	AA3	N	3000.00	3000.00	Y	2015-06-18 00:00:00.000	340364	YY	2015-06-16 00:00:00	167159	 	NULL	NULL	NULL
72380	1	2015-06-15 00:00:00	n029	2015-06-16 00:00:00	N	T	15060136	GS00035008	66685	_	T	16067	n428	FE1	FE1	N	2400.00	2400.00	Y	2015-06-18 00:00:00.000	340390	YE	2015-06-16 00:00:00	121831	 	NULL	NULL	NULL
72381	1	2015-06-15 16:41:00	n319	2015-06-16 00:00:00	N	P	15060209	GS15001489	28337	_	T	10554	n100	WS1	AJ1	N	8500.00	8500.00	Y	2015-06-18 00:00:00.000	340365	YY	2015-06-16 00:00:00	167172	 	NULL	NULL	NULL
72382	1	2015-06-16 00:00:00	n029	2015-06-16 00:00:00	N	T	15060146	GS00035009	66687	_	T	15224	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-06-18 00:00:00.000	340391	YE	2015-06-16 00:00:00	121851	 	NULL	NULL	NULL
72383	1	2015-06-16 00:00:00	n029	2015-06-16 00:00:00	N	T	15060147	GS00035010	66688	_	T	15224	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-06-18 00:00:00.000	340392	YE	2015-06-16 00:00:00	121852	 	NULL	NULL	NULL
72384	1	2015-06-16 00:00:00	n029	2015-06-16 00:00:00	N	T	15060148	GS00035011	66689	_	T	15224	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-06-18 00:00:00.000	340393	YE	2015-06-16 00:00:00	121853	 	NULL	NULL	NULL
72385	1	2015-06-16 09:34:00	n319	2015-06-16 00:00:00	N	P	15050226	GS15001491	28561	_	T	10747	n1065	UG1	AA3	N	3000.00	3000.00	Y	2015-06-18 00:00:00.000	340366	YY	2015-06-16 00:00:00	167179	 	NULL	NULL	NULL
72386	1	2015-06-16 09:42:00	n319	2015-06-16 00:00:00	N	P	15060199	GS15001492	26399	_	T	10747	n1065	WS1	AJ1	N	8500.00	8500.00	Y	2015-06-18 00:00:00.000	340367	YY	2015-06-16 00:00:00	167182	 	NULL	NULL	NULL
72387	1	2015-06-16 09:42:00	n319	2015-06-16 00:00:00	N	P	15060198	GS15001493	27780	_	T	10747	n1065	WS1	AJ1	N	8500.00	8500.00	Y	2015-06-18 00:00:00.000	340368	YY	2015-06-16 00:00:00	167185	 	NULL	NULL	NULL
72388	1	2015-06-16 09:43:00	n319	2015-06-16 00:00:00	N	P	15060197	GS15001494	27908	_	T	10747	n1065	WS1	AJ1	N	8500.00	8500.00	Y	2015-06-18 00:00:00.000	340369	YY	2015-06-16 00:00:00	167187	 	NULL	NULL	NULL
72389	1	2015-06-16 09:44:00	n319	2015-06-16 00:00:00	N	P	15060196	GS15001495	28119	_	T	10747	n1065	WS1	AJ1	N	8500.00	8500.00	Y	2015-06-18 00:00:00.000	340370	YY	2015-06-16 00:00:00	167188	 	NULL	NULL	NULL
72390	1	2015-06-16 09:45:00	n319	2015-06-16 00:00:00	N	P	15060194	GS15001496	26910	_	T	10747	n1065	WS1	AJ1	N	3400.00	3400.00	Y	2015-06-18 00:00:00.000	340371	YY	2015-06-16 00:00:00	167189	 	NULL	NULL	NULL
72391	1	2015-06-16 09:45:00	n319	2015-06-16 00:00:00	N	P	15060195	GS15001497	28218	_	T	10747	n1065	WS1	AJ1	N	8500.00	8500.00	Y	2015-06-18 00:00:00.000	340372	YY	2015-06-16 00:00:00	167190	 	NULL	NULL	NULL
72392	1	2015-06-16 09:46:00	n319	2015-06-16 00:00:00	N	P	15050172	GS15001498	28545	_	T	13042	n650	IG1B	AA21	N	9700.00	10500.00	Y	2015-06-18 00:00:00.000	340373	YY	2015-06-16 00:00:00	167191	 	NULL	NULL	NULL
72393	1	2015-06-16 09:46:00	n319	2015-06-16 00:00:00	N	P	15060218	GS15001498	28545	_	T	13042	n650	AC2	AA21	N	800.00	10500.00	Y	2015-06-18 00:00:00.000	340374	YY	2015-06-16 00:00:00	167191	 	NULL	NULL	NULL
72394	1	2015-06-16 14:56:00	n319	2015-06-17 00:00:00	N	P	15060217	GS15001499	26274	_	T	11290	n896	WS1	AJ1	N	8500.00	8500.00	Y	2015-06-18 00:00:00.000	340394	YY	2015-06-17 00:00:00	167263	 	NULL	NULL	NULL
72395	1	2015-06-16 14:58:00	n319	2015-06-17 00:00:00	N	P	15060219	GS15001500	28109	_	T	15632	n896	WS11	AJ2	N	4400.00	4400.00	Y	2015-06-18 00:00:00.000	340395	YY	2015-06-17 00:00:00	167264	 	NULL	NULL	NULL
72396	1	2015-06-16 15:03:00	n319	2015-06-17 00:00:00	N	P	15060184	GS15001502	28452	_	T	13472	n1304	WA3	AN5	N	2000.00	2000.00	Y	2015-06-18 00:00:00.000	340396	YY	2015-06-17 00:00:00	167266	 	NULL	NULL	NULL
72397	1	2015-06-16 15:04:00	n319	2015-06-17 00:00:00	N	P	15060207	GS15001503	28548	_	T	11997	n1486	WA3	AN5	D	1000.00	1000.00	Y	2015-06-18 00:00:00.000	340397	YY	2015-06-17 00:00:00	167267	 	NULL	NULL	NULL
72398	1	2015-06-16 17:16:00	n319	2015-06-17 00:00:00	N	P	15060230	GS15001504	22080	_	T	12556	n1489	WS11	AJ2	N	6100.00	6100.00	Y	2015-06-18 00:00:00.000	340398	YY	2015-06-17 00:00:00	167281	 	NULL	NULL	NULL
72399	1	2015-06-17 00:00:00	n029	2015-06-17 00:00:00	N	T	15060144	GS00035012	66690	_	T	13712	n441	FE11	FE11	N	2700.00	2700.00	Y	2015-06-18 00:00:00.000	340411	YE	2015-06-17 00:00:00	121919	 	NULL	NULL	NULL
72400	1	2015-06-17 08:48:00	n319	2015-06-17 00:00:00	N	P	15040294	GS15001507	26712	_	T	14963	n1304	FR1	AB1	N	7000.00	7000.00	Y	2015-06-18 00:00:00.000	340399	YY	2015-06-17 00:00:00	167284	 	NULL	NULL	NULL
72401	1	2015-06-17 08:50:00	n319	2015-06-17 00:00:00	N	P	15060228	GS15001508	27296	_	T	4623	n1125	WS11	AJ2	N	1000.00	1000.00	Y	2015-06-18 00:00:00.000	340400	YY	2015-06-17 00:00:00	167285	 	NULL	NULL	NULL
72402	1	2015-06-17 08:51:00	n319	2015-06-17 00:00:00	N	P	15060229	GS15001509	27416	_	T	4623	n1125	WS11	AJ2	N	1000.00	1000.00	Y	2015-06-18 00:00:00.000	340401	YY	2015-06-17 00:00:00	167286	 	NULL	NULL	NULL
72403	1	2015-06-17 08:52:00	n319	2015-06-17 00:00:00	N	P	15060224	GS15001510	27861	_	T	4623	n1125	WS11	AJ2	N	1000.00	1000.00	Y	2015-06-18 00:00:00.000	340402	YY	2015-06-17 00:00:00	167287	 	NULL	NULL	NULL
72404	1	2015-06-17 08:53:00	n319	2015-06-17 00:00:00	N	P	15060225	GS15001511	27862	_	T	4623	n1125	WS11	AJ2	N	1000.00	1000.00	Y	2015-06-18 00:00:00.000	340403	YY	2015-06-17 00:00:00	167288	 	NULL	NULL	NULL
72405	1	2015-06-17 08:54:00	n319	2015-06-17 00:00:00	N	P	15060226	GS15001512	27863	_	T	4623	n1125	WS11	AJ2	N	1000.00	1000.00	Y	2015-06-18 00:00:00.000	340404	YY	2015-06-17 00:00:00	167289	 	NULL	NULL	NULL
72406	1	2015-06-17 08:54:00	n319	2015-06-17 00:00:00	N	P	15060227	GS15001513	27864	_	T	4623	n1125	WS11	AJ2	N	1000.00	1000.00	Y	2015-06-18 00:00:00.000	340405	YY	2015-06-17 00:00:00	167290	 	NULL	NULL	NULL
72407	1	2015-06-17 08:55:00	n319	2015-06-17 00:00:00	N	P	15060223	GS15001514	27865	_	T	4623	n1125	WS11	AJ2	N	1000.00	1000.00	Y	2015-06-18 00:00:00.000	340406	YY	2015-06-17 00:00:00	167291	 	NULL	NULL	NULL
72408	1	2015-06-17 00:00:00	n029	2015-06-17 00:00:00	N	T	15060160	GS00035013	66691	_	T	4837	n547	FE1	FE1	N	2400.00	2400.00	Y	2015-06-18 00:00:00.000	340412	YE	2015-06-17 00:00:00	121923	 	NULL	NULL	NULL
72409	1	2015-06-17 00:00:00	n029	2015-06-17 00:00:00	N	T	15060150	GS00035014	66692	_	T	15503	n428	FE1	FE1	N	2400.00	2400.00	Y	2015-06-18 00:00:00.000	340413	YE	2015-06-17 00:00:00	121924	 	NULL	NULL	NULL
72410	1	2015-06-17 09:05:00	n319	2015-06-17 00:00:00	N	P	15050325	GS15001519	28578	_	T	14374	n1304	DG1	AA4	N	3000.00	3000.00	Y	2015-06-18 00:00:00.000	340407	YY	2015-06-17 00:00:00	167296	 	NULL	NULL	NULL
72411	1	2015-06-17 00:00:00	n029	2015-06-17 00:00:00	N	T	15060151	GS00035015	66693	_	T	15503	n428	FE1	FE1	N	2400.00	2400.00	Y	2015-06-18 00:00:00.000	340414	YE	2015-06-17 00:00:00	121925	 	NULL	NULL	NULL
72412	1	2015-06-17 09:07:00	n319	2015-06-17 00:00:00	N	P	15050338	GS15001520	28583	_	T	16054	n1125	IG1E	AA2	N	10500.00	10500.00	Y	2015-06-18 00:00:00.000	340408	YY	2015-06-17 00:00:00	167297	 	NULL	NULL	NULL
72413	1	2015-06-17 09:09:00	n319	2015-06-17 00:00:00	N	P	15050339	GS15001521	28584	_	T	16054	n1125	UG1	AA3	N	3000.00	3000.00	Y	2015-06-18 00:00:00.000	340409	YY	2015-06-17 00:00:00	167298	 	NULL	NULL	NULL
72414	1	2015-06-17 14:42:00	n087	2015-06-17 00:00:00	N	P	15050282	GS15001522	28564	_	T	16032	n994	IG1B	AA21	N	9700.00	9700.00	Y	2015-06-18 00:00:00.000	340410	YY	2015-06-17 00:00:00	167388	 	NULL	NULL	NULL
72415	1	2015-06-17 00:00:00	n029	2015-06-18 00:00:00	N	T	15060165	GS00035016	66245	_	T	15389	n1384	FF0	FF0	N	7500.00	7500.00	Y	2015-06-24 00:00:00.000	341335	YY	2015-06-18 00:00:00	121989	 	NULL	NULL	NULL
72416	1	2015-06-17 00:00:00	n029	2015-06-18 00:00:00	N	T	15060169	GS00035017	65939	_	T	15804	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-06-24 00:00:00.000	341336	YY	2015-06-18 00:00:00	121990	 	NULL	NULL	NULL
72417	1	2015-06-17 00:00:00	n029	2015-06-18 00:00:00	N	T	15060170	GS00035018	65940	_	T	15804	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-06-24 00:00:00.000	341337	YY	2015-06-18 00:00:00	121991	 	NULL	NULL	NULL
72418	1	2015-06-17 00:00:00	n029	2015-06-18 00:00:00	N	T	15060162	GS00035019	53434	_	T	835	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-06-24 00:00:00.000	341338	YY	2015-06-18 00:00:00	121992	 	NULL	NULL	NULL
72419	1	2015-06-17 00:00:00	n029	2015-06-18 00:00:00	N	T	15060163	GS00035020	66694	_	T	16073	n428	FE1	FE1	N	2400.00	2400.00	Y	2015-06-24 00:00:00.000	341339	YE	2015-06-18 00:00:00	121993	 	NULL	NULL	NULL
72420	1	2015-06-17 00:00:00	n029	2015-06-18 00:00:00	N	T	15060164	GS00035021	66695	_	T	16073	n428	FE1	FE1	N	2400.00	2400.00	Y	2015-06-24 00:00:00.000	341340	YE	2015-06-18 00:00:00	121994	 	NULL	NULL	NULL
72421	1	2015-06-17 00:00:00	n029	2015-06-18 00:00:00	N	T	15060171	GS00035022	66703	_	T	13792	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-06-24 00:00:00.000	341341	YE	2015-06-18 00:00:00	121995	 	NULL	NULL	NULL
72422	1	2015-06-17 00:00:00	n029	2015-06-18 00:00:00	N	T	15060172	GS00035023	66704	_	T	13792	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-06-24 00:00:00.000	341342	YE	2015-06-18 00:00:00	121996	 	NULL	NULL	NULL
72423	1	2015-06-17 16:56:00	n087	2015-06-18 00:00:00	N	P	15060241	GS15001523	26939	_	T	13884	n650	WS1	AJ1	N	3500.00	3500.00	Y	2015-06-24 00:00:00.000	341315	YY	2015-06-18 00:00:00	167403	 	NULL	NULL	NULL
72424	1	2015-06-17 00:00:00	n029	2015-06-18 00:00:00	N	T	15060173	GS00035024	66705	_	T	13792	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-06-24 00:00:00.000	341343	YE	2015-06-18 00:00:00	121997	 	NULL	NULL	NULL
72425	1	2015-06-17 16:57:00	n087	2015-06-18 00:00:00	N	P	15060240	GS15001524	26206	_	T	13884	n650	WS1	AJ1	N	3500.00	3500.00	Y	2015-06-24 00:00:00.000	341316	YY	2015-06-18 00:00:00	167404	 	NULL	NULL	NULL
72426	1	2015-06-17 16:59:00	n087	2015-06-18 00:00:00	N	P	15060238	GS15001525	28078	_	T	15850	n896	WS11	AJ2	N	1000.00	1000.00	Y	2015-06-24 00:00:00.000	341317	YY	2015-06-18 00:00:00	167405	 	NULL	NULL	NULL
72427	1	2015-06-17 00:00:00	n029	2015-06-18 00:00:00	N	T	15060174	GS00035025	66696	_	T	16046	n646	FE1	FE1	N	13500.00	13500.00	Y	2015-06-24 00:00:00.000	341344	YE	2015-06-18 00:00:00	121998	 	NULL	NULL	NULL
72428	1	2015-06-18 00:00:00	n029	2015-06-18 00:00:00	N	T	15060175	GS00035026	66697	_	T	16046	n646	FE1	FE1	N	13500.00	13500.00	Y	2015-06-24 00:00:00.000	341345	YE	2015-06-18 00:00:00	122004	 	NULL	NULL	NULL
72429	1	2015-06-18 00:00:00	n029	2015-06-18 00:00:00	N	T	15060176	GS00035027	66698	_	T	16046	n646	FE1	FE1	N	13500.00	13500.00	Y	2015-06-24 00:00:00.000	341346	YE	2015-06-18 00:00:00	122005	 	NULL	NULL	NULL
72430	1	2015-06-18 00:00:00	n029	2015-06-18 00:00:00	N	T	15060177	GS00035028	66699	_	T	16046	n646	FE1	FE1	N	13500.00	13500.00	Y	2015-06-24 00:00:00.000	341347	YE	2015-06-18 00:00:00	122006	 	NULL	NULL	NULL
72431	1	2015-06-18 00:00:00	n029	2015-06-18 00:00:00	N	T	15060178	GS00035029	66700	_	T	16046	n646	FE1	FE1	N	13500.00	13500.00	Y	2015-06-24 00:00:00.000	341348	YE	2015-06-18 00:00:00	122007	 	NULL	NULL	NULL
72432	1	2015-06-18 00:00:00	n029	2015-06-18 00:00:00	N	T	15060179	GS00035030	66701	_	T	16046	n646	FE1	FE1	N	13500.00	13500.00	Y	2015-06-24 00:00:00.000	341349	YE	2015-06-18 00:00:00	122008	 	NULL	NULL	NULL
72433	1	2015-06-18 00:00:00	n029	2015-06-18 00:00:00	N	T	15060180	GS00035031	66702	_	T	16046	n646	FE1	FE1	N	13500.00	13500.00	Y	2015-06-24 00:00:00.000	341350	YE	2015-06-18 00:00:00	122009	 	NULL	NULL	NULL
72434	1	2015-06-18 08:44:00	n319	2015-06-18 00:00:00	N	P	15060235	GS15001527	26723	_	T	6752	n1489	WM1	AF1	N	300.00	300.00	Y	2015-06-24 00:00:00.000	341318	YY	2015-06-18 00:00:00	167418	 	NULL	NULL	NULL
72435	1	2015-06-18 08:45:00	n319	2015-06-18 00:00:00	N	P	15050255	GS15001528	26723	_	T	6752	n1489	WS11	AJ2	N	6100.00	6100.00	Y	2015-06-24 00:00:00.000	341319	YY	2015-06-18 00:00:00	167419	 	NULL	NULL	NULL
72436	1	2015-06-18 08:48:00	n319	2015-06-18 00:00:00	N	P	15060237	GS15001530	27490	_	T	6752	n1489	WM1	AF1	N	300.00	300.00	Y	2015-06-24 00:00:00.000	341320	YY	2015-06-18 00:00:00	167421	 	NULL	NULL	NULL
72437	1	2015-06-18 08:49:00	n319	2015-06-18 00:00:00	N	P	15060236	GS15001531	27491	_	T	6752	n1489	WM1	AF1	N	300.00	300.00	Y	2015-06-24 00:00:00.000	341321	YY	2015-06-18 00:00:00	167422	 	NULL	NULL	NULL
72438	1	2015-06-18 08:52:00	n319	2015-06-18 00:00:00	N	P	14030022	GS15001532	27526	_	T	15640	n896	IG1B	AA21	N	9700.00	9700.00	Y	2015-06-24 00:00:00.000	341322	YY	2015-06-18 00:00:00	167423	 	NULL	NULL	NULL
72439	1	2015-06-18 08:53:00	n319	2015-06-18 00:00:00	N	P	14030023	GS15001533	27527	_	T	15640	n896	IG1B	AA21	N	9700.00	9700.00	Y	2015-06-24 00:00:00.000	341323	YY	2015-06-18 00:00:00	167424	 	NULL	NULL	NULL
72440	1	2015-06-18 08:55:00	n319	2015-06-18 00:00:00	N	P	14030024	GS15001534	27528	_	T	15640	n896	IG1B	AA21	N	9700.00	9700.00	Y	2015-06-24 00:00:00.000	341324	YY	2015-06-18 00:00:00	167425	 	NULL	NULL	NULL
72441	1	2015-06-18 08:56:00	n319	2015-06-18 00:00:00	N	P	14030025	GS15001535	27529	_	T	15640	n896	IG1B	AA21	N	9700.00	9700.00	Y	2015-06-24 00:00:00.000	341325	YY	2015-06-18 00:00:00	167426	 	NULL	NULL	NULL
72442	1	2015-06-18 08:58:00	n319	2015-06-18 00:00:00	N	P	14030175	GS15001536	27551	_	T	15640	n896	IG1B	AA21	N	9700.00	9700.00	Y	2015-06-24 00:00:00.000	341326	YY	2015-06-18 00:00:00	167427	 	NULL	NULL	NULL
72443	1	2015-06-18 00:00:00	n029	2015-06-18 00:00:00	N	T	15060188	GS00035032	65502	_	T	14032	n1384	FN1	FN1	N	500.00	500.00	Y	2015-06-24 00:00:00.000	341351	YY	2015-06-18 00:00:00	122010	 	NULL	NULL	NULL
72444	1	2015-06-18 09:00:00	n319	2015-06-18 00:00:00	N	P	14030176	GS15001537	27552	_	T	15640	n896	IG1B	AA21	N	9700.00	9700.00	Y	2015-06-24 00:00:00.000	341327	YY	2015-06-18 00:00:00	167428	 	NULL	NULL	NULL
72445	1	2015-06-18 09:11:00	n319	2015-06-18 00:00:00	N	P	15040222	GS15001543	28503	_	T	13444	n650	IG1E	AA2	N	10500.00	10500.00	Y	2015-06-24 00:00:00.000	341328	YY	2015-06-18 00:00:00	167434	 	NULL	NULL	NULL
72446	1	2015-06-18 09:35:00	n319	2015-06-18 00:00:00	N	P	15050173	GS15001544	28469	_	T	15390	n994	OG4	BB4	N	2000.00	2000.00	Y	2015-06-24 00:00:00.000	341329	YY	2015-06-18 00:00:00	167441	 	NULL	NULL	NULL
72447	1	2015-06-18 09:40:00	n319	2015-06-18 00:00:00	N	P	15020209	GS15001545	28372	_	T	15196	n650	OG12	BB12	N	13000.00	21000.00	Y	2015-06-24 00:00:00.000	341330	YY	2015-06-18 00:00:00	167444	 	NULL	NULL	NULL
72448	1	2015-06-18 09:40:00	n319	2015-06-18 00:00:00	N	P	15060250	GS15001545	28372	_	T	15196	n650	AC2	BB12	N	8000.00	21000.00	Y	2015-06-24 00:00:00.000	341331	YY	2015-06-18 00:00:00	167444	 	NULL	NULL	NULL
72449	1	2015-06-18 09:43:00	n319	2015-06-18 00:00:00	N	P	15060231	GS15001546	1071	M	T	12293	n113	WS2	AK2	X	5000.00	5000.00	Y	2015-06-24 00:00:00.000	341332	YE	2015-06-18 00:00:00	167445	 	NULL	NULL	NULL
72450	1	2015-06-18 11:37:00	n319	2015-06-18 00:00:00	N	P	15060029	GS15001547	28601	_	T	14510	n1125	DG1	AA4	N	3000.00	3000.00	Y	2015-06-24 00:00:00.000	341333	YY	2015-06-18 00:00:00	167503	 	NULL	NULL	NULL
72451	1	2015-06-18 11:38:00	n319	2015-06-18 00:00:00	N	P	15060211	GS15001548	28644	_	T	15012	n1125	UG1	AA3	N	3000.00	3000.00	Y	2015-06-24 00:00:00.000	341334	YY	2015-06-18 00:00:00	167504	 	NULL	NULL	NULL
72452	1	2015-06-18 00:00:00	n029	2015-06-22 00:00:00	N	T	15060190	GS00035033	65749	_	T	4837	n547	FF0	FF0	N	2500.00	2500.00	Y	2015-06-24 00:00:00.000	341356	YY	2015-06-22 00:00:00	122127	 	NULL	NULL	NULL
72453	1	2015-06-18 17:03:00	n319	2015-06-22 00:00:00	N	P	15060214	GS15001553	28505	_	T	13708	n896	WA3	AN5	D	2000.00	2000.00	Y	2015-06-24 00:00:00.000	341352	YY	2015-06-22 00:00:00	167553	 	NULL	NULL	NULL
72454	1	2015-06-18 17:04:00	n319	2015-06-22 00:00:00	N	P	15060252	GS15001554	26475	_	T	13472	n1304	WS1	AJ1	N	8500.00	8500.00	Y	2015-06-24 00:00:00.000	341353	YY	2015-06-22 00:00:00	167554	 	NULL	NULL	NULL
72455	1	2015-06-22 00:00:00	n029	2015-06-22 00:00:00	N	T	15060187	GS00035035	66706	_	T	16058	n646	FE11	FE11	N	2700.00	2700.00	Y	2015-06-24 00:00:00.000	341357	YE	2015-06-22 00:00:00	122129	 	NULL	NULL	NULL
72456	1	2015-06-22 09:30:00	n319	2015-06-22 00:00:00	N	P	15060259	GS15001557	1178	M	T	15548	n113	AC2	AAD	X	8000.00	8000.00	Y	2015-06-24 00:00:00.000	341354	YY	2015-06-22 00:00:00	167560	 	NULL	NULL	NULL
72457	1	2015-06-22 09:41:00	n319	2015-06-22 00:00:00	N	P	15060008	GS15001558	28598	_	T	13444	n650	IG1E	AA2	N	10500.00	10500.00	Y	2015-06-24 00:00:00.000	341355	YY	2015-06-22 00:00:00	167561	 	NULL	NULL	NULL
72458	1	2015-06-22 15:32:00	n319	2015-06-23 00:00:00	N	P	15060265	GS15001559	25971	_	T	14928	n650	WS11	AJ2	N	6100.00	6100.00	Y	2015-06-26 00:00:00.000	341548	YY	2015-06-23 00:00:00	167632	 	NULL	NULL	NULL
72459	1	2015-06-22 15:33:00	n319	2015-06-23 00:00:00	N	P	15060264	GS15001560	26378	_	T	14928	n650	WS11	AJ2	N	6100.00	6100.00	Y	2015-06-26 00:00:00.000	341549	YY	2015-06-23 00:00:00	167633	 	NULL	NULL	NULL
72460	1	2015-06-22 15:35:00	n319	2015-06-23 00:00:00	N	P	15060263	GS15001561	27147	_	T	13042	n650	WS11	AJ2	N	6100.00	6100.00	Y	2015-06-26 00:00:00.000	341550	YY	2015-06-23 00:00:00	167634	 	NULL	NULL	NULL
72461	1	2015-06-22 00:00:00	k1416	2015-06-22 00:00:00	N	T	15050124	BGS0005025	64577	_	T	14643	n1350	AS1	AS1	N	4000.00	4000.00	Y	2015-06-26 00:00:00.000	341556	YY	2015-06-23 00:00:00	122186	 	NULL	NULL	NULL
72462	1	2015-06-22 00:00:00	n029	2015-06-23 00:00:00	N	T	15060210	GS00035038	65857	_	T	4837	n547	FF0	FF0	N	2500.00	2500.00	Y	2015-06-26 00:00:00.000	341557	YY	2015-06-23 00:00:00	122187	 	NULL	NULL	NULL
72463	1	2015-06-22 00:00:00	n029	2015-06-23 00:00:00	N	T	15060204	GS00035039	65952	_	T	15430	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-06-26 00:00:00.000	341558	YY	2015-06-23 00:00:00	122188	 	NULL	NULL	NULL
72464	1	2015-06-22 00:00:00	n029	2015-06-23 00:00:00	N	T	15060192	GS00035040	53480	_	T	13189	n824	FI1	FI1	N	500.00	500.00	Y	2015-06-26 00:00:00.000	341559	YY	2015-06-23 00:00:00	122189	 	NULL	NULL	NULL
72465	1	2015-06-22 00:00:00	n029	2015-06-23 00:00:00	N	T	15060193	GS00035041	53481	_	T	13189	n824	FI1	FI1	N	500.00	500.00	Y	2015-06-26 00:00:00.000	341560	YY	2015-06-23 00:00:00	122190	 	NULL	NULL	NULL
72466	1	2015-06-22 00:00:00	n029	2015-06-23 00:00:00	N	T	15060194	GS00035042	53482	_	T	13189	n824	FI1	FI1	N	500.00	500.00	Y	2015-06-26 00:00:00.000	341561	YY	2015-06-23 00:00:00	122191	 	NULL	NULL	NULL
72467	1	2015-06-22 00:00:00	n029	2015-06-23 00:00:00	N	T	15060195	GS00035043	53483	_	T	13189	n824	FI1	FI1	N	500.00	500.00	Y	2015-06-26 00:00:00.000	341562	YY	2015-06-23 00:00:00	122192	 	NULL	NULL	NULL
72468	1	2015-06-23 00:00:00	n029	2015-06-23 00:00:00	N	T	15060196	GS00035044	53484	_	T	13189	n824	FI1	FI1	N	500.00	500.00	Y	2015-06-26 00:00:00.000	341563	YY	2015-06-23 00:00:00	122193	 	NULL	NULL	NULL
72469	1	2015-06-23 00:00:00	n029	2015-06-23 00:00:00	N	T	15060197	GS00035045	53575	_	T	13189	n824	FI1	FI1	N	500.00	500.00	Y	2015-06-26 00:00:00.000	341564	YY	2015-06-23 00:00:00	122194	 	NULL	NULL	NULL
72470	1	2015-06-23 00:00:00	n029	2015-06-23 00:00:00	N	T	15060198	GS00035046	54301	_	T	13189	n824	FI1	FI1	N	500.00	500.00	Y	2015-06-26 00:00:00.000	341565	YY	2015-06-23 00:00:00	122195	 	NULL	NULL	NULL
72471	1	2015-06-23 00:00:00	n029	2015-06-23 00:00:00	N	T	15060202	GS00035051	66709	_	T	16074	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-06-26 00:00:00.000	341566	YE	2015-06-23 00:00:00	122203	 	NULL	NULL	NULL
72472	1	2015-06-23 08:47:00	n087	2015-06-23 00:00:00	N	P	15060095	GS15001565	28633	_	T	14171	n1304	UG1	AA3	N	3000.00	3000.00	Y	2015-06-26 00:00:00.000	341551	YY	2015-06-23 00:00:00	167651	 	NULL	NULL	NULL
72473	1	2015-06-23 08:50:00	n087	2015-06-23 00:00:00	N	P	15050334	GS15001566	28582	_	T	15179	n1304	IG1E	AA2	N	10500.00	10500.00	Y	2015-06-26 00:00:00.000	341552	YY	2015-06-23 00:00:00	167652	 	NULL	NULL	NULL
72474	1	2015-06-23 09:03:00	n087	2015-06-23 00:00:00	N	P	15050245	GS15001569	28569	_	T	10747	n1065	UG1	AA3	N	3000.00	3000.00	Y	2015-06-26 00:00:00.000	341553	YY	2015-06-23 00:00:00	167655	 	NULL	NULL	NULL
72475	1	2015-06-23 09:16:00	n087	2015-06-23 00:00:00	N	P	15060270	GS15001572	27715	_	T	14523	n1125	WS11	AJ2	N	6100.00	6100.00	Y	2015-06-26 00:00:00.000	341554	YY	2015-06-23 00:00:00	167658	 	NULL	NULL	NULL
72476	1	2015-06-23 09:29:00	n087	2015-06-23 00:00:00	N	P	15060278	GS15001573	25765	_	T	13972	n100	WS2	AK2	N	4000.00	4000.00	Y	2015-06-26 00:00:00.000	341555	YE	2015-06-23 00:00:00	167659	 	NULL	NULL	NULL
72477	1	2015-06-23 00:00:00	n029	2015-06-24 00:00:00	N	T	15060211	GS00035052	66710	_	T	16077	n824	FE1	FE1	N	2400.00	2400.00	Y	2015-06-29 00:00:00.000	341631	YE	2015-06-24 00:00:00	122246	 	NULL	NULL	NULL
72478	1	2015-06-23 00:00:00	n029	2015-06-24 00:00:00	N	T	15060219	GS00035053	65876	_	T	13770	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-06-29 00:00:00.000	341632	YY	2015-06-24 00:00:00	122247	 	NULL	NULL	NULL
72479	1	2015-06-23 00:00:00	n029	2015-06-24 00:00:00	N	T	15060220	GS00035054	65877	_	T	13770	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-06-29 00:00:00.000	341633	YY	2015-06-24 00:00:00	122248	 	NULL	NULL	NULL
72480	1	2015-06-23 00:00:00	n029	2015-06-24 00:00:00	N	T	15060218	GS00035055	66018	_	T	13770	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-06-29 00:00:00.000	341634	YY	2015-06-24 00:00:00	122249	 	NULL	NULL	NULL
72481	1	2015-06-23 00:00:00	n029	2015-06-24 00:00:00	N	T	15060246	GS00035056	66035	_	T	12033	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-06-29 00:00:00.000	341635	YY	2015-06-24 00:00:00	122250	 	NULL	NULL	NULL
72482	1	2015-06-23 00:00:00	n029	2015-06-24 00:00:00	N	T	15060247	GS00035057	66036	_	T	12033	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-06-29 00:00:00.000	341636	YY	2015-06-24 00:00:00	122251	 	NULL	NULL	NULL
72483	1	2015-06-23 00:00:00	n029	2015-06-24 00:00:00	N	T	15060248	GS00035058	66037	_	T	12033	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-06-29 00:00:00.000	341637	YY	2015-06-24 00:00:00	122252	 	NULL	NULL	NULL
72484	1	2015-06-23 00:00:00	n029	2015-06-24 00:00:00	N	T	15060249	GS00035059	66038	_	T	12033	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-06-29 00:00:00.000	341638	YY	2015-06-24 00:00:00	122253	 	NULL	NULL	NULL
72485	1	2015-06-23 00:00:00	n029	2015-06-24 00:00:00	N	T	15060250	GS00035060	66039	_	T	12033	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-06-29 00:00:00.000	341639	YY	2015-06-24 00:00:00	122254	 	NULL	NULL	NULL
72486	1	2015-06-23 00:00:00	n029	2015-06-24 00:00:00	N	T	15060251	GS00035061	66040	_	T	12033	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-06-29 00:00:00.000	341640	YY	2015-06-24 00:00:00	122255	 	NULL	NULL	NULL
72487	1	2015-06-24 00:00:00	n029	2015-06-24 00:00:00	N	T	15060226	GS00035063	66711	_	T	15172	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-06-29 00:00:00.000	341641	YE	2015-06-24 00:00:00	122257	 	NULL	NULL	NULL
72488	1	2015-06-24 00:00:00	n029	2015-06-24 00:00:00	N	T	15060227	GS00035064	66712	_	T	15172	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-06-29 00:00:00.000	341642	YE	2015-06-24 00:00:00	122258	 	NULL	NULL	NULL
72489	1	2015-06-24 00:00:00	n029	2015-06-24 00:00:00	N	T	15060228	GS00035065	66713	_	T	15172	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-06-29 00:00:00.000	341643	YE	2015-06-24 00:00:00	122259	 	NULL	NULL	NULL
72490	1	2015-06-24 00:00:00	n029	2015-06-25 00:00:00	N	T	15060257	GS00035066	65793	_	T	7683	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-06-29 00:00:00.000	341653	YY	2015-06-25 00:00:00	122292	 	NULL	NULL	NULL
72491	1	2015-06-24 00:00:00	n029	2015-06-25 00:00:00	N	T	15060269	GS00035067	66065	_	T	14643	n1350	FF0	FF0	N	2500.00	2500.00	Y	2015-06-29 00:00:00.000	341654	YY	2015-06-25 00:00:00	122293	 	NULL	NULL	NULL
72492	1	2015-06-24 00:00:00	n029	2015-06-25 00:00:00	N	T	15060270	GS00035068	65490	_	T	15538	n1350	FF0	FF0	N	2500.00	2500.00	Y	2015-06-29 00:00:00.000	341655	YY	2015-06-25 00:00:00	122300	 	NULL	NULL	NULL
72493	1	2015-06-25 09:22:00	n319	2015-06-25 00:00:00	N	P	14030021	GS15001583	27525	_	T	15640	n896	IG1B	AA21	N	9700.00	9700.00	Y	2015-06-29 00:00:00.000	341644	YY	2015-06-25 00:00:00	167912	 	NULL	NULL	NULL
72494	1	2015-06-25 09:23:00	n319	2015-06-25 00:00:00	N	P	15060307	GS15001584	28274	_	T	12000	n1304	WA3	AN5	N	1000.00	1000.00	Y	2015-06-29 00:00:00.000	341645	YY	2015-06-25 00:00:00	167913	 	NULL	NULL	NULL
72495	1	2015-06-25 09:24:00	n319	2015-06-25 00:00:00	N	P	15060302	GS15001585	28346	_	T	12000	n1304	WA3	AN5	N	1000.00	1000.00	Y	2015-06-29 00:00:00.000	341646	YY	2015-06-25 00:00:00	167914	 	NULL	NULL	NULL
72496	1	2015-06-25 09:25:00	n319	2015-06-25 00:00:00	N	P	15060296	GS15001586	28454	_	T	12000	n1304	WA3	AN5	N	1000.00	1000.00	Y	2015-06-29 00:00:00.000	341647	YY	2015-06-25 00:00:00	167915	 	NULL	NULL	NULL
72497	1	2015-06-25 09:25:00	n319	2015-06-25 00:00:00	N	P	15060297	GS15001587	28454	_	T	12000	n1304	WA3	AN5	N	1000.00	1000.00	Y	2015-06-29 00:00:00.000	341648	YY	2015-06-25 00:00:00	167916	 	NULL	NULL	NULL
72498	1	2015-06-25 09:26:00	n319	2015-06-25 00:00:00	N	P	15060300	GS15001588	28481	_	T	12000	n1304	WA3	AN5	N	1000.00	1000.00	Y	2015-06-29 00:00:00.000	341649	YY	2015-06-25 00:00:00	167917	 	NULL	NULL	NULL
72499	1	2015-06-25 09:26:00	n319	2015-06-25 00:00:00	N	P	15060301	GS15001589	28481	_	T	12000	n1304	WA3	AN5	N	1000.00	1000.00	Y	2015-06-29 00:00:00.000	341650	YY	2015-06-25 00:00:00	167918	 	NULL	NULL	NULL
72500	1	2015-06-25 09:41:00	n319	2015-06-25 00:00:00	N	P	15060286	GS15001590	18491	_	T	12002	n896	WS2	AK2	N	48000.00	48000.00	Y	2015-06-29 00:00:00.000	341651	YE	2015-06-25 00:00:00	167919	 	NULL	NULL	NULL
72501	1	2015-06-25 09:43:00	n319	2015-06-25 00:00:00	N	P	15060323	GS15001591	25677	_	T	6567	n1304	WS21	AK3	N	2800.00	2800.00	Y	2015-06-29 00:00:00.000	341652	YY	2015-06-25 00:00:00	167920	 	NULL	NULL	NULL
72502	1	2015-06-25 00:00:00	n029	2015-06-26 00:00:00	N	T	15060271	GS00035077	65506	_	T	15754	n646	FF0	FF0	N	2500.00	2500.00	Y	2015-06-30 00:00:00.000	341848	YY	2015-06-26 00:00:00	122341	 	NULL	NULL	NULL
72503	1	2015-06-25 00:00:00	n029	2015-06-26 00:00:00	N	T	15060272	GS00035078	65535	_	T	3237	n646	FF0	FF0	N	2500.00	2500.00	Y	2015-06-30 00:00:00.000	341849	YY	2015-06-26 00:00:00	122343	 	NULL	NULL	NULL
72504	1	2015-06-25 16:31:00	n319	2015-06-26 00:00:00	N	P	15050128	GS15001592	25180	_	T	2853	n100	AAK	AK5	N	1000.00	1000.00	Y	2015-06-30 00:00:00.000	341836	YY	2015-06-26 00:00:00	168042	 	NULL	NULL	NULL
72505	1	2015-06-25 16:32:00	n319	2015-06-26 00:00:00	N	P	15060325	GS15001593	26719	_	T	12611	n650	WS1	AJ1	N	3500.00	3500.00	Y	2015-06-30 00:00:00.000	341837	YY	2015-06-26 00:00:00	168043	 	NULL	NULL	NULL
72506	1	2015-06-25 17:03:00	n319	2015-06-26 00:00:00	N	P	15060328	GS15001594	27723	_	T	13472	n1304	WA3	AN5	N	1000.00	1000.00	Y	2015-06-30 00:00:00.000	341838	YY	2015-06-26 00:00:00	168050	 	NULL	NULL	NULL
72507	1	2015-06-25 17:05:00	n319	2015-06-26 00:00:00	N	P	15040009	GS15001595	28453	_	T	13472	n1304	IG1B	AA21	N	9700.00	9700.00	Y	2015-06-30 00:00:00.000	341839	YY	2015-06-26 00:00:00	168051	 	NULL	NULL	NULL
72508	1	2015-06-26 00:00:00	n029	2015-06-26 00:00:00	N	T	15060276	GS00035079	65910	_	T	10763	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-06-30 00:00:00.000	341850	YY	2015-06-26 00:00:00	122386	 	NULL	NULL	NULL
72509	1	2015-06-26 00:00:00	n029	2015-06-26 00:00:00	N	T	15060277	GS00035080	65906	_	T	15800	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-06-30 00:00:00.000	341851	YY	2015-06-26 00:00:00	122387	 	NULL	NULL	NULL
72510	1	2015-06-26 00:00:00	n029	2015-06-26 00:00:00	N	T	15060278	GS00035081	65896	_	T	15863	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-06-30 00:00:00.000	341852	YY	2015-06-26 00:00:00	122388	 	NULL	NULL	NULL
72511	1	2015-06-26 00:00:00	n029	2015-06-26 00:00:00	N	T	15060282	GS00035082	52533	_	T	11878	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-06-30 00:00:00.000	341853	YY	2015-06-26 00:00:00	122389	 	NULL	NULL	NULL
72512	1	2015-06-26 00:00:00	n029	2015-06-26 00:00:00	N	T	15060273	GS00035083	66714	_	T	16081	n646	FE1	FE1	N	2400.00	2400.00	Y	2015-06-30 00:00:00.000	341854	YE	2015-06-26 00:00:00	122390	 	NULL	NULL	NULL
72513	1	2015-06-26 09:07:00	n319	2015-06-26 00:00:00	N	P	15060334	GS15001597	20899	_	T	13124	n1304	WS21	AK3	N	3800.00	3800.00	Y	2015-06-30 00:00:00.000	341840	YY	2015-06-26 00:00:00	168053	 	NULL	NULL	NULL
72514	1	2015-06-26 09:08:00	n319	2015-06-26 00:00:00	N	P	15060336	GS15001598	28500	_	T	12000	n1304	WA3	AN5	N	1000.00	1000.00	Y	2015-06-30 00:00:00.000	341841	YY	2015-06-26 00:00:00	168054	 	NULL	NULL	NULL
72515	1	2015-06-26 09:34:00	n319	2015-06-26 00:00:00	N	P	15060309	GS15001605	26872	_	T	15063	n1125	WS11	AJ2	N	2700.00	2700.00	Y	2015-06-30 00:00:00.000	341842	YY	2015-06-26 00:00:00	168061	 	NULL	NULL	NULL
72516	1	2015-06-26 09:38:00	n319	2015-06-26 00:00:00	N	P	15060327	GS15001606	28597	_	T	15857	n1125	FR1	AB1	N	300.00	300.00	Y	2015-06-30 00:00:00.000	341843	YY	2015-06-26 00:00:00	168062	 	NULL	NULL	NULL
72517	1	2015-06-26 09:41:00	n319	2015-06-26 00:00:00	N	P	15060324	GS15001607	28669	_	T	10747	n1065	UG1	AA3	N	3000.00	3000.00	Y	2015-06-30 00:00:00.000	341844	YY	2015-06-26 00:00:00	168063	 	NULL	NULL	NULL
72518	1	2015-06-26 09:43:00	n319	2015-06-26 00:00:00	N	P	15050263	GS15001608	28567	_	T	14510	n1125	IG1E	AA2	N	10500.00	12900.00	Y	2015-06-30 00:00:00.000	341845	YY	2015-06-26 00:00:00	168064	 	NULL	NULL	NULL
72519	1	2015-06-26 09:43:00	n319	2015-06-26 00:00:00	N	P	15060246	GS15001608	28567	_	T	14510	n1125	AC2	AA2	N	2400.00	12900.00	Y	2015-06-30 00:00:00.000	341846	YY	2015-06-26 00:00:00	168064	 	NULL	NULL	NULL
72520	1	2015-06-26 09:44:00	n319	2015-06-26 00:00:00	N	P	15050264	GS15001609	28568	_	T	14510	n1125	UG1	AA3	N	3000.00	3000.00	Y	2015-06-30 00:00:00.000	341847	YY	2015-06-26 00:00:00	168065	 	NULL	NULL	NULL
72521	1	2015-06-26 00:00:00	n029	2015-06-29 00:00:00	N	T	15060288	GS00035084	65929	_	T	15348	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-06-30 00:00:00.000	341860	YY	2015-06-29 00:00:00	122440	 	NULL	NULL	NULL
72522	1	2015-06-26 00:00:00	n029	2015-06-29 00:00:00	N	T	15060289	GS00035085	65930	_	T	15348	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-06-30 00:00:00.000	341861	YY	2015-06-29 00:00:00	122441	 	NULL	NULL	NULL
72523	1	2015-06-26 15:11:00	n319	2015-06-29 00:00:00	N	P	15060308	GS15001610	28456	_	T	16011	n1125	WA3	AN5	D	1000.00	1000.00	Y	2015-06-30 00:00:00.000	341857	YY	2015-06-29 00:00:00	168167	 	NULL	NULL	NULL
72524	1	2015-06-29 00:00:00	n029	2015-06-29 00:00:00	N	T	15060284	GS00035090	64798	_	T	15594	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-06-30 00:00:00.000	341862	YY	2015-06-29 00:00:00	122489	 	NULL	NULL	NULL
72525	1	2015-06-29 00:00:00	n029	2015-06-29 00:00:00	N	T	15060286	GS00035091	41920	_	T	7571	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-06-30 00:00:00.000	341863	YY	2015-06-29 00:00:00	122490	 	NULL	NULL	NULL
72526	1	2015-06-29 00:00:00	n029	2015-06-29 00:00:00	N	T	15060285	GS00035092	43781	_	T	7571	n441	FR1	FR1	N	4000.00	4000.00	Y	2015-06-30 00:00:00.000	341864	YY	2015-06-29 00:00:00	122491	 	NULL	NULL	NULL
72527	1	2015-06-29 08:49:00	n319	2015-06-29 00:00:00	N	P	15060310	GS15001613	28466	_	T	15895	n1125	WM1	AF1	N	300.00	300.00	Y	2015-06-30 00:00:00.000	341858	YY	2015-06-29 00:00:00	168182	 	NULL	NULL	NULL
72528	1	2015-06-29 08:52:00	n319	2015-06-29 00:00:00	N	P	15060311	GS15001615	28467	_	T	15895	n1125	WM1	AF1	N	300.00	300.00	Y	2015-06-30 00:00:00.000	341859	YY	2015-06-29 00:00:00	168184	 	NULL	NULL	NULL
72529	1	2015-06-29 15:15:00	n319	2015-06-30 00:00:00	N	P	15060349	GS15001621	28190	_	T	15890	n1304	WS11	AJ2	N	2700.00	2700.00	Y	2015-07-06 00:00:00.000	341951	YY	2015-06-30 00:00:00	168250	 	NULL	NULL	NULL
72530	1	2015-06-29 00:00:00	n029	2015-06-30 00:00:00	N	T	15060299	GS00035097	66028	_	T	6857	n428	FF0	FF0	N	2500.00	2500.00	Y	2015-07-06 00:00:00.000	341963	YY	2015-06-30 00:00:00	122565	 	NULL	NULL	NULL
72531	1	2015-06-29 00:00:00	n029	2015-06-30 00:00:00	N	T	15060300	GS00035098	65927	_	T	15348	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-07-06 00:00:00.000	341964	YY	2015-06-30 00:00:00	122566	 	NULL	NULL	NULL
72532	1	2015-06-29 00:00:00	n029	2015-06-30 00:00:00	N	T	15060301	GS00035099	65928	_	T	15348	n530	FF0	FF0	N	2500.00	2500.00	Y	2015-07-06 00:00:00.000	341965	YY	2015-06-30 00:00:00	122567	 	NULL	NULL	NULL
72533	1	2015-06-29 00:00:00	n029	2015-06-30 00:00:00	N	T	15060296	GS00035100	66020	_	T	5045	n646	FF0	FF0	N	5000.00	5000.00	Y	2015-07-06 00:00:00.000	341966	YY	2015-06-30 00:00:00	122568	 	NULL	NULL	NULL
72534	1	2015-06-30 08:44:00	n319	2015-06-30 00:00:00	N	P	14080215	GS15001623	27929	_	T	2853	n100	IG1E	AA2	N	10500.00	10500.00	Y	2015-07-06 00:00:00.000	341952	YY	2015-06-30 00:00:00	168284	 	NULL	NULL	NULL
72535	1	2015-06-30 08:46:00	n319	2015-06-30 00:00:00	N	P	15010227	GS15001624	28314	_	T	15877	n994	IG1B	AA21	N	9700.00	9700.00	Y	2015-07-06 00:00:00.000	341953	YY	2015-06-30 00:00:00	168285	 	NULL	NULL	NULL
72536	1	2015-06-30 08:53:00	n319	2015-06-30 00:00:00	N	P	15030167	GS15001626	28407	_	T	13472	n1304	IG1B	AA21	N	9700.00	9700.00	Y	2015-07-06 00:00:00.000	341954	YY	2015-06-30 00:00:00	168287	 	NULL	NULL	NULL
72537	1	2015-06-30 08:57:00	n319	2015-06-30 00:00:00	N	P	15040153	GS15001628	28482	_	T	15804	n1065	IG1E	AA2	N	10500.00	10500.00	Y	2015-07-06 00:00:00.000	341955	YY	2015-06-30 00:00:00	168289	 	NULL	NULL	NULL
72538	1	2015-06-30 08:59:00	n319	2015-06-30 00:00:00	N	P	15040195	GS15001629	28492	_	T	15804	n1065	UG1	AA3	N	3000.00	3000.00	Y	2015-07-06 00:00:00.000	341956	YY	2015-06-30 00:00:00	168291	 	NULL	NULL	NULL
72539	1	2015-06-30 09:42:00	n319	2015-06-30 00:00:00	N	P	15060347	GS15001630	25764	_	T	13712	n896	WS2	AK2	N	4000.00	4000.00	Y	2015-07-06 00:00:00.000	341957	YE	2015-06-30 00:00:00	168292	 	NULL	NULL	NULL
72540	1	2015-06-30 15:19:00	n319	2015-06-30 00:00:00	N	P	15060316	GS15001631	28664	_	T	14510	n1125	DG1	AA4	N	3000.00	3000.00	Y	2015-07-06 00:00:00.000	341958	YY	2015-06-30 00:00:00	168351	 	NULL	NULL	NULL
72541	1	2015-06-30 15:20:00	n319	2015-06-30 00:00:00	N	P	15060318	GS15001632	28666	_	T	14510	n1125	DG1	AA4	N	3000.00	3000.00	Y	2015-07-06 00:00:00.000	341959	YY	2015-06-30 00:00:00	168352	 	NULL	NULL	NULL
72542	1	2015-06-30 15:22:00	n319	2015-06-30 00:00:00	N	P	15060319	GS15001633	28667	_	T	14510	n1125	DG1	AA4	N	3000.00	3000.00	Y	2015-07-06 00:00:00.000	341960	YY	2015-06-30 00:00:00	168353	 	NULL	NULL	NULL
72543	1	2015-06-30 15:22:00	n319	2015-06-30 00:00:00	N	P	15060317	GS15001634	28665	_	T	14510	n1125	DG1	AA4	N	3000.00	3000.00	Y	2015-07-06 00:00:00.000	341961	YY	2015-06-30 00:00:00	168354	 	NULL	NULL	NULL
72544	1	2015-06-30 15:23:00	n319	2015-06-30 00:00:00	N	P	15060320	GS15001635	28668	_	T	14510	n1125	DG1	AA4	N	3000.00	3000.00	Y	2015-07-06 00:00:00.000	341962	YY	2015-06-30 00:00:00	168355	 	NULL	NULL	NULL
72545	1	2015-06-30 00:00:00	n029	2015-07-01 00:00:00	N	T	15060304	GS00035101	66717	_	T	14366	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-07-06 00:00:00.000	341981	YE	2015-07-01 00:00:00	122706	 	NULL	NULL	NULL
72546	1	2015-06-30 00:00:00	n029	2015-07-01 00:00:00	N	T	15060305	GS00035102	66718	_	T	14366	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-07-06 00:00:00.000	341982	YE	2015-07-01 00:00:00	122707	 	NULL	NULL	NULL
72547	1	2015-06-30 00:00:00	n029	2015-07-01 00:00:00	N	T	15060306	GS00035103	66719	_	T	14366	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-07-06 00:00:00.000	341983	YE	2015-07-01 00:00:00	122708	 	NULL	NULL	NULL
72548	1	2015-06-30 00:00:00	n029	2015-07-01 00:00:00	N	T	15060307	GS00035104	66720	_	T	14366	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-07-06 00:00:00.000	341984	YE	2015-07-01 00:00:00	122709	 	NULL	NULL	NULL
72549	1	2015-06-30 00:00:00	n029	2015-07-01 00:00:00	N	T	15060308	GS00035105	66721	_	T	14366	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-07-06 00:00:00.000	341985	YE	2015-07-01 00:00:00	122710	 	NULL	NULL	NULL
72550	1	2015-06-30 00:00:00	n029	2015-07-01 00:00:00	N	T	15060309	GS00035106	66722	_	T	14366	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-07-06 00:00:00.000	341986	YE	2015-07-01 00:00:00	122711	 	NULL	NULL	NULL
72551	1	2015-06-30 00:00:00	n029	2015-07-01 00:00:00	N	T	15060310	GS00035107	66723	_	T	14366	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-07-06 00:00:00.000	341987	YE	2015-07-01 00:00:00	122712	 	NULL	NULL	NULL
72552	1	2015-06-30 00:00:00	n029	2015-07-01 00:00:00	N	T	15060311	GS00035108	66724	_	T	14366	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-07-06 00:00:00.000	341988	YE	2015-07-01 00:00:00	122713	 	NULL	NULL	NULL
72553	1	2015-06-30 00:00:00	n029	2015-07-01 00:00:00	N	T	15060312	GS00035109	66725	_	T	14366	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-07-06 00:00:00.000	341989	YE	2015-07-01 00:00:00	122714	 	NULL	NULL	NULL
72554	1	2015-06-30 16:04:00	n319	2015-07-01 00:00:00	N	P	15030294	GS15001636	28440	_	T	12406	n650	IG1B	AA21	N	9700.00	9700.00	Y	2015-07-06 00:00:00.000	341967	YY	2015-07-01 00:00:00	168363	 	NULL	NULL	NULL
72555	1	2015-06-30 00:00:00	n029	2015-07-01 00:00:00	N	T	15060313	GS00035110	66726	_	T	14366	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-07-06 00:00:00.000	341990	YE	2015-07-01 00:00:00	122718	 	NULL	NULL	NULL
72556	1	2015-06-30 00:00:00	n029	2015-07-01 00:00:00	N	T	15060314	GS00035111	66727	_	T	14366	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-07-06 00:00:00.000	341991	YE	2015-07-01 00:00:00	122719	 	NULL	NULL	NULL
72557	1	2015-06-30 00:00:00	n029	2015-07-01 00:00:00	N	T	15060315	GS00035112	66728	_	T	14366	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-07-06 00:00:00.000	341992	YE	2015-07-01 00:00:00	122720	 	NULL	NULL	NULL
72558	1	2015-06-30 00:00:00	n029	2015-07-01 00:00:00	N	T	15060316	GS00035113	66729	_	T	14366	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-07-06 00:00:00.000	341993	YE	2015-07-01 00:00:00	122721	 	NULL	NULL	NULL
72559	1	2015-06-30 00:00:00	n029	2015-07-01 00:00:00	N	T	15060317	GS00035114	66730	_	T	14366	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-07-06 00:00:00.000	341994	YE	2015-07-01 00:00:00	122722	 	NULL	NULL	NULL
72560	1	2015-06-30 00:00:00	n029	2015-07-01 00:00:00	N	T	15060318	GS00035115	66731	_	T	14366	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-07-06 00:00:00.000	341995	YE	2015-07-01 00:00:00	122723	 	NULL	NULL	NULL
72561	1	2015-06-30 00:00:00	n029	2015-07-01 00:00:00	N	T	15060319	GS00035116	66732	_	T	14366	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-07-06 00:00:00.000	341996	YE	2015-07-01 00:00:00	122724	 	NULL	NULL	NULL
72562	1	2015-06-30 00:00:00	n029	2015-07-01 00:00:00	N	T	15060331	GS00035120	66733	_	T	15200	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-07-06 00:00:00.000	341997	YY	2015-07-01 00:00:00	122728	 	NULL	NULL	NULL
72563	1	2015-06-30 00:00:00	n029	2015-07-01 00:00:00	N	T	15060340	GS00035121	55961	_	T	13505	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-07-06 00:00:00.000	341998	YY	2015-07-01 00:00:00	122729	 	NULL	NULL	NULL
72564	1	2015-06-30 00:00:00	n029	2015-07-01 00:00:00	N	T	15010283	GS00035122	66100	_	T	13321	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-07-06 00:00:00.000	341999	YY	2015-07-01 00:00:00	122730	 	NULL	NULL	NULL
72565	1	2015-06-30 00:00:00	n029	2015-07-01 00:00:00	N	T	15060302	GS00035123	66715	_	T	15256	n428	FR2	FR2	N	8000.00	8000.00	Y	2015-07-06 00:00:00.000	342000	YY	2015-07-01 00:00:00	122731	 	NULL	NULL	NULL
72566	1	2015-06-30 00:00:00	n029	2015-07-01 00:00:00	N	T	15060303	GS00035124	66716	_	T	15256	n428	FR2	FR2	N	8000.00	8000.00	Y	2015-07-06 00:00:00.000	342001	YY	2015-07-01 00:00:00	122732	 	NULL	NULL	NULL
72567	1	2015-07-01 08:58:00	n319	2015-07-01 00:00:00	N	P	15060273	GS15001641	27647	_	T	15415	n1125	LM3	AN2	N	7400.00	7400.00	Y	2015-07-06 00:00:00.000	341968	YY	2015-07-01 00:00:00	168373	 	NULL	NULL	NULL
72568	1	2015-07-01 08:58:00	n319	2015-07-01 00:00:00	N	P	15060274	GS15001642	27648	_	T	15415	n1125	LM3	AN2	N	6800.00	6800.00	Y	2015-07-06 00:00:00.000	341969	YY	2015-07-01 00:00:00	168374	 	NULL	NULL	NULL
72569	1	2015-07-01 09:02:00	n319	2015-07-01 00:00:00	N	P	15040113	GS15001644	28474	_	T	15895	n1125	IG1E	AA2	N	10500.00	10500.00	Y	2015-07-06 00:00:00.000	341970	YY	2015-07-01 00:00:00	168376	 	NULL	NULL	NULL
72570	1	2015-07-01 09:03:00	n319	2015-07-01 00:00:00	N	P	15040114	GS15001645	28475	_	T	15895	n1125	UG1	AA3	N	3000.00	3000.00	Y	2015-07-06 00:00:00.000	341971	YY	2015-07-01 00:00:00	168377	 	NULL	NULL	NULL
72571	1	2015-07-01 09:08:00	n319	2015-07-01 00:00:00	N	P	15060031	GS15001647	28592	_	T	15945	n1125	WM1	AP2	N	300.00	300.00	Y	2015-07-06 00:00:00.000	341972	YY	2015-07-01 00:00:00	168379	 	NULL	NULL	NULL
72572	1	2015-07-01 09:09:00	n319	2015-07-01 00:00:00	N	P	15060032	GS15001648	28592	_	T	15945	n1125	WA3	AN5	D	1000.00	4000.00	Y	2015-07-06 00:00:00.000	341973	YY	2015-07-01 00:00:00	168380	 	NULL	NULL	NULL
72573	1	2015-07-01 09:09:00	n319	2015-07-01 00:00:00	N	P	15060271	GS15001648	28592	_	T	15945	n1125	WA3	AN5	D	3000.00	4000.00	Y	2015-07-06 00:00:00.000	341974	YY	2015-07-01 00:00:00	168380	 	NULL	NULL	NULL
72574	1	2015-07-01 09:10:00	n319	2015-07-01 00:00:00	N	P	15060034	GS15001649	28593	_	T	15945	n1125	WM1	AP2	N	300.00	300.00	Y	2015-07-06 00:00:00.000	341975	YY	2015-07-01 00:00:00	168381	 	NULL	NULL	NULL
72575	1	2015-07-01 09:11:00	n319	2015-07-01 00:00:00	N	P	15060033	GS15001650	28593	_	T	15945	n1125	WA3	AN5	D	1000.00	4000.00	Y	2015-07-06 00:00:00.000	341976	YY	2015-07-01 00:00:00	168382	 	NULL	NULL	NULL
72576	1	2015-07-01 09:11:00	n319	2015-07-01 00:00:00	N	P	15060272	GS15001650	28593	_	T	15945	n1125	WA3	AN5	D	3000.00	4000.00	Y	2015-07-06 00:00:00.000	341977	YY	2015-07-01 00:00:00	168382	 	NULL	NULL	NULL
72577	1	2015-07-01 09:13:00	n319	2015-07-01 00:00:00	N	P	15060212	GS15001651	28645	_	T	15748	n1125	DG1	AA4	N	3000.00	3000.00	Y	2015-07-06 00:00:00.000	341978	YY	2015-07-01 00:00:00	168383	 	NULL	NULL	NULL
72578	1	2015-07-01 09:42:00	n319	2015-07-01 00:00:00	N	P	15060117	GS15001652	25992	_	T	11959	n1065	FR1	AB1	N	11800.00	16600.00	Y	2015-07-06 00:00:00.000	341979	YY	2015-07-01 00:00:00	168389	 	NULL	NULL	NULL
72579	1	2015-07-01 09:42:00	n319	2015-07-01 00:00:00	N	P	15070001	GS15001652	25992	_	T	11959	n1065	FR12	AB1	N	4800.00	16600.00	Y	2015-07-06 00:00:00.000	341980	YY	2015-07-01 00:00:00	168389	 	NULL	NULL	NULL
72580	1	2015-07-01 00:00:00	n029	2015-07-02 00:00:00	N	T	15060354	GS00035125	66735	_	T	15492	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-07-06 00:00:00.000	342005	YE	2015-07-02 00:00:00	122777	 	NULL	NULL	NULL
72581	1	2015-07-01 00:00:00	n029	2015-07-02 00:00:00	N	T	15070002	GS00035126	65571	_	T	14956	n1350	FF0	FF0	N	2500.00	2500.00	Y	2015-07-06 00:00:00.000	342006	YY	2015-07-02 00:00:00	122778	 	NULL	NULL	NULL
72582	1	2015-07-01 00:00:00	n029	2015-07-02 00:00:00	N	T	15070003	GS00035127	65572	_	T	14956	n1350	FF0	FF0	N	2500.00	2500.00	Y	2015-07-06 00:00:00.000	342007	YY	2015-07-02 00:00:00	122779	 	NULL	NULL	NULL
72583	1	2015-07-01 00:00:00	n029	2015-07-02 00:00:00	N	T	15060346	GS00035128	55369	_	T	7813	n1350	FR1	FR1	N	4000.00	4000.00	Y	2015-07-06 00:00:00.000	342008	YY	2015-07-02 00:00:00	122780	 	NULL	NULL	NULL
72584	1	2015-07-01 00:00:00	n029	2015-07-02 00:00:00	N	T	15060347	GS00035129	53284	_	T	7813	n1350	FR1	FR1	N	4000.00	4000.00	Y	2015-07-06 00:00:00.000	342009	YY	2015-07-02 00:00:00	122781	 	NULL	NULL	NULL
72585	1	2015-07-01 00:00:00	n029	2015-07-02 00:00:00	N	T	15060348	GS00035130	53283	_	T	7813	n1350	FR1	FR1	N	4000.00	4000.00	Y	2015-07-06 00:00:00.000	342010	YY	2015-07-02 00:00:00	122782	 	NULL	NULL	NULL
72586	1	2015-07-01 00:00:00	n029	2015-07-02 00:00:00	N	T	15060328	GS00035131	61587	_	T	14965	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-07-06 00:00:00.000	342011	YY	2015-07-02 00:00:00	122783	 	NULL	NULL	NULL
72587	1	2015-07-01 00:00:00	n029	2015-07-02 00:00:00	N	T	15060329	GS00035132	61586	_	T	14965	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-07-06 00:00:00.000	342012	YY	2015-07-02 00:00:00	122784	 	NULL	NULL	NULL
72588	1	2015-07-01 00:00:00	n029	2015-07-02 00:00:00	N	T	15060330	GS00035133	61585	_	T	14965	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-07-06 00:00:00.000	342013	YY	2015-07-02 00:00:00	122785	 	NULL	NULL	NULL
72589	1	2015-07-01 00:00:00	n029	2015-07-02 00:00:00	N	T	15060332	GS00035134	38410	_	T	6986	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-07-06 00:00:00.000	342014	YY	2015-07-02 00:00:00	122786	 	NULL	NULL	NULL
72590	1	2015-07-01 00:00:00	n029	2015-07-02 00:00:00	N	T	15060333	GS00035135	53507	_	T	6986	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-07-06 00:00:00.000	342015	YY	2015-07-02 00:00:00	122787	 	NULL	NULL	NULL
72591	1	2015-07-01 00:00:00	n029	2015-07-02 00:00:00	N	T	15060334	GS00035136	38409	_	T	6986	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-07-06 00:00:00.000	342016	YY	2015-07-02 00:00:00	122788	 	NULL	NULL	NULL
72592	1	2015-07-01 00:00:00	n029	2015-07-02 00:00:00	N	T	15060335	GS00035137	52992	_	T	7276	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-07-06 00:00:00.000	342017	YY	2015-07-02 00:00:00	122789	 	NULL	NULL	NULL
72593	1	2015-07-01 00:00:00	n029	2015-07-02 00:00:00	N	T	15060336	GS00035138	52991	_	T	7276	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-07-06 00:00:00.000	342018	YY	2015-07-02 00:00:00	122790	 	NULL	NULL	NULL
72594	1	2015-07-01 00:00:00	n029	2015-07-02 00:00:00	N	T	15060337	GS00035139	40121	_	T	7276	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-07-06 00:00:00.000	342019	YY	2015-07-02 00:00:00	122791	 	NULL	NULL	NULL
72595	1	2015-07-01 00:00:00	n029	2015-07-02 00:00:00	N	T	15060338	GS00035140	40123	_	T	7276	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-07-06 00:00:00.000	342020	YY	2015-07-02 00:00:00	122792	 	NULL	NULL	NULL
72596	1	2015-07-01 00:00:00	n029	2015-07-02 00:00:00	N	T	15060339	GS00035141	40122	_	T	7276	n428	FR1	FR1	N	4000.00	4000.00	Y	2015-07-06 00:00:00.000	342021	YY	2015-07-02 00:00:00	122793	 	NULL	NULL	NULL
72597	1	2015-07-02 00:00:00	n029	2015-07-02 00:00:00	N	T	15060353	GS00035142	66734	_	T	4347	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-07-06 00:00:00.000	342022	YE	2015-07-02 00:00:00	122794	 	NULL	NULL	NULL
72598	1	2015-07-02 08:45:00	n319	2015-07-02 00:00:00	N	P	15070018	GS15001657	26867	_	T	11997	n1486	WS11	AJ2	N	6100.00	6100.00	Y	2015-07-06 00:00:00.000	342002	YY	2015-07-02 00:00:00	168504	 	NULL	NULL	NULL
72599	1	2015-07-02 08:49:00	n319	2015-07-02 00:00:00	N	P	15070004	GS15001659	28347	_	T	14374	n1304	WS11	AJ2	N	6100.00	6100.00	Y	2015-07-06 00:00:00.000	342003	YY	2015-07-02 00:00:00	168506	 	NULL	NULL	NULL
72600	1	2015-07-02 09:31:00	n319	2015-07-02 00:00:00	N	P	15070008	GS15001661	28404	_	T	15944	n1125	WS11	AJ2	N	6100.00	6100.00	Y	2015-07-06 00:00:00.000	342004	YY	2015-07-02 00:00:00	168509	 	NULL	NULL	NULL
72601	1	2015-07-02 15:09:00	n319	2015-07-03 00:00:00	N	P	15070029	GS15001664	21768	_	T	12556	n1489	WS21	AK3	N	11400.00	11400.00	Y	2015-07-09 00:00:00.000	342044	YY	2015-07-03 00:00:00	168589	 	NULL	NULL	NULL
72602	1	2015-07-02 15:10:00	n319	2015-07-03 00:00:00	N	P	15070030	GS15001665	21770	_	T	12556	n1489	WS21	AK3	N	11400.00	11400.00	Y	2015-07-09 00:00:00.000	342045	YY	2015-07-03 00:00:00	168590	 	NULL	NULL	NULL
72603	1	2015-07-02 15:16:00	n319	2015-07-03 00:00:00	N	P	15070035	GS15001668	28328	_	T	15924	n896	WS11	AJ2	N	6100.00	6100.00	Y	2015-07-09 00:00:00.000	342046	YY	2015-07-03 00:00:00	168595	 	NULL	NULL	NULL
72604	1	2015-07-02 15:18:00	n319	2015-07-03 00:00:00	N	P	15050219	GS15001669	28557	_	T	13319	n896	UG1	AA3	N	3000.00	3000.00	Y	2015-07-09 00:00:00.000	342047	YY	2015-07-03 00:00:00	168597	 	NULL	NULL	NULL
72605	1	2015-07-02 00:00:00	n029	2015-07-03 00:00:00	N	T	15070021	GS00035143	66736	_	T	11882	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-07-09 00:00:00.000	342059	YE	2015-07-03 00:00:00	122863	 	NULL	NULL	NULL
72606	1	2015-07-02 00:00:00	n029	2015-07-03 00:00:00	N	T	15070004	GS00035146	62761	_	T	4411	n646	FR1	FR1	N	4000.00	4000.00	Y	2015-07-09 00:00:00.000	342060	YY	2015-07-03 00:00:00	122866	 	NULL	NULL	NULL
72607	1	2015-07-02 00:00:00	n029	2015-07-03 00:00:00	N	T	15060355	GS00035147	65661	_	T	14703	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-07-09 00:00:00.000	342061	YY	2015-07-03 00:00:00	122867	 	NULL	NULL	NULL
72608	1	2015-07-02 00:00:00	n029	2015-07-03 00:00:00	N	T	15070005	GS00035148	56964	_	T	13100	n646	FR1	FR1	N	4000.00	4000.00	Y	2015-07-09 00:00:00.000	342062	YY	2015-07-03 00:00:00	122868	 	NULL	NULL	NULL
72609	1	2015-07-02 00:00:00	n029	2015-07-03 00:00:00	N	T	15070022	GS00035149	53120	_	T	7758	n646	FR1	FR1	N	4000.00	4000.00	Y	2015-07-09 00:00:00.000	342063	YY	2015-07-03 00:00:00	122869	 	NULL	NULL	NULL
72610	1	2015-07-02 00:00:00	n029	2015-07-03 00:00:00	N	T	15070007	GS00035150	53203	_	T	4547	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-07-09 00:00:00.000	342064	YY	2015-07-03 00:00:00	122875	 	NULL	NULL	NULL
72611	1	2015-07-02 00:00:00	n029	2015-07-03 00:00:00	N	T	15070008	GS00035151	53204	_	T	4547	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-07-09 00:00:00.000	342065	YY	2015-07-03 00:00:00	122876	 	NULL	NULL	NULL
72612	1	2015-07-02 16:02:00	n319	2015-07-03 00:00:00	N	P	15070033	GS15001670	24307	_	T	13042	n650	WS11	AJ2	N	6100.00	6100.00	Y	2015-07-09 00:00:00.000	342048	YY	2015-07-03 00:00:00	168604	 	NULL	NULL	NULL
72613	1	2015-07-02 16:27:00	n319	2015-07-03 00:00:00	N	P	15070003	GS15001671	27664	_	T	4436	n113	WA3	AN5	D	1000.00	1000.00	Y	2015-07-09 00:00:00.000	342049	YY	2015-07-03 00:00:00	168605	 	NULL	NULL	NULL
72614	1	2015-07-02 16:28:00	n319	2015-07-03 00:00:00	N	P	15070021	GS15001672	28448	_	T	15172	n1304	WS11	AJ2	N	6100.00	6100.00	Y	2015-07-09 00:00:00.000	342050	YY	2015-07-03 00:00:00	168606	 	NULL	NULL	NULL
72615	1	2015-07-02 00:00:00	n029	2015-07-03 00:00:00	N	T	15060356	GS00035152	66738	_	T	16079	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-07-09 00:00:00.000	342066	YE	2015-07-03 00:00:00	122881	 	NULL	NULL	NULL
72616	1	2015-07-02 00:00:00	n029	2015-07-03 00:00:00	N	T	15060360	GS00035153	66741	_	T	16079	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-07-09 00:00:00.000	342067	YE	2015-07-03 00:00:00	122882	 	NULL	NULL	NULL
72617	1	2015-07-02 00:00:00	n029	2015-07-03 00:00:00	N	T	15060358	GS00035154	66739	_	T	16079	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-07-09 00:00:00.000	342068	YE	2015-07-03 00:00:00	122883	 	NULL	NULL	NULL
72618	1	2015-07-02 00:00:00	n029	2015-07-03 00:00:00	N	T	15060359	GS00035155	66740	_	T	16079	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-07-09 00:00:00.000	342069	YE	2015-07-03 00:00:00	122884	 	NULL	NULL	NULL
72619	1	2015-07-02 16:57:00	n319	2015-07-03 00:00:00	N	P	15040179	GS15001673	28489	_	T	8818	n896	IG1E	AA2	N	10500.00	13700.00	Y	2015-07-09 00:00:00.000	342051	YY	2015-07-03 00:00:00	168608	 	NULL	NULL	NULL
72620	1	2015-07-02 16:57:00	n319	2015-07-03 00:00:00	N	P	15070036	GS15001673	28489	_	T	8818	n896	AC2	AA2	N	3200.00	13700.00	Y	2015-07-09 00:00:00.000	342052	YY	2015-07-03 00:00:00	168608	 	NULL	NULL	NULL
72621	1	2015-07-02 16:59:00	n319	2015-07-03 00:00:00	N	P	15040180	GS15001674	28490	_	T	8818	n896	UG1	AA3	N	3000.00	3000.00	Y	2015-07-09 00:00:00.000	342053	YY	2015-07-03 00:00:00	168609	 	NULL	NULL	NULL
72622	1	2015-07-02 00:00:00	n029	2015-07-03 00:00:00	N	T	15060357	GS00035156	66737	_	T	16079	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-07-09 00:00:00.000	342070	YE	2015-07-03 00:00:00	122885	 	NULL	NULL	NULL
72623	1	2015-07-03 00:00:00	n029	2015-07-03 00:00:00	N	T	15070024	GS00035157	66742	_	T	14101	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-07-09 00:00:00.000	342071	YE	2015-07-03 00:00:00	122886	 	NULL	NULL	NULL
72624	1	2015-07-03 00:00:00	n029	2015-07-03 00:00:00	N	T	15070027	GS00035158	66745	_	T	14101	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-07-09 00:00:00.000	342072	YE	2015-07-03 00:00:00	122887	 	NULL	NULL	NULL
72625	1	2015-07-03 00:00:00	n029	2015-07-03 00:00:00	N	T	15070028	GS00035159	66746	_	T	14101	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-07-09 00:00:00.000	342073	YE	2015-07-03 00:00:00	122888	 	NULL	NULL	NULL
72626	1	2015-07-03 00:00:00	n029	2015-07-03 00:00:00	N	T	15070029	GS00035160	66747	_	T	14101	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-07-09 00:00:00.000	342074	YE	2015-07-03 00:00:00	122889	 	NULL	NULL	NULL
72627	1	2015-07-03 00:00:00	n029	2015-07-03 00:00:00	N	T	15070025	GS00035161	66743	_	T	14101	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-07-09 00:00:00.000	342075	YE	2015-07-03 00:00:00	122890	 	NULL	NULL	NULL
72628	1	2015-07-03 00:00:00	n029	2015-07-03 00:00:00	N	T	15070026	GS00035162	66744	_	T	14101	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-07-09 00:00:00.000	342076	YE	2015-07-03 00:00:00	122893	 	NULL	NULL	NULL
72629	1	2015-07-03 08:50:00	n319	2015-07-03 00:00:00	N	P	15060367	GS15001676	23603	_	T	14338	n113	WS21	AK3	N	2800.00	2800.00	Y	2015-07-09 00:00:00.000	342054	YY	2015-07-03 00:00:00	168611	 	NULL	NULL	NULL
72630	1	2015-07-03 09:11:00	n319	2015-07-03 00:00:00	N	P	15070016	GS15001677	25876	_	T	437	n1065	WS21	AK3	N	8400.00	8400.00	Y	2015-07-09 00:00:00.000	342055	YY	2015-07-03 00:00:00	168612	 	NULL	NULL	NULL
72631	1	2015-07-03 09:26:00	n319	2015-07-03 00:00:00	N	P	15060191	GS15001678	25856	_	T	15023	n1125	WM62	AG12	N	1000.00	1000.00	Y	2015-07-09 00:00:00.000	342056	YY	2015-07-03 00:00:00	168613	 	NULL	NULL	NULL
72632	1	2015-07-03 13:43:00	n319	2015-07-03 00:00:00	N	P	15070049	GS15001679	27116	_	T	15512	n1065	AC2	AAD	N	800.00	800.00	Y	2015-07-09 00:00:00.000	342057	YY	2015-07-03 00:00:00	168682	 	NULL	NULL	NULL
72633	1	2015-07-03 13:49:00	n319	2015-07-03 00:00:00	N	P	15050268	GS15001680	28563	_	T	16094	n1125	UG1	AA3	N	3000.00	3000.00	Y	2015-07-09 00:00:00.000	342058	YY	2015-07-03 00:00:00	168686	 	NULL	NULL	NULL
72634	1	2015-07-03 00:00:00	n029	2015-07-06 00:00:00	N	T	15070069	GS00035163	65945	_	T	14032	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-07-09 00:00:00.000	342082	YY	2015-07-06 00:00:00	122944	 	NULL	NULL	NULL
72635	1	2015-07-03 00:00:00	n029	2015-07-06 00:00:00	N	T	15070070	GS00035164	65946	_	T	14032	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-07-09 00:00:00.000	342083	YY	2015-07-06 00:00:00	122949	 	NULL	NULL	NULL
72636	1	2015-07-03 00:00:00	n029	2015-07-06 00:00:00	N	T	15070071	GS00035165	65947	_	T	14032	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-07-09 00:00:00.000	342084	YY	2015-07-06 00:00:00	122950	 	NULL	NULL	NULL
72637	1	2015-07-03 00:00:00	n029	2015-07-06 00:00:00	N	T	15070052	GS00035166	65725	_	T	15813	n1384	FF0	FF0	N	2500.00	2500.00	Y	2015-07-09 00:00:00.000	342085	YY	2015-07-06 00:00:00	122951	 	NULL	NULL	NULL
72638	1	2015-07-03 00:00:00	n029	2015-07-06 00:00:00	N	T	15070051	GS00035167	66022	_	T	13030	n646	FF0	FF0	N	2500.00	2500.00	Y	2015-07-09 00:00:00.000	342086	YY	2015-07-06 00:00:00	122952	 	NULL	NULL	NULL
72639	1	2015-07-03 00:00:00	n029	2015-07-06 00:00:00	N	T	15070040	GS00035168	65829	_	T	15846	n1350	FF0	FF0	N	2500.00	2500.00	Y	2015-07-09 00:00:00.000	342087	YY	2015-07-06 00:00:00	122953	 	NULL	NULL	NULL
72640	1	2015-07-03 00:00:00	n029	2015-07-06 00:00:00	N	T	15070061	GS00035169	66023	_	T	12033	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-07-09 00:00:00.000	342088	YY	2015-07-06 00:00:00	122954	 	NULL	NULL	NULL
72641	1	2015-07-03 00:00:00	n029	2015-07-06 00:00:00	N	T	15070062	GS00035170	66024	_	T	12033	n441	FF0	FF0	N	2500.00	2500.00	Y	2015-07-09 00:00:00.000	342089	YY	2015-07-06 00:00:00	122955	 	NULL	NULL	NULL
72642	1	2015-07-03 00:00:00	n029	2015-07-06 00:00:00	N	T	15070060	GS00035171	66751	_	T	15772	n646	FE11	FE11	N	2700.00	2700.00	Y	2015-07-09 00:00:00.000	342090	YE	2015-07-06 00:00:00	122970	 	NULL	NULL	NULL
72643	1	2015-07-03 00:00:00	n029	2015-07-06 00:00:00	N	T	15070035	GS00035172	66752	_	T	16090	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-07-09 00:00:00.000	342091	YE	2015-07-06 00:00:00	122982	 	NULL	NULL	NULL
72644	1	2015-07-03 00:00:00	n029	2015-07-06 00:00:00	N	T	15070036	GS00035173	66753	_	T	16090	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-07-09 00:00:00.000	342092	YE	2015-07-06 00:00:00	122983	 	NULL	NULL	NULL
72645	1	2015-07-03 00:00:00	n029	2015-07-06 00:00:00	N	T	15070037	GS00035174	66754	_	T	16090	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-07-09 00:00:00.000	342093	YE	2015-07-06 00:00:00	122984	 	NULL	NULL	NULL
72646	1	2015-07-03 00:00:00	n029	2015-07-06 00:00:00	N	T	15070038	GS00035175	66755	_	T	16090	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-07-09 00:00:00.000	342094	YE	2015-07-06 00:00:00	122985	 	NULL	NULL	NULL
72647	1	2015-07-03 00:00:00	n029	2015-07-06 00:00:00	N	T	15070039	GS00035176	66756	_	T	16090	n1350	FE1	FE1	N	2400.00	2400.00	Y	2015-07-09 00:00:00.000	342095	YE	2015-07-06 00:00:00	122986	 	NULL	NULL	NULL
72648	1	2015-07-03 17:33:00	n319	2015-07-06 00:00:00	N	P	15060093	GS15001683	28632	_	T	3324	n1304	UG1	AA3	N	3000.00	3000.00	Y	2015-07-09 00:00:00.000	342077	YY	2015-07-06 00:00:00	168747	 	NULL	NULL	NULL
72649	1	2015-07-06 08:37:00	n087	2015-07-06 00:00:00	N	P	15050340	GS15001684	28585	_	T	16054	n1125	IG1E	AA2	N	10500.00	10500.00	Y	2015-07-09 00:00:00.000	342078	YY	2015-07-06 00:00:00	168749	 	NULL	NULL	NULL
72650	1	2015-07-06 08:40:00	n087	2015-07-06 00:00:00	N	P	15050341	GS15001685	28586	_	T	16054	n1125	UG1	AA3	N	3000.00	3000.00	Y	2015-07-09 00:00:00.000	342079	YY	2015-07-06 00:00:00	168750	 	NULL	NULL	NULL
72651	1	2015-07-06 00:00:00	n029	2015-07-06 00:00:00	N	T	15070032	GS00035177	66757	_	T	906	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-07-09 00:00:00.000	342096	YY	2015-07-06 00:00:00	122987	 	NULL	NULL	NULL
72652	1	2015-07-06 00:00:00	n029	2015-07-06 00:00:00	N	T	15070033	GS00035178	66758	_	T	906	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-07-09 00:00:00.000	342097	YY	2015-07-06 00:00:00	122988	 	NULL	NULL	NULL
72653	1	2015-07-06 00:00:00	n029	2015-07-06 00:00:00	N	T	15070034	GS00035179	66759	_	T	906	n530	FR1	FR1	N	4000.00	4000.00	Y	2015-07-09 00:00:00.000	342098	YY	2015-07-06 00:00:00	122989	 	NULL	NULL	NULL
72654	1	2015-07-06 00:00:00	n029	2015-07-06 00:00:00	N	T	15070053	GS00035180	66748	_	T	11878	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-07-09 00:00:00.000	342099	YY	2015-07-06 00:00:00	122990	 	NULL	NULL	NULL
72655	1	2015-07-06 00:00:00	n029	2015-07-06 00:00:00	N	T	15070054	GS00035181	66749	_	T	11878	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-07-09 00:00:00.000	342100	YY	2015-07-06 00:00:00	122991	 	NULL	NULL	NULL
72656	1	2015-07-06 00:00:00	n029	2015-07-06 00:00:00	N	T	15070055	GS00035182	66750	_	T	11878	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-07-09 00:00:00.000	342101	YY	2015-07-06 00:00:00	122992	 	NULL	NULL	NULL
72657	1	2015-07-06 00:00:00	n029	2015-07-06 00:00:00	N	T	15070056	GS00035183	50396	_	T	11878	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-07-09 00:00:00.000	342102	YY	2015-07-06 00:00:00	122993	 	NULL	NULL	NULL
72658	1	2015-07-06 00:00:00	n029	2015-07-06 00:00:00	N	T	15070057	GS00035184	50397	_	T	11878	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-07-09 00:00:00.000	342103	YY	2015-07-06 00:00:00	122995	 	NULL	NULL	NULL
72659	1	2015-07-06 00:00:00	n029	2015-07-06 00:00:00	N	T	15070058	GS00035185	52070	_	T	11878	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-07-09 00:00:00.000	342104	YY	2015-07-06 00:00:00	123000	 	NULL	NULL	NULL
72660	1	2015-07-06 08:56:00	n087	2015-07-06 00:00:00	N	P	15050186	GS15001686	28550	_	T	15762	n1489	IG1E	AA2	N	10500.00	10500.00	Y	2015-07-09 00:00:00.000	342080	YY	2015-07-06 00:00:00	168751	 	NULL	NULL	NULL
72661	1	2015-07-06 00:00:00	n029	2015-07-06 00:00:00	N	T	15070059	GS00035186	52069	_	T	11878	n824	FR1	FR1	N	4000.00	4000.00	Y	2015-07-09 00:00:00.000	342105	YY	2015-07-06 00:00:00	123001	 	NULL	NULL	NULL
72662	1	2015-07-06 08:58:00	n087	2015-07-06 00:00:00	N	P	15050187	GS15001687	28551	_	T	15762	n1489	UG1	AA3	N	3000.00	3000.00	Y	2015-07-09 00:00:00.000	342081	YY	2015-07-06 00:00:00	168752	 	NULL	NULL	NULL
72663	1	2015-07-06 00:00:00	n029	2015-07-07 00:00:00	N	T	15060363	GS00035187	53239	_	T	2855	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-07-09 00:00:00.000	342112	YY	2015-07-07 00:00:00	123045	 	NULL	NULL	NULL
72664	1	2015-07-06 00:00:00	n029	2015-07-07 00:00:00	N	T	15060364	GS00035188	53238	_	T	2855	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-07-09 00:00:00.000	342113	YY	2015-07-07 00:00:00	123046	 	NULL	NULL	NULL
72665	1	2015-07-06 00:00:00	n029	2015-07-07 00:00:00	N	T	15060365	GS00035189	53243	_	T	2855	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-07-09 00:00:00.000	342114	YY	2015-07-07 00:00:00	123048	 	NULL	NULL	NULL
72666	1	2015-07-06 00:00:00	n029	2015-07-07 00:00:00	N	T	15060366	GS00035190	53241	_	T	2855	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-07-09 00:00:00.000	342115	YY	2015-07-07 00:00:00	123049	 	NULL	NULL	NULL
72667	1	2015-07-06 00:00:00	n029	2015-07-07 00:00:00	N	T	15060367	GS00035191	53244	_	T	2855	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-07-09 00:00:00.000	342116	YY	2015-07-07 00:00:00	123050	 	NULL	NULL	NULL
72668	1	2015-07-06 00:00:00	n029	2015-07-07 00:00:00	N	T	15060368	GS00035192	53242	_	T	2855	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-07-09 00:00:00.000	342117	YY	2015-07-07 00:00:00	123051	 	NULL	NULL	NULL
72669	1	2015-07-06 00:00:00	n029	2015-07-07 00:00:00	N	T	15060369	GS00035193	53240	_	T	2855	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-07-09 00:00:00.000	342118	YY	2015-07-07 00:00:00	123052	 	NULL	NULL	NULL
72670	1	2015-07-06 00:00:00	n029	2015-07-07 00:00:00	N	T	15060370	GS00035194	53237	_	T	2855	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-07-09 00:00:00.000	342119	YY	2015-07-07 00:00:00	123053	 	NULL	NULL	NULL
72671	1	2015-07-06 00:00:00	n029	2015-07-07 00:00:00	N	T	15060371	GS00035195	48964	_	T	2855	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-07-09 00:00:00.000	342120	YY	2015-07-07 00:00:00	123054	 	NULL	NULL	NULL
72672	1	2015-07-06 00:00:00	n029	2015-07-07 00:00:00	N	T	15060372	GS00035196	48963	_	T	2855	n1384	FR1	FR1	N	4000.00	4000.00	Y	2015-07-09 00:00:00.000	342121	YY	2015-07-07 00:00:00	123055	 	NULL	NULL	NULL
72673	1	2015-07-06 00:00:00	n029	2015-07-07 00:00:00	N	T	15070079	GS00035197	66766	_	T	14558	n824	FE11	FE11	N	2700.00	2700.00	Y	2015-07-09 00:00:00.000	342122	YE	2015-07-07 00:00:00	123057	 	NULL	NULL	NULL
72674	1	2015-07-06 00:00:00	n029	2015-07-07 00:00:00	N	T	15070082	GS00035198	66767	_	T	16095	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-07-09 00:00:00.000	342123	YE	2015-07-07 00:00:00	123058	 	NULL	NULL	NULL
72675	1	2015-07-06 00:00:00	n029	2015-07-07 00:00:00	N	T	15070083	GS00035199	66768	_	T	16095	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-07-09 00:00:00.000	342124	YE	2015-07-07 00:00:00	123059	 	NULL	NULL	NULL
72676	1	2015-07-07 08:43:00	n319	2015-07-07 00:00:00	N	P	15070062	GS15001688	25740	_	T	14593	n1489	WS1	AJ1	N	8500.00	8500.00	Y	2015-07-09 00:00:00.000	342106	YY	2015-07-07 00:00:00	168831	 	NULL	NULL	NULL
72677	1	2015-07-07 08:46:00	n319	2015-07-07 00:00:00	N	P	14110122	GS15001689	28136	_	T	12433	n650	IG1E	AA2	N	10500.00	10500.00	Y	2015-07-09 00:00:00.000	342107	YY	2015-07-07 00:00:00	168832	 	NULL	NULL	NULL
72678	1	2015-07-07 09:17:00	n319	2015-07-07 00:00:00	N	P	15040173	GS15001692	28487	_	T	5093	n1065	UG1	AA3	N	3000.00	3000.00	Y	2015-07-09 00:00:00.000	342108	YY	2015-07-07 00:00:00	168840	 	NULL	NULL	NULL
72679	1	2015-07-07 09:41:00	n319	2015-07-07 00:00:00	N	P	15070052	GS15001693	1012	M	T	12330	n113	WS2	AK2	X	8000.00	8000.00	Y	2015-07-09 00:00:00.000	342109	YE	2015-07-07 00:00:00	168841	 	NULL	NULL	NULL
72680	1	2015-07-07 09:41:00	n319	2015-07-07 00:00:00	N	P	15070067	GS15001694	25720	_	T	13712	n896	WS2	AK2	N	4000.00	4000.00	Y	2015-07-09 00:00:00.000	342110	YE	2015-07-07 00:00:00	168842	 	NULL	NULL	NULL
72681	1	2015-07-07 09:41:00	n319	2015-07-07 00:00:00	N	P	15070068	GS15001695	25961	_	T	13712	n896	WS2	AK2	N	4000.00	4000.00	Y	2015-07-09 00:00:00.000	342111	YE	2015-07-07 00:00:00	168843	 	NULL	NULL	NULL
72682	1	2015-07-07 16:24:00	n319	2015-07-08 00:00:00	N	P	15070070	GS15001696	27894	_	T	14737	n650	WA3	AN5	D	1000.00	1000.00	Y	2015-07-14 00:00:00.000	342267	YY	2015-07-08 00:00:00	168922	 	NULL	NULL	NULL
72683	1	2015-07-07 16:24:00	n319	2015-07-08 00:00:00	N	P	15070071	GS15001697	27895	_	T	14737	n650	WA3	AN5	D	1000.00	1000.00	Y	2015-07-14 00:00:00.000	342268	YY	2015-07-08 00:00:00	168923	 	NULL	NULL	NULL
72684	1	2015-07-07 16:26:00	n319	2015-07-08 00:00:00	N	P	15070063	GS15001698	28405	_	T	3554	n896	WS1	AJ1	N	3500.00	3500.00	Y	2015-07-14 00:00:00.000	342269	YY	2015-07-08 00:00:00	168924	 	NULL	NULL	NULL
72685	1	2015-07-07 00:00:00	n029	2015-07-08 00:00:00	N	T	15070091	GS00035201	66771	_	T	16085	n646	FE1	FE1	N	2400.00	2400.00	Y	2015-07-14 00:00:00.000	342272	YE	2015-07-08 00:00:00	123127	 	NULL	NULL	NULL
72686	1	2015-07-07 00:00:00	n029	2015-07-08 00:00:00	N	T	15070084	GS00035202	66769	_	T	14952	n824	FE1	FE1	N	2400.00	2400.00	Y	2015-07-14 00:00:00.000	342273	YE	2015-07-08 00:00:00	123128	 	NULL	NULL	NULL
72687	1	2015-07-07 00:00:00	n029	2015-07-08 00:00:00	N	T	15070085	GS00035203	66770	_	T	14952	n824	FE1	FE1	N	2400.00	2400.00	Y	2015-07-14 00:00:00.000	342274	YE	2015-07-08 00:00:00	123129	 	NULL	NULL	NULL
72688	1	2015-07-07 00:00:00	n029	2015-07-08 00:00:00	N	T	15070093	GS00035204	66775	_	T	16074	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-07-14 00:00:00.000	342275	YE	2015-07-08 00:00:00	123130	 	NULL	NULL	NULL
72689	1	2015-07-07 00:00:00	n029	2015-07-08 00:00:00	N	T	15070094	GS00035205	66776	_	T	16074	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-07-14 00:00:00.000	342276	YE	2015-07-08 00:00:00	123131	 	NULL	NULL	NULL
72690	1	2015-07-07 00:00:00	n029	2015-07-08 00:00:00	N	T	15070095	GS00035206	66777	_	T	16074	n1384	FE1	FE1	N	2400.00	2400.00	Y	2015-07-14 00:00:00.000	342277	YE	2015-07-08 00:00:00	123132	 	NULL	NULL	NULL
72691	1	2015-07-07 00:00:00	n029	2015-07-08 00:00:00	N	T	15070078	GS00035207	65787	_	T	15794	n646	FF0	FF0	N	2500.00	2500.00	Y	2015-07-14 00:00:00.000	342278	YY	2015-07-08 00:00:00	123133	 	NULL	NULL	NULL
72692	1	2015-07-08 00:00:00	n029	2015-07-08 00:00:00	N	T	15070063	GS00035209	66760	_	T	12385	n646	FT1	FT1	N	2000.00	2000.00	Y	2015-07-14 00:00:00.000	342279	YY	2015-07-08 00:00:00	123135	 	NULL	NULL	NULL
72693	1	2015-07-08 00:00:00	n029	2015-07-08 00:00:00	N	T	15070064	GS00035210	66761	_	T	12385	n646	FT1	FT1	N	2000.00	2000.00	Y	2015-07-14 00:00:00.000	342280	YY	2015-07-08 00:00:00	123136	 	NULL	NULL	NULL
72694	1	2015-07-08 00:00:00	n029	2015-07-08 00:00:00	N	T	15070065	GS00035211	66762	_	T	12385	n646	FT1	FT1	N	2000.00	2000.00	Y	2015-07-14 00:00:00.000	342281	YY	2015-07-08 00:00:00	123137	 	NULL	NULL	NULL
72695	1	2015-07-08 00:00:00	n029	2015-07-08 00:00:00	N	T	15070066	GS00035212	66763	_	T	12385	n646	FT1	FT1	N	2000.00	2000.00	Y	2015-07-14 00:00:00.000	342282	YY	2015-07-08 00:00:00	123138	 	NULL	NULL	NULL
72696	1	2015-07-08 00:00:00	n029	2015-07-08 00:00:00	N	T	15070067	GS00035213	66764	_	T	12385	n646	FT1	FT1	N	2000.00	2000.00	Y	2015-07-14 00:00:00.000	342283	YY	2015-07-08 00:00:00	123139	 	NULL	NULL	NULL
72697	1	2015-07-08 00:00:00	n029	2015-07-08 00:00:00	N	T	15070068	GS00035214	66765	_	T	12385	n646	FT1	FT1	N	2000.00	2000.00	Y	2015-07-14 00:00:00.000	342284	YY	2015-07-08 00:00:00	123140	 	NULL	NULL	NULL
72698	1	2015-07-08 00:00:00	n029	2015-07-08 00:00:00	N	T	15070073	GS00035215	66772	_	T	16091	n441	FE1	FE1	N	2400.00	2400.00	Y	2015-07-14 00:00:00.000	342285	YE	2015-07-08 00:00:00	123141	 	NULL	NULL	NULL
72699	1	2015-07-08 00:00:00	n029	2015-07-08 00:00:00	N	T	15070074	GS00035216	66773	_	T	16091	n441	FE1	FE1	N	2400.00	2400.00	Y	2015-07-14 00:00:00.000	342286	YE	2015-07-08 00:00:00	123142	 	NULL	NULL	NULL
72700	1	2015-07-08 00:00:00	n029	2015-07-08 00:00:00	N	T	15070075	GS00035217	66774	_	T	16091	n441	FE1	FE1	N	2400.00	2400.00	Y	2015-07-14 00:00:00.000	342287	YE	2015-07-08 00:00:00	123143	 	NULL	NULL	NULL
72701	1	2015-07-08 08:46:00	n319	2015-07-08 00:00:00	N	P	15040276	GS15001700	28509	_	T	14544	n1125	UG1	AA3	N	3000.00	3000.00	Y	2015-07-14 00:00:00.000	342270	YY	2015-07-08 00:00:00	168930	 	NULL	NULL	NULL
72702	1	2015-07-08 09:18:00	n319	2015-07-08 00:00:00	N	P	15070100	GS15001701	26297	_	T	13638	n650	WS11	AJ2	N	1000.00	1000.00	Y	2015-07-14 00:00:00.000	342271	YY	2015-07-08 00:00:00	168931	 	NULL	NULL	NULL
72703	1	2015-07-08 15:42:00	n319	2015-07-09 00:00:00	N	P	15070074	GS15001705	26334	_	T	10747	n1065	WS1	AJ1	N	8500.00	8500.00	N	NULL	0	YY	2015-07-09 00:00:00	169034	 	NULL	NULL	NULL
72704	1	2015-07-08 15:45:00	n319	2015-07-09 00:00:00	N	P	15070076	GS15001707	28166	_	T	10747	n1065	WS1	AJ1	N	8500.00	8500.00	N	NULL	0	YY	2015-07-09 00:00:00	169038	 	NULL	NULL	NULL
72705	1	2015-07-08 15:46:00	n319	2015-07-09 00:00:00	N	P	15070077	GS15001708	28195	_	T	10747	n1065	WS1	AJ1	N	8500.00	8500.00	N	NULL	0	YY	2015-07-09 00:00:00	169039	 	NULL	NULL	NULL
72706	1	2015-07-08 15:47:00	n319	2015-07-09 00:00:00	N	P	15070073	GS15001709	28196	_	T	10747	n1065	WS1	AJ1	N	8500.00	8500.00	N	NULL	0	YY	2015-07-09 00:00:00	169042	 	NULL	NULL	NULL
72707	1	2015-07-08 15:48:00	n319	2015-07-09 00:00:00	N	P	15070075	GS15001710	28234	_	T	10747	n1065	WS1	AJ1	N	8500.00	8500.00	N	NULL	0	YY	2015-07-09 00:00:00	169044	 	NULL	NULL	NULL
72708	1	2015-07-08 15:49:00	n319	2015-07-09 00:00:00	N	P	15070078	GS15001711	28397	_	T	10747	n1065	WS1	AJ1	N	8500.00	8500.00	N	NULL	0	YY	2015-07-09 00:00:00	169047	 	NULL	NULL	NULL
72709	1	2015-07-08 15:51:00	n319	2015-07-09 00:00:00	N	P	15030229	GS15001712	28417	_	T	15336	n1125	IG1E	AA2	N	10500.00	10500.00	N	NULL	0	YY	2015-07-09 00:00:00	169049	 	NULL	NULL	NULL
72710	1	2015-07-08 15:52:00	n319	2015-07-09 00:00:00	N	P	15030230	GS15001713	28418	_	T	15336	n1125	UG1	AA3	N	3000.00	3000.00	N	NULL	0	YY	2015-07-09 00:00:00	169050	 	NULL	NULL	NULL
72711	1	2015-07-08 17:30:00	n319	2015-07-09 00:00:00	N	P	15050106	GS15001714	28529	_	T	10747	n1065	IG1E	AA2	N	10500.00	26200.00	N	NULL	0	YY	2015-07-09 00:00:00	169068	 	NULL	NULL	NULL
72712	1	2015-07-08 17:30:00	n319	2015-07-09 00:00:00	N	P	15070110	GS15001714	28529	_	T	10747	n1065	AC2	AA2	N	15700.00	26200.00	N	NULL	0	YY	2015-07-09 00:00:00	169068	 	NULL	NULL	NULL
72713	1	2015-07-09 08:54:00	n319	2015-07-09 00:00:00	N	P	15070111	GS15001715	27157	_	T	13472	n1304	WS1	AJ1	N	8500.00	8500.00	N	NULL	0	YY	2015-07-09 00:00:00	169069	 	NULL	NULL	NULL
72714	1	2015-07-09 08:58:00	n319	2015-07-09 00:00:00	N	P	15070105	GS15001716	28438	_	T	13124	n1304	WA3	AN5	D	1000.00	1000.00	N	NULL	0	YY	2015-07-09 00:00:00	169070	 	NULL	NULL	NULL
72715	1	2015-07-09 09:00:00	n319	2015-07-09 00:00:00	N	P	15050018	GS15001717	28519	_	T	14140	n896	IG1E	AA2	N	10500.00	10500.00	N	NULL	0	YY	2015-07-09 00:00:00	169071	 	NULL	NULL	NULL
72716	1	2015-07-09 09:02:00	n319	2015-07-09 00:00:00	N	P	15050019	GS15001718	28520	_	T	14140	n896	UG1	AA3	N	3000.00	3000.00	N	NULL	0	YY	2015-07-09 00:00:00	169072	 	NULL	NULL	NULL
72717	1	2015-07-09 09:20:00	n319	2015-07-09 00:00:00	N	P	15070115	GS15001719	28308	_	T	13708	n896	WS11	AJ2	N	6100.00	6100.00	N	NULL	0	YY	2015-07-09 00:00:00	169073	 	NULL	NULL	NULL
72718	1	2015-07-09 09:41:00	n319	2015-07-09 00:00:00	N	P	15070101	GS15001720	18434	_	T	12406	n650	WS2	AK2	N	8000.00	8000.00	N	NULL	0	YE	2015-07-09 00:00:00	169074	 	NULL	NULL	NULL
72719	1	2015-07-09 09:41:00	n319	2015-07-09 00:00:00	N	P	15070106	GS15001721	23886	_	T	12391	n1125	WS2	AK2	N	24000.00	24000.00	N	NULL	0	YE	2015-07-09 00:00:00	169075	 	NULL	NULL	NULL
72725	1	2015-07-13 00:00:00	n029	2015-07-13 00:00:00	N	T	15070109	GS00035229	66781	_	T	16097	n1350	FE1	FE1	N	2400.00	2400.00	N	NULL	0	YE	2015-07-13 00:00:00	123295	 	NULL	NULL	NULL
72726	1	2015-07-13 00:00:00	n029	2015-07-13 00:00:00	N	T	15070110	GS00035230	66782	_	T	16097	n1350	FE1	FE1	N	2400.00	2400.00	N	NULL	0	YE	2015-07-13 00:00:00	123296	 	NULL	NULL	NULL
72727	1	2015-07-13 00:00:00	n029	2015-07-13 00:00:00	N	T	15070111	GS00035231	66783	_	T	16097	n1350	FE1	FE1	N	2400.00	2400.00	N	NULL	0	YE	2015-07-13 00:00:00	123297	 	NULL	NULL	NULL
72728	1	2015-07-13 00:00:00	n029	2015-07-13 00:00:00	N	T	15070112	GS00035232	66784	_	T	16097	n1350	FE1	FE1	N	2400.00	2400.00	N	NULL	0	YE	2015-07-13 00:00:00	123298	 	NULL	NULL	NULL
72729	1	2015-07-13 00:00:00	n029	2015-07-13 00:00:00	N	T	15070113	GS00035233	66785	_	T	16097	n1350	FE1	FE1	N	2400.00	2400.00	N	NULL	0	YE	2015-07-13 00:00:00	123299	 	NULL	NULL	NULL
72730	1	2015-07-13 00:00:00	n029	2015-07-13 00:00:00	N	T	15070114	GS00035234	66786	_	T	16097	n1350	FE1	FE1	N	2400.00	2400.00	N	NULL	0	YE	2015-07-13 00:00:00	123300	 	NULL	NULL	NULL
72731	1	2015-07-13 00:00:00	n029	2015-07-13 00:00:00	N	T	15070107	GS00035225	52528	_	T	4830	n441	FR1	FR1	N	4000.00	4000.00	N	NULL	0	YY	2015-07-13 00:00:00	123253	 	NULL	NULL	NULL
72732	1	2015-07-13 00:00:00	n029	2015-07-13 00:00:00	N	T	15070101	GS00035224	66045	_	T	14059	n530	FF0	FF0	N	2500.00	2500.00	N	NULL	0	YY	2015-07-13 00:00:00	123252	 	NULL	NULL	NULL
72733	1	2015-07-13 00:00:00	n029	2015-07-13 00:00:00	N	T	15070103	GS00035226	66778	_	T	13600	n646	FT1	FT1	N	2000.00	2000.00	N	NULL	0	YY	2015-07-13 00:00:00	123270	 	NULL	NULL	NULL
72734	1	2015-07-13 00:00:00	n029	2015-07-13 00:00:00	N	T	15070104	GS00035227	66779	_	T	13600	n646	FT1	FT1	N	2000.00	2000.00	N	NULL	0	YY	2015-07-13 00:00:00	123271	 	NULL	NULL	NULL
72735	1	2015-07-13 00:00:00	n029	2015-07-13 00:00:00	N	T	15070105	GS00035228	66780	_	T	13600	n646	FT1	FT1	N	2000.00	2000.00	N	NULL	0	YY	2015-07-13 00:00:00	123272	 	NULL	NULL	NULL
72736	1	2015-07-13 08:45:00	n319	2015-07-13 00:00:00	N	P	15040176	GS15001723	28493	_	T	13930	n896	IG1E	AA2	N	10500.00	10500.00	N	NULL	0	YY	2015-07-13 00:00:00	169199	 	NULL	NULL	NULL
72737	1	2015-07-13 08:47:00	n319	2015-07-13 00:00:00	N	P	15060284	GS15001724	28659	_	T	14334	n896	DG1	AA4	N	3000.00	3000.00	N	NULL	0	YY	2015-07-13 00:00:00	169200	 	NULL	NULL	NULL
72738	1	2015-07-13 09:07:00	n319	2015-07-13 00:00:00	N	P	15030345	GS15001725	28443	_	T	7636	n1304	UG1	AA3	N	3000.00	3000.00	N	NULL	0	YY	2015-07-13 00:00:00	169201	 	NULL	NULL	NULL
72739	1	2015-07-13 09:09:00	n319	2015-07-13 00:00:00	N	P	15030346	GS15001726	28444	_	T	7636	n1304	UG1	AA3	N	3000.00	3000.00	N	NULL	0	YY	2015-07-13 00:00:00	169202	 	NULL	NULL	NULL
72740	1	2015-07-13 09:10:00	n319	2015-07-13 00:00:00	N	P	15070107	GS15001727	28701	_	T	15748	n1125	DG1	AA4	N	3000.00	3000.00	N	NULL	0	YY	2015-07-13 00:00:00	169203	 	NULL	NULL	NULL
72741	1	2015-07-13 15:18:00	n319	2015-07-14 00:00:00	N	P	15070125	GS15001729	28150	_	T	3570	n1489	WS1	AJ1	N	1800.00	1800.00	N	NULL	0	YY	2015-07-14 00:00:00	169302	 	NULL	NULL	NULL
72742	1	2015-07-13 15:20:00	n319	2015-07-14 00:00:00	N	P	15070126	GS15001730	28151	_	T	3570	n1489	WS1	AJ1	N	1800.00	1800.00	N	NULL	0	YY	2015-07-14 00:00:00	169303	 	NULL	NULL	NULL
72743	1	2015-07-13 15:21:00	n319	2015-07-14 00:00:00	N	P	15070127	GS15001731	28341	_	T	3570	n1489	WS1	AJ1	N	1800.00	1800.00	N	NULL	0	YY	2015-07-14 00:00:00	169304	 	NULL	NULL	NULL
72744	1	2015-07-13 15:48:00	n319	2015-07-14 00:00:00	N	P	15070117	GS15001733	25510	_	T	13124	n1304	WS11	AJ2	N	6100.00	6100.00	N	NULL	0	YY	2015-07-14 00:00:00	169311	 	NULL	NULL	NULL
72745	1	2015-07-13 15:48:00	n319	2015-07-14 00:00:00	N	P	15070118	GS15001734	25510	_	T	13124	n1304	WS21	AK3	N	7600.00	7600.00	N	NULL	0	YY	2015-07-14 00:00:00	169312	 	NULL	NULL	NULL
72746	1	2015-07-14 08:53:00	n319	2015-07-14 00:00:00	N	P	15070156	GS15001736	1189	M	T	16098	n113	UG1	AA3	X	3000.00	3000.00	N	NULL	0	YY	2015-07-14 00:00:00	169322	 	NULL	NULL	NULL
72747	1	2015-07-14 09:06:00	n319	2015-07-14 00:00:00	N	P	15060174	GS15001744	28642	_	T	16066	n113	IG1E	AA2	N	10500.00	15300.00	N	NULL	0	YY	2015-07-14 00:00:00	169330	 	NULL	NULL	NULL
72748	1	2015-07-14 09:06:00	n319	2015-07-14 00:00:00	N	P	15070143	GS15001744	28642	_	T	16066	n113	AC2	AA2	N	4800.00	15300.00	N	NULL	0	YY	2015-07-14 00:00:00	169330	 	NULL	NULL	NULL
72749	1	2015-07-14 09:07:00	n319	2015-07-14 00:00:00	N	P	15060176	GS15001745	28643	_	T	16066	n113	UG1	AA3	N	3000.00	3000.00	N	NULL	0	YY	2015-07-14 00:00:00	169331	 	NULL	NULL	NULL
72750	1	2015-07-14 09:32:00	n319	2015-07-14 00:00:00	N	P	15070140	GS15001746	27343	_	T	15569	n994	WS3	AK5	N	3200.00	3200.00	N	NULL	0	YY	2015-07-14 00:00:00	169332	 	NULL	NULL	NULL
72751	1	2015-07-14 09:37:00	n319	2015-07-14 00:00:00	N	P	15070141	GS15001747	18642	_	T	13095	n650	WS2	AK2	N	8000.00	8000.00	N	NULL	0	YE	2015-07-14 00:00:00	169333	 	NULL	NULL	NULL
72752	1	2015-07-14 00:00:00	n029	2015-07-15 00:00:00	N	T	15070131	GS00035236	66787	_	T	14816	n646	FE11	FE11	N	2700.00	2700.00	N	NULL	0	YE	2015-07-15 00:00:00	123390	 	NULL	NULL	NULL
72753	1	2015-07-14 00:00:00	n029	2015-07-15 00:00:00	N	T	15070130	GS00035237	66788	_	T	14816	n646	FE11	FE11	N	2700.00	2700.00	N	NULL	0	YE	2015-07-15 00:00:00	123391	 	NULL	NULL	NULL
72754	1	2015-07-15 08:55:00	n319	2015-07-15 00:00:00	N	P	15060291	GS15001749	27371	_	T	11997	n1486	FC2	AM2	N	2000.00	2000.00	N	NULL	0	YY	2015-07-15 00:00:00	169420	 	NULL	NULL	NULL
72755	1	2015-07-15 08:56:00	n319	2015-07-15 00:00:00	N	P	15060279	GS15001750	27371	_	T	11997	n1486	WS21	AK3	N	3400.00	3400.00	N	NULL	0	YY	2015-07-15 00:00:00	169421	 	NULL	NULL	NULL
72756	1	2015-07-15 09:02:00	n319	2015-07-15 00:00:00	N	P	15060096	GS15001751	28639	_	T	15598	n1125	UG1	AA3	N	3000.00	3000.00	N	NULL	0	YY	2015-07-15 00:00:00	169422	 	NULL	NULL	NULL
72757	1	2015-07-15 09:19:00	n319	2015-07-15 00:00:00	N	P	15070122	GS15001752	28601	_	T	14510	n1125	WA3	AN5	D	3000.00	3000.00	N	NULL	0	YY	2015-07-15 00:00:00	169423	 	NULL	NULL	NULL
72758	1	2015-07-15 14:38:00	n319	2015-07-16 00:00:00	N	P	15070051	GS15001754	25794	_	T	14269	n994	AC2	AK5	N	14400.00	14400.00	N	NULL	0	YY	2015-07-16 00:00:00	169485	 	NULL	NULL	NULL
72759	1	2015-07-15 14:40:00	n319	2015-07-16 00:00:00	N	P	15070174	GS15001755	26255	_	T	14988	n650	WS1	AJ1	N	3500.00	3500.00	N	NULL	0	YY	2015-07-16 00:00:00	169487	 	NULL	NULL	NULL
72760	1	2015-07-15 14:48:00	n319	2015-07-16 00:00:00	N	P	15070176	GS15001759	27929	_	T	2853	n100	WA3	AN5	D	1000.00	1000.00	N	NULL	0	YY	2015-07-16 00:00:00	169491	 	NULL	NULL	NULL
72761	1	2015-07-15 00:00:00	n029	2015-07-16 00:00:00	N	T	15070151	GS00035238	66790	_	T	14366	n1384	FE1	FE1	D	2400.00	2400.00	N	NULL	0	YE	2015-07-16 00:00:00	123435	 	NULL	NULL	NULL
72762	1	2015-07-15 00:00:00	n029	2015-07-16 00:00:00	N	T	15070134	GS00035239	65827	_	T	12943	n530	FF0	FF0	N	2500.00	2500.00	N	NULL	0	YY	2015-07-16 00:00:00	123436	 	NULL	NULL	NULL
72763	1	2015-07-15 00:00:00	n029	2015-07-16 00:00:00	N	T	15070127	GS00035240	66789	_	T	16096	n1384	FR1	FR1	N	4000.00	4000.00	N	NULL	0	YY	2015-07-16 00:00:00	123437	 	NULL	NULL	NULL
72764	1	2015-07-15 00:00:00	n029	2015-07-16 00:00:00	N	T	15070132	GS00035241	53369	_	T	7540	n1384	FR1	FR1	N	4000.00	4000.00	N	NULL	0	YY	2015-07-16 00:00:00	123438	 	NULL	NULL	NULL
72765	1	2015-07-15 00:00:00	n029	2015-07-16 00:00:00	N	T	15070133	GS00035242	53371	_	T	7540	n1384	FR1	FR1	N	4000.00	4000.00	N	NULL	0	YY	2015-07-16 00:00:00	123439	 	NULL	NULL	NULL
72766	1	2015-07-16 00:00:00	n029	2015-07-16 00:00:00	N	T	15070147	GS00035243	52903	_	T	4049	n441	FR1	FR1	N	4000.00	4000.00	N	NULL	0	YY	2015-07-16 00:00:00	123460	 	NULL	NULL	NULL
72767	1	2015-07-16 00:00:00	n029	2015-07-16 00:00:00	N	T	15070148	GS00035244	53372	_	T	4049	n441	FR1	FR1	N	4000.00	4000.00	N	NULL	0	YY	2015-07-16 00:00:00	123461	 	NULL	NULL	NULL
72768	1	2015-07-16 00:00:00	n029	2015-07-16 00:00:00	N	T	15070149	GS00035245	53373	_	T	4049	n441	FR1	FR1	N	4000.00	4000.00	N	NULL	0	YY	2015-07-16 00:00:00	123462	 	NULL	NULL	NULL
72769	1	2015-07-16 00:00:00	n029	2015-07-16 00:00:00	N	T	15070150	GS00035246	53518	_	T	4049	n441	FR1	FR1	N	4000.00	4000.00	N	NULL	0	YY	2015-07-16 00:00:00	123463	 	NULL	NULL	NULL
72770	1	2015-07-16 08:57:00	n319	2015-07-16 00:00:00	N	P	15070187	GS15001762	27641	_	T	12383	n1304	WS11	AJ2	N	1000.00	1000.00	N	NULL	0	YY	2015-07-16 00:00:00	169529	 	NULL	NULL	NULL
72771	1	2015-07-16 09:22:00	n319	2015-07-16 00:00:00	N	P	15060249	GS15001763	28656	_	T	13648	n650	UE1	AA3_E	N	2400.00	0.00	N	NULL	0	NN	NULL	0	 	NULL	NULL	NULL
72772	1	2015-07-16 00:00:00	n029	2015-07-17 00:00:00	N	T	15070175	GS00035251	66027	_	T	1646	n428	FF0	FF0	N	2500.00	2500.00	N	NULL	0	YY	2015-07-17 00:00:00	123492	 	NULL	NULL	NULL
72773	1	2015-07-16 00:00:00	n029	2015-07-17 00:00:00	N	T	15070173	GS00035252	66032	_	T	6857	n428	FF0	FF0	N	2500.00	2500.00	N	NULL	0	YY	2015-07-17 00:00:00	123494	 	NULL	NULL	NULL
72774	1	2015-07-16 00:00:00	n029	2015-07-17 00:00:00	N	T	15070174	GS00035253	66033	_	T	6857	n428	FF0	FF0	N	2500.00	2500.00	N	NULL	0	YY	2015-07-17 00:00:00	123495	 	NULL	NULL	NULL
72775	1	2015-07-16 00:00:00	n029	2015-07-17 00:00:00	N	T	15070152	GS00035254	65781	_	T	12385	n646	FF0	FF0	N	2500.00	2500.00	N	NULL	0	YY	2015-07-17 00:00:00	123496	 	NULL	NULL	NULL
72776	1	2015-07-16 00:00:00	n029	2015-07-17 00:00:00	N	T	15070153	GS00035255	65782	_	T	12385	n646	FF0	FF0	N	2500.00	2500.00	N	NULL	0	YY	2015-07-17 00:00:00	123497	 	NULL	NULL	NULL
72777	1	2015-07-16 00:00:00	n029	2015-07-17 00:00:00	N	T	15070155	GS00035256	66778	_	T	13600	n646	FR1	FR1	N	4000.00	4000.00	N	NULL	0	YY	2015-07-17 00:00:00	123498	 	NULL	NULL	NULL
72778	1	2015-07-16 00:00:00	n029	2015-07-17 00:00:00	N	T	15070156	GS00035257	66779	_	T	13600	n646	FR1	FR1	N	4000.00	4000.00	N	NULL	0	YY	2015-07-17 00:00:00	123500	 	NULL	NULL	NULL
72779	1	2015-07-16 00:00:00	n029	2015-07-17 00:00:00	N	T	15070157	GS00035258	66780	_	T	13600	n646	FR1	FR1	N	4000.00	4000.00	N	NULL	0	YY	2015-07-17 00:00:00	123501	 	NULL	NULL	NULL
72780	1	2015-07-16 00:00:00	n029	2015-07-17 00:00:00	N	T	15070169	GS00035259	66793	_	T	4347	n1350	FE1	FE1	N	2400.00	2400.00	N	NULL	0	YE	2015-07-17 00:00:00	123505	 	NULL	NULL	NULL
72781	1	2015-07-16 00:00:00	n029	2015-07-17 00:00:00	N	T	15070170	GS00035260	66794	_	T	4347	n1350	FE1	FE1	N	2400.00	2400.00	N	NULL	0	YE	2015-07-17 00:00:00	123506	 	NULL	NULL	NULL
72782	1	2015-07-16 00:00:00	n029	2015-07-17 00:00:00	N	T	15070171	GS00035261	66791	_	T	14993	n1350	FE1	FE1	N	2400.00	2400.00	N	NULL	0	YE	2015-07-17 00:00:00	123507	 	NULL	NULL	NULL
72783	1	2015-07-16 00:00:00	n029	2015-07-17 00:00:00	N	T	15070172	GS00035262	66792	_	T	14993	n1350	FE1	FE1	N	2400.00	2400.00	N	NULL	0	YE	2015-07-17 00:00:00	123508	 	NULL	NULL	NULL
72784	1	2015-07-16 00:00:00	n029	2015-07-17 00:00:00	N	T	15070178	GS00035263	66795	_	T	4610	n547	FE11	FE11	N	7700.00	7700.00	N	NULL	0	YE	2015-07-17 00:00:00	123509	 	NULL	NULL	NULL
72785	1	2015-07-16 00:00:00	n029	2015-07-17 00:00:00	N	T	15070179	GS00035264	66796	_	T	4610	n547	FE11	FE11	N	7700.00	7700.00	N	NULL	0	YE	2015-07-17 00:00:00	123510	 	NULL	NULL	NULL
72786	1	2015-07-17 08:49:00	n319	2015-07-17 00:00:00	N	P	15070191	GS15001768	28243	_	T	15609	n1065	WS11	AJ2	N	2700.00	2700.00	N	NULL	0	YY	2015-07-17 00:00:00	169634	 	NULL	NULL	NULL
72787	1	2015-07-17 15:02:00	n319	2015-07-20 00:00:00	N	P	15070208	GS15001770	23713	_	T	13708	n896	WS21	AK3	N	2800.00	0.00	N	NULL	0	NN	NULL	0	 	NULL	NULL	NULL
72788	1	2015-07-17 15:04:00	n319	2015-07-20 00:00:00	N	P	15070207	GS15001771	25986	_	T	13712	n896	WS1	AJ1	N	8500.00	0.00	N	NULL	0	NN	NULL	0	 	NULL	NULL	NULL
72789	1	2015-07-17 15:05:00	n319	2015-07-20 00:00:00	N	P	15070212	GS15001772	26310	_	T	15012	n1125	WS1	AJ1	N	8500.00	0.00	N	NULL	0	NN	NULL	0	 	NULL	NULL	NULL
72790	1	2015-07-17 15:10:00	n319	2015-07-20 00:00:00	N	P	15070209	GS15001775	27624	_	T	13712	n896	WS1	AJ1	N	8500.00	0.00	N	NULL	0	NN	NULL	0	 	NULL	NULL	NULL
72791	1	2015-07-17 15:11:00	n319	2015-07-20 00:00:00	N	P	15070213	GS15001776	28282	_	T	15336	n1125	WS11	AJ2	N	2700.00	0.00	N	NULL	0	NN	NULL	0	 	NULL	NULL	NULL
72792	1	2015-07-17 15:12:00	n319	2015-07-20 00:00:00	N	P	15070214	GS15001777	28299	_	T	16015	n1125	WS11	AJ2	N	2700.00	0.00	N	NULL	0	NN	NULL	0	 	NULL	NULL	NULL
72793	1	2015-07-17 15:16:00	n319	2015-07-20 00:00:00	N	P	15060312	GS15001779	28466	_	T	15895	n1125	WA3	AN5	N	1000.00	0.00	N	NULL	0	NN	NULL	0	 	NULL	NULL	NULL
72794	1	2015-07-17 15:17:00	n319	2015-07-20 00:00:00	N	P	15070205	GS15001780	28526	_	T	555	n1486	WS11	AJ2	N	14500.00	0.00	N	NULL	0	NN	NULL	0	 	NULL	NULL	NULL
72795	1	2015-07-17 15:20:00	n319	2015-07-20 00:00:00	N	P	15070027	GS15001781	28638	_	T	15857	n1125	RR1	AAD	N	300.00	0.00	N	NULL	0	NN	NULL	0	 	NULL	NULL	NULL
72796	1	2015-07-17 15:34:00	n319	2015-07-20 00:00:00	N	P	15070216	GS15001782	22110	_	T	13613	n1486	WS11	AJ2	N	2700.00	0.00	N	NULL	0	NN	NULL	0	 	NULL	NULL	NULL
72797	1	2015-07-24 17:02:00	m983	2015-07-24 00:00:00	N	P	15070221	GS15001784	28727	_	T	14500	n113	IE1E	AA2_E	N	9900.00	9900.00	N	NULL	0	NN	NULL	0	 	NULL	NULL	NULL
72798	1	2015-07-30 15:15:00	m983	2015-07-30 00:00:00	N	P	14100234	GS15001785	28085	_	T	15851	n1065	UG1	AA3_E	N	3000.00	0.00	N	NULL	0	NN	NULL	0	 	NULL	NULL	NULL
72808	1	2015-09-18 10:44:00	m983	2015-09-18 00:00:00	N	P	15070217	GS15001786	27380	_	T	99999	n994	WS1	AJ1	N	8500.00	0.00	N	NULL	0	NN	NULL	0	 	NULL	NULL	NULL
72809	1	2015-09-18 10:44:00	m983	2015-09-18 00:00:00	N	P	15090002	GS15001786	27380	_	T	99999	n994	AAK	AJ1	N	1000.00	0.00	N	NULL	0	NN	NULL	0	 	NULL	NULL	NULL
72817	1	2015-12-01 14:27:00	m983	2015-12-01 00:00:00	N	P	15070223	GS15001787	28729	_	T	4837	n113	IE1	AA1_E	N	3500.00	0.00	N	NULL	0	NN	NULL	0	 	NULL	NULL	NULL
72818	1	2016-02-17 11:02:00	m983	2016-02-17 00:00:00	N	P	15070224	GS16000002	28738	_	T	4837	n113	IE1E	AA2_E	N	9900.00	0.00	N	NULL	0	NN	NULL	0	 	NULL	NULL	NULL
72819	1	2016-02-17 11:02:00	m983	2016-02-17 00:00:00	N	P	15070225	GS16000003	28730	_	T	4837	n113	UE1	AA3_E	N	2400.00	0.00	N	NULL	0	NN	NULL	0	 	NULL	NULL	NULL
72820	1	2016-05-06 00:00:00	m802	2016-05-06 00:00:00	N	T	16040002	BGS0004269	66797	_	T	15224	n428	AS1	AS1	N	4000.00	0.00	N	NULL	0	NN	NULL	0	 	NULL	NULL	NULL
72827	1	2016-10-31 00:00:00	m1583	2016-02-18 00:00:00	N	T	16010002	GS00035266	66801	_	T	7189	n428	FE1	FE1	N	2400.00	0.00	N	NULL	0	NN	NULL	0	 	NULL	NULL	NULL
72829	1	2016-12-05 00:00:00	m802	2016-12-05 00:00:00	N	T	16090008	GS00035268	66839	_	T	1624	n428	FR1	FR1	N	4000.00	0.00	N	NULL	0	NN	NULL	0	 	NULL	NULL	NULL
72830	1	2016-12-12 00:00:00	m1583	2016-12-12 00:00:00	N	T	16120001	GS00035269	66850	_	T	1624	n428	FE1	FE1	N	2400.00	0.00	N	NULL	0	NN	NULL	0	 	NULL	NULL	NULL
72831	1	2016-12-21 15:07:00	m1583	2016-12-21 00:00:00	N	P	16120006	GS16000004	28754	_	T	14134	n113	IE1E	AA2_E	N	9900.00	0.00	N	NULL	0	NN	NULL	0	 	NULL	NULL	NULL
72835	1	2016-12-21 16:10:00	m1583	2016-12-21 00:00:00	N	P	16120007	GS16000005	28755	_	T	14134	n113	IE1E	AA2_E	N	9900.00	0.00	N	NULL	0	NN	NULL	0	 	NULL	NULL	NULL
72836	1	2016-12-27 00:00:00	m1583	2016-09-30 00:00:00	N	T	16090017	GS00035270	66845	_	T	1624	n428	FR1	FR1	N	4000.00	0.00	N	NULL	0	NN	NULL	0	 	NULL	NULL	NULL
72837	1	2017-01-16 00:00:00	m1583	2017-01-16 00:00:00	N	T	17010001	GS00035271	66851	_	T	1234	n428	FE1	FE1	N	2400.00	2400.00	N	NULL	0	XX	2017-01-16 00:00:00	99893	 	NULL	NULL	NULL
72838	1	2017-01-16 00:00:00	m1583	2016-09-02 00:00:00	N	T	16090001	GS00035272	66835	_	T	1624	n428	FE1	FE1	N	2400.00	2400.00	N	NULL	0	XX	2017-01-16 00:00:00	99894	 	NULL	NULL	NULL
72842	1	2017-03-06 16:53:00	m802	2017-03-06 00:00:00	N	P	15070204	GS17000001	28746	_	T	15534	n1125	UG1	AA3	N	3000.00	0.00	N	NULL	0	NN	NULL	0	 	NULL	NULL	NULL
72843	1	2017-03-06 00:00:00	m802	2016-05-27 00:00:00	N	T	16050004	GS00035273	66813	_	T	7189	n428	FC2	FC2	N	500.00	500.00	N	NULL	0	YY	2017-08-01 00:00:00	99911	 	NULL	NULL	NULL
72950	1	2017-06-01 00:00:00	m1583	2016-09-29 00:00:00	N	T	16090019	GS00035267	66847	_	T	1624	n428	FR1	FR1	N	4000.00	4000.00	N	NULL	0	YY	2017-08-01 00:00:00	99889	 	NULL	NULL	NULL
74318	1	2017-06-02 00:00:00	m1583	2016-12-27 00:00:00	N	T	16030003	GS00035274	66804	_	T	7189	n428	FF0	FF0	N	2500.00	2500.00	N	NULL	0	YY	2017-08-02 00:00:00	99957	 	NULL	NULL	NULL
74321	1	2017-06-02 11:34:00	m1583	2017-06-02 00:00:00	N	P	16040001	GS17000003	28743	_	T	14134	n113	IE1E	AA2_E	N	9900.00	9900.00	N	NULL	0	XX	2017-06-02 00:00:00	137239	 	NULL	NULL	NULL
74330	1	2017-06-02 00:00:00	m1583	2017-06-02 00:00:00	N	T	17060002	GS00035276	72003	_	T	1624	n428	FE1	FE1	N	2400.00	2400.00	N	NULL	0	YE	2017-06-02 00:00:00	99967	 	NULL	NULL	NULL
74331	1	2017-06-02 17:33:00	m1583	2017-06-02 00:00:00	N	P	17010003	GS17000004	28760	_	T	1624	n100	IE1	AA1_E	N	2900.00	0.00	N	NULL	0	NN	NULL	0	 	NULL	NULL	NULL
74332	1	2017-06-02 17:36:00	m1583	2017-06-02 00:00:00	N	P	15060364	GS17000005	28670	_	T	16087	n896	IE1B	AA21_E	N	9100.00	0.00	N	NULL	0	NN	NULL	0	 	NULL	NULL	NULL
74333	1	2017-06-02 00:00:00	m1583	2017-06-02 00:00:00	N	T	17060001	GS00035277	72002	_	T	1624	n428	FE1	FE1	N	2400.00	2400.00	N	NULL	0	YE	2017-06-14 00:00:00	99968	 	NULL	NULL	NULL
74334	1	2017-06-02 00:00:00	m1583	2017-06-02 00:00:00	N	T	16090006	GS00035278	66838	_	T	1624	n428	FE1	FE1	N	2400.00	2400.00	N	NULL	0	YE	2017-06-14 00:00:00	99969	 	NULL	NULL	NULL
74338	1	2017-06-03 14:21:00	m1583	2017-06-03 00:00:00	N	P	16110002	GS17000007	28748	_	T	1624	n100	WS2	AK2	N	33330.00	33330.00	N	NULL	0	XX	2017-06-03 00:00:00	137245	 	NULL	NULL	NULL
74339	1	2017-06-13 10:35:00	m1583	2017-06-13 00:00:00	N	P	16110002	GS17000008	28748	_	T	1624	n100	WS2	AK2	N	33330.00	33330.00	N	NULL	0	XX	2017-06-13 00:00:00	137269	 	NULL	NULL	NULL
74341	1	2017-06-13 11:11:00	m1583	2017-06-13 00:00:00	N	P	16110002	GS17000009	28748	_	T	1624	n100	WS2	AK2	N	33330.00	33330.00	N	NULL	0	YE	2017-06-13 00:00:00	137272	 	NULL	NULL	NULL
74342	1	2017-06-13 16:48:00	m1583	2017-06-13 00:00:00	N	P	16040001	GS17000011	28743	_	T	14134	n113	IE1E	AA2_E	N	9900.00	9900.00	N	NULL	0	YE	2017-06-13 00:00:00	137274	 	NULL	NULL	NULL
74343	1	2017-06-16 00:00:00	m1583	2017-06-16 00:00:00	N	T	17060003	GS00035279	72004	_	T	1234	n428	FE1	FE1	N	2400.00	0.00	N	NULL	0	NN	NULL	0	 	NULL	NULL	NULL
74344	1	2017-06-16 00:00:00	m1583	2017-06-16 00:00:00	N	T	17060004	GS00035280	72005	_	T	1234	n428	FE4	FE4	N	2400.00	0.00	N	NULL	0	NN	NULL	0	 	NULL	NULL	NULL
74345	1	2017-06-16 10:41:00	m1583	2017-06-16 00:00:00	N	P	17060002	GS17000012	40001	_	T	12345	n100	IE1	AA1_E	N	2900.00	2900.00	N	NULL	0	YE	2017-06-19 00:00:00	137276	 	NULL	NULL	NULL
74346	1	2017-06-16 10:52:00	m1583	2017-06-16 00:00:00	N	P	17060001	GS17000013	40002	_	T	14969	n100	UE1	AA3_E	N	2400.00	2400.00	N	NULL	0	YE	2017-06-19 00:00:00	137277	 	NULL	NULL	NULL
74347	1	2017-06-16 11:03:00	m1583	2017-06-16 00:00:00	N	P	15030303	GS17000014	1009	M	T	12293	n113	WS2	AK2	X	16000.00	16000.00	N	NULL	0	YE	2017-06-19 00:00:00	137278	 	NULL	NULL	NULL
74348	1	2017-06-16 11:27:00	m1583	2017-06-16 00:00:00	N	P	15020256	GS17000015	1032	M	T	12293	n113	WS2	AK2	X	8000.00	8000.00	N	NULL	0	YE	2017-06-19 00:00:00	137279	 	NULL	NULL	NULL
74349	1	2017-07-03 00:00:00	m1583	2017-07-03 00:00:00	N	T	17070001	GS00035281	72006	_	T	7189	n428	FE1	FE1	N	2400.00	2400.00	N	NULL	0	YE	2017-07-04 00:00:00	99976	 	NULL	NULL	NULL
74350	1	2017-07-03 00:00:00	m1583	2017-07-03 00:00:00	N	T	17070002	GS00035282	72007	_	T	7189	n428	FE1	FE1	N	2400.00	2400.00	N	NULL	0	YE	2017-07-04 00:00:00	99977	 	NULL	NULL	NULL
74351	1	2017-07-03 00:00:00	m1583	2017-07-03 00:00:00	N	T	17070003	GS00035283	72008	_	T	1624	n428	FE1	FE1	N	2400.00	2400.00	N	NULL	0	YE	2017-07-04 00:00:00	99978	 	NULL	NULL	NULL
74352	1	2017-07-03 13:53:00	m1583	2017-07-03 00:00:00	N	P	15070052	GS17000016	1012	M	T	12330	n113	WS2	AK2	X	8000.00	8000.00	N	NULL	0	YE	2017-07-04 00:00:00	137292	 	19060001	2019-07-02 11:40:08.617	PA01A05
74353	1	2017-07-03 13:55:00	m1583	2017-07-03 00:00:00	N	P	15060231	GS17000017	1071	M	T	12293	n113	WS2	AK2	X	5000.00	5000.00	N	NULL	0	YE	2017-07-04 00:00:00	137293	 	NULL	NULL	NULL
74354	1	2017-07-03 14:24:00	m1583	2017-07-03 00:00:00	N	P	17070001	GS17000018	40004	_	T	7189	n100	IE1	AA1_E	N	2900.00	2900.00	N	NULL	0	YE	2017-07-06 00:00:00	137294	 	NULL	NULL	NULL
74355	1	2017-07-03 14:38:00	m1583	2017-07-03 00:00:00	N	P	17070003	GS17000019	40006	_	T	7189	n100	IE1	AA1_E	N	2900.00	2900.00	N	NULL	0	YE	2017-07-06 00:00:00	137295	 	NULL	NULL	NULL
74356	1	2017-07-03 14:38:00	m1583	2017-07-03 00:00:00	N	P	17070004	GS17000020	40007	_	T	7189	n100	IE1	AA1_E	N	2900.00	2900.00	N	NULL	0	YE	2017-07-06 00:00:00	137296	 	NULL	NULL	NULL
74357	1	2017-08-04 10:13:00	m1583	2017-06-03 00:00:00	N	P	15070210	GS17000006	16738	_	T	4898	n896	WS2	AK2	N	48000.00	0.00	N	NULL	0	NN	NULL	0	 	NULL	NULL	NULL
74360	1	2017-08-04 00:00:00	m1583	2017-05-25 00:00:00	N	T	16060003	GS00035275	66814	_	T	1624	n428	FE1	FE1	N	2400.00	0.00	N	NULL	0	NN	NULL	0	 	NULL	NULL	NULL
74361	1	2017-08-10 15:31:00	m1583	2017-08-10 00:00:00	N	P	17010017	GS17000021	40008	_	T	1624	n100	IE1	AA1_E	N	2900.00	0.00	N	NULL	0	NN	NULL	0	 	19060001	2019-07-02 11:40:08.617	PA01A05
74364	1	2017-09-05 00:00:00	m1583	2017-09-05 00:00:00	N	T	16080007	GS00035284	66821	_	T	1624	n428	FE6	FE6	N	2400.00	0.00	N	NULL	0	NN	NULL	0	 	19060001	2019-07-02 11:40:08.623	PA01A05
74365	1	2017-09-05 00:00:00	m1583	2017-09-05 00:00:00	N	T	16080008	GS00035285	66822	_	T	1624	n428	FE7	FE7	N	2400.00	0.00	N	NULL	0	NN	NULL	0	 	19060001	2019-07-02 11:40:08.623	PA01A05
74366	1	2017-09-05 00:00:00	m1583	2017-09-05 00:00:00	N	T	16080009	GS00035286	66823	_	T	1624	n428	FE8	FE8	N	2400.00	0.00	N	NULL	0	NN	NULL	0	 	19060001	2019-07-02 11:40:08.623	PA01A05
74367	1	2017-09-05 14:22:00	m1583	2017-09-05 00:00:00	N	P	17030001	GS17000022	30004	_	T	1624	n113	IW4	AA1_E	N	2400.00	2400.00	N	NULL	0	YE	2017-09-05 00:00:00	137320	 	19060001	2019-07-02 11:40:08.617	PA01A05
74368	1	2017-09-05 15:12:00	m1583	2017-09-05 00:00:00	N	P	15070163	GS17000023	28719	_	T	14969	n896	UE1	AA3_E	N	2400.00	2400.00	N	NULL	0	YE	2017-09-05 00:00:00	137321	 	19060001	2019-07-02 11:40:08.617	PA01A05
74369	1	2017-09-05 15:23:00	m1583	2017-09-05 00:00:00	N	P	17010018	GS17000024	30001	_	T	1624	n100	IE1	AA1_E	N	2400.00	2400.00	N	NULL	0	YE	2017-09-05 00:00:00	137322	 	19060001	2019-07-02 11:40:08.617	PA01A05
74371	1	2017-10-05 14:13:00	m1583	2017-06-02 00:00:00	N	P	15120003	GS17000002	28737	_	T	15465	n113	IG1	AA1	N	3500.00	0.00	N	NULL	0	NN	NULL	0	 	19060001	2019-07-02 11:40:08.617	PA01A05
74374	1	2017-12-11 00:00:00	m802	2017-07-26 00:00:00	N	T	16090014	GS00035287	66842	_	T	1624	n428	FL1	FL1	N	2000.00	0.00	N	NULL	0	NN	NULL	0	 	19060001	2019-07-02 11:40:08.623	PA01A05
74388	1	2018-07-17 00:00:00	m1583	2018-07-17 00:00:00	N	T	18070001	GS00035289	72033	_	T	1624	n428	FF0	FF0	N	2500.00	2500.00	N	NULL	0	YE	2018-07-17 00:00:00	100006	 	19060001	2019-07-02 11:40:08.623	PA01A05
74393	1	2018-07-17 00:00:00	m1583	2018-07-17 00:00:00	N	T	18070002	GS00035290	72034	_	T	1624	n428	FF0	FF0	N	2500.00	2500.00	N	NULL	0	YE	2018-07-17 00:00:00	100008	 	19060001	2019-07-02 11:40:08.623	PA01A05
74401	1	2018-07-25 00:00:00	m1583	2018-07-25 00:00:00	N	T	18070009	GS00035291	72038	_	T	1034	n428	FF0	FF0	N	2500.00	2500.00	N	NULL	0	YE	2018-07-25 00:00:00	100043	 	19060001	2019-07-02 11:40:08.623	PA01A05
74402	1	2018-07-25 00:00:00	m1583	2018-07-25 00:00:00	N	T	18070010	GS00035292	72039	_	T	7718	n428	FF0	FF0	N	2500.00	2500.00	N	NULL	0	YE	2018-07-25 00:00:00	100044	 	19060001	2019-07-02 11:40:08.623	PA01A05
74403	1	2018-07-25 00:00:00	m1583	2018-07-25 00:00:00	N	T	18070011	GS00035293	72040	_	T	1624	n428	FF0	FF0	N	2500.00	2500.00	N	NULL	0	YE	2018-07-25 00:00:00	100045	 	19060001	2019-07-02 11:40:08.623	PA01A05
74471	1	2018-08-03 00:00:00	m1583	2018-08-03 00:00:00	N	T	18080003	GS00035297	72042	_	T	14558	n428	FF0	FF0	N	2500.00	2500.00	Y	2019-07-02 00:00:00.000	343336	YE	2018-08-03 00:00:00	100113	 	19060001	2019-07-02 11:40:08.623	PA01A05
74472	1	2018-08-03 00:00:00	m1583	2018-08-03 00:00:00	N	T	18080002	GS00035298	72043	_	T	6857	n428	FF0	FF0	N	2500.00	2500.00	Y	2019-07-02 00:00:00.000	343337	YE	2018-08-03 00:00:00	100114	 	19060001	2019-07-02 11:40:08.623	PA01A05
74473	1	2018-08-03 00:00:00	m1583	2018-08-03 00:00:00	N	T	18080001	GS00035299	72044	_	T	15930	n428	FF0	FF0	N	2500.00	2500.00	Y	2019-07-02 00:00:00.000	343338	YE	2018-08-03 00:00:00	100115	 	19060001	2019-07-02 11:40:08.623	PA01A05
74476	1	2018-08-03 00:00:00	m1583	2018-08-03 00:00:00	N	T	18070005	GS00035295	72035	_	T	1624	n428	FF0	FF0	N	20000.00	20000.00	Y	2019-07-02 00:00:00.000	343339	YE	2018-08-03 00:00:00	100111	 	19060001	2019-07-02 11:40:08.623	PA01A05
74478	1	2018-08-03 00:00:00	m1583	2018-08-03 00:00:00	N	T	18070004	GS00035296	72036	_	T	1624	n428	FF0	FF0	N	2500.00	2500.00	Y	2019-07-02 00:00:00.000	343340	YE	2018-08-03 00:00:00	100112	 	19060001	2019-07-02 11:40:08.623	PA01A05
74479	1	2018-08-03 00:00:00	m1583	2018-08-03 00:00:00	N	T	18070007	GS00035294	72037	_	T	1624	n428	FF0	FF0	N	2500.00	2500.00	Y	2019-07-02 00:00:00.000	343341	YE	2018-08-03 00:00:00	100108	 	19060001	2019-07-02 11:40:08.623	PA01A05
74485	1	2018-08-20 00:00:00	m1583	2018-08-20 00:00:00	N	T	18010003	GS00035300	72012	_	T	1624	n428	FF0	FF0	N	2500.00	2500.00	N	NULL	0	XX	2018-08-20 00:00:00	100124	 	19060001	2019-07-02 11:40:08.623	PA01A05
74488	1	2018-08-21 00:00:00	m1583	2018-08-21 00:00:00	N	T	18070009	GS00035301	72038	_	T	1034	n428	FF0	FF0	N	2500.00	2500.00	N	NULL	0	XX	2018-08-21 00:00:00	100127	 	19060001	2019-07-02 11:40:08.623	PA01A05
74491	1	2018-08-27 00:00:00	m1583	2018-08-27 00:00:00	N	T	18080007	BGS0004270	72046	_	T	1624	n428	DO1	DO1	N	4000.00	0.00	N	NULL	0	NN	NULL	0	 	19060001	2019-07-02 11:40:08.623	PA01A05
74495	1	2019-02-13 17:18:00	m802	2019-02-13 00:00:00	N	P	15040336	GS19000001	1041	Z	T	7552	n1125	FL1	AM1	N	2000.00	0.00	N	NULL	0	NN	NULL	0	 	19060001	2019-07-02 11:40:08.617	PA01A05

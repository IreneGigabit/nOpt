
select * from case_opt 
--update case_opt set send_way='M',receipt_type='P',receipt_title='B'
where send_way is null

select * from sysctrl

--複製群組使用者
--insert into sysctrl 
select scode,branch,dept,sysdefault,'NOpt',logingrp,beg_date,end_date,null,null,null
from sysctrl where syscode='opt'

--複製群組權限
--insert into loginap 
select 'NOpt',loginGrp,apcode,rights,beg_date,end_date,tran_date,'m1583'
from loginap where syscode='opt'



insert into sysctrl
select scode,branch,dept,sysdefault,'NOpt',logingrp,beg_date,end_date,null,null,null
from web02.sysctrl.dbo.sysctrl where syscode='nopt' and scode in('m1583')

insert into sysctrl
select scode,branch,dept,sysdefault,syscode,logingrp,beg_date,end_date,null,null,null
from web02.sysctrl.dbo.sysctrl where syscode='opt' and scode in('m1583')


--區所程式
--\\web02\wwwroot$\Btbrt\Brt1m\Brt18Update.asp
--\\web02\wwwroot$\Btbrt\brtam\brta33List.asp.asp

--電子送件程式
--\\web08\wwwroot$\Nopt\ajax\json_sendway.aspx(48):            SQL += "where code_type='GSEND_WAY' ";
--\\web08\wwwroot$\Nopt\commonForm\opt\BR_formA.ascx(18):            tfy_send_way = SHtml.Option(connB, "select cust_code,code_name from cust_code where code_type='GSEND_WAY' and cust_code='M' order by sortfld", "{cust_code}", "{code_name}");
--\\web08\wwwroot$\Nopt\commonForm\opt\case_form.ascx(23):            tfy_send_way = SHtml.Option(connB, "select cust_code,code_name from cust_code where code_type='GSEND_WAY'and cust_code='M' order by sortfld", "{cust_code}", "{code_name}");
--\\web08\wwwroot$\Nopt\commonForm\opt\Send_form.ascx(21):            send_way = SHtml.Option(connB, "select cust_code,code_name from cust_code where code_type='GSEND_WAY' and cust_code='M' order by sortfld", "{cust_code}", "{code_name}");


USE [sikopt]
GO

/****** Object:  Table [dbo].[attachtemp_opt]    Script Date: 2020/7/31 下午 02:24:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[attachtemp_opt](
	[temp_sqlno] [int] IDENTITY(1,1) NOT NULL,
	[syscode] [varchar](10) NOT NULL,
	[apcode] [varchar](10) NOT NULL,
	[branch] [varchar](2) NOT NULL,
	[dept] [varchar](5) NOT NULL,
	[opt_sqlno] [int] NOT NULL,
	[attach_no] [int] NOT NULL,
	[in_date] [datetime] NULL,
	[in_scode] [varchar](5) NULL,
	[tran_date] [smalldatetime] NULL,
	[tran_scode] [varchar](5) NULL,
	[remark] [varchar](255) NULL,
 CONSTRAINT [PK_attachtemp_tech] PRIMARY KEY CLUSTERED 
(
	[temp_sqlno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO




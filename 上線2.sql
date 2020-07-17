
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

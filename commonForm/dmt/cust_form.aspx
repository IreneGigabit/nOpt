<script runat="server">
    protected string MClass = "";
    protected string Cust_area = "";
    protected string Cust_seq = "";
    protected string Mdisabled = "";
    protected string SQL = "";
    protected string apclass = "";
    protected string apclassnm = "";
    protected string ref_seq = "";
    protected string ref_seqnm = "";
    protected string apcust_no = "";
    protected string cust_cname1 = "";
    protected string cust_cname2 = "";
    protected string cust_ename1 = "";
    protected string cust_ename2 = "";
    protected string ap_crep = "";
    protected string ap_erep = "";
    protected string ap_zip = "";
    protected string ap_addr1 = "";
    protected string ap_addr2 = "";
    protected string ap_eaddr1 = "";
    protected string ap_eaddr2 = "";
    protected string ap_eaddr3 = "";
    protected string ap_eaddr4 = "";
    protected string www = "";
    protected string email = "";
    protected string ap_tel = "";
    protected string ap_tel1 = "";
    protected string acc_zip = "";
    protected string acc_addr1 = "";
    protected string acc_addr2 = "";
    protected string acc_tel0 = "";
    protected string acc_tel1 = "";
    protected string acc_tel = "";
    protected string acc_fax = "";
    protected string magnm = "";
    protected string con_term = "";
    protected string cust_remark = "";
	protected string ap_country = "";
	protected string con_code = "";
	protected string plevel = "";
	protected string tlevel = "";
	protected string pdis_type = "";
	protected string ppay_type = "";
	protected string tdis_type = "";
    protected string tpay_type = "";
</script>

<table border="0" class=bluetable cellspacing="1" cellpadding="2" style="font-size: 9pt" width="100%">			
<TR>
	<TD class=lightbluetable align="right">客戶編號：</TD>
	<TD class=whitetablebg>
	<input TYPE="text" NAME="F_cust_area" SIZE="1" <%=MClass%>  value="<%=Cust_area%>">-
	<input TYPE="text" NAME="F_cust_seq" size="6"  <%=MClass%>  value="<%=Cust_seq%>">
	</TD>
	<TD class=lightbluetable  align="right">客戶國籍：</TD>
	<TD class=whitetablebg><Select id="F_ap_country" name="F_ap_country" size=1 <%=Mdisabled%>>
		<option value="" style="color:blue"></option>
		<%SQL="SELECT coun_code, coun_c FROM country where markb<>'X' ORDER BY coun_code";%>
	</SELECT></TD>
</TR>
<TR>
	<TD class=lightbluetable align=right width=16%>客戶種類：</TD>
	<TD class=whitetablebg><input type=text id="F_apclass" size="30" <%=MClass%> value="<%=apclass+" "+apclassnm%>"></TD>
	<TD class=lightbluetable  align="right" width="15%">客戶群組：</TD>
	<TD class=whitetablebg><INPUT TYPE=text id=F_ref_seq <%=MClass%> Value="<%=ref_seq+" "+ref_seqnm%>"></TD>
</TR>
<TR>
	<TD class=lightbluetable align=right>統一編號：</TD>
	<TD class=whitetablebg colspan=3><INPUT TYPE=text id="F_id_no" SIZE=12 MAXLENGTH=10 <%=MClass%> Value="<%=apcust_no%>"></TD>					
</TR>
<TR>		
	<TD class=lightbluetable align=right>客戶名稱：</TD>
	<TD class=whitetablebg colspan=3><INPUT TYPE=text id="F_ap_cname1" size=44 maxlength=60 <%=MClass%> value="<%=cust_cname1%>">
	<INPUT TYPE=text NAME="F_ap_cname2" size=44 maxlength=60 <%=MClass%> value="<%=cust_cname2%>"></TD>
</TR>
<TR>	
	<TD class=lightbluetable align=right>英文名稱：</TD>
	<TD class=whitetablebg colspan=3><INPUT TYPE=text id="F_ap_ename1" size=60 maxlength=100 <%=MClass%> value="<%=cust_ename1%>">
	<INPUT TYPE=text NAME="F_ap_ename2" size=60 maxlength=100 <%=MClass%> value="<%=cust_ename2%>"></TD>
</TR>
<TR>
	<TD class=lightbluetable align=right>代表人(中)：</TD>
	<TD class=whitetablebg colspan=3><INPUT TYPE=text id="F_ap_crep" SIZE=20 MAXLENGTH=20 <%=MClass%> value="<%=ap_crep%>"></TD>					
</TR>
<TR>
	<TD class=lightbluetable  align=right>代表人(英)：</TD>
	<TD class=whitetablebg colspan=3><INPUT TYPE=text id="F_ap_erep" size=40 maxlength=40 <%=MClass%> value="<%=ap_erep%>"></TD>
</TR>
<TR>	
	<TD class=lightbluetable align=right>証照地址(中)：</TD>
	<TD class=whitetablebg colspan=3>(<INPUT TYPE=text id=F_ap_zip size=8 maxlength=8 <%=MClass%> value="<%=ap_zip%>">)
	<INPUT TYPE=text id=F_ap_addr1 size=103 maxlength=120 <%=MClass%> value="<%=ap_addr1%>">
	<INPUT TYPE=text id=F_ap_addr2 size=103 maxlength=120 <%=MClass%> value="<%=ap_addr2%>"></TD>
</TR>		
<TR>	
	<TD class=lightbluetable align=right>登記地址(英)：</TD>
	<TD class=whitetablebg colspan=3><INPUT TYPE=text id=F_ap_eaddr1 size=103 maxlength=120 <%=MClass%> value="<%=ap_eaddr1%>"><br>
	<INPUT TYPE=text id=F_ap_eaddr2 size=103 maxlength=120 <%=MClass%> value="<%=ap_eaddr2%>"><br>
	<INPUT TYPE=text id=F_ap_eaddr3 size=103 maxlength=120 <%=MClass%> value="<%=ap_eaddr3%>"><br>
	<INPUT TYPE=text id=F_ap_eaddr4 size=103 maxlength=120 <%=MClass%> value="<%=ap_eaddr4%>"></TD>
</TR>
<TR>		  
	<TD class=lightbluetable align="right">公司網址：</TD>
	<TD class=whitetablebg colspan=3><INPUT TYPE=text id=F_www SIZE=40 MAXLENGTH=40 <%=MClass%> value="<%=www%>"></TD>
</TR>
<TR>  
	<TD class=lightbluetable align="right">公司電子郵件：</TD>		  
	<TD class=whitetablebg colspan=3><INPUT TYPE=text id=F_email SIZE=40 MAXLENGTH=40 <%=MClass%> value="<%=email%>"></TD>		  
</TR>
<TR>		  
	<TD class=lightbluetable align="right">對帳地址：</TD>
	<TD class=whitetablebg colspan=3>(<INPUT TYPE=text id=F_acc_zip size=8 maxlength=8 <%=MClass%> value="<%=acc_zip%>">)
	<input type="text" id="F_acc_addr1" size="47" maxlength="60" <%=MClass%> value="<%=acc_addr1%>">
	<input type="text" id="F_acc_addr2" size="47" maxlength="60" <%=MClass%> value="<%=acc_addr2%>"></TD>  		  
</TR>
<TR>
	<TD class=lightbluetable align="right">會計電話：</TD>
	<TD class=whitetablebg>(<INPUT TYPE=text id=F_acc_tel0 size=4 maxlength=4 <%=MClass%> value="<%=acc_tel0%>">)
	<INPUT TYPE=text id=F_acc_tel size=10 maxlength=10 <%=MClass%> value="<%=acc_tel%>">-
	<INPUT TYPE=text id=F_acc_tel1 size=5 maxlength=5 <%=MClass%> value="<%=acc_tel1%>"></TD>
	<TD class=lightbluetable align="right">會計傳真：</TD>
	<TD class=whitetablebg><INPUT TYPE=text id=F_acc_fax size=10 maxlength=15 <%=MClass%> value="<%=acc_fax%>"></TD>
</TR>
<TR>		  
	<TD class=lightbluetable align="right">郵寄雜誌：</TD>
	<TD class=whitetablebg colspan=3><INPUT TYPE=text id=F_mag size=10 maxlength=15 <%=MClass%> value="<%=magnm%>"></TD>
</TR>
<TR>
	<TD class=lightbluetable align="right">顧問種類：</TD>
	<TD class=whitetablebg><select id=F_con_code SIZE=1 <%=Mdisabled%>>
	<option value="" style="color:blue">請選擇</option>
	<%SQL="select cust_code,code_name from cust_code where code_type='H' order by cust_code";%>
	</SELECT></TD>
	<TD class=lightbluetable align="right">顧問迄日：</TD>
	<TD class=whitetablebg><INPUT TYPE=text id=F_con_term SIZE=10 <%=MClass%> value="<%=con_term%>"></TD>
</TR>
<TR>		  
	<TD class=lightbluetable align=right>專利客戶等級：</TD>
	<TD class=whitetablebg ><select id=F_plevel size=1 <%=Mdisabled%>>
		<option value="" style="color:blue">請選擇</option>
		<option value="A">大客戶</option>
		<option value="B">中客戶</option>
		<option value="C">小客戶</option>
		<option value="L">流失客戶</option>
		<option value="O">結束客戶</option>
	</SELECT></TD>
	<TD class=lightbluetable align=right>商標客戶等級：</TD>
	<TD class=whitetablebg><select id=F_tlevel size=1 <%=Mdisabled%>>
		<option value="" style="color:blue">請選擇</option>
		<option value="A">大客戶</option>
		<option value="B">中客戶</option>
		<option value="C">小客戶</option>
		<option value="L">流失客戶</option>
		<option value="O">結束客戶</option>
	</SELECT></TD>	
</TR>
<TR>
	<TD class=lightbluetable align=right>專利折扣代碼：</TD>
	<TD class=whitetablebg><Select id=F_pdis_type size=1 <%=Mdisabled%>>
		<option value="" style="color:blue">請選擇</option>
		<%SQL="select cust_code,code_name from cust_code where code_type='Discount' order by cust_code";%>
		</SELECT></TD>
<TD class=lightbluetable align=right>商標折扣代碼：</TD>
	<TD class=whitetablebg><Select id=F_tdis_type size=1 <%=Mdisabled%>>
		<option value="" style="color:blue">請選擇</option>
		<%SQL="select cust_code,code_name from cust_code where code_type='Discount' order by cust_code";%></option>
		</SELECT></TD>		
</TR>
<TR>
	<TD class=lightbluetable align=right>專利付款條件：</TD>
	<TD class=whitetablebg><Select id=F_ppay_type size=1 <%=Mdisabled%>>
		<option value="" style="color:blue">請選擇</option>
		<%SQL="select cust_code,code_name from cust_code where code_type='Payment' order by cust_code";%></option>
		</SELECT></TD>
	<TD class=lightbluetable align=right>商標付款條件：</TD>
	<TD class=whitetablebg><Select id=F_tpay_type size=1 <%=Mdisabled%>>
		<option value="" style="color:blue">請選擇</option>
		<%SQL="select cust_code,code_name from cust_code where code_type='Payment' order by cust_code";%>
		</SELECT></TD>
</TR>
<TR>
	<TD class=lightbluetable align=right>備註說明：</td>
	<TD class=whitetablebg colspan=3><textarea rows=5 cols=80 id=F_mark <%=MClass%>><%=cust_remark%></textarea>
</TR>		        
</table>
<script>
/*
function Cust_onLoad(){
	getoption reg.F_ap_country,"<%=ap_country%>"
	getoption reg.F_con_code,"<%=con_code%>"
	getoption reg.F_plevel,"<%=plevel%>"
	getoption reg.F_tlevel,"<%=tlevel%>"
	getoption reg.F_pdis_type,"<%=pdis_type%>"
	getoption reg.F_ppay_type,"<%=ppay_type%>"
	getoption reg.F_tdis_type,"<%=tdis_type%>"
	getoption reg.F_tpay_type,"<%=tpay_type%>"
}
*/
</script>
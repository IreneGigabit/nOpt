<%@ Control Language="C#" ClassName="attent_form" %>

<script runat="server">
    protected string Dept = "";
    protected string att_title = "";
    protected string att_dept = "";
    protected string att_tel = "";
    protected string att_tel0 = "";
    protected string att_tel1 = "";
    protected string att_mobile = "";
    protected string att_fax = "";
    protected string att_zip = "";
    protected string att_addr1 = "";
    protected string att_addr2 = "";
    protected string Att_email = "";
    protected string Tmag = "";
    protected string att_sql="";
</script>

<table border="0" class="bluetable" cellspacing="1" cellpadding="2" style="font-size: 9pt" width="100%">
	<TR>
		<td class="lightbluetable" align="right">客戶編號：</td>
		<td class="whitetablebg" colspan=3>
		<input TYPE="text" NAME="tfy_cust_area" SIZE="1" <%=MClass%>  value="<%=Cust_area%>">-	  
		<input TYPE="text" NAME="tfy_cust_seq" size="8" <%=MClass%>  value="<%=Cust_seq%>"></td>					
	</TR>			
	<TR>
		<td class="lightbluetable" align="right">聯絡人：</td>
		<td class="whitetablebg"><select NAME=tfy_att_sql SIZE="1" <%=Mdisabled%>>
			<option value="" style="color:blue">請選擇</option>
			<%SQL="SELECT Att_sql, Attention FROM custz_Att "+
			"where Cust_area='" + Cust_area + "' and (Cust_seq ='" + Cust_seq+ "')";%>
		</select>
		<TD class=lightbluetable align=right>所屬部門：</TD>
		<TD class=whitetablebg><INPUT TYPE=text id=dept name=dept <%=MClass%>  value="<%=Dept%>"></TD>
	</TR>
	<TR>
		<TD class=lightbluetable align=right>職稱：</TD>
		<TD class=whitetablebg><INPUT TYPE=text id=att_title SIZE=11 MAXLENGTH=10 <%=MClass%>  value="<%=att_title%>"></TD>		
		<TD class=lightbluetable align=right>聯絡部門：</TD>
		<TD class=whitetablebg><INPUT TYPE=text id=att_dept SIZE=22 MAXLENGTH=20 <%=MClass%>  value="<%=att_dept%>"></TD>
	</TR>
	<TR>
		<TD class=lightbluetable align=right>聯絡電話：</TD>
		<TD class=whitetablebg colspan=3>(<INPUT TYPE=text name=att_tel0 SIZE=4 MAXLENGTH=4 <%=MClass%>  value="<%=att_tel0%>">)
		<INPUT TYPE=text id=att_tel SIZE=16 MAXLENGTH=15 <%=MClass%>  value="<%=att_tel%>">-<INPUT TYPE=text id=att_tel1 SIZE=5 MAXLENGTH=5 <%=MClass%>  value="<%=att_tel1%>"></TD>
	</TR>
	<TR>
		<TD class=lightbluetable align=right>行動電話：</TD>
		<TD class=whitetablebg><INPUT TYPE=text id=att_mobile SIZE=11 MAXLENGTH=10 <%=MClass%>  value="<%=att_mobile%>"></TD>		
		<TD class=lightbluetable align=right>傳真號碼：</TD>
		<TD class=whitetablebg><INPUT TYPE=text id=att_fax SIZE=16 MAXLENGTH=15 <%=MClass%>  value="<%=att_fax%>"></TD>
	</TR>
	<TR>
		<TD class=lightbluetable align=right>聯絡地址：</TD>
		<TD class=whitetablebg colspan=3>
		<INPUT TYPE=text id=att_zip SIZE=5 MAXLENGTH=5 <%=MClass%>  value="<%=att_zip%>">
		<INPUT TYPE=text id=att_addr1 SIZE=33 MAXLENGTH=30 <%=MClass%>  value="<%=att_addr1%>">
		<INPUT TYPE=text id=att_addr2 SIZE=33 MAXLENGTH=30 <%=MClass%>  value="<%=att_addr2%>"></TD>
	</TR>
	<TR>
		<TD class=lightbluetable align=right>電子郵件：</TD>
		<TD class=whitetablebg colspan=3><INPUT TYPE=text id=Att_email SIZE=44 MAXLENGTH=40 <%=MClass%>  value="<%=Att_email%>"></TD>
	</TR>
	<TR>
		<TD class=lightbluetable align=right>郵寄雜誌：</TD>
		<TD class=whitetablebg colspan=3><INPUT TYPE=text id=att_mag size=22 <%=MClass%>  value="<%=Tmag%>"></TD>				  
	</TR>		
</table>
<script>
/*
function CustAtt_onLoad(){
	getoption reg.tfy_att_sql,"<%=att_sql%>"
}
*/
</script>

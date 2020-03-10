<%@ Control Language="C#" ClassName="cust_re_form" %>

<script runat="server">
    protected string html_apclass = "";//Select cust_code,code_name from cust_code where code_type='apclass' order by sortfld ShowSelect2(ConnB,aSQL,false,"Y")
    protected string html_country = "";//select coun_code,coun_c from country where markb<>'X' ShowSelect2(Cnn,cSQL,false,"Y")
    
    protected string prgid = HttpContext.Current.Request["prgid"];//功能權限代碼
    protected string SQL = "";

    protected string branch = "";
    protected string opt_sqlno = "";

    private void Page_Load(System.Object sender, System.EventArgs e) {
        branch = Request["branch"] ?? "";
        opt_sqlno = Request["opt_sqlno"] ?? "";

        this.DataBind();
    }
</script>


<input type=text id=apnum name=apnum value=0><!--筆數-->
<table border="0" id=tabap_re class="bluetable" cellspacing="1" cellpadding="2" style="font-size: 9pt" width="100%">
	<TFOOT>
	<TR>
		<TD class=whitetablebg colspan=4 align=right>
			<input type=button value ="增加一筆申請人" class="cbutton" id=AP_Add_button name=AP_Add_button>
			<input type=button value ="減少一筆申請人" class="cbutton" id=AP_Del_button name=AP_Del_button onclick="deleteAP(reg.apnum.value)">
		</TD>
	</TR>
	</TFOOT>
	<THEAD>
		<TR>
			<TD class=lightbluetable align=right>
				<input type=text id="apnum_##" name="apnum_##" class="Lock" size=2>申請人種類：
			</TD>
			<TD class=sfont9>
				<select id="apclass_##" name="apclass_##" class="Lock"></select>
                <input type="checkbox" id="ap_hserver_flag_##" name="ap_hserver_flag_##" value="Y" onclick="apserver_flag('_##')" class="Lock">註記此申請人為應受送達人
                <input type="hidden" id="ap_server_flag_##" name="ap_server_flag_##" value="N">
			</TD>
			<TD class=lightbluetable align=right title="輸入編號並點選確定，即顯示申請人資料；若無資料，請直接輸入申請人資料。">
				<span id="span_Apcust_no_##" style="cursor:pointer;color:blue">申請人編號<br>(統一編號/身份證字號)：</span>
			</TD>
			<TD class=sfont9>
				<input type=text id="Apcust_no_##" name="Apcust_no_##" size=11 maxlength=10 onblur="chkapcust_no('_##')" class="Lock">
			</TD>
		</TR>
		<TR>
			<TD class=lightbluetable align=right>申請人國籍：</TD>
			<TD class=sfont9 colspan=3><select id="ap_country_##" name="ap_country_##" class="Lock"></select></TD>
		</TR>
		<TR>
			<TD class=lightbluetable align=right>申請人名稱(中)：</TD>
			<TD class=sfont9 colspan=3>
                <input type=text id="ap_cname_##" name="ap_cname_##">
		        <INPUT TYPE=text id="ap_cname1_##" name="ap_cname1_##" SIZE=40 MAXLENGTH=60 alt="申請人名稱(中)" onblur="fDataLen(this.value,this.maxlength,this.alt)" class="Lock"><br>
		        <INPUT TYPE=text id="ap_cname2_##" name="ap_cname2_##" SIZE=40 MAXLENGTH=60 alt="申請人名稱(中)" onblur="fDataLen(this.value,this.maxlength,this.alt)" class="Lock">
			</TD>
		</TR>
		<TR>
			<TD class=lightbluetable align=right>申請人名稱(中)：</TD>
			<TD class=sfont9 colspan=3>
		        姓：<INPUT TYPE=text id="ap_fcname_##" name="ap_fcname_##" SIZE=20 MAXLENGTH=60 class="Lock">
		        名：<INPUT TYPE=text id="ap_lcname_##" name="ap_lcname_##" SIZE=20 MAXLENGTH=60 class="Lock">
			</TD>
		</TR>
		<TR id="trap_sql_##">
			<TD class=lightbluetable align=right>申請人序號：</TD>
			<TD class=sfont9 colspan=3>
		        <INPUT TYPE=text id="ap_sql##" name="ap_sql##" SIZE=3 MAXLENGTH=3 class="Lock">
			</TD>
		</TR>
		<TR>
			<TD class=lightbluetable align=right>申請人名稱(英)：</TD>
			<TD class=sfont9 colspan=3>
                <input type=text id="ap_ename_##" name="ap_ename_##">
		        <INPUT TYPE=text id="ap_ename1_##" name="ap_ename1_##" SIZE=60 MAXLENGTH=100 alt="申請人名稱(英)" onblur="fDataLen(this.value,this.maxlength,this.alt)" class="Lock"><br>
		        <INPUT TYPE=text id="ap_ename2_##" name="ap_ename2_##" SIZE=60 MAXLENGTH=100 alt="申請人名稱(英)" onblur="fDataLen(this.value,this.maxlength,this.alt)" class="Lock">
			</TD>
		</TR>
		<TR>
			<TD class=lightbluetable align=right>申請人名稱(英)：</TD>
			<TD class=sfont9 colspan=3>
		        姓：<INPUT TYPE=text id="ap_fename_##" name="ap_fename_##" SIZE=20 MAXLENGTH=60 class="Lock">
		        名：<INPUT TYPE=text id="ap_lename_##" name="ap_lename_##" SIZE=20 MAXLENGTH=60 class="Lock">
			</TD>
		</TR>
		<TR>
			<TD class=lightbluetable align=right>代表人名稱(中)：</TD>
			<TD class=sfont9 colspan=3>
		        <INPUT TYPE=text id="ap_crep_##" name="ap_crep_##" SIZE=40 MAXLENGTH=40 class="Lock">
			</TD>
		</TR>
		<TR>
			<TD class=lightbluetable align=right>代表人名稱(英)：</TD>
			<TD class=sfont9 colspan=3>
		        <INPUT TYPE=text id="ap_erep_##" name="ap_erep_##" SIZE=80 MAXLENGTH=80 class="Lock">
			</TD>
		</TR>
		<TR>
			<TD class=lightbluetable align=right>證照地址(中)：</TD>
			<TD class=sfont9 colspan=3>
		        <INPUT TYPE=text id="ap_zip_##" name="ap_zip_##" SIZE=8 MAXLENGTH=8 class="Lock">
		        <INPUT TYPE=text id="ap_addr1_##" name="ap_addr1_##" SIZE=103 MAXLENGTH=120 class="Lock"><br>
		        <INPUT TYPE=text id="ap_addr2_##" name="ap_addr2_##" SIZE=103 MAXLENGTH=120 class="Lock">
			</TD>
		</TR>
		<TR>
			<TD class=lightbluetable align=right>證照地址(英)：</TD>
			<TD class=sfont9 colspan=3>
		        <INPUT TYPE=text id="ap_eaddr1_##" name="ap_eaddr1_##" SIZE=103 MAXLENGTH=120 class="Lock"><br>
		        <INPUT TYPE=text id="ap_eaddr2_##" name="ap_eaddr2_##" SIZE=103 MAXLENGTH=120 class="Lock"><br>
		        <INPUT TYPE=text id="ap_eaddr3_##" name="ap_eaddr3_##" SIZE=103 MAXLENGTH=120 class="Lock"><br>
		        <INPUT TYPE=text id="ap_eaddr4_##" name="ap_eaddr4_##" SIZE=103 MAXLENGTH=120 class="Lock">
			</TD>
		</TR>
		<TR>
			<TD class=lightbluetable align=right>聯絡地址：</TD>
			<TD class=sfont9 colspan=3>
		        <INPUT TYPE=text id="apatt_zip_##" name="apatt_zip_##" SIZE=5 MAXLENGTH=5 class="Lock">
		        <INPUT TYPE=text id="apatt_addr1_##" name="apatt_addr1_##" SIZE=30 MAXLENGTH=60 class="Lock">
		        <INPUT TYPE=text id="apatt_addr2_##" name="apatt_addr2_##" SIZE=30 MAXLENGTH=60 class="Lock">
			</TD>
		</TR>
		<TR>
			<TD class=lightbluetable align=right>電話：</TD>
			<TD class=sfont9>
                <INPUT TYPE=text id="apatt_tel0_##" name="apatt_tel0_##" SIZE=4 MAXLENGTH=4 class="Lock">
                <INPUT TYPE=text id="apatt_tel_##" name="apatt_tel_##" SIZE=15 MAXLENGTH=15 class="Lock">
                <INPUT TYPE=text id="apatt_tel1_##" name="apatt_tel1_##" SIZE=10 MAXLENGTH=10 class="Lock">
			</TD>
			<TD class=lightbluetable align=right>傳真：</TD>
			<TD class=sfont9>
				<INPUT TYPE=text id="apatt_fax_##" name="apatt_fax_##" SIZE=20 MAXLENGTH=20 class="Lock">
			</TD>
		</TR>
	</THEAD>
	<TBODY>
	</TBODY>
</table>

<script language="javascript" type="text/javascript">
    var apcust_re={};
    apcust_re.init = function () {
    };
</script>

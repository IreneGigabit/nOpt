<script runat="server">
    protected string  html_apclass = "";//Select cust_code,code_name from cust_code where code_type='apclass' order by sortfld ShowSelect2(ConnB,aSQL,false,"Y")
    protected string html_country = "";//select coun_code,coun_c from country where markb<>'X' ShowSelect2(Cnn,cSQL,false,"Y")
</script>


<input type=hidden name=apnum value=0><!--進度筆數-->
<table border="0" id=tabap_re name=tabap_re class="bluetable" cellspacing="1" cellpadding="2" style="font-size: 9pt" width="100%">					
	<!--<TR>
		<TD  class=whitetablebg colspan=4 align=right>
			<input type=button value ="增加一筆申請人" class="cbutton" id=AP_Add_button name=AP_Add_button>			
			<input type=button value ="減少一筆申請人" class="cbutton" id=AP_Del_button name=AP_Del_button onclick="vbscript:deleteAP reg.apnum.value">
		</TD>
	</TR>-->
</table>

<script>
/*
Function Apcust_onLoad
    '抓取申請人資料
    call getapp()
End Function
function getapp()
    for i = 1 to reg.apnum.value
		deleteAP 1
	next
	dim xmldoc, root, x
	dim html
	url = "/opt/xml/xmlAppend_Co.asp?case_no=<%=Request["case_no"]%>&branch=<%=Request["branch"]%>&prgid=<%=prgid%>"
		
	set xmldoc = CreateObject("Microsoft.XMLDOM")
		xmldoc.async = false
	if xmldoc.load (url) then
			set root = xmldoc.documentElement
		if Root.childNodes.item(0).text = "Retry" then
			msgbox "無該申請人編號"
			set xmldoc = nothing
			set root = nothing
			exit function
		end if
		for each xi in root.childNodes	
			AP_Add_button_onclick()
			execute "reg.apsqlno"& reg.apnum.value &".value = xi.childNodes.item(21).text"
			execute "reg.Apclass"& reg.apnum.value &".value = xi.childNodes.item(0).text"
			execute "reg.Apcust_no"& reg.apnum.value &".value = xi.childNodes.item(23).text"
			execute "reg.Ap_country"& reg.apnum.value &".value = xi.childNodes.item(1).text"
			execute "reg.Ap_cname1_"& reg.apnum.value &".value = xi.childNodes.item(2).text"
			execute "reg.Ap_cname2_"& reg.apnum.value &".value = xi.childNodes.item(3).text"
			execute "reg.ap_cname"& reg.apnum.value &".value = reg.ap_cname1_"& reg.apnum.value &".value & reg.ap_cname2_"& reg.apnum.value &".value"								
			execute "reg.Ap_ename1_"& reg.apnum.value &".value = xi.childNodes.item(4).text"
			execute "reg.Ap_ename2_"& reg.apnum.value &".value = xi.childNodes.item(5).text"
			execute "reg.ap_ename"& reg.apnum.value &".value = reg.ap_ename1_"& reg.apnum.value &".value &""　""& reg.ap_ename2_"& reg.apnum.value &".value"
			execute "reg.ap_crep"& reg.apnum.value &".value = xi.childNodes.item(6).text"
			execute "reg.ap_erep"& reg.apnum.value &".value = xi.childNodes.item(7).text"
			execute "reg.ap_zip"& reg.apnum.value &".value = xi.childNodes.item(22).text"
			execute "reg.ap_addr1_"& reg.apnum.value &".value = xi.childNodes.item(8).text"
			execute "reg.ap_addr2_"& reg.apnum.value &".value = xi.childNodes.item(9).text"
			execute "reg.ap_eaddr1_"& reg.apnum.value &".value = xi.childNodes.item(10).text"
			execute "reg.ap_eaddr2_"& reg.apnum.value &".value = xi.childNodes.item(11).text"
			execute "reg.ap_eaddr3_"& reg.apnum.value &".value = xi.childNodes.item(12).text"
			execute "reg.ap_eaddr4_"& reg.apnum.value &".value = xi.childNodes.item(13).text"
			execute "reg.apatt_zip"& reg.apnum.value &".value = xi.childNodes.item(14).text"
			execute "reg.apatt_addr1_"& reg.apnum.value &".value = xi.childNodes.item(15).text"
			execute "reg.apatt_addr2_"& reg.apnum.value &".value = xi.childNodes.item(16).text"
			execute "reg.apatt_tel0_"& reg.apnum.value &".value = xi.childNodes.item(17).text"
			execute "reg.apatt_tel_"& reg.apnum.value &".value = xi.childNodes.item(18).text"
			execute "reg.apatt_tel1_"& reg.apnum.value &".value = xi.childNodes.item(19).text"
			execute "reg.apatt_fax"& reg.apnum.value &".value = xi.childNodes.item(20).text"
			IF xi.childNodes.item(24).text="Y" then
				execute "reg.ap_hserver_flag"& reg.apnum.value & ".checked=true"
			Else
				execute "reg.ap_hserver_flag"& reg.apnum.value & ".checked=false"
			End IF
			Call apserver_flag(reg.apnum.value)
			execute "reg.Ap_fcname_"& reg.apnum.value &".value = xi.childNodes.item(25).text"
			execute "reg.Ap_lcname_"& reg.apnum.value &".value = xi.childNodes.item(26).text"
			execute "reg.Ap_fename_"& reg.apnum.value &".value = xi.childNodes.item(27).text"
			execute "reg.Ap_lename_"& reg.apnum.value &".value = xi.childNodes.item(28).text"
			execute "reg.ap_sql" & reg.apnum.value & ".value = xi.childNodes.item(29).text"
			'申請人序號空值不顯示
			if isnull(xi.childNodes.item(29).text) or xi.childNodes.item(29).text=0 then
				execute "document.all.trap_sql" & reg.apnum.value & ".style.display=""none"""
			end if
		next		
	end if	
	set xmldoc = nothing
	set root = nothing
End function
function AP_Add_button_onclick()
	reg.apnum.value = reg.apnum.value + 1
	'alert reg.apnum.value
	'Row1
	set lRow = tabap_re.insertRow()
	lRow.classname = "sfont9"
	set lCell = lRow.insertCell()
	lCell.align = "right"
	lCell.classname = "lightbluetable"
	lCell.innerHTML = "<input type=text name='apnum" & reg.apnum.value & "' class=sedit readonly style='color:black;' size=2 value='" & reg.apnum.value &".'>申請人種類："
	set lCell = lRow.insertCell()
	lCell.align = "left"
	lCell.classname = "whitetablebg"
	lCell.innerHTML = "<select name='apclass" & reg.apnum.value & "' size=1 <%=Mdisabled%>><%=html_apclass%></select>"
	lCell.innerHTML = lCell.innerHTML & "<input type='checkbox' name='ap_hserver_flag"& reg.apnum.value &"' value='Y' onclick='vbscript:apserver_flag "& reg.apnum.value &"' <%=Mdisabled%>>註記此申請人為應受送達人"
	lCell.innerHTML = lCell.innerHTML & "<input type='hidden' name='ap_server_flag"& reg.apnum.value &"' value='N'>"
	set lCell = lRow.insertCell()
	lCell.align = "right"
	lCell.classname = "lightbluetable"
	lCell.title="輸入編號並點選確定，即顯示申請人資料；若無資料，請直接輸入申請人資料。"
	lCell.innerHTML = "<span id='span_Apcust_no"& reg.apnum.value &"' style='cursor:hand;color:blue'>申請人編號<br>(統一編號/身份證字號)：</span>"
	set lCell = lRow.insertCell()
	lCell.align = "left"
	lCell.classname = "whitetablebg"
	lCell.innerHTML = "<input type=text name='Apcust_no" & reg.apnum.value & "' size=11 maxlength=10 onblur='vbscript:chkapcust_no "& reg.apnum.value &"' <%=MClass%>>"
	
	'Row2
	set lRow = tabap_re.insertRow()
	lRow.classname = "sfont9"
	set lCell = lRow.insertCell()
	lCell.align = "right"
	lCell.classname = "lightbluetable"
	lCell.innerHTML = "申請人國籍："
	set lCell = lRow.insertCell()
	lCell.align = "left"
	lCell.classname = "whitetablebg"
	lCell.colspan="3"
	lCell.innerHTML = "<select name='ap_country" & reg.apnum.value & "' size=1 <%=Mdisabled%>><%=html_country%></select>"
	'Row3
	set lRow = tabap_re.insertRow()
	lRow.classname = "sfont9"
	set lCell = lRow.insertCell()
	lCell.align = "right"
	lCell.classname = "lightbluetable"
	lCell.innerHTML = "申請人名稱(中)："
	set lCell = lRow.insertCell()
	lCell.align = "left"
	lCell.classname = "whitetablebg"
	lCell.colspan="3"
	lCell.innerHTML = "<input type=hidden name='ap_cname"& reg.apnum.value &"'>"
	lCell.innerHTML = lCell.innerHTML & "<input type=hidden name='apsqlno"& reg.apnum.value &"'>"
	lCell.innerHTML = lCell.innerHTML & "<INPUT TYPE=text name='ap_cname1_"& reg.apnum.value &"' SIZE=40 MAXLENGTH=60 alt='申請人名稱(中)' onblur='vbscript:fDataLen me.value,me.maxlength,me.alt' <%=MClass%>><br>"
	lCell.innerHTML = lCell.innerHTML & "<INPUT TYPE=text name='ap_cname2_"& reg.apnum.value &"' SIZE=40 MAXLENGTH=60 alt='申請人名稱(中)' onblur='vbscript:fDataLen me.value,me.maxlength,me.alt' <%=MClass%>>"
	'Row4
	set lRow = tabap_re.insertRow()
	lRow.classname = "sfont9"
	set lCell = lRow.insertCell()
	lCell.align = "right"
	lCell.classname = "lightbluetable"
	lCell.innerHTML = "申請人名稱(中)："
	set lCell = lRow.insertCell()
	lCell.align = "left"
	lCell.classname = "whitetablebg"
	lCell.colspan="3"
	lCell.innerHTML = lCell.innerHTML & "姓：<INPUT TYPE=text name='ap_fcname_"& reg.apnum.value &"' SIZE=20 MAXLENGTH=60 class='sedit' readonly>"
	lCell.innerHTML = lCell.innerHTML & "名：<INPUT TYPE=text name='ap_lcname_"& reg.apnum.value &"' SIZE=20 MAXLENGTH=60 class='sedit' readonly>"
	'Row4
	set lRow = tabap_re.insertRow()
	lRow.id="trap_sql"&reg.apnum.value	
	lRow.classname = "sfont9"
	set lCell = lRow.insertCell()
	lCell.align = "right"
	lCell.classname = "lightbluetable"
	lCell.innerHTML = "申請人序號："
	set lCell = lRow.insertCell()
	lCell.align = "left"
	lCell.classname = "whitetablebg"
	lCell.colspan="3"
	lCell.innerHTML = lCell.innerHTML & "<INPUT TYPE=text name='ap_sql"& reg.apnum.value &"' SIZE=3 MAXLENGTH=3 class='sedit' readonly value=''>"
		
	'Row4
	set lRow = tabap_re.insertRow()
	lRow.classname = "sfont9"
	set lCell = lRow.insertCell()
	lCell.align = "right"
	lCell.classname = "lightbluetable"
	lCell.innerHTML = "申請人名稱(英)："
	set lCell = lRow.insertCell()
	lCell.align = "left"
	lCell.classname = "whitetablebg"
	lCell.colspan="3"
	lCell.innerHTML = "<input type=hidden name='ap_ename"& reg.apnum.value &"'>"
	lCell.innerHTML = lCell.innerHTML & "<INPUT TYPE=text name='ap_ename1_"& reg.apnum.value &"' SIZE=60 MAXLENGTH=100 alt='申請人名稱(英)' onblur='vbscript:fDataLen me.value,me.maxlength,me.alt' <%=MClass%>><br>"
	lCell.innerHTML = lCell.innerHTML & "<INPUT TYPE=text name='ap_ename2_"& reg.apnum.value &"' SIZE=60 MAXLENGTH=100 alt='申請人名稱(英)' onblur='vbscript:fDataLen me.value,me.maxlength,me.alt' <%=MClass%>>"
	'Row6
	set lRow = tabap_re.insertRow()
	lRow.classname = "sfont9"
	set lCell = lRow.insertCell()
	lCell.align = "right"
	lCell.classname = "lightbluetable"
	lCell.innerHTML = "申請人名稱(英)："
	set lCell = lRow.insertCell()
	lCell.align = "left"
	lCell.classname = "whitetablebg"
	lCell.colspan="3"
	lCell.innerHTML = lCell.innerHTML & "姓：<INPUT TYPE=text name='ap_fename_"& reg.apnum.value &"' SIZE=20 MAXLENGTH=60 class='sedit' readonly>"
	lCell.innerHTML = lCell.innerHTML & "名：<INPUT TYPE=text name='ap_lename_"& reg.apnum.value &"' SIZE=20 MAXLENGTH=60 class='sedit' readonly>"
	'Row5
	set lRow = tabap_re.insertRow()
	lRow.classname = "sfont9"
	set lCell = lRow.insertCell()
	lCell.align = "right"
	lCell.classname = "lightbluetable"
	lCell.innerHTML = "代表人名稱(中)："
	set lCell = lRow.insertCell()
	lCell.align = "left"
	lCell.classname = "whitetablebg"
	lCell.colspan="3"
	lCell.innerHTML = "<INPUT TYPE=text name=ap_crep"& reg.apnum.value &" SIZE=40 MAXLENGTH=40 <%=MClass%>>"
	'Row6
	set lRow = tabap_re.insertRow()
	lRow.classname = "sfont9"
	set lCell = lRow.insertCell()
	lCell.align = "right"
	lCell.classname = "lightbluetable"
	lCell.innerHTML = "代表人名稱(英)："
	set lCell = lRow.insertCell()
	lCell.align = "left"
	lCell.classname = "whitetablebg"
	lCell.colspan="3"
	lCell.innerHTML = "<INPUT TYPE=text name=ap_erep"& reg.apnum.value &" SIZE=80 MAXLENGTH=80 <%=MClass%>>"
	'Row7
	set lRow = tabap_re.insertRow()
	lRow.classname = "sfont9"
	set lCell = lRow.insertCell()
	lCell.align = "right"
	lCell.classname = "lightbluetable"
	lCell.innerHTML = "證照地址(中)："
	set lCell = lRow.insertCell()
	lCell.align = "left"
	lCell.classname = "whitetablebg"
	lCell.colspan="3"
	lCell.innerHTML = "<INPUT TYPE=text name=ap_zip"& reg.apnum.value &" SIZE=8 MAXLENGTH=8 <%=MClass%>>"
	lCell.innerHTML = lCell.innerHTML & "<INPUT TYPE=text name=ap_addr1_"& reg.apnum.value &" SIZE=103 MAXLENGTH=120 <%=MClass%>><br>"
	lCell.innerHTML = lCell.innerHTML & "<INPUT TYPE=text name=ap_addr2_"& reg.apnum.value &" SIZE=103 MAXLENGTH=120 <%=MClass%>>"
	'Row8
	set lRow = tabap_re.insertRow()
	lRow.classname = "sfont9"
	set lCell = lRow.insertCell()
	lCell.align = "right"
	lCell.classname = "lightbluetable"
	lCell.innerHTML = "證照地址(英)："
	set lCell = lRow.insertCell()
	lCell.align = "left"
	lCell.classname = "whitetablebg"
	lCell.colspan="3"
	lCell.innerHTML = "<INPUT TYPE=text name=ap_eaddr1_"& reg.apnum.value &" SIZE=103 MAXLENGTH=120 <%=MClass%>><br>"
	lCell.innerHTML = lCell.innerHTML & "<INPUT TYPE=text name=ap_eaddr2_"& reg.apnum.value &" SIZE=103 MAXLENGTH=120 <%=MClass%>><br>"
	lCell.innerHTML = lCell.innerHTML & "<INPUT TYPE=text name=ap_eaddr3_"& reg.apnum.value &" SIZE=103 MAXLENGTH=120 <%=MClass%>><br>"
	lCell.innerHTML = lCell.innerHTML & "<INPUT TYPE=text name=ap_eaddr4_"& reg.apnum.value &" SIZE=103 MAXLENGTH=120 <%=MClass%>>"
	'Row9
	set lRow = tabap_re.insertRow()
	lRow.classname = "sfont9"
	set lCell = lRow.insertCell()
	lCell.align = "right"
	lCell.classname = "lightbluetable"
	lCell.innerHTML = "聯絡地址："
	set lCell = lRow.insertCell()
	lCell.align = "left"
	lCell.classname = "whitetablebg"
	lCell.colspan="3"
	lCell.innerHTML = "<INPUT TYPE=text name=apatt_zip"& reg.apnum.value &" SIZE=5 MAXLENGTH=5 <%=MClass%>>"
	lCell.innerHTML = lCell.innerHTML & "<INPUT TYPE=text name=apatt_addr1_"& reg.apnum.value &" SIZE=30 MAXLENGTH=60 <%=MClass%>>"
	lCell.innerHTML = lCell.innerHTML & "<INPUT TYPE=text name=apatt_addr2_"& reg.apnum.value &" SIZE=30 MAXLENGTH=60 <%=MClass%>>"
	'Row10
	set lRow = tabap_re.insertRow()
	lRow.classname = "sfont9"
	set lCell = lRow.insertCell()
	lCell.align = "right"
	lCell.classname = "lightbluetable"
	lCell.innerHTML = "電話："
	set lCell = lRow.insertCell()
	lCell.align = "left"
	lCell.classname = "whitetablebg"
	lCell.innerHTML = "<INPUT TYPE=text name=apatt_tel0_"& reg.apnum.value &" SIZE=4 MAXLENGTH=4 <%=MClass%>>"
	lCell.innerHTML = lCell.innerHTML & "<INPUT TYPE=text name=apatt_tel_"& reg.apnum.value &" SIZE=15 MAXLENGTH=15 <%=MClass%>>"
	lCell.innerHTML = lCell.innerHTML & "<INPUT TYPE=text name=apatt_tel1_"& reg.apnum.value &" SIZE=10 MAXLENGTH=10 <%=MClass%>>"
	set lCell = lRow.insertCell()
	lCell.align = "right"
	lCell.classname = "lightbluetable"
	lCell.innerHTML = "傳真："
	set lCell = lRow.insertCell()
	lCell.align = "left"
	lCell.classname = "whitetablebg"
	lCell.innerHTML = "<INPUT TYPE=text name=apatt_fax"& reg.apnum.value &" SIZE=20 MAXLENGTH=20 <%=MClass%>>"
End Function
function deleteAP(papnum)
	dim i,j
	if reg.apnum.value=0 or papnum>reg.apnum.value then exit function
	for j = 1 to 13
		tabap_re.deleteRow((papnum*13)+1-j) '由0起
	next	
	reg.apnum.value = reg.apnum.value - 1
End Function
Function apserver_flag(papnum)
	IF eval("reg.ap_hserver_flag"& papnum &".checked")=true then
		execute "reg.ap_server_flag"& papnum &".value=""Y"""
	ElseIF eval("reg.ap_hserver_flag"& papnum &".checked")=false then
		execute "reg.ap_server_flag"& papnum &".value=""N"""
	End IF
End Function
*/
</script>
<%@ Control Language="C#" ClassName="case_form" %>

<script runat="server">
    protected string QDisabled = "";
    protected string branch = "";
    protected string arcase_type = "";
    protected string QClass = "";
    protected int MaxTaCount = 0;
    protected string Service = "";
    protected string Fees = "";
    protected string oth_money = "";
    protected string othSum = "";
    protected string Discount = "";
    protected string last_date = "";
    protected string remark = "";
    protected string QStyle = "";
    protected string in_scode = "";
	protected string arcase = "";
	protected string oth_code = "";
	protected string oth_arcase = "";
	protected string Ar_mark = "";
	protected string discount_chk = "";
	protected string Source = "";
	protected string Contract_type = "";
	protected string Contract_no = "";
	protected string opt_sqlno = "";
	protected string case_no = "";
</script>

  <TABLE border=0 class=bluetable cellspacing=1 cellpadding=2 width="100%">			
		<TR>
			<td class="lightbluetable" id=salename>洽案營洽 :</td>
			  <td class="whitetablebg"  align="left" colspan=3>
			 	  <select id="F_tscode" name="F_tscode" size="1" <%=QDisabled%>>
				  <%SQL="select distinct scode,sc_name,scode1 from sysctrl.dbo.vscode_roles where branch='"+ branch +"' and dept='T' and syscode='"+ branch +"Tbrt' and roles='sales' order by scode1 ";%>
				  </SELECT>		
			</td>
		  </TR>
		<TR>
		  <TD class=lightbluetable align=left colspan=4><strong>案性及費用：</strong></TD>
		</TR>
		  <TR>
	  	<TD class=whitetablebg align=center colspan=4>
			<TABLE border=0 class=bluetable cellspacing=1 cellpadding=2 >
				  <TD class=lightbluetable align=right width="4%">案&nbsp;&nbsp;&nbsp;&nbsp;性：</TD>
				  <TD class=whitetablebg width=10%><select TYPE=text NAME=tfy_Arcase SIZE=1 <%=QDisabled%>>
							<option value="" style="color:blue">請選擇</option>
							<%SQL="SELECT  rs_code,prt_code,rs_detail,remark FROM  code_br WHERE  (mark = 'B' )";
							  SQL+= " And  cr= 'Y' and dept='T' And rs_type='"+arcase_type+"' AND no_code='N' ";
							  SQL+= "and getdate() >= beg_date  ORDER BY rs_code";%>
					</SELECT></TD>
				  <TD class=lightbluetable align=right width=4%>服務費：</TD>
				  <TD class=whitetablebg  align="left"><INPUT TYPE=text NAME=nfyi_Service <%=QClass%> SIZE=8 maxlength=8 style="text-align:right;" ><INPUT TYPE=hidden NAME=Service></TD>		
				  <TD class=lightbluetable align=right width=4%>規費：</TD>
				  <TD class=whitetablebg align="left"><INPUT TYPE=text NAME=nfyi_Fees  <%=QClass%> size=8 maxlength=8 style="text-align:right;" ><INPUT TYPE=hidden NAME=Fees></TD>
				</TR>
				<%for(int i=0;i<=MaxTaCount;i++){%>
						<tr id=ta<%=i%> style="display:none">
							<td class=lightbluetable align=right width="4%"><%=i%>.其他費用：</td>
							<td class=whitetablebg align=left width="10%">
							<select name="nfyi_item_Arcase<%=i%>" size=1 disabled>
							<option value="" style="color:blue">請選擇</option>
							
							<%if( Request["add_arcase"]!="") 
								SQL="SELECT  rs_code, rs_detail FROM  code_br WHERE rs_class = 'Z1' And  cr= 'Y' and dept='T' AND no_code='N' and getdate() >= beg_date   ORDER BY rs_code";
							  else
								SQL="SELECT  rs_code, rs_detail FROM  code_br WHERE rs_class = 'Z1' And  cr= 'Y' and dept='T' AND no_code='N' and getdate() >= beg_date and substring(rs_code,1,3)='"+(Request["add_arcase"]).Left(3)+"'  ORDER BY rs_code";
							  	
							 %>
							</select> x <input type=text name="nfyi_item_count<%=i%>" size=2 maxlength=2 value="" <%=QClass%>>項</td>
							<td class=lightbluetable align=right width=4%>服務費：</td>
							<td class=whitetablebg align=left width=5%>
							<INPUT TYPE=text NAME=nfyi_Service<%=i%> SIZE=8 maxlength=8 style="text-align:right;" <%=QClass%>>
							<input type=hidden name=nfzi_Service<%=i%> SIZE=5 value=nfyi_service<%=i%>.value>
							</td>
							<td class=lightbluetable align=right width=4%>規費：</td>
							<td class=whitetablebg align=left width=5%>
							<INPUT TYPE=text NAME=nfyi_fees<%=i%> SIZE=8 maxlength=8 style="text-align:right;" <%=QClass%>>
							<input type=hidden name=nfzi_fees<%=i%> SIZE=5>
							</td>
						</tr>
					<%}%>
				<TR>
				  <td class=lightbluetable align=right colspan=2>小計：</td>
				  <td class=lightbluetable align=right>服務費：</td>
				  <td class=whitetablebg align=left><INPUT TYPE=text NAME=nfy_service SIZE=8 maxlength=8 style="text-align:right;" <%=QClass%> value="<%=Service%>"></td>
				  <td class=lightbluetable align=right>規費：</td>
				  <td class=whitetablebg align=left><INPUT TYPE=text NAME=nfy_fees SIZE=8 maxlength=8 style="text-align:right;" <%=QClass%> value="<%=Fees%>"></td>
				</TR>
				<TR>
				  <TD class=lightbluetable align=right width="4%">轉帳費用：</TD>
				  <TD class=whitetablebg width="11%"><select TYPE=text NAME=tfy_oth_arcase SIZE=1 <%=QDisabled%>>
							<option value="" style="color:blue">請選擇</option>
							<%SQL="SELECT  rs_code,prt_code,rs_detail FROM  code_br WHERE  cr= 'Y' and dept='T' And rs_type='"+arcase_type+"' AND no_code='N' and mark='M' ";
							  SQL+= "and getdate() >= beg_date and end_date is null ORDER BY rs_code";%>
					</SELECT></TD>
				  <TD class=lightbluetable align=right width=4%>轉帳金額：</TD>
				  <TD class=whitetablebg width=5%><input type="text" name="nfy_oth_money" size="8" style="text-align:right;" <%=QClass%> value=<%=oth_money%>></TD>
				  <TD class=lightbluetable align=right width=4%>轉帳單位：</TD>
				  <TD class=whitetablebg width=5%>
					<select TYPE=text NAME=tfy_oth_code SIZE=1 <%=QDisabled%>>
							<option value="" style="color:blue">請選擇</option>
							<%SQL="SELECT  branch,branchname FROM sysctrl.dbo.branch_code WHERE class = 'branch'";%>
							<option value="Z">Z_轉其他人</option>
					</SELECT>
				  </TD>
				</TR>
				<TR>
				  <TD class=lightbluetable align=right colspan=2>合計：</TD>
				  <TD class=whitetablebg colspan=4><INPUT TYPE=text NAME=OthSum SIZE=7  <%=QClass%> value=<%=othSum%>></TD>
				</TR>
				</TABLE>		  
		  </TD>
		  </TR>
		<TR>
		  <TD class=lightbluetable align=right>請款註記：</TD>
		  <TD class=whitetablebg><Select NAME=tfy_Ar_mark SIZE=1 <%=QDisabled%>>
				<option value="" style="color:blue" selected>請選擇</option>
				<%SQL="select cust_code,code_name from cust_code where code_type='ar_mark' and (mark1 like '%"+Session["SeBranch"]+Session["dept"]+"%' or mark1 is null)";%>
		  </SELECT></TD>
		  <TD class=lightbluetable align=right>折扣率：</TD>
		  <TD class="whitetablebg"><input TYPE="hidden" NAME="nfy_Discount" value="<%=Discount%>"><input TYPE=text NAME="Discount" <%=QClass%> value="<%=Discount%>%">
		  <INPUT TYPE=checkbox NAME=tfy_discount_chk value="Y"  <%=QDisabled%> >折扣請核單
		  </td>
		</TR>		
		<TR>
		  <TD class=lightbluetable align=right>案源代碼：</TD>
		  <TD class=whitetablebg><Select NAME=tfy_source SIZE=1  <%=QDisabled%>>
				<option value="" style="color:blue">請選擇</option>
				<%SQL="select cust_code,code_name from cust_code where code_type='Source' AND cust_code<> '__' AND End_date is null order by cust_code";%>
			</SELECT></TD>		  
		  <TD class=lightbluetable align=right>契約號碼：</TD>
		  <TD class=whitetablebg><input type="radio" name="Contract_no_Type"  <%=QDisabled%>><INPUT TYPE=text NAME=tfy_Contract_no SIZE=10 MAXLENGTH=10  <%=QClass%>>
			<span id="contract_type" style="display:">
				<input type="radio" name="Contract_no_Type"  <%=QDisabled%>>後續案無契約書
			</span>
			<span style="display:none"><!--2015/12/29修改，併入C不顯示-->
				<input type="radio" name="Contract_no_Type" <%=QDisabled%>>特案簽報
			</span>	
			<input type="radio" name="Contract_no_Type" <%=QDisabled%>>其他契約書無編號/特案簽報
			<input type="radio" name="Contract_no_Type" value="M" onclick="vbscript: contract_type_ctrl()" <%=QDisabled%>>總契約書
			<span id="span_btn_contract" style="display:none">
				<INPUT TYPE=text NAME=Mcontract_no SIZE=10 MAXLENGTH=10 readonly class="gsedit">
				<input type=button class="sgreenbutton" name="btn_contract" value="查詢總契約書" <%=QDisabled%>>
				+客戶案件委辦書
			</span>
			<br>
		  </TD>
		</TR>
		<TR>
			<TD class=lightbluetable align=right>法定期限：</TD>
			<TD class=whitetablebg align=left colspan=3><INPUT type=text NAME=dfy_last_date SIZE=10 <%=QClass%> value="<%=last_date%>">
			<img src="..\..\images\P.gif" style="cursor:hand" align="absmiddle" id="btnlast_date" onclick="vbscript:SelDate 'reg.dfy_last_date'" <%=QStyle%>>
			</TD>
		</TR>
		<TR>
		  <TD class=lightbluetable align=right>其他接洽：<BR>事項記錄：</TD>
		  <TD class=whitetablebg colspan=3><TEXTAREA NAME=tfy_Remark ROWS=6 COLS=70 <%=QClass%>><%=remark%></TEXTAREA>
		  </TD>
		</TR>				
	</TABLE>
	<input type=hidden name="TaCount" value="">
	
<script>

</script>

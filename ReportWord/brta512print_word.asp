<%@ Language=VBScript %>
<%

Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1

prgid = UCase(Request("prgid"))
'response.Write "prgid="& prgid
'response.End 

HTProgCode=prgid
HTProgPrefix=prgid
HTProgAcs=2
%>
<!-- #INCLUDE FILE="../inc/server.inc" -->
<!-- #INCLUDE FILE="../sub/server_conn.vbs" -->
<!-- #INCLUDE FILE="../sub/server_cbx.vbs" -->
<!--#INCLUDE FILE="../Sub/server_conn_unicode.vbs" -->
<!-- #include file="../brtam/report/官發規費明細表.asp" -->

<%
Set rs = Server.CreateObject("ADODB.Recordset")
Set rs1 = Server.CreateObject("ADODB.Recordset")
Set rs2 = Server.CreateObject("ADODB.Recordset")

'where條件
wsql=""
if request("sdate")<>empty then wsql = wsql & " and step_date>='"& request("sdate") &"'" 
if request("edate")<>empty then wsql = wsql & " and step_date<='"& request("edate") &"'" 
if request("srs_no")<>empty then wsql = wsql & " and rs_no>='"& request("srs_no") &"'" 
if request("ers_no")<>empty then wsql = wsql & " and rs_no<='"& request("ers_no") &"'" 
if request("sseq")<>empty then wsql = wsql & " and seq>="& request("sseq")
if request("eseq")<>empty then wsql = wsql & " and seq<="& request("eseq")
'if request("seq1")<>empty then wsql = wsql & " and seq1='"& request("seq1") &"'" 
if request("in_scode")<>empty then wsql = wsql & " and dmt_scode='"& request("in_scode") &"'" 
if request("scust_seq")<>empty then wsql = wsql & " and cust_seq>="& request("scust_seq")
if request("ecust_seq")<>empty then wsql = wsql & " and cust_seq<="& request("ecust_seq")
if request("qrysend_dept")<>empty then wsql = wsql & " and opt_Branch='"& request("qrysend_dept") &"'" 
if request("send_way")<>empty then '2012/12/13因應電子申請增加發文方式
   if request("send_way")="E" or request("send_way")="EA" then
	   wsql = wsql & " and send_way='" & request("send_way") & "'"
   else
	   'wsql = wsql & " and (send_way<>'E' or send_way is null or send_way='M') "
	   wsql = wsql & "  and isnull(send_way,'') not in('E','EA') "
   end if	 
end if

'2012/4/20因應區所轉帳規費，當天規費明細表增加顯示總發文日，有日期區間則不顯示
isql = "select distinct send_cl,send_clnm,branch,seq,seq1,cust_area,cust_seq,ap_cname1,ap_cname2,rs_no,step_date,rs_code,rs_detail,mp_date,"
isql = isql & "fees,dmt_scode,cappl_name,case_no,(select sc_name from sysctrl.dbo.scode where scode=a.dmt_scode) as sc_name,"
isql = isql & "(select ar_mark from case_dmt where case_no=a.case_no) as ar_mark"
isql = isql & " from vstep_dmt a where branch='"& session("se_branch") &"' and cg='G' and rs='S'"
isql = isql & wsql & " and fees>0"
'2006/5/27配合爭救案系統不列印爭救案發文資料,爭救案發文字號第一碼為B
isql = isql & " and left(rs_no,1)='G' "
'isql = isql & " group by send_cl,send_clnm,branch,seq,seq1,rs_no,step_date,rs_detail,fees,dmt_scode,cappl_name"
isql = isql & " order by send_cl,seq,seq1,rs_no"
'Response.Write isql & "<br>"
'Response.End

rs.Open isql, conn, 1, 1

Dim strBody,strBody1
dim tattach_path,tattach_name

tattach_path = "D:\Inetpub\wwwroot\btbrt\brtam\reportword" '存檔的路徑
tdate = year(request("edate")) & string(2-len(month(request("edate"))),"0") & month(request("edate")) & string(2-len(day(request("edate"))),"0") & day(request("edate"))
tattach_name = "GS"&request("send_way")&"-512T-" & tdate & ".doc" '存檔的檔案名稱
'response.Write tattach_name
'response.End
cnt = 0

If Not rs.EOF Then
    
           
    Set objStream = Server.CreateObject("ADODB.Stream")
	objStream.Open
	objStream.Charset = "utf-8"
	objStream.Position = objStream.Size
	
    ' 文件起始宣告
    doc_head = DocHead()
    'response.Write doc_head
    objStream.WriteText = doc_head 'xml的起頭到body

    
        
        Dim doc_head          ' 文件起始宣告
        Dim doc_body_01    
        Dim doc_body_011    
        Dim doc_body_02
        Dim doc_body_021
        Dim doc_body_022
        Dim doc_body_03
        Dim doc_tail             ' 文件尾    
        
        
        
        '==========報表抬頭  '換行<w:br/>
        doc_body_01 = DocBody_01()
        
        '抬頭
        sql = "select branch,branchname from branch_code where branch='" & session("se_branch") & "'"
	    branchname = getname(cnn,sql)
        doc_body_01 = ReplaceData(doc_body_01, "#br_nm#", branchname,"empty")
        '電子送件註記
        title=""
        if request("send_way")="E" then
           title="(電子送件)"
		elseif request("send_way")="EA" then
            title="(註冊費電子送件)"
        end if   
        doc_body_01 = ReplaceData(doc_body_01, "#title#", title,"empty")    
        
        '==========發文日期  '換行<w:br/>
        doc_body_011 = DocBody_011()
        '起日
        doc_body_011 = ReplaceData(doc_body_011, "#sdate#", request("sdate"),"empty")    
        '迄日
        doc_body_011 = ReplaceData(doc_body_011, "#edate#", request("edate"),"empty") 
        '總發文日期
        mp_date=""
	    if cdate(request("sdate"))=cdate(request("edate")) then
	       mp_date=RS("mp_date")
	       if mp_date<>empty then mp_date="總發文日期：" & mp_date
	    end if
	    doc_body_011 = ReplaceData(doc_body_011, "#mp_date#", mp_date,"empty") 
 	    '列印日期
 	    doc_body_011 = ReplaceData(doc_body_011, "#print_date#", date,"empty")    
            
           
        '==========表格資料
        doc_body_02 = DocBody_02()    
	    
	    '每行資料
	    service=0   '小計服務費
	    fees = 0    '小計規費
	    countnum = 0
	    subcount = 0'小計件數
	    send_cl = RS("send_cl")
	    strBody1=doc_body_02
	    cnt=0
	    while not rs.EOF 
	        fees = cdbl(fees) + cdbl(RS("fees"))
			isql = " select case_no from fees_dmt where rs_no='"& RS("rs_no") &"'"
		    rs1.Open isql,conn,1,1
		    service1=0
		    case_no=""
		    while not rs1.EOF 
		        if case_no="" then
		           case_no = case_no & trim(rs1("case_no")) 
		        else
		           case_no = case_no & trim(rs1("case_no")) & "<w:br/>"
		        end if   
			    isql = "select isnull(service,0)+isnull(add_service,0) from case_dmt where case_no='"& rs1("case_no") &"'"
			    rs2.Open isql,conn,1,1
			    if not rs2.EOF then
				    service1 = cdbl(service1) + cdbl(rs2(0))
			    end if
			    rs2.Close 
			    if not rs1.EOF then rs1.MoveNext 
		    wend
		    rs1.Close
		    service = cdbl(service) + cdbl(service1)
			countnum = countnum + 1
            cnt = cnt + 1
            if cnt=1 then
                '===發文對象
                doc_body_021 = DocBody_021()
                doc_body_021 = ReplaceData(doc_body_021, "#send_name#", RS("send_clnm"),"empty")
                strBody1=strBody1 & doc_body_021	 
            else
                '===小計
                if send_cl<>RS("send_cl") then
                    doc_body_03 = DocBody_03()
                    doc_body_03 = ReplaceData(doc_body_03, "#sub_cnt#", countnum,"empty")
                   	doc_body_03 = ReplaceData(doc_body_03, "#sub_service#", service,"empty")
					doc_body_03 = ReplaceData(doc_body_03, "#sub_fees#", fees,"empty")
					strBody1=strBody1 & doc_body_03
					'===表頭
					doc_body_02 = DocBody_02() 
					strBody1=strBody1 & doc_body_02
					'===發文對象
                    doc_body_021 = DocBody_021()
                    doc_body_021 = ReplaceData(doc_body_021, "#send_name#", RS("send_clnm"),"empty")
                    strBody1=strBody1 & doc_body_021	
                    service=0
                    fees = 0
				    countnum = 0
				    subcount = 0
				    send_cl = RS("send_cl")
			    end if
            end if
            '===每筆發文案件資料
            doc_body_022 = DocBody_022()    
            '本所編號
            seq=rs("branch")&ucase(session("dept"))&rs("seq")
	        if trim(rs("seq1"))<>"_" then seq=seq & "-" & trim(rs("seq1"))
            doc_body_022 = ReplaceData(doc_body_022, "#seq#", seq,"empty")	 
            '案件名稱
	        doc_body_022 = ReplaceData(doc_body_022, "#appl_name#", ToXmlUnicode(rs("cappl_name"),""),"empty")
             '客戶名稱
             cust_name=RS("cust_area") & string(5-len(RS("cust_seq")),"0") & RS("cust_seq") & trim(RS("ap_cname1")) & trim(RS("ap_cname2"))	   
            doc_body_022 = ReplaceData(doc_body_022, "#cust_name#", ToXmlUnicode(cust_name,""),"empty") 
            '發文內容
            doc_body_022 = ReplaceData(doc_body_022, "#rs_detail#",trim(rs("rs_code")) & "-"&trim(rs("rs_detail")),"empty")	    
	        '交辦單號
	       	doc_body_022 = ReplaceData(doc_body_022, "#case_no#",case_no,"empty")	      
	        '服務費
	        if rs("ar_mark")="D" then
	           service1=service1 & "(D)"
	        end if   
	        doc_body_022 = ReplaceData(doc_body_022, "#service#", service1,"empty")
	        '規費
	        doc_body_022 = ReplaceData(doc_body_022, "#fees#", rs("fees"),"empty")
	        '營洽
	        doc_body_022 = ReplaceData(doc_body_022, "#sc_name#", rs("sc_name"),"empty")
	        
    	    strBody1=strBody1 & doc_body_022
	        rs.MoveNext 
        wend
        doc_body_03 = DocBody_03()
        doc_body_03 = ReplaceData(doc_body_03, "#sub_cnt#", countnum,"empty")
        doc_body_03 = ReplaceData(doc_body_03, "#sub_service#", service,"empty")
		doc_body_03 = ReplaceData(doc_body_03, "#sub_fees#", fees,"empty")
		
	                  
        strBody =  doc_body_01 & doc_body_011 & strBody1 & doc_body_03 
        'strBody = DocHead2 & doc_body_01 & doc_body_02 & doc_body_03 & Doc_pic & doc_tail
        'strBody = DocHead2 & DocBody_01 & DocBody_02 & DocBody_031 & DocBody_032 & DocBody_033 & DocBody_034 & doc_tail 'test
        'response.Write strBody
 
 		objStream.WriteText = strBody
 				
        doc_tail = DocTail()
        'response.Write doc_tail_01 
        objStream.WriteText = doc_tail 
               
    
        '產生word儲存
            
		
	    objStream.SaveToFile tattach_path & "\" & tattach_name, 2
	    objStream.Close
        Set objStream = Nothing	

Else
    response.Write "找不到案件資料！"
    response.End   		
End If
rs.Close


' <w:color w:val=""0000FF""/>  ' 藍色字型宣告


Function geterrmsg()
	'conn.RollbackTrans
	msg = HTProgCap & "失敗!!!" & ERR.number & ERR.description
%>
<%
	Response.End
End Function

If err.number=0 Then
    
	%>
	<script language="vbscript">
	    window.close 
		'window.open "acc13_printdb.doc","myWindowOne", "width=1270 height=830 top=0 left=0 toolbar=yes menubar=yes resizable=yes scrollbars=yes "
		'window.open "http://" & "<%=session("webservername")%><%=session("custdbfile_path")%>/<%=cust_file%>"  
		window.open "../brtam/reportword/<%=tattach_name%>"
	</script>
	<%
%>
<%
Else
    Response.Write HTProgCap & "--失敗!!!" & ERR.number & ERR.description
  '  conn.RollbackTrans
End If


Set rs1 = Nothing
Set rs = Nothing

conn.Close
Set conn = Nothing
%>

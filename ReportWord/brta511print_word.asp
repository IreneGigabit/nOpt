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
<!-- #include file="../brtam/report/官發發文明細表.asp" -->

<%
Set rs = Server.CreateObject("ADODB.Recordset")
Set rs1 = Server.CreateObject("ADODB.Recordset")

'where條件
wsql=""
if request("sdate")<>empty then wsql = wsql & " and step_date>='"& request("sdate") &"'" 
if request("edate")<>empty then wsql = wsql & " and step_date<='"& request("edate") &"'" 
if request("srs_no")<>empty then wsql = wsql & " and main_rs_no>='"& request("srs_no") &"'" 
if request("ers_no")<>empty then wsql = wsql & " and main_rs_no<='"& request("ers_no") &"'" 
if request("sseq")<>empty then wsql = wsql & " and seq>="& request("sseq")
if request("eseq")<>empty then wsql = wsql & " and seq<="& request("eseq")
'if request("seq1")<>empty then wsql = wsql & " and seq1='"& request("seq1") &"'" 
if request("in_scode")<>empty then wsql = wsql & " and dmt_scode='"& request("in_scode") &"'" 
if request("scust_seq")<>empty then wsql = wsql & " and cust_seq>="& request("scust_seq")
if request("ecust_seq")<>empty then wsql = wsql & " and cust_seq<="& request("ecust_seq")
if request("qrysend_dept")<>empty then wsql = wsql & " and opt_Branch='"& request("qrysend_dept") &"'" 
if request("send_way")<>empty then 
   if request("send_way")="E" or request("send_way")="EA" then
	   wsql = wsql & " and send_way='" & request("send_way") & "'"
   else
	   'wsql = wsql & " and (send_way<>'E' or send_way is null or send_way='M') "
	   wsql = wsql & "  and isnull(send_way,'') not in('E','EA') "
   end if	   
end if

isql = "select send_cl,send_clnm,branch,main_rs_no,seq,seq1,rs_no,step_date,rs_detail,apply_no,fees,'正本' as sendmark,step_grade,cappl_name,class,issue_no "
isql = isql & ",send_way,pr_scode,receipt_type,receipt_title"
isql = isql & " from vstep_dmt where branch='"& session("se_branch") &"' and cg = 'g' and rs = 's'"
isql = isql & wsql
'2006/5/27配合爭救案系統不列印爭救案發文資料,爭救案發文字號第一碼為B
isql = isql & " and left(rs_no,1)='G' "
isql = isql & " union select send_cl1 as send_cl,send_cl1nm as send_clnm,branch,main_rs_no,seq,seq1,rs_no,step_date,rs_detail,apply_no,fees,'副本' as sendmark,step_grade,cappl_name,class,issue_no"
isql = isql & ",send_way,pr_scode,receipt_type,receipt_title"
isql = isql & " from vstep_dmt where branch='"& session("se_branch") &"' and cg = 'g' and rs = 's'"
isql = isql & wsql & " and send_cl1 is not null"
'2006/5/27配合爭救案系統不列印爭救案發文資料,爭救案發文字號第一碼為B
isql = isql & " and left(rs_no,1)='G' "
isql = isql & " group by send_cl,main_rs_no,send_clnm,send_cl1,send_cl1nm,branch,seq,seq1,rs_no,step_date,rs_detail,apply_no,fees,step_grade,cappl_name,class,issue_no,send_way,pr_scode,receipt_type,receipt_title "
isql = isql & " order by send_cl,main_rs_no,seq,seq1,rs_no"

showlog(isql)
'Response.Write isql & "<br>"
'Response.End
rs.Open isql, conn, 1, 1

Dim strBody,strBody1
dim tattach_path,tattach_name

tattach_path = "D:\Inetpub\wwwroot\btbrt\brtam\reportword" '存檔的路徑
tdate = year(request("edate")) & string(2-len(month(request("edate"))),"0") & month(request("edate")) & string(2-len(day(request("edate"))),"0") & day(request("edate"))
tattach_name = "GS"&request("send_way")&"-511T-" & tdate & ".doc" '存檔的檔案名稱
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
        Dim doc_body_04
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
 	    '列印日期
 	    doc_body_011 = ReplaceData(doc_body_011, "#print_date#", date,"empty")    
            
           
        '==========表格資料
        doc_body_02 = DocBody_02()    
	    
	    '每行資料
	    fees = 0'小計規費
	    countnum = 0'小計筆數
	    subcount = 0'小計併案
		Pcount = 0'小計紙本收據件數
		Ecount = 0'小計電子收據件數
		Zcount = 0'小計無規費件數
		
	    totfees = 0'總計規費
	    tot_subcount = 0'總計併案
		totPcount = 0'總計紙本收據件數
		totEcount = 0'總計電子收據件數
		totZcount = 0'總計無規費件數
		
	    send_cl = RS("send_cl")
	    strBody1=""
	    cnt=0
	    while not rs.EOF 
			'承辦
			sql = "select scode,sc_name from scode where scode='" & RS("pr_scode") & "'"
			pr_scodenm = getname(cnn,sql)
			
			'收據種類
			if cdbl(RS("fees"))=0 then'20191118 增加無規費不顯示收據種類
				rectitle = ""
			else
				if trim(RS("receipt_type"))="E" then
					rectitle = "電子收據("&trim(RS("receipt_title"))&")"
				else
					rectitle = "紙本收據"
				end if
			end if
	        IF trim(RS("sendmark"))="正本" then
			    fees = cdbl(fees) + cdbl(RS("fees"))
			    totfees = cdbl(totfees) + cdbl(RS("fees"))
		    End IF
		    countnum = countnum + 1
			if cdbl(RS("fees"))=0 then'20191118 增加統計無規費
				Zcount = Zcount +1
				totZcount = totZcount +1
			else
				if RS("receipt_type")="E" then'電子收據
					Ecount = Ecount +1
					totEcount = totEcount +1
				else
					Pcount = Pcount +1
					totPcount = totPcount +1
				end if
			end if
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
                    doc_body_03 = ReplaceData(doc_body_03, "#sub_cnt#", "電子收據"&Ecount&"件，紙本收據"&Pcount&"件，無規費"&Zcount&"件，共"&countnum,"empty")
                    sub_remark=""
                    if subcount > 0 then
					    sub_remark="( " & countnum - subcount & " 件公文 + " & subcount & " 件併案處理 )"
					    tot_subcount = tot_subcount + subcount
					end if
					doc_body_03 = ReplaceData(doc_body_03, "#sub_remark#", remark,"empty")
					doc_body_03 = ReplaceData(doc_body_03, "#sub_fees#", fees,"empty")
					strBody1=strBody1 & doc_body_03
					 '===發文對象
                    doc_body_021 = DocBody_021()
                    doc_body_021 = ReplaceData(doc_body_021, "#send_name#", RS("send_clnm"),"empty")
                    strBody1=strBody1 & doc_body_021	
                    fees = 0
				    countnum = 0
				    subcount = 0
					Ecount = 0
					Pcount = 0
				    send_cl = RS("send_cl")
			    end if
            end if
            '===每筆發文案件資料
            doc_body_022 = DocBody_022()    
            '本所編號
            seq=rs("branch")&ucase(session("dept"))&rs("seq")
	        if trim(rs("seq1"))<>"_" then seq=seq & "-" & trim(rs("seq1"))
            doc_body_022 = ReplaceData(doc_body_022, "#seq#", seq,"empty")	    
            '發文內容
            doc_body_022 = ReplaceData(doc_body_022, "#rs_detail#",trim(rs("rs_detail")),"empty")	    
	        '正副本
	        doc_body_022 = ReplaceData(doc_body_022, "#send_cl#", RS("sendmark"),"empty")	
	        '發文日期
	        doc_body_022 = ReplaceData(doc_body_022, "#step_date#", rs("step_date"),"empty")	     
	        '發文字號
	        doc_body_022 = ReplaceData(doc_body_022, "#rs_no#", trim(rs("rs_no")),"empty")	    
	        '進度序號
	        doc_body_022 = ReplaceData(doc_body_022, "#step_grade#", "(" & rs("step_grade") & ")","empty")	
	        '申請案號
	        doc_body_022 = ReplaceData(doc_body_022, "#apply_no#", trim(rs("apply_no")),"empty")
	        '20170605 增加承辦
	        doc_body_022 = ReplaceData(doc_body_022, "#pr_scodenm#", pr_scodenm,"empty")
	        '20170605 增加收據種類
	        doc_body_022 = ReplaceData(doc_body_022, "#rectitle#", rectitle,"empty")
	        '20161201 增加註冊號
			IF trim(rs("issue_no"))<>"" THEN
				doc_body_022 = ReplaceData(doc_body_022, "#issue_no#", "("&trim(rs("issue_no"))&")","empty")
			ELSE
				doc_body_022 = ReplaceData(doc_body_022, "#issue_no#", "","empty")
			END IF
	        '規費
	        IF trim(RS("sendmark"))="正本" then
	           doc_body_022 = ReplaceData(doc_body_022, "#fees#", rs("fees")&"","empty")
	        else
	           doc_body_022 = ReplaceData(doc_body_022, "#fees#", "","empty")
	        end if
	        '案件名稱
	        doc_body_022 = ReplaceData(doc_body_022, "#appl_name#", ToXmlUnicode(rs("cappl_name"),""),"empty")
	        '類別
	        doc_body_022 = ReplaceData(doc_body_022, "#class#", trim(rs("class")),"empty")
	        
	        if RS("rs_no") <>RS("main_rs_no") then
			    subcount = subcount + 1
		    end if
    	    strBody1=strBody1 & doc_body_022
	        rs.MoveNext 
        wend
        doc_body_03 = DocBody_03()
        doc_body_03 = ReplaceData(doc_body_03, "#sub_cnt#", "電子收據"&Ecount&"件，紙本收據"&Pcount&"件，無規費"&Zcount&"件，共"&countnum,"empty")
        sub_remark=""
        if subcount > 0 then
           acount=cint(countnum) - cint(subcount)
		   sub_remark="( " & acount & " 件公文 + " & subcount & " 件併案處理 )"
		   tot_subcount = tot_subcount + subcount
		end if
		doc_body_03 = ReplaceData(doc_body_03, "#sub_remark#", sub_remark,"empty")
		doc_body_03 = ReplaceData(doc_body_03, "#sub_fees#", fees,"empty")
		
	    '表尾合計
        doc_body_04 = DocBody_04()
        doc_body_04 = ReplaceData(doc_body_04, "#tot_cnt#", "電子收據"&totEcount&"件，紙本收據"&totPcount&"件，無規費"&totZcount&"件，共"&RS.RecordCount,"empty")
        tot_remark=""
        if tot_subcount > 0 then
            bcount=cint(RS.RecordCount) - cint(tot_subcount)
			tot_remark= "( " & bcount & " 件公文 + " & tot_subcount & " 件併案處理 )"
		end if
		doc_body_04 = ReplaceData(doc_body_04, "#tot_remark#", tot_remark,"empty")
		doc_body_04 = ReplaceData(doc_body_04, "#tot_fees#", totfees,"empty")
                
        strBody =  doc_body_01 & doc_body_011 & doc_body_02 & strBody1 & doc_body_03 & doc_body_04
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

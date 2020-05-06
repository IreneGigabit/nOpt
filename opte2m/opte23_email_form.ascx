<%@ Control Language="C#" Classname="opte23_email_form" %>
<%@ Import Namespace = "System.Collections.Generic"%>
<%@ Import Namespace = "System.Data.SqlClient"%>
<%@ Import Namespace = "System.Data" %>

<script runat="server">
    public Dictionary<string, string> ReqVal = new Dictionary<string, string>();
    public Dictionary<string, object> vbr_opte = new Dictionary<string, object>();
    public string tf_class = "";//?
    public string tf_subject = "";//Email主旨
    public string tf_content = "";//Email內容
    public string att_name = "";//收件者姓名
    public string from_email = "";//寄件者Email
    public string att_email = "";//收件者Email
    public string cc_email = "";//副本Email
    public string bcc_email = "";//密件副本Email

    protected string SQL = "";
    protected string work_scode_html = "";//撰寫人
    
    protected int attcnt = 0;//附件數
    
    private void Page_Load(System.Object sender, System.EventArgs e) {
        ReqVal = Request.QueryString.ToDictionary();
        //foreach (KeyValuePair<string, string> p in ReqVal) {
        //    Response.Write(string.Format("{0}:{1}<br>", p.Key, p.Value));
        //}
        //Response.Write("<HR>");


        PageLayout();
        this.DataBind();
    }
    
    private void PageLayout() {
        //撰寫人
        using (DBHelper conn = new DBHelper(Conn.OptK).Debug(false)) {
            SQL = "SELECT DISTINCT a.in_scode,";
            SQL += "(SELECT sc_name FROM sysctrl.dbo.scode WHERE scode=a.in_scode) as scodenm,";
            SQL += "(SELECT sscode FROM sysctrl.dbo.scode WHERE scode=a.in_scode) AS sscode";
            SQL += " FROM br_opte a";
            SQL += " where (a.stat_code like 'NN%' or a.stat_code like 'NX%') and a.mark='N'";
            SQL += " and a.pr_branch='BJ' and a.email_date is null ";
            SQL += " ORDER BY 3";
            work_scode_html = SHtml.Option(conn, SQL, "{in_scode}", "{scodenm}");
            
            if (ReqVal.TryGet("email_sqlno", "0")=="0"){
    	        SQL = "select tf_content from tfcode_opt where tf_code = '" +ReqVal.TryGet("tf_code","")+ "' ";
            }else{
                SQL = "select content as tf_content from opt_email_log where email_sqlno = " +ReqVal.TryGet("email_sqlno", "0");
            }
            using(SqlDataReader dr=conn.ExecuteReader(SQL)){
                if(dr.Read()){
                    tf_content=dr.SafeRead("tf_content","");
                }
            }
        }

        //附件清單
        attachRepeater.DataSource = GetAttachList();
        attachRepeater.DataBind();

        //更換資料
        changeValue();
    }

    private DataTable GetAttachList() {
        DataTable dtAttach = new DataTable();
        using (DBHelper conn = new DBHelper(Conn.OptK).Debug(false)) {
            string strpdf_name = "";//上次寄送的附件名稱
            if (Convert.ToInt32("0" + ReqVal.TryGet("email_sqlno", "0")) > 0) {
                SQL = "select pdf_name from opt_email_log where email_sqlno=" + Request["email_sqlno"];
                object objResult = conn.ExecuteScalar(SQL);
                strpdf_name = (objResult != DBNull.Value && objResult != null) ? ";" + objResult.ToString().Trim() + ";" : "";
            }

            SQL = "select *,branch upload_branch,''pdfpath,''pdfsize,''upload_branch_server,'checked'checked ";
            SQL += "from attach_opte ";
            SQL += "where opt_sqlno=" + Request["opt_sqlno"] + " and attach_flag<>'D' ";
            conn.DataTable(SQL, dtAttach);
            for (int i = 0; i < dtAttach.Rows.Count; i++) {
                attcnt += 1;
                
                //因資料庫儲存的路徑仍為舊系統路徑,要改為project路徑
                dtAttach.Rows[i]["pdfpath"] = Sys.Host + dtAttach.Rows[i].SafeRead("attach_path", "").Trim().Replace(@"\opt\", @"\nopt\");
                dtAttach.Rows[i]["pdfsize"] = (Convert.ToDecimal("0" + dtAttach.Rows[i].SafeRead("attach_size", "")) / 1024) + 1;
                if (dtAttach.Rows[i].SafeRead("attach_path", "").IndexOf(@"\opt\") > -1) {
                    dtAttach.Rows[i]["upload_branch_server"] = Sys.uploadservername("K");
                } else {
                    dtAttach.Rows[i]["upload_branch_server"] = Sys.uploadservername(dtAttach.Rows[i].SafeRead("upload_branch", "").Trim());
                }
                
                //預設勾選,但若有上寄送記錄以寄件記錄為準
                if (strpdf_name != "") {
                    if (strpdf_name.IndexOf(";" + dtAttach.Rows[i].SafeRead("attach_name", "").Trim() + ";") > -1) {
                        dtAttach.Rows[i]["checked"] = "checked";
                    } else {
                        dtAttach.Rows[i]["checked"] = "";
                    }
                }
            }
        }

        return dtAttach;
    }

    private void changeValue() {
        if (ReqVal.TryGet("email_sqlno", "0") == "0") {
            //更換主旨
            tf_subject = tf_subject.Replace("/*apply_no*/", vbr_opte.TryGet("apply_no", "").ToString());
            tf_subject = tf_subject.Replace("/*issue_no*/", vbr_opte.TryGet("issue_no", "").ToString());
            tf_subject = tf_subject.Replace("/*your_no*/", vbr_opte.TryGet("your_no", "").ToString());

            //更換內文
            string fseq = Funcs.formatSeq(vbr_opte.TryGet("Bseq", "").ToString(), vbr_opte.TryGet("Bseq1", "").ToString(), vbr_opte.TryGet("country", "").ToString(), vbr_opte.TryGet("branch", "").ToString(), Sys.GetSession("dept") + "E");
            string fext_seq = Funcs.formatSeq(vbr_opte.TryGet("ext_seq", "").ToString(), vbr_opte.TryGet("ext_seq1", "").ToString(), vbr_opte.TryGet("country", "").ToString(), "", Sys.GetSession("dept") + "E");
            tf_content = tf_content.Replace("/*fseq*/", fseq);
            tf_content = tf_content.Replace("/*fext_seq*/", fext_seq);
            tf_content = tf_content.Replace("/*your_no*/", vbr_opte.TryGet("your_no", "").ToString());
            tf_content = tf_content.Replace("/*appl_name*/", vbr_opte.TryGet("appl_name", "").ToString());
            tf_content = tf_content.Replace("/*apply_no*/", vbr_opte.TryGet("apply_no", "").ToString());
            tf_content = tf_content.Replace("/*issue_no*/", vbr_opte.TryGet("issue_no", "").ToString());
            tf_content = tf_content.Replace("/*class*/", vbr_opte.TryGet("class", "").ToString());
            string ap_cname = "";
            using (DBHelper conn = new DBHelper(Conn.OptK).Debug(false)) {
                SQL = "select ap_cname from caseopte_ap where opt_sqlno=" + Request["opt_sqlno"];
                using (SqlDataReader dr = conn.ExecuteReader(SQL)) {
                    while (dr.Read()) {
                        ap_cname += (ap_cname != "" ? "、" : "") + dr.SafeRead("ap_cname", "").Trim();
                    }
                }
            }
            tf_content = tf_content.Replace("/*ap_cname*/", ap_cname);
            tf_content = tf_content.Replace("/*last_date*/", Util.parsedate(vbr_opte.TryGet("last_date", "").ToString(), "yyyy年M月d日"));
            tf_content = tf_content.Replace("/*ctrl_date*/", Util.parsedate(vbr_opte.TryGet("ctrl_date", "").ToString(), "yyyy年M月d日"));
            tf_content = tf_content.Replace("/*ctrl_date1*/", Util.parsedate(vbr_opte.TryGet("ctrl_date", "").ToString(), "yyyy年M月d日"));
            tf_content = tf_content.Replace("/*arcase_name*/", vbr_opte.TryGet("pr_rs_code_name", "").ToString());
            tf_content = tf_content.Replace("/*remarkb*/", vbr_opte.TryGet("remarkb", "").ToString());
        }
        
        tf_content = tf_content.Replace("<FONT ", "<span ");
        tf_content = tf_content.Replace("</FONT>", "</span>");
    }
</script>

<%=Sys.GetAscxPath(this)%>
<input type="text" name="send_scode" value="<%#Session["scode"]%>"> 
<input type="text" name="source_server" value="<%#Sys.Host%>">
<INPUT TYPE="text" name="agt_comp" value="I">
<INPUT TYPE="text" name="sendrs_kind" value="TE">
<INPUT TYPE="text" name="sendseq" value="<%#vbr_opte.TryGet("bseq","")%>">
<INPUT TYPE="text" name="sendseq1" value="<%#vbr_opte.TryGet("bseq1","")%>">
<INPUT TYPE="text" name="job_sqlno" value="<%#ReqVal.TryGet("opt_sqlno","")%>">
<INPUT TYPE="text" name="recordnum" value="<%#ReqVal.TryGet("recordnum","")%>">
<INPUT TYPE="text" name="tf_code" value="<%#ReqVal.TryGet("tf_code","")%>">
<INPUT TYPE="text" name="tf_class" value="<%#vbr_opte.TryGet("tf_class","")%>">
<INPUT TYPE="text" id="email_sqlno" name="email_sqlno" value="<%#ReqVal.TryGet("email_sqlno","0")%>">

<table border="0" class="bluetable" cellspacing="1" cellpadding="2" width="100%">
	<tr>
		<td class="lightbluetable" align="right" width="20%" nowrap>信函序號：</td>
		<td class="whitetablebg" align="left" colspan="3">			
			<INPUT name="tfsend_no" size=11 maxlength=10 value="<%#vbr_opte.TryGet("opt_no","")%>" class="Lock">
		</td>
	</tr>
	<tr>
		<td class="lightbluetable" align="right" nowrap>撰寫人：</td>
		<td class="whitetablebg" align="left" colspan="3">
			<select id="work_scode" name="work_scode" size=1 disabled><%#work_scode_html%></select>
		</td>
	</tr>
	<tr>
		<td class="lightbluetable" align="right" nowrap>寄件者Email：</td>
		<td class="whitetablebg" align="left" colspan="3">
			<input type="text" name="from_email" size="50" maxlength="100" value="<%#from_email%>" class="Lock">
			(若無對外Email，則設定以siiplo為寄件者)
		</td>
	</tr>
	<tr>
		<td class="lightbluetable" align="right" nowrap>收件者姓名：</td>
		<td class="whitetablebg" align="left" colspan="3">
			<input type="text" name="att_name" size="50" maxlength="100" value="<%#att_name%>" >
		</td>
	</tr>		
	<tr>
		<td class="lightbluetable" align="right" nowrap>收件者Email：</td>
		<td class="whitetablebg" align="left" colspan="3">
			<input type="text" name="att_email" size="50" maxlength="100" value="<%#att_email%>" >
		</td>
	</tr>
			
	<tr>
		<td class="lightbluetable" align="right" nowrap>副本：</td>
		<td class="whitetablebg" align="left" colspan="3">
			<input type="text" name="cc_email" size="50" maxlength="100" value="<%#cc_email%>" class="Lock">
		</td>
	</tr>
	<tr style="display:none">
		<td class="lightbluetable" align="right" nowrap>密件副本：</td>
		<td class="whitetablebg" align="left" colspan="3">
			<input type="text" name="bcc_email" size="50" maxlength="100" value="<%#bcc_email%>" class="Lock">
		</td>
	</tr>
	<tr>
		<td class="lightbluetable" align="right" nowrap>附件：</td>
		<td class="whitetablebg" align="left" colspan="3">
			<input type="checkbox" name="pdf_all" value="Y" style="display:none">
			<span id="span_pdf_all" style="display:none">全選/全不選<br></span>
			<asp:Repeater id="attachRepeater" runat="server">
			<ItemTemplate>
                <input type="text" name="pdfpath<%#Container.ItemIndex%>" value="<%#Eval("pdfpath")%>">
				<input type="text" name="pdfname<%#Container.ItemIndex%>" value="<%#Eval("attach_name")%>">
				<input type="text" name="pdfsize<%#Container.ItemIndex%>" value="<%#Eval("pdfsize")%>">
				<input type="text" name="pdfbranch<%#Container.ItemIndex%>" value="<%#Eval("upload_branch")%>">
				<input type="text" name="brupload_server<%#Container.ItemIndex%>" value="<%#Eval("upload_branch_server")%>">
				<input type="checkbox" name="pdf_send<%#Container.ItemIndex%>" value="Y" <%#Eval("checked")%> onclick="pdf_send_onClick('<%#Container.ItemIndex%>')">
				<font color="darkblue" style="cursor:pointer" onclick="pdf_onclick('<%#Eval("pdfpath")%>')"><%#Eval("attach_name")%></font> 
				(<%#Eval("pdfsize")%>KB)
				<br>
			</ItemTemplate>
			</asp:Repeater>
			<input type="text" name="pdfcnt" value="<%#attcnt%>">
		</td>
	</tr>

    <tr>
		<td class="lightbluetable" align="right" nowrap>附件檔案大小：</td>
		<td class="whitetablebg" align="left" colspan="3">
			<input type="hidden" name="file_size"> 
			<span id="span_file_size"></span>&nbsp;KB
			&nbsp;&nbsp;&nbsp;&nbsp;◎所有附件之檔案大小總和不得超過4MB(4096KB)。
		</td>				
	</tr>
	<tr>
		<td class="lightbluetable" align="right" nowrap>Email主旨：</td>
		<td class="whitetablebg" align="left" colspan="3">
			<input type="text" name="tf_subject" size="80" maxlength="100" value="<%#tf_subject%>">
		</td>
	</tr>				
	<tr>
		<td class="lightbluetable" align="right" nowrap>Email內容：</td>
		<td class="whitetablebg" align="left" colspan="3">
            <textarea id="tf_content" name="tf_content"><%=tf_content%></textarea>
		</td>
	</tr>
</table>
<script language="javascript" type="text/javascript">
    var email_form = {};
    email_form.init = function () {
    }
</script>

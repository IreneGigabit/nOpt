<%@Page Language="C#" CodePage="65001"%>
<%@Import Namespace = "System.Collections.Generic"%>
<%@Import Namespace = "System.IO"%>
<%@Import Namespace = "System.Data.SqlClient"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script runat="server">

	protected string HTProgCap = "上載檔案";
	private string HTProgCode = "";
	protected string HTProgPrefix = "UpLoadImage";
	private int HTProgAcs = 4;
	private int HTProgRight = 0;
	protected string QueryString = "";
	protected string sssss = "";
	protected Dictionary<string, string> SrvrVal = new Dictionary<string, string>();

	private void Page_Load(Object sender, EventArgs e) {
		Response.CacheControl = "no-cache";
		Response.AddHeader("Pragma", "no-cache");
		Response.Expires = -1;
		HTProgCode = Funcs.Request("ProgID");
		QueryString = Request.ServerVariables["QUERY_STRING"];
		SrvrVal.Add("MsgStr", "");
		SrvrVal.Add("UpID", "");
		SrvrVal.Add("pVal", Funcs.Request("pVal"));
		SrvrVal.Add("FName", "");
		SrvrVal.Add("AttName", "");

		Token myToken = new Token(HTProgCode);
		HTProgRight = myToken.Check();
		if (HTProgRight >= 0) {
            string sTask = Funcs.Request("submitTask");
			if (sTask != null && sTask == "UPLOAD")
				DoUpLoad();
			UpLoadFileLayout();
			this.DataBind();
		}
	}

	private void DoUpLoad() {
		string szSeqArea = Funcs.Request("vcSeqArea");
		string nSeq = Funcs.Request("nSeq");
		string szSeq1 = Funcs.Request("vcSeq1");
		string rsID = Funcs.Request("rsID");
		string wrkID = Funcs.Request("wrkID");
		string csID = Funcs.Request("csID");
		string pVal = Funcs.Request("pVal");

		HttpFileCollection allFiles = Request.Files;
		HttpPostedFile uploadedFile;

		uploadedFile = allFiles["FileUp"];
		string FName = uploadedFile.FileName;
		int n = FName.LastIndexOf(".");
		string sExt = (n < 0) ? "" : FName.Substring(n);
		int nFSize = uploadedFile.ContentLength;
        string AttType = Funcs.Request("selDoc");
        string rMrk = Funcs.Request("nvReMark");
		SqlConnection cn = null;
		SqlTransaction trns = null;
		SqlCommand cmd = null;
		string SQL = "";
		string tblName = "";
		string sPath = "";
		string AttName = "";
		string UpID = "";
		int nrec = 0;
		string msgString = "";
		string trcString = "";
		//string okString = "";
		string debugString = "";
		string sqlString = "";

		try {
			cn = new SqlConnection(Session["ODBCDSN"].ToString());
			cn.Open();
			trns = cn.BeginTransaction();
			cmd = cn.CreateCommand();
			cmd.CommandText = "";
			cmd.Transaction = trns;

			if (nSeq == "") {
				SQL = "INSERT INTO tbAttachTemp (nvReMark, vcExt, nvFName, deFSize, vcDocType, vcInUID, vcUpPrgid) VALUES (" +
					Funcs.pkNStr(rMrk, ",") + Funcs.pkStr(sExt, ",") + Funcs.pkNStr(FName, ",") + nFSize.ToString() + "," + 
					Funcs.pkStr(AttType, ",") + Funcs.pkStr(Session["scode"].ToString(), ",") + Funcs.pkStr(HTProgCode, ")");
				cmd.CommandText = SQL;

				tblName = "tbAttachTemp";
				sPath = Application["uploadPath"].ToString() + "\\Temp\\";
				AttName = "";
			} else {
				string sP0 = szSeqArea;
				string stmp = "0000" + nSeq;
				stmp = stmp.Substring(stmp.Length - 5);
				string sP1 = stmp.Substring(0, 3);
				string sP2 = stmp.Substring(stmp.Length - 2);

				string sP3 =  (szSeq1 == "_") ? sP0 + "-" + stmp : sP3 = sP0 + "-" + stmp + "-" + szSeq1;

				SQL = "SELECT dbo.NewAttachNo(" + Funcs.pkStr(szSeqArea, ",") + Funcs.pkN(nSeq, ",") + Funcs.pkStr(szSeq1, "") + ")";
				cmd.CommandText = SQL;
				int AttNo = (int) cmd.ExecuteScalar();
				string AttPath = Application["uploadPath"].ToString() + "\\" + sP0 + "\\" + sP1 + "\\" + sP2 + "\\" + sP3;
				AttName = (szSeq1 == "_") ? sP3 + "--" + AttNo.ToString() + sExt : AttName = sP3 + "-" + AttNo.ToString() + sExt;
		
				SQL = "INSERT INTO dbFeesAttach (vcAttach_type, vcSeqArea, nSeq, vcSeq1, nStepGrade, nCsSqlno, vcUpPrgid, vcInUID, " +
					"nAttachNo, vcAttachPath, nvAttachDesc, vcAttachName, vcAttachExt, deAttachSize, vcModUID) VALUES (" +
					Funcs.pkStr(AttType, ",") + Funcs.pkStr(szSeqArea, ",") + Funcs.pkN(nSeq, ",") + Funcs.pkStr(szSeq1, ",") +
					Funcs.pkN(rsID, ",") + Funcs.pkN(csID, ",") + "'" + HTProgCode + "','" + Session["scode"].ToString() + "'," + 
					AttNo.ToString() + ",'" + AttPath + "'," + Funcs.pkNStr(rMrk, ",") + "'" +	AttName + "'," + Funcs.pkStr(sExt, ",") + 
					nFSize.ToString() + ",'" + Session["scode"].ToString() + "')";
				cmd.CommandText = SQL;
				tblName = "dbFeesAttach";
		
				sPath = Application["uploadPath"] + "\\" + sP0;

				if (!Directory.Exists(sPath)) Directory.CreateDirectory(sPath);

				sPath += "\\" + sP1;
				if (!Directory.Exists(sPath)) Directory.CreateDirectory(sPath);

				sPath += "\\" + sP2;
				if (!Directory.Exists(sPath)) Directory.CreateDirectory(sPath);

				sPath += "\\" + sP3;
				if (!Directory.Exists(sPath)) Directory.CreateDirectory(sPath);

				sPath += "\\";
			}
			nrec = cmd.ExecuteNonQuery();
			if (nrec <= 0) throw new System.Exception("新增附件檔資料失敗！");

			SQL = "SELECT IDENT_CURRENT( '" + tblName + "' )";
			cmd.CommandText = SQL;
			object sqlno = cmd.ExecuteScalar();
			UpID = sqlno.ToString();

			if (AttName == "") {
				AttName = UpID + sExt;
				sPath = sPath + UpID + sExt;
			} else {
				sPath = sPath + AttName;
			}
			uploadedFile.SaveAs(sPath);

			// 更新客戶函檔
			if (nSeq != "" && rsID != "" && csID != "") {
				SQL = "UPDATE dbFeesCS SET nAttachSqlno = " + Funcs.pkN(UpID, ", ") +
					"chCsPrintFlag = 'P', dtCsPrintDate = GETDATE(), chSendFlag = 'N', dtChkDate = NULL, " +
					"dtModDate = GETDATE(), vcModUID = " + Funcs.pkStr(Session["scode"].ToString(), " ") +
					"OUTPUT 'U', GETDATE(), " + Funcs.pkStr(Session["scode"].ToString(), ",") + 
					Funcs.pkStr(HTProgCode, ",") + "DELETED.* INTO dbFeesCS_log " +
					" WHERE nCsSqlno = " + csID;
				cmd.CommandText = SQL;
				nrec = cmd.ExecuteNonQuery();
				if (nrec <= 0) throw new System.Exception("更新客戶函失敗！");
			}

			//okString = "OK";
			msgString = "上載成功 !";
			trns.Commit();
			cn.Close();
		} catch (Exception ex) {
			if (trns != null) trns.Rollback();
			if (cn != null) cn.Close();
			msgString = ex.Message.ToString();
			trcString = (ex.StackTrace == null) ? "" : ex.StackTrace.ToString();
			//okString = "BAD";
			system.errorLog(ex, SQL, HTProgCode);
			msgString = msgString.Replace("\\", "\\\\").Replace("\r", "\\r").Replace("\n", "\\n").Replace("\"", "\\\"");
			foreach (object strReq in Request.Form)
				debugString = debugString + "<tr><td>" + strReq.ToString() + "</td><td>" + Request.Form[strReq.ToString()] + "</td></tr>\n";
			sqlString = SQL;
		}
		SrvrVal["MsgStr"] = msgString.Replace("\r\n", "\\r\\n");
		/*	
		Char [] chaa = msgString.Substring(13, 2).ToCharArray();
		sssss = "";
		foreach (Char cc in chaa) {
			int tmp = cc;
			sssss += String.Format("x{0:X2}", System.Convert.ToUInt32(tmp.ToString()));
		}
		sssss = msgString.Replace("\r\n", "");
		*/
		SrvrVal["UpID"] = UpID;
		SrvrVal["pVal"] = pVal;
		SrvrVal["FName"] = FName;
		SrvrVal["AttName"] = AttName;
	}

	private void UpLoadFileLayout() {
	}
</script>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%#HTProgCap%></title>
<link rel="stylesheet" type="text/css" href="../inc/setstyle.css" />
<script type="text/javascript" src="../js/jquery-1.12.4.min.js"></script>
<script type="text/javascript" language="javascript">
	$(function() {
		var mStr = "<%#SrvrVal["MsgStr"]%>";
		if (mStr != "") alert(mStr);
		var upID = "<%#SrvrVal["UpID"]%>";
		var pVal = "<%#SrvrVal["pVal"]%>";
		var FName = "<%#SrvrVal["FName"]%>";
		var AName = "<%#SrvrVal["AttName"]%>";
		if (upID != "" && pVal != "") {
			//alert(pVal + "," + upID);
			window.parent.SetpValue(pVal, upID, FName, rMrk, AName);
		}
		$("#doit").click(formSubmit);
		$("#upload select[name='selDoc']").change(ChgDoc);
	});

	function formSubmit(e) {
		if ($("#upload :file[name='FileUp']").val() == "") {
			alert("請務必選擇「檔案」，不得為空白！");
			$("#upload :file[name='FileUp']").focus();
			return;
		}

		if ($("#upload :text[name='nvReMark']").val() == "") {
			alert("請務必填寫「檔案說明」，不得為空白！");
			$("#upload :text[name='nvReMark']").focus();
			return;
		}

		//window.parent.AddFile upload.FileUp.value, upload.nvReMark.value
		$("#upload :hidden[name='submitTask']").val("UPLOAD");
		$("#upload").submit();
		return;
	}

	function ChgDoc(e) {
		var sObj = e.target;

 		if ($(sObj).val() == "") return;

		var selStr = $("option[selected]", sObj).text();
		var stmp = $("#upload :text[name='nvReMark']").val();
		if (stmp.indexOf(selStr) < 0) {
			if (stmp.length > 0) stmp += ",";
			stmp += selStr
			$("#upload :text[name='nvReMark']").val(stmp);
		}
		return;
	}
</script>
</head>
<body bgcolor="#ffcc00" style="margin: 5px 0px 0px 0px;">
<form id="upload" name="upload" method="post" action="UpLoadFile.aspx?<%#QueryString%>" enctype="multipart/form-data" acceptcharset="utf-8">
<input type="hidden" name="submitTask" value="" />
<table border="0" cellspacing="1" cellpadding="2" width="100%" class="bluetable">
<tr>
<td class="lightbluetable" align="right">檔案：</td>
<td class="whitetablebg" colspan="3">
<input type="file" name="FileUp" size="50" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type="button" id="doit" value="上載" class="cbutton" />
&nbsp;&nbsp;<b style="color:red">檔案大小上限：10MB</b>
</td>
</tr>
</table>
</form>
</body>
</html>


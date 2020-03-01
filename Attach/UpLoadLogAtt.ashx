<%@ WebHandler Language="C#" Class="UploadMailAtt" %> 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using System.IO;
using System.Text;
using System.Data.SqlClient;

public class UploadMailAtt : IHttpHandler, IRequiresSessionState {
	public void ProcessRequest(HttpContext context) {
		try {
			context.Response.ContentType = "text/plain";
			//由於uploadify的flash是採用utf-8的編碼方式，所以上傳頁面也要用utf-8編碼，才能正常上傳中文檔名的文件
			context.Request.ContentEncoding = Encoding.GetEncoding("UTF-8");
			context.Response.ContentEncoding = Encoding.GetEncoding("UTF-8");
			context.Response.Charset = "UTF-8";

			string HTProgCode = "";
			int HTProgAcs = 4;
			int HTProgRight = 0;

			HTProgCode = context.Request.Form["ProgID"];
		
			Token myToken = new Token(HTProgCode);
			HTProgRight = myToken.Check();
			if (HTProgRight >= 0) {
				string pVal = context.Request.Form["pVal"];
				string pnLogSqlno = context.Request.Form["nLogSqlno"];

				HttpPostedFile uploadedFile = context.Request.Files["Filedata"];

				string FName = uploadedFile.FileName;
				int n = FName.LastIndexOf("\\");
				if (n >= 0) FName = FName.Substring(n + 1);
				n = FName.LastIndexOf(".");
				string sReMark = (n < 0) ? "" : FName.Substring(0, n);
				string szExt = (n < 0) ? "" : FName.Substring(n).ToLower();
				int nFSize = uploadedFile.ContentLength;

				SqlConnection cn = new SqlConnection(context.Session["ODBCDSN"].ToString());
				cn.Open();
				SqlTransaction trns = cn.BeginTransaction();
				SqlCommand cmd = cn.CreateCommand();
				cmd.CommandText = "";
				cmd.Transaction = trns;

				string UpID = "";
				int nrec = 0;

				string szAttName = String.Format("{0:yyyy-MM-dd-HH-mm-ss.fff}", DateTime.Now) + "_0" + szExt;
				string szPath = context.Application["uploadPath"].ToString() + "\\Log";
				string DestName = szPath + "\\" + szAttName;

				string SQL = "INSERT INTO tbAttach (vcAttachType, vcUpPrgid, nRuleSqlno, vcDocType, nvAttachDesc, " +
					"nvAttachPath, nvAttachName, nvFName, vcAttachExt, deAttachSize, vcInUID, vcModUID) VALUES (";
				SQL += "'LogRef', ";
				SQL += Funcs.pkStr(HTProgCode, ", ");
				SQL += Funcs.pkN(pnLogSqlno, ", ");
				SQL += "'A99', ";
				SQL += Funcs.pkNStr(sReMark, ", ");
				SQL += Funcs.pkNStr(szPath, ", ");
				SQL += Funcs.pkNStr(szAttName, ", ");
				SQL += Funcs.pkNStr(FName, ", ");
				SQL += Funcs.pkStr(szExt, ", ");
				SQL += Funcs.pkN0(nFSize.ToString(), ", ");
				SQL += Funcs.pkStr(context.Session["scode"].ToString(), ", ");
				SQL += Funcs.pkStr(context.Session["scode"].ToString(), ")");
				cmd.CommandText = SQL;

				nrec = cmd.ExecuteNonQuery();
				if (nrec <= 0) throw new System.Exception("新增附件檔資料失敗！");

				SQL = "SELECT IDENT_CURRENT('tbAttach')";
				cmd.CommandText = SQL;
				UpID = Convert.ToInt32(cmd.ExecuteScalar()).ToString();

				uploadedFile.SaveAs(DestName);

				trns.Commit();
				cn.Close();

				context.Response.Write("1#@#" + pVal + "#@#" + UpID + "#@#" + FName + "#@#" + sReMark + "#@#" +
					DestName.Replace(context.Application["uploadPath"].ToString(), "").Replace("\\", "/"));

			} else {
				context.Response.Write("0#@#無權限操作");
			}
		} catch(Exception ex) {
			context.Response.Write("0#@#" + ex.Message.ToString());
			//context.Response.Write(ex.StackTrace.ToString());
		}
	}

	public bool IsReusable {
		get {
			return false;
		}
	}
}

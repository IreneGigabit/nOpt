using System;
using System.Configuration;
using System.Web;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Net.Mail;
using System.Text;

public class Sys
{
	public static string Host = HttpContext.Current.Request.ServerVariables["HTTP_HOST"].ToString().ToLower();
	/// <summary>  
	/// 取得某個Session值  
	/// </summary>  
	/// <param name="strSessionName">Session對象名稱</param>  
	/// <returns>Session值</returns>  
	public static string GetSession(string strSessionName) {
		return (HttpContext.Current.Session[strSessionName] ?? "").ToString();
	}

	/// <summary>  
	/// 取得Session ID
	/// </summary>  
	/// <returns>Session值</returns>  
	public static string GetSessionID() {
		return HttpContext.Current.Session.SessionID;
	}

	/// <summary>  
	/// 設定Session值
	/// </summary>  
	/// <returns>Session值</returns>  
	public static void SetSession(string strSessionName, object sessionValue) {
		HttpContext.Current.Session[strSessionName] = sessionValue;
	}

	/// <summary>  
	/// 取得應用程式在伺服器上虛擬應用程式根路徑ex:/NOpt
	/// </summary>  
	/// <returns>應用程式根路徑</returns>  
	public static string GetRootDir() {
		return HttpContext.Current.Request.ApplicationPath;
	}

	public static bool IsAdmin() {
		bool b = (GetSession("scode") == "admin" || GetSession("LoginGrp").ToLower().IndexOf("admin") > -1);
		return b;
	}

	public static string getConnString(string parameter) {
		string str = "";
		try {
			str = ConfigurationManager.ConnectionStrings[parameter].ConnectionString;
		}
		catch {
		}
		return str;
	}

	public static string getAppSetting(string parameter) {
		string str = "";
		try {
			str = ConfigurationManager.AppSettings[parameter];
		}
		catch {
		}
		return str;
	}

	public static void errorLog(Exception ex, string sqlStr, string prgID) {
		List<string> sqlList = new List<string>();
		sqlList.Add(sqlStr);
		errorLog(ex, sqlList, prgID);
	}

	public static void errorLog(Exception ex, List<string> sqlList, string prgID) {
		using (SqlConnection cn = new SqlConnection(Conn.OptK)) {
			cn.Open();
			string eSQL = "INSERT INTO error_log(log_date, log_uid, syscode, prgid, MsgStr, SQLstr, StackStr) VALUES (";
			eSQL = eSQL + "getdate(),";
			eSQL = eSQL + "'" + (GetSession("scode") == "" ? GetSessionID() : GetSession("scode")) + "',";
			eSQL = eSQL + "'" + (GetSession("Syscode") == "" ? GetRootDir().Replace("/", "") : GetSession("Syscode")) + "',";
			eSQL = eSQL + "'" + prgID + "',";
			eSQL = eSQL + "'" + ex.Message.Replace("'", "''") + "',";
			eSQL = eSQL + "'" + string.Join("\r\n=====\r\n", sqlList.ToArray()).Replace("'", "''") + "',";
			eSQL = eSQL + "'" + ex.StackTrace.Replace("'", "''") + "')";

			SqlCommand cmd = new SqlCommand(eSQL, cn);
			cmd.ExecuteNonQuery();
		}
	}

	/// <summary>
	/// 聖島人主機
	/// </summary>
	public static string SIServer {
		get {
			if (Host == "web10") return "web01";
			if (Host == "web08") return "web02";
			switch (Host.Substring(0, 1)) {
				case "w":
				case "b":
				case "l": return Host;
				default: return "sin32";
			}
		}
	}

	/// <summary>
	/// 案件資料庫名稱(抓共用設定用.ex:code_br,case_fee)
	/// </summary>
	public static string tdbname {
		get {
			switch (Host) {
				case "sik10": return "sikdbs";//正式環境
				default: return "sindbs";//開發環境
			}
		}
	}

	/// <summary>
	/// 區所上傳檔案檢視主機(iis)
	/// </summary>
	public static string webservername(string pBranch) {
		string rtnStr = "";
		switch (Host) {
			case "sik10": //正式環境
				if (pBranch.ToUpper() == "N") rtnStr = "sinn03";
				if (pBranch.ToUpper() == "C") rtnStr = "sic09";
				if (pBranch.ToUpper() == "S") rtnStr = "sis09";
				if (pBranch.ToUpper() == "K") rtnStr = "sik09";
				break;
			case "web10":
				rtnStr = "web01";//測試環境
				break;
			default:
				rtnStr = "web02";//開發環境
				break;
		}
		return rtnStr;
	}

	/// <summary>
	/// 區所上傳檔案實體主機(fileServer)
	/// </summary>
	public static string uploadservername(string pBranch) {
		string rtnStr = "";
		switch (Host) {
			case "sik10": //正式環境
				if (pBranch.ToUpper() == "N") rtnStr = "sinn11";
				if (pBranch.ToUpper() == "C") rtnStr = "sic11";
				if (pBranch.ToUpper() == "S") rtnStr = "sis11";
				if (pBranch.ToUpper() == "K") rtnStr = "sik08";
				break;
			case "web10":
				rtnStr = "web01";//測試環境
				break;
			default:
				rtnStr = "web02";//開發環境
				break;
		}
		return rtnStr;
	}

    /// <summary>
    /// 發送郵件
    /// </summary>
    public static void DoSendMail(string Subject, string Msg, string SendFrom, List<string> SendTo, List<string> SendCC, List<string> SendBCC) {
        MailMessage MailMsg = new MailMessage();
        MailMsg.From = new MailAddress(SendFrom);//寄件者
        foreach (string to in SendTo)//收件者
		{
            if (!string.IsNullOrEmpty(to)) {
                MailMsg.To.Add(new MailAddress(to));
            }
        }
        foreach (string cc in SendCC)//副本
		{
            if (!string.IsNullOrEmpty(cc)) {
                MailMsg.CC.Add(new MailAddress(cc));
            }
        }
        foreach (string bcc in SendBCC)//密件副本
		{
            if (!string.IsNullOrEmpty(bcc)) {
                MailMsg.Bcc.Add(new MailAddress(bcc));
            }
        }

        MailMsg.Subject = Subject;//主旨
        MailMsg.SubjectEncoding = Encoding.UTF8;
        MailMsg.Body = Msg;//內文
        MailMsg.BodyEncoding = Encoding.UTF8;
        MailMsg.IsBodyHtml = true;//郵件格式為HTML

		SmtpClient client = new SmtpClient("192.192.10.30");
		//SmtpClient client = new SmtpClient("sin22.saint-island.com.tw");
        try {
            //client.ServicePoint.MaxIdleTime = 2;//連線可閒置時間(毫秒)
            //client.ServicePoint.ConnectionLimit = 1;//允許最大連線數
			//client.Credentials = new System.Net.NetworkCredential("siiplo", "Jean212");
			//client.Credentials = new System.Net.NetworkCredential("m1570", "mkfpk");
            client.Send(MailMsg);//發送郵件
        }
        catch {
            throw;
        }
        finally {
	    	client.ServicePoint.CloseConnectionGroup(client.ServicePoint.ConnectionName);//關閉SMTP連線
			//釋放每個附件，才不會Lock住
			if (MailMsg.Attachments != null && MailMsg.Attachments.Count > 0) {
				for (int i = 0; i < MailMsg.Attachments.Count; i++) {
					MailMsg.Attachments[i].Dispose();
				}
			}
			MailMsg.Dispose();//釋放訊息
        }
    }


    /// <summary>  
    /// 組本所編號
    /// </summary>  
    public static string formatSeq(string seq, string seq1, string country, string branch, string dept) {
		string lseq = branch + dept + "-" + seq;
		lseq += (seq1 != "_" ? ("-" + seq1) : "");
		lseq += (country != "" ? (" " + country.ToUpper()) : "");
		return lseq;
	}


}

using System;
using System.Configuration;
using System.Web;
using System.Data.SqlClient;
using System.Collections.Generic;
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
    /// 區所上傳檔案檢視主機(北)
    /// </summary>
    public static string webservernameN {
		get {
			switch (Host) {
				case "sik10": return "sinn03";//正式環境
                case "web10": return "web01";//測試環境
                default: return "web02";//開發環境
			}
		}
	}

    /// <summary>
    /// 區所上傳檔案檢視主機(中)
    /// </summary>
    public static string webservernameC {
        get {
            switch (Host) {
                case "sik10": return "sic09";//正式環境
                case "web10": return "web01";//測試環境
                default: return "web02";//開發環境
            }
        }
    }

    /// <summary>
    /// 區所上傳檔案檢視主機(南)
    /// </summary>
    public static string webservernameS {
        get {
            switch (Host) {
                case "SIK10": return "sinn03";//正式環境
                case "web10": return "web01";//測試環境
                default: return "web02";//開發環境
            }
        }
    }

    /// <summary>
    /// 區所上傳檔案檢視主機(雄)
    /// </summary>
    public static string webservernameK {
        get {
            switch (Host) {
                case "SIK10": return "sik09";//正式環境
                case "web10": return "web01";//測試環境
                default: return "web02";//開發環境
            }
        }
    }

    /// <summary>
    /// 區所上傳檔案copy主機(北)
    /// </summary>
    public static string uploadservernameN {
        get {
            switch (Host) {
                case "sik10": return "sinn11";//正式環境
                case "web10": return "web01";//測試環境
                default: return "web02";//開發環境
            }
        }
    }

    /// <summary>
    /// 區所上傳檔案copy主機(中)
    /// </summary>
    public static string uploadservernameC {
        get {
            switch (Host) {
                case "sik10": return "sic11";//正式環境
                case "web10": return "web01";//測試環境
                default: return "web02";//開發環境
            }
        }
    }

    /// <summary>
    /// 區所上傳檔案copy主機(南)
    /// </summary>
    public static string uploadservernameS {
        get {
            switch (Host) {
                case "SIK10": return "sis11";//正式環境
                case "web10": return "web01";//測試環境
                default: return "web02";//開發環境
            }
        }
    }

    /// <summary>
    /// 區所上傳檔案copy主機(雄)
    /// </summary>
    public static string uploadservernameK {
        get {
            switch (Host) {
                case "SIK10": return "sik08";//正式環境
                case "web10": return "web01";//測試環境
                default: return "web02";//開發環境
            }
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


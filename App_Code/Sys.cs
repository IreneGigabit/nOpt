using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// 連線字串設定
/// </summary>
public static class Conn
{
    private static string Host = HttpContext.Current.Request.ServerVariables["HTTP_HOST"].ToString().ToUpper();

    /// <summary>
    /// 爭救案系統
    /// </summary>
    public static string OptK {
        get {
            switch (Host) {
                case "SIK10": return Sys.getConnString("prod_optk");//正式環境
                case "WEB10": return Sys.getConnString("test_optk");//使用者測試環境
                default: return Sys.getConnString("dev_optk");//開發環境
            }
        }
    }

	/// <summary>
	/// 區所案件管理系統
	/// </summary>
	public static string OptB(string pBranch) {
		string rtnStr = "";
		switch (Host) {
			case "SIK10": //正式環境
				if (pBranch.ToUpper() == "N") rtnStr = Sys.getConnString("prod_optBN");
				if (pBranch.ToUpper() == "C") rtnStr = Sys.getConnString("prod_optBC");
				if (pBranch.ToUpper() == "S") rtnStr = Sys.getConnString("prod_optBS");
				if (pBranch.ToUpper() == "K") rtnStr = Sys.getConnString("prod_optBK");
				break;
			case "WEB10":
				rtnStr = Sys.getConnString("test_optBN");//測試環境
				break;
			default:
				rtnStr = Sys.getConnString("dev_optBN");//開發環境
				break;
		}
		return rtnStr;
	}

    /// <summary>
    /// 案件管理系統(總)
    /// </summary>
    public static string OptBM {
        get {
            switch (Host) {
                case "SIK10": return Sys.getConnString("prod_optBM");//正式環境
				case "WEB10": return Sys.getConnString("test_optBM");//使用者測試環境
                default: return Sys.getConnString("dev_optBM");//開發環境
            }
        }
    }

	/// <summary>
	/// 帳款資料使用
	/// </summary>
	public static string Acc(string pBranch) {
		string rtnStr = "";
		switch (Host) {
			case "SIK10": //正式環境
				if (pBranch.ToUpper() == "N") rtnStr = Sys.getConnString("prod_Nacc");
				if (pBranch.ToUpper() == "C") rtnStr = Sys.getConnString("prod_Cacc");
				if (pBranch.ToUpper() == "S") rtnStr = Sys.getConnString("prod_Sacc");
				if (pBranch.ToUpper() == "K") rtnStr = Sys.getConnString("prod_Kacc");
				break;
			case "WEB10":
				rtnStr = Sys.getConnString("test_Nacc");//測試環境
				break;
			default:
				rtnStr = Sys.getConnString("dev_Nacc");//開發環境
				break;
		}
		return rtnStr;
	}

    /// <summary>
    /// Sysctrl
    /// </summary>
    public static string Sysctrl {
        get {
            switch (Host) {
                case "SIK10": return Sys.getConnString("prod_sysctrl");//正式環境
				case "WEB10": return Sys.getConnString("test_sysctrl");//使用者測試環境
                default: return Sys.getConnString("dev_sysctrl");//開發環境
            }
        }
    }

    /// <summary>
    /// ODBCDSN
    /// </summary>
    public static string ODBCDSN {
        get {
            switch (Host) {
                case "SIK10": return Sys.getConnString("prod_sysctrl");//正式環境
				case "WEB10": return Sys.getConnString("test_sysctrl");//使用者測試環境
                default: return Sys.getConnString("dev_sysctrl");//開發環境
            }
        }
    }
}

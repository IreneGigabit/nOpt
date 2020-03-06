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
                case "SIK10": return system.getConnString("prod_optk");//正式環境
                case "WEB10": return system.getConnString("test_optk");//使用者測試環境
                default: return system.getConnString("dev_optk");//開發環境
            }
        }
    }
    /// <summary>
    /// 案件管理系統(北)
    /// </summary>
    public static string OptBN {
        get {
            switch (Host) {
				case "SIK10": return system.getConnString("prod_optBN");//正式環境
				case "WEB10": return system.getConnString("test_optBN");//使用者測試環境
                default: return system.getConnString("dev_optBN");//開發環境
            }
        }
    }
    /// <summary>
    /// 案件管理系統(中)
    /// </summary>
    public static string OptBC {
        get {
            switch (Host) {
                case "SIK10": return system.getConnString("prod_optBC");//正式環境
				case "WEB10": return system.getConnString("test_optBC");//使用者測試環境
                default: return system.getConnString("dev_optBC");//開發環境
            }
        }
    }
    /// <summary>
    /// 案件管理系統(南)
    /// </summary>
    public static string OptBS {
        get {
            switch (Host) {
                case "SIK10": return system.getConnString("prod_optBS");//正式環境
				case "WEB10": return system.getConnString("test_optBS");//使用者測試環境
                default: return system.getConnString("dev_optBS");//開發環境
            }
        }
    }
    /// <summary>
    /// 案件管理系統(雄)
    /// </summary>
    public static string OptBK {
        get {
            switch (Host) {
                case "SIK10": return system.getConnString("prod_optBK");//正式環境
				case "WEB10": return system.getConnString("test_optBK");//使用者測試環境
                default: return system.getConnString("dev_optBK");//開發環境
            }
        }
    }
    /// <summary>
    /// 案件管理系統(總)
    /// </summary>
    public static string OptBM {
        get {
            switch (Host) {
                case "SIK10": return system.getConnString("prod_optBM");//正式環境
				case "WEB10": return system.getConnString("test_optBM");//使用者測試環境
                default: return system.getConnString("dev_optBM");//開發環境
            }
        }
    }
    /// <summary>
    /// 帳款資料使用(北)
    /// </summary>
    public static string AccN {
        get {
            switch (Host) {
                case "SIK10": return system.getConnString("prod_Nacc");//正式環境
				case "WEB10": return system.getConnString("test_Nacc");//使用者測試環境
                default: return system.getConnString("dev_Nacc");//開發環境
            }
        }
    }
    /// <summary>
    /// 帳款資料使用(中)
    /// </summary>
    public static string AccC {
        get {
            switch (Host) {
                case "SIK10": return system.getConnString("prod_Cacc");//正式環境
				case "WEB10": return system.getConnString("test_Cacc");//使用者測試環境
                default: return system.getConnString("dev_Cacc");//開發環境
            }
        }
    }
    /// <summary>
    /// 帳款資料使用(南)
    /// </summary>
    public static string AaccS {
        get {
            switch (Host) {
                case "SIK10": return system.getConnString("prod_Sacc");//正式環境
				case "WEB10": return system.getConnString("test_Sacc");//使用者測試環境
                default: return system.getConnString("dev_Sacc");//開發環境
            }
        }
    }
    /// <summary>
    /// 帳款資料使用(雄)
    /// </summary>
    public static string AccK {
        get {
            switch (Host) {
                case "SIK10": return system.getConnString("prod_Kacc");//正式環境
				case "WEB10": return system.getConnString("test_Kacc");//使用者測試環境
                default: return system.getConnString("dev_Kacc");//開發環境
            }
        }
    }
    /// <summary>
    /// Sysctrl
    /// </summary>
    public static string Sysctrl {
        get {
            switch (Host) {
                case "SIK10": return system.getConnString("prod_sysctrl");//正式環境
				case "WEB10": return system.getConnString("test_sysctrl");//使用者測試環境
                default: return system.getConnString("dev_sysctrl");//開發環境
            }
        }
    }
    /// <summary>
    /// ODBCDSN
    /// </summary>
    public static string ODBCDSN {
        get {
            switch (Host) {
                case "SIK10": return system.getConnString("prod_sysctrl");//正式環境
				case "WEB10": return system.getConnString("test_sysctrl");//使用者測試環境
                default: return system.getConnString("dev_sysctrl");//開發環境
            }
        }
    }
}

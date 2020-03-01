using System;
using System.Collections.Generic;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using System.Web.UI.WebControls;
using System.Collections;
using System.Globalization;

public class Funcs {
	public static string Request(string s) {
        return (HttpContext.Current.Request[s] ?? "").ToString();
	}

	// IsNumeric Function
	public static bool IsNumeric(object Expresion) {
		bool isNum = true;
		double retNum = 0.0;

		isNum = Double.TryParse(Convert.ToString(Expresion), System.Globalization.NumberStyles.Any, System.Globalization.NumberFormatInfo.InvariantInfo, out retNum);

		return isNum;
	}

	public static string pkDate(string oStr, string endchar, int mode) {
		string dStr = oStr.Trim();
		string strRet = "NULL" + endchar;
		string sm = "";
		int pos = 0;

		switch(mode) {
			case 0:
				sm = " 00:00";
				break;
			case 1:
				sm = " 23:59";
				break;
			case 2:
				sm = " 00:00:00";
				break;
			case 3:
				sm = " 23:59:59";
				break;
			default:
				sm = "";
				break;
		}

		if (oStr != null) {
			dStr = oStr.Trim();
			if (dStr.Length > 0) {
				pos = dStr.IndexOf(" ");
				if (pos < 0)
					strRet = "'" + dStr + sm + "'" + endchar;
				else
					strRet = "'" + dStr.Substring(0, pos) + sm + "'" + endchar;
			}
		}

		return strRet;
	}

	public static string pkDate(string oStr, int mode) {
		string dStr = "";
		string strRet = "NULL";
		string sm = "";
		int pos = 0;

		switch(mode) {
			case 0:
				sm = " 00:00";
				break;
			case 1:
				sm = " 23:59";
				break;
			case 2:
				sm = " 00:00:00";
				break;
			case 3:
				sm = " 23:59:59";
				break;
			default:
				sm = "";
				break;
		}

		if (oStr != null) {
			dStr = oStr.Trim();
			if (dStr.Length > 0) {
				pos = dStr.IndexOf(" ");
				if (pos < 0)
					strRet = "'" + dStr + sm + "'";
				else
					strRet = "'" + dStr.Substring(0, pos) + sm + "'";
			}
		}

		return strRet;
	}

	public static string pkN(string oStr, string eChr) {
		string dStr = "";
		string strRet = "";

		if (oStr == null) {
			dStr = "NULL";
		} else {
			dStr = oStr.Trim();
			if (dStr.Length == 0)
				dStr = "NULL" ;
			else if (!IsNumeric(dStr))
				dStr = "NULL";
		}
		strRet = dStr + eChr;

		return strRet;
	}

	public static string pkN(string oStr) {
		string strRet = "";

		if (oStr == null)
			strRet = "NULL";
		else {
			strRet = oStr.Trim();
			if (strRet.Length == 0)
				strRet = "NULL";
			else if (!IsNumeric(strRet))
				strRet = "NULL";
		}

		return strRet;
	}

	public static string pkN0(string oStr, string eChr) {
		string dStr = "";
		string strRet = "";

		if (oStr == null)
			dStr = "0";
		else {
			dStr = oStr.Trim();
			if (dStr.Length == 0)
				dStr = "0";
			else if (!IsNumeric(dStr))
				dStr = "0";
		}
		strRet = dStr + eChr;

		return strRet;
	}

	public static string pkN0(string oStr) {
		string strRet = "";

		if (oStr == null)
			strRet = "0";
		else {
			strRet = oStr.Trim();
			if (strRet.Length == 0)
				strRet = "0";
			else if (!IsNumeric(strRet))
				strRet = "0";
		}

		return strRet;
	}

	public static string pkStr(string iStr, string eChr) {
		string Str = "";
		string dStr = "";
		int pos = 0;

		if (iStr != null) Str = iStr.Trim();
		if (Str.Length == 0)
			dStr = "NULL" + eChr;
		else {
			pos = Str.IndexOf("'");
			while(pos >= 0) {
				Str = Str.Substring(0, pos + 1) + "'" + Str.Substring(pos + 1);
				pos = Str.IndexOf("'", pos + 2);
			}
			dStr = "'" + Str + "'" + eChr;
		}

		return dStr;
	}

	public static string pkStr(string iStr) {
		string Str = "";
		string dStr = "";
		int pos = 0;

		if (iStr != null) Str = iStr.Trim();
		if (Str.Length == 0)
			dStr = "NULL";
		else {
			pos = Str.IndexOf("'");
			while (pos >= 0) {
				Str = Str.Substring(0, pos + 1) + "'" + Str.Substring(pos + 1);
				pos = Str.IndexOf("'", pos + 2);
			}
			dStr = "'" + Str + "'";
		}

		return dStr;
	}

    public static string pkSStr(string iStr, string eChr)
    {
        string Str = "";
        string dStr = "";
        int pos = 0;

        if (iStr != null) Str = iStr.Trim();
        if (Str.Length == 0)
            dStr = "''" + eChr;
        else
        {
            pos = Str.IndexOf("'");
            while (pos >= 0)
            {
                Str = Str.Substring(0, pos + 1) + "'" + Str.Substring(pos + 1);
                pos = Str.IndexOf("'", pos + 2);
            }
            dStr = "'" + Str + "'" + eChr;
        }

        return dStr;
    }

    public static string pkSStr(string iStr)
    {
        string Str = "";
        string dStr = "";
        int pos = 0;

        if (iStr != null) Str = iStr.Trim();
        if (Str.Length == 0)
            dStr = "''";
        else
        {
            pos = Str.IndexOf("'");
            while (pos >= 0)
            {
                Str = Str.Substring(0, pos + 1) + "'" + Str.Substring(pos + 1);
                pos = Str.IndexOf("'", pos + 2);
            }
            dStr = "'" + Str + "'";
        }

        return dStr;
    }

	public static string qkStr(string iStr) {
		string Str = "";
		string dStr = "";
		int pos = 0;

		if (iStr != null) Str = iStr.Trim();
		if (Str.Length == 0)
			dStr = "%";
		else {
			pos = Str.IndexOf("'");
			while (pos >= 0) {
				Str = Str.Substring(0, pos + 1) + "'" + Str.Substring(pos + 1);
				pos = Str.IndexOf("'", pos + 2);
			}
			dStr = "'%" + Str + "%'";
		}

		return dStr;
	}

	public static string pkNStr(string iStr, string eChr) {
		string Str = "";
		string dStr = "";
		int pos = 0;

		if (iStr != null) Str = iStr.Trim();
		if (Str.Length == 0)
			dStr = "NULL" + eChr;
		else {
			pos = Str.IndexOf("'");
			while (pos >= 0) {
				Str = Str.Substring(0, pos + 1) + "'" + Str.Substring(pos + 1);
				pos = Str.IndexOf("'", pos + 2);
			}
			dStr = "N'" + Str + "'" + eChr;
		}

		return dStr;
	}

	public static string pkNStr(string iStr) {
		string Str = "";
		string dStr = "";
		int pos = 0;

		if (iStr != null) Str = iStr.Trim();
		if (Str.Length == 0)
			dStr = "NULL";
		else {
			pos = Str.IndexOf("'");
			while (pos >= 0) {
				Str = Str.Substring(0, pos + 1) + "'" + Str.Substring(pos + 1);
				pos = Str.IndexOf("'", pos + 2);
			}
			dStr = "N'" + Str + "'";
		}

		return dStr;
	}

	public static string qkNStr(string iStr) {
		string Str = "";
		string dStr = "";
		int pos = 0;

		if (iStr != null) Str = iStr.Trim();
		if (Str.Length == 0)
			dStr = "%";
		else {
			pos = Str.IndexOf("'");
			while (pos >= 0) {
				Str = Str.Substring(0, pos + 1) + "'" + Str.Substring(pos + 1);
				pos = Str.IndexOf("'", pos + 2);
			}
			dStr = "N'%" + Str + "%'";
		}

		return dStr;
	}

	public static string pkChk(bool bChk, string eChr) {
		return (bChk) ? "'Y'" + eChr : "'N'" + eChr;
	}

	public static string pkChk(bool bChk) {
		return (bChk) ? "'Y'" : "'N'";
	}

	public static string pkChk(string oStr, string eChar) {
		string dStr = "";

		if (oStr == null)
			dStr = "'N'" + eChar;
		else if (oStr.Length == 0)
			dStr = "'N'" + eChar;
		else if (oStr == "Y")
			dStr = "'Y'" + eChar;
		else
			dStr = "'N'" + eChar;

		return dStr;
	}

	public static string pkChk(string oStr) {
		string dStr = "";

		if (oStr == null)
			dStr = "'N'";
		else if (oStr.Length == 0)
			dStr = "'N'";
		else if (oStr == "Y")
			dStr = "'Y'";
		else
			dStr = "'N'";

		return dStr;
	}

	public static string pkMChk(string iStr, string eChar) {
		string Str = "";
		string dStr = "";

		if (iStr != null) Str = iStr.Trim().Replace(" ", "");
		if (Str.Length == 0)
			dStr = "NULL" + eChar;
		else
			dStr = "'" + Str + "'" + eChar;

		return dStr;
	}

	public static string pkMChk(string iStr) {
		string Str = "";
		string dStr = "";

		if (iStr != null) Str = iStr.Trim().Replace(" ", "");
		if (Str.Length == 0)
			dStr = "NULL";
		else
			dStr = "'" + Str + "'";

		return dStr;
	}

	public static string pkIN(string oStr, string mode) {
		string strRet = oStr;

		strRet = strRet.Replace(" ", "");
		strRet = strRet.Replace("'", "");
		if (mode == "n")
			strRet = "(" + strRet + ")";
		else {
			strRet = strRet.Replace(",", "','");
			strRet = "('" + strRet + "')";
		}

		return strRet;
	}

	public static string pkIN(object obj, string eChar) {
		string strRet = (obj == null) ? "" : obj.ToString();

		strRet = strRet.Replace(" ", "");
		strRet = strRet.Replace("'", "''");
		strRet = "'" + strRet + "'" + eChar;

		return strRet;
	}

}



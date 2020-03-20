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

	public static string dbnull(string iStr) {
		if (iStr == null || iStr == "") return "null";

		iStr = iStr.Replace("'", "''");
		return "'" + iStr + "'";
	}
}



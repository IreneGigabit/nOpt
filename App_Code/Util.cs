using System;
using System.Collections.Generic;
using System.Web;
using System.Globalization;
using System.Text;
using System.Security.Cryptography;

public static class Util
{
    #region GetTimeString - 轉成時間字串格式(yyyy/m/d hh:mm:ss)
    /// <summary>
    /// 轉成時間字串格式(yyyy/m/d hh:mm:ss)
    /// </summary>
    public static string GetTimeString(this DateTime datetime) {
        return datetime.ToString("yyyy/M/d HH:mm:ss");
    }
    #endregion

    #region GetDateString - 轉成時間字串格式(yyyy/m/d)
    /// <summary>
    /// 轉成時間字串格式(yyyy/m/d)
    /// </summary>
    public static string GetDateString(this DateTime datetime) {
        return datetime.ToString("yyyy/M/d");
    }
    #endregion

    #region ToLongTwDate - 轉成民國日期格式(民國yyy年mm月dd日)
    /// <summary>
    /// 轉成民國日期格式(民國yyy年mm月dd日)
    /// </summary>
    public static string ToLongTwDate(this DateTime datetime) {
        return datetime.ToLongTwDate(true);
    }
    /// <summary>
    /// 轉成民國日期格式(民國yyy年mm月dd日)
    /// </summary>
    public static string ToLongTwDate(this DateTime datetime, bool padZero) {
        TaiwanCalendar taiwanCalendar = new TaiwanCalendar();

        if (padZero) {
            return string.Format("民國{0}年{1}月{2}日",
                taiwanCalendar.GetYear(datetime).ToString().PadLeft(3, '0'),
                datetime.Month.ToString().PadLeft(2, '0'),
                datetime.Day.ToString().PadLeft(2, '0'));
        }
        else {
            return string.Format("民國{0}年{1}月{2}日",
                taiwanCalendar.GetYear(datetime).ToString(),
                datetime.Month.ToString(),
                datetime.Day.ToString());
        }
    }
    #endregion

    #region ToShortTwDate - 轉成民國日期格式(yyy/mm/dd)
    /// <summary>
    /// 轉成民國日期格式(yyy/mm/dd)
    /// </summary>
    public static string ToShortTwDate(this DateTime datetime) {
        return datetime.ToShortTwDate(true);
    }
    /// <summary>
    /// 轉成民國日期格式(yyy/mm/dd)
    /// </summary>
    public static string ToShortTwDate(this DateTime datetime, bool padZero) {
        TaiwanCalendar taiwanCalendar = new TaiwanCalendar();

        if (padZero) {
            return string.Format("{0}/{1}/{2}",
                taiwanCalendar.GetYear(datetime).ToString().PadLeft(3, '0'),
                datetime.Month.ToString().PadLeft(2, '0'),
                datetime.Day.ToString().PadLeft(2, '0'));
        }
        else {
            return string.Format("{0}/{1}/{2}",
                taiwanCalendar.GetYear(datetime).ToString(),
                datetime.Month.ToString(),
                datetime.Day.ToString());
        }
    }
    #endregion

    #region GetTwYear - 取得民國年
    /// <summary>
    /// 取得民國年
    /// </summary>
    public static int GetTwYear(this DateTime datetime) {
        TaiwanCalendar taiwanCalendar = new TaiwanCalendar();

        return taiwanCalendar.GetYear(datetime);
    }
    #endregion

    #region ToD9Date - 轉成西元年99/99/9999(月/日/年) 給informix SmallDateTime 使用
    /// <summary>
    /// 轉成西元年99/99/9999(月/日/年) 給informix SmallDateTime 使用
    /// </summary>
    public static string ToD9Date(this string dateString) {
        string RtnVal = "";
        DateTime dt = new DateTime();
        if (DateTime.TryParse(dateString, out dt)) {
            RtnVal = dt.ToString("MM/dd/yyyy");
        }
        else {
            RtnVal = "";
        }
        return RtnVal;
    }
    #endregion

    #region Left
    public static string Left(this string str, int ln) {
        string sret = str.Substring(0, Math.Min(ln, str.Length));
        return sret;
    }
    #endregion

    #region Right
    public static string Right(this string str, int ln) {
        //string sret = s.Substring(str.Length - ln, ln);
        //return sret;
        ln = Math.Max(ln, 0);
        if (str.Length > ln) {
            return str.Substring(str.Length - ln, ln);
        }
        else {
            return str;
        }
    }
    #endregion

    #region Mid
    public static string Mid(this string s, int idx) {
        string sret = s.Substring(idx);
        return sret;
    }

    public static string Mid(this string s, int idx, int ln) {
        string sret = s.Substring(idx, ln);
        return sret;
    }
    #endregion

	#region CutData
	public static string CutData(this string s, int n) {
		if (n <= 0) return "";
		else if (n > System.Text.Encoding.Default.GetBytes(s).Length) return s;
		else {
			int len = 0;
			string tStr2 = "";
			for (int i = 0; i < s.Length; i++) {
				string thisChar = s.Mid(i, 1);
				len += System.Text.Encoding.Default.GetBytes(thisChar).Length;

				if (len > n) {
					tStr2 += "...";
					break;
				}
				tStr2 += thisChar;
			}
			return tStr2;
		}
	}
	#endregion

    #region ToXmlUnicode - 將&#nnnn;轉成word用格式
    /// <summary>
    /// 將&amp;#nnnn;轉成word用格式
    /// </summary>
    public static string ToXmlUnicode(this string str) {
        return str.ToXmlUnicode(false);
    }
    public static string ToXmlUnicode(this string str, bool isEng) {
        str = HttpUtility.HtmlDecode(str);
        foreach (System.Text.RegularExpressions.Match m
            in System.Text.RegularExpressions.Regex.Matches(str, "&#(?<ncr>\\d+?);"))
            str = str.Replace(m.Value, Convert.ToChar(int.Parse(m.Groups["ncr"].Value)).ToString());
        //str = str.Replace("&", "&amp;");
        //str = str.Replace("<", "&lt;");
        if (isEng) {//防止英文欄位只能半型
            str = str.Replace("’", "'");
            str = str.Replace("＆", "&");
        }
        //ret=str.Replace(">","&gt;");
        //ret=str.Replace("'","&apos;");
        //ret=str.Replace("""","&quot;");

        return str.Trim();
    }
    #endregion

    #region ToUnicode - 將字串內有&amp;#nnnn;格式字元轉成char字元
    /// <summary>
    /// 將字串內有&amp;#nnnn;格式字元轉成char字元
    /// </summary>
    public static string ToUnicode(this string str) {
        //HttpUtility.HtmlDecode("中b文a字&amp;&copy;&Agrave;α-澱粉水解&#37238;之製造方法");
        foreach (System.Text.RegularExpressions.Match m
            in System.Text.RegularExpressions.Regex.Matches(str, "&#(?<ncr>\\d+?);"))
            str = str.Replace(m.Value, Convert.ToChar(int.Parse(m.Groups["ncr"].Value)).ToString());
        return str;
    }
    #endregion

    #region ToBig5 - 將難字轉成&#nnnn;
    /// <summary>
    /// 將難字轉成&amp;#nnnn;
    /// </summary>
    public static string ToBig5(this string str) {
        StringBuilder sb = new StringBuilder();
        Encoding big5 = Encoding.GetEncoding("big5");
        foreach (char c in str) {
            string cInBig5 = big5.GetString(big5.GetBytes(new char[] { c }));
            if (c != '?' && cInBig5 == "?")
                sb.AppendFormat("&#{0};", Convert.ToInt32(c));
            else
                sb.Append(c);
        }
        return sb.ToString();
    }
    #endregion

    #region GetHashValueMD5 - 依據帶入的字串，產生MD5
    //依據帶入的字串，產生MD5
    public static string GetHashValueMD5(this String data) {
        MD5CryptoServiceProvider md5Hasher = new MD5CryptoServiceProvider();

        byte[] myData = md5Hasher.ComputeHash(System.Text.Encoding.ASCII.GetBytes(data));
        System.Text.StringBuilder sBuilder = new System.Text.StringBuilder();

        for (int i = 0; i < myData.Length; i++) {
            sBuilder.Append(myData[i].ToString("x2"));
        }

        return sBuilder.ToString();
    }
    #endregion
}

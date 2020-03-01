using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Text.RegularExpressions;

/// <summary>
/// 產生html碼
/// </summary>
public static class SHtml
{
    /// <summary>
    /// 產生Option字串
    /// </summary> 
    /// <param name="valueFormat">option的value格式用{}包住欄位,ex:{scode}</param>
    /// <param name="textFormat">option的文字格式用{}包住欄位,ex:{scode}_{sc_name}</param>
    /// <param name="attrFormat">option的attribute格式用{}包住欄位,ex:value1='{scode1}'</param>
    /// <param name="showEmpty">空白選項的顯示字串</param>
    /// <returns></returns>
    public static string Option(this DataTable dt, string valueFormat, string textFormat, string attrFormat, string emptyStr) {
        Regex rgx = new Regex("{([^{}]+)}", RegexOptions.IgnoreCase);
        string rtnStr="";
        if (emptyStr != "")
            rtnStr += "<option value='' style='color:blue' selected>" + emptyStr + "</option>\n";

        for (int r = 0; r < dt.Rows.Count; r++) {
            //處理value
            string val = valueFormat;
            foreach (Match match in rgx.Matches(valueFormat)) {
                val = val.Replace(match.Value, dt.Rows[r][match.Result("$1")].ToString());
            }

            //處理value
            string txt = textFormat;
            foreach (Match match in rgx.Matches(textFormat)) {
                txt = txt.Replace(match.Value, dt.Rows[r][match.Result("$1")].ToString());
            }

            //處理attribute
            string attr = attrFormat;
            foreach (Match match in rgx.Matches(attrFormat)) {
                attr = attr.Replace(match.Value, dt.Rows[r][match.Result("$1")].ToString());
            }
            rtnStr += "<option value='" + val + "' " + attr + ">" + txt + "</option>\n";
        }
        return rtnStr;
    }
}

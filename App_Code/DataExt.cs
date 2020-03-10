using System;
using System.Collections.Generic;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Text;
using System.Reflection;
using System.Linq;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;


namespace System.Runtime.CompilerServices
{
	public class ExtensionAttribute : Attribute { }
}


/// <summary>
/// ref:https://msdn.microsoft.com/zh-tw/library/cc716729(v=vs.110).aspx
/// </summary>
public static class DataExt
{
    static string debugStr = "";

    #region 分頁擴展
    /// <summary>
    /// 分頁控制項
    /// </summary>
    /// <param name="conn">連線物件</param> 
    /// <param name="dt">回傳DataTable</param> 
    /// <param name="totRow">總筆數</param> 
    /// <param name="strFields">T-SQL欄位</param> 
    /// <param name="strFrom">T-SQL table+join+where</param> 
    /// <param name="strOrderBy">排序欄位(不含別名)</param> 
    /// <param name="nowPage">目前頁數</param> 
    /// <param name="perPageSize">每頁N筆</param> 
    public static string Paging(DBHelper conn, DataTable dt, out int totRow, string strFields, string strFrom, string strOrderBy, int nowPage, int perPageSize) {
        int[] arrPerPage = new int[] { 10, 20, 30, 40, 50 };
        return Paging(conn, dt, out totRow, strFields, strFrom, strOrderBy, nowPage, perPageSize, arrPerPage);
    }

    /// <summary>
    /// 分頁控制項
    /// </summary>
    /// <param name="conn">連線物件</param> 
    /// <param name="dt">回傳DataTable</param> 
    /// <param name="totRow">總筆數</param> 
    /// <param name="strFields">T-SQL欄位</param> 
    /// <param name="strFrom">T-SQL table+join+where</param> 
    /// <param name="strOrderBy">排序欄位(不含別名)</param> 
    /// <param name="nowPage">目前頁數</param> 
    /// <param name="perPageSize">每頁N筆</param> 
    /// <param name="arrPerPage">每頁N筆選項</param> 
    public static string Paging(DBHelper conn, DataTable dt, out int totRow, string strFields, string strFrom, string strOrderBy, int nowPage, int perPageSize, int[] arrPerPage) {
        string sqlCount = "SELECT COUNT(*) " + strFrom;
        totRow = Convert.ToInt32(conn.ExecuteScalar(sqlCount));
        int totPage = (int)Math.Ceiling((decimal)totRow / perPageSize);
        nowPage = Math.Min(nowPage, totPage);

        int StartRow = (nowPage - 1) * perPageSize;
        int EndRow = nowPage * perPageSize;

        string SQL = "SELECT * FROM (SELECT ROW_NUMBER() OVER (ORDER BY {2}) AS RowNum,* from ( SELECT {0} {1} )z )NewTable WHERE RowNum > {3} AND RowNum <= {4}";
        SQL = string.Format(SQL, strFields, strFrom, strOrderBy, StartRow, EndRow);
        conn.DataTable(SQL, dt);

        //第N頁
        string StrPgSel = "<select id=\"GoPage\" name=\"GoPage\" size=\"1\" style=\"color:red\">\n";
        for (int i = 1; i <= totPage; i++) {
            StrPgSel += "<option value=\"" + i + "\" " + (i == nowPage ? "selected=\"selected\"" : "") + ">" + i + "</option>\n";
        }
        StrPgSel += "</select>\n";

        //上一頁/下一頁
        string StrNxtPrv = "";
        if (nowPage > 1) {
            StrNxtPrv += " | <u class=\"pgGo\" v1=\"" + (nowPage - 1) + "\">上一頁</u>\n";
        }
        if (nowPage < totPage) {
            StrNxtPrv += " | <u class=\"pgGo\" v1=\"" + (nowPage + 1) + "\">下一頁</u>\n";
        }

        //每頁N筆
        string StrPgSz = "<select id=\"PerPage\" name=\"PerPage\" size=\"1\" style=\"color:red\">\n";
        foreach (int p in arrPerPage) {
            StrPgSz += String.Format("<option value=\"{0}\" {1}>{0}</option>\n", p, (p == perPageSize ? " selected=\"selected\"" : ""));
        }
        StrPgSz += "</select>\n";

        return String.Format("第<font color=\"red\">{0}/{1}</font>頁 | 共<font color=\"red\">{2}</font>筆 | 跳至第{3}頁{4} | 每頁筆數:{5}\n"
            , nowPage, totPage, totRow, StrPgSel, StrNxtPrv, StrPgSz);
    }
    #endregion

    #region DataTable 擴展
    /// <summary>
    /// 轉換為物件實體：T為資料型別
    /// ref:https://blog.csdn.net/qiqingli/article/details/78999284
    /// ref:https://www.itread01.com/content/1545094027.html
    /// </summary>
    public static List<T> Mapping<T>(this DataTable dt) {
        List<T> lists = new List<T>();
        for (int i = 0; i < dt.Rows.Count; i++) {
            T t = Activator.CreateInstance<T>();
            //獲取T物件的所有屬性
            PropertyInfo[] propertys = t.GetType().GetProperties();
            //通過屬性集合迭代出每一個屬性對象
            foreach (PropertyInfo item in propertys) {
                int index = dt.Columns.IndexOf(item.Name);// datatable中column名不區分大小寫,
                if (index >= 0)//dt.Columns.Contains(item.Name),用index讀取值速度要更好一些
                {
                    //判斷DataTable的Column Value是否為null
                    if (dt.Rows[i][index] != DBNull.Value)
                        //將當前DataTable的單列值賦予相匹配的屬性,否則賦予一個null值.
                        item.SetValue(t, (dt.Rows[i][index]), null);
                    else
                        item.SetValue(t, null, null);
                }
            }
            lists.Add(t);
        }
        return lists;
    }

    /// <summary>
    /// 轉換為Dictionary
    /// ref:http://hk.voidcc.com/question/p-ejqlvzbf-ne.html
    /// </summary>
    public static IEnumerable<Dictionary<string, object>> ToDictionary(this DataTable table) {
        return table.Select().Select(x => x.ItemArray.Select((a, i) => new { Name = table.Columns[i].ColumnName, Value = a })
                        .ToDictionary(a => a.Name, a => a.Value));
    }

    /*
    public static void ToDictionary(this DataTable table,Dictionary<string, object> RtnVal) {
		table.ToDictionary(RtnVal, false);
	}

	public static void ToDictionary(this DataTable table,Dictionary<string, object> RtnVal, bool debug) {
		if (table.Rows.Count > 0) {
			foreach (DataColumn column in table.Columns) {
				object colValue;
				column.MappingType(table.Rows[0][column.ColumnName], true, out colValue);
				try {
					RtnVal.Add(column.ColumnName.ToLower(), colValue);
				}
				catch(Exception ex) {
					throw new Exception("[" + column.ColumnName + "]", ex);
				}
			}
		} else {
			foreach (DataColumn column in table.Columns) {
				object colValue;
				column.MappingType((object)DBNull.Value, true, out colValue);
				RtnVal.Add(column.ColumnName.ToLower(), colValue);
			}
		}

		if (debug) {
			debugStr = "";
			debugStr += String.Format("筆數:{0}<BR>", table.Rows.Count);
			debugStr += "<table border=1>";
			debugStr += "<tr>";
			foreach (var entry in RtnVal) {
				debugStr += "<td>" + entry.Key + "(" + (entry.Value ?? "").GetType() + ")</td>";
			}
			debugStr += "</tr>";
			debugStr += "<tr>";
			foreach (var entry in RtnVal) {
				debugStr += "<td>" + entry.Value + "</td>";
			}
			debugStr += "</tr>";
			debugStr += "</table>";
			HttpContext.Current.Response.Write(debugStr);

		}
	}*/

    /*
	public static ArrayList ToList(this DataTable table) {
		return table.ToList(false);
	}

	public static ArrayList ToList(this DataTable table, bool debug) {
		ArrayList rtnArry = new ArrayList();

		if (table.Rows.Count > 0) {
			foreach (DataRow row in table.Rows) {
				Dictionary<string, object> RtnVal = new Dictionary<string, object>();
				foreach (DataColumn column in table.Columns) {
					object colValue;
					column.MappingType(row[column.ColumnName], false, out colValue);
					RtnVal.Add(column.ColumnName, colValue);
				}
				rtnArry.Add(RtnVal);
			}
		}

		if (debug) {
			debugStr = "";
			debugStr += String.Format("筆數:{0}<BR>", table.Rows.Count);
			debugStr += "<table border=1>";
			debugStr += "<tr>";
			foreach (var entry in (Dictionary<string, object>)rtnArry[0]) {
				debugStr += "<td>" + entry.Key + "(" + (entry.Value ?? "").GetType() + ")</td>";
			}
			debugStr += "</tr>";
			foreach (Dictionary<string, object> item in rtnArry) {
				debugStr += "<tr>";
				foreach (var entry in item) {
					debugStr += "<td>" + entry.Value + "</td>";
				}
				debugStr += "</tr>";
			}
			debugStr += "</table>";
			HttpContext.Current.Response.Write(debugStr);
		}

		return rtnArry;
	}*/
    #endregion

    #region DataColumn 擴展
    /*
    public static string ToHexString(this byte[] hex) {
        if (hex == null) return null;
        if (hex.Length == 0) return string.Empty;

        var s = new StringBuilder();
        foreach (byte b in hex) {
            s.Append(b.ToString("x2"));
        }
        return s.ToString();
    }

    private static void MappingType(this DataColumn col, object inVal, bool debugFlag, out object RtnVal) {
        string mType = "";
        string mValue = "";
        if (col.DataType == System.Type.GetType("System.Int16")) {
            mType = "int16";
            if (inVal is DBNull) {
                RtnVal = "";
            }
            else {
                RtnVal = Int16.Parse(inVal.ToString());
            }
            mValue = RtnVal.ToString();
        }
        else if (col.DataType == System.Type.GetType("System.Int32")) {
            mType += "int32";
            if (inVal is DBNull) {
                RtnVal = "";
            }
            else {
                RtnVal = Int32.Parse(inVal.ToString());
            }
            mValue = RtnVal.ToString();
        }
        else if (col.DataType == System.Type.GetType("System.Int64")) {
            mType += "int64";
            if (inVal is DBNull) {
                RtnVal = "";
            }
            else {
                RtnVal = Int64.Parse(inVal.ToString());
            }
            mValue = RtnVal.ToString();
        }
        else if (col.DataType == System.Type.GetType("System.Double")) {
            mType += "float";
            RtnVal = inVal is DBNull ? 0 : float.Parse(inVal.ToString());
            mValue = RtnVal.ToString();
        }
        else if (col.DataType == System.Type.GetType("System.Decimal")) {
            mType += "decimal";
            RtnVal = inVal is DBNull ? 0 : decimal.Parse(inVal.ToString());
            mValue = RtnVal.ToString();
        }
        else if (col.DataType == System.Type.GetType("System.DateTime")) {
            mType += "datetime";
            DateTime dt = new DateTime();
            if (DateTime.TryParse(inVal.ToString(), out dt)) {
                RtnVal = dt.ToString("yyyy/MM/dd HH:mm:ss").Replace(" 00:00:00", "");
            }
            else {
                RtnVal = "";
            }
            mValue = (string)RtnVal;
        }
        else if (col.DataType == System.Type.GetType("System.Byte")) {
            mType += "byte";
            RtnVal = inVal is DBNull ? new Byte() : Byte.Parse(inVal.ToString());
            mValue = ((byte)RtnVal).ToString("x2");
        }
        else if (col.DataType == System.Type.GetType("System.Byte[]")) {
            mType += "byte[]";
            RtnVal = inVal is DBNull ? (Byte[])null : (Byte[])inVal;
            mValue = ((Byte[])RtnVal).ToHexString();
        }
        else if (col.DataType == System.Type.GetType("System.Boolean")) {
            mType += "bool";
            RtnVal = inVal is DBNull ? (bool)false : inVal.ToString().ToLower().StartsWith("true");
            mValue = RtnVal.ToString();
        }
        else {
            mType += "string";
            RtnVal = inVal is DBNull ? "" : inVal.ToString().Trim();
            mValue = (string)RtnVal;
        }
        //if (debugFlag) {
        //	debugStr += String.Format("{0}({1})→{2}={3}<BR>", col.ColumnName, col.DataType.ToString(), mType, mValue);
        //	HttpContext.Current.Response.Write(debugStr);
        //}
    }*/
    #endregion

    #region DataReader 擴展
    /// <summary>
    /// 獲取指定型別
    /// </summary> 
    /// <param name="fieldName">欄位名稱</param>
    /// <param name="defaultValue">若是null時回傳預設值</param>
    /// <returns></returns>
    public static T SafeRead<T>(this IDataReader reader, string fieldName, T defaultValue) {
        try {
            object obj = reader[fieldName];
            if (obj == null || obj == System.DBNull.Value)
                return defaultValue;

            return (T)Convert.ChangeType(obj, defaultValue.GetType());
        }
        catch {
            return defaultValue;
        }
    }

    ///// <summary>
    ///// 獲取字串
    ///// </summary> 
    ///// <param name="colName">欄位名稱</param>  
    ///// <returns></returns>  
    //public static string GetString(this IDataReader dr, string colName) {
    //	if (dr[colName] != DBNull.Value && dr[colName] != null)
    //		return dr[colName].ToString().Trim();
    //	return String.Empty;
    //}
    ///// <summary>
    ///// 獲取DateTime(null時回傳現在時間)
    ///// </summary>
    ///// <param name="colName">欄位名稱</param>  
    ///// <returns></returns>
    //public static DateTime GetDateTime(this IDataReader dr, string colName) {
    //	DateTime result = DateTime.Now;
    //	if (dr[colName] != DBNull.Value && dr[colName] != null) {
    //		if (!DateTime.TryParse(dr[colName].ToString(), out result))
    //			throw new Exception("日期格式數據轉換失敗(" + colName + ")");
    //	}
    //	return result;
    //}
    ///// <summary>
    ///// 獲取DateTime(可回傳null)
    ///// </summary>
    ///// <param name="colName">欄位名稱</param>  
    ///// <returns></returns>
    //public static DateTime? GetNullDateTime(this IDataReader dr, string colName) {

    //	DateTime? result = null;
    //	DateTime time = DateTime.Now;
    //	if (dr[colName] != DBNull.Value && dr[colName] != null) {
    //		if (!DateTime.TryParse(dr[colName].ToString(), out time))
    //			throw new Exception("日期格式數據轉換失敗(" + colName + ")");
    //		result = time;
    //	}
    //	return result;
    //}

    ///// <summary>
    ///// 獲取Int16
    ///// </summary>
    ///// <param name="colName">欄位名稱</param>  
    ///// <returns></returns>
    //public static Int16 GetInt16(this IDataReader dr, string colName) {
    //	short result = 0;
    //	if (dr[colName] != DBNull.Value && dr[colName] != null) {
    //		if (!short.TryParse(dr[colName].ToString(), out result))
    //			throw new Exception("短整形轉換失敗(" + colName + ")");
    //	}
    //	return result;
    //}

    ///// <summary>
    ///// 獲取Int32
    ///// </summary>
    ///// <param name="colName">欄位名稱</param>  
    ///// <returns></returns>
    //public static int GetInt32(this IDataReader dr, string colName) {
    //	int result = 0;

    //	if (dr[colName] != DBNull.Value && dr[colName] != null) {
    //		if (!int.TryParse(dr[colName].ToString(), out result))
    //			throw new Exception("整形轉換失敗(" + colName + ")");
    //	}
    //	return result;
    //}

    ///// <summary>
    ///// 獲取Double
    ///// </summary>
    ///// <param name="colName">欄位名稱</param>  
    ///// <returns></returns>
    //public static double GetDouble(this IDataReader dr, string colName) {
    //	double result = 0.00;
    //	if (dr[colName] != DBNull.Value && dr[colName] != null) {
    //		if (!double.TryParse(dr[colName].ToString(), out result))
    //			throw new Exception("雙精度類型轉換失敗(" + colName + ")");
    //	}
    //	return result;
    //}
    ///// <summary>
    ///// 獲取Single
    ///// </summary>
    ///// <param name="colName">欄位名稱</param>  
    ///// <returns></returns>
    //public static float GetSingle(this IDataReader dr, string colName) {
    //	float result = 0.00f;
    //	if (dr[colName] != DBNull.Value && dr[colName] != null) {
    //		if (!float.TryParse(dr[colName].ToString(), out result))
    //			throw new Exception("單精度類型轉換失敗(" + colName + ")");
    //	}

    //	return result;
    //}

    ///// <summary>
    ///// 獲取Decimal
    ///// </summary>
    ///// <param name="colName">欄位名稱</param>  
    ///// <returns></returns>
    //public static decimal GetDecimal(this IDataReader dr, string colName) {
    //	decimal result = 0.00m;
    //	if (dr[colName] != DBNull.Value && dr[colName] != null) {
    //		if (!decimal.TryParse(dr[colName].ToString(), out result))
    //			throw new Exception("Decimal類型轉換失敗(" + colName + ")");
    //	}
    //	return result;
    //}

    ///// <summary>
    ///// 獲取Byte
    ///// </summary> 
    ///// <param name="colName">欄位名稱</param>  
    ///// <returns></returns>
    //public static byte GetByte(this IDataReader dr, string colName) {
    //	byte result = 0;
    //	if (dr[colName] != DBNull.Value && dr[colName] != null) {
    //		if (!byte.TryParse(dr[colName].ToString(), out result))
    //			throw new Exception("Byte類型轉換失敗(" + colName + ")");
    //	}
    //	return result;
    //}

    ///// <summary>
    ///// 獲取bool(如果是1或Y時回傳true);
    ///// </summary>
    ///// <param name="colName">欄位名稱</param>  
    ///// <returns></returns>
    //public static bool GetBool(this IDataReader dr, string colName) {
    //	if (dr[colName] != DBNull.Value && dr[colName] != null) {
    //		return dr[colName].ToString() == "1" || dr[colName].ToString() == "Y" || dr[colName].ToString().ToLower() == "true";
    //	}
    //	return false;
    //}
    #endregion

    #region DataRow 擴展
    /// <summary>
    /// 轉換為Dictionary
    /// ref:https://social.msdn.microsoft.com/Forums/vstudio/en-US/72587038-2e63-4693-b57f-ab9d3d4af024/convert-datarow-to-idictionarystring-object?forum=wfprerelease
    /// </summary>
    public static Dictionary<string, object> ToDictionary(this DataRow dr) {
        return dr.Table.Columns
              .Cast<DataColumn>()
              .ToDictionary(col => col.ColumnName, col => dr[col.ColumnName]);
    }

    /// <summary>
    /// 獲取指定型別
    /// </summary> 
    /// <param name="fieldName">欄位名稱</param>
    /// <param name="defaultValue">若是null時回傳預設值</param>
    /// <returns></returns>
    public static T SafeRead<T>(this DataRow dr, string fieldName, T defaultValue) {
        try {
            object obj = dr[fieldName];
            if (obj == null || obj == System.DBNull.Value)
                return defaultValue;

            return (T)Convert.ChangeType(obj, defaultValue.GetType());
        }
        catch {
            return defaultValue;
        }
    }

    /*
	/// <summary>
	/// 獲取字串
	/// </summary> 
	/// <param name="colName"></param>  
	/// <returns></returns>  
	public static string GetString(this DataRow dr, string colName) {
		if (dr[colName] != DBNull.Value && dr[colName] != null)
			return dr[colName].ToString().Trim();
		return String.Empty;
	}
	/// <summary>
	/// 獲取DateTime(null時回傳現在時間)
	/// </summary>
	/// <param name="colName"></param>
	/// <returns></returns>
	public static DateTime GetDateTime(this DataRow dr, string colName) {
		DateTime result = DateTime.Now;
		if (dr[colName] != DBNull.Value && dr[colName] != null) {
			if (!DateTime.TryParse(dr[colName].ToString(), out result))
				throw new Exception("GetDateTime轉換失敗(" + colName + ")");
		}
		return result;
	}
	/// <summary>
	/// 獲取DateTime(可回傳null)
	/// </summary>
	/// <param name="colName"></param>
	/// <returns></returns>
	public static DateTime? GetNullDateTime(this DataRow dr, string colName) {

		DateTime? result = null;
		DateTime time = DateTime.Now;
		if (dr[colName] != DBNull.Value && dr[colName] != null) {
			if (!DateTime.TryParse(dr[colName].ToString(), out time))
				throw new Exception("GetNullDateTime轉換失敗(" + colName + ")");
			result = time;
		}
		return result;
	}

	/// <summary>
	/// 獲取Int16
	/// </summary>
	/// <param name="colName"></param>
	/// <returns></returns>
	public static Int16 GetInt16(this DataRow dr, string colName) {
		short result = 0;
		if (dr[colName] != DBNull.Value && dr[colName] != null) {
			if (!short.TryParse(dr[colName].ToString(), out result))
				throw new Exception("GetInt16轉換失敗(" + colName + ")");
		}
		return result;
	}

	/// <summary>
	/// 獲取Int32
	/// </summary>
	/// <param name="colName"></param>
	/// <returns></returns>
	public static int GetInt32(this DataRow dr, string colName) {
		int result = 0;

		if (dr[colName] != DBNull.Value && dr[colName] != null) {
			if (!int.TryParse(dr[colName].ToString(), out result))
				throw new Exception("GetInt32轉換失敗(" + colName + ")");
		}
		return result;
	}

	/// <summary>
	/// 獲取Double
	/// </summary>
	/// <param name="colName"></param> 
	/// <returns></returns>
	public static double GetDouble(this DataRow dr, string colName) {
		double result = 0.00;
		if (dr[colName] != DBNull.Value && dr[colName] != null) {
			if (!double.TryParse(dr[colName].ToString(), out result))
				throw new Exception("GetDouble轉換失敗(" + colName + ")");
		}
		return result;
	}
	/// <summary>
	/// 獲取Single
	/// </summary>
	/// <param name="colName"></param>
	/// <returns></returns>
	public static float GetSingle(this DataRow dr, string colName) {
		float result = 0.00f;
		if (dr[colName] != DBNull.Value && dr[colName] != null) {
			if (!float.TryParse(dr[colName].ToString(), out result))
				throw new Exception("GetSingle轉換失敗(" + colName + ")");
		}

		return result;
	}

	/// <summary>
	/// 獲取Decimal
	/// </summary>
	/// <param name="colName"></param> 
	/// <returns></returns>
	public static decimal GetDecimal(this DataRow dr, string colName) {
		decimal result = 0.00m;
		if (dr[colName] != DBNull.Value && dr[colName] != null) {
			if (!decimal.TryParse(dr[colName].ToString(), out result))
				throw new Exception("GetDecimal轉換失敗(" + colName + ")");
		}
		return result;
	}

	/// <summary>
	/// 獲取Byte
	/// </summary> 
	/// <param name="colName"></param>
	/// <returns></returns>
	public static byte GetByte(this DataRow dr, string colName) {
		byte result = 0;
		if (dr[colName] != DBNull.Value && dr[colName] != null) {
			if (!byte.TryParse(dr[colName].ToString(), out result))
				throw new Exception("GetByte轉換失敗(" + colName + ")");
		}
		return result;
	}

	/// <summary>
	/// 獲取bool(如果是1或Y時回傳true);
	/// </summary>
	/// <param name="colName"></param>
	/// <returns></returns>
	public static bool GetBool(this DataRow dr, string colName) {
		if (dr[colName] != DBNull.Value && dr[colName] != null) {
			return dr[colName].ToString() == "1" || dr[colName].ToString() == "Y" || dr[colName].ToString().ToLower() == "true";
		}
		return false;
	}
    */
    #endregion

}


/// <summary>
/// Json.Net對DBNull的轉換處理，此處只寫了轉換成JSON字符串的處理，JSON字符串轉物件的未處理
/// ref:https://www.cnblogs.com/wsq-blog/p/10888566.html
/// </summary>
#region class DBNullCreationConverter
public class DBNullCreationConverter : JsonConverter
{
	/// <summary>
	/// 是否允許轉換
	/// </summary>
	public override bool CanConvert(Type objectType) {
		bool canConvert = false;
		switch (objectType.FullName) {
			case "System.DBNull":
				canConvert = true;
				break;
		}
		return canConvert;
	}

	public override object ReadJson(JsonReader reader, Type objectType, object existingValue, JsonSerializer serializer) {
		return existingValue;
	}

	public override void WriteJson(JsonWriter writer, object value, JsonSerializer serializer) {
		writer.WriteValue(string.Empty);
	}

	public override bool CanRead {
		get {
			return false;
		}
	}
	/// <summary>
	/// 是否允許轉換JSON字符串時調用
	/// </summary>
	public override bool CanWrite {
		get {
			return true;
		}
	}
}
#endregion

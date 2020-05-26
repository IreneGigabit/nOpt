<%@ Page Language="C#" CodePage="65001" AutoEventWireup="true"  %>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "System.Text"%>
<%@ Import Namespace = "System.Data.SqlClient"%>
<%@ Import Namespace = "System.IO"%>
<%@ Import Namespace = "System.Linq"%>
<%@ Import Namespace = "System.Collections.Generic"%>
<%@ Import Namespace = "System.Web.Script.Serialization"%>
<%@ Import Namespace = "Newtonsoft.Json"%>

<script runat="server">
    protected string isql = "";
    protected string HTProgCode = HttpContext.Current.Request["prgid"] ?? "";//功能權限代碼
    protected string prgid = HttpContext.Current.Request["prgid"] ?? "";//程式代碼
    protected int HTProgRight = 0;

    protected Dictionary<string, string> ReqVal = new Dictionary<string, string>();

    protected void Page_Load(object sender, EventArgs e) {
        Token myToken = new Token(HTProgCode);
        HTProgRight = myToken.CheckMe(false, true);

        ReqVal = Request.QueryString.ToDictionary();

        bool first_check = false;//判斷有無填寫條件
        bool last_check = false;//判斷有無填寫條件
        bool last_CNot_check = false;//判斷有無填寫條件
        
        using (DBHelper conn = new DBHelper(Conn.OptK).Debug(false)) {
            isql = "SELECT *,''fBJTseq,''opt_comfirm_str,''opt_check_str,''law_detail_no ";
            isql+="FROM law_opt where 1=1 ";

            if ((Request["qry_opt_no"] ?? "") != "") {
                isql += " AND opt_no = '" + Request["qry_opt_no"] + "' ";
		    }
            if ((Request["qry_BJTbranch"] ?? "") != "") {
                isql += " and BJTbranch='" + Request["qry_BJTbranch"] + "'";
            }
            if ((Request["qry_BJTSeq"] ?? "") != "") {
                isql += " AND BJTSeq='" + Request["qry_BJTSeq"] + "'";
            }
            if ((Request["qry_BJTSeq1"] ?? "") != "") {
                isql += " AND BJTSeq1='" + Request["qry_BJTSeq1"] + "'";
            }
            if ((Request["qry_branch"] ?? "") != "") {
                isql += " AND branch='" + Request["qry_branch"] + "'";
            }
            if ((Request["qry_BSeq"] ?? "") != "") {
                isql += " and Bseq='" + Request["qry_BSeq"] + "'";
            }
            if ((Request["qry_BSeq1"] ?? "") != "") {
                isql += " and Bseq1='" + Request["qry_BSeq1"] + "'";
            }
            if ((Request["qry_pr_no"] ?? "") != "") {
                isql += " and pr_no='" + Request["qry_pr_no"] + "'";
            }
            if ((Request["qry_opt_comfirm"] ?? "") != "") {
                isql += " and opt_comfirm='" + Request["qry_opt_comfirm"] + "'";
            }
            if ((Request["qry_opt_check"] ?? "") != "") {
                isql += " and opt_check='" + Request["qry_opt_check"] + "'";
            }
            if ((Request["qry_opt_class"] ?? "") != "") {
                string[] arr_opt_class = ReqVal.TryGet("qry_opt_class", "").Split(',');
                isql += " AND (";
                for (int i = 0; i < arr_opt_class.Length; i++) {
                    isql += (i > 0 ? " OR" : "");
                    isql += " ','+opt_class+',' like '%," + arr_opt_class[i] + ",%'";
                }
                isql += " ) ";
            }

            if ((Request["No_date"] ?? "") != "Y") {
                if ((Request["qry_pr_date_B"] ?? "") != "") {
                    isql += " and pr_date>='" + Request["qry_pr_date_B"] + "'";
                }
                if ((Request["qry_pr_date_E"] ?? "") != "") {
                    isql += " and pr_date<='" + Request["qry_pr_date_E"] + "'";
                }
            }

            //法條搜尋條件
            first_check=false;//判斷有無填寫條件
            for (int i = 1; i <= int.Parse(ReqVal.TryGet("class_num","0")); i++) {
                if ((Request["law_type1_"+i] ?? "") != ""
                    ||(Request["law_type2_"+i] ?? "") != ""
                    ||(Request["law_type3_"+i] ?? "") != "") {
                    first_check=true;
                    break;
                }
            }

            if (first_check) {
                isql += "  AND ( ";
                for (int i = 1; i <= int.Parse(ReqVal.TryGet("class_num", "0")); i++) {
                    if ((Request["law_type1_" + i] ?? "") != ""|| (Request["law_type2_" + i] ?? "") != ""|| (Request["law_type3_" + i] ?? "") != "") {
                        isql += (i == 1 ? " ( " : " OR ( ");
                        if ((Request["law_type1_" + i] ?? "") != "") {
                            isql += " ','+ref_law+',' like '%," + Request["law_type1_" + i] + ",%' ";
                        }
                        if ((Request["law_type2_" + i] ?? "") != "") {
                            isql += " AND ','+ref_law+',' like '%," + Request["law_type2_" + i] + ",%' ";
                        }
                        if ((Request["law_type3_" + i] ?? "") != "") {
                            isql += " AND ','+ref_law+',' like '%," + Request["law_type3_" + i] + ",%' ";
                        }
                        isql += " ) ";
                    }
                }
                isql += "  ) ";
            }

            //全文檢索-商標名稱
            if ((Request["qry_opt_pic"] ?? "") == "Y") {
                first_check = false;//判斷有無填寫包含條件
                for (int i = 1; i <= int.Parse(ReqVal.TryGet("law_count", "0")); i++) {
                    if ((Request["f_wordA_" + i + "_1"] ?? "") != ""
                        || (Request["f_wordA_" + i + "_2"] ?? "") != ""
                        || (Request["f_wordA_" + i + "_3"] ?? "") != "") {
                        first_check = true;
                        break;
                    }
                }
                
                if (first_check) {
                    isql += "  AND( ( ";
                    for (int i = 1; i <= int.Parse(ReqVal.TryGet("law_count", "0")); i++) {
                        if ((Request["f_wordA_" + i + "_1"] ?? "") != "" || (Request["f_wordA_" + i + "_2"] ?? "") != "" || (Request["f_wordA_" + i + "_3"] ?? "") != "") {
                            isql += (i == 1 ? " ( " : " OR ( ");
                            if ((Request["f_wordA_" + i + "_1"] ?? "") != "") {
                                isql += " opt_pic like '%" + Request["f_wordA_" + i + "_1"] + "%' ";
                            }
                            if ((Request["f_wordA_" + i + "_1"] ?? "") != "") {
                                isql += " AND opt_pic like '%" + Request["f_wordA_" + i + "_2"] + "%' ";
                            }
                            if ((Request["f_wordA_" + i + "_1"] ?? "") != "") {
                                isql += " AND opt_pic like '%" + Request["f_wordA_" + i + "_3"] + "%' ";
                            }
                            isql += " ) ";
                        }
                    }
                    isql += "  ) ";
                }

                first_check = false;//判斷有無填寫不包含條件
                for (int i = 1; i <= int.Parse(ReqVal.TryGet("law_CNot", "0")); i++) {
                    if ((Request["f_wordB_" + i + "_1"] ?? "") != ""
                        || (Request["f_wordB_" + i + "_2"] ?? "") != ""
                        || (Request["f_wordB_" + i + "_3"] ?? "") != "") {
                        first_check = true;
                        break;
                    }
                }
                if (first_check) {
                    isql += "  AND ( ";
                    for (int i = 1; i <= int.Parse(ReqVal.TryGet("law_CNot", "0")); i++) {
                        if ((Request["f_wordB_" + i + "_1"] ?? "") != "" || (Request["f_wordB_" + i + "_2"] ?? "") != "" || (Request["f_wordB_" + i + "_3"] ?? "") != "") {
                            isql += (i == 1 ? " ( " : " OR ( ");
                            if ((Request["f_wordB_" + i + "_1"] ?? "") != "") {
                                isql += " opt_pic NOT like '%" + Request["f_wordB_" + i + "_1"] + "%' ";
                            }
                            if ((Request["f_wordB_" + i + "_1"] ?? "") != "") {
                                isql += " AND opt_pic NOT like '%" + Request["f_wordB_" + i + "_2"] + "%' ";
                            }
                            if ((Request["f_wordB_" + i + "_1"] ?? "") != "") {
                                isql += " AND opt_pic NOT like '%" + Request["f_wordB_" + i + "_3"] + "%' ";
                            }
                            isql += " ) ";
                        }
                    }
                    isql += "  ) ";
                }

                last_check = false;//判斷有無填寫包含條件
                for (int i = 1; i <= int.Parse(ReqVal.TryGet("law_count", "0")); i++) {
                    if ((Request["f_wordA_" + i + "_1"] ?? "") != ""|| (Request["f_wordA_" + i + "_2"] ?? "") != ""|| (Request["f_wordA_" + i + "_3"] ?? "") != "") {
                        last_check = true;
                        break;
                    }
                }
                last_CNot_check = false;//判斷有無填寫包含條件
                for (int i = 1; i <=int.Parse(ReqVal.TryGet("law_CNot", "0")); i++) {
                    if ((Request["f_wordB_" + i + "_1"] ?? "") != "" || (Request["f_wordB_" + i + "_2"] ?? "") != "" || (Request["f_wordB_" + i + "_3"] ?? "") != "") {
                        last_CNot_check = true;
                        break;
                    }
                }

                if( last_check|| last_CNot_check){
                    isql += "  ) ";
                }
            }


            //全文檢索-客戶名稱
            if ((Request["qry_cust_name"] ?? "") == "Y") {
                first_check = false;//判斷有無填寫包含條件
                for (int i = 1; i <= int.Parse(ReqVal.TryGet("law_count", "0")); i++) {
                    if ((Request["f_wordA_" + i + "_1"] ?? "") != ""
                        || (Request["f_wordA_" + i + "_2"] ?? "") != ""
                        || (Request["f_wordA_" + i + "_3"] ?? "") != "") {
                        first_check = true;
                        break;
                    }
                }

                if (first_check) {
                    isql += "  AND( ( ";
                    for (int i = 1; i <= int.Parse(ReqVal.TryGet("law_count", "0")); i++) {
                        if ((Request["f_wordA_" + i + "_1"] ?? "") != "" || (Request["f_wordA_" + i + "_2"] ?? "") != "" || (Request["f_wordA_" + i + "_3"] ?? "") != "") {
                            isql += (i == 1 ? " ( " : " OR ( ");
                            if ((Request["f_wordA_" + i + "_1"] ?? "") != "") {
                                isql += " cust_name like '%" + Request["f_wordA_" + i + "_1"] + "%' ";
                            }
                            if ((Request["f_wordA_" + i + "_1"] ?? "") != "") {
                                isql += " AND cust_name like '%" + Request["f_wordA_" + i + "_2"] + "%' ";
                            }
                            if ((Request["f_wordA_" + i + "_1"] ?? "") != "") {
                                isql += " AND cust_name like '%" + Request["f_wordA_" + i + "_3"] + "%' ";
                            }
                            isql += " ) ";
                        }
                    }
                    isql += "  ) ";
                }

                first_check = false;//判斷有無填寫不包含條件
                for (int i = 1; i <= int.Parse(ReqVal.TryGet("law_CNot", "0")); i++) {
                    if ((Request["f_wordB_" + i + "_1"] ?? "") != ""
                        || (Request["f_wordB_" + i + "_2"] ?? "") != ""
                        || (Request["f_wordB_" + i + "_3"] ?? "") != "") {
                        first_check = true;
                        break;
                    }
                }
                if (first_check) {
                    isql += "  AND ( ";
                    for (int i = 1; i <= int.Parse(ReqVal.TryGet("law_CNot", "0")); i++) {
                        if ((Request["f_wordB_" + i + "_1"] ?? "") != "" || (Request["f_wordB_" + i + "_2"] ?? "") != "" || (Request["f_wordB_" + i + "_3"] ?? "") != "") {
                            isql += (i == 1 ? " ( " : " OR ( ");
                            if ((Request["f_wordB_" + i + "_1"] ?? "") != "") {
                                isql += " cust_name NOT like '%" + Request["f_wordB_" + i + "_1"] + "%' ";
                            }
                            if ((Request["f_wordB_" + i + "_1"] ?? "") != "") {
                                isql += " AND cust_name NOT like '%" + Request["f_wordB_" + i + "_2"] + "%' ";
                            }
                            if ((Request["f_wordB_" + i + "_1"] ?? "") != "") {
                                isql += " AND cust_name NOT like '%" + Request["f_wordB_" + i + "_3"] + "%' ";
                            }
                            isql += " ) ";
                        }
                    }
                    isql += "  ) ";
                }

                last_check = false;//判斷有無填寫包含條件
                for (int i = 1; i <= int.Parse(ReqVal.TryGet("law_count", "0")); i++) {
                    if ((Request["f_wordA_" + i + "_1"] ?? "") != "" || (Request["f_wordA_" + i + "_2"] ?? "") != "" || (Request["f_wordA_" + i + "_3"] ?? "") != "") {
                        last_check = true;
                        break;
                    }
                }
                last_CNot_check = false;//判斷有無填寫包含條件
                for (int i = 1; i <= int.Parse(ReqVal.TryGet("law_CNot", "0")); i++) {
                    if ((Request["f_wordB_" + i + "_1"] ?? "") != "" || (Request["f_wordB_" + i + "_2"] ?? "") != "" || (Request["f_wordB_" + i + "_3"] ?? "") != "") {
                        last_CNot_check = true;
                        break;
                    }
                }

                if (last_check || last_CNot_check) {
                    isql += "  ) ";
                }
            }

            //全文檢索-商品類別名稱
            if ((Request["qry_opt_class_name"] ?? "") == "Y") {
                first_check = false;//判斷有無填寫包含條件
                for (int i = 1; i <= int.Parse(ReqVal.TryGet("law_count", "0")); i++) {
                    if ((Request["f_wordA_" + i + "_1"] ?? "") != ""
                        || (Request["f_wordA_" + i + "_2"] ?? "") != ""
                        || (Request["f_wordA_" + i + "_3"] ?? "") != "") {
                        first_check = true;
                        break;
                    }
                }

                if (first_check) {
                    isql += "  AND( ( ";
                    for (int i = 1; i <= int.Parse(ReqVal.TryGet("law_count", "0")); i++) {
                        if ((Request["f_wordA_" + i + "_1"] ?? "") != "" || (Request["f_wordA_" + i + "_2"] ?? "") != "" || (Request["f_wordA_" + i + "_3"] ?? "") != "") {
                            isql += (i == 1? " ( " : " OR ( ");
                            if ((Request["f_wordA_" + i + "_1"] ?? "") != "") {
                                isql += " opt_class_name like '%" + Request["f_wordA_" + i + "_1"] + "%' ";
                            }
                            if ((Request["f_wordA_" + i + "_1"] ?? "") != "") {
                                isql += " AND opt_class_name like '%" + Request["f_wordA_" + i + "_2"] + "%' ";
                            }
                            if ((Request["f_wordA_" + i + "_1"] ?? "") != "") {
                                isql += " AND opt_class_name like '%" + Request["f_wordA_" + i + "_3"] + "%' ";
                            }
                            isql += " ) ";
                        }
                    }
                    isql += "  ) ";
                }

                first_check = false;//判斷有無填寫不包含條件
                for (int i = 1; i <= int.Parse(ReqVal.TryGet("law_CNot", "0")); i++) {
                    if ((Request["f_wordB_" + i + "_1"] ?? "") != ""
                        || (Request["f_wordB_" + i + "_2"] ?? "") != ""
                        || (Request["f_wordB_" + i + "_3"] ?? "") != "") {
                        first_check = true;
                        break;
                    }
                }
                if (first_check) {
                    isql += "  AND ( ";
                    for (int i = 1; i <= int.Parse(ReqVal.TryGet("law_CNot", "0")); i++) {
                        if ((Request["f_wordB_" + i + "_1"] ?? "") != "" || (Request["f_wordB_" + i + "_2"] ?? "") != "" || (Request["f_wordB_" + i + "_3"] ?? "") != "") {
                            isql += (i == 1 ? " ( " : " OR ( ");
                            if ((Request["f_wordB_" + i + "_1"] ?? "") != "") {
                                isql += " opt_class_name NOT like '%" + Request["f_wordB_" + i + "_1"] + "%' ";
                            }
                            if ((Request["f_wordB_" + i + "_1"] ?? "") != "") {
                                isql += " AND opt_class_name NOT like '%" + Request["f_wordB_" + i + "_2"] + "%' ";
                            }
                            if ((Request["f_wordB_" + i + "_1"] ?? "") != "") {
                                isql += " AND opt_class_name NOT like '%" + Request["f_wordB_" + i + "_3"] + "%' ";
                            }
                            isql += " ) ";
                        }
                    }
                    isql += "  ) ";
                }

                last_check = false;//判斷有無填寫包含條件
                for (int i = 1; i <= int.Parse(ReqVal.TryGet("law_count", "0")); i++) {
                    if ((Request["f_wordA_" + i + "_1"] ?? "") != "" || (Request["f_wordA_" + i + "_2"] ?? "") != "" || (Request["f_wordA_" + i + "_3"] ?? "") != "") {
                        last_check = true;
                        break;
                    }
                }
                last_CNot_check = false;//判斷有無填寫包含條件
                for (int i = 1; i <= int.Parse(ReqVal.TryGet("law_CNot", "0")); i++) {
                    if ((Request["f_wordB_" + i + "_1"] ?? "") != "" || (Request["f_wordB_" + i + "_2"] ?? "") != "" || (Request["f_wordB_" + i + "_3"] ?? "") != "") {
                        last_CNot_check = true;
                        break;
                    }
                }

                if (last_check || last_CNot_check) {
                    isql += "  ) ";
                }
            }

            //全文檢索-判決主旨
            if ((Request["qry_opt_point"] ?? "") == "Y") {
                first_check = false;//判斷有無填寫包含條件
                for (int i = 1; i <= int.Parse(ReqVal.TryGet("law_count", "0")); i++) {
                    if ((Request["f_wordA_" + i + "_1"] ?? "") != ""
                        || (Request["f_wordA_" + i + "_2"] ?? "") != ""
                        || (Request["f_wordA_" + i + "_3"] ?? "") != "") {
                        first_check = true;
                        break;
                    }
                }

                if (first_check) {
                    isql += "  AND( ( ";
                    for (int i = 1; i <= int.Parse(ReqVal.TryGet("law_count", "0")); i++) {
                        if ((Request["f_wordA_" + i + "_1"] ?? "") != "" || (Request["f_wordA_" + i + "_2"] ?? "") != "" || (Request["f_wordA_" + i + "_3"] ?? "") != "") {
                            isql += (i == 1 ? " ( " : " OR ( ");
                            if ((Request["f_wordA_" + i + "_1"] ?? "") != "") {
                                isql += " opt_point like '%" + Request["f_wordA_" + i + "_1"] + "%' ";
                            }
                            if ((Request["f_wordA_" + i + "_1"] ?? "") != "") {
                                isql += " AND opt_point like '%" + Request["f_wordA_" + i + "_2"] + "%' ";
                            }
                            if ((Request["f_wordA_" + i + "_1"] ?? "") != "") {
                                isql += " AND opt_point like '%" + Request["f_wordA_" + i + "_3"] + "%' ";
                            }
                            isql += " ) ";
                        }
                    }
                    isql += "  ) ";
                }

                first_check = false;//判斷有無填寫不包含條件
                for (int i = 1; i <= int.Parse(ReqVal.TryGet("law_CNot", "0")); i++) {
                    if ((Request["f_wordB_" + i + "_1"] ?? "") != ""
                        || (Request["f_wordB_" + i + "_2"] ?? "") != ""
                        || (Request["f_wordB_" + i + "_3"] ?? "") != "") {
                        first_check = true;
                        break;
                    }
                }
                if (first_check) {
                    isql += "  AND ( ";
                    for (int i = 1; i <= int.Parse(ReqVal.TryGet("law_CNot", "0")); i++) {
                        if ((Request["f_wordB_" + i + "_1"] ?? "") != "" || (Request["f_wordB_" + i + "_2"] ?? "") != "" || (Request["f_wordB_" + i + "_3"] ?? "") != "") {
                            isql += (i == 1 ? " ( " : " OR ( ");
                            if ((Request["f_wordB_" + i + "_1"] ?? "") != "") {
                                isql += " opt_point NOT like '%" + Request["f_wordB_" + i + "_1"] + "%' ";
                            }
                            if ((Request["f_wordB_" + i + "_1"] ?? "") != "") {
                                isql += " AND opt_point NOT like '%" + Request["f_wordB_" + i + "_2"] + "%' ";
                            }
                            if ((Request["f_wordB_" + i + "_1"] ?? "") != "") {
                                isql += " AND opt_point NOT like '%" + Request["f_wordB_" + i + "_3"] + "%' ";
                            }
                            isql += " ) ";
                        }
                    }
                    isql += "  ) ";
                }

                last_check = false;//判斷有無填寫包含條件
                for (int i = 1; i <= int.Parse(ReqVal.TryGet("law_count", "0")); i++) {
                    if ((Request["f_wordA_" + i + "_1"] ?? "") != "" || (Request["f_wordA_" + i + "_2"] ?? "") != "" || (Request["f_wordA_" + i + "_3"] ?? "") != "") {
                        last_check = true;
                        break;
                    }
                }
                last_CNot_check = false;//判斷有無填寫包含條件
                for (int i = 1; i <= int.Parse(ReqVal.TryGet("law_CNot", "0")); i++) {
                    if ((Request["f_wordB_" + i + "_1"] ?? "") != "" || (Request["f_wordB_" + i + "_2"] ?? "") != "" || (Request["f_wordB_" + i + "_3"] ?? "") != "") {
                        last_CNot_check = true;
                        break;
                    }
                }

                if (last_check || last_CNot_check) {
                    isql += "  ) ";
                }
            }

            //全文檢索-關鍵字
            if ((Request["qry_opt_mark"] ?? "") == "Y") {
                first_check = false;//判斷有無填寫包含條件
                for (int i = 1; i <= int.Parse(ReqVal.TryGet("law_count", "0")); i++) {
                    if ((Request["f_wordA_" + i + "_1"] ?? "") != ""
                        || (Request["f_wordA_" + i + "_2"] ?? "") != ""
                        || (Request["f_wordA_" + i + "_3"] ?? "") != "") {
                        first_check = true;
                        break;
                    }
                }

                if (first_check) {
                    isql += "  AND( ( ";
                    for (int i = 1; i <= int.Parse(ReqVal.TryGet("law_count", "0")); i++) {
                        if ((Request["f_wordA_" + i + "_1"] ?? "") != "" || (Request["f_wordA_" + i + "_2"] ?? "") != "" || (Request["f_wordA_" + i + "_3"] ?? "") != "") {
                            isql += (i == 1 ? " ( " : " OR ( ");
                            if ((Request["f_wordA_" + i + "_1"] ?? "") != "") {
                                isql += " opt_mark like '%" + Request["f_wordA_" + i + "_1"] + "%' ";
                            }
                            if ((Request["f_wordA_" + i + "_1"] ?? "") != "") {
                                isql += " AND opt_mark like '%" + Request["f_wordA_" + i + "_2"] + "%' ";
                            }
                            if ((Request["f_wordA_" + i + "_1"] ?? "") != "") {
                                isql += " AND opt_mark like '%" + Request["f_wordA_" + i + "_3"] + "%' ";
                            }
                            isql += " ) ";
                        }
                    }
                    isql += "  ) ";
                }

                first_check = false;//判斷有無填寫不包含條件
                for (int i = 1; i <= int.Parse(ReqVal.TryGet("law_CNot", "0")); i++) {
                    if ((Request["f_wordB_" + i + "_1"] ?? "") != ""
                        || (Request["f_wordB_" + i + "_2"] ?? "") != ""
                        || (Request["f_wordB_" + i + "_3"] ?? "") != "") {
                        first_check = true;
                        break;
                    }
                }
                if (first_check) {
                    isql += "  AND ( ";
                    for (int i = 1; i <= int.Parse(ReqVal.TryGet("law_CNot", "0")); i++) {
                        if ((Request["f_wordB_" + i + "_1"] ?? "") != "" || (Request["f_wordB_" + i + "_2"] ?? "") != "" || (Request["f_wordB_" + i + "_3"] ?? "") != "") {
                            isql += (i == 1 ? " ( " : " OR ( ");
                            if ((Request["f_wordB_" + i + "_1"] ?? "") != "") {
                                isql += " opt_mark NOT like '%" + Request["f_wordB_" + i + "_1"] + "%' ";
                            }
                            if ((Request["f_wordB_" + i + "_1"] ?? "") != "") {
                                isql += " AND opt_mark NOT like '%" + Request["f_wordB_" + i + "_2"] + "%' ";
                            }
                            if ((Request["f_wordB_" + i + "_1"] ?? "") != "") {
                                isql += " AND opt_mark NOT like '%" + Request["f_wordB_" + i + "_3"] + "%' ";
                            }
                            isql += " ) ";
                        }
                    }
                    isql += "  ) ";
                }

                last_check = false;//判斷有無填寫包含條件
                for (int i = 1; i <= int.Parse(ReqVal.TryGet("law_count", "0")); i++) {
                    if ((Request["f_wordA_" + i + "_1"] ?? "") != "" || (Request["f_wordA_" + i + "_2"] ?? "") != "" || (Request["f_wordA_" + i + "_3"] ?? "") != "") {
                        last_check = true;
                        break;
                    }
                }
                last_CNot_check = false;//判斷有無填寫包含條件
                for (int i = 1; i <= int.Parse(ReqVal.TryGet("law_CNot", "0")); i++) {
                    if ((Request["f_wordB_" + i + "_1"] ?? "") != "" || (Request["f_wordB_" + i + "_2"] ?? "") != "" || (Request["f_wordB_" + i + "_3"] ?? "") != "") {
                        last_CNot_check = true;
                        break;
                    }
                }

                if (last_check || last_CNot_check) {
                    isql += "  ) ";
                }
            }

                        
            if ((Request["qryOrder"] ?? "") != "") {
                isql += " order by " + Request["qryOrder"];
            } else {
                isql += " order by pr_date desc";
            }

            DataTable dt = new DataTable();
            conn.DataTable(isql, dt);

            //處理分頁
            int nowPage = Convert.ToInt32(Request["GoPage"] ?? "1"); //第幾頁
            int PerPageSize = Convert.ToInt32(Request["PerPage"] ?? "10"); //每頁筆數
            Paging page = new Paging(nowPage, PerPageSize, string.Join(";", conn.exeSQL.ToArray()));
            page.GetPagedTable(dt);

            //分頁完再處理其他資料才不會虛耗資源
            for (int i = 0; i < page.pagedTable.Rows.Count; i++) {

                //組北京案號
                page.pagedTable.Rows[i]["fBJTseq"] = Funcs.formatSeq(
                    page.pagedTable.Rows[i].SafeRead("BJTSeq", "")
                    , page.pagedTable.Rows[i].SafeRead("BJTSeq1", "")
                    , ""
                    , page.pagedTable.Rows[i].SafeRead("BJTbranch", "")
                    , "");
                
                //商標圖樣
                page.pagedTable.Rows[i]["opt_pic_path"] = page.pagedTable.Rows[i].SafeRead("opt_pic_path", "").Replace("/", @"\").Replace(@"\opt\", @"\nopt\");

                //條款成立狀態
                switch (page.pagedTable.Rows[i].SafeRead("opt_comfirm", "")) {
                    case "1":
                        page.pagedTable.Rows[i]["opt_comfirm_str"] = "全部成立";
                        break;
                    case "2":
                        page.pagedTable.Rows[i]["opt_comfirm_str"] = "部分成立";
                        break;
                    case "3":
                        page.pagedTable.Rows[i]["opt_comfirm_str"] = "全部不成立";
                        break;
                }

                //裁決生效狀態
                switch (page.pagedTable.Rows[i].SafeRead("opt_check", "")) {
                    case "1":
                        page.pagedTable.Rows[i]["opt_check_str"] = "確定已生效";
                        break;
                    case "2":
                        page.pagedTable.Rows[i]["opt_check_str"] = "確定被推翻";
                        break;
                    case "3":
                        page.pagedTable.Rows[i]["opt_check_str"] = "救濟中或尚未能確定";
                        break;
                }

                //引用條文法規
                string law_detail_no="";
                if (page.pagedTable.Rows[i].SafeRead("ref_law", "") !="") {
                    isql = "SELECT * ";
                    isql += "from law_detail a ";
                    isql += "LEFT JOIN Cust_code b ON a.law_type=b.Cust_code and b.Code_type='law_type' ";
                    isql += "where law_sqlno in ('" + page.pagedTable.Rows[i].SafeRead("ref_law", "").Replace(",", "','") + "') ";
                    using (SqlDataReader dr = conn.ExecuteReader(isql)) {
                        while (dr.Read()) {
                            law_detail_no += (dr.SafeRead("Code_name", "") == "" ? "" : dr.SafeRead("Code_name", ""));
                            law_detail_no += (dr.SafeRead("law_no1", "") == "" ? "" : dr.SafeRead("law_no1", "") + "條");
                            law_detail_no += (dr.SafeRead("law_no2", "") == "" ? "" : dr.SafeRead("law_no2", "") + "款");
                            law_detail_no += (dr.SafeRead("law_no3", "") == "" ? "" : dr.SafeRead("law_no3", "") + "項");
                            law_detail_no += "<BR>";
                        }
                    }
                    page.pagedTable.Rows[i]["law_detail_no"] = law_detail_no;
                }
            }
            
            
            var settings = new JsonSerializerSettings()
            {
                Formatting = Formatting.Indented,
                ContractResolver = new LowercaseContractResolver(),//key統一轉小寫
                Converters = new List<JsonConverter> { new DBNullCreationConverter(), new TrimCreationConverter() }//dbnull轉空字串且trim掉
            };
            Response.Write(JsonConvert.SerializeObject(page, settings).ToUnicode());
            Response.End();
        }
    }
</script>

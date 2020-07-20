<%@ Page Language="C#" %>
<%@ Import Namespace = "System.Data" %>
<%@ Import Namespace = "System.Data.SqlClient" %>
<%@ Import Namespace = "System.IO"%>
<%@ Import Namespace = "System.Collections.Generic"%>
<%@ Import Namespace = "Word=Microsoft.Office.Interop.Word" %>
<%@ Import Namespace = "iTextSharp.text" %>
<%@ Import Namespace = "iTextSharp.text.pdf" %>
<%@ Import Namespace = "System.Xml" %>

<script runat="server">
	protected object wdCell=Word.WdUnits.wdCell;
	protected object wdCharacter = Word.WdUnits.wdCharacter;
	protected object wdCharacterFormatting = Word.WdUnits.wdCharacterFormatting;
	protected object wdColumn = Word.WdUnits.wdColumn;
	protected object wdItem = Word.WdUnits.wdItem;
	protected object wdLine = Word.WdUnits.wdLine;
	protected object wdParagraph = Word.WdUnits.wdParagraph;
	protected object wdParagraphFormatting = Word.WdUnits.wdParagraphFormatting;
	protected object wdRow = Word.WdUnits.wdRow;
	protected object wdScreen = Word.WdUnits.wdScreen;
	protected object wdSection = Word.WdUnits.wdSection;
	protected object wdSentence = Word.WdUnits.wdSentence;
	protected object wdStory = Word.WdUnits.wdStory;
	protected object wdTable = Word.WdUnits.wdTable;
	protected object wdWindow = Word.WdUnits.wdWindow;
	protected object wdWord = Word.WdUnits.wdWord;
	protected object wdExtend = 1;

	protected Word._Application wordApp = null;
	protected object oMissing = System.Reflection.Missing.Value;
	protected object oCount=1;

    protected StringBuilder strOut = new StringBuilder();
    DBHelper conn = null;//開完要在Page_Unload釋放,否則sql server連線會一直佔用
    DBHelper connB = null;//開完要在Page_Unload釋放,否則sql server連線會一直佔用
    private void Page_Unload(System.Object sender, System.EventArgs e) {
        if (conn != null) conn.Dispose();
        if (connB != null) connB.Dispose();
    }
    private void Page_Load(System.Object sender, System.EventArgs e) {
        conn = new DBHelper(Conn.OptK);
        connB = new DBHelper(Conn.OptB("K"));

        string SQL = "select * from attach_opt ";
        SQL += "where opt_sqlno = '" + Request["opt_sqlno"] + "' ";
        SQL += "and (source_name like '%.doc' or source_name like '%.docx') ";
        SQL += "and attach_desc like '%申請書%' ";
        SQL += "and attach_flag<>'D' ";
        DataTable dt = new DataTable();
        conn.DataTable(SQL, dt);
        strOut.AppendLine("$('#msg').html('');");

        if (dt.Rows.Count == 0) {
            strOut.AppendLine("$('#msg').html('<Font align=left color=\"red\" size=3>找不到申請書Word檔，請先上傳!!〈word檔判斷規則：副檔名為.doc或.docx，附件說明含有「申請書」字樣，<u>不可</u>勾□電子送件檔〉</font><BR>');");
            if ((Request["debug"] ?? "").ToUpper() == "Y") {
                strOut.AppendLine("$('#msg').append('" + SQL.Replace("'", "\\'") + "<BR>');");
            }
            return;
        } else if (dt.Rows.Count > 1) {
            strOut.AppendLine("$('#msg').html('<Font align=left color=\"red\" size=3>找到多個申請書Word檔，請確認!!</font><BR>');");
            if ((Request["debug"] ?? "").ToUpper() == "Y") {
                strOut.AppendLine("$('#msg').append('" + SQL.Replace("'", "\\'") + "<BR>');");
            }
            return;
        } else {
            string orgPath = dt.Rows[0]["attach_path"].ToString().Replace(@"\opt\", "");
            string FileName = Server.MapPath("~/" + orgPath);
            if (!File.Exists(FileName)) {
                strOut.AppendLine("$('#msg').html('<Font align=left color=\"red\" size=3>找不到申請書Word檔(" + FileName.Replace("\\", "\\\\") + ")!!</font><BR>');");
                if ((Request["debug"] ?? "").ToUpper() == "Y") {
                    strOut.AppendLine("$('#msg').append('虛擬目錄:~/" + orgPath + "<BR>');");
                    strOut.AppendLine("$('#msg').append('轉換後:" + FileName.Replace("\\", "\\\\") + "<BR>');");
                }
                Response.End();
            }

            wordApp = new Word.Application();

            object oFalse = false;//執行過程不在畫面上開啟 Word
            object oTrue = true;//唯讀模式
            object oFilePath = FileName;    //檔案路徑
            Word._Document myDoc = wordApp.Documents.Open(ref oFilePath, ref oMissing, ref oTrue, ref oMissing,
                                ref oMissing, ref oMissing, ref oMissing, ref oMissing,
                                ref oMissing, ref oMissing, ref oMissing, ref oFalse,
                                ref oMissing, ref oMissing, ref oMissing, ref oMissing);
            myDoc.Activate();
            try {
                strOut.AppendLine("var TagItem = new Array();");
                strOut.AppendLine("var tagCount=0;");
                strOut.AppendLine("var errFlag=false;");

                //20170808 增加檢查案件名稱
                string title_line = Get_name("【");
                string required_name = title_line.Replace("【", "\\[").Replace("】", "\\]");
                title_line = title_line.Replace("【", "").Replace("】", "");
                SQL = " select form_name from cust_code where Code_type='rpt_pr_t' and convert(varchar,remark)='" + title_line + "' ";
                using (SqlDataReader dr = connB.ExecuteReader(SQL)) {
                    if (!dr.Read()) {
                        strOut.AppendLine("$('#msg').append('<Font align=left color=\"red\" size=3>找不到申請書設定，請聯繫資訊人員!!</font><BR>');");
                        if ((Request["debug"] ?? "").ToUpper() == "Y") {
                            strOut.AppendLine("$('#msg').append('" + SQL.Replace("'", "\\'") + "<BR>');");
                        }
                    } else {
                        string appl_line = Get_name(dr.SafeRead("form_name", ""));
                        string[] split_appl = appl_line.Split('】');
                        dr.Close();

                        SQL = "select appl_name from opt_detail a where opt_sqlno = '" + Request["opt_sqlno"] + "' ";
                        using (SqlDataReader dr1 = conn.ExecuteReader(SQL)) {
                            if (!dr1.Read()) {
                                strOut.AppendLine("	errFlag=true;");
                                strOut.AppendLine("	$('#msg').append('<Font align=left color=\"red\" size=3>" + split_appl[0] + "】找不到案件主檔!!</font><BR>');");
                                if ((Request["debug"] ?? "").ToUpper() == "Y") {
                                    strOut.AppendLine("$('#msg').append('" + SQL.Replace("'", "\\'") + "<BR>');");
                                }
                            } else {
                                if (dr1.SafeRead("appl_name", "").Trim().ToXmlUnicode() != split_appl[1].Trim().ToXmlUnicode()) {
                                    strOut.AppendLine("	errFlag=true;");
                                    strOut.AppendLine("	$('#msg').append('<Font align=left color=\"red\" size=3>" + split_appl[0] + "】申請書案件名稱(" + split_appl[1].Trim().Replace("'", "\\'") + ")與案件主檔(" + dr1.SafeRead("appl_name", "").Trim().Replace("'", "\\'") + ")不符!!</font><BR>');");
                                }
                            }
                        }
                    }
                }

                //20191017 增加檢查申請書檔名
                SQL = " select * from attach_opt a ";
                SQL += "where opt_sqlno = '" + Request["opt_sqlno"] + "' ";
                SQL += " and source_name like '%" + required_name + "%' ESCAPE '\\' ";//中括號在SQL是關鍵字,要用跳脫字元
                SQL += " and attach_flag<>'D' ";
                SQL += " and doc_flag='E' ";
                string applyOrgPath = "";
                using (SqlDataReader dr1 = conn.ExecuteReader(SQL)) {
                    if (!dr1.Read()) {
                        strOut.AppendLine("	errFlag=true;");
                        strOut.AppendLine("	$('#msg').append('<Font align=left color=\"red\" size=3>申請書PDF檔名有誤，檔名須含有<font color=\"black\">" + required_name + "</font>，透過增益集轉檔後產生的檔名請勿任意修改!!</font><BR>');");
                        if ((Request["debug"] ?? "").ToUpper() == "Y") {
                            strOut.AppendLine("$('#msg').append('" + SQL.Replace("'", "\\'") + "<BR>');");
                        }
                    } else {
                        applyOrgPath = dr1.SafeRead("attach_path", "");
                    }
                }
                //20191017 增加申請書增益集版本
                if (applyOrgPath != "") {
                    applyOrgPath = applyOrgPath.Replace(@"\opt\", "");

                    string pdfFileName = Server.MapPath("~/" + applyOrgPath);
                    if (!File.Exists(pdfFileName)) {//檢查申請書PDF是否存在
                        strOut.AppendLine("	errFlag=true;");
                        strOut.AppendLine("	$('#msg').append('<Font align=left color=\"red\" size=3>找不到申請書PDF檔(" + pdfFileName.Replace("\\", "\\\\") + ")!!</font><BR>');");
                        if ((Request["debug"] ?? "").ToUpper() == "Y") {
                            strOut.AppendLine("$('#msg').append('虛擬目錄:~/" + applyOrgPath + "<BR>');");
                            strOut.AppendLine("$('#msg').append('轉換後:" + pdfFileName.Replace("\\", "\\\\") + "<BR>');");
                        }
                    } else {
                        PdfReader reader = null;
                        try {
                            reader = new PdfReader(pdfFileName);
                            if (!reader.Info.ContainsKey("XmlData")) {
                                strOut.AppendLine("	errFlag=true;");
                                strOut.AppendLine("	$('#msg').append('<Font align=left color=\"red\" size=3>申請書PDF檔未使用增益集轉檔!!</font><BR>');");
                            } else {
                                XmlDocument xml = new XmlDocument();
                                xml.LoadXml(reader.Info["XmlData"]);
                                string pdfV = xml.GetElementsByTagName("version")[0].InnerText;

                                //cust_code=最低可用版本
                                SQL = "select cust_code lowest from cust_code ";
                                SQL += "where code_type = 'ESET' ";
                                string strBaseVer = (connB.ExecuteScalar(SQL) ?? "").ToString();
                                if (strBaseVer == "") {
                                    strOut.AppendLine("	errFlag=true;");
                                    strOut.AppendLine("	$('#msg').append('<Font align=left color=\"red\" size=3>找不到版本檢查設定，請聯繫資訊人員!!</font><BR>');");
                                } else {
                                    System.Version baseVer = new System.Version(strBaseVer);
                                    System.Version pdfVer = new System.Version(pdfV);
                                    if (baseVer > pdfVer) {
                                        strOut.AppendLine("errFlag=true;");
                                        strOut.AppendLine("$('#msg').append('<Font align=left color=\"red\" size=3>申請書PDF版本過舊(" + pdfVer.ToString() + ")，請使用最新版的增益集重新轉檔 !!</font><BR>');");
                                    }
                                }
                            }
                        }
                        finally {
                            //一定要資源釋放，否則會Lock
                            reader.Dispose();
                            reader.Close();
                        }
                    }
                }

                //20170808 增加檢查規費
                string fee_line = Get_name("【繳費金額】");
                string[] split_fee = fee_line.Split('】');
                if (split_fee.Length == 2) {
                    strOut.AppendLine("var fee=$('#Send_Fees').val();");
                    strOut.AppendLine("if (fee!='" + split_fee[1].Trim() + "'){");
                    strOut.AppendLine("	errFlag=true;");
                    strOut.AppendLine("	$('#msg').append('<Font align=left color=\"red\" size=3>【繳費金額】官發應繳規費('+fee+')與申請書填寫金額(" + split_fee[1].Trim() + ")不符!!</font><BR>');");
                    strOut.AppendLine("}");
                }

                //20180331 增加檢查收據抬頭
                string receipt_line = Get_name("【收據抬頭】");
                string[] split_receipt = receipt_line.Split('】');
                string receipt_type = "B";
                string receipt_text = "空白";
                if (split_receipt.Length == 2) {
                    if (split_receipt[1].IndexOf("(代繳人") > -1) {
                        receipt_type = "C";
                        receipt_text = "案件申請人(代繳人)";
                    } else if (split_receipt[1].Trim() != "") {
                        receipt_type = "A";
                        receipt_text = "專利權人";
                    }
                }
                strOut.AppendLine("var receipt_title=$('#receipt_title').val();");
                strOut.AppendLine("var receipt_text=$('#receipt_title :selected').text();");
                strOut.AppendLine("if (receipt_title!='" + receipt_type + "'){");
                strOut.AppendLine("	errFlag=true;");
                strOut.AppendLine("	$('#msg').append('<Font align=left color=\"red\" size=3>【收據抬頭】申請書抬頭種類(" + receipt_text + ")與官發收據種類('+receipt_text+')不符!!</font><BR>');");
                strOut.AppendLine("}");

                //檢查附送書件
                List<string> attachList = Get_AttachBlock();
                for (int z = 0; z < attachList.Count; z++) {
                    if (attachList[z] != "") {
                        string[] split_line = attachList[z].Replace("　", "").Split('】');
                        if (split_line.Length == 2) {
                            SQL = " select * from attach_opt a ";
                            SQL += "where opt_sqlno = '" + Request["opt_sqlno"] + "' ";
                            SQL += " and source_name='" + split_line[1].Trim() + "' ";
                            SQL += " and attach_flag<>'D' ";
                            SQL += " and doc_flag='E' ";
                            using (SqlDataReader dr1 = conn.ExecuteReader(SQL)) {
                                if (!dr1.HasRows) {
                                    strOut.AppendLine("TagItem[tagCount] = new Array();");
                                    strOut.AppendLine("TagItem[tagCount][0] = '" + split_line[0] + "】';");
                                    strOut.AppendLine("TagItem[tagCount][1] = '" + split_line[1].Trim() + "';");
                                    strOut.AppendLine("tagCount+=1;");
                                }
                            }
                        }
                    }
                }

                strOut.AppendLine("for(var x=0;x<tagCount;x++)");
                strOut.AppendLine("{");
                strOut.AppendLine("	var chkOK=false;");
                strOut.AppendLine("	var filenum = document.getElementById('opt_file_filenum').value;");
                strOut.AppendLine("	for (var no = 1; no <= filenum; no++) {");
                strOut.AppendLine("		if (document.getElementById('opt_file_source_name_'+no).value!=''&&document.getElementById('opt_file_source_name_'+no).value==TagItem[x][1]&&document.getElementById('opt_file_doc_flag_'+no).checked==true){");
                strOut.AppendLine("			chkOK=true;");
                strOut.AppendLine("			break;");
                strOut.AppendLine("		}else if (document.getElementById('opt_file_source_name_'+no).value==''&&document.getElementById('opt_file_name'+no).value==TagItem[x][1]&&document.getElementById('opt_file_doc_flag_'+no).checked==true){");
                strOut.AppendLine("			chkOK=true;");
                strOut.AppendLine("			break;");
                strOut.AppendLine("		}");
                strOut.AppendLine("	}");
                strOut.AppendLine("	if(!chkOK)");
                strOut.AppendLine("	{");
                strOut.AppendLine("		errFlag=true;");
                strOut.AppendLine("		$('#msg').append('<Font align=left color=\"red\" size=3>'+TagItem[x][0]+'<b>'+TagItem[x][1]+'</b> 抓取對應附件有錯誤，請檢查附送書件之檔案是否已經上傳 !!</font><BR>');");
                strOut.AppendLine("	}");
                strOut.AppendLine("}");

                strOut.AppendLine("if (!errFlag){");
                strOut.AppendLine("	$('#msg').html('<Font align=left color=\"darkblue\" size=3>檢查完成，請執行確認!!</font><BR>');");
                strOut.AppendLine("	$('#button0').attr('disabled', true);");
                strOut.AppendLine("}");
            }
            catch (Exception ex) {
                strOut.AppendLine("errFlag=true;");
                strOut.AppendLine("$('#msg').html('<Font align=left color=\"red\" size=3>Eeception - " + ex.Message + "!!</font><BR>');");
            }
            finally {
                wordApp.ActiveDocument.Close(ref oMissing, ref oMissing, ref oMissing);
                wordApp.Quit(ref oMissing, ref oMissing, ref oMissing);
                if (myDoc != null)
                    System.Runtime.InteropServices.Marshal.ReleaseComObject(myDoc);
                if (wordApp != null)
                    System.Runtime.InteropServices.Marshal.ReleaseComObject(wordApp);
                myDoc = null;
                wordApp = null;
                GC.Collect();
            }
        }
    }

	//尋找特定tag
	protected string Get_name(string pTag_name) {
		string get_value = "";
		wordApp.Selection.HomeKey(ref wdStory, ref oMissing);
		wordApp.Selection.Find.ClearFormatting();
		wordApp.Selection.Find.Text = pTag_name;
		wordApp.Selection.Find.Forward = true;
		wordApp.Selection.Find.MatchWholeWord = true;

		if (wordApp.Selection.Find.Execute(ref oMissing,
				ref oMissing, ref oMissing, ref oMissing, ref oMissing, ref oMissing, ref oMissing,
				ref oMissing, ref oMissing, ref oMissing, ref oMissing, ref oMissing, ref oMissing,
				ref oMissing, ref oMissing)) {
			wordApp.Selection.HomeKey(ref wdLine, ref oMissing);
			wordApp.Selection.MoveDown(ref wdParagraph, ref oCount, ref wdExtend);//ctrl+shift+↓
			wordApp.Selection.Copy();

			get_value = wordApp.Selection.Text;
			get_value = get_value.Replace(((char)13).ToString(), "");//整行複製會帶最後的換行符號
			//get_value = get_value.Replace("　", "");//全形空白
            get_value = ReplaceStart(get_value, "　", "");//開頭全形空白
            get_value = ReplaceEnd(get_value, "　", "");//結尾全形空白
            get_value = get_value.Replace(((char)9).ToString(), "");//tab
		}

		return get_value;
	}
	
	//擷取word【附送書件】區塊,找到具結為止
	protected List<string> Get_AttachBlock() {
		List<string> attach_list = new List<string>();
		
		wordApp.Selection.HomeKey(ref wdStory, ref oMissing);
		wordApp.Selection.Find.ClearFormatting();
		wordApp.Selection.Find.Text = "【附送書件】";
		wordApp.Selection.Find.Forward = true;
		wordApp.Selection.Find.MatchWholeWord = true;

		if (wordApp.Selection.Find.Execute(ref oMissing,
				ref oMissing, ref oMissing, ref oMissing, ref oMissing, ref oMissing, ref oMissing,
				ref oMissing, ref oMissing, ref oMissing, ref oMissing, ref oMissing, ref oMissing,
				ref oMissing, ref oMissing)) {
			int i = 0;
			while (++i < 100) {//防止無限迴圈
				wordApp.Selection.MoveDown(ref wdParagraph, ref oCount, ref oMissing);//ctrl+↓
				wordApp.Selection.MoveDown(ref wdParagraph, ref oCount, ref wdExtend);//ctrl+shift+↓
				wordApp.Selection.Copy();

				string strTemp = wordApp.Selection.Text;
				strTemp = strTemp.Replace(((char)13).ToString(), "");//整行複製會帶最後的換行符號
				strTemp = strTemp.Replace("　", "");//全形空白
				strTemp = strTemp.Replace(((char)9).ToString(), "");//tab
				strTemp = strTemp.Replace(((char)12).ToString(), "");//換頁
				strTemp = strTemp.Trim();

				if (strTemp == "【本申請書所填寫之資料係為真實】") {
					break;
				} else if (strTemp.IndexOf("【其他】") > -1 
                    || strTemp.IndexOf("【文件描述】") > -1 
                    || strTemp == "【附送書件】" 
                    || strTemp == ""
                    || (strTemp.IndexOf("【基本資料表") > -1 && strTemp.IndexOf("未變更本案基本資料") > -1)
                    ) {
					continue;
				} else {
					strTemp = strTemp.Replace("【文件檔名】", "【其他】");
					attach_list.Add(strTemp);
				}
				//strOut.AppendLine(i + strTemp + "<BR>");
			}
		}
		return attach_list;
	}

    protected string ReplaceStart(string Source, string Find, string Replace) {
        string regex = @"(^" + Find + "+)";
        return Regex.Replace(Source, regex, Replace);
    }

    protected string ReplaceEnd(string Source, string Find, string Replace) {
        string regex = @"(" + Find + "+$)";
        return Regex.Replace(Source, regex, Replace);
    }
</script>
<%Response.Write(strOut.ToString());%>

//判斷字串是否為JSON格式
function isJSON(str) {
    if (typeof str == 'string') {
        try {
            var obj = JSON.parse(str);
            if (typeof obj == 'object' && obj) {
                return true;
            } else {
                return false;
            }
        } catch (e) {
            return false;
        }
    }
    return false;
}

'==client
'pStr:資料內容
'pLen:資料最大長度,若傳入0則傳回資料長度
'pmsg:欄位名稱,若Error則回傳 ""
Function fDataLen(pStr,pLen,pmsg)
    Dim ixI 
    Dim tStr1
    Dim tCod
    Dim tLen
    fDataLen = 0
    tStr1 = ""
    if Len(pStr)=0 then tLen=0
    For ixI = 1 To Len(pStr)
    tStr1 = Mid(pStr, ixI, 1)
    tCod = Asc(tStr1)
    If tCod >= 128 Or tCod < 0 Then
    tLen = tLen + 2
    Else
    tLen = tLen + 1
    End If
    Next
    if pLen = 0 or tLen <= pLen then
    fDataLen = tLen
    else
		    msgbox pmsg & "長度過長，請檢查!!!"
    fDataLen = ""
    end if
End Function

'pObj:檢查長度之物件
'pmsg:欄位名稱,若Error則回傳 ""
Function fChkDataLen(pObj,pmsg)
    Dim ixI 
    Dim tStr1
    Dim tCod
    Dim tLen
    Dim tc,te
    fChkDataLen = 0
    tStr1 = ""
    tLen = 0
	
    pObj.value = replace(pObj.value,"&","＆")
    pObj.value = replace(pObj.value,"'","’")
	
    For ixI = 1 To Len(pObj.value)
    tStr1 = Mid(pObj.value, ixI, 1)
    tCod = Asc(tStr1)
    If tCod >= 128 Or tCod < 0 Then
    tLen = tLen + 2
    Else
    tLen = tLen + 1
    End If
    Next
    if pObj.maxlength = 0 or tLen <= pObj.maxlength then
    fChkDataLen = tLen
    else
		    tc =  pObj.maxlength / 2
    te =  pObj.maxlength
    msgbox pmsg & " 長度過長，請檢查! " & chr(10) & chr(10) & "(提示=中文字最多: " & tc & "個字 / 英文字最多: " & te & "個字)"
    pObj.focus
    fChkDataLen = ""
    end if
End Function

'check field null:檢查單一欄位不可為空白
function chkNull(pFieldName,pobject)
    if trim(pobject.value)="" then
    msgbox pFieldName+"必須輸入!!!"
    pobject.focus()
    chkNull = true
    exit function
    end if
    chkNull = false
End Function

'check field integer:檢查單一欄位不可為小數
function chkInt(pFieldName,pobject)
    if pobject.value > 0 then
    tvalue=pobject.value	
    tint=int(pobject.value)
    tvalue=tvalue / tint
    if tvalue <> 1 then
    msgbox pFieldName+"必須為整數，請重新輸入!!!"
    chkInt = true
    exit function
     end if
    end if
    chkInt = false
End Function

'******************************************

Function SetRadioValue(gObject,gd)
    for each x in gObject
        if x.value = gd then
            x.checked = true
        end if
    next
End Function

Function SetRadioValueNull(gObject)
    for each x in gObject
        x.checked = false
    next
End Function

Function GetRadioValue(gObject)
    rs = ""
    for each x in gObject
        if x.checked = true then
            rs = rs &  x.value & ";"
        end if
    next
        if rs <> "" then rs=left(rs,len(rs)-1)   
    GetRadioValue = rs
End Function

Function SetRadioDisabled(gObject)
    for each x in gObject
        x.disabled = true
    next
End Function

Function SetRsCode_Default (gs,gd)
    for each x in gs		
        if len(x.value) > 0 then
            gn = instr(x.value,"_")
            gvalue = mid(x.value,1,gn - 1)
            if gvalue = gd then
                x.selected = true
                exit function
            end if
        end if
    next
End function

'==date
function chkSEdate(psdate,pedate,pmsg)
    chkSEdate = true
    if psdate.value="" or pedate.value="" then
        alert(pmsg&"起迄必須輸入!!!")
        exit function
    end if
    if psdate.value<>empty and pedate.value<>empty then
        if cdate(psdate.value)>cdate(pedate.value) then
            alert(pmsg&"起始日不可大於迄止日!!!")
            exit function
        end if
    end if
    chkSEdate = false
end function

'檢查日期格式
function chkdateformat(pobject)
    chkdateformat = false
    if trim(pobject.value)=empty then exit function
    if isdate(pobject.value)=false then
        msgbox "日期格式錯誤，請重新輸入!!! 日期格式:YYYY/MM/DD"
        chkdateformat = true
        pobject.focus()
    else
        pobject.value = cdate(pobject.value)		
    end if
end function

function chkdateformat1(pobject,pmsg)
    chkdateformat1 = false
    if trim(pobject.value)=empty then exit function
    if isdate(pobject.value)=false then
        msgbox pmsg & "日期格式錯誤，請重新輸入!!! 日期格式:YYYY/MM/DD"
        pobject.focus()
        chkdateformat1 = true
    else
        pobject.value = cdate(pobject.value)		
    end if
end function

'日期時間格式
function getformatdatetime(pvalue,pkind)
    if trim(pvalue)=empty then exit function
'msgbox pkind
    tdate = year(pvalue) & "/" & string(2-len(month(pvalue)),"0") & month(pvalue) & "/" & string(2-len(day(pvalue)),"0") & day(pvalue)
    ttime = string(2-len(hour(pvalue)),"0") & hour(pvalue) & ":" & string(2-len(minute(pvalue)),"0") & minute(pvalue) & ":" & string(2-len(second(pvalue)),"0") & second(pvalue)
    select case pkind
        case "date"
            getformatdatetime = tdate
        case "time"
            getformatdatetime = ttime
        case "datetime"
            getformatdatetime = tdate & " " & ttime
    end select
'msgbox getformatdatetime
end function
'********************************

Function ChkDate(gObject)
    if trim(gObject.value)=empty then
        ChkDate = true 
        exit function
    end if
    if isdate(gObject.value)=false then
        msgbox "日期格式錯誤，請重新輸入!!! 日期格式:YYYY/MM/DD"
        gObject.focus()
        ChkDate = false
    else		
        ChkDate = true
    end if
End Function

function ChkDateSE(psdate,pedate,pmsg)
    ChkDateSE = true
    if psdate="" or pedate="" then
        ChkDateSE = true
        exit function
    end if
    if psdate<>empty and pedate<>empty then
        if cdate(psdate)>cdate(pedate) then
            alert(pmsg&"起始日不可大於迄止日!!!")
            ChkDateSE = false
            exit function
        end if
    end if
    ChkDateSE = true
end function

'=num
function chkNum(pvalue,pmsg)
    chkNum = false
    if pvalue<>empty then 
        if IsNumeric(pvalue) = false then
            msgbox pmsg & "必須為數值!!!"
            chkNum = true
            exit function
        end if
    end if
end function

function chkNum1(pobj,pmsg)
    chkNum1 = false
    if pobj.value<>empty then 
        if IsNumeric(pobj.value) = false then
            msgbox pmsg & "必須為數值!!!"
            pobj.focus()
            chkNum1 = true
            exit function
        end if
    end if
end function

function chkSENum(ps,pe,pmsg)
    chkSENum = false
    if ps.value<>empty and pe.value<>empty then 
        if cdbl(ps.value)>cdbl(pe.value) then
            msgbox pmsg & " 起始編號不可大於迄止編號必須為數值!!!"
            ps.focus()
            chkSENum = true
            exit function
        end if
    end if
end function
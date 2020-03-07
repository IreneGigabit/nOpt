//彈跳訊息選項
toastr.options = {
    "closeButton": true,//是否顯示關閉按鈕
    //"debug": false,//是否使用debug模式
    //"newestOnTop": false,//是否新的訊息放上面
    "progressBar": true,//是否訊息下方顯示進度條
    "positionClass": "toast-top-center",//彈出窗的位置
    //"preventDuplicates": false,//是否啟用避免重複顯示
    //"onclick": null,//Click event
    //"showDuration": "300",//顯示的動畫時間
    //"hideDuration": "1000",//消失的動畫時間
    //"timeOut": "5000",//展現時間
    //"extendedTimeOut": "1000",//加長展示時間
    //"showEasing": "swing",//顯示時的動畫緩衝方式
    //"hideEasing": "linear",/消失時的動畫緩衝方式
    //"showMethod": "fadeIn",//顯示時的動畫方式
    //"hideMethod": "fadeOut"//消失時的動畫方式
}

//獲取web ap根路徑 ex:http://web02/nOpt
function getRootPath() {
    var strFullPath = window.document.location.href;
    var strPath = window.document.location.pathname;
    var pos = strFullPath.indexOf(strPath);
    var prePath = strFullPath.substring(0, pos);
    var postPath = strPath.substring(0, strPath.substr(1).indexOf('/') + 1);
    return (prePath + postPath);
}

//獲取web ap根目錄 ex:nOpt
function getRootDir() {
    var strPath = window.document.location.pathname;
    var postPath = strPath.substring(0, strPath.substr(1).indexOf('/') + 1);
    return postPath;
}

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
/*將數值轉換貨幣表示法
c:取到小數第幾位
d:小數符號
t:分位數符號
Number(-1654349.7).toMoney(0, ".", ""); →   -1654350
Number(-1654349.7).toMoney(2, ".", ""); →   -1654349.70
Number(-1654349.7).toMoney();   →   -1,654,349.70
Number.prototype.formatMoney = function (c, d, t) {
    var n = this,
    c = isNaN(c = Math.abs(c)) ? 2 : c,
    d = d == undefined ? "." : d,
    t = t == undefined ? "," : t,
    s = n < 0 ? "-" : "",
    i = parseInt(n = Math.abs(+n || 0).toFixed(c)) + "",
    j = (j = i.length) > 3 ? j % 3 : 0;
    return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
}
*/

/*將數值轉換貨幣表示法
n:取到小數第幾位
x:幾位一撇
Number(-1654349.7).format(0,3); →   -1,654,350
Number(-1654349.7).format(2,4); →   -165,4349.70
Number(-1654349.7).format();   →   -1,654,350
*/
Number.prototype.format = function (n, x) {
    var re = '\\d(?=(\\d{' + (x || 3) + '})+' + (n > 0 ? '\\.' : '$') + ')';
    return this.toFixed(Math.max(0, ~ ~n)).replace(new RegExp(re, 'g'), '$&,');
};

String.prototype.Right = function (n) {
	if (n <= 0)
		return "";
	else if (n > String(this).length)
		return this;
	else {
		var iLen = String(this).length;
		return String(this).substring(iLen, iLen - n);
	}
}

String.prototype.Left = function (n) {
	if (n <= 0)
		return "";
	else if (n > String(this).length)
		return this;
	else
		return String(this).substring(0, n);
}

String.prototype.CutData = function (n) {
    if (n <= 0)
        return "";
    else if (n > $.BLen(String(this)))
        return this;
    else {
        var len = 0, tStr2 = "";
        for (i = 0; i < String(this).length; i++) {
            chCd = String(this).charCodeAt(i);
            if (chCd > 255) len += 2;
            else len += 1;

            if (len > n) {
                tStr2 += "...";
                break;
            }
            tStr2 += String(this).substr(i, 1);
        }
        return tStr2;
    }
}
/*
String.prototype.CodeLength = function () {
    var len = 0;
    var i = 0;
    var chCd;
    for (i = 0; i < String(this).length; i++) {
        chCd = String(this).charCodeAt(i);
        if (chCd > 255) len += 2;
        else len += 1;
    }
    return len;
}
*/
if (!String.prototype.trim) {
	String.prototype.trim = function () {
		//return this.replace(/[(^\s+)(\s+$)]/g,"");//會把字符串中間的空白也去掉  
		//return this.replace(/^\s+|\s+$/g,""); //  
		return this.replace(/^\s+/g, "").replace(/\s+$/g, "");
	};
}

/*ajax function(get)*/
function ajaxByGet(url, param) {
    return $.ajax({
        url: url,
        type: "get",
        cache: false,
        async: false,
        data: param
    });
}

/*ajax function(post)*/
function ajaxByPost(url, param) {
    return $.ajax({
        url: url,
        type: "post",
        cache: false,
        async: false,
        data: JSON.stringify(param)
    });
}

//靜態函式
(function ($) {
    //#region $.maskStart 顯示遮罩
    $.maskStart = function (msg) {
        var w = Math.max($(window).width(), $(document).width());
        var h = Math.max($(window).height(), $(document).height());

        if ($("body").find("#divProgress").length == 0) {
            $("body").append("<div id=\"divProgress\" style=\"display:none;\">" +
			"<img id=\"imgLoading\" src=\"../images/loading.gif\" style=\"border-width:0px;\" /><br />" +
			"<font color=\"#1B3563\">" + msg + "</font>" +
			"</div>");
        }

        if ($("body").find("#divMaskFrame").length == 0) {
            $("body").append("<div id=\"divMaskFrame\" style=\"display:none;\"></div>");
        }

        $("#divMaskFrame").css({
            'overflow': 'hidden',
            'background-color': '#F2F4F7',
            'width': w,
            'height': h,
            'position': 'absolute',
            'z-index': '999998',
            'opacity': '0.7',
            '-moz-opacity': '0.7',
            '-khtml-opacity': '0.7',
            'filter': 'alpha(opacity=70)',
            'top': '0',
            'left': '0'
        });

        var t = (h / 2) - ($("#divProgress").height() / 2);
        $("#divProgress").css({
            'text-align': 'center',
            'position': 'absolute',
            'top': t,
            'left': '50%',
            //'background-color': '#88bbff',
            'opacity': '0.9',
            '-moz-opacity': '0.9',
            '-khtml-opacity': '0.9',
            'filter': 'alpha(opacity=90)',
            'z-index': '999999'
        });


        $("body").css("cursor", "wait");
        $("#divMaskFrame").show();
        if (msg != "" && msg != undefined && msg != null) {
            $("#divProgress").show();
        }
    }
    //#endregion

    //#region $.maskStop 關閉遮罩
    $.maskStop = function (msg) {
        $("#divMaskFrame").fadeOut(500);
        $("#divProgress").fadeOut(500);
        $("body").css("cursor", "default");
    }
    //#endregion

    //#region $.BLen 計算字元長度(英數=1,中文=2)
    $.BLen = function (str) {
        var arr = str.match(/[^\x00-\xff]/ig);
        return arr == null ? str.length : str.length + arr.length;
    }
    //#endregion

    //#region $.NulltoEmpty 若為null回傳空字串
    $.NulltoEmpty = function (s) {
        if (s == null || s == undefined) return "";
        return s;
    }
    //#endregion
})(jQuery);

//#region dateReviver // json日期格式轉js日期格式
var dateReviver = function (value, pstr) {
    var a;
    var b;
    //2018-12-26T10:47:00
    if (typeof value === 'string') {
        a = /^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})$/.exec(value);
        if (a) {
            b = new Date(+a[1], +a[2] - 1, +a[3], +a[4], +a[5], +a[6]);
        }
    }
    if (b != null) {
        return b.format(pstr);
    }
    else {
        return "";
    }

};
//end region

//#region Date.prototype.format // js日期格式fotmat轉換
//("yyyy-MM-dd")
//("yyyy-MM-dd hh:mm:ss")
Date.prototype.format = function (fmt) {
    var o = {
        "M+": this.getMonth() + 1,
        "d+": this.getDate(),
        "h+": this.getHours(),
        "m+": this.getMinutes(),
        "s+": this.getSeconds(),
        "q+": Math.floor((this.getMonth() + 3) / 3),
        "S": this.getMilliseconds()
    };
    if (/(y+)/.test(fmt)) {
        fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    }
    for (var k in o) {
        if (new RegExp("(" + k + ")").test(fmt)) {
            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
        }
    }
    return fmt;
}
//#end region

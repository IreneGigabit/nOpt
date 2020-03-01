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

Number.prototype.formatMoney = function (c, d, t) {
    var n = this, c = isNaN(c = Math.abs(c)) ? 2 : c, d = d == undefined ? "." : d, t = t == undefined ? "," : t, s = n < 0 ? "-" : "", i = parseInt(n = Math.abs(+n || 0).toFixed(c)) + "", j = (j = i.length) > 3 ? j % 3 : 0;
    return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
}

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

if (!String.prototype.trim) {
	String.prototype.trim = function () {
		//return this.replace(/[(^\s+)(\s+$)]/g,"");//會把字符串中間的空白也去掉  
		//return this.replace(/^\s+|\s+$/g,""); //  
		return this.replace(/^\s+/g, "").replace(/\s+$/g, "");
	};
}

//遮罩
function showBlockUI(param) {
    $.blockUI({
        //message: '<div>' + param + '</div>',
        message: param,
        css: { borderWidth: '0px', backgroundColor: 'transparent' } //透明背景
    });
}

/*ajax function(get)*/
function ajaxByGet(url, param) {
    return $.ajax({
        cache: false,
        url: url,
        contentType: "application/json; charset=utf-8",
        dataType: "json",//回傳json
        type: "get",
        data: param
    });
}

/*ajax function(post)*/
function ajaxByPost(url, param) {
    return $.ajax({
        cache: false,
        url: url,
        contentType: "application/json; charset=utf-8",
        dataType: "json",//回傳json
        type: "post",
        data: JSON.stringify(param)
    });
}

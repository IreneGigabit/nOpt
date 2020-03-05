(function ($) {
    //#region Paging
    $.fn.paging = function (settings) {
        var defaultSettings = {
            submitForm:"",
            data:{},
            prePage: [10, 20, 30, 50],
            bind: 'mouseover',
            callback: function () {},
        };
        //將傳入的settings 覆蓋預設的 defaultSettings
        var _settings = $.extend(defaultSettings, settings);
        var tmpl = '\
<TABLE border=0 cellspacing=1 cellpadding=0 width="85%" align="center">\
	<tr>\
		<td valign="top" align="right" nowrap="nowrap">\
			<a id="imgRefresh" href="javascript:void(0);" >[重新整理]</a>\
			<HR color=#000080 SIZE=1 noShade>\
		</td>\
	</tr>\
	<tr>\
		<td colspan=2 align=center class=whitetablebg>\
			<font size="2" color="#3f8eba">\
				第<font color="red"><span id="NowPage"></span>/<span id="TotPage"></span></font>頁\
				| 資料共<font color="red"><span id="TotRec"></span></font>筆\
				| 跳至第\
				<select id="GoPage" name="GoPage" style="color:#FF0000"></select>\
        頁\
        <span id="PageUp">| <a href="javascript:void(0)" class="pgU" v1="">上一頁</a></span>\
        <span id="PageDown">| <a href="javascript:void(0)" class="pgD" v1="">下一頁</a></span>\
        | 每頁筆數:\
        <select id="PerPage" name="PerPage" style="color:#FF0000"></select>\
        <input type="hidden" name="SetOrder" id="SetOrder" />\
    </font>\
    </td>\
    </tr>\
</TABLE>';
        var render = function (obj) {
            $(obj).html(tmpl);

            //每頁筆數
            var option = new Array(_settings.prePage.length);
            $.each(_settings.prePage, function (i, value) {
                option[i] = ['<option value="' + value + '">' + value + '</option>'].join("");
            });
            $("#PerPage", $(obj)).replaceWith('<select id="PerPage" name="PerPage" style="color:#FF0000">' + option.join("") + '</select>');

            var totRow = parseInt(_settings.data.totRow||0, 10);
            var totPage = parseInt(_settings.data.totPage||0, 10);
            var nowPage = parseInt(_settings.data.nowPage||0, 10);
            $("#NowPage", $(obj)).html(nowPage);
            $("#TotPage", $(obj)).html(totPage);
            $("#TotRec", $(obj)).html(totRow);
            var i = totPage + 1, option = new Array(i);
            while (--i) {
                option[i] = ['<option value="' + i + '">' + i + '</option>'].join("");
            }
            $("#GoPage", $(obj)).replaceWith('<select id="GoPage" name="GoPage" style="color:#FF0000">' + option.join("") + '</select>');
            $("#GoPage", $(obj)).val(nowPage);

            nowPage > 1 ? $("#PageUp", $(obj)).show() : $("#PageUp", $(obj)).hide();
            nowPage < totPage ? $("#PageDown", $(obj)).show() : $("#PageDown", $(obj)).hide();
            $("a.pgU", $(obj)).attr("v1", nowPage - 1);
            $("a.pgD", $(obj)).attr("v1", nowPage + 1);
            $("#id-div-slide", $(obj)).slideUp("fast");

            //
            //console.log($(obj).find("#PerPage").length);
            //console.log($("#PerPage", $(obj)).length);
            //console.log($("#NowPage", $(obj)).length);
            //console.log($("#TotPage", $(obj)).length);
            //console.log($("#TotRec", $(obj)).length);
        };

        //return 回去,this 指的是外面的 jQuey 物件
        return this.each(function () {
            var obj = this;
            render(obj);

            //每頁幾筆
            //$("#PerPage", $(this)).change(_settings.callback());
            ////指定第幾頁
            //$("#divPaging", $(this)).on("change", "#GoPage", function (e) {
            //    _settings.callback();
            //});
            ////上下頁
            $(".pgU,.pgD", obj).click(function (e) {
                $("#GoPage", obj).val($(this).attr("v1"));
                _settings.callback();
            });
            ////排序
            //$(".setOdr", $(this)).click(function (e) {
            //    $("#dataList>thead tr .setOdr span").remove();
            //    $(this).append("<span>▲</span>");
            //    $("#SetOrder").val($(this).attr("v1"));
            //    _settings.callback();
            //});
            ////重新整理
            //$("#imgRefresh", $(this)).click(function (e) {
            //    _settings.callback();
            //});
            ////查詢條件
            //$("#imgQry", $(this)).click(function (e) {
            //    $("#id-div-slide").slideToggle("fast");
            //});

            //console.log(this.id);
            //$(this).bind(_settings.bind, _settings.callback);
        });
    }
    /*
    $.fn.extend({
		chkRequire: function (option) {
			var defaults = {
				msg: "",
				br: false,
				depend: null
			};

			var settings = $.extend(defaults, option || {});
			var errflag = false;

			this.each(function () {
				var errmsg = "";

				if ($(this).parents("td:first").children(":gt(" + $(this).index() + ").errlog:first").length == 0) {
					$(this).parents("td:first").append("<span class='errlog'></span>");
				}

				if (settings.depend != null && settings.depend != undefined && settings.depend != "") {
					if ($(settings.depend).val() == "") {
						return false;
					}
				}

				if (this.type == "select-one") {
					if ($(this).val() == "") {
						errmsg = settings.msg || "須選擇";
						errflag = true;
					}
				} else if (this.type == "textarea") {
					if ($(this).val() == "") {
						errmsg = settings.msg || "不可空白";
						errflag = true;
					}
				} else if (this.type == "radio") {
					if ($(this).prop("checked") == false) {
						errmsg = settings.msg || "radio須勾選";
						errflag = true;
					}
				} else if (this.type == "checkbox") {
					if ($(this).prop("checked") == false) {
						errmsg = settings.msg || "check須選擇";
						errflag = true;
					}
				} else {
					if ($(this).val() == "") {
						errmsg = settings.msg || "不可空白";
						errflag = true;
					}
				}
				//console.log($(this).index());
				//console.log($(this).parents("td:first").find(".errlog").index());
				//console.log($(this).parents("td:first").children(":gt("+$(this).index()+").errlog:first").length+",errmsg="+errmsg);

				if (errmsg != "") {
					//$(this).parents("td:first").find(".errlog").html(errmsg);
					//$(this).nextAll(".errlog:eq(0)").html(errmsg);
					$(this).addClass("chkError");
					$(this).parents("td:first").children(":gt(" + $(this).index() + ").errlog:first").html((settings.br ? "<BR>" : "") + errmsg);
				} else {
					if ($(this).parents("td:first").children(":gt(" + $(this).index() + ").errlog:first").html() == "") {
						$(this).removeClass("chkError");
					}
				}
			});
			return errflag;
		}
	});
    */
	//#endregion
})(jQuery);


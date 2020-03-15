(function ($) {
	//#region labelfor 把radio/checkbox加上labelfor
	$.fn.labelfor = function () {
		return this.each(function () {
			if (this.type == "radio" || this.type == "checkbox") {
				if ($(this).attr("id") != "") {
					$(this).next("label").attr("for", $(this).attr("id"));
				}
			}
		});
	}
	//#endregion

	//#region lock 指定唯讀模式
	$.fn.lock = function (cond) {
	    return this.each(function () {
	        if (typeof cond === "undefined" || cond) {//符合條件 或 沒給條件
	            if ($(this).hasClass("dateField")) {
	                $(this).datepick("option", "showOnFocus", false).next(".datepick-trigger:first").hide();
	                //xx$(this).next(".datepick-trigger:first").prop('disabled', true);
	                //$(this).datepick("disable");
	            }
	            if (this.type == "text" || this.type == "textarea") {
	                $(this).prop('readonly', true).addClass('SEdit');
	            } else {
	                $(this).prop('disabled', true);
	            }
	        }
		});
	}
	//#endregion

    //#region unlock 指定解鎖模式
	$.fn.unlock = function (cond) {
		return this.each(function () {
		    if (typeof cond === "undefined" || cond ) {//符合條件 或 沒給條件
		        if ($(this).hasClass("dateField")) {
		            $(this).datepick("option", "showOnFocus", true).next(".datepick-trigger:first").show();
		            //xx$(this).next(".datepick-trigger:first").prop('disabled', false);
		            //$(this).datepick("enable");
		        }
		        $(this).prop('readonly', false).removeClass('SEdit').prop('disabled', false);
		    }
		});
	}
	//#endregion

	//#region chkRequire
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

				//$(this).nextAll(".errlog:eq(0)").html("");
				//$(this).parents("td:first").children(":gt("+$(this).index()+").errlog:first").html("");

				if (settings.depend != null && settings.depend != undefined && settings.depend != "") {
					//if (this.type == "radio" || this.type == "checkbox") {
					//	if ($(this).prop("checked") == false) {
					//		return false;
					//	}
					//} else
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
	//#endregion

	//#region chkNumber 
	$.fn.extend({
		chkNumber: function (option) {
			var defaults = {
				msg: "",
				br: false,
				min: null,
				max: null,
				require: false
			};

			var settings = $.extend(defaults, option || {});
			var errflag = false;

			this.each(function () {
				var errmsg = "";
				if ($(this).parents("td:first").children(":gt(" + $(this).index() + ").errlog:first").length == 0) {
					$(this).parents("td:first").append("<span class='errlog'></span>");
				}

				if (this.type == "text") {
					if (settings.require && $(this).val() == "") {
						errmsg = settings.msg || "須輸入數值";
						errflag = true;
					} else if (isNaN($(this).val())) {
						errmsg = settings.msg || "須為數值";
						errflag = true;
					} else if (settings.min != null && parseFloat($(this).val()) < settings.min) {
						errmsg = settings.msg || "須>=" + settings.min;
						errflag = true;
					}
				}

				if (errmsg != "") {
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
	//#endregion

	//#region chkDate
	$.fn.extend({
		chkDate: function (option) {
			var defaults = {
				msg: "",
				br: false,
				require: false
			};

			var settings = $.extend(defaults, option || {});
			var errflag = false;

			this.each(function () {
				var errmsg = "";
				if ($(this).parents("td:first").children(":gt(" + $(this).index() + ").errlog:first").length == 0) {
					$(this).parents("td:first").append("<span class='errlog'></span>");
				}
				if (this.type == "text") {
					if ($(this).val() != "") {
						if (!$.isDate($(this).val())) {
							errmsg = settings.msg || "日期格式錯誤，請重新輸入!!! 日期格式:YYYY/MM/DD";
							errflag = true;
						}
					} else {
						if (settings.require) {
							errmsg = settings.msg || "日期格式錯誤，請重新輸入!!! 日期格式:YYYY/MM/DD";
							errflag = true;
						}
					}
				}

				if (errmsg != "") {
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
	//#endregion

	//#region chkRequireGrp
	$.fn.extend({
		chkRequireGrp: function (option) {
			var defaults = {
				msg: "",
				br: false,
				alert: true,
				extcheck: function (hasFlag) { }
			};

			var settings = $.extend(defaults, option || {});
			var errflag = false;
			var errmsg = "";
			var hasFlag = false;

			hasFlag = settings.extcheck(hasFlag);
			this.each(function () {
				//if (this.type == "radio" || this.type == "checkbox") {
				//	if ($(this).prop("checked") != true) {
				//		hasFlag = hasFlag || true;
				//	}
				//} else
				//alert($(this).val());
				if ($(this).val() != "") {
					hasFlag = hasFlag || true;
				}
				//if (window.console) {
				//	console.log(this.type + "..hasFlag.." + hasFlag);
				//}
			});

			if (!hasFlag) {
				errflag = true;
				if (settings.alert) {
					alert(settings.msg || "至少輸入一項!!");
				} else {
					this.each(function () {
						if ($(this).parents("td:first").children(":gt(" + $(this).index() + ").errlog:first").length == 0) {
							$(this).parents("td:first").append("<span class='errlog'></span>");
						}

						errmsg = settings.msg || "至少輸入一項!!";
						//console.log(errmsg);
						$(this).addClass("chkError");
						$(this).parents("td:first").children(":gt(" + $(this).index() + ").errlog:first").html((settings.br ? "<BR>" : "") + errmsg);
					});
				}
			} else {
				this.each(function () {
					if ($(this).parents("td:first").children(":gt(" + $(this).index() + ").errlog:first").html() == "") {
						$(this).removeClass("chkError");
					}
				});
			}
			return errflag;
		}
	});
	//#endregion

	//#region chkLength
	$.fn.extend({
		chkLength: function (option) {
			var defaults = {
				msg: "",
				br: false,
				max:0
			};

			var settings = $.extend(defaults, option || {});
			var errflag = false;

			this.each(function () {
				var errmsg = "";

				if ($(this).parents("td:first").children(":gt(" + $(this).index() + ").errlog:first").length == 0) {
					$(this).parents("td:first").append("<span class='errlog'></span>");
				}

				if ($.BLen($(this).val()) > settings.max) {
					errmsg = settings.msg || "長度過長，請檢查！";
				}
				
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
	//#endregion

	//#region chkErrorExt
	$.fn.extend({
		chkErrorExt: function (option) {
			var defaults = {
				msg: "資料有誤，請檢查!!",
				br: false,
				alert: false,
				checkErr: function (extFlag) { }
			};

			var settings = $.extend(defaults, option || {});
			var errflag = false;

			errflag = settings.checkErr(settings);

			if (errflag) {
				if (settings.alert) {
					alert(settings.msg);
				} else {
					this.each(function () {
						if ($(this).parents("td:first").children(":gt(" + $(this).index() + ").errlog:first").length == 0) {
							$(this).parents("td:first").append("<span class='errlog'></span>");
						}
						$(this).addClass("chkError");
						$(this).parents("td:first").children(":gt(" + $(this).index() + ").errlog:first").html((settings.br ? "<BR>" : "") + settings.msg);
					});
				}
			} else {
				this.each(function () {
					if ($(this).parents("td:first").children(":gt(" + $(this).index() + ").errlog:first").html() == "") {
						$(this).removeClass("chkError");
					}
				});
			}

			return errflag;
		}
	});
	//#endregion

    //#region getOption
	$.fn.extend({
	    getOption: function (option) {
	        var obj = $(this);
	        var defaults = {
	            debug: false,
	            url: "",
	            data: null,
	            dataList: null,
	            showEmpty: true,//顯示"請選擇"
	            valueFormat: "",//option的value格式,用{}包住欄位,ex:{scode}
	            textFormat: "",//option的文字格式,用{}包住欄位,ex:{scode}_{sc_name}
	            attrFormat: "",//option的attribute格式,用{}包住欄位,ex:value1='{scode1}' value2='{sscode}'
	            firstOpt: "",//要在最上面額外增加option,ex:<option value='*'>全部<option>
	            lastOpt: "",//要在最下面額外增加option,ex:<option value='*'>全部<option>
	            setValue: ""//預設值
	        };
	        var settings = $.extend(defaults, option || {});  //初始化

	        var debugurl = settings.url + "?";// + unescape(unescape($.param(settings.data)));
	        if (settings.data != null) debugurl += unescape(unescape($.param(settings.data)));
	        if (settings.debug) {
	            if ($("body").find("#divDebug").length == 0) {
	                $("body").append("<div id=\"divDebug\" style=\"display:none;color:#1B3563\"></div>");
	            }
	            $("#divDebug").html("<a href=\"" + debugurl + "\" target=\"_blank\">Open getOption Debug Win<a>");
	            $("#divDebug").show();
	            $("#divDebug").fadeOut(5000);
	        }

	        return this.each(function () {
	            var obj = $(this);

	            if (settings.dataList == null) {
	                $.ajax({
	                    async: false,
	                    cache: false,
	                    type: "get",
	                    data: settings.data,
	                    url: settings.url,
	                    success: function (json) {
	                        settings.dataList = $.parseJSON(json);
	                    },
	                    beforeSend: function (jqXHR, settings) {
	                        jqXHR.url = settings.url;
	                        //toastr.info("<a href='" + jqXHR.url + "' target='_new'>debug！\n" + jqXHR.url + "</a>");
	                    },
	                    error: function (jqXHR, textStatus, errorThrown) {
	                        //window.open(debugurl);
	                        //alert("載入查詢清單發生錯誤!!");
	                        toastr.error("<a href='" + jqXHR.url + "' target='_new'>載入查詢清單發生錯誤！<BR><b><u>(點此顯示詳細訊息)</u></b></a>");
	                    }
	                });
	            }

	            if (settings.firstOpt != "") {
	                obj.append(settings.firstOpt);
	            }
	            if (settings.showEmpty) {
	                obj.append("<option value='' style='COLOR:blue'>請選擇</option>");
	            }
	            $.each(settings.dataList, function (i, item) {
	                //處理value
	                var val = settings.valueFormat;
	                Object.keys(item).forEach(function (key) {
	                    var re = new RegExp("{" + key + "}", "ig");
	                    val = val.replace(re, item[key]);
	                });

	                //處理text
	                var txt = settings.textFormat;
	                Object.keys(item).forEach(function (key) {
	                    var re = new RegExp("{" + key + "}", "ig");
	                    txt = txt.replace(re, item[key]);
	                });

	                //處理attribute
	                var attr = settings.attrFormat;
	                Object.keys(item).forEach(function (key) {
	                    var re = new RegExp("{" + key + "}", "ig");
	                    attr = attr.replace(re, item[key]);
	                });
	                obj.append("<option value='" + val + "' " + attr + ">" + txt + "</option>");
	            });
	            obj.val(settings.setValue);


	        });
	    }
	});
    //#endregion
})(jQuery);


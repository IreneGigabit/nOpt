/**
* @license Copyright (c) 2003-2018, CKSource - Frederico Knabben. All rights reserved.
* For licensing, see https://ckeditor.com/legal/ckeditor-oss-license
*/

CKEDITOR.editorConfig = function (config) {
    // Define changes to default configuration here.
    // For complete reference see:
    // http://docs.ckeditor.com/#!/api/CKEDITOR.config

    //config.uiColor = '#cbe1fc';//主題為moono時才有效
    config.skin = 'office2013';

    // The toolbar groups arrangement, optimized for two toolbar rows.
    
    config.toolbarGroups = [
    { name: 'styles' },//様式.格式.字型.大小
    { name: 'paragraph', groups: ['list', 'indent', 'blocks', 'bidi', 'spellchecker'] },//清單.縮排.拼字檢查
    { name: 'tools' },//最大化
    { name: 'document', groups: ['mode', 'document', 'doctools'] },//原始碼
    '/',//換行
    { name: 'clipboard', groups: ['clipboard', 'undo'] },//剪貼簿
    { name: 'basicstyles', groups: ['basicstyles', 'cleanup', 'align'] },//粗體.斜體.....對齊
    { name: 'insert' },//插入
    { name: 'colors' },//顏色
    { name: 'about' },//?
    ];
    /*config.toolbarGroups = [
		{ name: 'styles' },//様式.格式.字型.大小
		{ name: 'tools' },//最大化
		//'/',//換行
		{ name: 'basicstyles', groups: ['basicstyles', 'cleanup'] },//粗體.斜體.....
		{ name: 'align' },//對齊
		{ name: 'insert' },//插入
		{ name: 'editing', groups: ['find', 'selection', 'spellchecker'] },//拼字檢查
        ////{ name: 'links' },
		////{ name: 'forms' },
		//{ name: 'others' },
		//'/',//換行
		{ name: 'clipboard', groups: ['clipboard', 'undo'] },//剪貼簿
	    { name: 'paragraph', groups: ['list', 'indent', 'blocks', 'bidi'] },//清單.縮排
		{ name: 'colors' },//顏色
		{ name: 'document', groups: ['mode', 'document', 'doctools'] },//原始碼
		{ name: 'about' },//?
        ////indent 縮排功能 , blocks 整塊縮排
        ////{name: 'paragraph', groups: ['list', 'align', 'bidi'] },
    ];*/
    /*
    // The toolbar groups arrangement, optimized for two toolbar rows.
    config.toolbarGroups = [
		{ name: 'clipboard', groups: ['clipboard', 'undo'] },
		{ name: 'editing', groups: ['find', 'selection', 'spellchecker'] },
    //{ name: 'links' },
		{name: 'insert' },
		{ name: 'forms' },
		{ name: 'tools' },
		{ name: 'document', groups: ['mode', 'document', 'doctools'] },
		{ name: 'others' },
		{ name: 'basicstyles', groups: ['basicstyles', 'cleanup'] },
		'/',
	    { name: 'paragraph', groups: ['list', 'indent', 'blocks', 'align', 'bidi'] },
    //indent 縮排功能 , blocks 整塊縮排
    //{name: 'paragraph', groups: ['list', 'align', 'bidi'] },
		{name: 'colors' },
		{ name: 'styles' },
		{ name: 'about' }
	];
    */
    //定義button的顯示語言，因為外掛plugin:font在big5顯示button名稱時，會變成亂碼，所以改成使用英文顯示
    config.language = 'zh-tw';

    //config.extraPlugins = 'colorbutton,font';
    //colorbutton :字型顏色, font: 字型大小, justify段落靠左/靠右/置中 , tab TAB鍵生效
    config.extraPlugins = 'colorbutton,font,justify,tab';
    config.tabSpaces = 4;   //TAB鍵空白

    config.enterMode = CKEDITOR.ENTER_BR;
    config.shiftEnterMode = CKEDITOR.ENTER_P;

    // Remove some buttons provided by the standard plugins, which are
    // not needed in the Standard(s) toolbar.
    //config.removeButtons = 'Underline,Subscript,Superscript';

    //將圖片處理移除(包含url上傳)
    config.removeButtons = 'Image';

    //20181213:因代理人原信中含有 <title></title>的tag , 但是到了ckeditor編輯email內容時，title tag會自動被拿掉，就變成email內容的一部分顯示出來了
    //         使用下列方式，可以阻止ckeditor拿掉title tag
    //config.allowedContent = true;
    //config.protectedSource.push(/<title>[\s\S]*?<\/title>/gi); // allow content between <title></title>
    //上述寫法，在word複製內容時，會把書籤(bookmark)一起複製，變成連結，所以改成下列寫法
    config.allowedContent = false;
    config.extraAllowedContent = 'title(*)';

    //將 link 功能拿掉
    //config.removePlugins = 'link'; 

    //將 word 貼入功能拿掉
    //config.removePlugins = 'pastefromword';


    //強制貼入後的文字變成純文字
    //config.forcePasteAsPlainText = true;


    // Set the most common block elements.
    //config.format_tags = 'p;h1;h2;h3;pre';

    // Simplify the dialog windows.
    //config.removeDialogTabs = 'image:advanced;link:advanced';

    //config.extraPlugins = 'tab';

    config.format_tags= 'p;h1;h2;h3;h4;h5;h6;pre;address;div';
    config.font_names = 'Arial/Arial, Helvetica, sans-serif;Comic Sans MS/Comic Sans MS, cursive;Courier New/Courier New, Courier, monospace;Georgia/Georgia, serif;Lucida Sans Unicode/Lucida Sans Unicode, Lucida Grande, sans-serif;Tahoma/Tahoma, Geneva, sans-serif;Times New Roman/Times New Roman, Times, serif;Trebuchet MS/Trebuchet MS, Helvetica, sans-serif;Verdana/Verdana, Geneva, sans-serif;新細明體;標楷體;微軟正黑體';
};

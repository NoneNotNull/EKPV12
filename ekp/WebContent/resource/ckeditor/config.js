﻿/**
	 * @license Copyright (c) 2003-2013, CKSource - Frederico Knabben. All
	 *          rights reserved. For licensing, see LICENSE.html or
	 *          http://ckeditor.com/license
	 */

CKEDITOR.editorConfig = function(config) {
	// Define changes to default configuration here. For example:
	// config.language = 'fr';
	// config.uiColor = '#AADC6E';
	config.customConfig = "";// 自定义config文件
	config.baseHref = "";
	config.skin = 'moono';
	config.fullPage = false;
	config.defaultLanguage = 'zh-cn';
	config.contentsLangDirection = 'ltr';
	config.forcePasteAsPlainText = false;
	config.fillEmptyBlocks = true;
	config.startupFocus = false;
	config.forceSimpleAmpersand = false;
	config.tabSpaces = 0;

	config.filebrowserBrowseUrl = '';

	config.filebrowserImageBrowseUrl = '';
	config.filebrowserFlashBrowseUrl = '';

	config.htmlEncodeOutput = false;
	// 粘贴word保持格式
	config.pasteFromWordRemoveFontStyles = false;
	config.pasteFromWordRemoveStyles = false;
	CKEDITOR.config.entities = false;

	config.toolbar_Default = [
			[ 'Cut', 'Copy', 'Paste' ],[ 'Font', 'FontSize' ],
			[ 'TextColor', 'BGColor', 'Bold', 'Italic' ],
			[ 'Link', 'Unlink'],
			[ 'multiimage', 'Smiley'],
			[ 'Maximize' ],
			'/',
			[ 'Undo', 'Redo', 'Table' ],
			[ 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock' ],
			[ 'NumberedList', 'BulletedList' ],
			[ 'Format' ],
			[ 'Anchor' ],
			[ 'Flash', 'SpecialChar', 'PageBreak', 'HorizontalRule' ],
			[ 'Find', 'Replace', 'SelectAll', 'Scayt' ],
			[ 'Underline', 'Strike', 'Subscript', 'Superscript', '-',
					'RemoveFormat' ],
			[ 'Outdent', 'Indent', '-', 'Blockquote', 'CreateDiv' ],
			[ 'PasteText', 'PasteFromWord' ],
			[ 'ShowBlocks', 'Source', 'About' ] ];
	
	config.toolbar_Keydata = [
	              			[ 'Cut', 'Copy', 'Paste', '-', 'Undo', 'Redo', '-', 'Link',
	              					'Unlink', '-', 'multiimage', 'Smiley', 'Table' ],
	              			[ 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock' ],
	              			[ 'NumberedList', 'BulletedList' ],
	              			[ 'Maximize' ],
	              			[ 'Format' ],
	              			[ 'Font' ],
	              			[ 'FontSize' ],
	              			[ 'TextColor', 'BGColor', 'Bold', 'Italic' ],[ 'keydata' ],
	              			'/',
	              			[ 'Anchor' ],
	              			[ 'Flash', 'SpecialChar', 'PageBreak', 'HorizontalRule' ],
	              			[ 'Find', 'Replace', 'SelectAll', 'Scayt' ],
	              			[ 'Underline', 'Strike', 'Subscript', 'Superscript', '-',
	              					'RemoveFormat' ],
	              			[ 'Outdent', 'Indent', '-', 'Blockquote', 'CreateDiv' ],
	              			[ 'PasteText', 'PasteFromWord' ],
	              			[ 'ShowBlocks', 'Source', 'About' ] ];

	// kms维基库
	config.toolbar_Wiki = [
			[ 'Category', 'Wikilink' ],
			[ 'Cut', 'Copy', 'Paste', '-', 'Undo', 'Redo', '-', 'Link',
					'Unlink', '-', 'multiimage', 'Table' ],
			[ 'FontSize' ],
			[ 'TextColor', 'BGColor', 'Bold', 'Italic' ],
			[ 'Maximize' ],
			'/',
			[ 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock' ],
			[ 'NumberedList', 'BulletedList' ],
			[ 'Font' ],
			[ 'Anchor' ],
			[ 'Flash', 'SpecialChar', 'PageBreak', 'HorizontalRule' ],
			[ 'Find', 'Replace', 'SelectAll', 'Scayt' ],
			[ 'Outdent', 'Indent', '-', 'Blockquote', 'CreateDiv' ],
			'/',
			[ 'Underline', 'Strike', 'Subscript', 'Superscript', '-',
					'RemoveFormat' ], [ 'PasteText', 'PasteFromWord' ],
			[ 'ShowBlocks', 'Source' ] ];

	config.toolbarGroups = [ {
		name : 'document',
		groups : [ 'mode', 'document', 'doctools' ]
	}, {
		name : 'clipboard',
		groups : [ 'clipboard', 'undo' ]
	}, '/', {
		name : 'editing',
		groups : [ 'find', 'selection', 'spellchecker' ]
	}, {
		name : 'forms'
	}, {
		name : 'basicstyles',
		groups : [ 'basicstyles', 'cleanup' ]
	}, {
		name : 'paragraph',
		groups : [ 'list', 'indent', 'blocks', 'align' ]
	}, {
		name : 'links'
	}, {
		name : 'insert'
	}, '/', {
		name : 'styles'
	}, {
		name : 'colors'
	}, {
		name : 'tools'
	}, {
		name : 'others'
	}, {
		name : 'about'
	} ];

	config.toolbar = 'Default';

	var __basePath = CKEDITOR.basePath.replace(/ckeditor/g, 'fckeditor');
	// 旺旺表情
	config.smiley_path = __basePath + "editor/images/smiley/wangwang/";
	config.smiley_images = [ '001.gif', '002.gif', '003.gif', '004.gif',
			'005.gif', '006.gif', '007.gif', '008.gif', '009.gif', '010.gif',
			'011.gif', '012.gif', '013.gif', '014.gif', '015.gif', '016.gif',
			'017.gif', '018.gif', '019.gif', '020.gif', '021.gif', '022.gif',
			'023.gif', '024.gif', '025.gif', '026.gif', '027.gif', '028.gif',
			'029.gif', '030.gif', '031.gif', '032.gif', '033.gif', '034.gif',
			'035.gif', '036.gif', '037.gif', '038.gif', '039.gif', '040.gif',
			'041.gif', '042.gif', '043.gif', '044.gif', '045.gif', '046.gif',
			'047.gif', '048.gif', '049.gif', '050.gif', '051.gif', '052.gif',
			'053.gif', '054.gif', '055.gif', '056.gif', '057.gif', '058.gif',
			'059.gif', '060.gif', '061.gif', '062.gif', '063.gif', '064.gif',
			'065.gif', '066.gif', '067.gif', '068.gif', '069.gif', '070.gif',
			'071.gif', '072.gif' ];
	CKEDITOR.config.smiley_descriptions = [];
	config.smiley_columns = 8;
	// config.smiley_width = 660;
	config.smiley_height = 480;

	// 图片上传
	config.ImageBrowser = true;

	config.getFilebrowserImageUploadUrl = function(editor) {
		editor.config.filebrowserImageUploadUrl = __basePath
				+ 'editor/filemanager/upload/simpleuploader?Type=Image';
		if (editor.config.fdModelName && editor.config.fdModelId) {
			editor.config.filebrowserImageUploadUrl += '&fdModelName='
					+ editor.config.fdModelName + '&fdModelId='
					+ editor.config.fdModelId;
		}
		return editor.config.filebrowserImageUploadUrl;
	}
	
	config.downloadUrl = Com_Parameter.ContextPath
			+ 'resource/fckeditor/editor/filemanager/download';
	window['CKconfig'] = {};
	CKconfig.ImageUploadAllowedExtensions = "*.gif;*.jpg;*.jpeg;*.bmp;*.png"; // empty
// CKconfig.ImageUploadDeniedExtensions = ""; // empty for no one

	// flash上传
	config.FlashBrowser = true;
	config.filebrowserFlashUploadUrl = __basePath
			+ 'editor/filemanager/upload/simpleuploader?Type=Flash';
	CKconfig.FlashUploadAllowedExtensions = ".(swf|flv)$"; // empty for all
	CKconfig.FlashUploadDeniedExtensions = ""; // empty for no one

	config.filebrowserUploadUrl = "";

	// 同一ued页面
	var csss = null;
	if (window.seajs) {
		var themes = seajs.data.themes;
		var common = themes.common[0], form = themes.form[0];
		var base = seajs.data.contextPath ? seajs.data.contextPath
				: seajs.data.env.contextPath;
		common = (base + '/' + common).replace(/\/\//g, '/');
		form = (base + '/' + form).replace(/\/\//g, '/');
		csss = [ common, form ];
	} else if (Com_Parameter.StylePath)// 后台管理页面
		csss = [ Com_Parameter.StylePath + 'doc/document.css' ];
	csss.push(Com_Parameter.ContextPath + 'resource/ckeditor/contents.css');
	config.contentsCss = csss;
	config.font_names = '微软雅黑/Microsoft YaHei, Geneva, "sans-serif", SimSun;宋体/宋体;黑体/黑体;楷体_GB2312/楷体;仿宋_GB2312/仿宋;隶书/隶书;幼圆/幼圆;新宋体/新宋体;细明体/细明体;Arial/Arial;Arial Black/Arial Black;Arial Narrow/Arial Narrow;Bradley Hand ITC/Bradley Hand ITC;Brush Script MT/Brush Script MT;Century Gothic/Century Gothic;Comic Sans MS/Comic Sans MS;Courier/Courier;Courier New/Courier New;MS Sans Serif/MS Sans Serif;Script/Script;System/System;Times New Roman/Times New Roman;Viner Hand ITC/Viner Hand ITC;Verdana/Verdana;Wide Latin/Wide Latin;Wingdings/Wingdings';
	config.font_defaultLabel = '微软雅黑';
	config.extraPlugins = 'category,wikilink,pasteimage,multiimage,keydata';

	config.allowedContent = true;
	// 不显示下方标签路径
	// config.resize_enabled = false;
	config.removePlugins = 'elementspath';

};

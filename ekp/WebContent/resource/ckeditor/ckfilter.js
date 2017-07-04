/**
 * CK 编辑内容过滤器
 */
Com_RegisterFile("ckeditor/ckfilter.js");
Com_IncludeFile("security.js");

CKFilter = new Object();

CKFilter.replaceFilters = [];
CKFilter.ckInstanceName = [];

CKFilter.fireReplaceFilters = function(str) {
	var rtn = str;
	var fns = CKFilter.replaceFilters;
	for (var i = 0; i < fns.length; i++) {
		rtn = fns[i](rtn);
	}
	return rtn;
};

CKFilter.addReplaceFilter = function(field, enforce) {
	CKFilter.ckInstanceName.push(field);
};
// 过滤非法html对象
CKFilter.replaceFilters.push(function(str) {
	return str.replace(/<(script|link|iframe)[\s|\S]*?<\/\1>/ig, "");
});
// 过滤form
CKFilter.replaceFilters.push(function(str) {
	return str.replace(/<form[^>]*>/ig, "").replace(/<\/form>/ig, "");
});
// 过滤触发脚本
CKFilter.replaceFilters.push(function(str) {
	return str.replace(
			/<([a-z][^>]*)\son[a-z]+\s*=\s*("[^"]+"|'[^']+'|[^\s]+)([^>]*)>/ig,
			"<$1$3>");
});
// 过滤链接脚本
CKFilter.replaceFilters
		.push(function(str) {
			return str
					.replace(
							/<([a-z][^>]*)\s(href|src)\s*=\s*("\s*(javascript|vbscript):[^"]+"|'\s*(javascript|vbscript):[^']+'|(javascript|vbscript):[^\s]+)([^>]*)>/ig,
							'<$1 $2=""$7>');
		});
// 去除隐藏域
CKFilter.replaceFilters.push(function(str) {
	return str.replace(
			/<([a-z][^>]*)\stype\s*=\s*("hidden"|'hidden'|hidden)([^>]*)>/gi,
			"");
});
// 去除表单名称
CKFilter.replaceFilters.push(function(str) {
	return str.replace(
			/<([b-z][^>]*)\sname\s*=\s*("[^"]+"|'[^']+'|[^\s]+)([^>]*)>/gi,
			"<$1$3>");
});
// 去除注释
CKFilter.replaceFilters.push(function(str) {
	return str.replace(/<!--[\s\S]*?-->/g, '');
});

CKFilter.SetOnAfterLinkedFieldUpdate = function(name) {
	var editor = CKEDITOR.instances[name];
	var fn = function() {
		var html = editor.getData();
		html = CKFilter.fireReplaceFilters(html);
		editor.setData(html);
	};
	editor.element.on('updateEditorElement', fn);
};

CKFilter.SetEnforceOnAfterLinkedFieldUpdate = function(name) {
	var editor = CKEDITOR.instances[name];
	var fn = function() {
		var html = editor.getData();
		html = html.replace(/<(script|iframe)[\s|\S]*?<\/\1>/ig, "");
		editor.setData(html);
	};
	editor.element.on('updateEditorElement', fn);
};
CKFilter.SetBase64Encode = function(name) {
	var editor = CKEDITOR.instances[name];
	editor.element.on('updateEditorElement', function(e) {
		var html = editor.getData();
		editor.setData(base64Encode(html));
	});
};

CKFilter.registerLinkedFieldUpdateListeners = function() {

	var len = 0;
	for ( var k in CKEDITOR.instances) {
		len++;
	}
	if (len != CKFilter.ckInstanceName.length) {
		setTimeout(CKFilter.registerLinkedFieldUpdateListeners, 1000);
		return;
	}

	var i, names = CKFilter.ckInstanceName;
	for (i = 0; i < names.length; i++) {
		CKFilter.SetOnAfterLinkedFieldUpdate(names[i]);
	}
	for (i = 0; i < names.length; i++) {
		CKFilter.SetEnforceOnAfterLinkedFieldUpdate(names[i]);
	}

	for ( var name in CKEDITOR.instances) {
		CKFilter.SetBase64Encode(name);
	}
};

Com_AddEventListener(window, "load",
		CKFilter.registerLinkedFieldUpdateListeners);

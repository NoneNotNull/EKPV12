var CKEDITOR_EXTEND = {};

CKEDITOR_EXTEND.getTop = function(node, stopNode) {
	var y = 0;
	for (var pNode = node; pNode != null && pNode !== stopNode; pNode = pNode.offsetParent) {
		y += pNode.offsetTop - pNode.scrollTop;
	}
	return y;
};

// 点击构造维基库目录

CKEDITOR_EXTEND.ckeditorCategoryChange = function(editor) {
	var targetWindow = "window";
	var cateArr = CKEDITOR_EXTEND.getCategorys(editor);
	var html = new Array();
	for (var i = 0; i < cateArr.length; i++) {
		var o = cateArr[i];
		var text = $(o).text();
		if (text.length > 10) {
			text = text.substring(0, 10) + "...";
		}
		if (o.tagName == "H3") {
			html.push("<li class='lui_wiki_catelog_t'>" + text + "</li>");
		} else {
			html.push("<li class='lui_wiki_catelog_s'>" + text + "</li>");
		}
	}
	var innerHTML = html.join("");
	var eidtorId = $('#cke_' + editor.name).parent().attr('id'), id = eidtorId
			.substring("editable_".length);
	$('#viewable_' + id).html(innerHTML);
}

// 获取目录信息
CKEDITOR_EXTEND.getCategorys = function(editor, except1, keep1) {
	var oContent, cateArr = new Array();
	if (except1) {
		oContent = editor;
		var cate3Arr = editor.getElementsByTagName("H2");
		for (var i = 0; i < cate3Arr.length; i++)
			cateArr.push(cate3Arr[i]);
	} else {
		oContent = editor.document.getBody().$;// 当前body对象
	}
	if (!keep1) {
		var cate1Arr = oContent.getElementsByTagName("H3");
		var cate2Arr = oContent.getElementsByTagName("H4");

		// 若一二级目录都有，需要排序

		for (var i = 0; i < cate1Arr.length; i++)
			cateArr.push(cate1Arr[i]);
		for (i = 0; i < cate2Arr.length; i++)
			cateArr.push(cate2Arr[i]);
	}

	cateArr.sort(function(o1, o2) {
				return CKEDITOR_EXTEND.getTop(o1, oContent)
						- CKEDITOR_EXTEND.getTop(o2, oContent);
			});
	return cateArr;
};

// 刷新目录
CKEDITOR_EXTEND.refresh = function(oContent, oCate, except1, keep1) {
	var targetWindow = "window";
	var cateArr = CKEDITOR_EXTEND.getCategorys(oContent, except1, keep1);
	var html = new Array();
	var index_2 = -1;
	var index_3 = -1;
	var index_4 = -1;
	var divIndex = -1;
	var divContent = [];
	for (var i = 0; i < cateArr.length; i++) {
		var o = cateArr[i];
		// 兼容多浏览器
		var text = $(o).text();
		if (text.length > 10) {
			text = text.substring(0, 10) + "...";
		}
		if (o.tagName == "H2") {
			divIndex++;
			divContent[divIndex] = [];
			index_2++;
			if (o.childNodes.length > 0) {
				var a = o.childNodes[0];
				if (a.nodeType == '1' && a.getAttribute('name')
						&& a.getAttribute('name').indexOf('viewable_') > -1) {
					var divId = a.getAttribute('name'), divId = "viewable_"
							+ divId.substring("editable_".length);
					html
							.push("<li categoryIndex='1' class='lui_wiki_catelog_f'><a href='javascript:void(0)' onclick='"
									+ targetWindow
									+ ".CKEDITOR_EXTEND.scrollTo(\"H2\", "
									+ index_2
									+ ")'>"
									+ text
									+ "</a>"
									+ "</li>"
									+ "<div id='"
									+ divId
									+ "' >{{divContent"
									+ divIndex + "}}</div>");
				}
			}
		} else if (o.tagName == "H3") {
			index_3++;
			divContent[divIndex]
					.push("<li class='lui_wiki_catelog_s' categoryIndex='2'><a href='javascript:void(0)' onclick='"
							+ targetWindow
							+ ".CKEDITOR_EXTEND.scrollTo(\"H3\", "
							+ index_3
							+ ")'>" + text + "</a></li>");
		} else {
			index_4++;
			divContent[divIndex]
					.push("<li class='lui_wiki_catelog_t' categoryIndex='3'><a href='javascript:void(0)' onclick='"
							+ targetWindow
							+ ".CKEDITOR_EXTEND.scrollTo(\"H4\", "
							+ index_4
							+ ")'>" + text + "</a></li>");
		}
	}
	var innerHTML = html.join("");
	for (var j = 0; j < divContent.length; j++) {
		innerHTML = innerHTML.replace("{{divContent" + j + "}\}", divContent[j]
						.join(''));
	}

	oCate.innerHTML = innerHTML;
};

// 点击目录后定位到目录位置
CKEDITOR_EXTEND.scrollTo = function(tagName, index) {
	var contDiv = document.getElementById('contentDiv');
	if (contDiv) {
		oBody = document.body, obj = contDiv.getElementsByTagName(tagName)[index];
		if (obj != null) {
			LUI.$(oBody).animate({
						scrollTop : CKEDITOR_EXTEND.getTop(obj, oBody) - 25
					}, 500);
		}
	}
};
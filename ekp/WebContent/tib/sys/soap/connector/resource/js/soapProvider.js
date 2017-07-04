
function soapToStandardXml(xmlObj) {
	$(xmlObj).find("web Output").remove();
	$(xmlObj).find("web Fault").remove();
	var inputObj=$(xmlObj).find("web");
	
	// 控制是否可拉线
	var notPreview = new Array();
	notPreview.push("web");
	notPreview.push("Input");
	notPreview.push("Envelope");
	notPreview.push("Header");
	notPreview.push("Body");
	notPreview.push("Output");
	notPreview.push("Fault");
	// 递归解析，设置展示信息
	Soap_getNextDOM($(inputObj), notPreview);
	
}

function Soap_getNextDOM(obj, notPreview){
	if(obj.length > 0){
		obj.each(function(i){
			var nodeName = $(this)[0].tagName;
			// 去除:号之前的命名
			var splitNameIndex = nodeName.indexOf(":");
			if (splitNameIndex != -1) {
				nodeName = nodeName.substring(splitNameIndex + 1);
			}
			var commentJson = TIB_SysUtil.getCommentJson($(this)[0], TIB_SysUtil.defalutCommentHandler);
			// 控制是否可拉线
			if (nodeName == "Body") {
				var firstChildObjs = $(this).children("*")[0];
				// 是否还存在子节点
				if ($(firstChildObjs).children().length > 0) {
					var bodyFirstChild = $(firstChildObjs)[0].tagName;
					var index = bodyFirstChild.indexOf(":");
					if (index != -1) {
						bodyFirstChild = bodyFirstChild.substring(index + 1);
					} 
					notPreview.push(bodyFirstChild);
				} 
			}
			// 设置是否可看见拉线属性
			if ($.inArray(nodeName, notPreview) != -1) {
				$($(this)[0]).attr("isPreview", "0");
			} else {
				$($(this)[0]).attr("isPreview", "1");
			}
			// 展现节点的name
			$($(this)[0]).attr("name", nodeName);
			if (commentJson != null) {
				var ctype = commentJson.ctype;
				if (ctype != undefined) {
					$($(this)[0]).attr("ctype", ctype);
				}
			}
			Soap_getNextDOM($(this).children(), notPreview);
		});
	}
}



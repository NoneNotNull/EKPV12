
function sapToStandardXml(xmlObj) {
	$(xmlObj).find("jco export").remove();
	var inTableObj = $(xmlObj).find("jco tables table[isin='1']");
	if (inTableObj.length == 0) {
		$(xmlObj).find("jco tables").remove();
	} else {
		$(xmlObj).find("jco tables table[isin='0']").remove();
	}
	
	var inputObj=$(xmlObj).find("jco");
	// 是否需要出现在接口预览
	var notPreview = new Array();
	notPreview.push("jco");
	notPreview.push("import");
	notPreview.push("export");
	notPreview.push("structure");
	notPreview.push("tables");
	notPreview.push("table");
	notPreview.push("records");
	Sap_getNextDOM($(inputObj), notPreview);
	
}

function Sap_getNextDOM(obj, notPreview){
	if(obj.length > 0){
		obj.each(function(i){
			var nodeName = $(this)[0].tagName;
			// 去除:号之前的命名
			var splitNameIndex = nodeName.indexOf(":");
			if (splitNameIndex != -1) {
				nodeName = nodeName.substring(splitNameIndex + 1);
			}
			var name = $($(this)[0]).attr("name");
			if (name == undefined) {
				$($(this)[0]).attr("name", nodeName);
			}
			// 组装需要的属性数据
			if ($.inArray(nodeName, notPreview) != -1) {
				$($(this)[0]).attr("isPreview", "0");
			} else {
				$($(this)[0]).attr("isPreview", "1");
			}
			/* var nodeCtype = $($(this)[0]).attr("ctype");
			if (nodeCtype != undefined) {
				providerJson += "ctype:'"+ nodeCtype +"',";
			}
			var decimals = $($(this)[0]).attr("decimals");
			if (decimals != undefined) {
				providerJson += "minleng:'"+ decimals +"',";
			}
			var maxlength = $($(this)[0]).attr("maxlength");
			if (maxlength != undefined) {
				providerJson += "maxleng:'"+ maxlength +"',";
			} */
			var isoptional = $($(this)[0]).attr("isoptional");
			if (isoptional != undefined) {
				if (isoptional == "true") {
					$($(this)[0]).attr("required", "1");
				} else {
					$($(this)[0]).attr("required", "0");
				}
			}
			Sap_getNextDOM($(this).children(), notPreview);
		});
	}
}


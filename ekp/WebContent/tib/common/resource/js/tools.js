/**
 * 小插件文件,用来优化用户体验小插件
 */
/**
 * jquery 遮罩层
 * base ：jquery.js ,htmlhead.jsp with Com_Parameter
 * 
 */
$.extend({
	cover : {
		show : function() {
			$.cover.hide();
			var str = "<div id='cover' style='position:absolute;background-color: #FCFAFA;"
			str += "width:100%";
			str += "height:" + $('body').height() + "px;";
			str += "opacity:0.5;filter:alpha(opacity=50);";
			str += "top:0;left:0;z-index=10'> <div style='position:relative; width:100%;*position:absolute; *top:200px; *left:50%;'>";
			str += "<img src="+Com_Parameter.ContextPath+"resource/style/common/images/loading.gif"+"></img></div> </div>";
			$(document.body).append(str);
		},
		hide : function() {
			$("#cover").remove();
		}
	}
	
});

var TibUtil = {
	extend : function(target, exts) {
		if (!exts)
			return target;
		for (var name in exts) {
			target[name] = exts[name];
		}
		return target;
	},
	tibTreeDialog : function(opts) {
		var defaults = {
			mulSelect : false,
			idField : "",
			nameField : "",
			splitStr : ";",
			treeBean : "",
			treeTitle : "",
			dataBean : "",
			action : null,
			searchBean : "",
			exceptValue : null,
			isMulField : false,
			notNull : true,
			winTitle : ""
		};
		var data = this.extend(defaults, opts);
		Dialog_TreeList(data.mulSelect, data.idField, data.nameField,
				data.splitStr, data.treeBean, data.treeTitle, data.dataBean,
				data.action, data.searchBean, data.exceptValue,
				data.isMulField, data.notNull, data.winTitle);
	},
	XML2String : function(xmlObject) {
		// for IE，兼容ie11
		if (!!window.ActiveXObject || "ActiveXObject" in window) {
			return xmlObject.xml;
		} else {
			// for other browsers
			return (new XMLSerializer()).serializeToString(xmlObject);
		}
	}
};

/****************
 * 去除前后空格
 * @returns
 ****************/
String.prototype.trim = function(){
	return this.replace(/^\s+|\s+$/g, ''); 
};
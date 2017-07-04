define(["dojo/_base/declare", "dijit/_WidgetBase","dijit/_Contained", "dijit/_Container"], 
		function(declare, WidgetBase, Contained, Container) {
		//	标示不参与页面解析的dojo组件部分
		var templ = declare("mui.form.Template", [WidgetBase, Contained, Container], {
			stopParser:true
		});
		return templ;
});
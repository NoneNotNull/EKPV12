define([
    "mui/tabbar/TabBarButton",
	"dojo/_base/declare",
	"mui/i18n/i18n!sys-mobile",
	"mui/device/adapter" 
	], function(TabBarButton, declare, Msg , adapter) {
	
	var goHome = function() {
		var rtn = adapter.closeWindow();
		if(rtn==null){//无接口、接口调用不存在或失败情况
			location = dojoConfig.baseUrl?dojoConfig.baseUrl:'/';
		}
	};
	
	return declare("mui.back.HomeButton", [TabBarButton], {
		icon1: "mui mui-home",
		
		align: "left",
		
		buildRendering:function(){
			this.inherited(arguments);
			this.labelNode.innerHTML = Msg['mui.back.home'];
		},
		
		_onClick : function(evt) {
			setTimeout(function(){
				goHome();
			}, 350);
		}
	});
});
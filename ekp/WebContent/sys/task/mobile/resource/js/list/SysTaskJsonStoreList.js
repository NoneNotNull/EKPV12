define([
    "dojo/_base/declare",
    "dojo/topic",
	"mui/list/JsonStoreList",
	"dojox/mobile/viewRegistry"
	], function(declare,topic, JsonStoreList,viewRegistry) {
	
	return declare("sys.task.list.SysTaskJsonStoreList", [JsonStoreList], {
		
		
		onComplete:function(){
			this.inherited(arguments);
			var parentView=viewRegistry.getEnclosingView(this.domNode);
			//手动控制push的显示与隐藏，防止其他view页面也出现push提示信息
			topic.publish('/mui/list/pushDomHide',parentView);
		},
		
		//重写下拉刷新事件
		handleOnPush: function(widget, handle) {
			var parentView=viewRegistry.getEnclosingView(this.domNode);
			if(parentView.isVisible() && !this._loadOver){
				topic.publish('/mui/list/pushDomShow',parentView);
				this.loadMore(handle);
			}
			if (handle)
				handle.done(this);
		},
		
		startup:function(){
			this.inherited(arguments);
		}
		
		
	});
});
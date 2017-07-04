define([
    "dojo/_base/declare",
    "dojo/topic",
	"mui/list/JsonStoreList"
	], function(declare,topic, JsonStoreList) {
	
	return declare("km.imeeting.list.FeedbackJsonStoreList", [JsonStoreList], {
		
		
		onComplete:function(){
			this.inherited(arguments);
			var parentView=this.getParent();
			//手动控制push的显示与隐藏，防止其他view页面也出现push提示信息
			topic.publish('/mui/list/pushDomHide',parentView);
		},
		
		//重写下拉刷新事件
		handleOnPush: function(widget, handle) {
			var parentView=this.getParent();
			if(parentView.isVisible()){
				if(!this._loadOver){
					topic.publish('/mui/list/pushDomShow',parentView);
					this.loadMore(handle);
				}
			}
			if (handle)
				handle.done(this);
		},
		
		//暂时没在dojo找到对应的api
		_setUrlParameter:function(url, param, value){
			var re = new RegExp();
			re.compile("([\\?&]"+param+"=)[^&]*", "i");
			if(value==null){
				if(re.test(url)){
					url = url.replace(re, "");
				}
			}else{
				value = encodeURIComponent(value);
				if(re.test(url)){
					url = url.replace(re, "$1"+value);
				}else{
					url += (url.indexOf("?")==-1?"?":"&") + param + "=" + value;
				}
			}
			if(url.charAt(url.length-1)=="?")
				url = url.substring(0, url.length-1);
			return url;
		},
		
		startup:function(){
			this.inherited(arguments);
			this.subscribe('/km/imeeting/onFeedbackCriteria', 'onFeedbackCriteria');
		},
		
		//回执单筛选
		onFeedbackCriteria:function(widget){
			criteriaType=widget.criteriaType || "";
			this.url = this._setUrlParameter(this.url,"criteriaType",criteriaType);
			this.reload();
		},
		
	});
});
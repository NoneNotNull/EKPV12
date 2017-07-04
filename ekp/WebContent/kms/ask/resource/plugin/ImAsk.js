define(function(require, exports, module) { 
	
	var $ = require("lui/jquery");
	var strutil = require('lui/util/str');
	var env = require("lui/util/env");
	function ImAsk(config) {
		if(!config)
			 config = {};
		this.contextPath = config.contextPath || "";
		this.href = "/kms/ask/kms_ask_topic/kmsAskTopic.do?method=add&fdPosterType=3&fdPosterTypeListId=";
	}
	//show事件,___params为communicate的参数
	ImAsk.prototype.onShow =  function ($content, ___params) {
		
	};
	
	ImAsk.prototype.onClick = function ($content, ___params) {
		if(___params.personId) {
			var url = this.contextPath ? this.contextPath : "" + this.href + ___params.personId
			window.open(env.fn.formatUrl(url), "_blank");
		}
	};
	module.exports = ImAsk;
	
});
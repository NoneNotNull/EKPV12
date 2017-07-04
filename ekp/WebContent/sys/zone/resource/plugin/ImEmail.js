define(function(require, exports, module) { 
	
	var $ = require("lui/jquery");
	var strutil = require('lui/util/str');
	
	function ImEmail(config) {
		this.emailPrefix = "mailto:";
	}
	//show事件,___params为communicate的参数
	ImEmail.prototype.onShow =  function ($content, ___params) {
		
	};
	
	ImEmail.prototype.onClick = function ($content, ___params) {
		if(___params.email) {
			window.open(this.emailPrefix + ___params.email, "_parent");
		}
	};
	module.exports = ImEmail;
	
});
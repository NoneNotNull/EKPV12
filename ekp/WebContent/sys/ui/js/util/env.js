define( function(require, exports, module) {
	var fn = function(){
		this.config = null;
	};
	fn.prototype.getConfig = function() {
		if(this.config == null){
			return seajs.data.env;
		}else{
			return this.config;
		}
	};
	fn.prototype.formatUrl = function(url) {
		if(url==null){
			return "";
		}
		if (url.substring(0, 1) == '/') {
			return this.getConfig().contextPath + url;
		} else {
			return url;
		}
	};
	fn.prototype.formatText = function(str) {
		if (str==null || str.length == 0)
			return "";
		return str.replace(/&/g, "&gt;")
			.replace(/</g, "&lt;")
			.replace(/>/g, "&gt;")
			.replace(/ /g, "&nbsp;")
			.replace(/\'/g,"&#39;")
			.replace(/\"/g, "&quot;")
			.replace(/\n/g, "<br>");
	};
	fn.prototype.parseDate = function(str, format){
		var _format = format || this.getConfig().pattern.datetime;
		var result=new Date();
		if(/(y+)/.test(_format))
			result.setFullYear(str.substring(_format.indexOf(RegExp.$1),_format.indexOf(RegExp.$1)+RegExp.$1.length));
		if(/(M+)/.test(_format))
			result.setMonth(parseInt(str.substring(_format.indexOf(RegExp.$1),_format.indexOf(RegExp.$1)+RegExp.$1.length),10)-1);
		if(/(d+)/.test(_format))
			result.setDate(str.substring(_format.indexOf(RegExp.$1),_format.indexOf(RegExp.$1)+RegExp.$1.length));
		if(/(h+)/.test(_format))
			result.setHours(str.substring(_format.indexOf(RegExp.$1),_format.indexOf(RegExp.$1)+RegExp.$1.length));
		if(/(m+)/.test(_format))
			result.setMinutes(str.substring(_format.indexOf(RegExp.$1),_format.indexOf(RegExp.$1)+RegExp.$1.length));
		if(/(s+)/.test(_format))
			result.setSeconds(str.substring(_format.indexOf(RegExp.$1),_format.indexOf(RegExp.$1)+RegExp.$1.length));
		if(/(S+)/.test(_format))
			result.setMilliseconds(str.substring(_format.indexOf(RegExp.$1),_format.indexOf(RegExp.$1)+RegExp.$1.length));
		return result;
	};
	fn.prototype.variableResolver = function(str, data) {
		 //aaa!{bb}asdf!{cc},正则查找替换!{}之间的值 
		 function extend(destination, source) {
				for (var property in source)
				  destination[property] = source[property];
				return destination;
		 }
		 data = extend(data,this.getConfig().config);
	     return str.replace(/\!\{([\w\.]*)\}/gi, function (_var, _key) {
	          var value = data[_key];  
	          return (value === null || value === undefined) ? "" : value;  
	     });
	};
	module.exports = {
		fn : new fn(),
		fnclass : fn,
		win : window
	};
});
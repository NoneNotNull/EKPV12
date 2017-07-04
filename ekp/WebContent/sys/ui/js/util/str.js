
define(function(require, exports, module) {
	exports.decodeHTML = function(str){
		return str.replace(/&quot;/g, '"')
           .replace(/&gt;/g, '>')
           .replace(/&lt;/g, '<')
           .replace(/&amp;/g, '&');
    };
    exports.encodeHTML = function(str){ 
		return str.replace(/&/g,"&amp;")
			.replace(/</g,"&lt;")
			.replace(/>/g,"&gt;")
			.replace(/\"/g,"&quot;");
	};
    exports.toJSON = function(str){
		return (new Function("return (" + str + ");"))();
	};
	exports.toJson = exports.toJSON;
	
	exports.upperFirst = function(str) {
		return str.charAt(0).toUpperCase() + str.substring(1);
	};
	exports.variableResolver = function(str, data) {  
		 //aaa!{bb}asdf!{cc},正则查找替换!{}之间的值 
		 function extend(destination, source) {
				for (var property in source)
				  destination[property] = source[property];
				return destination;
		 }
		 data = extend(data,seajs.data.env.config);
	     return str.replace(/\!\{([\w\.]*)\}/gi, function (_var, _key) {
	          var value = data[_key];  
	          return (value === null || value === undefined) ? "" : value;  
	     });
	}; 
	exports.errorMessage = function(str,url,num){
		num = num || 0;
		return str.replace(/\), <anonymous>:([0-9]+):([0-9]+)\)/g, function (_var, _row, _col) {
	          return _var + "\n <span style='color:red'><b>"+(url ? url : "")+",行:"+(parseInt(_row)+parseInt(num))+",列:"+_col+" 出错了</b></span> ";  
	    }).replace(/(\r|\n)/g,"<br>");
	};
	exports.urlParam = function(qstr, name) {
		var pre = name + "=";
		var start, end, changed = true;
		if ((start = qstr.indexOf(pre)) > -1) {
			end = qstr.indexOf('&');
			if (end < 0)
				end = qstr.length;
			return qstr.substring(start + pre.length, end);
		}
		return null;
	};
	
	exports.textEllipsis = function(str, num) {
		if (str) {
			if (str.length * 2 <= num)
				return str;
			var rtnLength = 0;
			for (var i = 0; i < str.length; i++) {
				if (Math.abs(str.charCodeAt(i)) > 200)
					rtnLength = rtnLength + 2;
				else
					rtnLength++;
				if (rtnLength > num)
					return str.substring(0, i)
							+ (rtnLength % 2 == 0 ? ".." : "...");
			}
			return str;
		}
	}	
});
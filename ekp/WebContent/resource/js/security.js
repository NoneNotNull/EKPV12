/*压缩类型：标准*/
/*******************************************************************************
 * JS文件说明： 本JS文件中的函数不提供给普通模块调用。 本JS文件提供了对某个字段加密或对某个字段Base64的处理
 * 
 * 作者：叶中奇 版本：1.0 2006-4-3
 ******************************************************************************/
Com_RegisterFile("security.js");
Com_IncludeFile("des.js");
Com_IncludeFile("base64.js");
document.writeln("<script src='"+Com_Parameter.ResPath+"js/session.jsp'></script>");

var DESKEY = {
	toHexString : function(str){
		var temp = "";
		for(i=0;i<str.length;i++){
			temp += str.charCodeAt(i).toString(16);
		}
		return temp;
	},
	get: function(){
		var str = getSessionId();
		if (str.length < 16) {
			str += "abcdefghijklmnopqrstuvwxyz";
		}
		str = str.toUpperCase();
		var key = {};
		key.key = DESKEY.toHexString(str.substring(0, 8)); 
		key.iv = DESKEY.toHexString(str.substring(8, 16)); 
		return key;
	},
	getCookie : function (c_name){
		if (document.cookie.length>0) {
			var cookies = document.cookie.split(";");
			for(i = 0; i < cookies.length; i++) {
				 var xc = cookies[i];
				 var cn = xc.substring(0, xc.indexOf("=")).toUpperCase(); 
				  cn = cn.replace(/^\s*/,"").replace(/\s*$/,"");  
				 if (cn == c_name) {
					 return unescape(xc.substring(xc.indexOf("=") + 1, xc.length));				      
				 }
			}
		}
		return "";
	}
};
function base64Convert(){
	//BASE64 => 424153453634
	return "\u4241\u5345\u3634{"+ Base64.encode(arguments[0])+"}";
}
function isMultipartForm(xForm){
	//alert(xForm)
	if(xForm == null){
		xForm = document.forms[0];
	}
	//alert(xForm.encoding);
	if(xForm != null){
		if(xForm.encoding == "multipart/form-data"){
			return true;
		}
	}
	return false;
}
function desEncrypt(value,xForm) {
	if(isMultipartForm(xForm)){
		return value;
	}else{
		var keyObj = DESKEY.get(); 
		var key = CryptoJS.enc.Hex.parse(keyObj.key);
		var iv = CryptoJS.enc.Hex.parse(keyObj.iv);
		var value = CryptoJS.DES.encrypt(value, key, {
			iv : iv
		});
		//DES ME => 444553204d45
		return "\u4445\u5320\u4d45" + value;
	}
}
function base64Encode(str,xForm) {
	if(isMultipartForm(xForm)){
		return str;
	}else{
		var val = str;
		/*
		var patterns = getRejectPatterns();
		for (var i = 0; i < patterns.length; i++) {
			str = str.replace(patterns[i],base64Convert);
		}
		str = str.replace(/<script[^>]*>[\s\S]*?<\/script>/gi,base64Convert);
		str = str.replace(/<[\s]*iframe[^>]*>[\s\S]*?<[\s]*\/[\s]*iframe[\s]*>/gi,base64Convert);
		str = str.replace(/<[\s]*iframe[^>]*\/[\s]*>/gi,base64Convert);
		*/
		if(str != null && str.length > 0)
			str = base64Convert(str);
		if(val != str){
			//FIX ME => 464958204d45
			val = "\u4649\u5820\u4d45" + str;
		}
		return val;
	}
}

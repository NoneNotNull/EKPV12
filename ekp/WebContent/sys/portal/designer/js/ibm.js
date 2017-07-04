String.prototype.startsWith = function (substring) {
    var reg = new RegExp("^" + substring);
    return reg.test(this);
}; 
String.prototype.endsWith = function (substring) {
    var reg = new RegExp(substring + "$");
    return reg.test(this);
};
function ibm_portal(html,urlPrefix,contextPath){
	/*
	if(urlPrefix.endsWith("/")){
		urlPrefix = urlPrefix.substr(0,urlPrefix.length-1);
	}
	var reg = new RegExp("src='"+contextPath+"/","g");
	var str = html.replace(reg,"src='"+urlPrefix+"/");
	
	reg = new RegExp("\"href\": \""+contextPath+"/","g");
	str = str.replace(reg,"\"href\": \""+urlPrefix+"/");
	
	str = str.replace(/"url":"\//g,"\"url\":\""+urlPrefix+"/");
	*/
	var str = html;
	str = str.replace(/source!AjaxJson/g,"source!AjaxJsonp");
	str = str.replace(/source!AjaxXml/g,"source!AjaxJsonp");
	str = str.replace(/source!AjaxText/g,"source!AjaxJsonpText");
	return str;
}
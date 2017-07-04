<%@ page language="java" contentType="javascript/x-javascript" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>

<html:javascript dynamicJavascript="false" staticJavascript="true"/>

function Validate_Number(value){
	var re = /[^\d\.\-]/;
	if(re.test(value))
		return false;
	if(value.lastIndexOf("-")>0)
		return false;
	if(value.split(".").length>2)
		return false;
	return true;
}
function Validate_Integer(value){
	return isAllDigits(value) && !isNaN(parseInt(value));
}
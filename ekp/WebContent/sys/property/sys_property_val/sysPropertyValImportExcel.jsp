<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/kms/assistant/kms_property_val/kmsPropertyVal.do"> 
 <iframe id="importExcel" src="" width="500" height="300" scrolling="auto" marginheight="0" frameborder="0">
</iframe>
<script type="text/javascript">
window.onload = function(){
	var obj = window.dialogArguments
	var frameObj =  document.getElementById("importExcel");
	var url="<c:url value='/kms/assistant/kms_property_val/kmsPropertyValAddExcel.jsp' />";
	//url = Com_SetUrlParameter(url, "fdParentId", obj.value);
	frameObj.src = url;
}
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>

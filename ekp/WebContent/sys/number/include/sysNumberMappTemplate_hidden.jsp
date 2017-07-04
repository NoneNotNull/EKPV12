<%--
--<%@ page language="java" contentType="text/html; charset=UTF-8"
--	pageEncoding="UTF-8"%>
 --%>
<%@ page buffer="16kb" %>
<%@ include file="/resource/jsp/common.jsp"%>
<%-- <%@ include file="/resource/jsp/edit_top.jsp"%>--%>
<c:set var="mainModelForm" value="${requestScope[param.formName]}" scope="request"></c:set>
<c:set var="sysNumberMainMappForm" value="${mainModelForm.sysNumberMainMappForm}" scope="request"/>
<c:set var="sysNumberMainMappPrefix" value="sysNumberMainMappForm." scope="request"/>

<script>
Com_IncludeFile("doclist.js|dialog.js|calendar.js|optbar.js|jquery.js|json2.js|formula.js|eventbus.js|xform.js");
</script>
<%--<table width="100%"> --%>

	<html:hidden property="${sysNumberMainMappPrefix}fdNumberId" value="1"/>
	<html:hidden property="${sysNumberMainMappPrefix}fdMainModelName" value="${param.modelName}"/>
	<html:hidden property="${sysNumberMainMappPrefix}fdContent" value=""/>
<%-- </table>--%>


<script type="text/javascript">
	
	Com_Parameter.event["submit"][Com_Parameter.event["submit"].length] = function(){
		
		var mName=document.getElementsByName("${sysNumberMainMappPrefix}fdModelName")[0];
		if(mName=="")
			{
			mName.value="${param.modelName}";
			}
		 
		document.getElementsByName("${sysNumberMainMappPrefix}fdNumberId")[0].value="1";
		
		return true;
	};
	
	
</script>

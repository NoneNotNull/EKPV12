<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>

<c:set var="lbpmContentTitle" scope="page"><kmss:message 
	key="${not empty param.messageKey ? param.messageKey : 'sys-lbpmservice-support:lbpmTemplate.tab.label'}" 
/></c:set>
<ui:content title="${lbpmContentTitle }">
    <ui:event event="show">
		$('#WF_TR_ID_${param.fdKey }').show();
		this.element.find("*[onresize]").each(function(){
			var funStr = this.getAttribute("onresize");
			if(funStr!=null && funStr!=""){
				var tmpFunc = new Function(funStr);
				tmpFunc.call();
			}
		});
	</ui:event>
   	<table class="tb_simple" width=100%>
   	<%@ include file="/sys/lbpmservice/include/sysLbpmTemplate_view.jsp" %>
	</table>
</ui:content>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%-- 权限 --%>
<div class="lui_kmaps_catelog">
	<div class="lui_kmaps_title">
		权限
	</div>
</div>
<div class="lui_kmaps_content">
	<table class="tb_normal" width=100%>
		<%@ include file="/sys/right/right_edit.jsp"%>
	</table>
</div>
<%-- 流程 --%>
<div class="lui_kmaps_catelog">
	<div class="lui_kmaps_title">
		流程
	</div>
</div>
<div class="lui_kmaps_content">
	<c:set var="sysWfBusinessForm" value="${requestScope[param.formName]}" />
	<c:set var="lbpmProcessForm" value="${sysWfBusinessForm.sysWfBusinessForm.internalForm}" />
	<c:if test="${sysWfBusinessForm.sysWfBusinessForm!=null}">
	<ui:event event="show">
	//if(!Com_Parameter.IE){
		this.element.find("*[onresize]").each(function(){
			var funStr = this.getAttribute("onresize");
			if(funStr!=null && funStr!=""){
				var tmpFunc = new Function(funStr);
				tmpFunc.call();
			}
		});
	//}
	</ui:event>
	<%@include file="/sys/lbpmservice/import/sysLbpmProcess_edit.jsp"%>
	</c:if>
</div>

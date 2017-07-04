<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="sysWfBusinessForm" value="${requestScope[param.formName]}" />
<c:set var="lbpmProcessForm" value="${sysWfBusinessForm.sysWfBusinessForm.internalForm}" />
<c:set var="resize_prefix" value="_" scope="request" />
<c:if test="${sysWfBusinessForm.sysWfBusinessForm!=null}">
	<ui:content id="process_review_tabcontent" 
		title="${ lfn:message('sys-lbpmservice:lbpm.tab.label') }" 
		expand="${sysWfBusinessForm.docStatus == '20' or sysWfBusinessForm.docStatus == '11' or param.isExpand == 'true'?'true':'false'}">
	<ui:event event="show">
		if (this.isBindOnResize) {
			return;
		}
		var element = this.element;
		function onResize() {
			element.find("*[_onresize]").each(function(){
				var elem = $(this);
				var funStr = elem.attr("_onresize");
				var show = elem.closest('tr').is(":visible");
				var init = elem.attr("data-init-resize");
				if(funStr!=null && funStr!="" && show && init == null){
					elem.attr("data-init-resize", 'true');
					var tmpFunc = new Function(funStr);
					tmpFunc.call();
				}
			});
		}
		this.isBindOnResize = true;
		onResize();
		element.click(onResize);
	</ui:event>
	<%@ include file="../common/process_edit.jsp"%>
	</ui:content>
</c:if>
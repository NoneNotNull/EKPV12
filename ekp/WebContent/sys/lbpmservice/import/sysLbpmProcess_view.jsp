<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="sysWfBusinessForm" value="${requestScope[param.formName]}" />
<c:set var="lbpmProcessForm" value="${sysWfBusinessForm.sysWfBusinessForm.internalForm}" />
<c:set var="resize_prefix" value="_" scope="request" />
<c:if test="${sysWfBusinessForm.sysWfBusinessForm!=null}">
	<c:if test="${param.isSimpleWorkflow != 'true' }">
	<c:choose>
		<c:when test="${empty param.isExpand and (sysWfBusinessForm.docStatus == '20' or sysWfBusinessForm.docStatus == '11')}">
		    <c:set var="expand" value="true"></c:set>
		</c:when>
		<c:otherwise>
		  <c:set var="expand" value="${param.isExpand}"></c:set>
		</c:otherwise>
	</c:choose>
	<ui:content id="process_review_tabcontent" 
		title="${ lfn:message('sys-lbpmservice:lbpm.tab.label') }" 
		expand="${expand}">
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
	<%@ include file="../common/process_view.jsp"%>
	</ui:content>
	</c:if>
	
	<c:if test="${param.isSimpleWorkflow == 'true' }">
	<%@ include file="../common/process_view.jsp"%>
	</c:if>
</c:if>
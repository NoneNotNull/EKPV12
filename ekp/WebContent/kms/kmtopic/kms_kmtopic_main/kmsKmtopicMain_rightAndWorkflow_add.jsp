<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%-- 权限 --%>
<h2 class="lui_kmtopic_baseinfo_m">
	${ lfn:message('kms-kmtopic:kmsKmtopicMain.form.tab.right.label') }
</h2>
<div class="lui_kmtopic_content">
	<table class="tb_normal" width=100%>
		<%@ include file="/sys/right/right_edit.jsp"%>
	</table>
</div>
<%-- 流程 --%>
<h2 class="lui_kmtopic_baseinfo_m">
	${ lfn:message('kms-kmtopic:kmsKmtopicMain.process') }
</h2>
<div class="lui_kmtopic_content">
	<c:set var="sysWfBusinessForm" value="${requestScope[param.formName]}" />
	<c:set var="lbpmProcessForm" value="${sysWfBusinessForm.sysWfBusinessForm.internalForm}" />
	<c:set var="resize_prefix" value="_" scope="request" />
	<c:if test="${sysWfBusinessForm.sysWfBusinessForm!=null}">
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
	<%@ include file="/sys/lbpmservice/common/process_edit.jsp"%>
	</c:if>
</div>
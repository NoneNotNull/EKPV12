<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.dialog">
<template:replace name="head">
<%@ include file="/sys/lbpmservice/include/sysLbpmProcessConstant.jsp"%>
<script type="text/javascript">
	Com_IncludeFile("data.js|dialog.js", null, "js");
	lbpm.workitem.constant.COMMONPAGEFIRSTOPTION = '<bean:message key="page.firstOption" />';
</script>
<script type="text/javascript" src="${pageContext.request.contextPath}/sys/lbpmservice/workitem/workitem_common_usage.js"></script>
<script>
	//获取list页面选择的流程记录的id
	function initDocIds() {
		var values = [];
		var select = parent.document.getElementsByName("List_Selected");
		for ( var i = 0; i < select.length; i++) {
			if (select[i].checked) {
				values.push(select[i].value);
			}
		}
		$("input[name='docIds']").val(values);
	}
	$(function() {
		initDocIds();
	});
</script>
</template:replace>
<template:replace name="content">
<form
	action="${pageContext.request.contextPath}/sys/lbpmmonitor/sys_lbpmmonitor_flow/SysLbpmMonitorFlow.do"
	method="post">
	<ui:toolbar layout="sys.ui.toolbar.float">
		<ui:button text="${ lfn:message('button.update') }" styleClass="lui_toolbar_btn_gray" onclick="document.forms[0].submit();">
		</ui:button>
		<ui:button text="${ lfn:message('button.close') }" styleClass="lui_toolbar_btn_gray" onclick="Com_CloseWindow();">
		</ui:button>
	</ui:toolbar>
	<p>&nbsp;</p>
	<div class="lui_form_content_frame">
		<table class="tb_normal" width=95%>
			<tr>
				<td class="td_normal_title" width="15%"><bean:message
						bundle="sys-lbpmservice" key="lbpmNode.createDraft.commonUsages" />
				</td>
				<td colspan="3"><select name="commonUsages"
					onchange="lbpm.globals.setUsages(this);"
					style="width: 92px; overflow-x: hidden; padding-left: 0px;">
						<option value="">
							<bean:message key="page.firstOption" />
						</option>
				</select> <a href="#"
					onclick="Com_EventPreventDefault();lbpm.globals.openDefiniateUsageWindow();">
						<bean:message bundle="sys-lbpmservice"
							key="lbpmNode.createDraft.commonUsages.definite" />
				</a></td>
			</tr>
			<tr>
				<td class="td_normal_title" width="15%"><bean:message
						bundle="sys-lbpmservice" key="lbpmNode.createDraft.opinion" /></td>
				<td colspan="3">
					<table width=100% border=0 class="tb_noborder">
						<tr>
							<td><textarea name="fdUsageContent" class="inputMul"
									style="width: 100%;" alertText="" key="auditNode"></textarea></td>
						</tr>
						<tr>
							<td><label id="currentNodeDescription"></label></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td class="td_normal_title" width="15%"><bean:message
						bundle="sys-lbpmservice"
						key="lbpmNode.processingNode.operationMethods" /></td>
				<td colspan="3"><input type="radio" name="operationType"
					value="admin_retry" checked readOnly="true" />
				<bean:message bundle="sys-lbpmservice"
						key="lbpm.operation.retryErrorQueue" /></td>
			</tr>
			<tr>
				<td id="rerunIfErrorTDTitle" class="td_normal_title" width="15%">
					<kmss:message
						key="sys-lbpmservice-operation-admin:lbpmOperations.fdOperType.addition.rerunEventTitle" />
				</td>
				<td id="rerunIfErrorTDContent" colspan="3"><label
					id="rerunIfErrorLabel"> <input type="checkbox"
						id="rerunIfError" value="true"> <kmss:message
							key="sys-lbpmservice-operation-admin:lbpmOperations.fdOperType.addition.rerunEventFlag" />
				</label></td>
			</tr>
		</table>
	</div>

	<input type="hidden" name="docIds" value="" /> 
	<input type="hidden" name="method" value="batchPrivil" />
</form>
</template:replace>
</template:include>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script>
Com_IncludeFile("dialog.js");
</script>
<tr LKS_LabelName="<bean:message bundle="sys-workflow" key="sysWfApprovalType"/>">
	<td>
	<table class="tb_normal" width=100%>
		<tr>
			<td class="td_normal_title" width="15%">
				<bean:message bundle="sys-workflow" key="sysWfApprovalType" />
			</td>
			<td width="85%">
				<input name="ext_approvalTypeName" class="inputsgl" style="width: 85%" readonly>
				<input name="ext_approvalType" type="hidden">
				<a href="#" onclick="Dialog_Tree(false,'ext_approvalType','ext_approvalTypeName',';','sysWfApprovalTypeService&parentId=!{value}&modelName=${param.modelName}','<bean:message bundle="sys-workflow" key="sysWfApprovalType"/>');">
					<kmss:message key="button.select" />
				</a>
			</td>
		</tr>
	</table>
	</td>
</tr>
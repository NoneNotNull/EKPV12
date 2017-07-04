<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<div id="optBarDiv">
	<kmss:auth requestURL="/kms/expert/kms_expert_type/kmsExpertType.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button" value="<bean:message key="button.edit"/>" onclick="Com_OpenWindow('kmsExpertType.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/kms/expert/kms_expert_type/kmsExpertType.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button" value="<bean:message key="button.delete"/>" onclick="if(!confirmDelete())return;Com_OpenWindow('kmsExpertType.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
<p class="txttitle">
	<bean:message bundle="kms-expert" key="table.kmsExpertType" />
</p>
<center>
	<table class="tb_normal" width=95%>
		<html:hidden name="kmsExpertTypeForm" property="fdId" />
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="kms-expert" key="table.kmsExpertType" />
				.
				<bean:message bundle="kms-expert" key="kmsExpertType.fdId" />
			</td>
			<td width=35%>
				<logic:present name="kmsExpertTypeForm" property="kmsExpertType">
					<bean:write name="kmsExpertTypeForm" property="kmsExpertType.fdId" />
				</logic:present>
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="kms-expert" key="kmsExpertType.fdAreaName" />
			</td>
			<td width=35%>
				<bean:write name="kmsExpertTypeForm" property="fdAreaName" />
			</td>
		</tr>		
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="kms-expert" key="kmsExpertType.fdAllowExpertAnswer" />
			</td>
			<td width=85%>
				<sunbor:enumsShow value="${kmsExpertTypeForm.fdAllowExpertAnswer}" enumsType="common_yesno"/>	
			</td>
			</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="kms-expert" key="kmsExpertType.fdDesciption" />
			</td>
			<td width=35%>
				<bean:write name="kmsExpertTypeForm" property="fdDesciption" />
			</td>
			<td class="td_normal_title" width=15%>
				&nbsp;
			</td>
			<td width=35%>
				&nbsp;
			</td>
		</tr>
	</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>

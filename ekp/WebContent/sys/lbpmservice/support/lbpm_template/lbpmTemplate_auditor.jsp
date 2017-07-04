<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script type="text/javascript">
Com_IncludeFile("dialog.js|optbar.js");
</script>
<kmss:windowTitle moduleKey="sys-lbpmservice-support:table.lbpmTemplate" subjectKey="sys-lbpmservice-support:lbpmTemplate.updateAuditor.subject" />
<html:form action="/sys/lbpmservice/support/lbpm_template/lbpmTemplate.do?fdModelName=${param.fdModelName}&fdKey=${param.fdKey}">
<div id="optBarDiv">
	<input type=button value="<bean:message key="button.update"/>"
			onclick="if(!confirmUpdateAuditor())return;Com_Submit(document.lbpmTemplateForm, 'doUpdateAuditor');">
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message key="lbpmTemplate.updateAuditor.subject" bundle="sys-lbpmservice-support"/></p>
<center>
<c:if test="${not empty templateList}">
<%-- 业务模板、简单分类、全局分类 替换处理人 --%>
<div <c:if test="${hasCommonTemplate == false}">style="display:none;"</c:if>>
<p>
<bean:message key="lbpmTemplate.updateAuditor.help" bundle="sys-lbpmservice-support"/>
</p>
<table class="tb_normal" width=95%>
	<tr class="tr_normal_title">
		<td width="10pt">
			<input type="checkbox" name="List_Tongle" checked onclick="tongleSelect();">
		</td>
		<td width="40pt">
			<bean:message key="page.serial"/>
		</td>
		<td>
			<bean:message key="lbpmTemplate.updateAuditor.template" bundle="sys-lbpmservice-support"/>
		</td>
		<td>
			<bean:message key="lbpmTemplate.updateAuditor.common" bundle="sys-lbpmservice-support"/>
		</td>
		<td width="120pt" class="td_normal_title">
			<bean:message key="lbpmTemplate.fdType" bundle="sys-lbpmservice-support"/>
		</td>
	</tr>
	<c:forEach items="${templateList}" var="template" varStatus="vstatus">
		<tr>
			<td>
				<input type="checkbox" name="List_Selected" checked value="${template.id}" />
			</td>
			<td>
				${vstatus.index+1}
			</td>
			<td>
				<c:out value="${template.modelSubject}" />
			</td>
			<td>
				<c:out value="${template.comTempName}" />
			</td>
			<td>
				<c:if test="${template.type == '1'}">
					<bean:message key="lbpmTemplate.fdType.default" bundle="sys-lbpmservice-support"/>
				</c:if>
				<c:if test="${template.type == '2' }">
					<bean:message key="lbpmTemplate.fdType.other" bundle="sys-lbpmservice-support"/>
				</c:if>
				<c:if test="${template.type == '3' }">
					<bean:message key="lbpmTemplate.fdType.define" bundle="sys-lbpmservice-support"/>
				</c:if>
			</td>
		</tr>
	</c:forEach>
</table>
</div>
</c:if>
<c:if test="${not empty templateIds}">
<%-- 通用流程模板 替换处理人 --%>
<c:forEach items="${templateIds}" var="templateId">
<input type="checkbox" name="List_Selected" checked value="${templateId}" style="display:none" />
</c:forEach>
</c:if>
<table class="tb_normal" width=350 style="margin-top: 30px;">
	<tr>
		<td class="td_normal_title">
			<bean:message key="lbpmTemplate.updateAuditor.srcAuditor" bundle="sys-lbpmservice-support"/>
		</td>
		<td>
		<input type="hidden" name="srcOrgElemId">
		<input type="text" name="srcOrgElemName" class="inputSgl" style="width:200px" readonly validate="required" 
			title="<bean:message key="lbpmTemplate.updateAuditor.srcAuditor" bundle="sys-lbpmservice-support"/>"
			subject="<bean:message key="lbpmTemplate.updateAuditor.srcAuditor" bundle="sys-lbpmservice-support"/>">
		<span class="txtstrong">*</span>
		<a href="javascript:void(0);" 
			onclick="Dialog_Address(false, 'srcOrgElemId','srcOrgElemName', ';', ORG_TYPE_POSTORPERSON, null, null, null, true);">
			<bean:message key="dialog.selectOrg"/></a>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title">
			<bean:message key="lbpmTemplate.updateAuditor.targetAuditor" bundle="sys-lbpmservice-support"/>
		</td>
		<td>
		<input type="hidden" name="targetOrgElemId">
		<input type="text" name="targetOrgElemName" class="inputSgl" style="width:200px" readonly
			title="<bean:message key="lbpmTemplate.updateAuditor.targetAuditor" bundle="sys-lbpmservice-support"/>">
		<a href="javascript:void(0);" 
			onclick="Dialog_Address(false, 'targetOrgElemId','targetOrgElemName', ';', ORG_TYPE_POSTORPERSON, null, null, null, false);">
			<bean:message key="dialog.selectOrg"/></a>
		</td>
	</tr>
</table>
</center>
<script>
$KMSSValidation();
function tongleSelect() {
	var List_Tongle = document.getElementsByName('List_Tongle')[0];
	var List_Selected = document.getElementsByName('List_Selected');
	for (var i = 0; i < List_Selected.length; i ++) {
		List_Selected[i].checked = List_Tongle.checked;
	}
}
function confirmUpdateAuditor() {
	var obj = document.getElementsByName("List_Selected");
	for(var i=0, n=obj.length; i<n; i++) {
		if(obj[i].checked) {
			return true;
		}
	}
	alert('<bean:message key="page.noSelect"/>');
	return false;
}
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>
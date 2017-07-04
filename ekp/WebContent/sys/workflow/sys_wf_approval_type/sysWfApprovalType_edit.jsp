<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/sys/workflow/sys_wf_approval_type/sysWfApprovalType.do" onsubmit="return validateSysWfApprovalTypeForm(this);">
<div id="optBarDiv">
	<c:if test="${sysWfApprovalTypeForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysWfApprovalTypeForm, 'update');">
	</c:if>
	<c:if test="${sysWfApprovalTypeForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.sysWfApprovalTypeForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.sysWfApprovalTypeForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
<html:hidden property="fdId"/>
<html:hidden property="fdCreatorId"/>
<html:hidden property="fdCreatorName"/>
<html:hidden property="fdCreateTime"/>
<c:if test="${sysWfCommonTemplateForm.method_GET=='add'}">
	<html:hidden property="fdModelName" value="${param.fdModelName }"/>
	<html:hidden property="fdKey" value="${param.fdKey }"/>
</c:if>
<c:if test="${sysWfCommonTemplateForm.method_GET=='edit'}">
	<html:hidden property="fdModelName"/>
	<html:hidden property="fdKey"/>
</c:if>
<p class="txttitle"><bean:message  bundle="sys-workflow" key="table.sysWfApprovalType"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-workflow" key="sysWfApprovalType.fdName"/>
		</td><td width=35%>
			<html:text property="fdName" style="width:95%;"/><span class="txtstrong">*</span>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-workflow" key="sysWfApprovalType.fdOrder"/>
		</td><td width=35%>
			<html:text property="fdOrder" style="width:95%;"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-workflow" key="sysWfApprovalType.fdProhibit"/>
		</td><td width=85% colspan=3>
			<label>
			<html:checkbox property="fdProhibitDraftor" value="true"/>
			<bean:message  bundle="sys-workflow" key="sysWfApprovalType.fdProhibit.draftor"/>
			</label>
		</td> 
	</tr>
	<%--tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-workflow" key="sysWfApprovalType.description"/>
		</td><td width=85% colspan=3>
			<li><bean:message  bundle="sys-workflow" key="sysWfApprovalType.description.content.1"/></li>
			<li><bean:message  bundle="sys-workflow" key="sysWfApprovalType.description.content.2"/></li>
		</td>
	</tr--%>
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<html:javascript formName="sysWfApprovalTypeForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/resource/jsp/edit_down.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.lbpmservice.support.util.LbpmTemplateUtil" %>
<%@ include file="/resource/jsp/view_top.jsp"%>
<c:set var="lbpmTemplateForm" value="${lbpmTemplateForm}" />
<c:set var="lbpmTemplateFormPrefix" value="" />
<c:set var="lbpmTemplate_ModelName" value="${lbpmTemplateForm.fdModelName}" />
<c:set var="lbpmTemplate_Key" value="${lbpmTemplateForm.fdKey}" />
<%
	pageContext.setAttribute("lbpmTemplate_MainModelName",
			LbpmTemplateUtil.getMainModelName(
					(String)pageContext.getAttribute("lbpmTemplate_ModelName"),
					(String)pageContext.getAttribute("lbpmTemplate_Key")));
%>
<script>
Com_Parameter.IsAutoTransferPara = true;
function confirmDelete(msg){
	var del = confirm('<bean:message key="page.comfirmDelete"/>');
	return del;
}
</script>
<div id="optBarDiv">
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message  bundle="sys-lbpmservice-support" key="lbpmTemplateChangeHistory.historyVersion"/></p>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.fdType"/>
		</td><td>
		<c:choose>
			<c:when test="${lbpmTemplateForm.fdIsCommon=='true'}">
				<c:if test="${lbpmTemplateForm.fdIsDefault=='true'}">
					<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.fdType.default"/>
				</c:if>
				<c:if test="${lbpmTemplateForm.fdIsDefault=='false'}">
					<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.fdType.other"/>
				</c:if>
			</c:when>
			<c:otherwise>
			<c:if test="${lbpmTemplateForm.fdType=='1'}">
				<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.fdType.default"/>
			</c:if>
			<c:if test="${lbpmTemplateForm.fdType=='2'}">
				<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.fdType.other"/>
			</c:if>
			<c:if test="${lbpmTemplateForm.fdType=='3'}">
				<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.fdType.define"/>
			</c:if>
			</c:otherwise>
		</c:choose>
		</td>
	</tr>
	<c:if test="${lbpmTemplateForm.fdType!='3'}">
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.fdCommon"/>
		</td><td>
			<c:out value="${lbpmTemplateForm.fdName}" />
		</td>
	</tr>
	</c:if>
	<%@ include file="/sys/lbpmservice/support/lbpm_template/lbpmTemplate_sub_view.jsp"%>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
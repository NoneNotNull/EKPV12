<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ page import="com.landray.kmss.sys.lbpmservice.support.util.LbpmTemplateUtil" %>
<%@ include file="/resource/jsp/view_top.jsp"%>
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
	<c:if test="${lbpmTemplateForm.fdIsDefault=='false'}">
		<kmss:auth requestURL="/sys/lbpmservice/support/lbpm_template/lbpmTemplate.do?method=setDefault&fdModelName=${param.fdModelName}&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.fdIsDefault.button"/>"
				onclick="Com_OpenWindow('lbpmTemplate.do?method=setDefault&fdId=${param.fdId}','_self');">
		</kmss:auth>
	</c:if>
	<kmss:auth requestURL="/sys/lbpmservice/support/lbpm_template/lbpmTemplate.do?method=edit&fdId=${param.fdId}&fdModelName=${param.fdModelName}&fdKey=${param.fdKey}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('lbpmTemplate.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/sys/lbpmservice/support/lbpm_template/lbpmTemplate.do?method=delete&fdId=${param.fdId}&fdModelName=${param.fdModelName}&fdKey=${param.fdKey}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('lbpmTemplate.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message bundle="sys-lbpmservice-support" key="table.lbpmTemplate"/></p>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.fdName"/>
		</td><td width="85%" colspan="3">
			<xform:text property="fdName" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.fdIsDefault"/>
		</td><td width="85%" colspan="3">
			<c:choose>
				<c:when test="${lbpmTemplateForm.fdIsDefault=='true'}">
					<bean:message key="message.yes"/>
				</c:when>
				<c:otherwise>
					<bean:message key="message.no"/>
				</c:otherwise>
			</c:choose>
		</td>
	</tr>
	<%@ include file="/sys/lbpmservice/support/lbpm_template/lbpmTemplate_sub_view.jsp"%>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
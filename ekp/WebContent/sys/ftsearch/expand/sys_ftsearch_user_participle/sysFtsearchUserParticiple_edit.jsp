<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/sys/ftsearch/expand/sys_ftsearch_user_participle/sysFtsearchUserParticiple.do">
<div id="optBarDiv">
	<c:if test="${sysFtsearchUserParticipleForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysFtsearchUserParticipleForm, 'update');">
	</c:if>
	<c:if test="${sysFtsearchUserParticipleForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.sysFtsearchUserParticipleForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.sysFtsearchUserParticipleForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="sys-ftsearch-expand" key="table.sysFtsearchUserParticiple"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchUserParticiple.fdParticiple"/>
		</td><td width="35%">
			<xform:text property="fdParticiple" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchUserParticiple.docCreateTime"/>
		</td><td width="35%">
			<xform:datetime property="docCreateTime" showStatus="view" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchUserParticiple.docCreator"/>
		</td><td width="35%">
			<xform:address propertyId="docCreatorId" propertyName="docCreatorName" orgType="ORG_TYPE_PERSON" showStatus="view" />
		</td>
		<td class="td_normal_title" width=15%>&nbsp;</td><td width=35%>&nbsp;</td>
	</tr>
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	$KMSSValidation();
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>
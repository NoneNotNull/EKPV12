<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/sys/ftsearch/expand/t_att_ekp_sys/tattEkpSys.do">
<div id="optBarDiv">
	<c:if test="${tattEkpSysForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.tattEkpSysForm, 'update');">
	</c:if>
	<c:if test="${tattEkpSysForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.tattEkpSysForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.tattEkpSysForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="sys-ftsearch-expand" key="table.tattEkpSys"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-ftsearch-expand" key="tattEkpSys.fdEkpId"/>
		</td><td width="35%">
			<xform:text property="fdEkpId" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-ftsearch-expand" key="tattEkpSys.fdEkpName"/>
		</td><td width="35%">
			<xform:text property="fdEkpName" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-ftsearch-expand" key="tattEkpSys.fdSysName"/>
		</td><td width="35%">
			<xform:text property="fdSysName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-ftsearch-expand" key="tattEkpSys.fdUserId"/>
		</td><td width="35%">
			<xform:text property="fdUserId" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-ftsearch-expand" key="tattEkpSys.fdUserName"/>
		</td><td width="35%">
			<xform:text property="fdUserName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%><bean:message bundle="sys-ftsearch-expand" key="tattEkpSys.fdTypeUser"/></td>
		<td width=35%>
		<sunbor:enums property="fdTypeUser" enumsType="km_type_user" elementType="select" bundle="sys-ftsearch-expand" />
		</td>
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
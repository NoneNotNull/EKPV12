<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/tib/jdbc/tib_jdbc_relation/tibJdbcRelation.do">
<div id="optBarDiv">
	<c:if test="${tibJdbcRelationForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.tibJdbcRelationForm, 'update');">
	</c:if>
	<c:if test="${tibJdbcRelationForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.tibJdbcRelationForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.tibJdbcRelationForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="tib-jdbc" key="table.tibJdbcRelation"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-jdbc" key="tibJdbcRelation.fdUseExplain"/>
		</td><td width="35%">
			<xform:text property="fdUseExplain" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-jdbc" key="tibJdbcRelation.fdSyncType"/>
		</td><td width="35%">
			<xform:textarea property="fdSyncType" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-jdbc" key="tibJdbcRelation.tibJdbcMappCategory"/>
		</td><td width="35%">
			<xform:select property="tibJdbcMappCategoryId">
				<xform:beanDataSource serviceBean="tibJdbcMappManageService" selectBlock="fdId,docSubject" orderBy="" />
			</xform:select>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-jdbc" key="tibJdbcRelation.tibJdbcTaskManage"/>
		</td><td width="35%">
			<xform:select property="tibJdbcTaskManageId">
				<xform:beanDataSource serviceBean="tibJdbcTaskManageService" selectBlock="fdId,fdId" orderBy="" />
			</xform:select>
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
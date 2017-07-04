<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/km/keydata/base/kmKeydataPluginShow.do">
<div id="optBarDiv">
	<c:if test="${kmKeydataPluginShowForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.kmKeydataPluginShowForm, 'update');">
	</c:if>
	<c:if test="${kmKeydataPluginShowForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.kmKeydataPluginShowForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.kmKeydataPluginShowForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="km-keydata-base" key="table.kmKeydataPluginShow"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-base" key="kmKeydataPluginShow.fdName"/>
		</td><td width="35%">
			<xform:text property="fdName" style="width:85%"/>
		</td>
		<!-- 
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-base" key="kmKeydataPluginShow.fdType"/>
		</td><td width="35%">
			<xform:text property="fdType" style="width:85%" />
		</td>
		 -->
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-base" key="kmKeydataPluginShow.fdActionUrl"/>
		</td><td width="35%">
			<xform:text property="fdActionUrl" style="width:85%" showStatus="view"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-base" key="kmKeydataPluginShow.fdIsShow"/>
		</td><td width="35%">
			<xform:radio property="fdIsShow">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:radio>
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
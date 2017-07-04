<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/sys/fans/sys_fans_main/sysFansMain.do">
<div id="optBarDiv">
	<c:if test="${sysFansMainForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysFansMainForm, 'update');">
	</c:if>
	<c:if test="${sysFansMainForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.sysFansMainForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.sysFansMainForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="sys-fans" key="table.sysFansMain"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-fans" key="sysFansMain.fdUserId"/>
		</td><td width="35%">
			<xform:text property="fdUserId" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-fans" key="sysFansMain.fdFollowerId"/>
		</td><td width="35%">
			<xform:text property="fdFollowerId" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-fans" key="sysFansMain.fdFollowTime"/>
		</td><td width="35%">
			<xform:datetime property="fdFollowTime" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-fans" key="sysFansMain.fdRelationType"/>
		</td><td width="35%">
			<xform:text property="fdRelationType" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-fans" key="sysFansMain.fdUserType"/>
		</td><td width="35%">
			<xform:text property="fdUserType" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-fans" key="sysFansMain.fdCanUnfollow"/>
		</td><td width="35%">
			<xform:radio property="fdCanUnfollow">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:radio>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-fans" key="sysFansMain.fdModelName"/>
		</td><td width="35%">
			<xform:text property="fdModelName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>&nbsp;</td><td width=35%>&nbsp;</td>
	</tr>
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	Com_IncludeFile("calendar.js");
	$KMSSValidation();
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<div id="optBarDiv">
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="kms-log" key="table.kmsLogApp"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-log" key="kmsLogApp.fdSubject"/>
		</td><td width="35%">
			<xform:text property="fdSubject" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-log" key="kmsLogApp.fdCreateTime"/>
		</td><td width="35%">
			<xform:datetime property="fdCreateTime" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-log" key="kmsLogApp.fdTargetId"/>
		</td><td width="35%">
			<xform:text property="fdTargetId" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-log" key="kmsLogApp.modelName"/>
		</td><td width="35%">
			<xform:text property="modelName" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-log" key="kmsLogApp.fdIp"/>
		</td><td width="35%">
			<xform:text property="fdIp" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-log" key="kmsLogApp.fdParam"/>
		</td><td width="35%">
			<xform:text property="fdParam" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-log" key="kmsLogApp.fdOperator"/>
		</td><td width="35%">
			<c:out value="${kmsLogAppForm.fdOperatorName}" />
		</td>
		<td class="td_normal_title" width=15%>&nbsp;</td><td width=35%>&nbsp;</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
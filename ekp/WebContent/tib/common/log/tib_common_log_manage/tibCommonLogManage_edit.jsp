<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/tib/common/log/tib_common_log_manage/tibCommonLogManage.do">
<div id="optBarDiv">
	<c:if test="${tibCommonLogManageForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="waitSubmit('update');">
	</c:if>
	<c:if test="${tibCommonLogManageForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="waitSubmit('add');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="waitSubmit('saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="tib-common-log" key="table.tibCommonLogManage"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-log" key="tibCommonLogManage.fdLogTime"/>
		</td><td colspan="3" width="85%">
			<xform:text property="fdLogTime" onValueChange="fdLogTimeChecked();"/>
			<bean:message bundle="tib-common-log" key="tibCommonLogManage.day"/>
			<!-- 操作日志保存时间  -->
			<jsp:include page="../../resource/jsp/checkedValue.jsp">
				<jsp:param value="fdLogTimeHiddenId" name="hiddenId"/>
				<jsp:param value="fdLogTimeTextId" name="textId"/>
			</jsp:include>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-log" key="tibCommonLogManage.fdLogLastTime"/>
		</td><td colspan="3" width="85%">
			<xform:text property="fdLogLastTime"  onValueChange="fdLogLastTimeChecked();"/>
			<bean:message bundle="tib-common-log" key="tibCommonLogManage.day"/>
			<!-- 日志归档时间  -->
			<jsp:include page="../../resource/jsp/checkedValue.jsp">
				<jsp:param value="fdLogLastTimeHiddenId" name="hiddenId"/>
				<jsp:param value="fdLogLastTimeTextId" name="textId"/>
			</jsp:include>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-log" key="tibCommonLogManage.fdLogType"/>
		</td><td colspan="3" width="85%">
			<xform:radio property="fdLogType">
				<xform:enumsDataSource enumsType="fd_log_type"/>
			</xform:radio>
		</td>
	</tr>
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	Com_IncludeFile("calendar.js");
	$KMSSValidation();
	function waitSubmit(method) {
		if (fdLogTimeChecked() && fdLogLastTimeChecked()){
			Com_Submit(document.tibCommonLogManageForm, method);
		}
	}
	
	var reg = /^[0-9]+$/;
	function fdLogTimeChecked() {
		var fdLogTime= document.getElementsByName("fdLogTime")[0].value;//document.getElementById("fdLogTime").value;
		if(!reg.test(fdLogTime)) {
			document.getElementById("fdLogTimeHiddenId").style.display = "block";
			document.getElementById("fdLogTimeTextId").innerHTML = "<bean:message bundle="tib-common-log" key="tibCommonLogManage.fdLogTimeTextId"/>";
			return false;
		} else {
			document.getElementById("fdLogTimeHiddenId").style.display = "none";
			return true;
		}
	}
	
	function fdLogLastTimeChecked() {
		var fdLogLastTime= document.getElementsByName("fdLogLastTime")[0].value;//document.getElementById("fdLogLastTime").value;
		if(!reg.test(fdLogLastTime)) {
			document.getElementById("fdLogLastTimeHiddenId").style.display = "block";
			document.getElementById("fdLogLastTimeTextId").innerHTML = "<bean:message bundle="tib-common-log" key="tibCommonLogManage.fdLogLastTimeTextId"/>";
			return false;
		} else {
			document.getElementById("fdLogLastTimeHiddenId").style.display = "none";
			return true;
		}
	}
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>
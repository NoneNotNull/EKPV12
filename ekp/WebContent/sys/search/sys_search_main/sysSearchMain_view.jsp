<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.sys.search.forms.SysSearchMainForm"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<%
	SysSearchMainForm sysSearchMainForm = (SysSearchMainForm)request.getAttribute("sysSearchMainForm");
	sysSearchMainForm.setLocale(request.getLocale());
	sysSearchMainForm.setFdModelName(request.getParameter("fdModelName"));
%>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<div id="optBarDiv">
	<kmss:auth requestURL="/sys/search/sys_search_main/sysSearchMain.do?method=edit&fdId=${param.fdId}&fdModelName=${param.fdModelName}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('sysSearchMain.do?method=edit&fdId=${param.fdId}&fdModelName=${param.fdModelName}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/sys/search/sys_search_main/sysSearchMain.do?method=delete&fdId=${param.fdId}&fdModelName=${param.fdModelName}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('sysSearchMain.do?method=delete&fdId=${param.fdId}&fdModelName=${param.fdModelName}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message  bundle="sys-search" key="table.sysSearchMain"/></p>
<center>

<table class="tb_normal" width="600px">
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-search" key="sysSearchMain.fdName"/>
		</td><td>
			<bean:write name="sysSearchMainForm" property="fdName"/>
		</td>
	</tr>
	<c:if test="${not empty sysSearchMainForm.fdTemplateId}">
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-search" key="sysSearchMain.fdTemplateId"/>
		</td>
		<td>
			${sysSearchMainForm.fdTemplateName}
		</td>
	</tr>
	</c:if>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-search" key="sysSearchMain.fdCondition"/>
		</td><td>
			${sysSearchMainForm.conditionText}
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-search" key="sysSearchMain.fdDisplay"/>
		</td><td>
			${sysSearchMainForm.displayText}
		</td>
	</tr>
	<c:if test="${not empty sysSearchMainForm.fdResultUrl}">
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-search" key="sysSearchMain.fdResultUrl"/>
		</td>
		<td>
			${sysSearchMainForm.fdResultUrl}
		</td>
	</tr>
	</c:if>
	<c:if test="${not empty sysSearchMainForm.fdParemNames}">
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-search" key="sysSearchMain.fdParemNames"/>
		</td><td>
			${sysSearchMainForm.paremNamesText}
		</td>
	</tr>
	</c:if>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-search" key="sysSearchMain.fdOrderBy"/>
		</td><td>
			${sysSearchMainForm.orderByText}
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-search" key="sysSearchMain.fdOrderType"/>
		</td><td>
			<c:if test="${empty sysSearchMainForm.fdOrderType or sysSearchMainForm.fdOrderType eq 'asc'}">
			<bean:message bundle="sys-search" key="sysSearchMain.fdOrderType.asc"/>
			</c:if>
			<c:if test="${sysSearchMainForm.fdOrderType eq 'desc'}">
			<bean:message bundle="sys-search" key="sysSearchMain.fdOrderType.desc"/>
			</c:if>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%><kmss:message key="model.tempReaderName"/></td>
		<td>
			<bean:write name="sysSearchMainForm" property="authSearchReaderNames"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-search" key="sysSearchMain.fdCreator"/>
		</td><td>
			<bean:write name="sysSearchMainForm" property="fdCreatorName"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-search" key="sysSearchMain.fdCreateTime"/>
		</td><td>
			<bean:write name="sysSearchMainForm" property="fdCreateTime"/>
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
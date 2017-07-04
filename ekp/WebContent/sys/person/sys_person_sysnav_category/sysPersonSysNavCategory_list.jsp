<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="/resource/jsp/list_top.jsp"%>

<script>Com_IncludeFile("jquery.js");</script>
<script src="<c:url value="/sys/person/resource/utils.js" />"></script>
<html:form action="/sys/person/sys_person_sysnav_category/sysPersonSysNavCategory.do">
	<div id="optBarDiv">
			<kmss:authShow roles="ROLE_SYSPERSON_ADMIN">
				<input type="button" onclick="PersonOnUpdateStatus(2);" value="${lfn:message('sys-person:btn.start') }">
				<input type="button" onclick="PersonOnUpdateStatus(1);" value="${lfn:message('sys-person:btn.stop') }">
				<input
					type="button"
					value="<bean:message key="button.add"/>"
					onclick="Com_OpenWindow('<c:url value="/sys/person/sys_person_sysnav_category/sysPersonSysNavCategory.do?method=add" />', '_blank');">
			<input type="button" onclick="PersonOnDeleteAll();" value="<bean:message key="button.delete"/>">
			</kmss:authShow>
	</div>
<%
	if (((java.util.List) request.getAttribute("list")).isEmpty()) {
%>
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
<%
	} else {
%>
	<table id="List_ViewTable">
		<tr>
			<td width="10pt"><input type="checkbox" name="List_Tongle"></td>
			<td width="40pt"><bean:message key="page.serial" /></td>
			<td>
				<bean:message bundle="sys-person" key="sysPersonSysNavCategory.fdName" />
			</td>
			<td>
				<bean:message bundle="sys-person" key="sysPersonSysNavCategory.fdShortName" />
			</td>
			<td>
				<bean:message bundle="sys-person" key="sysPersonSysNavCategory.fdStatus" />
			</td>
			<td>
				<bean:message bundle="sys-person" key="sysPersonSysNavCategory.docCreator" />
			</td>
			<td>
				<bean:message bundle="sys-person" key="sysPersonSysNavCategory.docCreateTime" />
			</td>
		</tr>
		<c:forEach items="${list}" var="sysPersonSysNavCategory"
			varStatus="vstatus">
			<tr kmss_href="<c:url value="/sys/person/sys_person_sysnav_category/sysPersonSysNavCategory.do" />?method=edit&fdId=${sysPersonSysNavCategory.fdId}"
				data-status="${sysPersonSysNavCategory.fdStatus}">
			<td style="width:5px"><input type="checkbox" name="List_Selected" value="${sysPersonSysNavCategory.fdId}"></td>
			<td style="width:5px">${vstatus.index+1}</td>
			<td style="width:35%"><c:out value="${sysPersonSysNavCategory.fdName}" /></td>
			<td style="width:20%"><c:out value="${sysPersonSysNavCategory.fdShortName}" /></td>
			<td style="width:8%"><sunbor:enumsShow enumsType="sysPerson_fdStatus" value="${sysPersonSysNavCategory.fdStatus}" /></td>
			<td style="width:10%"><c:out value="${sysPersonSysNavCategory.docCreator.fdName}" /></td>
			<td style="width:17%"><kmss:showDate value="${sysPersonSysNavCategory.docCreateTime}" type="datetime"/></td>
		</tr>
		</c:forEach>
	</table>
	<%
	}
	%>
	<div style="margin:20px 0px; border-top: 1px #C0C0C0 dashed; text-align: center; padding-top:10px;">
		<div style="display:inline;vertical-align: top;"><bean:message bundle="sys-person" key="nav.config.example" /></div>
		<div style="display:inline; margin-left:20px;">
			<img src="<c:url value="/sys/person/resource/images/sample.png" />" style="border:1px #C0C0C0 solid; width:400px;">
		</div>
	</div>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>

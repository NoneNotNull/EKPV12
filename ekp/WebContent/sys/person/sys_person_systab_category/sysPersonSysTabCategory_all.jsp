<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="/resource/jsp/list_top.jsp"%>

<script>Com_IncludeFile("jquery.js");</script>
<script src="<c:url value="/sys/person/resource/utils.js" />"></script>
<html:form action="/sys/person/sys_person_systab_category/sysPersonSysTabCategory.do">
	<div id="optBarDiv">
			<input type="button" onclick="PersonOnUpdateStatus(2);" value="${lfn:message('sys-person:btn.start') }">
			<input type="button" onclick="PersonOnUpdateStatus(1);" value="${lfn:message('sys-person:btn.stop') }">
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
				<bean:message bundle="sys-person" key="sysPersonSysTabCategory.fdName" />
			</td>
			<td>
				<bean:message bundle="sys-person" key="sysPersonSysTabCategory.fdStatus" />
			</td>
			<td>
				<bean:message bundle="sys-person" key="sysPersonSysTabCategory.docCreator" />
			</td>
			<td>
				<bean:message bundle="sys-person" key="sysPersonSysTabCategory.docCreateTime" />
			</td>
		</tr>
		<c:forEach items="${list}" var="sysPersonSysTabCategory"
			varStatus="vstatus">
			<tr kmss_href="<c:url value="/sys/person/sys_person_systab_category/sysPersonSysTabCategory.do" />?method=edit&fdId=${sysPersonSysTabCategory.fdId}"
				data-status="${sysPersonSysTabCategory.fdStatus}">
			<td style="width:5px"><input type="checkbox" name="List_Selected" value="${sysPersonSysTabCategory.fdId}"></td>
			<td style="width:5px">${vstatus.index+1}</td>
			<td style="width:40%"><c:out value="${sysPersonSysTabCategory.fdName}" /></td>
			<td style="width:10%"><sunbor:enumsShow enumsType="sysPerson_fdStatus" value="${sysPersonSysTabCategory.fdStatus}" /></td>
			<td style="width:20%"><c:out value="${sysPersonSysTabCategory.docCreator.fdName}" /></td>
			<td style="width:20%"><kmss:showDate value="${sysPersonSysTabCategory.docCreateTime}" type="datetime"/></td>
		</tr>
		</c:forEach>
	</table>
	<%
	}
	%>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>

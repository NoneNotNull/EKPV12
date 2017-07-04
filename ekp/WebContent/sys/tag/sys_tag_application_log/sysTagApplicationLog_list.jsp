<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/tag/sys_tag_application_log/sysTagApplicationLog.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/tag/sys_tag_application_log/sysTagApplicationLog.do?method=add" requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/tag/sys_tag_application_log/sysTagApplicationLog.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/tag/sys_tag_application_log/sysTagApplicationLog.do?method=deleteall" requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysTagApplicationLogForm, 'deleteall');">
		</kmss:auth>
	</div>
<c:if test="${queryPage.totalrows==0}">
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
</c:if>
<c:if test="${queryPage.totalrows>0}">
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt"><input type="checkbox" name="List_Tongle"></td>
				<td width="40pt"><bean:message key="page.serial"/></td>
				<sunbor:column property="sysTagApplicationLog.fdId">
					<bean:message  bundle="sys-tag" key="sysTagApplicationLog.fdId"/>
				</sunbor:column>
				<sunbor:column property="sysTagApplicationLog.fdModelName">
					<bean:message  bundle="sys-tag" key="sysTagApplicationLog.fdModelName"/>
				</sunbor:column>
				<sunbor:column property="sysTagApplicationLog.fdModelId">
					<bean:message  bundle="sys-tag" key="sysTagApplicationLog.fdModelId"/>
				</sunbor:column>
				<sunbor:column property="sysTagApplicationLog.fdTagName">
					<bean:message  bundle="sys-tag" key="sysTagApplicationLog.fdTagName"/>
				</sunbor:column>
				<sunbor:column property="sysTagApplicationLog.fdValue">
					<bean:message  bundle="sys-tag" key="sysTagApplicationLog.fdValue"/>
				</sunbor:column>
				<sunbor:column property="sysTagApplicationLog.fdAccount">
					<bean:message  bundle="sys-tag" key="sysTagApplicationLog.fdAccount"/>
				</sunbor:column>
				<sunbor:column property="sysTagApplicationLog.sysOrgElement.fdId">
					<bean:message  bundle="sys-tag" key="table.sysOrgElement"/>.<bean:message key="sysOrgElement.fdId"/>
				</sunbor:column>
				<sunbor:column property="sysTagApplicationLog.docCreateTime">
					<bean:message  bundle="sys-tag" key="sysTagApplicationLog.docCreateTime"/>
				</sunbor:column>
				<sunbor:column property="sysTagApplicationLog.docStatus">
					<bean:message  bundle="sys-tag" key="sysTagApplicationLog.docStatus"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysTagApplicationLog" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/tag/sys_tag_application_log/sysTagApplicationLog.do" />?method=view&fdId=${sysTagApplicationLog.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysTagApplicationLog.fdId}">
				</td>
				<td>${vstatus.index+1}</td>
				<td>
					<c:out value="${sysTagApplicationLog.fdId}" />
				</td>
				<td>
					<c:out value="${sysTagApplicationLog.fdModelName}" />
				</td>
				<td>
					<c:out value="${sysTagApplicationLog.fdModelId}" />
				</td>
				<td>
					<c:out value="${sysTagApplicationLog.fdTagName}" />
				</td>
				<td>
					<c:out value="${sysTagApplicationLog.fdValue}" />
				</td>
				<td>
					<c:out value="${sysTagApplicationLog.fdAccount}" />
				</td>
				<td>
					<c:out value="${sysTagApplicationLog.sysOrgElement.fdId}" />
				</td>
				<td>
					<c:out value="${sysTagApplicationLog.docCreateTime}" />
				</td>
				<td>
					<c:out value="${sysTagApplicationLog.docStatus}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
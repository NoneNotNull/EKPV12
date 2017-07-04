<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/tag/sys_tag_main/sysTagMain.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/tag/sys_tag_main/sysTagMain.do?method=add" requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/tag/sys_tag_main/sysTagMain.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/tag/sys_tag_main/sysTagMain.do?method=deleteall" requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysTagMainForm, 'deleteall');">
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
				<sunbor:column property="sysTagMain.fdId">
					<bean:message  bundle="sys-tag" key="sysTagMain.fdId"/>
				</sunbor:column>
				<sunbor:column property="sysTagMain.fdModelName">
					<bean:message  bundle="sys-tag" key="sysTagMain.fdModelName"/>
				</sunbor:column>
				<sunbor:column property="sysTagMain.fdModelId">
					<bean:message  bundle="sys-tag" key="sysTagMain.fdModelId"/>
				</sunbor:column>
				<sunbor:column property="sysTagMain.docSubject">
					<bean:message  bundle="sys-tag" key="sysTagMain.docSubject"/>
				</sunbor:column>
				<sunbor:column property="sysTagMain.fdKey">
					<bean:message  bundle="sys-tag" key="sysTagMain.fdKey"/>
				</sunbor:column>
				<sunbor:column property="sysTagMain.fdTagName">
					<bean:message  bundle="sys-tag" key="sysTagMain.fdTagName"/>
				</sunbor:column>
				<sunbor:column property="sysTagMain.sysOrgElement.fdId">
					<bean:message  bundle="sys-tag" key="table.sysOrgElement"/>.<bean:message key="sysOrgElement.fdId"/>
				</sunbor:column>
				<sunbor:column property="sysTagMain.docCreateTime">
					<bean:message  bundle="sys-tag" key="sysTagMain.docCreateTime"/>
				</sunbor:column>
				<sunbor:column property="sysTagMain.docAlterTime">
					<bean:message  bundle="sys-tag" key="sysTagMain.docAlterTime"/>
				</sunbor:column>
				<sunbor:column property="sysTagMain.docStatus">
					<bean:message  bundle="sys-tag" key="sysTagMain.docStatus"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysTagMain" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/tag/sys_tag_main/sysTagMain.do" />?method=view&fdId=${sysTagMain.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysTagMain.fdId}">
				</td>
				<td>${vstatus.index+1}</td>
				<td>
					<c:out value="${sysTagMain.fdId}" />
				</td>
				<td>
					<c:out value="${sysTagMain.fdModelName}" />
				</td>
				<td>
					<c:out value="${sysTagMain.fdModelId}" />
				</td>
				<td>
					<c:out value="${sysTagMain.docSubject}" />
				</td>
				<td>
					<c:out value="${sysTagMain.fdKey}" />
				</td>
				<td>
					<c:out value="${sysTagMain.fdTagName}" />
				</td>
				<td>
					<c:out value="${sysTagMain.sysOrgElement.fdId}" />
				</td>
				<td>
					<c:out value="${sysTagMain.docCreateTime}" />
				</td>
				<td>
					<c:out value="${sysTagMain.docAlterTime}" />
				</td>
				<td>
					<c:out value="${sysTagMain.docStatus}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
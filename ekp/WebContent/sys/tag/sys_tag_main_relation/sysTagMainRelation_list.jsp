<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/tag/sys_tag_main_relation/sysTagMainRelation.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/tag/sys_tag_main_relation/sysTagMainRelation.do?method=add" requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/tag/sys_tag_main_relation/sysTagMainRelation.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/tag/sys_tag_main_relation/sysTagMainRelation.do?method=deleteall" requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysTagMainRelationForm, 'deleteall');">
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
				<sunbor:column property="sysTagMainRelation.fdId">
					<bean:message  bundle="sys-tag" key="sysTagMainRelation.fdId"/>
				</sunbor:column>
				<sunbor:column property="sysTagMainRelation.sysTagMain.fdId">
					<bean:message  bundle="sys-tag" key="table.sysTagMain"/>.<bean:message key="sysTagMain.fdId"/>
				</sunbor:column>
				<sunbor:column property="sysTagMainRelation.fdTagName">
					<bean:message  bundle="sys-tag" key="sysTagMainRelation.fdTagName"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysTagMainRelation" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/tag/sys_tag_main_relation/sysTagMainRelation.do" />?method=view&fdId=${sysTagMainRelation.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysTagMainRelation.fdId}">
				</td>
				<td>${vstatus.index+1}</td>
				<td>
					<c:out value="${sysTagMainRelation.fdId}" />
				</td>
				<td>
					<c:out value="${sysTagMainRelation.sysTagMain.fdId}" />
				</td>
				<td>
					<c:out value="${sysTagMainRelation.fdTagName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
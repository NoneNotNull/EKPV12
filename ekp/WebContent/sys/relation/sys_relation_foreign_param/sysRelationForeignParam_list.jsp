<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/relation/sys_relation_foreign_param/sysRelationForeignParam.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/relation/sys_relation_foreign_param/sysRelationForeignParam.do?method=add" requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/relation/sys_relation_foreign_param/sysRelationForeignParam.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/relation/sys_relation_foreign_param/sysRelationForeignParam.do?method=deleteall" requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysRelationForeignParamForm, 'deleteall');">
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
				<sunbor:column property="sysRelationForeignParam.fdId">
					<bean:message  bundle="sys-relation" key="sysRelationForeignParam.fdId"/>
				</sunbor:column>
				<sunbor:column property="sysRelationForeignParam.fdParam">
					<bean:message  bundle="sys-relation" key="sysRelationForeignParam.fdParam"/>
				</sunbor:column>
				<sunbor:column property="sysRelationForeignParam.fdParamName">
					<bean:message  bundle="sys-relation" key="sysRelationForeignParam.fdParamName"/>
				</sunbor:column>
				<sunbor:column property="sysRelationForeignParam.fdParamType">
					<bean:message  bundle="sys-relation" key="sysRelationForeignParam.fdParamType"/>
				</sunbor:column>
				<sunbor:column property="sysRelationForeignParam.sysRelationForeignModule.fdId">
					<bean:message  bundle="sys-relation" key="table.sysRelationForeignModule"/>.<bean:message key="sysRelationForeignModule.fdId"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysRelationForeignParam" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/relation/sys_relation_foreign_param/sysRelationForeignParam.do" />?method=view&fdId=${sysRelationForeignParam.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysRelationForeignParam.fdId}">
				</td>
				<td>${vstatus.index+1}</td>
				<td>
					<c:out value="${sysRelationForeignParam.fdId}" />
				</td>
				<td>
					<c:out value="${sysRelationForeignParam.fdParam}" />
				</td>
				<td>
					<c:out value="${sysRelationForeignParam.fdParamName}" />
				</td>
				<td>
					<c:out value="${sysRelationForeignParam.fdParamType}" />
				</td>
				<td>
					<c:out value="${sysRelationForeignParam.sysRelationForeignModule.fdId}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
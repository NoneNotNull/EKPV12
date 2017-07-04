<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/property/sys_property_tree/sysPropertyTree.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/property/sys_property_tree/sysPropertyTree.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/property/sys_property_tree/sysPropertyTree.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/property/sys_property_tree/sysPropertyTree.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysPropertyTreeForm, 'deleteall');">
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
				<td width="10pt">
					<input type="checkbox" name="List_Tongle">
				</td>
				<td width="40pt">
					<bean:message key="page.serial"/>
				</td>
				<sunbor:column property="sysPropertyTree.fdName">
					<bean:message bundle="sys-property" key="sysPropertyTree.fdName"/>
				</sunbor:column>
				<sunbor:column property="sysPropertyTree.fdOrder">
					<bean:message bundle="sys-property" key="sysPropertyTree.fdOrder"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysPropertyTree" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/property/sys_property_tree/sysPropertyTree.do" />?method=view&fdId=${sysPropertyTree.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysPropertyTree.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${sysPropertyTree.fdName}" />
				</td>
				<td>
					<c:out value="${sysPropertyTree.fdOrder}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/portal/sys_portal_tree/sysPortalTree.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/portal/sys_portal_tree/sysPortalTree.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/portal/sys_portal_tree/sysPortalTree.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/portal/sys_portal_tree/sysPortalTree.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysPortalTreeForm, 'deleteall');">
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
				<sunbor:column property="sysPortalTree.fdName">
					<bean:message bundle="sys-portal" key="sysPortalTree.fdName"/>
				</sunbor:column>
				<sunbor:column property="sysPortalTree.fdType">
					<bean:message bundle="sys-portal" key="sysPortalTree.fdType"/>
				</sunbor:column>
				<sunbor:column property="sysPortalTree.docCreateTime">
					<bean:message bundle="sys-portal" key="sysPortalTree.docCreateTime"/>
				</sunbor:column>
				<sunbor:column property="sysPortalTree.docCreator.fdName">
					<bean:message bundle="sys-portal" key="sysPortalTree.docCreator"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysPortalTree" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/portal/sys_portal_tree/sysPortalTree.do" />?method=edit&fdId=${sysPortalTree.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysPortalTree.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${sysPortalTree.fdName}" />
				</td>
				<td>
					<xform:select property="connState" value="${sysPortalTree.fdType}">
						<xform:enumsDataSource enumsType="sys_portal_tree_type" />
					</xform:select> 
				</td>
				<td>
					<kmss:showDate value="${sysPortalTree.docCreateTime}" />
				</td> 
				<td>
					<c:out value="${sysPortalTree.docCreator.fdName}" />
				</td> 
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
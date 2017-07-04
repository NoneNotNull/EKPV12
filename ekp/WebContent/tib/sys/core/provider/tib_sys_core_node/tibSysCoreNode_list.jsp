<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/tib/sys/core/provider/tib_sys_core_node/tibSysCoreNode.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/tib/sys/core/provider/tib_sys_core_node/tibSysCoreNode.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/tib/sys/core/provider/tib_sys_core_node/tibSysCoreNode.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/tib/sys/core/provider/tib_sys_core_node/tibSysCoreNode.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.tibSysCoreNodeForm, 'deleteall');">
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
				<sunbor:column property="tibSysCoreNode.fdNodeLevel">
					<bean:message bundle="tib-sys-core-provider" key="tibSysCoreNode.fdNodeLevel"/>
				</sunbor:column>
				<sunbor:column property="tibSysCoreNode.fdNodeName">
					<bean:message bundle="tib-sys-core-provider" key="tibSysCoreNode.fdNodeName"/>
				</sunbor:column>
				<sunbor:column property="tibSysCoreNode.fdNodePath">
					<bean:message bundle="tib-sys-core-provider" key="tibSysCoreNode.fdNodePath"/>
				</sunbor:column>
				<sunbor:column property="tibSysCoreNode.fdDataType">
					<bean:message bundle="tib-sys-core-provider" key="tibSysCoreNode.fdDataType"/>
				</sunbor:column>
				<sunbor:column property="tibSysCoreNode.fdNodeEnable">
					<bean:message bundle="tib-sys-core-provider" key="tibSysCoreNode.fdNodeEnable"/>
				</sunbor:column>
				<sunbor:column property="tibSysCoreNode.fdDefName">
					<bean:message bundle="tib-sys-core-provider" key="tibSysCoreNode.fdDefName"/>
				</sunbor:column>
				<sunbor:column property="tibSysCoreNode.fdNodeContent">
					<bean:message bundle="tib-sys-core-provider" key="tibSysCoreNode.fdNodeContent"/>
				</sunbor:column>
				<sunbor:column property="tibSysCoreNode.fdIface.fdId">
					<bean:message bundle="tib-sys-core-provider" key="tibSysCoreNode.fdIface"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="tibSysCoreNode" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/tib/sys/core/provider/tib_sys_core_node/tibSysCoreNode.do" />?method=view&fdId=${tibSysCoreNode.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${tibSysCoreNode.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${tibSysCoreNode.fdNodeLevel}" />
				</td>
				<td>
					<c:out value="${tibSysCoreNode.fdNodeName}" />
				</td>
				<td>
					<c:out value="${tibSysCoreNode.fdNodePath}" />
				</td>
				<td>
					<c:out value="${tibSysCoreNode.fdDataType}" />
				</td>
				<td>
					<xform:radio value="${tibSysCoreNode.fdNodeEnable}" property="fdNodeEnable" showStatus="view">
						<xform:enumsDataSource enumsType="common_yesno" />
					</xform:radio>
				</td>
				<td>
					<c:out value="${tibSysCoreNode.fdDefName}" />
				</td>
				<td>
					<c:out value="${tibSysCoreNode.fdNodeContent}" />
				</td>
				<td>
					<c:out value="${tibSysCoreNode.fdIface.fdId}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
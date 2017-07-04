<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/cluster/sys_cluster_group/sysClusterGroup.do">
	<div id="optBarDiv">
		<input type="button" value="<bean:message bundle="sys-cluster" key="sysClusterGroupFunc.setting"/>"
			onclick="Com_OpenWindow('<c:url value="/sys/cluster/sys_cluster_group_func/sysClusterGroupFunc.do" />?method=list');">
		<input type="button" value="<bean:message bundle="sys-cluster" key="sysClusterGroup.sync"/>"
			onclick="if(!List_ConfirmSync())return;Com_Submit(document.sysClusterGroupForm, 'syncGroup');">
		<input type="button" value="<bean:message key="button.add"/>"
			onclick="Com_OpenWindow('<c:url value="/sys/cluster/sys_cluster_group/sysClusterGroup.do" />?method=add');">
		<input type="button" value="<bean:message key="button.delete"/>"
			onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysClusterGroupForm, 'deleteall');">
		<input type="button" value="<bean:message key="button.refresh"/>"
			onclick="history.go(0);">
	</div>
	<script>
		function List_ConfirmSync(){
			return List_CheckSelect() && confirm("<bean:message bundle="sys-cluster" key="sysClusterGroup.sync.confirm"/>");
		}
	</script>
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
				<sunbor:column property="sysClusterGroup.fdOrder">
					<bean:message bundle="sys-cluster" key="sysClusterGroup.fdOrder"/>
				</sunbor:column>
				<sunbor:column property="sysClusterGroup.fdName">
					<bean:message bundle="sys-cluster" key="sysClusterGroup.fdName"/>
				</sunbor:column>
				<sunbor:column property="sysClusterGroup.fdKey">
					<bean:message bundle="sys-cluster" key="sysClusterGroup.fdKey"/>
				</sunbor:column>
				<sunbor:column property="sysClusterGroup.fdUrl">
					<bean:message bundle="sys-cluster" key="sysClusterGroup.fdUrl"/>
				</sunbor:column>
				<sunbor:column property="sysClusterGroup.fdMaster">
					<bean:message bundle="sys-cluster" key="sysClusterGroup.fdMaster"/>
				</sunbor:column>
				<td>
					<bean:message bundle="sys-cluster" key="sysClusterGroup.fdLocal"/>
				</td>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysClusterGroup" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/cluster/sys_cluster_group/sysClusterGroup.do" />?method=edit&fdId=${sysClusterGroup.fdId}"
				<c:if test="${sysClusterGroup.fdLocal}">style="font-weight:bold;"</c:if>
				>
				<td>
					<input type="checkbox" name="List_Selected" value="${sysClusterGroup.fdId}">
				</td>
				<td>
					<c:out value="${sysClusterGroup.fdOrder}" />
				</td>
				<td>
					<c:out value="${sysClusterGroup.fdName}" />
				</td>
				<td>
					<c:out value="${sysClusterGroup.fdKey}" />
				</td>
				<td>
					<c:if test="${not sysClusterGroup.fdLocal && not empty sysClusterGroup.fdUrl}">
						<a href="${sysClusterGroup.fdUrl}/sys/cluster/sys_cluster_group/sysClusterGroup.do?method=list"
								target="_self" title="<bean:message bundle="sys-cluster" key="sysClusterGroup.linkTitle"/>">
					</c:if>
						<c:out value="${sysClusterGroup.fdUrl}" />
					<c:if test="${not sysClusterServer.local && not empty sysClusterServer.fdUrl}">
						</a>
					</c:if>
				</td>
				<td>
					<sunbor:enumsShow value="${sysClusterGroup.fdMaster}" enumsType="common_yesno" />
				</td>
				<td>
					<sunbor:enumsShow value="${sysClusterGroup.fdLocal}" enumsType="common_yesno" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
	<br>
	说明：更新子系统信息以后，或者重新设置子系统功能以后，在各个子系统已经启动的情况下，可以通过“同步”功能，将子系统的配置信息同步到其它子系统<br>
	当中心服务发生变更（包括修改URL等），请务必点击“同步”功能，将配置信息刷新到各个子系统中，否则将会出现系统功能异常
</c:if>

</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>

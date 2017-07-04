<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/fans/sys_fans_main/sysFansMain.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/fans/sys_fans_main/sysFansMain.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/fans/sys_fans_main/sysFansMain.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/fans/sys_fans_main/sysFansMain.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysFansMainForm, 'deleteall');">
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
				<sunbor:column property="sysFansMain.fdUserId">
					<bean:message bundle="sys-fans" key="sysFansMain.fdUserId"/>
				</sunbor:column>
				<sunbor:column property="sysFansMain.fdFollowerId">
					<bean:message bundle="sys-fans" key="sysFansMain.fdFollowerId"/>
				</sunbor:column>
				<sunbor:column property="sysFansMain.fdFollowTime">
					<bean:message bundle="sys-fans" key="sysFansMain.fdFollowTime"/>
				</sunbor:column>
				<sunbor:column property="sysFansMain.fdRelationType">
					<bean:message bundle="sys-fans" key="sysFansMain.fdRelationType"/>
				</sunbor:column>
				<sunbor:column property="sysFansMain.fdUserType">
					<bean:message bundle="sys-fans" key="sysFansMain.fdUserType"/>
				</sunbor:column>
				<sunbor:column property="sysFansMain.fdCanUnfollow">
					<bean:message bundle="sys-fans" key="sysFansMain.fdCanUnfollow"/>
				</sunbor:column>
				<sunbor:column property="sysFansMain.fdModelName">
					<bean:message bundle="sys-fans" key="sysFansMain.fdModelName"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysFansMain" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/fans/sys_fans_main/sysFansMain.do" />?method=view&fdId=${sysFansMain.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysFansMain.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${sysFansMain.fdUserId}" />
				</td>
				<td>
					<c:out value="${sysFansMain.fdFollowerId}" />
				</td>
				<td>
					<kmss:showDate value="${sysFansMain.fdFollowTime}" />
				</td>
				<td>
					<c:out value="${sysFansMain.fdRelationType}" />
				</td>
				<td>
					<c:out value="${sysFansMain.fdUserType}" />
				</td>
				<td>
					<xform:radio value="${sysFansMain.fdCanUnfollow}" property="fdCanUnfollow" showStatus="view">
						<xform:enumsDataSource enumsType="common_yesno" />
					</xform:radio>
				</td>
				<td>
					<c:out value="${sysFansMain.fdModelName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
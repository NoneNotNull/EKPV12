<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/follow/sys_follow_person_config/sysFollowPersonConfig.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/follow/sys_follow_person_config/sysFollowPersonConfig.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/follow/sys_follow_person_config/sysFollowPersonConfig.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/follow/sys_follow_person_config/sysFollowPersonConfig.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysFollowPersonConfigForm, 'deleteall');">
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
				<sunbor:column property="sysFollowPersonConfig.fdSubject">
					<bean:message bundle="sys-follow" key="sysFollowPersonConfig.fdSubject"/>
				</sunbor:column>
				<sunbor:column property="sysFollowPersonConfig.fdStatus">
					<bean:message bundle="sys-follow" key="sysFollowPersonConfig.fdStatus"/>
				</sunbor:column>
				<sunbor:column property="sysFollowPersonConfig.fdType">
					<bean:message bundle="sys-follow" key="sysFollowPersonConfig.fdType"/>
				</sunbor:column>
				<sunbor:column property="sysFollowPersonConfig.fdModelName">
					<bean:message bundle="sys-follow" key="sysFollowPersonConfig.fdModelName"/>
				</sunbor:column>
				<sunbor:column property="sysFollowPersonConfig.fdFollowName">
					<bean:message bundle="sys-follow" key="sysFollowPersonConfig.fdFollowName"/>
				</sunbor:column>
				<sunbor:column property="sysFollowPersonConfig.follower.fdName">
					<bean:message bundle="sys-follow" key="sysFollowPersonConfig.follower"/>
				</sunbor:column>
				<sunbor:column property="sysFollowPersonConfig.fdLastModifiedTime">
					<bean:message bundle="sys-follow" key="sysFollowPersonConfig.fdLastModifiedTime"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysFollowPersonConfig" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/follow/sys_follow_person_config/sysFollowPersonConfig.do" />?method=view&fdId=${sysFollowPersonConfig.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysFollowPersonConfig.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${sysFollowPersonConfig.fdSubject}" />
				</td>
				<td>
					<sunbor:enumsShow value="${sysFollowPersonConfig.fdStatus}" enumsType="sys_follow_person_config_status" />
				</td>
				<td>
					<c:out value="${sysFollowPersonConfig.fdType}" />
				</td>
				<td>
					<c:out value="${sysFollowPersonConfig.fdModelName}" />
				</td>
				<td>
					<c:out value="${sysFollowPersonConfig.fdFollowName}" />
				</td>
				<td>
					<c:out value="${sysFollowPersonConfig.follower.fdName}" />
				</td>
				<td>
					<kmss:showDate value="${sysFollowPersonConfig.fdLastModifiedTime}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
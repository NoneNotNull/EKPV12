<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/component/locker/component_locker_main/componentLockerMain.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/component/locker/component_locker_main/componentLockerMain.do?method=releaseLockers">
			<input type="button" value="<bean:message key="botton.componentLockerMain.release" bundle="component-locker" />"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.componentLockerMainForm, 'releaseLockers');">
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
				<sunbor:column property="componentLockerMain.fdModelName">
					<bean:message bundle="component-locker" key="componentLockerMain.fdModelName"/>
				</sunbor:column>
				<sunbor:column property="componentLockerMain.fdLockedTime">
					<bean:message bundle="component-locker" key="componentLockerMain.fdLockedTime"/>
				</sunbor:column>
				<sunbor:column property="componentLockerMain.fdLockerOwner">
					<bean:message bundle="component-locker" key="componentLockerMain.fdLockerOwner"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="componentLockerMain" varStatus="vstatus">
			<tr>
				<td>
					<input type="checkbox" name="List_Selected" value="${componentLockerMain.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${componentLockerMain.fdModelName}" />
				</td>
				<td>
					<kmss:showDate value="${componentLockerMain.fdLockedTime}" />
				</td>
				<td>
					<c:out value="${componentLockerMain.fdLockerOwner}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
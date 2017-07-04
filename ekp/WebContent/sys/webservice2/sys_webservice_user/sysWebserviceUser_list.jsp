<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/webservice2/sys_webservice_user/sysWebserviceUser.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/webservice2/sys_webservice_user/sysWebserviceUser.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/webservice2/sys_webservice_user/sysWebserviceUser.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/webservice2/sys_webservice_user/sysWebserviceUser.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysWebserviceUserForm, 'deleteall');">
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
				<sunbor:column property="sysWebserviceUser.fdUserName">
					<bean:message bundle="sys-webservice2" key="sysWebserviceUser.fdUserName"/>
				</sunbor:column>
				<sunbor:column property="sysWebserviceUser.fdLoginId">
					<bean:message bundle="sys-webservice2" key="sysWebserviceUser.fdLoginId"/>
				</sunbor:column>				
				<sunbor:column property="sysWebserviceUser.fdService">
					<bean:message bundle="sys-webservice2" key="sysWebserviceUser.fdService"/>
				</sunbor:column>
				<sunbor:column property="sysWebserviceUser.docCreator.fdName">
					<bean:message bundle="sys-webservice2" key="sysWebserviceUser.docCreator"/>
				</sunbor:column>				
				<sunbor:column property="sysWebserviceUser.docCreateTime">
					<bean:message bundle="sys-webservice2" key="sysWebserviceUser.docCreateTime"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysWebserviceUser" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/webservice2/sys_webservice_user/sysWebserviceUser.do" />?method=view&fdId=${sysWebserviceUser.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysWebserviceUser.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${sysWebserviceUser.fdUserName}" />
				</td>
				<td>
					<c:out value="${sysWebserviceUser.fdLoginId}" />
				</td>				
				<td>
					<c:forEach items="${sysWebserviceUser.fdService}" var="sysWebserviceMain" varStatus="loop">
					    <c:if test="${loop.index==0}">
					        <c:out value="${sysWebserviceMain.fdName}" />
					    </c:if>
					    <c:if test="${loop.index>0}">
					        <c:out value="、${sysWebserviceMain.fdName}" />
					    </c:if>
					</c:forEach> 
				</td>
				<td>
					<c:out value="${sysWebserviceUser.docCreator.fdName}" />
				</td>				
				<td>
					<kmss:showDate value="${sysWebserviceUser.docCreateTime}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
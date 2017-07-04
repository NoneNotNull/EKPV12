<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/lbpmext/integrate/authorize/lbpm_authorize/lbpmAuthorizeScope.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/lbpmext/integrate/authorize/lbpm_authorize/lbpmAuthorizeScope.do?method=add" requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/lbpmext/integrate/authorize/lbpm_authorize/lbpmAuthorizeScope.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/lbpmext/integrate/authorize/lbpm_authorize/lbpmAuthorizeScope.do?method=deleteall" requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.lbpmAuthorizeScopeForm, 'deleteall');">
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
				<sunbor:column property="lbpmAuthorizeScope.lbpmAuthorizeS.fdId">
					<bean:message  bundle="sys-lbpmext-authorize" key="table.lbpmAuthorize"/>.<bean:message key="lbpmAuthorize.fdId"/>
				</sunbor:column>
				<sunbor:column property="lbpmAuthorizeScope.fdAuthorizeCateId">
					<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorizeScope.fdAuthorizeCateId"/>
				</sunbor:column>
				<sunbor:column property="lbpmAuthorizeScope.fdAuthorizeCateName">
					<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorizeScope.fdAuthorizeCateName"/>
				</sunbor:column>
				<sunbor:column property="lbpmAuthorizeScope.fdAuthorizeCateShowtext">
					<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorizeScope.fdAuthorizeCateShowtext"/>
				</sunbor:column>
				<sunbor:column property="lbpmAuthorizeScope.fdModelName">
					<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorizeScope.fdModelName"/>
				</sunbor:column>
				<sunbor:column property="lbpmAuthorizeScope.fdModuleName">
					<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorizeScope.fdModuleName"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="lbpmAuthorizeScope" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/lbpmext/integrate/authorize/lbpm_authorize/lbpmAuthorizeScope.do" />?method=view&fdId=${lbpmAuthorizeScope.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${lbpmAuthorizeScope.fdId}">
				</td>
				<td>${vstatus.index+1}</td>
				<td>
					<c:out value="${lbpmAuthorizeScope.lbpmAuthorizeS.fdId}" />
				</td>
				<td>
					<c:out value="${lbpmAuthorizeScope.fdAuthorizeCateId}" />
				</td>
				<td>
					<c:out value="${lbpmAuthorizeScope.fdAuthorizeCateName}" />
				</td>
				<td>
					<c:out value="${lbpmAuthorizeScope.fdAuthorizeCateShowtext}" />
				</td>
				<td>
					<c:out value="${lbpmAuthorizeScope.fdModelName}" />
				</td>
				<td>
					<c:out value="${lbpmAuthorizeScope.fdModuleName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
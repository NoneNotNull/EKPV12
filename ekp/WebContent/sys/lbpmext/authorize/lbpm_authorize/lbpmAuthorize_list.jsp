<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/lbpmext/authorize/lbpm_authorize/lbpmAuthorize.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/lbpmext/authorize/lbpm_authorize/lbpmAuthorize.do?method=add" requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/lbpmext/authorize/lbpm_authorize/lbpmAuthorize.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/lbpmext/authorize/lbpm_authorize/lbpmAuthorize.do?method=deleteall" requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.lbpmAuthorizeForm, 'deleteall');">
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
				<sunbor:column property="lbpmAuthorize.fdStartTime">
					<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorize.fdStartTime"/>
				</sunbor:column>
				<sunbor:column property="lbpmAuthorize.fdEndTime">
					<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorize.fdEndTime"/>
				</sunbor:column>
				<sunbor:column property="lbpmAuthorize.fdAuthorizer.fdName">
					<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorize.fdAuthorizer"/>
				</sunbor:column>
				<sunbor:column property="lbpmAuthorize.fdAuthorizedPerson.fdName">
					<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorize.fdAuthorizedPerson"/>
				</sunbor:column>
				<sunbor:column property="lbpmAuthorize.fdAuthorizeType">
					<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorize.fdAuthorizeType"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="lbpmAuthorize" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/lbpmext/authorize/lbpm_authorize/lbpmAuthorize.do" />?method=view&fdId=${lbpmAuthorize.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${lbpmAuthorize.fdId}">
				</td>
				<td>${vstatus.index+1}</td>
				<c:if test="${lbpmAuthorize.fdAuthorizeType == 0 || lbpmAuthorize.fdAuthorizeType == 2}">
					<td>
						<kmss:showDate value="${lbpmAuthorize.fdStartTime}" type="datetime" />
					</td>
					<td>
						<kmss:showDate value="${lbpmAuthorize.fdEndTime}" type="datetime" />
					</td>
				</c:if>
				<c:if test="${lbpmAuthorize.fdAuthorizeType == 1}">
					<td>
						<kmss:showDate value="${lbpmAuthorize.fdStartTime}" type="datetime" />
					</td>
					<td>
						<bean:message  bundle="sys-lbpmext-authorize" key="lbpmAuthorize.fdEndTime.infinitive"/>
					</td>
				</c:if>
				<td>
					<c:out value="${lbpmAuthorize.fdAuthorizer.fdName}" />
				</td>
				<td>
					<c:out value="${lbpmAuthorize.fdAuthorizedPerson.fdName}" />
				</td>
				<td>
					<sunbor:enumsShow  enumsType="lbpmAuthorize_authorizeType" value="${lbpmAuthorize.fdAuthorizeType}"/>
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
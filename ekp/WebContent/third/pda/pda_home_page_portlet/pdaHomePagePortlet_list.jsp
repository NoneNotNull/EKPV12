<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/third/pda/pda_home_page_portlet/pdaHomePagePortlet.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/third/pda/pda_home_page_portlet/pdaHomePagePortlet.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.pdaHomePagePortletForm, 'deleteall');">
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
				<sunbor:column property="pdaHomePagePortlet.fdName">
					<bean:message bundle="third-pda" key="pdaHomePagePortlet.fdName"/>
				</sunbor:column>
				<sunbor:column property="pdaHomePagePortlet.fdType">
					<bean:message bundle="third-pda" key="pdaHomePagePortlet.fdType"/>
				</sunbor:column>
				<sunbor:column property="pdaHomePagePortlet.fdOrder">
					<bean:message bundle="third-pda" key="pdaHomePagePortlet.fdDataContent"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="pdaHomePagePortlet" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/third/pda/pda_home_page_portlet/pdaHomePagePortlet.do" />?method=view&fdId=${pdaModuleLabelList.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${pdaHomePagePortlet.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${pdaHomePagePortlet.fdName}" />
				</td>
				<td>
				<c:if test="${pdaHomePagePortlet.fdType=='list'}">
					<bean:message bundle="third-pda" key="pdaHomeCustomPortlet.fdType.list"/>
				</c:if>
				<c:if test="${pdaHomePagePortlet.fdType=='pic'}">
					<bean:message bundle="third-pda" key="pdaHomeCustomPortlet.fdType.pic"/>
				</c:if>
				</td>
				<td>
					<c:out value="${pdaHomePagePortlet.fdContent}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
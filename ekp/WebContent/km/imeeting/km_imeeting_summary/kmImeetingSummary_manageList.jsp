<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script language="JavaScript">Com_IncludeFile("dialog.js");</script>
<c:import url="/resource/jsp/search_bar.jsp" charEncoding="UTF-8">
	<c:param name="fdModelName" value="com.landray.kmss.km.imeeting.model.KmImeetingSummary" />
</c:import>
<html:form action="/km/imeeting/km_imeeting_summary/kmImeetingSummary.do">
	<div id="optBarDiv">
		<c:if test="${param.categoryId==null || param.nodeType=='CATEGORY'}">
			<kmss:authShow roles="ROLE_KMIMEETING_SUMMARY_CREATE">
				<input type="button" value="<bean:message key="button.add"/>"
					onclick="Dialog_Template('com.landray.kmss.km.imeeting.model.KmImeetingTemplate','<c:url value="/km/imeeting/km_imeeting_summary/kmImeetingSummary.do" />?method=add&fdTemplateId=!{id}&fdTemplateName=!{name}');">
			</kmss:authShow>
		</c:if>
		<c:if test="${param.nodeType=='TEMPLATE'}">	
			<kmss:auth
				requestURL="/km/imeeting/km_imeeting_summary/kmImeetingSummary.do?method=add&fdTemplateId=${param.categoryId}&fdModelId=${param.fdModelId}&fdModelName=${param.fdModelName}"
				requestMethod="GET">
				<input type="button" value="<bean:message key="button.add"/>"
					onclick="Com_OpenWindow('<c:url value="/km/imeeting/km_imeeting_summary/kmImeetingSummary.do" />?method=add&fdTemplateId=${param.categoryId}&fdProjectId=${param.fdProjectId}&fdModelName=${param.fdModelName}');">
			</kmss:auth>
		</c:if>
		<kmss:auth requestURL="/km/imeeting/km_imeeting_summary/kmImeetingSummary.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmImeetingSummaryForm, 'deleteall');">
		</kmss:auth>
		<input type="button" value="<bean:message key="button.search"/>" onclick="Search_Show();">
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
				<sunbor:column property="kmImeetingSummary.fdName">
					<bean:message bundle="km-imeeting" key="kmImeetingSummary.fdName"/>
				</sunbor:column>
					<sunbor:column property="kmImeetingSummary.docCreator.fdName">
					<bean:message bundle="km-imeeting" key="kmImeetingSummary.docCreator"/>
				</sunbor:column>
				<sunbor:column property="kmImeetingSummary.fdTemplate.docCategory.fdName">
					<bean:message bundle="km-imeeting" key="kmImeetingSummary.fdTemplate"/>
				</sunbor:column>
				<sunbor:column property="kmImeetingSummary.docStatus">
					<bean:message bundle="km-imeeting" key="kmImeetingSummary.docStatus"/>
				</sunbor:column>
				<sunbor:column property="kmImeetingSummary.fdHoldDate">
					<bean:message bundle="km-imeeting" key="kmImeetingSummary.fdHoldDate"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmImeetingSummary" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/km/imeeting/km_imeeting_summary/kmImeetingSummary.do" />?method=view&fdId=${kmImeetingSummary.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmImeetingSummary.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmImeetingSummary.fdName}" />
				</td>
				<td>
					<c:out value="${kmImeetingSummary.docCreator.fdName}" />
				</td>
				<td>
					<c:out value="${kmImeetingSummary.fdTemplate.docCategory.fdName}" />
				</td>
				<td>
					<sunbor:enumsShow value="${kmImeetingSummary.docStatus}" enumsType="common_status" />
				</td>
				<td>
					<kmss:showDate value="${kmImeetingSummary.fdHoldDate}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
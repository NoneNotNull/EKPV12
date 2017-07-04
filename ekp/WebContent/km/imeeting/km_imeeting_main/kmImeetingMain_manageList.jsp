<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script language="JavaScript">Com_IncludeFile("dialog.js");</script>
<c:import url="/resource/jsp/search_bar.jsp" charEncoding="UTF-8">
	<c:param name="fdModelName" value="com.landray.kmss.km.imeeting.model.KmImeetingMain" />
</c:import>
<html:form action="/km/imeeting/km_imeeting_main/kmImeetingMain.do">
	<div id="optBarDiv">
		<c:if test="${param.categoryId==null || param.nodeType=='CATEGORY'}">
			<kmss:authShow roles="ROLE_KMIMEETING_CREATE">
				<input type="button" value="<bean:message key="button.add"/>"
					onclick="Dialog_Template('com.landray.kmss.km.imeeting.model.KmImeetingTemplate','<c:url value="/km/imeeting/km_imeeting_main/kmImeetingMain.do" />?method=add&fdTemplateId=!{id}&fdTemplateName=!{name}');">
			</kmss:authShow>
		</c:if>
		<c:if test="${param.nodeType=='TEMPLATE'}">	
			<kmss:auth
				requestURL="/km/imeeting/km_imeeting_main/kmImeetingMain.do?method=add&fdTemplateId=${param.categoryId}&fdModelId=${param.fdModelId}&fdModelName=${param.fdModelName}"
				requestMethod="GET">
				<input type="button" value="<bean:message key="button.add"/>"
					onclick="Com_OpenWindow('<c:url value="/km/imeeting/km_imeeting_main/kmImeetingMain.do" />?method=add&fdTemplateId=${param.categoryId}&fdProjectId=${param.fdProjectId}&fdModelName=${param.fdModelName}');">
			</kmss:auth>
		</c:if>
		<kmss:auth requestURL="/km/imeeting/km_imeeting_main/kmImeetingMain.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmImeetingMainForm, 'deleteall');">
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
				<sunbor:column property="kmImeetingMain.fdName">
					<bean:message bundle="km-imeeting" key="kmImeetingMain.fdName"/>
				</sunbor:column>
				<sunbor:column property="kmImeetingMain.fdTemplate.fdName">
					<bean:message bundle="km-imeeting" key="kmImeetingMain.fdTemplate"/>
				</sunbor:column>
				<sunbor:column property="kmImeetingMain.fdHoldDate">
					<bean:message bundle="km-imeeting" key="kmImeetingMain.fdHoldDate"/>
				</sunbor:column>
				<sunbor:column property="kmImeetingMain.fdFinishDate">
					<bean:message bundle="km-imeeting" key="kmImeetingMain.fdFinishDate"/>
				</sunbor:column>
				<sunbor:column property="kmImeetingMain.fdPlace.fdName">
					<bean:message bundle="km-imeeting" key="kmImeetingMain.fdPlace"/>
				</sunbor:column>
				<sunbor:column property="kmImeetingMain.docCreator.fdName">
					<bean:message bundle="km-imeeting" key="kmImeetingMain.docCreator"/>
				</sunbor:column>
				<sunbor:column property="kmImeetingMain.docDept.fdName">
					<bean:message bundle="km-imeeting" key="kmImeetingMain.docDept"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmImeetingMain" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/km/imeeting/km_imeeting_main/kmImeetingMain.do" />?method=view&fdId=${kmImeetingMain.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmImeetingMain.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmImeetingMain.fdName}" />
				</td>
				<td>
					<c:out value="${kmImeetingMain.fdTemplate.fdName}" />
				</td>
				<td>
					<kmss:showDate value="${kmImeetingMain.fdHoldDate}" />
				</td>
				<td>
					<kmss:showDate value="${kmImeetingMain.fdFinishDate}" />
				</td>
				<td>
					<c:out value="${kmImeetingMain.fdPlace.fdName}" />
				</td>
				<td>
					<c:out value="${kmImeetingMain.docCreator.fdName}" />
				</td>
				<td>
					<c:out value="${kmImeetingMain.docDept.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
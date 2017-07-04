<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/km/imeeting/km_imeeting_template/kmImeetingTemplate.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/km/imeeting/km_imeeting_template/kmImeetingTemplate.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/km/imeeting/km_imeeting_template/kmImeetingTemplate.do" />?method=add&parentId=${param.parentId}');">
		</kmss:auth>
		<kmss:auth requestURL="/km/imeeting/km_imeeting_template/kmImeetingTemplate.do?method=deleteall&parentId=${param.parentId}">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmImeetingTemplateForm, 'deleteall');">
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
				<sunbor:column property="kmImeetingTemplate.fdName">
					<bean:message bundle="km-imeeting" key="kmImeetingTemplate.fdName"/>
				</sunbor:column>
				<sunbor:column property="kmImeetingTemplate.docCategory.fdId">
					<bean:message bundle="km-imeeting" key="kmImeetingTemplate.docCategoryId"/>
				</sunbor:column>
				<sunbor:column property="kmImeetingTemplate.fdOrder">
					<bean:message bundle="km-imeeting" key="kmImeetingTemplate.fdOrder"/>
				</sunbor:column>
				<sunbor:column property="kmImeetingTemplate.docCreator.fdName">
					<bean:message bundle="km-imeeting" key="kmImeetingTemplate.docCreatorId" />
				</sunbor:column>
				<sunbor:column property="kmImeetingTemplate.docCreateTime">
					<bean:message bundle="km-imeeting" key="kmImeetingTemplate.docCreateTime" />
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmImeetingTemplate" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/km/imeeting/km_imeeting_template/kmImeetingTemplate.do" />?method=view&fdId=${kmImeetingTemplate.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmImeetingTemplate.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmImeetingTemplate.fdName}" />
				</td>
				<td>
					<c:out value="${kmImeetingTemplate.docCategory.fdName}" />
				</td>
				<td>
					<c:out value="${kmImeetingTemplate.fdOrder}" />
				</td>
				<td>
					<c:out value="${kmImeetingTemplate.docCreator.fdName}" />
				</td>
				<td>
					<kmss:showDate value="${kmImeetingTemplate.docCreateTime}" type="date" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
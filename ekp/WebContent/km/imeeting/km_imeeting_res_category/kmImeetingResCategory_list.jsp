<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/km/imeeting/km_imeeting_res_category/kmImeetingResCategory.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/km/imeeting/km_imeeting_res_category/kmImeetingResCategory.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/km/imeeting/km_imeeting_res_category/kmImeetingResCategory.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/km/imeeting/km_imeeting_res_category/kmImeetingResCategory.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmImeetingResCategoryForm, 'deleteall');">
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
				<sunbor:column property="kmImeetingResCategory.fdName">
					<bean:message bundle="km-imeeting" key="kmImeetingResCategory.fdName"/>
				</sunbor:column>
				<sunbor:column property="kmImeetingResCategory.fdOrder">
					<bean:message bundle="km-imeeting" key="kmImeetingResCategory.fdOrder"/>
				</sunbor:column>
				<sunbor:column property="kmImeetingResCategory.fdParent.fdName">
					<bean:message bundle="km-imeeting" key="kmImeetingResCategory.fdParent"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmImeetingResCategory" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/km/imeeting/km_imeeting_res_category/kmImeetingResCategory.do" />?method=view&fdId=${kmImeetingResCategory.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmImeetingResCategory.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmImeetingResCategory.fdName}" />
				</td>
				<td>
					<c:out value="${kmImeetingResCategory.fdOrder}" />
				</td>
				<td>
					<c:out value="${kmImeetingResCategory.fdParent.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
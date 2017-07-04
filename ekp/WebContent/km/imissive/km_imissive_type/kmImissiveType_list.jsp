<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/km/imissive/km_imissive_type/kmImissiveType.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/km/imissive/km_imissive_type/kmImissiveType.do?method=add" requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/km/imissive/km_imissive_type/kmImissiveType.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/km/imissive/km_imissive_type/kmImissiveType.do?method=deleteall" requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmImissiveTypeForm, 'deleteall');">
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
				<sunbor:column property="kmImissiveType.fdName">
					<bean:message  bundle="km-imissive" key="kmImissiveType.fdName"/>
				</sunbor:column>
				<sunbor:column property="kmImissiveType.fdIsAvailable">
					<bean:message  bundle="km-imissive" key="kmImissiveType.fdIsAvailable"/>
				</sunbor:column>
				<sunbor:column property="kmImissiveType.docCreator.fdName">
					<bean:message  bundle="km-imissive" key="kmImissiveType.docCreateId"/>
				</sunbor:column>
				<sunbor:column property="kmImissiveType.docCreateTime">
					<bean:message  bundle="km-imissive" key="kmImissiveType.docCreateTime"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmImissiveType" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/km/imissive/km_imissive_type/kmImissiveType.do" />?method=view&fdId=${kmImissiveType.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmImissiveType.fdId}">
				</td>
				<td>${vstatus.index+1}</td>
				<td>
					<c:out value="${kmImissiveType.fdName}" />
				</td>
				<td>
					<sunbor:enumsShow value="${kmImissiveType.fdIsAvailable}" enumsType="common_yesno" />
				</td>
				<td>
					<c:out value="${kmImissiveType.docCreator.fdName}" />
				</td>
				<td>
					<kmss:showDate value="${kmImissiveType.docCreateTime}" type="datetime"/>
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
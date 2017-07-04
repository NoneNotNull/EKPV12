<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/km/imissive/km_imissive_emergency_grade/kmImissiveEmergencyGrade.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/km/imissive/km_imissive_emergency_grade/kmImissiveEmergencyGrade.do?method=add" requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/km/imissive/km_imissive_emergency_grade/kmImissiveEmergencyGrade.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/km/imissive/km_imissive_emergency_grade/kmImissiveEmergencyGrade.do?method=deleteall" requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmImissiveEmergencyGradeForm, 'deleteall');">
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
				<sunbor:column property="kmImissiveEmergencyGrade.fdName">
					<bean:message  bundle="km-imissive" key="kmImissiveEmergencyGrade.fdName"/>
				</sunbor:column>
				<sunbor:column property="kmImissiveEmergencyGrade.fdIsAvailable">
					<bean:message  bundle="km-imissive" key="kmImissiveEmergencyGrade.fdIsAvailable"/>
				</sunbor:column>
				<sunbor:column property="kmImissiveEmergencyGrade.docCreator.fdName">
					<bean:message  bundle="km-imissive" key="kmImissiveEmergencyGrade.docCreateId"/>
				</sunbor:column>
				<sunbor:column property="kmImissiveEmergencyGrade.docCreateTime">
					<bean:message  bundle="km-imissive" key="kmImissiveEmergencyGrade.docCreateTime"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmImissiveEmergencyGrade" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/km/imissive/km_imissive_emergency_grade/kmImissiveEmergencyGrade.do" />?method=view&fdId=${kmImissiveEmergencyGrade.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmImissiveEmergencyGrade.fdId}">
				</td>
				<td>${vstatus.index+1}</td>
				<td>
					<c:out value="${kmImissiveEmergencyGrade.fdName}" />
				</td>
				<td>
					<sunbor:enumsShow value="${kmImissiveEmergencyGrade.fdIsAvailable}" enumsType="common_yesno" />
				</td>
				<td>
					<c:out value="${kmImissiveEmergencyGrade.docCreator.fdName}" />
				</td>
				<td>
					<kmss:showDate value="${kmImissiveEmergencyGrade.docCreateTime}" type="datetime"/>
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
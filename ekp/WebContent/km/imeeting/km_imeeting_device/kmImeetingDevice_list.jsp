<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/km/imeeting/km_imeeting_device/kmImeetingDevice.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/km/imeeting/km_imeeting_device/kmImeetingDevice.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/km/imeeting/km_imeeting_device/kmImeetingDevice.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/km/imeeting/km_imeeting_device/kmImeetingDevice.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmImeetingDeviceForm, 'deleteall');">
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
				<sunbor:column property="kmImeetingDevice.fdName">
					<bean:message bundle="km-imeeting" key="kmImeetingDevice.fdName"/>
				</sunbor:column>
				<sunbor:column property="kmImeetingDevice.fdIsAvailable">
					<bean:message bundle="km-imeeting" key="kmImeetingDevice.fdIsAvailable"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmImeetingDevice" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/km/imeeting/km_imeeting_device/kmImeetingDevice.do" />?method=view&fdId=${kmImeetingDevice.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmImeetingDevice.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmImeetingDevice.fdName}" />
				</td>
				<td>
					<sunbor:enumsShow value="${kmImeetingDevice.fdIsAvailable}" enumsType="common_yesno" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
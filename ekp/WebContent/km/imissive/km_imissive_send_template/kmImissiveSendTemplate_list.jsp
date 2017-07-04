<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<c:import url="/sys/right/cchange_tmp_right/cchange_tmp_right_button.jsp" charEncoding="UTF-8">
	<c:param name="mainModelName" value="com.landray.kmss.km.imissive.model.KmImissiveSendMain" />
	<c:param name="tmpModelName" value="com.landray.kmss.km.imissive.model.KmImissiveSendTemplate" />
	<c:param name="templateName" value="fdTemplate" />
	<c:param name="authReaderNoteFlag" value="2" /> 
</c:import>
<html:form action="/km/imissive/km_imissive_send_template/kmImissiveSendTemplate.do">
	<div id="optBarDiv">
		<input type="button" value="<bean:message key="button.add"/>"
			onclick="Com_OpenWindow('<c:url value="/km/imissive/km_imissive_send_template/kmImissiveSendTemplate.do" />?method=add&parentId=${param.parentId}');">
	<kmss:auth
		requestURL="/km/imissive/km_imissive_send_template/kmImissiveSendTemplate.do?method=deleteall&parentId=${param.parentId}"
		requestMethod="GET">
		<input type="button" value="<bean:message key="button.delete"/>"
			onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmImissiveSendTemplateForm, 'deleteall');">
	</kmss:auth></div>
	<%
	if (((Page) request.getAttribute("queryPage")).getTotalrows() == 0) {
	%>
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
	<%
	} else {
	%>
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt"><input type="checkbox" name="List_Tongle"></td>
				<td width="40pt"><bean:message key="page.serial" /></td>

				<sunbor:column property="kmImissiveSendTemplate.fdName">
					<bean:message bundle="km-imissive" key="kmImissiveSendTemplate.fdName" />
				</sunbor:column>
				
				<sunbor:column property="kmImissiveSendTemplate.fdOrder">
					<bean:message bundle="km-imissive" key="kmImissiveSendTemplate.fdOrder" />
				</sunbor:column>

				<sunbor:column property="kmImissiveSendTemplate.docCreator">
					<bean:message bundle="km-imissive"
						key="kmImissiveSendTemplate.docCreatorId" />
				</sunbor:column>


				<sunbor:column property="kmImissiveSendTemplate.docCreateTime">
					<bean:message bundle="km-imissive"
						key="kmImissiveSendTemplate.docCreateTime" />
				</sunbor:column>

			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmImissiveSendTemplate"
			varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/km/imissive/km_imissive_send_template/kmImissiveSendTemplate.do" />?method=view&fdId=${kmImissiveSendTemplate.fdId}">
				<td><input type="checkbox" name="List_Selected"
					value="${kmImissiveSendTemplate.fdId}"></td>
				<td>${vstatus.index+1}</td>
				<td><c:out value="${kmImissiveSendTemplate.fdName}" /></td>
				<td><c:out value="${kmImissiveSendTemplate.fdOrder}"/></td>
				<td><c:out value="${kmImissiveSendTemplate.docCreator.fdName}" /></td>
				<td><sunbor:date value="${kmImissiveSendTemplate.docCreateTime}" /></td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp"%>
	<%
	}
	%>
</html:form>

<c:import url="/sys/workflow/include/sysWfTemplate_auditorBtn.jsp" charEncoding="UTF-8">
	<c:param name="fdModelName" value="com.landray.kmss.km.imissive.model.KmImissiveSendTemplate"/>
	<c:param name="cateid" value="${param.parentId}"/>
</c:import>
<%@ include file="/resource/jsp/list_down.jsp"%>

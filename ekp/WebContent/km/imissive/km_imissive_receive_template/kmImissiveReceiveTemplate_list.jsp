<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<c:import url="/sys/right/cchange_tmp_right/cchange_tmp_right_button.jsp" charEncoding="UTF-8">
	<c:param name="mainModelName" value="com.landray.kmss.km.imissive.model.KmImissiveReceiveMain" />
	<c:param name="tmpModelName" value="com.landray.kmss.km.imissive.model.KmImissiveReceiveTemplate" />
	<c:param name="templateName" value="fdTemplate" />
	<c:param name="authReaderNoteFlag" value="2" /> 
</c:import>
<html:form action="/km/imissive/km_imissive_receive_template/kmImissiveReceiveTemplate.do">
	<div id="optBarDiv">
		<input type="button" value="<bean:message key="button.add"/>"
			onclick="Com_OpenWindow('<c:url value="/km/imissive/km_imissive_receive_template/kmImissiveReceiveTemplate.do" />?method=add&parentId=${param.parentId}');">
	<kmss:auth
		requestURL="/km/imissive/km_imissive_receive_template/kmImissiveReceiveTemplate.do?method=deleteall&parentId=${param.parentId}"
		requestMethod="GET">
		<input type="button" value="<bean:message key="button.delete"/>"
			onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmImissiveReceiveTemplateForm, 'deleteall');">
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

				<sunbor:column property="kmImissiveReceiveTemplate.fdName">
					<bean:message bundle="km-imissive" key="kmImissiveReceiveTemplate.fdName" />
				</sunbor:column>
				
				<sunbor:column property="kmImissiveReceiveTemplate.fdOrder">
					<bean:message bundle="km-imissive" key="kmImissiveReceiveTemplate.fdOrder" />
				</sunbor:column>

				<sunbor:column property="kmImissiveReceiveTemplate.docCreator">
					<bean:message bundle="km-imissive"
						key="kmImissiveReceiveTemplate.docCreatorId" />
				</sunbor:column>


				<sunbor:column property="kmImissiveReceiveTemplate.docCreateTime">
					<bean:message bundle="km-imissive"
						key="kmImissiveReceiveTemplate.docCreateTime" />
				</sunbor:column>

			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmImissiveReceiveTemplate"
			varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/km/imissive/km_imissive_receive_template/kmImissiveReceiveTemplate.do" />?method=view&fdId=${kmImissiveReceiveTemplate.fdId}">
				<td><input type="checkbox" name="List_Selected"
					value="${kmImissiveReceiveTemplate.fdId}"></td>
				<td>${vstatus.index+1}</td>
				<td><c:out value="${kmImissiveReceiveTemplate.fdName}" /></td>
				<td><c:out value="${kmImissiveReceiveTemplate.fdOrder}"/></td>
				<td><c:out value="${kmImissiveReceiveTemplate.docCreator.fdName}" /></td>
				<td><sunbor:date value="${kmImissiveReceiveTemplate.docCreateTime}" /></td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp"%>
	<%
	}
	%>
</html:form>

<c:import url="/sys/workflow/include/sysWfTemplate_auditorBtn.jsp" charEncoding="UTF-8">
	<c:param name="fdModelName" value="com.landray.kmss.km.imissive.model.KmImissiveReceiveTemplate"/>
	<c:param name="cateid" value="${param.parentId}"/>
</c:import>
<%@ include file="/resource/jsp/list_down.jsp"%>

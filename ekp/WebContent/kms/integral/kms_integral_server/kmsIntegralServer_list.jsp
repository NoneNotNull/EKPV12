<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script type="text/javascript">
Com_IncludeFile("optbar.js|list.js");
function List_CheckSelect(checkName){
	if(checkName==null)
		checkName = List_TBInfo[0].checkName;
	var obj = document.getElementsByName("List_Selected");
	for(var i=0; i<obj.length; i++)
		if(obj[i].checked)
			return true;
	alert("<bean:message key="page.noSelect"/>");
	return false;
}
function setStartOrStop(checkName){
	return List_CheckSelect(checkName) && confirm("<bean:message key='kmsIntegralServer.start.or.stop'  bundle='kms-integral'/>");
}
</script>
<html:form action="/kms/integral/kms_integral_server/kmsIntegralServer.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/kms/integral/kms_integral_server/kmsIntegralServer.do?method=add" requestMethod="GET">
			<input type="button" value="<bean:message key="kms.integral.server.add" bundle="kms-integral"/>"
				onclick="Com_OpenWindow('<c:url value="/kms/integral/kms_integral_server/kmsIntegralServer.do" />?method=add');">
			<input type="button" value="<bean:message key="kmsIntegralServer.fdStart" bundle="kms-integral"/>"
				onclick="if(!setStartOrStop())return;Com_Submit(document.kmsIntegralServerForm, 'start');">
			<input type="button" value="<bean:message key="kmsIntegralServer.fdStop" bundle="kms-integral"/>"
				onclick="if(!setStartOrStop())return;Com_Submit(document.kmsIntegralServerForm, 'stop');">
		</kmss:auth>
		<kmss:auth requestURL="/kms/integral/kms_integral_server/kmsIntegralServer.do?method=deleteall" requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmsIntegralServerForm, 'deleteall');">
		</kmss:auth>
	</div>
	<% if (((Page)request.getAttribute("queryPage")).getTotalrows()==0){ %>
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
	<% }else{ %>
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt"><input type="checkbox" name="List_Tongle"></td>
				<td width="40pt"><bean:message key="page.serial"/></td>	
				<sunbor:column property="kmsIntegralServer.fdName">
					<bean:message  bundle="kms-integral" key="kmsIntegralServer.fdName"/>
				</sunbor:column>
				<sunbor:column property="kmsIntegralServer.fdPrefix">
					<bean:message  bundle="kms-integral" key="kmsIntegralServer.fdPrefix"/>
				</sunbor:column>		
				<sunbor:column property="kmsIntegralServer.fdStartOrStop">
					<bean:message  bundle="kms-integral" key="kmsIntegralServer.fdStartOrStop"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsIntegralServer" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/kms/integral/kms_integral_server/kmsIntegralServer.do" />?method=view&fdId=${kmsIntegralServer.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmsIntegralServer.fdId}">
				</td>
				<td>${vstatus.index+1}</td>
				<td>
					<c:out value="${kmsIntegralServer.fdName}" />
				</td>
				<td>
					<c:out value="${kmsIntegralServer.fdPrefix}" />
				</td>			
				<td>
					<c:if test="${kmsIntegralServer.fdStartOrStop==true }">
						<bean:message  bundle="kms-integral" key="kmsIntegralServer.fdStart"/>
					</c:if>
					<c:if test="${kmsIntegralServer.fdStartOrStop==false }">
						<bean:message  bundle="kms-integral" key="kmsIntegralServer.fdStop"/>
					</c:if>
				</td>				
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
<% } %>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>

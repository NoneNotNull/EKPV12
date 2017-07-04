<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script>
Com_AddEventListener(window,'load',function(){
	var newForm = document.forms[0];
	if('autocomplete' in newForm)
		newForm.autocomplete = "off";
	else
		newForm.setAttribute("autocomplete","off");
});
</script>
<html:form action="/tib/common/log/tib_common_log_opt/tibCommonLogOpt.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/tib/common/log/tib_common_log_opt/tibCommonLogOpt.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.tibCommonLogOptForm, 'deleteall');">
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
				<sunbor:column property="tibCommonLogOpt.fdPerson">
					<bean:message bundle="tib-common-log" key="tibCommonLogOpt.fdPerson"/>
				</sunbor:column>
				<sunbor:column property="tibCommonLogOpt.fdAlertTime">
					<bean:message bundle="tib-common-log" key="tibCommonLogOpt.fdAlertTime"/>
				</sunbor:column>
				<sunbor:column property="tibCommonLogOpt.fdUrl">
					<bean:message bundle="tib-common-log" key="tibCommonLogOpt.fdUrl"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="tibCommonLogOpt" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/tib/common/log/tib_common_log_opt/tibCommonLogOpt.do" />?method=view&fdId=${tibCommonLogOpt.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${tibCommonLogOpt.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${tibCommonLogOpt.fdPerson}" />
				</td>
				<td>
					<kmss:showDate value="${tibCommonLogOpt.fdAlertTime}" />
				</td>
				<td>
					<c:out value="${tibCommonLogOpt.fdUrl}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script type="text/javascript">
window.onload=function(){
	window.frameElement.style.height=(document.forms[0].offsetHeight + 90)+"px";
}
</script>
<html:form action="/sys/time/sys_time_vacation/sysTimeVacation.do">
	<div id="optBarDiv">
		<input type="button" value="<bean:message key="button.refresh"/>" onclick="location.reload();">
		<kmss:auth requestURL="/sys/time/sys_time_vacation/sysTimeVacation.do?method=add&sysTimeAreaId=${param.sysTimeAreaId}" requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/time/sys_time_vacation/sysTimeVacation.do" />?method=add&sysTimeAreaId=${param.sysTimeAreaId}');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/time/sys_time_vacation/sysTimeVacation.do?method=deleteall&sysTimeAreaId=${param.sysTimeAreaId}" requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysTimeVacationForm, 'deleteall');">
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
				<sunbor:column property="sysTimeVacation.fdName">
					<bean:message  bundle="sys-time" key="sysTimeVacation.fdName"/>
				</sunbor:column>
				<sunbor:column property="sysTimeVacation.hbmStartTime">
					<bean:message  bundle="sys-time" key="sysTimeVacation.time"/>
				</sunbor:column>
				<sunbor:column property="sysTimeVacation.docCreator.fdName">
					<bean:message  bundle="sys-time" key="sysTimeVacation.docCreatorId"/>
				</sunbor:column>
				<sunbor:column property="sysTimeVacation.docCreateTime">
					<bean:message  bundle="sys-time" key="sysTimeVacation.docCreateTime"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysTimeVacation" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/time/sys_time_vacation/sysTimeVacation.do" />?method=view&fdId=${sysTimeVacation.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysTimeVacation.fdId}">
				</td>
				<td>${vstatus.index+1}</td>
				<td>
					<c:out value="${sysTimeVacation.fdName}" />
				</td>
				<td>
					<kmss:showDate value="${sysTimeVacation.fdStartDate}" type='date'/>
					<kmss:showDate value="${sysTimeVacation.fdStartTime}" type='time'/>
					<bean:message  bundle="sys-time" key="sysTimeVacation.end"/>
					<kmss:showDate value="${sysTimeVacation.fdEndDate}" type='date'/>
					<kmss:showDate value="${sysTimeVacation.fdEndTime}" type='time'/>
				</td>
				<td>
					<c:out value="${sysTimeVacation.docCreator.fdName}" />
				</td>
				<td>
					<kmss:showDate value="${sysTimeVacation.docCreateTime}" type="datetime"/>
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
<% } %>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
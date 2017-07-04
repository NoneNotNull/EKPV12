<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script type="text/javascript">
window.onload=function(){
	window.frameElement.style.height=(document.forms[0].offsetHeight + 90)+"px";
}
</script>
<html:form action="/sys/time/sys_time_work/sysTimeWork.do">
	<div id="optBarDiv">
		<input type="button" value="<bean:message key="button.refresh"/>" onclick="location.reload();">
		<kmss:auth requestURL="/sys/time/sys_time_work/sysTimeWork.do?method=add&sysTimeAreaId=${param.sysTimeAreaId}" requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/time/sys_time_work/sysTimeWork.do" />?method=add&sysTimeAreaId=${param.sysTimeAreaId}');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/time/sys_time_work/sysTimeWork.do?method=deleteall&sysTimeAreaId=${param.sysTimeAreaId}" requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysTimeWorkForm, 'deleteall');">
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
				<sunbor:column property="sysTimeWork.hbmStartTime">
					<bean:message  bundle="sys-time" key="sysTimeWork.validTime"/>
				</sunbor:column>	
				<sunbor:column property="sysTimeWork.fdWeekStartTime">
					<bean:message  bundle="sys-time" key="sysTimeWork.week"/>
				</sunbor:column>	
				<sunbor:column property="sysTimeWork.docCreator.fdName">
					<bean:message  bundle="sys-time" key="sysTimeWork.docCreatorId"/>
				</sunbor:column>
				<sunbor:column property="sysTimeWork.docCreateTime">
					<bean:message  bundle="sys-time" key="sysTimeWork.docCreateTime"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysTimeWork" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/time/sys_time_work/sysTimeWork.do" />?method=view&fdId=${sysTimeWork.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysTimeWork.fdId}">
				</td>
				<td>${vstatus.index+1}</td>
				<td>
					<bean:message  bundle="sys-time" key="sysTimeWork.validTime.start"/>
					<kmss:showDate  value="${sysTimeWork.fdStartTime}" type="date"/>
					<bean:message  bundle="sys-time" key="sysTimeWork.validTime.end.middle"/>
					<c:if test="${sysTimeWork.fdEndTime != null || sysTimeWork.fdEndTime != ''}">
						<kmss:showDate value="${sysTimeWork.fdEndTime}" type="date"/>
					</c:if>
					<c:if test="${sysTimeWork.fdEndTime == null || sysTimeWork.fdEndTime == ''}">
						<bean:message  bundle="sys-time" key="sysTimeWork.validTime.end.list"/>
					</c:if>	
					
				</td>
				<td>
					<bean:message  bundle="sys-time" key="sysTimeWork.week.start"/>
					<sunbor:enumsShow value="${sysTimeWork.fdWeekStartTime}" enumsType="common_week_type"/>
					<bean:message  bundle="sys-time" key="sysTimeWork.week.end"/>
					<sunbor:enumsShow value="${sysTimeWork.fdWeekEndTime}" enumsType="common_week_type"/>
				</td>
				<td>
					<c:out value="${sysTimeWork.docCreator.fdName}" />
				</td>
				<td>
					<kmss:showDate value="${sysTimeWork.docCreateTime}" type="datetime"/>
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
<% } %>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
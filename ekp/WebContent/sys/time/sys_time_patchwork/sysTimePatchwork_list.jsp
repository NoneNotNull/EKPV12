<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script type="text/javascript">
window.onload=function(){
	window.frameElement.style.height=(document.forms[0].offsetHeight + 90)+"px";
}
</script>
<html:form action="/sys/time/sys_time_patchwork/sysTimePatchwork.do">
	<div id="optBarDiv">
		<input type="button" value="<bean:message key="button.refresh"/>" onclick="location.reload();">
		<kmss:auth requestURL="/sys/time/sys_time_patchwork/sysTimePatchwork.do?method=add&sysTimeAreaId=${param.sysTimeAreaId}" requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/time/sys_time_patchwork/sysTimePatchwork.do" />?method=add&sysTimeAreaId=${param.sysTimeAreaId}');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/time/sys_time_patchwork/sysTimePatchwork.do?method=deleteall&sysTimeAreaId=${param.sysTimeAreaId}" requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysTimePatchworkForm, 'deleteall');">
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
				<sunbor:column property="sysTimePatchwork.fdName">
					<bean:message  bundle="sys-time" key="sysTimePatchwork.fdName"/>
				</sunbor:column>
				<sunbor:column property="sysTimePatchwork.hbmStartTime">
					<bean:message  bundle="sys-time" key="sysTimePatchwork.time"/>
				</sunbor:column>
				<sunbor:column property="sysTimePatchwork.docCreator.fdName">
					<bean:message  bundle="sys-time" key="sysTimePatchwork.docCreatorId"/>
				</sunbor:column>
				<sunbor:column property="sysTimePatchwork.docCreateTime">
					<bean:message  bundle="sys-time" key="sysTimePatchwork.docCreateTime"/>
				</sunbor:column>	
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysTimePatchwork" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/time/sys_time_patchwork/sysTimePatchwork.do" />?method=view&fdId=${sysTimePatchwork.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysTimePatchwork.fdId}">
				</td>
				<td>${vstatus.index+1}</td>
				<td>
					<c:out value="${sysTimePatchwork.fdName}" />
				</td>
				<td>
					<kmss:showDate value="${sysTimePatchwork.fdStartTime}" type="date"/>
					<bean:message  bundle="sys-time" key="sysTimePatchwork.end" />
					<kmss:showDate value="${sysTimePatchwork.fdEndTime}" type="date"/>
				<td>
					<c:out value="${sysTimePatchwork.docCreator.fdName}" />
				</td>
				<td>
					<kmss:showDate value="${sysTimePatchwork.docCreateTime}" type="datetime"/>
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
<% } %>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
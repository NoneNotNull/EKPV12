<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<c:import url="/resource/jsp/search_bar.jsp" charEncoding="UTF-8">
	<c:param name="fdModelName" value="com.landray.kmss.sys.task.model.SysTaskMain" />
</c:import>
<div id="optBarDiv">
<kmss:auth requestURL="/sys/task/sys_task_main/sysTaskMain.do?method=add" requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/task/sys_task_main/sysTaskMain.do" />?method=add');">
		</kmss:auth>
<input  type="button" value="<bean:message key="button.search"/>" onclick="Search_Show();">		
</div>

<c:import url="/resource/jsp/calendarview.jsp" charEncoding="UTF-8">
		<c:param name="fdkey" value="calendar" />
		<c:param name="listType" value="30" />
		<c:param name="beanName" value="sysTaskMainCalendarAttentionService"/>
		<c:param name="showTime" value='false'/>
</c:import>
<script type="text/javascript">
<!--
var CALENDARVIEW_TASK_STATUS_INACTIVE = "1";
var CALENDARVIEW_TASK_STATUS_PROGRESS = "2";
var CALENDARVIEW_TASK_STATUS_COMPLETE = "3";
var CALENDARVIEW_TASK_STATUS_TERMINATE = "4";
var CALENDARVIEW_TASK_ICON_STATUS_INACTIVE = "STATUS_INACTIVE.gif";
var CALENDARVIEW_TASK_ICON_STATUS_PROGRESS = "STATUS_PROGRESS.gif";
var CALENDARVIEW_TASK_ICON_STATUS_COMPLETE = "STATUS_COMPLETE.gif";
var CALENDARVIEW_TASK_ICON_STATUS_TERMINATE = "STATUS_TERMINATE.gif";
function Calendar_GetNodeIcon(nodeType) {
	if(nodeType==CALENDARVIEW_TASK_STATUS_INACTIVE) {
		return CALENDARVIEW_IMGPATHPREFIX+CALENDARVIEW_TASK_ICON_STATUS_INACTIVE;
	}else if(nodeType==CALENDARVIEW_TASK_STATUS_PROGRESS){
		return CALENDARVIEW_IMGPATHPREFIX+CALENDARVIEW_TASK_ICON_STATUS_PROGRESS;
	}else if(nodeType==CALENDARVIEW_TASK_STATUS_COMPLETE){
		return CALENDARVIEW_IMGPATHPREFIX+CALENDARVIEW_TASK_ICON_STATUS_COMPLETE;
	}else if(nodeType==CALENDARVIEW_TASK_STATUS_TERMINATE){
		return CALENDARVIEW_IMGPATHPREFIX+CALENDARVIEW_TASK_ICON_STATUS_TERMINATE;		
	}
}
//-->
</script>
<%@ include file="/resource/jsp/list_down.jsp"%>
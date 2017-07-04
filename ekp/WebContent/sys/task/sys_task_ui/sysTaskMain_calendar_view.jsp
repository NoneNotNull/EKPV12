<%-- 已废弃，被calendar.jsp替代--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<c:import url="/resource/jsp/calendarview.jsp" charEncoding="UTF-8">
	<c:param name="fdkey" value="calendar" />
	<c:param name="listType" value="30" />
	<c:param name="beanName" value="${param.serviceBean}&fdStatusType=${param.fdStatusType}&fdQueryTimeType=${param.fdQueryTimeType}&fdModelId=${param.fdModelId}&fdModelName=${param.fdModelName}&fdKey=${param.fdKey}"/>
	<c:param name="showTime" value='false'/>
</c:import>
<script type="text/javascript">
var CALENDARVIEW_TASK_STATUS_INACTIVE = "1";
var CALENDARVIEW_TASK_STATUS_PROGRESS = "2";
var CALENDARVIEW_TASK_STATUS_COMPLETE = "3";
var CALENDARVIEW_TASK_STATUS_TERMINATE = "4";
var CALENDARVIEW_TASK_STATUS_OVERRULE = "5";
var CALENDARVIEW_TASK_ICON_STATUS_INACTIVE = "STATUS_INACTIVE.gif";
var CALENDARVIEW_TASK_ICON_STATUS_PROGRESS = "STATUS_PROGRESS.gif";
var CALENDARVIEW_TASK_ICON_STATUS_COMPLETE = "STATUS_COMPLETE.gif";
var CALENDARVIEW_TASK_ICON_STATUS_TERMINATE = "STATUS_TERMINATE.gif";
var CALENDARVIEW_TASK_ICON_STATUS_OVERRULE = "STATUS_OVERRULE.gif";
function Calendar_GetNodeIcon(nodeType) {
	if(nodeType==CALENDARVIEW_TASK_STATUS_INACTIVE) {
		return "${KMSS_Parameter_ContextPath}sys/task/images/"+CALENDARVIEW_TASK_ICON_STATUS_INACTIVE;
	}else if(nodeType==CALENDARVIEW_TASK_STATUS_PROGRESS){
		return "${KMSS_Parameter_ContextPath}sys/task/images/"+CALENDARVIEW_TASK_ICON_STATUS_PROGRESS;
	}else if(nodeType==CALENDARVIEW_TASK_STATUS_COMPLETE){
		return "${KMSS_Parameter_ContextPath}sys/task/images/"+CALENDARVIEW_TASK_ICON_STATUS_COMPLETE;
	}else if(nodeType==CALENDARVIEW_TASK_STATUS_TERMINATE){
		return "${KMSS_Parameter_ContextPath}sys/task/images/"+CALENDARVIEW_TASK_ICON_STATUS_TERMINATE;		
	}else if(nodeType==CALENDARVIEW_TASK_STATUS_OVERRULE){
		return "${KMSS_Parameter_ContextPath}sys/task/images/"+CALENDARVIEW_TASK_ICON_STATUS_OVERRULE;		
	}
}
function addRadioToCalendar(){
	var radio_value="${param.fdStatusType}";
	var select_value="${param.fdQueryTimeType}";
	var calendarHead = document.getElementById("calendar_head");
	var calendarHead_tr = calendarHead.getElementsByTagName("tr")[0];	
	var calendarHeadTd1 = document.createElement("td");
	calendarHead_tr.appendChild(calendarHeadTd1);
		
	calendarHeadTd1.setAttribute("align", "right");
	calendarHeadTd1.innerHTML = "<input type=\"radio\" name=\"radio_status\"  value=\"1\" style=\"font-size:10px\" checked onclick=\"requery();\"><bean:message bundle='sys-task' key='calendar.complete.false'/></input><input type=\"radio\" name=\"radio_status\" value=\"2\" style=\"font-size:10px\"  onclick=\"requery();\"><bean:message bundle='sys-task' key='calendar.complete.true'/></input>&nbsp;&nbsp;"
	var calendarHeadTd2 = document.createElement("td");
	calendarHead_tr.appendChild(calendarHeadTd2);
	calendarHeadTd2.setAttribute("align", "right");
	calendarHeadTd2.setAttribute("width", "10%");
	calendarHeadTd2.innerHTML = "<select id = \"select_time_id\" style=\"width:130px;font-size:10px\" onchange=\"requery()\";><option value=\"1\"><bean:message bundle='sys-task' key='calendar.select.createTime'/></option><option value=\"2\"><bean:message bundle='sys-task' key='calendar.select.completeTime'/></option><option value=\"3\"><bean:message bundle='sys-task' key='calendar.select.feedbackTime'/></option></select>"
	if(radio_value != undefined && radio_value !=""){
		if(radio_value == 2){
			document.getElementsByName("radio_status")[1].checked="true";
		}
	}
	if(select_value != undefined && select_value != ""){
		var select = document.getElementById("select_time_id");
		var selectIndex = select_value-1;
		for(var i = 0; i < select.options.lenght; i++){
			select.options[i].selected = "false";
		}
		select.options[selectIndex].selected = "true";
	}
}
function requery(){
	var radio = document.getElementsByName("radio_status");
	var select = document.getElementById("select_time_id");
	var fdStatusType = "";
	var fdQueryTimeType = "";
	for(var i = 0; i < radio.length; i++){
		if(radio[i].checked){
			fdStatusType = fdStatusType+radio[i].value;
		}
	}
	fdQueryTimeType = select.options[select.selectedIndex].value;
	var url = "${KMSS_Parameter_ContextPath}sys/task/sys_task_ui/sysTaskMain_calendar_view.jsp?serviceBean=${param.serviceBean}";
	url = Com_SetUrlParameter(url,"fdStatusType",fdStatusType);
	url = Com_SetUrlParameter(url,"fdQueryTimeType",fdQueryTimeType);
	url = Com_SetUrlParameter(url,"fdModelId","${param.fdModelId}");
	url = Com_SetUrlParameter(url,"fdModelName","${param.fdModelName}");
	url = Com_SetUrlParameter(url,"fdKey","${param.fdKey}");
	Com_OpenWindow(url,"_self");
}
addRadioToCalendar();
</script>
<%@ include file="/resource/jsp/list_down.jsp"%>
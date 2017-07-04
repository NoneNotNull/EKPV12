<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="body">
		<%--头部样式--%>
		<style>
			.calendar-setting{position: relative;padding-right: 20px!important;}
			.trig {border: 4px solid #fff;border-color: #ffd #8c8c8c;line-height: 7px;border-width: 4px 4px 0 4px;float: right;position: absolute;right: 10px;top: 15px;}
			.calendar_dropdown{ zoom:1; position:absolute; display:none; top:30px; right:0px; width:100px; padding:7px 2px; background:#929292; filter:alpha(opacity=80); min-width:47px; z-index:1000}
			.calendar_dropdown li{ list-style-position:outside; height:24px; line-height:24px; cursor:pointer; width:100%; zoom:1;}
			.calendar_dropdown li a{width:100%; color:#fefefe; padding:0px 5px; }
			.calendar_dropdown li:hover{ background:#47b5e6;}
			.setting_select_on{list-style:none; background-color:#c0c0c0 ;color: #1690d7!important;}
			.setting_select_on a{color: #2c8bc5!important;font-weight: bold;}
			.lui_calendar_content .fc-event,#calendar .lui_calendar_list_data{border: 1px solid #dceaf0;background-color: #dceaf0;}
		</style>
		<ui:calendar id="calendar" showStatus="view" mode="default"  layout="sys.task.calendar.default">
			<%--数据--%>
			<ui:source type="AjaxJson">
				{url:'/sys/task/sys_task_main/sysTaskIndex.do?method=calendar&fdStatusType=all&fdQueryTimeType=createTime'}
			</ui:source>
			<%--呈现--%>
			<ui:render type="Template">
				{$<a href="javascript:void(0);"  style="color:  white;"
						title="${ lfn:message('sys-task:sysTaskMain.docSubject') }:{%data['title']%}&#10;${ lfn:message('sys-task:table.sysTaskMainPerform') }:{%data['performs']%}&#10;${ lfn:message('sys-task:sysTaskMain.fdProgress') }:{%data['progress']%}%">
				<span class="textEllipsis" >$}
					if(data['fdStatus']=='1'){
						{$<img src="${LUI_ContextPath}/sys/task/images/STATUS_INACTIVE.gif" />$}
					}
					if(data['fdStatus']=='2'){
						{$<img src="${LUI_ContextPath}/sys/task/images/STATUS_PROGRESS.gif" />$}	
					}
					if(data['fdStatus']=='3'){
						{$<img src="${LUI_ContextPath}/sys/task/images/STATUS_COMPLETE.gif" />$}	
					}
					if(data['fdStatus']=='4'){
						{$<img src="${LUI_ContextPath}/sys/task/images/STATUS_TERMINATE.gif" />$}	
					}
					if(data['fdStatus']=='5'){
						{$<img src="${LUI_ContextPath}/sys/task/images/STATUS_OVERRULE.gif" />$}	
					}
					if(data['fdStatus']=='6'){
						{$<img src="${LUI_ContextPath}/sys/task/images/STATUS_CLOSE.gif" />$}	
					}
				{$<span style="color: #0b6eb3;">{%env.fn.formatText(data['title'])%}</span></span></a>$}
			</ui:render>
		</ui:calendar>
		<script>
			seajs.use(['lui/jquery','lui/dialog','lui/topic'], function($, dialog , topic) {
				//点击任务事件
				topic.subscribe('calendar.thing.click',function(arg){
					var fdId=arg.schedule.fdId;
					window.open('${LUI_ContextPath}/sys/task/sys_task_main/sysTaskMain.do?method=view&fdId='+fdId,"_blank");
				});
				//显示什么状态的任务
				window.changeStatus=function(element,fdStatusType){
					var url=LUI("calendar").source.url;
					LUI("calendar").source.setUrl(Com_SetUrlParameter(url,"fdStatusType",fdStatusType));//修改请求地址
					LUI('calendar').refreshSchedules();//重刷日历
					$(".calendar_status_dropdown li").removeClass("setting_select_on");
					$(element).parents("li").eq(0).addClass("setting_select_on");
				};
				//任务显示在什么时间位置
				window.changeDate=function(element,fdQueryTimeType){
					var url=LUI("calendar").source.url;
					LUI("calendar").source.setUrl(Com_SetUrlParameter(url,"fdQueryTimeType",fdQueryTimeType));//修改请求地址
					LUI('calendar').refreshSchedules();//重刷日历
					$(".calendar_date_dropdown li").removeClass("setting_select_on");
					$(element).parents("li").eq(0).addClass("setting_select_on");
				};
			});
		</script>
	</template:replace>
</template:include>
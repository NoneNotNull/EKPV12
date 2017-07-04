<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.list">
	<%--日历框架JS、CSS--%>
	<template:replace name="head">
		<link rel="Stylesheet" href="${LUI_ContextPath}/km/calendar/resource/css/calendar_main.css" />
	</template:replace>
	
	<%--页签标题--%>
	<template:replace name="title">${ lfn:message('km-calendar:module.km.calendar') }</template:replace>
	
	<template:replace name="nav">
	    <%-- 日历管理-新建日程 --%>
		<ui:combin ref="menu.nav.create">
			<ui:varParam name="title" value="${ lfn:message('km-calendar:module.km.calendar') }"></ui:varParam>
			<ui:varParam name="button">
				[
					{
						"text": "${ lfn:message('km-calendar:kmCalendarMain.opt.create') }",
						"href":"javascript:openEvent()",
						"icon": "lui_icon_l_icon_36"
					}
				]
			</ui:varParam>
		</ui:combin>
		<div class="lui_list_nav_frame">
	      <ui:accordionpanel>
		    	<c:import url="/km/calendar/import/nav.jsp" charEncoding="UTF-8">
		   			<c:param name="key" value="group"></c:param>
		   		</c:import>
		</ui:accordionpanel>
		</div>
	</template:replace>
	
	<%--右侧--%>
	<template:replace name="content">
		<script type="text/javascript">	
			seajs.use([
				'km/calendar/resource/js/dateUtil',
				'km/calendar/resource/js/calendar_group',
				'lui/jquery',
				'lui/topic',
				'lui/dialog'],
				 function(dateUtil,calendar,$,topic,dialog) {
				//群组类
				window.groupCalendar=calendar.GroupCalendarMode;

				//获取位置
				var getPos=function(evt,showObj){
					var sWidth=showObj.width();
					var sHeight=showObj.height();
					x=evt.pageX;
					y=evt.pageY;
					if(y+sHeight>$(window).height()){
						y-=sHeight;
					}
					if(x+sWidth>$(document.body).outerWidth(true)){
						x-=sWidth;
					}
					return {"top":y,"left":x};
				};
				
				//显示日程
				topic.subscribe('calendar.thing.click',function(arg){
					//是否显示内容
					if(arg.schedule.content){
	                	$("#calendar_content").html(arg.schedule.content);
	                	$("#tr_content").show();
	                }else{
	                	$("#tr_content").hide();
	                }
	                //是否有提醒
	                if(arg.schedule.hasSettedRemind=="true"){
		                $("#calendar_remind_icon").show();
	                }else{
	                	$("#calendar_remind_icon").hide();
	                }
	                //是否显示标签
	                if(arg.schedule.labelId){
		                $("#labelId_view").val(arg.schedule.labelId);
	                }else{
	                	$("#labelId_view").val("");
	                }
	                //共享日程,判断是否有操作权限
	                $("#calendar_view_btn").hide();
	                $.post('<c:url value="/km/calendar/km_calendar_main/kmCalendarMain.do?method=checkEditAuth"/>',
	    	           $.param({"calendarId":arg.schedule.id},true),function(data){
							if(data['canEdit']==true){
								 $("#calendar_view_btn").show();
								 $("#button_delete_event").hide();
								 $("#div_remind_label_edit").hide();
								 $("#button_save_event").hide();
							}
    	                },'json');
					//显示时间
					var formatDate=Com_Parameter['Lang']!=null && Com_Parameter['Lang']=='zh-cn'?"yyyy年MM月dd日":"MM/dd/yyyy";
					if(!arg.schedule.allDay){
						formatDate+=" HH:mm";
					}
					var DateString=dateUtil.formatDate(arg.schedule.start,formatDate);
					if(arg.schedule.end!=null){
						DateString+="-"+dateUtil.formatDate(arg.schedule.end,formatDate);
					}
					$("#calendar_date").html(DateString);//初始化日期
					$("#calendar_title").html(arg.schedule.title);
					$("#calendarViewForm :input[name='fdId']").val(arg.schedule.id);
					$("#calendar_view").css(getPos(arg.evt,$("#calendar_view"))).fadeIn("fast");
				});

				//群组日程导出
				window.kmCalendarExport=function(){
					var url="/km/calendar/km_calendar_main/kmCalendarMain_setTime.jsp?type=groupCalendar";
					var locationUrl=LUI("calendar").source.url;
					url+="&groupId="+Com_GetUrlParameter(locationUrl,"groupId");//
					dialog.iframe(url,"${lfn:message('km-calendar:kmCalendarMain.exportGroupTitle')}",function(){
						
					},{width:550,height:350});
				};
				
			});
		</script>
		<ui:calendar id="calendar" showStatus="edit" mode="groupCalendar"  layout="km.calendar.group" customMode="{'id':'groupCalendar','name':'群组日历','func':groupCalendar}">
			<ui:source type="AjaxJson">
				{url:'/km/calendar/km_calendar_main/kmCalendarMain.do?method=listGroupCalendar&groupId=${param.groupId}'}
			</ui:source>
			
		</ui:calendar>
		 
		 <%--查看日程DIV--%>
		<%@ include file="/km/calendar/km_calendar_main/kmCalendarMain_view.jsp"%>
		 <%--新建日程DIV--%>
		 <%@ include file="/km/calendar/km_calendar_main/kmCalendarMain_edit.jsp"%>
		 
	</template:replace>
</template:include>

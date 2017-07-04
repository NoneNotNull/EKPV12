<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ page import=" com.landray.kmss.util.ResourceUtil"%>
<%@ page import="com.landray.kmss.sys.mobile.util.MobileUtil"%>
<%@ page import="com.landray.kmss.common.actions.RequestContext"%>
<%
	request.setAttribute("dateFormatter", ResourceUtil.getString("date.format.date"));
	request.setAttribute("dateTimeFormatter",ResourceUtil.getString("date.format.datetime"));
	//UA=mobile跳转到移动端的主页(临时解决方案)
	if(MobileUtil.getClientType(new RequestContext(request)) > -1){
		response.sendRedirect("mobile/index.jsp");
	}
%>
<c:set var="form"  value="kmCalendarMainForm"></c:set>
<template:include ref="default.list">
	<%--日历框架JS、CSS--%>
	<template:replace name="head">
		<link rel="Stylesheet" href="${LUI_ContextPath}/km/calendar/resource/css/calendar_main.css" />
		<script>
			seajs.use(['km/calendar/resource/js/dateUtil'], function(dateUtil) {
				window.kmcalendarDateUtil=dateUtil;
			});
		</script>
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
		   			<c:param name="key" value="calendar"></c:param>
		   		</c:import>
			</ui:accordionpanel>
		</div>
	</template:replace>
	
	<%--右侧--%>
	<template:replace name="content">
		<script type="text/javascript">	
			seajs.use(['lui/jquery','lui/dialog','lui/topic','lui/toolbar'], function($,dialog , topic ,toolbar) {

				// 监听新建更新等成功后刷新
				topic.subscribe('successReloadPage', function() {
					topic.publish('list.refresh');
				});

				//获取位置
				var getPos=function(evt,showObj){
					var sWidth=showObj.width();var sHeight=showObj.height();
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

				//选择日程事件
				topic.subscribe('calendar.select',function(arg){
					$("#calendar_add,#calendar_view,#note_view").hide();//隐藏所有弹出框
					//初始化时间
					var start=arg.start;
					var end=arg.end;
					if(end==null){
						end=start;
					}
					$("#calendar_add :input[name='docStartTime']").val(kmcalendarDateUtil.formatDate(start,"${dateFormatter}"));
				    $("#calendar_add :input[name='docFinishTime']").val(kmcalendarDateUtil.formatDate(end,"${dateFormatter}"));
				    //是否全天
				    $("#fdIsAlldayevent").attr("checked",arg.allDay);
				    if(arg.allDay){
				    	$("#startTimeDiv,#endTimeDiv").css("display","none");
				    	$("[name='startHour'],[name='startMinute'],[name='endHour'],[name='endMinute']").val(0);
					}else{
						$("#startTimeDiv,#endTimeDiv").css("display","inline");
						$("[name='startHour']").val(start.getHours());
				 	    $("[name='startMinute']").val(start.getMinutes());
				 	    $("[name='endHour']").val(end.getHours());
				 	    $("[name='endMinute']").val(end.getMinutes());
					}
					//初始化标签
					if(LUI("label_edit")){
						LUI("label_edit").source.get();
					}
					//显示
	                $("#calendar_add").css(getPos(arg.evt,$("#calendar_add"))).fadeIn("fast");
	                $("#simple_fdType_event").val("event");
	                $("#simple_fdType_note").val("note");
					
					// 默认显示event编辑页面
	                $('#tab_event').addClass("current");
					$('#tab_note').removeClass("current");
					$('#simple_calendarTab').show();
					$('#simple_noteTab').hide();
				});
				
				//拖拽日程
				topic.subscribe('calendar.thing.change',function(arg){
					$("#calendar_add,#calendar_view,#note_view").hide();//隐藏所有弹出框
					var fdId=arg.schedule.id;	
					if(arg.end==null){
						arg.end=kmcalendarDateUtil.cloneDate(arg.start);
						arg.end.setHours(arg.end.getHours()+1);
					}
					window.loading = dialog.loading();
					var param={
							"fdId":fdId,
							"dayDelta":arg.dayDelta,
							"minuteDelta":arg.minuteDelta,
							"isAllDayEvent":arg.schedule.allDay,
							"resize":arg.resize
					};
					$.post('<c:url value="/km/calendar/km_calendar_main/kmCalendarMain.do?method=updateCalendarTime"/>',
						$.param(param,true),function(data){
							if(window.loading!=null) window.loading.hide();
							//操作成功
							if(data!=null && data.status==true){
								if(data.isRecurrence==true){//重复日程拖拽更新后直接刷新整个页面
									LUI("calendar").refreshSchedules();
								}else{//非重复不刷新
									arg.schedule.start=arg.start;
									arg.schedule.end=arg.end;
									LUI("calendar").updateSchedule(arg.schedule);
								}
							}
							//操作失败
							else{
								dialog.success('<bean:message key="return.optFailure" />');
								arg.moveFun();
							}
					},'json');
				});

				window.labelId_select = "";
				window.setLabelSelected=function(){
					$("#calendarViewForm :input[name='labelId']").val(labelId_select);
				};
				
				//显示日程
				topic.subscribe('calendar.thing.click',function(arg){
					$("#calendar_add,#calendar_view,#note_view").hide();//隐藏所有弹出框
					$("#calendar_view_btn").show();//我的日程,默认一定显示操作栏
					if("note"!=arg.schedule.type){
						//初始化标签
						if(LUI("label_view")){
							LUI("label_view").source.get();
						 	if(arg.schedule.labelId){//标签
			                	labelId_select = arg.schedule.labelId;
				                //setTimeout("setLabelSelected()",100);
				            }else{
				            	labelId_select="";
			                }
						}
						//初始化内容
						if(arg.schedule.content){
		                	$("#calendar_content").html(arg.schedule.content);
		                	$("#tr_content").show();
		                }else{
		                	$("#tr_content").hide();
		                }
		                //初始化链接
		                if(arg.schedule.relationUrl){
			                var relationUrl = arg.schedule.relationUrl;
		                	if(relationUrl.length>4 && relationUrl.substring(0,4)!="http"){
		                		relationUrl = '${LUI_ContextPath}' + relationUrl;
		                	}
		                	$("#calendar_relatation_url").attr("href",relationUrl);
		                	$("#tr_relation_url").show();
		                }else{
		                	$("#tr_relation_url").hide();
		                }
		              //初始化提醒
		                if(arg.schedule.hasSettedRemind=="true"){
			                $("#calendar_remind_icon").show();
		                	$("#calendar_remind_icon").removeClass("unremind");
		                }else{
		                	$("#calendar_remind_icon").hide();
		                }
						//显示时间
						var formatDate=Com_Parameter['Lang']!=null && Com_Parameter['Lang']=='zh-cn'?"yyyy年MM月dd日":"MM/dd/yyyy";
						if(!arg.schedule.allDay){
							formatDate+=" HH:mm";
						}
		                var DateString=kmcalendarDateUtil.formatDate(arg.schedule.start,formatDate);
						if(arg.schedule.end!=null){
							DateString+="-"+kmcalendarDateUtil.formatDate(arg.schedule.end,formatDate);
						}
						$("#calendar_date").html(DateString);//初始化日期
						$("#calendar_title").html(arg.schedule.title);
						$("#calendarViewForm :input[name='fdId']").val(arg.schedule.id);
						$("#calendar_view").css(getPos(arg.evt,$("#calendar_view"))).fadeIn("fast");
					}else{
						if(arg.schedule.content){//内容
							var content=arg.schedule.content.replace(/<\/?[^>]*>/g,'').replace(/[ | ]*\n/g,'\n');//简单页面不显示图片,和更新后的p标签
							if(content.length>200){//截取前200个字符显示在简单页面
								content=content.substring(0,200)+"...";
							}
		                	$("#note_docContent").html(content);
		                }else{
		                	$("#note_docContent").html("");
		                }
						$("#note_subject").html(arg.schedule.title);
						$("#noteViewForm :input[name='fdId']").val(arg.schedule.id);
						$("#note_view").css(getPos(arg.evt,$("#note_view"))).fadeIn("fast");
					}
				});
				
				//初始化默认标签的颜色,针对单个日程
				window.setColor=function(schedule){
					var eventColor=$(".lui_calendar_color_event").eq(0).css("background-color");//默认日程颜色
					var noteColor=$(".lui_calendar_color_note").eq(0).css("background-color");//笔记颜色
					if(schedule.type=="note"){
						schedule.color=noteColor;
					}else if(schedule.color==null||schedule.color==""){
						schedule.color=eventColor;
					}
				};
				
				//初始化默认标签的颜色,针对集合
				window.setColors=function(data){
					for(var i=0;i<data.length;i++){
						setColor(data[i]);
					}
					return data;
				};

				//个人日程导出
				window.kmCalendarExport=function(){
					var url="/km/calendar/km_calendar_main/kmCalendarMain_setTime.jsp?type=myCalendar";
					dialog.iframe(url,"${lfn:message('km-calendar:kmCalendarMain.exportSelfTitle')}",function(){
						
					},{width:550,height:350});
				};
				
			});
		</script>
		<ui:calendar id="calendar" showStatus="drag" mode="default" layout="km.calendar.default">
			<ui:dataformat>
				<ui:source type="AjaxJson">
					{url:'/km/calendar/km_calendar_main/kmCalendarMain.do?method=data&exceptLabelIds=${param.exceptLabelIds}'}
				</ui:source>
				<ui:transform type="ScriptTransform">
					return setColors(data);
				</ui:transform>
			</ui:dataformat>
			<ui:render type="Template">
				{$<p title="{%data['title']%}">$}
				var str="";
				var start=kmcalendarDateUtil.parseDate(data['start']);
				if(data['allDay']=='1'){
					str+="${lfn:message('km-calendar:kmCalendarMain.allDay')} ";
				}else{
					var hours=start.getHours()<10?"0"+start.getHours():start.getHours();
					var minutes=start.getMinutes()<10?"0"+start.getMinutes():start.getMinutes();
					str+=hours+":"+minutes+" "
				}
				if(data['title']){
					str+=env.fn.formatText(data['title'].replace(/(\n)+|(\r\n)+/g, " "));
				}
				{$<span class="textEllipsis">{%str%}</span></p>$}
			</ui:render>
		</ui:calendar>
		 
		 <%--查看日程DIV--%>
		<%@ include file="/km/calendar/km_calendar_main/kmCalendarMain_view.jsp"%>
		 <%--新建日程DIV--%>
		 <%@ include file="/km/calendar/km_calendar_main/kmCalendarMain_edit.jsp"%>
		 
	</template:replace>
</template:include>

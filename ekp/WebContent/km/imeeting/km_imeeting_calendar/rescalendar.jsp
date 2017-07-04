<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ page import=" com.landray.kmss.util.ResourceUtil"%>
<%request.setAttribute("dateTimeFormatter",ResourceUtil.getString("date.format.datetime"));%>
<template:include ref="default.list">
	<template:replace name="head">
		<script>
			
		</script>
		<link rel="Stylesheet" href="${LUI_ContextPath}/km/imeeting/km_imeeting_calendar/calendar.css" />
	</template:replace>

	<%-- 标签页标题 --%>
	<template:replace name="title">
		<c:out value="${lfn:message('km-imeeting:module.km.imeeting')}"></c:out>
	</template:replace>
	
	<%-- 导航路径 --%>
	<template:replace name="path"> 
		<ui:menu layout="sys.ui.menu.nav"  id="categoryId"> 
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home" href="/" target="_self"></ui:menu-item>
			<ui:menu-item text="${ lfn:message('km-imeeting:module.km.imeeting') }" href="/km/imeeting/" target="_self"></ui:menu-item>
			<ui:menu-item text="${ lfn:message('km-imeeting:kmImeeting.tree.calender') }" href="/km/imeeting/index.jsp" target="_self">
				<ui:menu-item text="${ lfn:message('km-imeeting:table.kmImeetingMain') }" href="/km/imeeting/km_imeeting_main/index.jsp" target="_self"></ui:menu-item>
			   	<ui:menu-item text="${ lfn:message('km-imeeting:table.kmImeetingStat') }" href="/km/imeeting/km_imeeting_stat/index.jsp?stat_key=dept.stat" target="_self"></ui:menu-item>
			   	<ui:menu-item text="${ lfn:message('km-imeeting:kmImeeting.tree.summary') }" href="/km/imeeting/km_imeeting_summary/index.jsp" target="_self"></ui:menu-item>
			</ui:menu-item>
			<ui:menu-item text="${ lfn:message('km-imeeting:kmImeeting.tree.calender.rescalendar') }" href="#" target="_self">
				<ui:menu-item text="${ lfn:message('km-imeeting:kmImeeting.tree.calender.mycalendar') }" href="/km/imeeting/km_imeeting_calendar/mycalendar.jsp" target="_self"></ui:menu-item>
			</ui:menu-item>
		</ui:menu>
	</template:replace>
	
	<%-- 左侧导航栏 --%>
	<template:replace name="nav">
		
		<ui:combin ref="menu.nav.create">
			<ui:varParam name="title" value="${ lfn:message('km-imeeting:kmImeeting.tree.title') }"></ui:varParam>
			<%-- 会议导航 --%>
			<ui:varParam name="button">
				[
				   <kmss:authShow roles="ROLE_KMIMEETING_CREATE">
					{
						"text": "${lfn:message('km-imeeting:table.kmImeetingMain')}",
						"href":"javascript:addDoc();",
						"icon": "lui_icon_l_icon_36"
					}
					</kmss:authShow>
				]
			</ui:varParam>
		</ui:combin>
		
		<div class="lui_list_nav_frame">
			<ui:accordionpanel>
				<c:import url="/km/imeeting/import/nav.jsp" charEncoding="UTF-8">
					<c:param name="key" value="calendar"></c:param>
				   	<c:param name="criteria" value="res"></c:param>
				</c:import>
			</ui:accordionpanel>
		</div>
	
	</template:replace>
	
	<%-- 右侧内容区域 --%>
	<template:replace name="content"> 
		
		<script>
			seajs.use([
				'lui/dialog',
				'lui/topic',
				'lui/jquery',
				'km/imeeting/resource/js/dateUtil'
				], function(dialog,topic,$,dateUtil) {

					// 监听新建更新等成功后刷新
					topic.subscribe('successReloadPage', function() {
						setTimeout(function(){
							LUI('calendar').refreshSchedules();
						}, 100);
					});

					//新建会议
			 		window.addDoc = function() {
							dialog.categoryForNewFile(
									'com.landray.kmss.km.imeeting.model.KmImeetingTemplate',
									'/km/imeeting/km_imeeting_main/kmImeetingMain.do?method=add&fdTemplateId=!{id}',false,null,null,'${param.categoryId}');
				 	};

					//数据初始化
					window.transformData=function(datas){
						var main=datas.main;
						for(var key in main){
							for(var i=0;i<main[key].list.length;i++){
								var item=main[key].list[i];
								if(checkStatus(item)==-1){
									item.color=$('.meeting_calendar_label_unhold').css('background-color');
								}
								if(checkStatus(item)==0){
									item.color=$('.meeting_calendar_label_holding').css('background-color');
								}
								if(checkStatus(item)==1){
									item.color=$('.meeting_calendar_label_hold').css('background-color');
								}
							}
						}
						return datas;
					};

					//当前会议状态
					var checkStatus=function(item){
						var startDate=dateUtil.parseDate(item.start),endDate=dateUtil.parseDate(item.end);
						var now=new Date();
						//未召开
						if(now.getTime()<startDate.getTime()){
							return -1;
						}
						//进行中
						if(now.getTime()>=startDate.getTime() && now.getTime()<=endDate.getTime()){
							return 0;
						}
						//已召开
						if(now.getTime()>endDate.getTime()){
							return 1;
						}
					};
				
					//定位
					var getPos=function(evt,obj){
						var sWidth=obj.width();var sHeight=obj.height();
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
					
					//新建
					topic.subscribe('calendar.select',function(arg){
						$('.meeting_calendar_dialog').hide();
						var addDialog=$('#meeting_calendar_add');
						//时间格式2014-7-11~2014-7-12
						var date=arg.start;
						if(arg.start!=arg.end){
							date+="~"+arg.end;
						}
						addDialog.find('.date').html(date);//时间字符串
						addDialog.find('.fdHoldDate').html(arg.start);//召开时间
						addDialog.find('.fdFinishDate').html(arg.end);//结束时间
						addDialog.find('.resId').html(arg.resId);//地点ID
						addDialog.find('.resName').html(arg.resName);//地点
						addDialog.css(getPos(arg.evt,addDialog)).fadeIn("fast");
					});

					//查看
					topic.subscribe('calendar.thing.click',function(arg){
						$('.meeting_calendar_dialog').hide();
						var viewDialog;//弹出框
						if(arg.data.type =="book"){
							viewDialog=$("#meeting_calendar_bookview");//会议室预约弹出框
							viewDialog.find(".fdRemark").html(textEllipsis(arg.data.fdRemark));//备注
						}else{
							viewDialog=$("#meeting_calendar_mainview");//会议安排弹出框
							viewDialog.find(".fdHost").html(arg.data.fdHost);//主持人
						}
						//时间格式2014-7-11~2014-7-12
						var date=dateUtil.formatDate(arg.data.start,"${dateTimeFormatter}");
						if(arg.data.start!=arg.data.end){
							date+=" ~ "+dateUtil.formatDate(arg.data.end,"${dateTimeFormatter}");
						}
						viewDialog.find(".fdId").html(arg.data.fdId);//fdId
						viewDialog.find(".fdName").html(arg.data.title);//会议题目
						viewDialog.find(".fdPlace").html(arg.data.fdPlaceName);//地点
						viewDialog.find(".fdHoldDate").html(date);//召开时间

						var creator=arg.data.creator;
						if(arg.data.dept){
							creator+="("+arg.data.dept+")";//（部门）
						}
						viewDialog.find(".docCreator").html(creator);//人员（部门）
						
						if(arg.data.type=="book"){//会议预约按钮权限检测
							$('#book_delete_btn,#book_edit_btn').hide();
							$.ajax({
								url: "${LUI_ContextPath}/km/imeeting/km_imeeting_book/kmImeetingBook.do?method=checkAuth",
								type: 'POST',
								dataType: 'json',
								data: {fdId: arg.data.fdId},
								success: function(data, textStatus, xhr) {//操作成功
									if(data.canEdit){
										$('#book_edit_btn').show();
									}
									if(data.canDelete){
										$('#book_delete_btn').show();
									}
								}
							});
						}else{//会议安排查看按钮权限检测
							$('#meeting_view_btn').hide();
							$.ajax({
								url: "${LUI_ContextPath}/km/imeeting/km_imeeting_main/kmImeetingMain.do?method=checkViewAuth",
								type: 'POST',
								dataType: 'json',
								data: {fdId: arg.data.fdId},
								success: function(data, textStatus, xhr) {//操作成功
									if(data.canView){
										$('#meeting_view_btn').show();
									}
								}
							});
						}
						viewDialog.css(getPos(arg.evt,viewDialog)).fadeIn("fast");
					});
					
					//字符串截取
					function textEllipsis(text){
						if(text.length>200){
							text=text.substring(0,200)+"......";
						}
						return text;
					}
			});
		</script>
		<ui:calendar id="calendar" showStatus="drag" mode="meetingCalendar"  layout="km.imeeting.calendar.default" customMode="{'id':'meetingCalendar','name':'会议日历','func':'km/imeeting/km_imeeting_calendar/calendar'}">
			<%--数据--%>
			<ui:dataformat>
				<ui:source type="AjaxJson">
					{url:'/km/imeeting/km_imeeting_calendar/kmImeetingCalendar.do?method=rescalendar'}
				</ui:source>
				<ui:transform type="ScriptTransform">
					return transformData(data);
				</ui:transform>
			</ui:dataformat>
		</ui:calendar>
		<%@ include file="/km/imeeting/km_imeeting_calendar/kmImeetingCalendar_edit.jsp"%>
		<%@ include file="/km/imeeting/km_imeeting_calendar/kmImeetingCalendar_view.jsp"%>
	</template:replace>
</template:include>
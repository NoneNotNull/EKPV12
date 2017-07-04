<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ page import=" com.landray.kmss.util.ResourceUtil"%>
<%request.setAttribute("dateTimeFormatter",ResourceUtil.getString("date.format.datetime"));%>
<template:include ref="default.list">
	
	<template:replace name="head">
		<link rel="Stylesheet" href="${LUI_ContextPath}/km/imeeting/km_imeeting_calendar/calendar.css" />
		<script>
			seajs.use(['km/imeeting/resource/js/dateUtil'], function(dateUtil) {
				window.dateUtil=dateUtil;
			});
		</script>
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
			<ui:menu-item text="${ lfn:message('km-imeeting:kmImeeting.tree.calender.mycalendar') }" href="#" target="_self">
				<ui:menu-item text="${ lfn:message('km-imeeting:kmImeeting.tree.calender.rescalendar') }" href="/km/imeeting/index.jsp" target="_self"></ui:menu-item>
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
				   	<c:param name="criteria" value="my"></c:param>
				</c:import>
			</ui:accordionpanel>
		</div>
	
	</template:replace>
	
	<%-- 右侧内容区域 --%>
	<template:replace name="content">
		<ui:calendar id="calendar" showStatus="view" mode="default">
			<%--数据--%>
			<ui:source type="AjaxJson">
				{url:'/km/imeeting/km_imeeting_calendar/kmImeetingCalendar.do?method=mycalendar'}
			</ui:source>
			<ui:render type="Template">
				var formaStr=seajs.data.env.pattern.datetime+"{ ' ~ ' "+seajs.data.env.pattern.datetime+"}";
				var title=dateUtil.formatDate(data['start'],formaStr)+" ~ "+dateUtil.formatDate(data['end'],formaStr);
				title+="&#xd;"+data['title'];
				{$<p title="{%title%}" style="cursor: pointer;">$}
				var str="";
				var hours=data['start'].getHours()<10?"0"+data['start'].getHours():data['start'].getHours();
				var minutes=data['start'].getMinutes()<10?"0"+data['start'].getMinutes():data['start'].getMinutes();
				str+=hours+":"+minutes+" "
				if(data['title']){
					str+=env.fn.formatText(data['title'].replace(/(\n)+|(\r\n)+/g, " "));
				}
				{$<span class="textEllipsis">{%str%}</span></p>$}
			</ui:render>
			<%--不显示全天（会议不存在全天）--%>
			<ui:event event="viewOrModeChange">
				$('.fc-agenda-allday').hide();
			</ui:event>
		</ui:calendar>
		
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

					//查看
					topic.subscribe('calendar.thing.click',function(arg){
						$('.meeting_calendar_dialog').hide();
						var viewDialog;//弹出框
						viewDialog=$("#meeting_calendar_mainview");//会议安排弹出框
						viewDialog.find(".fdHost").html(arg.schedule.fdHost);//主持人
						//时间格式2014-7-11~2014-7-12
						var date=dateUtil.formatDate(arg.schedule.start,"${dateTimeFormatter}");
						if(arg.schedule.start!=arg.schedule.end){
							date+=" ~ "+dateUtil.formatDate(arg.schedule.end,"${dateTimeFormatter}");
						}
						var creator=arg.schedule.creator;
						if(arg.schedule.dept){
							creator+="("+arg.schedule.dept+")";//（部门）
						}
						viewDialog.find(".docCreator").html(creator);//人员（部门）
						viewDialog.find(".fdId").html(arg.schedule.fdId);//fdId
						viewDialog.find(".fdName").html(arg.schedule.title);//会议题目
						viewDialog.find(".fdPlace").html(arg.schedule.fdPlaceName);//地点
						viewDialog.find(".fdHoldDate").html(date);//召开时间
						viewDialog.css(getPos(arg.evt,viewDialog)).fadeIn("fast");
					});
			});
		</script>
		<%@ include file="/km/imeeting/km_imeeting_calendar/kmImeetingCalendar_view.jsp"%>
	</template:replace>
</template:include>
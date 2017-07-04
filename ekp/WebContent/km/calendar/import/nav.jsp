<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<c:set var="key" value="${param.key}"/>
<%--我的日历--%>
<ui:content title="${lfn:message('km-calendar:module.km.calendar.tree.my.calendar')}" >
	<ul class='lui_list_nav_list'>
		<ui:dataview id="label_nav">
			<ui:source type="AjaxJson">
				{url:'/km/calendar/km_calendar_label/kmCalendarLabel.do?method=listJson&init=true'}
			</ui:source>
			<ui:render type="Template">
				<c:import url="/km/calendar/tmpl/label_nav.jsp" charEncoding="UTF-8"></c:import>
			</ui:render>
		</ui:dataview>
 	</ul>  
 	<ui:operation href="javascript:kmCalendarList()"  target="_self" name="${lfn:message('km-calendar:kmCalendarLabel.tab.list')}"   />
</ui:content>
<%--群组日程--%>
<ui:content title="${lfn:message('km-calendar:kmCalendar.nav.share.group')}" >
	<%--日程分组提示--%>
 	<div style="position: relative;width: 100%"><div id="group_tips"  style="display: none">
		 	<a class="group_tips_close" title="${lfn:message('button.close')}" href="javascript:void(0);"  onclick="close_tips();"></a>
        	<i class="group_tips_trig"></i>
		 	 <div class="group_tips_title">
            	${lfn:message('km-calendar:kmCalendarShareGroup.tip') }：<span><b>${lfn:message('km-calendar:kmCalendar.nav.share.group')}</b></span>
            </div>
             <div class="group_tips_content">
	            <ul>
	                <li>${lfn:message('km-calendar:kmCalendarShareGroup.tip.one') }</li>
	                <li>${lfn:message('km-calendar:kmCalendarShareGroup.tip.two') }</li>
	            </ul>
	            <div class="group_tips_img">
	                <a href="javascript:void(0);" onclick="close_tips();kmCalendarShareGroup();"><img src="${LUI_ContextPath}/km/calendar/resource/images/tips_img.jpg" alt="分组" /></a>
	            </div>
        	</div>
	 </div>
	<ul class="lui_list_nav_list"  id="lui_list_nav_group">
		<ui:dataview id="share_group">
			<ui:source type="AjaxJson">
				{url:'/km/calendar/km_calendar_share_group/kmCalendarShareGroup.do?method=listUserGroupJson'}
			</ui:source>
			<ui:render type="Template">
				<c:import url="/km/calendar/tmpl/share_group.jsp" charEncoding="UTF-8"></c:import>
			</ui:render>
		</ui:dataview>
 	</ul>
 	</div>
</ui:content>
<%--后台--%>
<ui:content title="${ lfn:message('list.otherOpt') }" expand="false">
	<ul class='lui_list_nav_list'>
		<li><a href="${LUI_ContextPath }/sys/?module=km/calendar" target="_blank">${ lfn:message('list.manager') }</a></li>
	</ul>
</ui:content>
<script type="text/javascript">
	var exceptLabelIds="";//不需要显示的标签
	seajs.use(['lui/jquery', 'lui/util/str', 'lui/dialog'], function($, strutil, dialog){
		//打开群组日历页面
		window.showGroupCalendar=function(id){
			var url="${LUI_ContextPath}/km/calendar/group.jsp?groupId="+id;
			window.open(url,"_self");
		};
		//打开我的日历页面
		window.showCalendar=function(id,name){
			var url="${LUI_ContextPath}/km/calendar/index.jsp";
			window.open(url,"_self");
		};
		//点击标签
		window.clickLabel=function(_this,id){
			//处于我的日历页面
			if("${param.key}"=="calendar"){
				var hasClass=$(_this).children(":first").hasClass("label_div_on");
				//点击前处于选中状态
				if(hasClass){
					$(_this).children(":first").addClass("label_div_off").removeClass("label_div_on");
					exceptLabelIds+=id+",";
				}else{
					$(_this).children(":first").addClass("label_div_on").removeClass("label_div_off");
					exceptLabelIds=exceptLabelIds.replace(id,"");
				}
				var url=LUI("calendar").source.source.url;
				LUI("calendar").source.source.setUrl(Com_SetUrlParameter(url,"exceptLabelIds",exceptLabelIds));//修改请求地址
				LUI('calendar').refreshSchedules();//重刷日历
			}else{//处于群组页面
				showCalendar(id);
			}
		};
		//点击群组
		window.clickGroup=function(id,name){
			//处于群组页面
			if("${param.key}"=="group"){
				var url=LUI("calendar").source.url;
				LUI("calendar").source.setUrl(Com_SetUrlParameter(url,"groupId",id));//修改请求地址
				LUI('calendar').refreshSchedules();//重刷日历
			}else{
				showGroupCalendar(id,name);
			}
		};

		//新建标签
		window.kmCalendarEdit=function(){
			 dialog.iframe('/km/calendar/km_calendar_label/kmCalendarLabel_edit.jsp','${lfn:message("km-calendar:kmCalendarLabel.tab.add")}',function(value){
				if(value=="true"){
					if(LUI("label_nav")){
						LUI("label_nav").source.get();//操作成功,刷新标签导航栏
					}
				}else if(value=="false"){
					dialog.failure('<bean:message key="return.optFailure" />');
				}
			 },{height:'300',width:'700'});
		};
		
		//管理标签
		window.kmCalendarList=function(){
			$("#calendar_add").fadeOut();
			dialog.iframe('/km/calendar/km_calendar_label/kmCalendarUserLabel.do?method=edit','${lfn:message("km-calendar:kmCalendarLabel.tab.list")}',function(value){
				if(value=="true"){
					if(LUI("label_nav")){
						LUI("label_nav").source.get();//操作成功,刷新标签导航栏
					}
					LUI('calendar').refreshSchedules();//重刷日历
				}else if(value=="false"){
					dialog.failure('<bean:message key="return.optFailure" />');
				}
		 	},{height:'400',width:'650'});
		};

		 //个人共享设置
		window.kmCalendarAuth=function(){
			dialog.iframe('/km/calendar/km_calendar_auth/kmCalendarAuth.do?method=edit','${lfn:message("km-calendar:kmCalendar.setting.authSetting")}',null,{height:'500',width:'750'});
		};

		//关注群组
		window.kmCalendarShareGroup=function(){
			dialog.iframe('/km/calendar/km_calendar_share_group/kmCalendarUserShareGroup.do?method=edit','${lfn:message("km-calendar:kmCalendar.setting.groupSetting")}',function(value){
				if(value=="true"){
					if(LUI("share_group")){
						LUI("share_group").source.get();//刷新群组导航栏
					}
					LUI('calendar').refreshSchedules();//重刷日历
				}else if(value=="false"){
					dialog.success('<bean:message key="return.optFailure" />');
				}
			 },{height:'400',width:'750'});
		};
		var getCookie=function(name){
			var search = name + "=";
			var returnvalue = "";
		   	if (document.cookie&&document.cookie.length > 0) {
		    	offset = document.cookie.indexOf(search);
		   	if (offset != -1) {
		        offset += search.length;
		        end = document.cookie.indexOf(";", offset);
		        if (end == -1)
		           end = document.cookie.length;
		        returnvalue=unescape(document.cookie.substring(offset, end));
		      }
		   }
		   return returnvalue;
		};
		//关闭提示
		window.close_tips=function(){
			$("#group_tips").fadeOut("slow");
		};
		//日程分组提示
		$("#group_tips").parent().mouseover(function(){
			if($("#lui_list_nav_group li").size()<=1&&document.cookie&&getCookie("lui_group_tips")==""){
				//显示提示
				$("#group_tips").fadeIn("slow");
				document.cookie="lui_group_tips=yes";
			}
		});
	});
</script>

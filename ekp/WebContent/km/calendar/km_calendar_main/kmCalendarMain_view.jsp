<%@ page language="java" contentType="text/html; charset=UTF-8"pageEncoding="UTF-8"%>
<script>
	seajs.use(['lui/jquery','lui/dialog'], function($,dialog) {
		//删除日程
		window.delDoc=function(divId,form){
			var fdId=$("#"+form+" :input[name='fdId']").val();
			var url="${LUI_ContextPath}/km/calendar/km_calendar_main/kmCalendarMain.do?method=delete&fdId="+fdId;
			window.loading=dialog.loading();
			$.get(url,function(data){
				if(window.loading!=null)
					window.loading.hide();
				if(data!=null && data.status==true){
					LUI('calendar').removeSchedule(fdId);//删除日程
				}
				else{
					dialog.failure('<bean:message key="return.optFailure" />');
				}
				window.close_view(divId);//关闭对话框
			},'json');
		};
		
		//取消、设置提醒
		window.change_remind=function(){
			var icon=$("#calendar_remind_icon");
			if(icon.hasClass("remind")){
				icon.addClass("unremind").removeClass("remind").attr("title","设置提醒");
			}else{
				icon.removeClass("unremind").addClass("remind").attr("title","取消提醒");
			}
		};

		//日程详细设置
		window.eidtEventDetail=function(){
			window.close_view('calendar_view');
			var fdId=$("#calendarViewForm :input[name='fdId']").val();
			var url = "/km/calendar/km_calendar_main/kmCalendarMain.do?method=edit&fdId="+fdId;
			var isAllDayEvent = $("#fdIsAlldayevent").val();
			//var isLunar = $("#fdIsLunar").val();
			var subject = $("#docSubject").val();
			var startTime = $("#docStartTime").val();
			var endTime = $("#docFinishTime").val();
			var labelId = $("#labelId").val();
			url += "&isAllDayEvent="+isAllDayEvent+"&subject="+subject+"&startTime="+startTime+"&endTime="+endTime+"&labelId="+labelId;
			if(!isAllDayEvent){
				 var startHour = $("#startHour").val();
				 var startMinute = $("#startMinute").val();
				 var endHour = $("#endHour").val();
				 var endMinute = $("#endMinute").val();
				 url += "&startHour="+startHour+"&startMinute="+startMinute+"&endHour="+endHour+"&endMinute="+endMinute;
			}
			var header='<span class="event_lable_select" style="cursor:pointer;" id="event_base_label" >${lfn:message("km-calendar:kmCalendarMain.opt.edit")}&nbsp;</span>|'
				+'<span class="event_lable_unselect" style="cursor:pointer;" id="event_auth_label">&nbsp;${lfn:message("km-calendar:kmCalendar.label.table.share")}</span>';
			dialog.iframe(url,header,function(rtn){
				if(rtn!=null){
					if(rtn.method=="delete"){
						LUI('calendar').removeSchedule(fdId);//删除日程
					}else{
						//重复日程直接刷新整个界面
						if(rtn.isRecurrence != null && rtn.isRecurrence==true){
							LUI('calendar').refreshSchedules();
							return ;
						}
						if(rtn.schedule!=null){
							if(typeof setColor!="undefined"){
								setColor(rtn.schedule);
							}
							LUI('calendar').updateSchedule(rtn.schedule);
						}
					}
				}
			},{width:700,height:500});
		};

		//笔记详细设置
		window.editNoteDetail=function(){
			window.close_view('note_view');
			var fdId=$("#noteViewForm :input[name='fdId']").val();
			var url = "/km/calendar/km_calendar_main/kmCalendarMain.do?method=edit&fdId="+fdId;
			dialog.iframe(url,"${lfn:message('km-calendar:kmCalendarMain.opt.note.edit')}",function(schedule){
				if(schedule!=null){
					setColor(schedule);
					LUI('calendar').updateSchedule(schedule);
				}
			},{width:750,height:550});
		};

		//点击确定,修改标签、提醒设置
		window.updateLabelAndRemind=function(){
			window.loading = dialog.loading();
			var fdId=$("#calendar_view :input[name='fdId']").val();
			var labelId=$("#calendarViewForm :input[name='labelId']").val();//修改标签
			var clearRemind=$("#calendar_remind_icon").hasClass("unremind");//unremind:取消提醒
			$.get('<c:url value="/km/calendar/km_calendar_main/kmCalendarMain.do?method=updateLabelAndRemind"/>',
				$.param({"fdId":fdId,"labelId":labelId,"clearRemind":clearRemind},true),function(data){
					window.close_view("calendar_view");//关闭对话框
					if(window.loading!=null)
						window.loading.hide();
					if(data!=null && data.status==true){
						//重复日程直接刷新整个界面
						if(data.isRecurrence != null && data.isRecurrence==true){
							LUI('calendar').refreshSchedules();
							return ;
						}else{
							setColor(data.schedule);
							LUI('calendar').updateSchedule(data.schedule);
						}
					}else{
						dialog.failure('<bean:message key="return.optFailure" />');
					}
				},'json');
		};

		//关闭
		window.close_view=function(id){
			$("#"+id).fadeOut();//隐藏对话框
		};
		
	});

</script>
<%--查看日程DIV--%>
<div class="lui_calendar calendar_view" id="calendar_view" style="display: none;position: absolute;">
   	<div class="lui_calendar_top">
   		<div class="lui_calendar_title">
   			<bean:message bundle="km-calendar" key="kmCalendarMain.export.myCalendar"  />
   		</div>
        <div class="lui_calendar_close" onclick="close_view('calendar_view');"></div>
   	</div>
   	<form id="calendarViewForm"  name="kmCalendarMainForm">
	<div class="calendar_view_content">
		<div class="view_sched_wrapper">
			
				<input type="hidden"  name="fdId" />
		 		<table class="view_sched">
		 			<tr>
		 				<%--时间--%>
	               		<td class="title" width="50px">
	               			<bean:message bundle="km-calendar" key="kmCalendarMain.docTime"  />
	               		</td>
	                 	<td>
	                     	<div id="calendar_date" style="text-align: left"></div>
	                 	</td>
	             	</tr>
	             	<tr>
	             		<%--内容--%>
	                 	<td class="title" width="50px" valign="top">
	                     	<bean:message bundle="km-calendar" key="kmCalendarMain.docContent"  />
	                 	</td>
	                 	<td>
	                     	<div id="calendar_title" style="text-align: left"></div>
	                 	</td>
	             	</tr>
	             	<tr id="tr_relation_url" style="display: none;">
	             		<%--内容--%>
	                 	<td class="title" ></td>
	                 	<td>
	                     	<a id="calendar_relatation_url" style="text-align: left; cursor: pointer;color:blue;" target="_blank">${lfn:message('km-calendar:kmCalendarMain.calendar.source')}</a>
	                 	</td>
	             	</tr>
				</table>
			
		 </div>
		 <div class="lui_shades_btnGroup clrfix" id="calendar_view_btn" style="display: none;">
		 	<div id="div_remind_label_edit" class="left">
		 		<span class="calendar_remind_btn" onclick="change_remind()">
		 			<a id="calendar_remind_icon" class="remind"   title="取消提醒"></a>
	             </span>
	             <ul id="ul_label_edit" class="lui_list_nav_list">
					<ui:dataview id="label_view">
						<ui:source type="AjaxJson">
							{url:'/km/calendar/km_calendar_label/kmCalendarLabel.do?method=listJson'}
						</ui:source>
						<ui:render type="Template">
								<c:import url="/km/calendar/tmpl/label_select.jsp" charEncoding="UTF-8"></c:import>
						</ui:render>
						<ui:event event="load">
							if(typeof labelId_select!="undefined"){
								setLabelSelected(labelId_select);
							}
						</ui:event>
					</ui:dataview>
				</ul>	
			</div>
           <div class="right">
          	  <ul class="shade_btn_box clrfix">
               		<li id="button_save_event"><ui:button text="${lfn:message('button.ok')}"  onclick="updateLabelAndRemind();"/> </li>
          			<li id="button_delete_event"><ui:button text="${lfn:message('button.delete')}"  styleClass="lui_toolbar_btn_gray"  onclick="delDoc('calendar_view','calendarViewForm');"/> </li>
           			<li><ui:button text="${lfn:message('km-calendar:kmCalendarMain.moreSetting')}"   styleClass="lui_toolbar_btn_gray"  id="btn_Calendar_detail" onclick="eidtEventDetail();"/></li>
           		</ul>
           </div>
		 </div>
	</div>
	</form>
</div>

<%--查看笔记DIV--%>
<div class="lui_calendar note_view" id="note_view" style="display: none;position: absolute;">
   	<div class="lui_calendar_top">
   		<div class="lui_calendar_title">
   			<bean:message bundle="km-calendar" key="module.km.calendar.tree.my.note"  />
   		</div>
        <div class="lui_calendar_close" onclick="close_view('note_view');"></div>
   	</div>
   	<div class="calendar_view_content">
		<div class="view_sched_wrapper">
			<form id="noteViewForm"  name="kmCalendarMainForm">
				<input type="hidden"  name="fdId" />
		 		<table class="view_sched">
		 			<tr>
		 				<%--标题--%>
	               		<td class="title" width="50px">
	               			<bean:message bundle="km-calendar" key="kmCalendarMain.docSubject"  />
	               		</td>
	                 	<td>
	                     	<div id="note_subject" style="text-align: left"></div>
	                 	</td>
		 			</tr>
		 			<tr>
		 				<%--内容--%>
	               		<td class="title" width="50px" valign="top">
	               			<bean:message bundle="km-calendar" key="kmCalendarMain.docContent"  />
	               		</td>
	                 	<td>
	                     	<div id="note_docContent" style="text-align: left"></div>
	                 	</td>
		 			</tr>
		 		</table>
		 	</form>
		</div>
		<div class="lui_shades_btnGroup clrfix">
			<div class="right">
          	  <ul class="shade_btn_box clrfix">
          			<li><ui:button text="${lfn:message('button.delete')}"  styleClass="lui_toolbar_btn_gray"  onclick="delDoc('note_view','noteViewForm');"/> </li>
           			<li><ui:button text="${lfn:message('km-calendar:kmCalendarMain.moreSetting')}"   styleClass="lui_toolbar_btn_gray"  onclick="editNoteDetail();"/></li>
           		</ul>
           </div>
		</div>
	</div>
</div>
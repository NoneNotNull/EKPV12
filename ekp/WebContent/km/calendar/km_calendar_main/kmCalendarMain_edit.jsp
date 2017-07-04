<%@ page language="java" contentType="text/html; charset=UTF-8"pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.util.ResourceUtil"%>
<%
	request.setAttribute("formatter", ResourceUtil.getString("date.format.date"));
%>
<script>
	seajs.use(['theme!form']);//form样式
	Com_IncludeFile("validator.jsp|validation.js|plugin.js|validation.jsp|eventbus.js|xform.js|calendar.js",null,"js");
	seajs.use(['lui/jquery','lui/dialog'],function($,dialog){
		window.eventValidation=null;//日程校验框架
		window.noteValidation=null;//笔记校验框架
		//初始化校验框架
		LUI.ready(function(){
			eventValidation=$KMSSValidation($("#simple_event")[0]);
			noteValidation=$KMSSValidation($("#simple_note")[0]);
		});
		  
		//新增
		window.save=function(formId){
			var result=true;
			var url="";
			//提交前校验
			if(formId=="simple_event"){
				result=eventValidation.validate();
				url+="${LUI_ContextPath}/km/calendar/km_calendar_main/kmCalendarMain.do?method=saveEvent&simple=true";
				//校验时间
				var _startTime=$("[name='docStartTime']").val();
				var _finishTime=$("[name='docFinishTime']").val();
				//非全天.加上时、分
				if(!$("#fdIsAlldayevent").prop('checked')){
					_startTime+=" "+$("#startHour option:selected").val()+":"+$("#startMinute option:selected").val()+":00";
					_finishTime+=" "+$("#endHour option:selected").val()+":"+$("#endMinute option:selected").val()+":00";
				}
				 if(Date.parse(new Date(_finishTime.replace(/-/g,"/")))<Date.parse(new Date(_startTime.replace(/-/g,"/")))){
					 dialog.alert("开始时间不能晚于结束时间");
			    	return false;
				}
			}else{
				result=noteValidation.validate();
				url+="${LUI_ContextPath}/km/calendar/km_calendar_main/kmCalendarMain.do?method=saveNote";
			}
	    	if(result==false){
		    	return;
		    }
			LUI.$.ajax({
				url: url,
				type: 'POST',
				dataType: 'json',
				async: false,
				data: $("#"+formId).serialize(),
				beforeSend:function(){
					//window.loading = dialog.loading();
				},
				success: function(data, textStatus, xhr) {//操作成功
					if (data && data['status'] === true) {
						//window.loading.hide();
						if(typeof setColor!="undefined"){
							setColor(data['schedule']);//设置标签颜色
						}
						LUI('calendar').addSchedule(data['schedule']);
						window.close_edit();//关闭窗口
					}
				},
				error:function(xhr, textStatus, errorThrown){//操作失败
					//window.loading.hide();
					dialog.success('<bean:message key="return.optFailure" />');
					window.close_edit();
				}
			});
		};
		
		//关闭
		window.close_edit=function(){
			$(":reset").trigger("click");
			//window.eventValidation=null;//日程校验信息清空
			$("#calendar_add").fadeOut();//隐藏对话框
		};
		
		//打开日程详细页面
		window.openEvent=function(init){
			var url = "/km/calendar/km_calendar_main/kmCalendarMain.do?method=addEvent";
			//需要初始化参数(将简单页面的数据带入详细页面)
			if(init){
				var isAllDayEvent = $("#fdIsAlldayevent").prop('checked');
				var subject = $("#docSubject").val();
				subject=encodeURIComponent(subject);//转码
				var startTime = $("#docStartTime").val();
				var endTime = $("#docFinishTime").val();
				var labelId = $("#simple_event :input[name='labelId']").val();
				url += "&isAllDayEvent="+isAllDayEvent+"&subject="+subject+"&startTime="+startTime+"&endTime="+endTime+"&labelId="+labelId;
				//不是全天,带出小时、分钟
				if(!isAllDayEvent){
					 var startHour = $("#startHour").val();
					 var startMinute = $("#startMinute").val();
					 var endHour = $("#endHour").val();
					 var endMinute = $("#endMinute").val();
					 url += "&startHour="+startHour+"&startMinute="+startMinute+"&endHour="+endHour+"&endMinute="+endMinute;
				}
			}
			var header='<span class="event_lable_select" style="cursor:pointer;" id="event_base_label">${lfn:message("km-calendar:kmCalendarMain.opt.create")}&nbsp;</span>|'+
				'<span class="event_lable_unselect" style="cursor:pointer;" id="event_auth_label">&nbsp;${lfn:message("km-calendar:kmCalendar.label.table.share")}</span>';
			dialog.iframe(url,header,function(rtn){
				if(rtn != null){
					//重复日程直接刷新整个界面
					if(rtn.isRecurrence != null && rtn.isRecurrence==true){
						LUI('calendar').refreshSchedules();
						return ;
					}
					if(rtn.schedule!=null){
						if(typeof setColor!="undefined"){
							setColor(rtn.schedule);
						}
						LUI('calendar').addSchedule(rtn.schedule);
					}
				}
			},{width:700,height:500});
			window.close_edit();//关闭简单编辑页面
		};


		//打开笔记详细页面
		window.openNote=function(){
			var url = "/km/calendar/km_calendar_main/kmCalendarMain.do?method=addNote";
			var subject = $("#docSubject_note").val();
			subject=encodeURIComponent(subject);//转码
			var docContent = $("#docContent_note").val();
			docContent=encodeURIComponent(docContent);//转码
			var labelId = $("#simple_noteTab :input[name='labelId']").val();
			var startTime = $("#docStartTimeNote").val();
			url += "&subject="+subject+"&labelId="+labelId+"&startTime="+startTime+"&docContent="+docContent;
			window.close_edit();//关闭简单编辑页面
			dialog.iframe(url,"${lfn:message('km-calendar:kmCalendarMain.opt.note.create')}",function(schedule){
				if(schedule!=null){
					if(typeof setColor!="undefined"){
						setColor(schedule);
					}
					LUI('calendar').addSchedule(schedule);
				}
			},{width:750,height:550});
		};

		//是否全天
		window.changeAllDayValue=function(){
			var isAllday=$("#fdIsAlldayevent").prop('checked');
			if(isAllday){
				$("#startTimeDiv,#endTimeDiv,#startTimeDivLunar,#endTimeDivLunar").css("display","none");
			}else{
				$("#startTimeDiv,#endTimeDiv,#startTimeDivLunar,#endTimeDivLunar").css("display","inline");
			}
		};

		//标签切换(日程、笔记)
		window.switchTab=function(type){
			if(type=='event'){
				$('#tab_event').addClass("current");
				$('#tab_note').removeClass("current");
				$('#simple_calendarTab').show();
				$('#simple_noteTab').hide();
			}else{
				var date=$("#docStartTime").val();
				if(date==""){
					var today=new Date();
					date=today.getFullYear()+"-"+(today.getMonth()+1)+"-"+today.getDate();
				}
				$("#docStartTimeNote").val(date);
				$('#tab_event').removeClass("current");
				$('#tab_note').addClass("current");
				$('#simple_calendarTab').hide();
				$('#simple_noteTab').show();
			}
		};

		//开始时间改变时，校验结束时间是否小于开始时间，如果小于将结束时间=开始时间
		window.docStartTimeChange=function(obj){
			if($("[name='docFinishTime']").val()==null || $("[name='docFinishTime']").val()==""){
				return;
			}
			var docStartTime=formatDate($("[name='docStartTime']").val(),"${formatter}");
			var docFinishTime=formatDate($("[name='docFinishTime']").val(),"${formatter}");
			if(docStartTime.getTime()>docFinishTime.getTime()){
				$("[name='docFinishTime']").val($("[name='docStartTime']").val());	
			}
		};
		
		
	});

	function setTab(name, cursel, n) {
	    for (var i = 1; i <= n; i++) {
	        var menu = document.getElementById(name + i);
	        var con = document.getElementById("con_" + name + "_" + i);
	        menu.className = i == cursel ? "current" : "";
	        con.style.display = i == cursel ? "block" : "none";
	    }
	};

	

	
</script>
<%--新增日程DIV--%>
<div class="lui_calendar calendar_add" id="calendar_add" style="position: absolute; display: none">
	<%--顶部操作栏--%>
	<div class="lui_calendar_top">
   		<div class="lui_calendar_title">
   			<ul class="clrfix schedule_share">
   				<%--切换到日程--%>
                <li class="current" id="tab_event" onclick="switchTab('event')">
                	<bean:message bundle="km-calendar" key="kmCalendar.label.table.calender" />
                </li>
                <li>|</li>
                <%--切换到笔记--%>
                <li id="tab_note" onclick="switchTab('note');">
                	<bean:message bundle="km-calendar" key="kmCalendarMain.note" />
                </li>
            </ul>
   		</div>
        <div class="lui_calendar_close" onclick="close_edit();"></div>
   	</div>
   	<%--日程页面--%>
   	<div class="lui_calendar_view_content" id="simple_calendarTab">
	   	<div>
	   	<div class="add_sched_wrapper">
	   	<form id="simple_event"  name="kmCalendarMainForm">
	   		<input type="reset" style="display: none;" />
	   		<input type="hidden" name="fdType" id="simple_fdType_event" value="event" />
	        <table class="add_sched tb_simple">
	       		<tr>
	       			<%--内容--%>
	                <td width="15%" class="td_normal_title" valign="top">
	                	<bean:message bundle="km-calendar" key="kmCalendarMain.docContent" />
	                 </td>
                    <td width="85%">
                    	<xform:textarea showStatus="edit" htmlElementProperties="id='docSubject'" required="true" isLoadDataDict="fasle" validators="maxLength(500)"
                    		subject="${lfn:message('km-calendar:kmCalendarMain.docContent')}" property="docSubject" style="width:95%;"/>
                    </td>
               </tr>
	         	<tr>
	         		<%--时间--%>
	                <td width="15%" class="td_normal_title" valign="top">
	                	<bean:message bundle="km-calendar" key="kmCalendarMain.docTime" />
	                </td>
	                <td width="85%">
	                	<div class="div_normal">
	                		<%--是否全天--%>
                            <input type="checkbox" id="fdIsAlldayevent" name="fdIsAlldayevent" value="true" onclick="changeAllDayValue();"/>
                            <label><bean:message bundle="km-calendar" key="kmCalendarMain.allDay" /></label>
                         </div>
                         <div id="div_lunar" class="div_lunar" style="display: none;">
                            <select>
                                <option>2001年</option>
                              </select>
                          </div>
                          <%--时间--%>
                          <div id="div_fullDay" >
                          	<%--开始时间--%>
                        	<xform:datetime showStatus="edit" htmlElementProperties="id='docStartTime'" property="docStartTime" onValueChange="docStartTimeChange"
                        		 style="width:40%" dateTimeType="date" required="true" isLoadDataDict="false" />
                            <div id="startTimeDiv" style="top: -10px;position: relative; display: none;">
                            	<select name="startHour" id="startHour">
                            		<c:forEach  begin="0" end="23" varStatus="status" >
                               			<option value="${status.index}">${status.index}</option>
                               		</c:forEach>
                            	</select>
                            	<bean:message bundle="km-calendar" key="hour" />
                            	<select name="startMinute" id="startMinute">
                            		<c:forEach  begin="0" end="59" varStatus="status" >
                               			<option value="${status.index}">${status.index}</option>
                               		</c:forEach>
                            	</select>
                            	<bean:message bundle="km-calendar" key="minute" />
                            </div>
                            <span style="top: -10px;position: relative;">—</span>
                            <%--结束时间--%>
                            <xform:datetime showStatus="edit"  htmlElementProperties="id='docFinishTime'"  property="docFinishTime" 
                            	style="width:40%" dateTimeType="date" required="true" isLoadDataDict="false" />
                       		<div id="endTimeDiv" style="top: -10px;position: relative; display: none;">
                            	<select id="endHour" name="endHour">
                            		<c:forEach  begin="0" end="23" varStatus="status" >
                               			<option value="${status.index}">${status.index}</option>
                               		</c:forEach>
                            	</select>
                            	<bean:message bundle="km-calendar" key="hour" />
                            	<select id="endMinute" name="endMinute"> 
                            		<c:forEach  begin="0" end="59" varStatus="status" >
                               			<option value="${status.index}">${status.index}</option>
                               		</c:forEach>
                            	</select>
                            	<bean:message bundle="km-calendar" key="minute" />
                            </div>
                        </div>
	                </td>
                </tr>
                <tr>
                	<%--标签--%>
                	<td width="15%" class="td_normal_title" valign="top">
                		<bean:message bundle="km-calendar" key="kmCalendarMain.docLabel" />
                	</td>
                	<td>
                	<div>
                		<div style="float:left">
                	  	<ui:dataview id="label_edit" style="float:left;">
                	  		<ui:source type="AjaxJson">
								{url:'/km/calendar/km_calendar_label/kmCalendarLabel.do?method=listJson'}
							</ui:source>
							<ui:render type="Template">
								<c:import url="/km/calendar/tmpl/label_select.jsp" charEncoding="UTF-8"></c:import>
							</ui:render>
						</ui:dataview>
						</div>
						<div style="float:left;margin-top:4px;cursor: pointer;">
							<a onclick="kmCalendarList();" class="link">
								<bean:message bundle="km-calendar" key="kmCalendarLabel.tab.list" />
							</a>
						</div>
						</div>
                     </td>
                     
             	</tr>                
	        </table>
	     </form>
	   	</div></div>
		<%--底部操作栏(详细设置)--%>	   
	   	 <div class="lui_shades_btnGroup clrfix">
		 	<div class="left">
		 		<a id="btn_Calendar_add" onclick="openEvent(true);">
		 			<bean:message bundle="km-calendar" key="kmCalendarMain.moreSetting" />
		 		</a>
		 	</div>
		 	<div class="right">
		 		 <ul class="shade_btn_box clrfix">
	               	<li>
	               		<ui:button text="${lfn:message('button.save')}"  styleClass="lui_toolbar_btn_gray" onclick="save('simple_event');"/>
	               	</li>
	              </ul>
		 	</div>
		</div>
   	</div>
   	
   	
   <%--笔记--%>
   	<div id="simple_noteTab" style="display: none;">
   	<div>
	   	<div class="add_sched_wrapper">
	   	<html:form action="/km/calendar/km_calendar_main/kmCalendarMain.do" styleId="simple_note">
	   		<input type="reset" style="display: none;" />
	   		<input type="hidden" name="fdType" id="simple_fdType_note" value="note" />
	   		<input type="hidden" name="docStartTime"  id="docStartTimeNote"/>
	        <div  id="simple_noteTab">
           		<div style="width: 350px;" >
                	<table class="add_sched tb_simple">
                    	<tr>
                    		<%--主题--%>
                        	<td width="15%" class="td_normal_title" >
                             	<bean:message bundle="km-calendar" key="kmCalendarMain.docSubject"/>
                             </td>
                             <td>
                             	<xform:text showStatus="edit" property="docSubject" htmlElementProperties="id='docSubject_note'" 
                             		subject="${lfn:message('km-calendar:kmCalendarMain.docSubject')}" style="width:95%;" required="true" />
                             </td>
                        </tr>
                        <tr>
                        	<%--内容--%>
                        	<td width="15%" class="td_normal_title" >
                            	<bean:message bundle="km-calendar" key="kmCalendarMain.docContent"/>
                            </td>
                            <td>
                            	<xform:textarea showStatus="edit" property="docContent" htmlElementProperties="id='docContent_note'" 
                            		subject="${lfn:message('km-calendar:kmCalendarMain.docContent')}" style="width:95%;" required="true" />
                           </td>
                        </tr>
                        
                     </table>
                  </div>
              </div>
	     </html:form>
	   	</div>
	   	</div>
	   	<%--底部操作栏--%>
	   	 <div class="lui_shades_btnGroup clrfix">
		 	<div class="left">
		 		<a id="btn_Calendar_add" onclick="openNote();">
		 			<bean:message bundle="km-calendar" key="kmCalendarMain.moreSetting" />
		 		</a>
		 	</div>
		 	<div class="right">
		 		 <ul class="shade_btn_box clrfix">
	               	<li>
	               		<ui:button text="${lfn:message('button.save')}"  styleClass="lui_toolbar_btn_gray" onclick="save('simple_note');"/> 
	               	</li>
	              </ul>
		 	</div>
		</div>
   	</div>
</div>


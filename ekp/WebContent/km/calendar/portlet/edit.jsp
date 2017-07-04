<%@ page language="java" contentType="text/html; charset=UTF-8"pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.dialog">
	<template:replace name="content" >
		<link rel="Stylesheet" href="${LUI_ContextPath}/km/calendar/resource/css/calendar_main.css" />
		<script>
		Com_IncludeFile("validator.jsp|validation.js|plugin.js|validation.jsp|eventbus.js|xform.js",null,"js");
		var eventValidation=null;//日程校验框架
		//初始化校验框架
		LUI.ready(function(){
			eventValidation=$KMSSValidation($("#simple_event")[0]);
		});
		seajs.use(['lui/jquery','lui/dialog'],function($,dialog){
			//新增
			window.saveKmCalendarMain=function(divId){
				var result=eventValidation.validate();
				if(!result){
					return;
				}
				var url="${LUI_ContextPath}/km/calendar/km_calendar_main/kmCalendarMain.do?method=saveEvent&simple=true";
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
				LUI.$.ajax({
					url: url,
					type: 'POST',
					dataType: 'json',
					async: false,
					data: $("#"+divId).serialize(),
					success: function(data, textStatus, xhr) {//操作成功
						if (data && data['status'] === true) {
							window.closeKmCalendarEdit();//关闭窗口
							$(parent.document).find("#${param.prefix}calendarDIV .refresh").trigger("click");//触发刷新
						}
					},
					error:function(xhr, textStatus, errorThrown){//操作失败
						dialog.success('<bean:message key="return.optFailure" />');
						window.closeKmCalendarEdit();
					}
				});
			};
			
			//关闭
			window.closeKmCalendarEdit=function(){
				$(parent.document)
					.find("#${param.prefix}calendarDialog")
					.fadeOut();//隐藏对话框
				_resetform();
			};
			
			function _resetform(){
				$('#simple_event')[0].reset();
				$("#startTimeDiv,#endTimeDiv,#startTimeDivLunar,#endTimeDivLunar").css("display","none");
			}
		
			//是否全天
			window.changeAllDayValue=function(){
				var isAllday=$("#fdIsAlldayevent").prop('checked');
				if(isAllday){
					$("#startTimeDiv,#endTimeDiv,#startTimeDivLunar,#endTimeDivLunar").css("display","none");
				}else{
					$("#startTimeDiv,#endTimeDiv,#startTimeDivLunar,#endTimeDivLunar").css("display","inline");
				}
			};
			
			
			
		});
		</script>

		<%--新增日程DIV--%>
		<div class="lui_calendar calendar_add" id="calendar_add">
			<%--顶部操作栏--%>
			<div class="lui_calendar_top">
		   		<div class="lui_calendar_title">
		   			<ul class="clrfix schedule_share">
		   				<%--切换到日程--%>
		                <li class="current" id="tab_event">
		                	<bean:message bundle="km-calendar" key="kmCalendar.label.table.calender" />
		                </li>
		            </ul>
		   		</div>
		        <div class="lui_calendar_close" onclick="closeKmCalendarEdit();"></div>
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
		                    	<xform:textarea showStatus="edit" htmlElementProperties="id='docSubject'" required="true" 
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
		                            <input type="checkbox" id="fdIsAlldayevent" name="fdIsAlldayevent" value="true" checked="checked" onclick="changeAllDayValue();"/>
		                            <label><bean:message bundle="km-calendar" key="kmCalendarMain.allDay" /></label>
		                         </div>
		                          <%--时间--%>
		                          <div id="div_fullDay" >
		                          	<%--开始时间--%>
		                        	<xform:datetime showStatus="edit" htmlElementProperties="id='docStartTime'" property="docStartTime"
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
								</div>
		                   </td>
		             	</tr>                
			        </table>
			     </form>
			   	</div></div>
				<%--底部操作栏(详细设置)--%>	   
			   	 <div class="lui_shades_btnGroup clrfix">
				 	<div class="right">
				 		 <ul class="shade_btn_box clrfix">
			               	<li>
			               		<ui:button text="${lfn:message('button.save')}"  styleClass="lui_toolbar_btn_gray" onclick="saveKmCalendarMain('simple_event');"/>
			               	</li>
			              </ul>
				 	</div>
				</div>
		   	</div>
		</div>
	</template:replace>
</template:include>
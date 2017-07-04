<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.util.ResourceUtil"%>
<%request.setAttribute("formatter", ResourceUtil.getString("date.format.date"));%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<ui:ajaxtext>
<% 
	String prefix=request.getParameter("LUIID").replace("-","");
	request.setAttribute("prefix",prefix);
%>
<link rel="stylesheet" href="${LUI_ContextPath}/km/calendar/resource/css/calendar_portlet.css" type="text/css" />
<script type="text/javascript">
	seajs.use(['km/calendar/resource/js/calendar_portlet'], function(portlet) {
		 //初始化日历
	     var portletObj=new portlet.CalendarPortlet({'prefix':"${prefix}"});
	     //打开日程对话框
	     window.openEvent=function(url,method){
	    	 portletObj.openEvent(url,method);
		 };
	});
</script>
   	<div id="${prefix}calendarDIV" class="calendarDIV">
       <div class="lui_modules_person_history">
		<div class="lui_modules_person_history_content">
           	<div class="lui_modules_person_calendar_person">
                	<div id="${prefix}calendar">
                   	<table class="table" >
                       	<tr style="height:26px;background: url(${LUI_ContextPath}/km/calendar/resource/images/title_bg.png) repeat-x">
                           	<td colspan="7" valign="middle">
                           		<%--日期翻页--%>
                           		<div style="float: left;margin-left: 3px;">
                           			<img class="prev" src="${LUI_ContextPath}/km/calendar/resource/images/pre.png" width="5" height="8" border="0"  style="cursor: pointer;"/>
                                    <span id="${prefix}YMBG" ></span>
                                    <img class="next"  src="${LUI_ContextPath}/km/calendar/resource/images/next.png" width="5" height="8" border="0"  style="cursor: pointer;"/>
                           		</div>
                           		<%--回到今天--%>
                           		<div style="right">
                           			<div class="current_left today" >
                                       	<div class="current_right">
                                           	<div class="current_center"> 
                                           		<bean:message key="calendar.today" />
                                           	</div>
                                        </div>
                               		</div>
                               		<div class="current_left refresh" >
                                       	<div class="current_right">
                                           	<div class="current_center"> 
                                           		<bean:message key="button.refresh" />
                                           	</div>
                                        </div>
                               		</div>
                           		</div>
                               </td>
                            </tr>
                            <%--星期标题.从周一开始--%>
                           <tr align="center" bgcolor="#e0e0e0">
                                <td align="center" bgcolor="#ffffff" width="14%">
                                	<span style="color:#919b9c" ><bean:message key="Monday" bundle="km-calendar" /></span>
                                </td>
                                <td align="center" bgcolor="#ffffff" width="14%">
                                	<span style="color:#919b9c" ><bean:message key="Tuesday" bundle="km-calendar" /></span>
                                </td>
                                <td align="center" bgcolor="#ffffff" width="14%">
                                	<span style="color:#919b9c" ><bean:message key="Wednesday" bundle="km-calendar" /></span>
                                </td>
                                <td align="center" bgcolor="#ffffff" width="14%">
                                	<span style="color:#919b9c" ><bean:message key="Thursday" bundle="km-calendar" /></span>
                                </td>
                                <td align="center" bgcolor="#ffffff" width="14%">
                                	<span style="color:#919b9c" ><bean:message key="Friday" bundle="km-calendar" /></span>
                                </td>
                                <td align="center" bgcolor="#ffffff" width="14%">
                                	<span style="color:#919b9c" ><bean:message key="Saturday" bundle="km-calendar" /></span>
                                </td>
                                <td align="center" bgcolor="#ffffff" width="14%">
                                	<span style="color:#919b9c" ><bean:message key="Sunday" bundle="km-calendar" /></span>
                                </td>
                           </tr>
                           <c:forEach  begin="0" end="5" varStatus="i" >
                           		<tr align="center"  id="${prefix}TR${i.index}">
	                           		<c:forEach  begin="0" end="6" varStatus="j" >
	                           			<c:set value="${i.index*7+j.index}" var="gNum" />
										<td id="${prefix}GD${gNum}" style="cursor:pointer;height:30px;" class="no_events" bgcolor="white" >
											<div>
												<div align='center' id='${prefix}SD${gNum}' class='days' style='font-size:14px; height:20px; font-weight:bold; color:#64615a;background-color: #ffffff'  ></div>
											 </div>    
											 <div>
											 	<div align='center' id='${prefix}LD${gNum}' style='font-size:10px; color:#a7a6a4; height:20px;background-color: #ffffff'></div>
											 </div>                      			
	                           			</td>
	                           		</c:forEach>
                           		</tr>
                           </c:forEach>
						</table>
                     	</div>
                 	</div>
                   	<ul class="lui_modules_person_history_ul1" id="${prefix}calendarList"></ul>
              	</div>
       		</div>
   		</div>
   		<%--简单弹出框--%>
	   		<script type="text/javascript">
	   			seajs.use(['lui/topic','lui/jquery','km/calendar/resource/js/dateUtil'], function(topic,$,dateutil) {
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
	   				//打开日程简单弹出框
	   				topic.subscribe("kmCalendar_openSimpleDialog",function(args){
	   					var iframeDoc=window.frames["${prefix}calendarDialog"].document||window.frames["${prefix}calendarDialog"].contentDocument
	   						,addDIV=$(iframeDoc).find("#calendar_add");
	   					addDIV.find(['name="docSubject"']).val('');
	   					addDIV.find('[name="docStartTime"],[name="docFinishTime"]').val(dateutil.formatDate(args.date,"${formatter}"));
	   					$("#${prefix}calendarDialog").css(getPos(args.evt,addDIV));
	   					$("#${prefix}calendarDialog").fadeIn("fast");
	   				});
	   			});
	   		</script>
	   		<iframe style="position:absolute;border:none;z-index: 999;display: none;" width="350" height="380"
	   			src="${LUI_ContextPath}/km/calendar/portlet/edit.jsp?prefix=${prefix}" id="${prefix}calendarDialog">
	   		</iframe>
  </ui:ajaxtext>
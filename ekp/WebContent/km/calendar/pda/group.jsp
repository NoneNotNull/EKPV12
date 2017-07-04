<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/third/pda/htmlhead.jsp"%>
<link rel="stylesheet" href="${KMSS_Parameter_ContextPath}km/calendar/resource/css/calendar_pda.css" type="text/css" />
</head>
<body>
<c:if test="${KMSS_PDA_ISAPP !='1'}">
	<c:import charEncoding="UTF-8" url="/third/pda/banner.jsp">
		<c:param name="fdNeedHome" value="true"/>
		<c:param name="fdNeedNav" value="true" />
		<c:param name="fdNeedOtherInfo" value="true"/>
	</c:import>
</c:if>
<form name="CLD">
	<div id="div_loaing" class="div_loading" style="display: none;">数据正在加载中...</div>
   	<div id="calendarDIV" class="calendarDIV">
       <div class="lui_modules_person_history">
		<div class="lui_modules_person_history_content">
           	<div class="lui_modules_person_calendar_person">
                	<div id="calendar">
                   	<table class="table" >
                       	<tr style="height:39px;background: url(${KMSS_Parameter_ContextPath}km/calendar/resource/images/title_bg_pda.png) repeat-x">
                           	<td colspan="7">
                           		<%--回到个人日程--%>
                           		<div style="float: left;" onclick="Com_OpenWindow('<c:url value="/km/calendar/pda/index.jsp"/>','_self')">
                           			<div class="calendar"></div>
                           		</div>
                           		<%--回到今天--%>
                           		<div style="float: right;">
                           			<div class="today" ></div>
                           		</div>
                           		<%--日期翻页--%>
                           		<div style="width: 160px;margin: 0 auto;">
                           			<div class="prev" ></div>
                           			<div class="next" ></div>
                               		<div id="YMBG" class="ymbg"></div>
                           			<div style="clear: both;"></div>
                           		</div>
                               </td>
                            </tr>
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
                           <tr align="center">
                           		<c:forEach  begin="0" end="6" varStatus="gNum" >
                           			<td id="GD${gNum.index}" index="${gNum.index}" style="cursor:pointer;height:30px;" class="no_events" bgcolor="white" >
										<div>
											<div align='center' id='SD${gNum.index}' class='days' style='font-size:14px; height:20px; font-weight:bold; color:#64615a;background-color: #ffffff'  ></div>
										</div>    
										<div>
											 <div align='center' id='LD${gNum.index}' style='font-size:10px; color:#a7a6a4; height:20px;background-color: #ffffff'></div>
										</div>                      			
	                           		</td>
                           		</c:forEach>
                           </tr>
						</table>
                        </div>
                       </div>
                       <div class="lui_modules_calendar_opt" align="center">
                       		<select id="lui_shareGroup"></select>
                       </div>
                       <div id="list_loaing" class="div_loading" style="display: none;text-align: center;">数据正在加载中...</div>
                       <ul class="lui_modules_person_history_ul1" id="calendarList"></ul>
              		</div>
       		</div>
   		</div>
  </form>
  </body>
<script type="text/javascript" src="${KMSS_Parameter_ContextPath}km/calendar/pda/group.js"></script>
<script type="text/javascript">
	var calendar_pda=new calendarPda();
	calendar_pda.init();
</script>
</html>
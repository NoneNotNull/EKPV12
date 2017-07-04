<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ include file="/third/pda/htmlhead.jsp"%>
</head>
<link type="text/css" rel="stylesheet" href="<c:url value="/km/calendar/resource/css/calendar_pda.css"/>" />
	<%--新增日程(详细设置)--%>
	<html:form action="/km/calendar/km_calendar_main/kmCalendarMain.do" styleId="eventform">
		<div id="calendarView">
		    <div class="back" onclick="Com_OpenWindow('<c:url value="/km/calendar/pda/index.jsp"/>','_self');"></div>
			<div class="calendarHeader"><c:out value="${kmCalendarMainForm.docSubject}" /></div>
			<div class="calendarContent">
				<table>
					<%--时间、重复信息--%>
					<tr>
						<td width="15%">
							<img src="${KMSS_Parameter_ContextPath}km/calendar/resource/images/time_pda.png" width="20" height="20" />
						</td>
						<td>
							<xform:datetime  property="docStartTime" style="width:20%" dateTimeType="date"    />
							<c:if test="${kmCalendarMainForm.fdIsAlldayevent =='false' }">
								<c:out value="${kmCalendarMainForm.startHour}" />:<c:out value="${kmCalendarMainForm.startMinute}" />		
							</c:if>
							<span>-</span>
							<xform:datetime  property="docFinishTime" style="width:20%" dateTimeType="date"   />
							<c:if test="${kmCalendarMainForm.fdIsAlldayevent =='false' }">
								<c:out value="${kmCalendarMainForm.endHour}" />:<c:out value="${kmCalendarMainForm.endMinute}" />		
							</c:if>
							<div id="summary" class="summary"></div>
						</td>
					</tr>
					<%--地点--%>
					<c:if test="${not empty  kmCalendarMainForm.fdLocation}">
					<tr>
						<td width="15%">
							<img src="${KMSS_Parameter_ContextPath}km/calendar/resource/images/location_pda.png" width="20" height="20"/>
						</td>
						<td>
							<c:out value="${kmCalendarMainForm.fdLocation}" />
						</td>
					</tr>
					</c:if>
					<%--相关链接--%>
					<c:if test="${not empty  kmCalendarMainForm.fdRelationUrl}">
						<%--内部链接--%>
						<c:if test="${fn:substring(kmCalendarMainForm.fdRelationUrl,0,1)=='/'}">
							<c:set value="${KMSS_Parameter_ContextPath}${fn:substring(kmCalendarMainForm.fdRelationUrl,1,fn:length(kmCalendarMainForm.fdRelationUrl))}" var="relationUrl" />	
						</c:if>
						<%--外部链接--%>
						<c:if test="${fn:substring(kmCalendarMainForm.fdRelationUrl,0,1)!='/'}">
							<c:set value="${kmCalendarMainForm.fdRelationUrl}" var="relationUrl" />	
						</c:if>
						<td width="15%">
							<img src="${KMSS_Parameter_ContextPath}km/calendar/resource/images/relationUrl_pda.png" width="20" height="20"/>
						</td>
						<td>
							<a href="${relationUrl}">
								<bean:message bundle="km-calendar" key="kmCalendarMain.fdRelationUrl" />
							</a>
						</td>
					</c:if>
					<%--标签--%>
					<tr>
						<td width="15%">
							<img src="${KMSS_Parameter_ContextPath}km/calendar/resource/images/label_pda.png"  width="20" height="20"/>
						</td>
						<td>
							 <c:out value="${kmCalendarMainForm.labelName}"></c:out>
							<c:if test="${empty kmCalendarMainForm.labelName}">
								<bean:message bundle="km-calendar" key="kmCalendar.nav.title" />
							</c:if>	  
						</td>
					</tr>
				</table>
			</div>
			<div class="calendarRemind">
				<div style="width: 90%;margin: 0px auto;">
					<img src="${KMSS_Parameter_ContextPath}km/calendar/resource/images/remind_pda.png"  width="20" height="20"/>
					<span>提醒</span>
					<div style="display: inline-table;">
						<c:import url="/sys/notify/import/sysNotifyRemindMain_view.jsp" charEncoding="UTF-8">
						    <c:param name="formName" value="kmCalendarMainForm" />
					         <c:param name="fdKey" value="kmCalenarMainDoc" />
					         <c:param name="fdPrefix" value="event" />
					         <c:param name="fdModelName" value="com.landray.kmss.km.calendar.model.KmCalendarMain" />
			   	 		</c:import>
			   	 	</div>
				</div>
			</div>
		</div>
	</html:form>
<script>Com_IncludeFile("jquery.js|xform.js",null,"js");</script>
<script type="text/javascript" src="${KMSS_Parameter_ContextPath}km/calendar/resource/js/solarAndLunar.js"></script>
<script>
	//常用字段
	var weekObj={"SU":"日","MO":"一","TU":"二","WE":"三","TH":"四","FR":"五","SA":"六"};
	var unitObj={"NO":"不重复","DAILY":"天","WEEKLY":"周","MONTHLY":"月","YEARLY":"年"};

	//公历摘要
	function solarSummary(){
		var unit=unitObj["${kmCalendarMainForm.RECURRENCE_FREQ}"];
		var text="";//公历
		text+="每隔${kmCalendarMainForm.RECURRENCE_INTERVAL}"+unit;
		if(unit=="${lfn:message('km-calendar:week')}"){//如果是周重复
			text+=" ${lfn:message('km-calendar:week')}";
			var weeks="${kmCalendarMainForm.RECURRENCE_WEEKS}".split(",");
			for(var i=0;i<weeks.length;i++){
				text+=weekObj[weeks[i]]+"、";
			}
		}else if(unit=="${lfn:message('km-calendar:month')}"){//如果是月重复
			text+=" ${lfn:message('km-calendar:month')}";
			var type="${kmCalendarMainForm.RECURRENCE_MONTH_TYPE}";
			var d="${kmCalendarMainForm.docStartTime}";
			var date=new Date();
			if(d!=""){
				date=new Date(d.replace(/-/g,"/"));
			}
			if(type=="month"){
				text+="${lfn:message('km-calendar:each')}${lfn:message('km-calendar:month')}${lfn:message('page.the')}" + date.getDate() + "${lfn:message('km-calendar:daily')}";//每月第N天
			}else{
				text+="${lfn:message('page.the')}"+ Math.ceil(date.getDate() / 7) +"${lfn:message('km-calendar:one')}${lfn:message('km-calendar:week')}" + '日一二三四五六'.split('')[date.getDay()];//第N个周日、一、二……
			}
		}
		var endType="${kmCalendarMainForm.RECURRENCE_END_TYPE}";
		if(endType=="NEVER"){
			text+=" ${lfn:message('km-calendar:recurrence.end.type.never')}${lfn:message('km-calendar:recurrence.end')}";//从不结束
		}else if(endType=="COUNT"){
			text+=" ${lfn:message('km-calendar:recurrence.end.freq')}"+"${kmCalendarMainForm.RECURRENCE_COUNT}"+"${lfn:message('km-calendar:times')}${lfn:message('km-calendar:recurrence.end')}";//重复N次结束
		}else{
			var endDate="${kmCalendarMainForm.RECURRENCE_UNTIL}";
			text+=" ${lfn:message('km-calendar:recurrence.end.type.until')}" + endDate + "${lfn:message('km-calendar:recurrence.end')}";//直到yyyy-MM-dd结束
		}
		$("#summary").html(text);
	}

	//农历摘要
	function lunarSummary(){
		var unit=unitObj["${kmCalendarMainForm.RECURRENCE_FREQ_LUNAR}"];
		var text="";
		text+="每隔${kmCalendarMainForm.RECURRENCE_INTERVAL_LUNAR}"+unit;
		var endType="${kmCalendarMainForm.RECURRENCE_END_TYPE_LUNAR}";
		if(endType=="NEVER"){
			text+=" ${lfn:message('km-calendar:recurrence.end.type.never')}${lfn:message('km-calendar:recurrence.end')}";//从不结束
		}else if(endType=="COUNT"){
			text+=" ${lfn:message('km-calendar:recurrence.end.freq')}"+"${kmCalendarMainForm.RECURRENCE_COUNT_LUNAR}"+"${lfn:message('km-calendar:times')}${lfn:message('km-calendar:recurrence.end')}";//重复N次结束
		}else{
			var endDate="${kmCalendarMainForm.RECURRENCE_UNTIL_LUNAR}";
			text+=" ${lfn:message('km-calendar:recurrence.end.type.until')}" + endDate + "${lfn:message('km-calendar:recurrence.end')}";//直到yyyy-MM-dd结束
		}
		$("#summary").html(text);
	}

	//初始化农历
	function initLunar(startDate,endDate){
		var lunarDate = lunar(startDate);
		var year = lunarDate.sYear + 1984;
		$('#lunarStartYear').html(year+"年");//农历开始年
		$("#lunarStartMonth").html(lunarDate.lMonth+"月");//农历开始月
		$("#lunarStartDay").html(lunarDate.lDate);//农历开始日

		if(endDate){
			lunarDate = lunar(endDate);
			year = lunarDate.sYear + 1984;
			$('#lunarEndYear').html(year+"年");
			$("#lunarEndMonth").html(lunarDate.lMonth+"月");//农历结束月
			$("#lunarEndDay").html(lunarDate.lDate);//农历结束日
		}
	}

	//初始化
	if("${kmCalendarMainForm.fdIsLunar}"=="true"){//农历
		var docStartTime ="${kmCalendarMainForm.docStartTime}";
		var docFinishTime ="${kmCalendarMainForm.docFinishTime}";
		initLunar(new Date(docStartTime.substring(0,4),docStartTime.substring(5,7)-1,docStartTime.substring(8,10)),new Date(docFinishTime.substring(0,4),docFinishTime.substring(5,7)-1,docFinishTime.substring(8,10)));
	}
	//是否显示重复信息
	if('${kmCalendarMainForm.RECURRENCE_FREQ}'!=null && '${kmCalendarMainForm.RECURRENCE_FREQ}' != 'NO'){
		solarSummary();
		$("#moreset").show();
	}
	//是否显示农历重复信息
	if('${kmCalendarMainForm.RECURRENCE_FREQ_LUNAR}'!=null && '${kmCalendarMainForm.RECURRENCE_FREQ_LUNAR}' != 'NO'){
		lunarSummary();
		$("#moreset").show();
	}
</script>
<%@page import="com.landray.kmss.km.calendar.model.KmCalendarMain"%>
</html>
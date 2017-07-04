<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>

<div id="optBarDiv">
	<kmss:auth requestURL="/km/calendar/km_calendar_base_config/kmCalendarBaseConfig.do?method=edit" requestMethod="GET">
		<input type="button" value="<bean:message key="button.edit"/>" onclick="Com_OpenWindow('kmCalendarBaseConfig.do?method=edit&type=${type }','_self');">
	</kmss:auth>
</div>

<center>
<p class="txttitle">
<c:if test="${!empty type and type=='day'}">
	<bean:message bundle="km-calendar" key="table.kmCalendarBaseConfigKeepTime"/>
</c:if>
<c:if test="${!empty type and type=='time'}">
	<bean:message bundle="km-calendar" key="table.kmCalendarBaseConfigSetTime"/>
</c:if></p>
<table class="tb_normal" width=95%>
	<c:if test="${!empty type and type=='day'}">
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-calendar" key="kmCalendarBaseConfig.fdKeepDay"/>
					
			</td><td colspan=3>
				<bean:write name="kmCalendarBaseConfigForm" property="fdKeepDay"/>
				<span id='dateDescription' >
				<br><font color="red" ><bean:message  bundle="km-calendar" key="kmCalendarType.dateDescription"/></font></span>
			</td>
		</tr>
	</c:if>
	<c:if test="${!empty type and type=='time'}">
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-calendar" key="kmCalendarBaseConfig.fdStartTime"/>
			</td><td width=35%>
				<bean:write name="kmCalendarBaseConfigForm" property="fdStartTime"/>
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-calendar" key="kmCalendarBaseConfig.fdEndTime"/>
			</td><td width=35%>
				<bean:write name="kmCalendarBaseConfigForm" property="fdEndTime"/>
			</td>
		</tr>
	</c:if>
</table>
</center>

<%@ include file="/resource/jsp/view_down.jsp"%>

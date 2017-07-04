<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
		
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<div id="optBarDiv">
	<kmss:auth requestURL="/km/calendar/km_calendar_agenda_label/kmCalendarAgendaLabel.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('kmCalendarAgendaLabel.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<c:if test="${!kmCalendarAgendaLabelForm.isAgendaLabel}">
	<kmss:auth requestURL="/km/calendar/km_calendar_agenda_label/kmCalendarAgendaLabel.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('kmCalendarAgendaLabel.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	</c:if>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="km-calendar" key="table.kmCalendarAgendaLabel"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-calendar" key="kmCalendarAgendaLabel.fdName"/>
		</td><td width="35%">
			<xform:text property="fdName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-calendar" key="kmCalendarAgendaLabel.fdColor"/>
		</td>
		<td width="35%">
			<div style="width:20px;height:20px;background-color: ${kmCalendarAgendaLabelForm.fdColor };"></div>
			
		</td>
	</tr>
	<tr>
		
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-calendar" key="kmCalendarAgendaLabel.enable"/>
		</td>
		<td width="35%">
			<xform:radio property="fdIsAvailable">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:radio>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-calendar" key="kmCalendarAgendaLabel.isAgendaLabel"/>
		</td>
		<td width="35%">
			<xform:radio property="isAgendaLabel">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:radio>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-calendar" key="kmCalendarAgendaLabel.fdModelName"/>
		</td><td colspan="3">
			<xform:text property="fdModelName" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-calendar" key="kmCalendarAgendaLabel.remark"/>
		</td>
		<td colspan="3">
			<xform:text property="fdDiscription" style="width:85%" />
		</td>
		
	</tr>
	
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/agenda/include/sysAgendaMain_general_view.jsp" %>
<tr>
	<%-- 日程内容 --%>
	<td class="td_normal_title" width=15%><bean:message bundle="sys-agenda" key="sysAgenda.fdSubject" /></td>
	<td width="90%">
	   <xform:text property="sysAgendaMainForm.fdSubjectFieldName" style="width:100%" />
	</td>
</tr>
<tr>
	<%-- 开始时间 --%>
	<td class="td_normal_title" width=15%><bean:message bundle="sys-agenda" key="sysAgenda.fdBeginTime" /></td>
	<td width="90%">
	   <xform:text property="sysAgendaMainForm.fdBeginTimeFieldName" style="width:100%" />
	</td>
</tr>
<tr>
	<%-- 结束时间 --%>
	<td class="td_normal_title" width=15%><bean:message bundle="sys-agenda" key="sysAgenda.fdEndTime" /></td>
	<td width="90%">
	   <xform:text property="sysAgendaMainForm.fdEndTimeFieldName" style="width:100%" />
	</td>
</tr>
<tr>
	<%-- 日程人员 --%>
	<td class="td_normal_title" width=15%><bean:message bundle="sys-agenda" key="sysAgenda.fdNotifierId" /></td>
	<td width="90%">
	  <xform:text property="sysAgendaMainForm.fdNotifierIdFieldName" style="width:100%" />
	</td>
</tr>
<tr>
	<%-- 日程地点 --%>
	<td class="td_normal_title" width=15%><bean:message bundle="sys-agenda" key="sysAgenda.fdLocate" /></td>
	<td width="90%">
	  <xform:text property="sysAgendaMainForm.fdLocateFieldName" style="width:100%" />
	</td>
</tr>
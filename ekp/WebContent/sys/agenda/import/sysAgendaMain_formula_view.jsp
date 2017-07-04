<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="mainModelForm" value="${requestScope[param.formName]}" scope="request" />
<c:set var="sysAgendaMainForm" value="${mainModelForm.sysAgendaMainForm}" scope="request" />
<table class="tb_normal" width=100% style="border-width:0px; border-style:hidden;">
	<tr>
		<%-- 提醒机制 --%>
		<td class="td_normal_title" width="15%">
			<bean:message bundle="sys-notify" key="sysNotify.remind.calendar.subject" />
		</td>
		<td colspan="3">
			<%@include file="/sys/notify/import/sysNotifyRemindMain_view.jsp"%>
		</td>
	</tr>
	<tr>
		<%-- 日程内容 --%>
		<td class="td_normal_title" width="15%">
			<bean:message bundle="sys-agenda" key="sysAgenda.fdSubject" />
		</td>
		<td width="85%" colspan="3">
		   <xform:text property="sysAgendaMainForm.fdSubjectFieldName" style="width:100%" />
		</td>
	</tr>
	<tr>
		<%-- 开始时间 --%>
		<td class="td_normal_title" width="15%">
			<bean:message bundle="sys-agenda" key="sysAgenda.fdBeginTime" />
		</td>
		<td width="85%" colspan="3">
		   <xform:text property="sysAgendaMainForm.fdBeginTimeFieldName" style="width:100%" />
		</td>
	</tr>
	<tr>
		<%-- 结束时间 --%>
		<td class="td_normal_title" width="15%">
			<bean:message bundle="sys-agenda" key="sysAgenda.fdEndTime" />
		</td>
		<td width="85%" colspan="3">
		   <xform:text property="sysAgendaMainForm.fdEndTimeFieldName" style="width:100%" />
		</td>
	</tr>
	<tr>
		<%-- 日程人员 --%>
		<td class="td_normal_title" width="15%">
			<bean:message bundle="sys-agenda" key="sysAgenda.fdNotifierId" />
		</td>
		<td width="85%" colspan="3">
		  <xform:text property="sysAgendaMainForm.fdNotifierIdFieldName" style="width:100%" />
		</td>
	</tr>
	<tr>
		<%-- 日程地点 --%>
		<td class="td_normal_title" width="15%">
			<bean:message bundle="sys-agenda" key="sysAgenda.fdLocate" />
		</td>
		<td width="85%" colspan="3">
		  <xform:text property="sysAgendaMainForm.fdLocateFieldName" style="width:100%" />
		</td>
	</tr>
</table>
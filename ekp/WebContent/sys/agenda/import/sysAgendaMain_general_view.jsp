<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="mainModelForm" value="${requestScope[param.formName]}" scope="request" />
<c:set var="sysAgendaMainForm" value="${mainModelForm.sysAgendaMainForm}" scope="request" />
<table class="tb_normal" width=100% style="border-width:0px; border-style:hidden;">
	<tr>
		<%-- 提醒机制 --%>
		<td class="td_normal_title" width="15%">
			<bean:message bundle="sys-notify" key="sysNotify.remind.calendar.subject" />
		</td>
		<td width="85%" colspan="3">
			<%@include file="/sys/notify/import/sysNotifyRemindMain_view.jsp"%>
		</td>
	</tr>
</table>
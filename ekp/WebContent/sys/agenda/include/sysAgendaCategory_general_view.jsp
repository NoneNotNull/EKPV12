<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="templateForm" value="${requestScope[param.formName]}" scope="request" />
<c:set var="sysAgendaCategoryForm" value="${templateForm.sysAgendaCategoryForm}" scope="request" />
<script>Com_IncludeFile("jquery.js");</script>
<c:if test="${templateForm[param.syncTimeProperty]!=param.noSyncTimeValues && not empty templateForm[param.syncTimeProperty]}">
<table id="sysAgendaCategoryTable" class="tb_normal" width=100% style="border-width:0px; border-style:hidden;">
	<tr>
		<%-- 提醒机制 --%>
		<td class="td_normal_title" width="15%">
			<bean:message bundle="sys-notify" key="sysNotify.remind.calendar.subject" />
		</td>
		<td colspan="3">
			<%@include file="/sys/notify/include/sysNotifyRemindCategory_view.jsp"%>
		</td>
	</tr>
</table>
</c:if>
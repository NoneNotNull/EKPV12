<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/agenda/include/sysAgendaMain_general_edit.jsp" %>
<c:set var="mainModelForm" value="${requestScope[param.formName]}" scope="request" />
<c:set var="sysAgendaMainForm" value="${mainModelForm.sysAgendaMainForm}" scope="request" />
<tr>
	<%-- 日程内容 --%>
	<td class="td_normal_title" width=10%><bean:message bundle="sys-agenda" key="sysAgenda.fdSubject" /></td>
	<td width="90%">
	  <input type="text" name="sysAgendaMainForm.fdSubjectFieldName"  value="${sysAgendaMainForm.fdSubjectFieldName}" size="80"  class="inputsgl" readonly="readonly" />
	</td>
</tr>
<tr>
	<%-- 开始时间 --%>
	<td class="td_normal_title" width=10%><bean:message bundle="sys-agenda" key="sysAgenda.fdBeginTime" /></td>
	<td width="90%">
	  <input type="text" name="sysAgendaMainForm.fdBeginTimeFieldName"  value="${sysAgendaMainForm.fdBeginTimeFieldName}" size="80"  class="inputsgl" readonly="readonly" />
	</td>
</tr>
<tr>
	<%-- 结束时间 --%>
	<td class="td_normal_title" width=10%><bean:message bundle="sys-agenda" key="sysAgenda.fdEndTime" /></td>
	<td width="90%">
	    <input type="text" name="sysAgendaMainForm.fdEndTimeFieldName" value="${sysAgendaMainForm.fdEndTimeFieldName}" size="80"  class="inputsgl" readonly="readonly" />
	 </td>
</tr>
<tr>
	<%-- 日程人员 --%>
	<td class="td_normal_title" width=10%><bean:message bundle="sys-agenda" key="sysAgenda.fdNotifierId" /></td>
	<td width="90%">
	    <input type="text" name="sysAgendaMainForm.fdNotifierIdFieldName" value="${sysAgendaMainForm.fdNotifierIdFieldName}" size="80"  class="inputsgl" readonly="readonly" />
	</td>
</tr>
<tr>
	<%-- 日程地点 --%>
	<td class="td_normal_title" width=10%><bean:message bundle="sys-agenda" key="sysAgenda.fdLocate" /></td>
	<td width="90%">
	    <input type="text" name="sysAgendaMainForm.fdLocateFieldName"  value="${sysAgendaMainForm.fdLocateFieldName}" size="80"  class="inputsgl" readonly="readonly" />
	</td>
</tr>

<html:hidden property="sysAgendaMainForm.fdSubjectFieldId" />
<html:hidden property="sysAgendaMainForm.fdBeginTimeFieldId" />
<html:hidden property="sysAgendaMainForm.fdEndTimeFieldId" />
<html:hidden property="sysAgendaMainForm.fdNotifierIdFieldId" />
<html:hidden property="sysAgendaMainForm.fdLocateFieldId" />

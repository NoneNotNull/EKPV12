<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="mainModelForm" value="${requestScope[param.formName]}" scope="request" />
<c:set var="sysAgendaMainForm" value="${mainModelForm.sysAgendaMainForm}" scope="request" />
<script>Com_IncludeFile("jquery.js");</script>
<table id="sysAgendaMainTable" class="tb_normal" width=100%  style="border-width:0px; border-style:hidden;">
	<tr>
		<%-- 提醒设置 --%>
		<td width="15%"  class="tb_normal">
			<bean:message bundle="sys-notify" key="sysNotify.remind.calendar.subject" />
		</td>
		<td width="85%" colspan="3">
			<%@include file="/sys/notify/import/sysNotifyRemindMain_edit.jsp"%>
		</td>
	</tr>
	<tr>
		<%-- 日程内容 --%>
		<td width="15%"  class="tb_normal">
		  <bean:message bundle="sys-agenda" key="sysAgenda.fdSubject" />
		</td>
		<td width="85%" colspan="3">
		  <input type="text" name="sysAgendaMainForm.fdSubjectFieldName"  value="<c:out value='${sysAgendaMainForm.fdSubjectFieldName}' />" class="inputsgl"  readonly="readonly" />
		</td>
	</tr>
	<tr>
		<%-- 开始时间 --%>
		<td width="15%"  class="tb_normal">
		  <bean:message bundle="sys-agenda" key="sysAgenda.fdBeginTime" />
		</td>
		<td width="85%" colspan="3">
		  <input type="text" name="sysAgendaMainForm.fdBeginTimeFieldName"  value="<c:out value='${sysAgendaMainForm.fdBeginTimeFieldName}' />" class="inputsgl" readonly="readonly"/>
		</td>
	</tr>
	<tr>
		<%-- 结束时间 --%>
		<td width="15%"  class="tb_normal">
		    <bean:message bundle="sys-agenda" key="sysAgenda.fdEndTime" />
		</td>
		<td width="85%" colspan="3">
		    <input type="text" name="sysAgendaMainForm.fdEndTimeFieldName" value="<c:out value='${sysAgendaMainForm.fdEndTimeFieldName}' />" class="inputsgl" readonly="readonly"/>
		 </td>
	</tr>
	<tr>
		<%-- 日程人员 --%>
		<td width="15%"  class="tb_normal">
		    <bean:message bundle="sys-agenda" key="sysAgenda.fdNotifierId" />
		</td>
		<td width="85%" colspan="3">
		    <input type="text" name="sysAgendaMainForm.fdNotifierIdFieldName" value="<c:out value='${sysAgendaMainForm.fdNotifierIdFieldName}' />" class="inputsgl"  readonly="readonly"/>
		</td>
	</tr>
	<tr>
		<%-- 日程地点 --%>
		<td width="15%"  class="tb_normal">
		    <bean:message bundle="sys-agenda" key="sysAgenda.fdLocate" />
		</td>
		<td width="85%" colspan="3">
		    <input type="text" name="sysAgendaMainForm.fdLocateFieldName"  value="<c:out value='${sysAgendaMainForm.fdLocateFieldName}' />" class="inputsgl" readonly="readonly"/>
		</td>
	</tr>
</table>
<html:hidden property="sysAgendaMainForm.fdSubjectFieldId" />
<html:hidden property="sysAgendaMainForm.fdBeginTimeFieldId" />
<html:hidden property="sysAgendaMainForm.fdEndTimeFieldId" />
<html:hidden property="sysAgendaMainForm.fdNotifierIdFieldId" />
<html:hidden property="sysAgendaMainForm.fdLocateFieldId" />
<script>
	$(document).ready(function(){
		//初始化日程机制
		if("${param.syncTimeProperty}"!=""){
			var syncTimeProperty="${param.syncTimeProperty}";
			var noSyncTimeValues="${param.noSyncTimeValues}".split(";");
			for(var i=0;i<noSyncTimeValues.length;i++){
				var noSyncTimeValue=noSyncTimeValues[i];
				if($(":input[name='"+syncTimeProperty+"']:checked").val()==noSyncTimeValue){
					$("#sysAgendaMainTable").hide();
					break;
				}
			}
			$("[name='"+syncTimeProperty+"']").bind("click",function(){
				var k=0;
				for(k=0;k<noSyncTimeValues.length;k++){
					var noSyncTimeValue=noSyncTimeValues[k];
					if($(":input[name='"+syncTimeProperty+"']:checked").val()==noSyncTimeValue){
						$("#sysAgendaMainTable").hide();
						break;
					}
				}
				if(k>=noSyncTimeValues.length){
					$("#sysAgendaMainTable").show();
				}
			});
		}
	});
</script>
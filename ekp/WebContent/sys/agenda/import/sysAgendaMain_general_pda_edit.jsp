<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="mainModelForm" value="${requestScope[param.formName]}" scope="request" />
<c:set var="sysAgendaMainForm" value="${mainModelForm.sysAgendaMainForm}" scope="request" />
<script>Com_IncludeFile("jquery.js");</script>
<table id="sysAgendaMainTable"  class="docView" width=100%  style="border-width:0px; border-style:hidden;">
	<tr>
		<%-- 提醒设置 --%>
		<td width="25%" class="td_title">
			<bean:message bundle="sys-notify" key="sysNotify.remind.calendar.subject" />
		</td>
		<td width="75%">
			<%@include file="/sys/notify/import/sysNotifyRemindMain_edit.jsp"%>
		</td>
	</tr>
</table>
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
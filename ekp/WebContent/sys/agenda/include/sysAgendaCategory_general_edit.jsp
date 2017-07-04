<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="templateForm" value="${requestScope[param.formName]}" scope="request" />
<c:set var="sysAgendaCategoryForm" value="${templateForm.sysAgendaCategoryForm}" scope="request" />
<script>Com_IncludeFile("jquery.js");</script>
<table id="sysAgendaCategoryTable" class="tb_normal" width=100% style="border: 0px;border-style: hidden;">
	<tr>
		<%-- 提醒 --%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-notify" key="sysNotify.remind.calendar.subject" />
		</td>
		<td width="85%" colspan="3">
		  	<%@include file="/sys/notify/include/sysNotifyRemindCategory_edit.jsp"%>
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
					$("#sysAgendaCategoryTable").hide();
					break;
				}
			}
			$("[name='"+syncTimeProperty+"']").bind("click",function(){
				var k=0;
				for(k=0;k<noSyncTimeValues.length;k++){
					var noSyncTimeValue=noSyncTimeValues[k];
					if($(":input[name='"+syncTimeProperty+"']:checked").val()==noSyncTimeValue){
						$("#sysAgendaCategoryTable").hide();
						break;
					}
				}
				if(k>=noSyncTimeValues.length){
					$("#sysAgendaCategoryTable").show();
				}
			});
		}
	});
</script>
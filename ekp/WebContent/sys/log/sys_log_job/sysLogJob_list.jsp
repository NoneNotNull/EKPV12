<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script>
Com_Parameter.IsAutoTransferPara = true;

Com_AddEventListener(window,'load',function(){
	var newForm = document.forms[0];
	if('autocomplete' in newForm)
		newForm.autocomplete = "off";
	else
		newForm.setAttribute("autocomplete","off");
});
</script>
<html:form action="/sys/log/sys_log_job/sysLogJob.do">
<div id="optBarDiv">
	<kmss:auth requestURL="/sys/log/sys_log_job/sysLogJob.do?method=deleteall" requestMethod="POST">
		<input type="button" value="<bean:message key="button.delete"/>"
			onclick="if(!List_ConfirmDel())return; Com_Submit(document.sysLogJobForm, 'deleteall');">
	</kmss:auth>
</div>
<% if (((Page)request.getAttribute("queryPage")).getTotalrows()==0){ %>
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
<% }else{ %>
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt"><input type="checkbox" name="List_Tongle"></td>
				<sunbor:column property="sysLogJob.fdStartTime">
					<bean:message bundle="sys-log" key="sysLogJob.fdStartTime"/>
				</sunbor:column>
				<sunbor:column property="sysLogJob.fdEndTime">
					<bean:message bundle="sys-log" key="sysLogJob.fdEndTime"/>
				</sunbor:column>
				<sunbor:column property="sysLogJob.fdSubject">
					<bean:message bundle="sys-log" key="sysLogJob.fdSubject"/>
				</sunbor:column>			
				<sunbor:column property="sysLogJob.fdSuccess">
					<bean:message bundle="sys-log" key="sysLogJob.fdSuccess"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<logic:iterate id="sysLogJob" name="queryPage" property="list" indexId="index">
			<tr kmss_href="<c:url value="/sys/log/sys_log_job/sysLogJob.do" />?method=view&fdId=<bean:write name="sysLogJob" property="fdId"/>">
				<td>
					<input type="checkbox" name="List_Selected" value="<bean:write name="sysLogJob" property="fdId"/>">
				</td>
				<td>
					<kmss:showDate type="datetime" value="${sysLogJob.fdStartTime}" />
				</td>
				<td>
					<kmss:showDate type="datetime" value="${sysLogJob.fdEndTime}" />
				</td>
				<td>
					<bean:write name="sysLogJob" property="fdSubject"/> 
				</td>
				<td>
					<sunbor:enumsShow value="${sysLogJob.fdSuccess}" enumsType="common_yesno" />
				</td>
			</tr>
		</logic:iterate>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
<% } %>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
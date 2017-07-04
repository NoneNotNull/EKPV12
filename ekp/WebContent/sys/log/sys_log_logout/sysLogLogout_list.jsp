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
<html:form action="/sys/log/sys_logout_info/sysLogLogout.do">
<div id="optBarDiv">
	<kmss:auth requestURL="/sys/log/sys_logout_info/sysLogLogout.do?method=deleteall" requestMethod="POST">
		<input type="button" value="<bean:message key="button.delete"/>"
			onclick="if(!List_ConfirmDel())return; Com_Submit(document.sysLogLogoutForm, 'deleteall');">
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
				<sunbor:column property="sysLogLogout.fdCreateTime">
					<bean:message bundle="sys-log" key="sysLogError.fdCreateTime"/>
				</sunbor:column>
				<sunbor:column property="sysLogLogout.fdIp">
					<bean:message bundle="sys-log" key="sysLogLogout.fdIp"/>
				</sunbor:column>
				<sunbor:column property="sysLogLogout.fdOperator">
					<bean:message bundle="sys-log" key="sysLogLogout.fdOperator"/>
				</sunbor:column>			
			</sunbor:columnHead>
		</tr>
		<logic:iterate id="sysLogLogout" name="queryPage" property="list" indexId="index">
			<tr kmss_href="<c:url value="/sys/log/sys_logout_info/sysLogLogout.do" />?method=view&fdId=<bean:write name="sysLogLogout" property="fdId"/>">
				<td>
					<input type="checkbox" name="List_Selected" value="<bean:write name="sysLogLogout" property="fdId"/>">
				</td>
				<td>
					<kmss:showDate type="datetime" value="${sysLogLogout.fdCreateTime}" />
				</td>
				<td>
					<c:out value="${sysLogLogout.fdIp}"/>
				</td>
				<td>
					<c:out value="${sysLogLogout.fdOperator}"/>
				</td>
			</tr>
		</logic:iterate>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
<% } %>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
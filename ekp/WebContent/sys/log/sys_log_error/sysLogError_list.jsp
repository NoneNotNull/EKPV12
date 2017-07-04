<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.log.model.BaseSysLogError" %>
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
<html:form action="/sys/log/sys_log_error/sysLogError.do">
<div id="optBarDiv">
	<kmss:auth requestURL="/sys/log/sys_log_error/sysLogError.do?method=deleteall" requestMethod="POST">
		<input type="button" value="<bean:message key="button.delete"/>"
			onclick="if(!List_ConfirmDel())return; Com_Submit(document.sysLogErrorForm, 'deleteall');">
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
				<sunbor:column property="sysLogError.fdCreateTime">
					<bean:message bundle="sys-log" key="sysLogError.fdCreateTime"/>
				</sunbor:column>
				<sunbor:column property="sysLogError.fdIp">
					<bean:message bundle="sys-log" key="sysLogError.fdIp"/>
				</sunbor:column>
				<sunbor:column property="sysLogError.fdOperator">
					<bean:message bundle="sys-log" key="sysLogError.fdOperator"/>
				</sunbor:column>			
				<sunbor:column property="sysLogError.fdUrl">
					<bean:message bundle="sys-log" key="sysLogError.fdUrl"/>
				</sunbor:column>
				<sunbor:column property="sysLogError.fdMethod">
					<bean:message bundle="sys-log" key="sysLogError.fdMethod"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<logic:iterate id="sysLogError" name="queryPage" property="list" indexId="index">
			<tr kmss_href="<c:url value="/sys/log/sys_log_error/sysLogError.do" />?method=view&fdId=<bean:write name="sysLogError" property="fdId"/>">
				<td>
					<input type="checkbox" name="List_Selected" value="<bean:write name="sysLogError" property="fdId"/>">
				</td>
				<td>
					<kmss:showDate type="datetime" value="${sysLogError.fdCreateTime}"/>
				</td>
				<td>
					<bean:write name="sysLogError" property="fdIp"/> 
				</td>
				<td>
					<bean:write name="sysLogError" property="fdOperator"/> 
				</td>
				<td style="word-break:break-all;">
					<%
						String url = ((BaseSysLogError)pageContext.getAttribute("sysLogError")).getFdUrl();
						int i = url.indexOf('?');
						if(i>-1)
							url = url.substring(0, i);
						out.write(url);
					%>
				</td>
				<td>
					<bean:write name="sysLogError" property="fdMethod"/>
				</td>
			</tr>
		</logic:iterate>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
<% } %>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.log.model.BaseSysLogApp" %>
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
<html:form action="/sys/log/sys_log_app/sysLogApp.do">
<div id="optBarDiv">
	<kmss:auth requestURL="/sys/log/sys_log_app/sysLogApp.do?method=deleteall" requestMethod="POST">
		<input type="button" value="<bean:message key="button.delete"/>"
			onclick="if(!List_ConfirmDel())return; Com_Submit(document.sysLogAppForm, 'deleteall');">
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
				<sunbor:column property="sysLogApp.fdCreateTime">
					<bean:message bundle="sys-log" key="sysLogApp.fdCreateTime"/>
				</sunbor:column>
				<sunbor:column property="sysLogApp.fdIp">
					<bean:message bundle="sys-log" key="sysLogApp.fdIp"/>
				</sunbor:column>
				<sunbor:column property="sysLogApp.fdOperator">
					<bean:message bundle="sys-log" key="sysLogApp.fdOperator"/>
				</sunbor:column>			
				<sunbor:column property="sysLogApp.fdUrl">
					<bean:message bundle="sys-log" key="sysLogApp.fdUrl"/>
				</sunbor:column>
				<sunbor:column property="sysLogApp.fdParaMethod">
					<bean:message bundle="sys-log" key="sysLogApp.fdParaMethod"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<logic:iterate id="sysLogApp" name="queryPage" property="list" indexId="index">
			<tr kmss_href="<c:url value="/sys/log/sys_log_app/sysLogApp.do" />?method=view&fdId=<bean:write name="sysLogApp" property="fdId"/>">
				<td>
					<input type="checkbox" name="List_Selected" value="<bean:write name="sysLogApp" property="fdId"/>">
				</td>
				<td>
					<kmss:showDate type="datetime" value="${sysLogApp.fdCreateTime}"/>
				</td>
				<td>
					<bean:write name="sysLogApp" property="fdIp"/> 
				</td>
				<td>
					<bean:write name="sysLogApp" property="fdOperator"/> 
				</td>
				<td style="word-break:break-all;">
					<%
						String url = ((BaseSysLogApp)pageContext.getAttribute("sysLogApp")).getFdUrl();
						int i = url.indexOf('?');
						if(i>-1)
							url = url.substring(0, i);
						out.write(url);
					%>
				</td>
				<td>
					<% try{ %>
						<bean:message key="button.${sysLogApp.fdParaMethod}"/>
					<% }catch(Exception e){ %>
						<bean:write name="sysLogApp" property="fdParaMethod"/>
					<% } %>
				</td>
			</tr>
		</logic:iterate>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
<% } %>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
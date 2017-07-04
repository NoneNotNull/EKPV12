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
<html:form action="/sys/log/sys_log_organization/sysLogOrganization.do">
<div id="optBarDiv">
	<kmss:auth requestURL="/sys/log/sys_log_organization/sysLogOrganization.do?method=deleteall" requestMethod="POST">
		<input type="button" value="<bean:message key="button.delete"/>"
			onclick="if(!List_ConfirmDel())return; Com_Submit(document.sysLogOrganizationForm, 'deleteall');">
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
				<sunbor:column property="sysLogOrganization.fdCreateTime">
					<bean:message key="page.serial"/>
				</sunbor:column>
				<sunbor:column property="sysLogOrganization.fdCreateTime">
					<bean:message bundle="sys-log" key="sysLogApp.fdCreateTime"/>
				</sunbor:column>
				<sunbor:column property="sysLogOrganization.fdIp">
					<bean:message bundle="sys-log" key="sysLogApp.fdIp"/>
				</sunbor:column>
				<sunbor:column property="sysLogOrganization.foperator">
					<bean:message bundle="sys-log" key="sysLogApp.fdOperator"/>
				</sunbor:column>			
				<sunbor:column property="sysLogOrganization.fdParaMethod">
					<bean:message bundle="sys-log" key="sysLogApp.fdParaMethod"/>
				</sunbor:column>
				<sunbor:column property="sysLogOrganization.fdDetails">
					<bean:message bundle="sys-log" key="page.button.moreinfo"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<logic:iterate id="sysLogOrganization" name="queryPage" property="list" indexId="index">
			<tr kmss_href="<c:url value="/sys/log/sys_log_organization/sysLogOrganization.do" />?method=view&fdId=<bean:write name="sysLogOrganization" property="fdId"/>">
				<td>
					<input type="checkbox" name="List_Selected" value="<bean:write name="sysLogOrganization" property="fdId"/>">
				</td>
				<td>
					${index+1}
				</td>
				<td>
					<kmss:showDate type="datetime" value="${sysLogOrganization.fdCreateTime}"/>
				</td>
				<td>
					<bean:write name="sysLogOrganization" property="fdIp"/> 
				</td>
				<td>
					<bean:write name="sysLogOrganization" property="fdOperator"/> 
				</td>
				<td>
					<% try{ %>
						<bean:message key="button.${sysLogOrganization.fdParaMethod}"/>
					<% }catch(Exception e){ %>
							<% try{ %>
								<bean:message bundle="sys-log" key="sysLogOrganization.${sysLogOrganization.fdParaMethod}"/>
							<%}catch(Exception ex){ %>
								<bean:write name="sysLogOrganization" property="fdParaMethod"/>
							<% } %>
					<% } %>
					
				</td>
				<td style="text-align: left;">
					${sysLogOrganization.fdDetails}
				</td>
			</tr>
		</logic:iterate>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
<% } %>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
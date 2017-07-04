<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/organization/sys_org_person/sysOrgPerson.do">
<c:if test="${param.hidetoplist != 'true'}">
<%@ include file="/sys/organization/sysOrg_listtop.jsp"%>
</c:if>
<kmss:ifModuleExist path="/km/resinfo/">
<c:if test="${param.hidetoplist == 'true'}">
	<input type="radio" id="available" name="f_stype" value='available' onclick="changePersonTypeList(value)"><bean:message bundle="sys-organization" key="sysOrgPerson.available" />
	<input type="radio" id="abandon" name="f_stype" value='abandon' onclick="changePersonTypeList(value)"><bean:message bundle="sys-organization" key="sysOrgPerson.abandon" />
	<script>
	Com_Parameter.IsAutoTransferPara = true;
	function changePersonTypeList(value){
		Com_Parameter.IsAutoTransferPara = false;
		var url = location.href.toString();
		if ("abandon" == value) {
			url = Com_SetUrlParameter(url, "abandon", "true");
			
		} else {
			url = Com_SetUrlParameter(url, "abandon", null);
		}
		Com_OpenWindow(url, "_self");
	}
	function resetPersonRadio(){
		var value = Com_GetUrlParameter(location.href, "abandon");
		if (null != value && ("true" == value || "1" == value)) {
			var field = document.getElementById("abandon");
			field.checked = true;
		} else {
			var field = document.getElementById("available");
			field.checked = true;
		}
	}
	resetPersonRadio();
	</script>
</c:if>
</kmss:ifModuleExist>
<script>Com_IncludeFile("dialog.js");</script>
<div id="optBarDiv">
	<%
		String url = request.getParameter("parent");
		url = "/sys/organization/sys_org_person/sysOrgPerson.do?"+(url==null?"":"parent="+url+"&");
		pageContext.setAttribute("actionUrl", url);
	%>
	<kmss:auth requestURL="${actionUrl}method=add" requestMethod="GET">
		<input type="button" name="method"
			onclick="Com_OpenWindow('<c:url value="/sys/organization/sys_org_person/sysOrgPerson.do" />?method=add');"
			value="<bean:message key="button.add"/>" />
	</kmss:auth>
	<c:if test="${param.available != '0'}">
	<kmss:auth requestURL="${actionUrl}method=invalidatedAll" requestMethod="POST">
		<input type="button"  name="method"
			onclick="if(!List_ConfirmInvalid())return;Com_Submit(document.sysOrgPersonForm, 'invalidatedAll');"
			value="<bean:message bundle="sys-organization" key="organization.invalidated" />">
	</kmss:auth>
	</c:if>
	<c:if test="${param.all != 'true'}">
	<kmss:auth requestURL="${actionUrl}method=quickSort" requestMethod="GET">
		<input type="button"
			value="<bean:message bundle="sys-organization" key="sysOrgQuickSort.button" />"
			onclick="Dialog_PopupWindow(Com_Parameter.ContextPath+'resource/jsp/frame.jsp?url='+encodeURIComponent(Com_Parameter.ContextPath+'sys/organization/sys_org_quick_sort/SysOrgQuickSort.do?method=quickSort&type=8&parentId=${param.parent}'),'650','500');">
	</kmss:auth>
	</c:if>	
</div>
	<% if (((Page)request.getAttribute("queryPage")).getTotalrows()==0){ %>
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
	<% }else{ %>
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt"><input type="checkbox" name="List_Tongle"></td>
				<sunbor:column property="sysOrgPerson.fdOrder">
					<bean:message bundle="sys-organization" key="sysOrgPerson.fdOrder" />
				</sunbor:column>
				<sunbor:column property="sysOrgPerson.hbmParent.fdName">
					<bean:message bundle="sys-organization" key="sysOrgPerson.fdParent" />
				</sunbor:column>
				<sunbor:column property="sysOrgPerson.fdName">
					<bean:message bundle="sys-organization" key="sysOrgPerson.fdName" />
				</sunbor:column>
				<sunbor:column property="sysOrgPerson.fdLoginName">
					<bean:message bundle="sys-organization" key="sysOrgPerson.fdLoginName" />
				</sunbor:column>
				<sunbor:column property="sysOrgPerson.fdEmail">
					<bean:message bundle="sys-organization" key="sysOrgPerson.fdEmail" />
				</sunbor:column>
				<sunbor:column property="sysOrgPerson.fdMobileNo">
					<bean:message bundle="sys-organization" key="sysOrgPerson.fdMobileNo" />
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<logic:iterate id="sysOrgPerson" name="queryPage" property="list"
			indexId="index">
			<tr
				kmss_href="<c:url value="/sys/organization/sys_org_person/sysOrgPerson.do" />?method=view&fdId=<bean:write name="sysOrgPerson" property="fdId"/>">
				<td>
					<c:if test="${sysOrgPerson.anonymous}">
						<input type="checkbox" name="List_Selected" disabled="disabled" value="<bean:write name="sysOrgPerson" property="fdId" />">
					</c:if>
					<c:if test="${!sysOrgPerson.anonymous}">
						<input type="checkbox" name="List_Selected" value="<bean:write name="sysOrgPerson" property="fdId" />">
					</c:if>
				</td>
				<td width="80px"><bean:write name="sysOrgPerson" property="fdOrder" /></td>
				<td width="160px"><c:out value="${sysOrgPerson.fdParent.fdName}" /></td>
				<td width="100px"><bean:write name="sysOrgPerson" property="fdName" /></td>
				<td width="100px"><bean:write name="sysOrgPerson" property="fdLoginName" /></td>								
				<td><bean:write name="sysOrgPerson" property="fdEmail" /></td>
				<td><bean:write name="sysOrgPerson" property="fdMobileNo" /></td>
			</tr>
		</logic:iterate>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
<% } %>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
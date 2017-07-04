<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script>
	Com_IncludeFile("dialog.js");

	Com_AddEventListener(window,'load',function(){
		var newForm = document.forms[0];
		if('autocomplete' in newForm)
			newForm.autocomplete = "off";
		else
			newForm.setAttribute("autocomplete","off");
	});
</script>
<html:form action="/sys/log/sys_log_online/sysLogOnline.do">
<table width="100%">
	<tr>
		<td align="left">
			<label><input type=radio name="fd_type" value='online' onclick="listFilterChange();"><bean:message bundle="sys-log" key="sysLogOnline.online" /></label>
			<label><input type=radio name="fd_type" value='offline' onclick="listFilterChange();"><bean:message bundle="sys-log" key="sysLogOnline.offline" /></label>
			<label><input type=radio name="fd_type" value='all' onclick="listFilterChange();"><bean:message bundle="sys-log" key="sysLogOnline.all" /></label>
			<script>
			function listFilterChange(){
				var url = Com_Parameter.ContextPath+"sys/log/sys_log_online/sysLogOnline.do?method=list";
				url = Com_SetUrlParameter(url, "s_path", Com_GetUrlParameter(location.href, "s_path"));
				url = Com_SetUrlParameter(url, "s_css", Com_GetUrlParameter(location.href, "s_css"));
				var _type = document.getElementsByName("fd_type");				
				for(var i = 0; i < _type.length; i++) {
					if(_type[i].checked == true){
						url = Com_SetUrlParameter(url, "type", _type[i].value);
						break;
					}
				}
				var _deptId = document.getElementsByName("fdDeptId")[0];
				url = Com_SetUrlParameter(url, "deptId", _deptId.value);
				var _deptName = document.getElementsByName("fdDeptName")[0];
				url = Com_SetUrlParameter(url, "deptName", _deptName.value);
				Com_OpenWindow(url, "_self");
			}
			
			function resetRadio() {
				var url = location.href.toString();
				var _type = Com_GetUrlParameter(url, "type");
				var fields = document.getElementsByName("fd_type");
				if(_type == '' || _type == null){
					_type = 'online'; 
				}
				
				for(var i = 0; i < fields.length; i++) {
					if(fields[i].value == _type){
						fields[i].checked = true;
						break;
					}
				}
			}
			function resetDept() {
				var url = location.href.toString();
				var _deptId = Com_GetUrlParameter(url, "deptId");
				var _deptName = Com_GetUrlParameter(url, "deptName");
				if(_deptId != '' && _deptId != null){
					var deptId = document.getElementsByName("fdDeptId")[0];
					deptId.value = _deptId;
					var deptName = document.getElementsByName("fdDeptName")[0];
					deptName.value = _deptName;
				}
			}
			function resetListForm(){
				 resetRadio();
				 resetDept();
			}
			Com_AddEventListener(window, "load", function() {resetListForm();});
			</script> 
			<span style="padding-left: 15px;"><bean:message bundle="sys-log" key="sysLogOnline.fdDept" /></span>
			<input type="hidden" name="fdDeptId"/>
			<input type="text" name="fdDeptName" style="width: 150px" class="inputsgl" readonly="true"/>
			<a href="#" style="text-decoration:none"
			   onclick="Dialog_Address(false, 'fdDeptId', 'fdDeptName', null, ORG_TYPE_ORGORDEPT,listFilterChange);">
				<bean:message key="dialog.selectOrg" />
			</a>
			<span style="font-weight: bold; padding-left: 15px;"><bean:message bundle="sys-log" key="sysLogOnline.currentOnlineUserNum"/>
			<font style="color:red;">${requestScope.fdOnlineUserNum}</font></span>
		</td>
	</tr>
</table>
<c:if test="${queryPage.totalrows==0}">
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
</c:if>
<c:if test="${queryPage.totalrows>0}">
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt">
					<input type="checkbox" name="List_Tongle">
				</td>
				<td width="40pt">
					<bean:message key="page.serial"/>
				</td>
				<sunbor:column property="sysLogOnline.fdPerson.fdName">
					<bean:message bundle="sys-log" key="sysLogOnline.fdPerson"/>
				</sunbor:column>
				<sunbor:column property="sysLogOnline.fdPerson.hbmParent.fdName">
					<bean:message bundle="sys-log" key="sysLogOnline.fdDept"/>
				</sunbor:column>				
				<sunbor:column property="sysLogOnline.fdOnlineTime">
					<bean:message bundle="sys-log" key="sysLogOnline.isOnline"/>
				</sunbor:column>
				<sunbor:column property="sysLogOnline.fdOnlineTime">
					<bean:message bundle="sys-log" key="sysLogOnline.fdOnlineTime"/>
				</sunbor:column>				
				<sunbor:column property="sysLogOnline.fdLoginTime">
					<bean:message bundle="sys-log" key="sysLogOnline.fdLoginTime"/>
				</sunbor:column>
				<sunbor:column property="sysLogOnline.fdLoginIp">
					<bean:message bundle="sys-log" key="sysLogOnline.fdLoginIp"/>
				</sunbor:column>
				<sunbor:column property="sysLogOnline.fdLastLoginTime">
					<bean:message bundle="sys-log" key="sysLogOnline.fdLastLoginTime"/>
				</sunbor:column>
				<sunbor:column property="sysLogOnline.fdLastLoginIp">
					<bean:message bundle="sys-log" key="sysLogOnline.fdLastLoginIp"/>
				</sunbor:column>
				<sunbor:column property="sysLogOnline.fdLoginNum">
					<bean:message bundle="sys-log" key="sysLogOnline.fdLoginNum"/>
				</sunbor:column>
				<sunbor:column property="sysLogOnline.docCreateTime">
					<bean:message bundle="sys-log" key="sysLogOnline.docCreateTime"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysLogOnline" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/log/sys_log_online/sysLogOnline.do" />?method=view&fdId=${sysLogOnline.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysLogOnline.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${sysLogOnline.fdPerson.fdName}" />
				</td>
				<td title="${sysLogOnline.fdPerson.fdParentsName}">
					<c:out value="${sysLogOnline.fdPerson.fdParent.fdName}"/>
				</td>
				<td>
					<c:out value="${sysLogOnline.fdIsUserOnline}" />
				</td>
				<td>
					<c:out value="${sysLogOnline.fdOnlineTime}" />
				</td>
				<td>
					<kmss:showDate value="${sysLogOnline.fdLoginTime}" />
				</td>
				<td>
					<c:out value="${sysLogOnline.fdLoginIp}" />
				</td>
				<td>
					<kmss:showDate value="${sysLogOnline.fdLastLoginTime}" />
				</td>
				<td>
					<c:out value="${sysLogOnline.fdLastLoginIp}" />
				</td>
				<td>
					<c:out value="${sysLogOnline.fdLoginNum}" />
				</td>
				<td>
					<kmss:showDate value="${sysLogOnline.docCreateTime}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
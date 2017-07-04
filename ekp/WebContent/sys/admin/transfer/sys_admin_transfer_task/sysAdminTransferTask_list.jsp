<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<kmss:windowTitle subjectKey="sys-admin-transfer:module.sys.admin.transfer" moduleKey="sys-admin:home.nav.sysAdmin" />
<script>
Com_IncludeFile("jquery.js");
</script>
<script type="text/javascript" src="<c:url value="/sys/admin/resource/js/ajaxSyncComponent.js"/>"></script>
<script>
Lang = {
	todo: '<bean:message bundle="sys-admin-transfer" key ="sysAdminTransferTask.fdStatus.todo" />',
	done: '<bean:message bundle="sys-admin-transfer" key ="sysAdminTransferTask.fdStatus.done" />',
	waitting: '<bean:message bundle="sys-admin-transfer" key ="label.waitting" />',
	running: '<bean:message bundle="sys-admin-transfer" key ="label.running" />',
	notruned: '<bean:message bundle="sys-admin-transfer" key ="sysAdminTransferTask.fdStatus.not.runed" />',
	runed: '<bean:message bundle="sys-admin-transfer" key ="sysAdminTransferTask.fdStatus.runed" />',
	notread: '<bean:message bundle="sys-admin-transfer" key ="sysAdminTransferTask.fdStatus.not.read" />',
	read: '<bean:message bundle="sys-admin-transfer" key ="sysAdminTransferTask.fdStatus.read" />',	
	deleted: '<bean:message bundle="sys-admin-transfer" key ="sysAdminTransferTask.fdStatus.deleted" />',
	info: '<bean:message bundle="sys-admin-transfer" key ="sysAdminTransferTask.fdResult.info" />',
	warn: '<bean:message bundle="sys-admin-transfer" key ="sysAdminTransferTask.fdResult.warn" />',
	error: '<bean:message bundle="sys-admin-transfer" key ="sysAdminTransferTask.fdResult.error" />'
};
function List_ConfirmTransfer(checkName){
	return List_CheckSelect(checkName) && confirm('<bean:message bundle="sys-admin-transfer" key="page.comfirmTransferAll"/>');
}
// 禁止链接
function disabled(disabled){
	var btns = document.getElementsByTagName("INPUT");
	for(var i = 0; i < btns.length; i++) {
		if(btns[i].type == "button" || btns[i].type == "image" || btns[i].type == "radio") {
			btns[i].disabled = disabled;
		}
	}
	btns = document.getElementsByTagName("A");
	for(var j = 0; j < btns.length; j++){
		btns[j].disabled = disabled;
	}
}
function transferAll() {
	disabled(true);
	var url = Com_Parameter.ContextPath+"sys/admin/resource/jsp/jsonp.jsp?s_bean=sysAdminTransferTaskService";
	var component = ajaxSyncComponent(url); // ajax异步顺序执行
	var obj = document.getElementsByName("List_Selected");
	for(var i = 0; i < obj.length; i++) {
		if(obj[i].checked && !obj[i].disabled) {
			component.addData({fdId: obj[i].value});
			$("#status_"+obj[i].value).html("<b><font color='red'>"+Lang.waitting+"</font></b>");
			obj[i].disabled = true;
			obj[i].checked = false;
		}
	}
	component.beforeRequest = function(comp) {
		$("#status_"+comp.datas[comp.index].fdId).html("<b><font color='red'>"+Lang.running+"</font></b>");
	};
	component.afterResponse = function(json, comp) {
		if(json) {
			if(json.status=='0') { // 未执行
				$("#status_"+comp.datas[comp.index-1].fdId).html("<b><font color='black'>"+Lang.notruned+"</font></b>");
			} else if(json.status=='1') { // 已执行
				$("#status_"+comp.datas[comp.index-1].fdId).html("<b><font color='black'>"+Lang.runed+"</font></b>");
			} else if(json.status=='2') { // 待查阅
				$("#status_"+comp.datas[comp.index-1].fdId).html("<b><font color='black'>"+Lang.notread+"</font></b>");
			} else if(json.status=='3') { // 已查阅
				$("#status_"+comp.datas[comp.index-1].fdId).html("<b><font color='black'>"+Lang.read+"</font></b>");
			} else if(json.status=='9') { // 已删除
				$("#status_"+comp.datas[comp.index-1].fdId).html("<b><font color='black'>"+Lang.deleted+"</font></b>");
			}
			if(json.result == '0') { // 成功
				$("#result_"+comp.datas[comp.index-1].fdId).html("<b><font color='green'>"+Lang.info+"</font></b>");
			} else if(json.result == '1') { // 警告
				$("#result_"+comp.datas[comp.index-1].fdId).html("<b><font color='yellow'>"+Lang.warn+"</font></b>");
			} else if(json.result == '2') { // 错误
				$("#result_"+comp.datas[comp.index-1].fdId).html("<b><font color='red'>"+Lang.error+"</font></b>");
			}
		}
	};
	component.onComplate = function(comp) {
		disabled(false);
	};
	component.traverse();
}
</script>
<html:form action="/sys/admin/transfer/sys_admin_transfer_task/sysAdminTransferTask.do">
	<div id="optBarDiv">
		<input type="button" value="<bean:message bundle="sys-admin-transfer" key="button.transfer"/>"
			onclick="if(!List_ConfirmTransfer())return;transferAll();">
		<input type="button"
			value="<bean:message key="button.close"/>"
			onclick="Com_CloseWindow();">
	</div>
	<table width="100%">
		<tr>
			<td align="left">
				<label><input type=radio name="fd_status" value='10' onclick="statusChange(this.value)"><bean:message bundle="sys-admin-transfer" key ="sysAdminTransferTask.fdStatus.todo" /></label>
				<label><input type=radio name="fd_status" value='20' onclick="statusChange(this.value)"><bean:message bundle="sys-admin-transfer" key ="sysAdminTransferTask.fdStatus.done" /></label>
				<label><input type=radio name="fd_status" value='9' onclick="statusChange(this.value)"><bean:message bundle="sys-admin-transfer" key="sysAdminTransferTask.fdStatus.deleted" /></label>
				<label><input type=radio name="fd_status" value='' onclick="statusChange(this.value)"><bean:message bundle="sys-admin-transfer" key="sysAdminTransferTask.fdStatus.all" /></label>
				<script>
				Com_Parameter.IsAutoTransferPara = true;
				function statusChange(name){
					Com_Parameter.IsAutoTransferPara = false;
					var url = Com_Parameter.ContextPath+"sys/admin/transfer/sys_admin_transfer_task/sysAdminTransferTask.do?method=list";
					url = Com_SetUrlParameter(url, "status", name);
					url = Com_SetUrlParameter(url, "s_path", Com_GetUrlParameter(location.href, "s_path"));
					url = Com_SetUrlParameter(url, "s_css", Com_GetUrlParameter(location.href, "s_css"));
					Com_OpenWindow(url, "_self");
				}
				function resetRadio() {
					var url = location.href.toString();
					var _status = Com_GetUrlParameter(url, "status");
					var fields = document.getElementsByName("fd_status");
					for(var i = 0; i < fields.length; i++) {
						if(fields[i].value == _status){
							fields[i].checked = true;
							break;
						}
					}
				}
				Com_AddEventListener(window, "load", function() {resetRadio();});
				</script>
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
					<input type="checkbox" name="List_Tongle" disabled="disabled">
				</td>
				<td width="40pt">
					<bean:message key="page.serial"/>
				</td>
				<td>
					<bean:message bundle="sys-admin-transfer" key="sysAdminTransferTask.fdType"/>
				</td>
				<sunbor:column property="sysAdminTransferTask.fdName">
					<bean:message bundle="sys-admin-transfer" key="sysAdminTransferTask.fdName"/>
				</sunbor:column>
				<sunbor:column property="sysAdminTransferTask.fdDescription">
					<bean:message bundle="sys-admin-transfer" key="sysAdminTransferTask.fdDescription"/>
				</sunbor:column>
				<sunbor:column property="sysAdminTransferTask.fdStatus">
					<bean:message bundle="sys-admin-transfer" key="sysAdminTransferTask.fdStatus"/>
				</sunbor:column>
				<sunbor:column property="sysAdminTransferTask.fdResult">
					<bean:message bundle="sys-admin-transfer" key="sysAdminTransferTask.fdResult"/>
				</sunbor:column>
				<sunbor:column property="sysAdminTransferTask.docCreateTime">
					<bean:message bundle="sys-admin-transfer" key="sysAdminTransferTask.docCreateTime"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysAdminTransferTask" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/admin/transfer/sys_admin_transfer_task/sysAdminTransferTask.do" />?method=view&fdId=${sysAdminTransferTask.fdId}"
				title='<bean:message bundle="sys-admin-transfer" key="link.see.detail"/>'>
				<td>
					<c:choose>
					<c:when test="${sysAdminTransferTask.fdStatus == '0' || sysAdminTransferTask.fdStatus == '2'}">
						<input type="checkbox" name="List_Selected" value="${sysAdminTransferTask.fdId}" checked="checked">
					</c:when>
					<c:otherwise>
						<input type="checkbox" name="List_Selected" value="${sysAdminTransferTask.fdId}" disabled="disabled">
					</c:otherwise>
					</c:choose>
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td width="80px">
					<b>
					<c:choose>
					<c:when test="${sysAdminTransferTask.fdStatus == '0' || sysAdminTransferTask.fdStatus == '1'}">
						<bean:message bundle="sys-admin-transfer" key="sysAdminTransferTask.fdType.transfer"/>
					</c:when>
					<c:otherwise>
						<bean:message bundle="sys-admin-transfer" key="sysAdminTransferTask.fdType.notify"/>
					</c:otherwise>
					</c:choose>
					</b>
				</td>				
				<td width="10%">
					<c:out value="${sysAdminTransferTask.fdName}" />
				</td>
				<td style="text-align: left">
					<c:out value="${sysAdminTransferTask.fdDescription}" />
				</td>
				<td width="80px">
					<div id="status_${sysAdminTransferTask.fdId}">
					<xform:select property="fdStatus" showStatus="view" value="${sysAdminTransferTask.fdStatus}">
						<xform:enumsDataSource enumsType="sysAdminTransferTask.fdStatus" />
					</xform:select>
					</div>
				</td>
				<td width="50px">
					<div id="result_${sysAdminTransferTask.fdId}">
					<xform:select property="fdResult" showStatus="view" value="${sysAdminTransferTask.fdResult}">
						<xform:enumsDataSource enumsType="sysAdminTransferTask.fdResult" />
					</xform:select>
					</div>
				</td>
				<td width="100px">
					<kmss:showDate value="${sysAdminTransferTask.docCreateTime}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
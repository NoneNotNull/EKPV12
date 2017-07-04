<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.util.*,com.landray.kmss.util.*,net.sf.json.JSONArray,net.sf.json.JSONObject"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>

<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<div id="optBarDiv">
	<kmss:auth requestURL="/sys/notify/sys_notify_todo/sysNotifyTodo.do?method=mngList&owner=false">
	<input type="button"
		value="<bean:message key="button.edit"/>"
		onclick="Com_OpenWindow('sysNotifyCategory.do?method=edit&fdId=${param.fdId}','_self');">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('sysNotifyCategory.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>

	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="sys-notify" key="table.sysNotifyCategory"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-notify" key="sysNotifyCategory.fdName"/>
		</td>
		<td width=35% >
			<c:out value="${sysNotifyCategoryForm.fdName}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-notify" key="sysNotifyCategory.fdOrder"/>
		</td>
		<td width=35%>
			<c:out value="${sysNotifyCategoryForm.fdOrder}" />
		</td>
	</tr>
	
	<!--
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-notify" key="sysNotifyCategory.fdNo"/>
		</td>
		<td width=35%>
			<c:out value="${sysNotifyCategoryForm.fdNo}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-notify" key="sysNotifyCategory.fdOrder"/>
		</td>
		<td width=35%>
			<c:out value="${sysNotifyCategoryForm.fdOrder}" />
		</td>
	</tr>
-->
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-notify" key="sysNotifyCategory.fdModelNames"/>
		</td>
		<td colspan="3">
							<%
							JSONArray selMNames = (JSONArray)request.getAttribute("selMNames");
							for(int i=0;i<selMNames.size();i++){
								JSONObject selMName = selMNames.getJSONObject(i);
								out.print(selMName.getString("label")+"("+selMName.getString("name")+")<br>");
							}

							JSONArray others = (JSONArray)request.getAttribute("others");
							if(others!=null){
								for(int i=0;i<others.size();i++){
									JSONObject other = others.getJSONObject(i);
									out.print(other.getString("label")+"("+other.getString("name")+")<br>");
								}
							}
							%>
		</td>
	</tr>

		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="sys-notify" key="sysNotifyCategory.fdCreatorName"/>
			</td><td>
			<c:out value="${sysNotifyCategoryForm.fdCreatorName}" />
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="sys-notify" key="sysNotifyCategory.docCreateTime"/>
			</td><td>
				<c:out value="${sysNotifyCategoryForm.docCreateTime}" />
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="sys-notify" key="sysNotifyCategory.fdModifyName"/>
			</td><td>
				<c:out value="${sysNotifyCategoryForm.fdModifyName}" />
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="sys-notify" key="sysNotifyCategory.fdModifyTime"/>
			</td><td>
				<c:out value="${sysNotifyCategoryForm.fdModifyTime}" />
			</td>
		</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<style type="text/css">
#notify_content_1{
	display:inline-block;
	width:13px;
	height:11px;
	background: url(<c:url value='/resource/style/default/portal/icon_red.gif'/>) 50% 30% no-repeat;
}
#notify_content_2{
	display:inline-block;
	width:13px;
	height:11px;
	background: url(<c:url value='/resource/style/default/portal/icon_green.gif'/>) 50% 30% no-repeat;
}
#notify_content_3{
	display:inline-block;
	width:13px;
	height:11px;
	background: url(<c:url value='/resource/style/default/portal/icon_blue.gif'/>) 50% 30% no-repeat;
}
</style>
<script>
function List_ConfirmDel(checkName){
	return List_CheckSelect(checkName) && confirm("<bean:message key="page.comfirmDelete"/>");
}

function Search_Show(){
	Search_Div.style.top = 38+"px";
	Search_Div.style.display = "";
}

function Search_Hide(){
	Search_Div.style.display = "none";
}

function Search_Simple(){
	var keyField = document.getElementsByName("fdSubject")[0];
	if(keyField.value==""){
		alert('<bean:message key="error.search.keywords.required"/>');
		keyField.focus();
		return;
	}
	Search_Hide();
	var url = Com_CopyParameter('<c:url value="/sys/notify/sys_notify_todo/sysNotifyTodo.do"/>');
	var seq = parseInt(Com_GetUrlParameter(url, "s_seq"));
	seq = isNaN(seq)?1:seq+1;
	url = Com_SetUrlParameter(url, "s_seq", seq);
	url = Com_SetUrlParameter(url, "fdSubject", keyField.value);
	Com_OpenWindow(url,"_blank");
}

function Search_More(){
	Search_Hide();
	var url = Com_CopyParameter('<c:url value="/sys/notify/sys_notify_todo/sysNotifyTodoDone_mng_search.jsp"/>');
	Com_OpenWindow(url,"_blank");
}

</script>

<div id="optBarDiv">
<c:if test="${empty param.owner || param.owner == 'true'}">
	<input type="button" value="<bean:message key="button.delete"/>"
		onclick="if(!List_ConfirmDel())return; Com_Submit(document.sysNotifyTodoForm, 'deleteall');">
</c:if>
<c:if test="${not empty param.oprType && param.owner == 'false'}">
	<input type="button" value="<bean:message key="button.delete"/>"
		onclick="if(!List_ConfirmDel())return; Com_Submit(document.sysNotifyTodoForm, 'mngDelete');">
</c:if>
<input
	type="button"
	value="<bean:message key="button.search"/>"
	onclick="Search_Show();">
</div>
<div id="Search_Div" style="display:none; position:absolute; top:5px; right:20px;">
	<table class="tb_search">
		<tr>
			<td nowrap>
				&nbsp;<bean:message key="message.quickSearch"/>:<bean:message key="message.keyword"/>
			</td>
			<td nowrap>
				<input name="fdSubject" class="input_search" onkeydown="if (event.keyCode == 13 && this.value !='') Search_Simple();" >
				<input type="button" class="btn_search" onclick="Search_Simple();" value="<bean:message key="button.search"/>">
				<input type="button" class="btn_search" onclick="Search_More();" value="<bean:message key="button.advancedSearch"/>" >
			</td>
			<td valign="top">
				<a href="#">
					<img alt="<bean:message key="button.close"/>" border="0" src="${KMSS_Parameter_StylePath}icons/x.gif" width="5" height="5" hspace="2" vspace="2" onclick="Search_Hide();">
				</a>
			</td>
		</tr>
	</table>
</div>


<form action="<c:url value="/sys/notify/sys_notify_todo/sysNotifyTodo.do?finish=1"/>" 
	method="POST" 
	name="sysNotifyTodoForm">
	<%
	if (((Page) request.getAttribute("queryPage")).getTotalrows() == 0) {
	%>
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
	<%
	} else {
	%>
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt"><input
					type="checkbox"
					name="List_Tongle"></td>
				<td width="40pt"><bean:message key="page.serial" /></td>
				<sunbor:column property="f.FD_SUBJECT">
					<bean:message
						bundle="sys-notify"
						key="sysNotifyTodo.fdSubject" />
				</sunbor:column>
				<c:if test="${showApp==1}">
					<sunbor:column property="f.fd_app_name">
						<bean:message
							bundle="sys-notify"
							key="sysNotifyTodo.fdAppName" />
					</sunbor:column>
				</c:if>
				<c:if test="${param.fdType == null || param.fdType == ''}">
					<sunbor:column property="f.fd_type">
						<bean:message
							bundle="sys-notify"
							key="sysNotifyTodo.cate.title" />
					</sunbor:column>
				</c:if>
				<sunbor:column property="f.fd_create_time">
					<bean:message
						bundle="sys-notify"
						key="sysNotifyTodo.fdCreateDate" />
				</sunbor:column>
				<sunbor:column property="t.fd_finish_time">
					<bean:message
						bundle="sys-notify"
						key="sysNotifyTodo.finishDate" />
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach
			items="${queryPage.list}"
			var="sysNotifyTodoDoneInfo"
			varStatus="vstatus">
			<tr kmss_href="<c:url value="${sysNotifyTodoDoneInfo.todo.fdLink}"/>">
				<td><input
					type="checkbox"
					name="List_Selected"
					value="${sysNotifyTodoDoneInfo.todo.fdId}"></td>
				<td>${vstatus.index+1}</td>
				<td style="text-align: left;" title="${sysNotifyTodoDoneInfo.todo.subject4View}">
					<span id="notify_content_${sysNotifyTodoDoneInfo.todo.fdType}"></span>
					<c:choose>
						<c:when test="${fn:length(sysNotifyTodoDoneInfo.todo.subject4View)>33}">${fn:substring(sysNotifyTodoDoneInfo.todo.subject4View,0,32)}...</c:when>
						<c:otherwise><c:out value="${sysNotifyTodoDoneInfo.todo.subject4View}" /></c:otherwise>
					</c:choose>	
				</td>
				<c:if test="${showApp==1}">
					<td>
						<c:set var="appName" value="${sysNotifyTodoDoneInfo.todo.fdAppName}"/>
						<c:choose>
							<c:when test="${appName==null || appName=='' }">
								<bean:message bundle="sys-notify" key="sysNotifyTodo.todo.local.application.ekp.notify" />
							</c:when>
							<c:otherwise>
								<c:out value="${appName}"/>
							</c:otherwise>
						</c:choose>
					</td>
				</c:if>
				<c:if test="${param.fdType == null || param.fdType == ''}">
					<td><sunbor:enumsShow value="${sysNotifyTodoDoneInfo.todo.fdType}" enumsType="sys_todo_cate" bundle="sys-notify"/></td>
				</c:if>
				<td><kmss:showDate value="${sysNotifyTodoDoneInfo.todo.fdCreateTime}" type="datetime" /></td>
				<td><kmss:showDate value="${sysNotifyTodoDoneInfo.fdFinishTime}" type="datetime" /></td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp"%>
	<%
	}
	%>
</form>
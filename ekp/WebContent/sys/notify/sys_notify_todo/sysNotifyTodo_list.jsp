<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/resource/jsp/common.jsp"%>
<%@taglib uri="/WEB-INF/listview.tld" prefix="lv" %>
<lv:router>
<lv:custom><%-- ================== 自定义内容 ======================== --%>

<script>
function List_ConfirmDel(checkName){
	return List_CheckSelect(checkName) && confirm("<bean:message bundle="sys-notify" key="sysNotifyTodo.confirm.finish"/>");
}
</script>

<div id="optBarDiv">
	<input type="button" value="<bean:message bundle="sys-notify" key="sysNotifyTodo.button.finish"/>"
		onclick="if(!List_ConfirmDel())return; Com_Submit(document.sysNotifyTodoForm, 'deleteall');">
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<form action="<c:url value="/sys/notify/sys_notify_todo/sysNotifyTodo.do"/>" 
	method="POST" 
	name="sysNotifyTodoForm">
	<%@ include file="/resource/jsp/listview_center.jsp"%>
</form>
</lv:custom><%-- ================== 自定义内容 ======================== --%>
<lv:table><%-- ================== 列表 ======================== --%>
	<lv:head>
		<lv:selectCol />
		<lv:rowNumCol />
		<lv:column key="sysNotifyTodo.fdSubject" 
				   bundle="sys-notify" 
				   sortname="sysNotifyTodo.fdSubject"
				   sortable="false"/>
		<c:if test="${showApp==1}">
			<lv:column bundle="sys-notify"
					key="sysNotifyTodo.fdAppName"
					sortable="false"
					sortname="sysNotifyTodo.fdAppName"/>
		</c:if>
		<c:if test="${param.fdType == null || param.fdType == ''}">
			<lv:column key="sysNotifyTodo.cate.title" 
					   bundle="sys-notify" 
					   sortname="sysNotifyTodo.fdType" 
					   sortable="false"/>
		</c:if>
		<lv:column key="sysNotifyTodo.fdCreateDate" 
				   bundle="sys-notify" 
				   sortname="sysNotifyTodo.fdCreateTime" 
				   sortable="false"/>
	</lv:head>
	<lv:rows>
		<lv:attr>
			<c:if test="${bean.fdLink!=''}">
				<c:url value="/sys/notify/sys_notify_todo/sysNotifyTodo.do?method=view&fdId=${bean.fdId}"/>
			</c:if>
		</lv:attr>
		<lv:selectCell property="fdId" />
		<lv:rowNumCell />
		<lv:cell property="subject4View" />
		<c:if test="${showApp==1}">
			<lv:cell>
				<c:set var="appName" value="${bean.fdAppName}"/>
				<c:choose>
					<c:when test="${appName==null || appName=='' }">
						<bean:message bundle="sys-notify" key="sysNotifyTodo.todo.local.application.ekp.notify" />
					</c:when>
					<c:otherwise>
						<c:out value="${appName}"/>
					</c:otherwise>
				</c:choose>
			</lv:cell>
		</c:if>
		<c:if test="${param.fdType == null || param.fdType == ''}">
			<lv:cell>
				<sunbor:enumsShow value="${bean.fdType}" enumsType="sys_todo_cate" bundle="sys-notify"/>
			</lv:cell>
		</c:if>
		<lv:cell><kmss:showDate value="${bean.fdCreateTime}" type="datetime" /></lv:cell>
	</lv:rows>
</lv:table>
</lv:router>
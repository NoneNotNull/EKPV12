<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<style>
.tag_icon {
	display: inline-block;
	width:13px;
	height:11px;
	background: url(<c:url value='/resource/style/default/portal/icon_green.gif'/>) no-repeat 50% 30%;
}
.hover_td {
	border: 1px solid #000;
	background-color: #eee;
}
.normal_td {
	border: 1px solid #fff;
}
</style>
	<c:if test="${empty requestScope.mainModels}" >
		<center><bean:message key="return.noRecord"/></center>
	</c:if>
	<c:if test="${not empty requestScope.mainModels}" >
	<table style="width:95%">
		<%--tr>
			<td width="40pt"><bean:message key="page.serial"/></td>
			<td >
				<bean:message  bundle="sys-workflow" key="sysWfProcess.fdName"/>
			</td>
			<td >
				<bean:message  bundle="sys-workflow" key="sysWfProcess.fdStatus"/>
			</td>
			<td >
				<bean:message  bundle="sys-workflow" key="sysWfProcess.fdCreator"/>
			</td>
		</tr --%>
		<c:forEach items="${requestScope.mainModels}" var="mainModelMap" varStatus="vstatus">
			<c:set var="mainModel" value="${mainModelMap.model}" />
			<tr
				style="cursor: pointer;"
				modelId="${mainModel.fdId}"
				onclick="ViewSubprocess(this);">
				<td 
					class="normal_td"
					onmouseover="Onmouseover(this);"
					onmouseout="Onmouseout(this);">
					<span class="tag_icon"></span>
					<c:out value="${mainModel.docSubject}" />
					(<c:out value="${mainModel.docCreator.fdName}" />)
					<c:if test="${mainModel.docStatus < '10'}">
					 - <kmss:message key="status.discard"/>
					</c:if>
					<c:if test="${mainModel.docStatus >= '10' and mainModel.docStatus < '20'}">
					 - <kmss:message key="status.draft"/>
					</c:if>
					<c:if test="${mainModel.docStatus >= '20' and mainModel.docStatus < '30'}">
					 - <kmss:message key="status.examine"/>
					</c:if>
					<c:if test="${mainModel.docStatus >= '30' and mainModel.docStatus < '40'}">
					 - <kmss:message key="status.publish"/>
					</c:if>
					<c:if test="${mainModel.docStatus >= '40'}">
					 - <kmss:message key="status.expire"/>
					</c:if>
				</td>
			</tr>
		</c:forEach>
	</table>
	</c:if>
<script>
// id="List_ViewTable"
var FlowChartObject = parent.FlowChartObject;
function ViewSubprocess(tr) {
	var processId = tr.getAttribute('modelId');
	var url = "sys/lbpmservice/support/lbpm_process/lbpmProcess.do?method=viewSub&fdId=";
	url = Com_Parameter.ContextPath + url + processId;
	window.open(url);
	//if (FlowChartObject.InfoDialog && FlowChartObject.InfoDialog.viewSubFrame) {
		//FlowChartObject.InfoDialog.viewSubFrame.setUrl(url);
		//FlowChartObject.InfoDialog.viewSubFrame.show();
	//}
}
function Onmouseover(td) {
	td.className = "hover_td";
}
function Onmouseout(td) {
	td.className = "normal_td";
}
</script>
<%@ include file="/resource/jsp/list_down.jsp"%>
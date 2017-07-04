<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<div id="optBarDiv">
		<kmss:auth requestURL="/sys/task/sys_task_analyze/sysTaskAnalyze.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.edit"/>"
				onclick="Com_OpenWindow('sysTaskAnalyze.do?method=edit&fdId=${param.fdId}','_self');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/task/sys_task_analyze/sysTaskAnalyze.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.delete"/>"
				onclick="if(!confirmDelete())return;Com_OpenWindow('sysTaskAnalyze.do?method=delete&fdId=${param.fdId}','_self');">
		</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message  bundle="sys-task" key="table.sysTaskAnalyze"/></p>
<center>
<table class="tb_normal" width=95%>
		<html:hidden name="sysTaskAnalyzeForm" property="fdId"/>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskAnalyze.docSubject"/>
		</td><td width=35% colspan=3>
			<c:out value="${sysTaskAnalyzeForm.docSubject}"/>	
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskAnalyze.analyzeObj.type"/>
		</td><td width=35%>
			<sunbor:enumsShow value="${sysTaskAnalyzeForm.fdAnalyzeObjType}" enumsType="sysTaskAnalyze_analyzeObj_type"></sunbor:enumsShow>	
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskAnalyze.analyze.type"/>
		</td><td width=35%>
			<sunbor:enumsShow value="${sysTaskAnalyzeForm.fdAnalyzeType}" enumsType="sysTaskFreedback_analyze_type"></sunbor:enumsShow>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskAnalyze.analyzeObj.bound"/>
		</td><td width=35% colspan=3>
			<c:out value="${sysTaskAnalyzeForm.fdBoundNames}"/>		
		</td>
	</tr>
	<tr>
	<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskAnalyze.fdIsincludechild"/>
		</td><td width=35%>
		<c:choose>
		<c:when test="${sysTaskAnalyzeForm.fdIsincludechild==NULL}">
	    	<bean:message  bundle="sys-task" key="task.yesno.no"/>
		</c:when>
		<c:otherwise>
			<sunbor:enumsShow value="${sysTaskAnalyzeForm.fdIsincludechild}" enumsType="sysTaskAnalyze_fdIsincludechild"></sunbor:enumsShow>
		</c:otherwise>
	</c:choose>
	</td>
	<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskAnalyze.fdIsincludechildTask"/>
		</td><td width=35%>
	<c:choose>
		<c:when test="${sysTaskAnalyzeForm.fdIsincludechildTask==NULL}">
	    	<bean:message  bundle="sys-task" key="task.yesno.yes"/>
		</c:when>
		<c:otherwise>
			<sunbor:enumsShow value="${sysTaskAnalyzeForm.fdIsincludechildTask}" enumsType="sysTaskAnalyze_fdIsincludechildTask"></sunbor:enumsShow>		
		</c:otherwise>
	</c:choose>
	</td>
	</tr>
	<tr>
		<td colspan=4 class="td_normal_title" ><sunbor:multiSelectCheckbox formName="sysTaskAnalyzeForm"  enumsType="sysTaskAnalyze_fdDateQueryType" property="dateQueryTypeList"  htmlElementProperties = "disabled"></sunbor:multiSelectCheckbox></td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskAnalyze.startDate"/>
		</td><td width=35%>
			<c:out value="${sysTaskAnalyzeForm.fdStartDate}"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-task" key="sysTaskAnalyze.endDate"/>
		</td><td width=35%>
			<c:out value="${sysTaskAnalyzeForm.fdEndDate}"/>
		</td>
	</tr>
	<tr height="450" width=100%>
		<td  colspan="4" width="100%">
			<iframe frameborder="0" style="width:100%;height:100%" src="${KMSS_Parameter_ContextPath}sys/task/sys_task_analyze/sysTaskAnalyze.do?method=listResult&fdId=${sysTaskAnalyzeForm.fdId}&fdStartDate=${sysTaskAnalyzeForm.fdStartDate}&fdEndDate=${sysTaskAnalyzeForm.fdEndDate}&dateQueryType=${sysTaskAnalyzeForm.dateQueryTypeList[0]}${sysTaskAnalyzeForm.dateQueryTypeList[1]}" ></iframe>
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<p class="txttitle"><bean:message  bundle="sys-task" key="sysTaskEvaluate.detail"/></p><br><br>
<center>
<table class="tb_normal" width=80%>
		<html:hidden name="sysTaskEvaluateForm" property="fdId"/>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskEvaluate.docCreatorId"/>
		</td><td width=35%>
			<c:out value="${sysTaskEvaluateForm.docCreatorName}"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskEvaluate.docCreateTime"/>
		</td><td width=35%>
			<c:out value="${sysTaskEvaluateForm.docCreateTime}"/>
		</td>
	</tr>
	<!-- 满意度 -->
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskEvaluate.fdApprove"/>
		</td><td width=85% colspan=3>
			<c:out value="${sysTaskEvaluateForm.fdApproveName}"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			</br><bean:message  bundle="sys-task" key="sysTaskEvaluate.docContent"/><br></br>
		</td><td width=85% colspan=3>
			<kmss:showText value="${sysTaskEvaluateForm.docContent}"/>
		</td>
	</tr>
	
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
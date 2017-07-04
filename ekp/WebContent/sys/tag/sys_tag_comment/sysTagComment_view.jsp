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
	<kmss:auth requestURL="/sys/tag/sys_tag_comment/sysTagComment.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('sysTagComment.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message  bundle="sys-tag" key="table.sysTagComment"/></p>
<center>
<table class="tb_normal" width=95%>
	<html:hidden name="sysTagCommentForm" property="fdId"/>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagComment.fdAppraise"/>
		</td><td width=35% colspan="3">
			<sunbor:enumsShow value="${sysTagCommentForm.fdAppraise}" enumsType="sysTagComment_fdAppraise" bundle="sys-tag"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagComment.fdRemark"/>
		</td><td width=35% colspan="3">
			<kmss:showText value="${sysTagCommentForm.fdRemark}"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagComment.docCreatorId"/>
		</td><td width=35%>
			<c:out value="${sysTagCommentForm.docCreatorName}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagComment.docCreateTime"/>
		</td><td width=35%>
			<c:out value="${sysTagCommentForm.docCreateTime}" />
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<div id="optBarDiv">
	<kmss:auth requestURL="/sys/follow/sys_follow_person_doc_related/sysFollowPersonDocRelated.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('sysFollowPersonDocRelated.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/sys/follow/sys_follow_person_doc_related/sysFollowPersonDocRelated.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('sysFollowPersonDocRelated.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="sys-follow" key="table.sysFollowPersonDocRelated"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-follow" key="sysFollowPersonDocRelated.isread"/>
		</td><td width="35%">
			<xform:radio property="isRead">
				<xform:enumsDataSource enumsType="sys_follow_related_doc_status"></xform:enumsDataSource>
			</xform:radio>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-follow" key="sysFollowPersonDocRelated.readTime"/>
		</td><td width="35%">
			<xform:datetime property="readTime" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-follow" key="sysFollowPersonDocRelated.followConfig"/>
		</td><td width="35%">
			<c:out value="${sysFollowPersonDocRelatedForm.followConfigName}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-follow" key="sysFollowPersonDocRelated.followDoc"/>
		</td><td width="35%">
			<c:out value="${sysFollowPersonDocRelatedForm.followDocName}" />
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
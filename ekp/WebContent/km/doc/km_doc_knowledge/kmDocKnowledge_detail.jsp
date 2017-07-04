<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
		<table class="tb_normal" width="100%">
			<tr>
				<td valign="center" align="middle" width="55%"
					class="td_normal_title"><bean:message bundle="sys-doc"
					key="sysDocBaseInfo.docSubject" /></td>
				<td valign="center" align="middle" width="15%"
					class="td_normal_title"><bean:message bundle="sys-doc"
					key="sysDocBaseInfo.docCreator" /></td>
				<td valign="center" align="middle" width="15%"
					class="td_normal_title"><bean:message bundle="sys-doc"
					key="sysDocBaseInfo.docCreateTime" /></td>				
				<td valign="center" align="middle" width="10%"
					class="td_normal_title">
					<a href="javascript:location.reload();"><bean:message key="button.refresh"/></a>
					</td>
			</tr>
			<c:forEach items="${queryList}" var="kmDocKnowledge"
				varStatus="vstatus">
				<tr>
					<td align="left" width="35%"><a href="#"
						onclick="Com_OpenWindow('<c:url value="/km/doc/km_doc_knowledge/kmDocKnowledge.do" />?method=view&fdId=${kmDocKnowledge.fdId}')"><c:out
						value="${kmDocKnowledge.docSubject}" /></a></td>					
					<td align="middle" width="15%"><c:out
						value="${kmDocKnowledge.docCreator.fdName}" /></td>
					<td align="middle" width="15%"><c:out
						value="${kmDocKnowledge.docCreateTime}" /></td>
									
					<td align="middle" width="8%"><kmss:auth
						requestURL="/km/doc/km_doc_knowledge/kmDocKnowledge.do?method=delete&fdId=${kmDocKnowledge.fdId}"
						requestMethod="GET">
						<a href="#"
							onclick="if(!confirmDelete())return;Com_OpenWindow('<c:url value="/km/doc/km_doc_knowledge/kmDocKnowledge.do" />?method=delete&fdId=${kmDocKnowledge.fdId}','_blank');">
						<bean:message key="button.delete" /> </a>
					</kmss:auth></td>
				</tr>
			</c:forEach>
		</table>
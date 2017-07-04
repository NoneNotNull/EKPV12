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
	<kmss:auth requestURL="/kms/ask/kms_ask_post/kmsAskPost.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('kmsAskPost.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/kms/ask/kms_ask_post/kmsAskPost.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('kmsAskPost.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="kms-ask" key="table.kmsAskPost"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-ask" key="kmsAskPost.docContent"/>
		</td><td width="35%">
			<xform:rtf property="docContent" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-ask" key="kmsAskPost.fdIsBest"/>
		</td><td width="35%">
			<xform:radio property="fdIsBest">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:radio>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-ask" key="kmsAskPost.fdTopicFlag"/>
		</td><td width="35%">
			<xform:radio property="fdTopicFlag">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:radio>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-ask" key="kmsAskPost.fdAgreeNum"/>
		</td><td width="35%">
			<xform:text property="fdAgreeNum" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-ask" key="kmsAskPost.fdPostTime"/>
		</td><td width="35%">
			<xform:datetime property="fdPostTime" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-ask" key="kmsAskPost.fdCommentNum"/>
		</td><td width="35%">
			<xform:text property="fdCommentNum" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-ask" key="kmsAskPost.fdKmsAskTopic"/>
		</td><td width="35%">
			<c:out value="${kmsAskPostForm.fdKmsAskTopicName}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-ask" key="kmsAskPost.fdPoster"/>
		</td><td width="35%">
			<c:out value="${kmsAskPostForm.fdPosterName}" />
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
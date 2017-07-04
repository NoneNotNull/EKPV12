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
		<kmss:auth requestURL="/km/review/km_review_template_keyword/kmReviewTemplateKeyword.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.edit"/>"
				onclick="Com_OpenWindow('kmReviewTemplateKeyword.do?method=edit&fdId=${param.fdId}','_self');">
		</kmss:auth>
		<kmss:auth requestURL="/km/review/km_review_template_keyword/kmReviewTemplateKeyword.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.delete"/>"
				onclick="if(!confirmDelete())return;Com_OpenWindow('kmReviewTemplateKeyword.do?method=delete&fdId=${param.fdId}','_self');">
		</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message  bundle="km-review" key="table.kmReviewTemplateKeyword"/></p>
<center>
<table class="tb_normal" width=95%>
		<html:hidden name="kmReviewTemplateKeywordForm" property="fdId"/>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-review" key="table.kmReviewTemplate"/>.<bean:message  bundle="km-review" key="kmReviewTemplate.fdId"/>
		</td><td width=35%>
			<logic:present name="kmReviewTemplateKeywordForm" property="kmReviewTemplate">
				<bean:write name="kmReviewTemplateKeywordForm" property="kmReviewTemplate.fdId" />
			</logic:present>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-review" key="kmReviewTemplateKeyword.fdKeyword"/>
		</td><td width=35%>
			<bean:write name="kmReviewTemplateKeywordForm" property="fdKeyword"/>
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>

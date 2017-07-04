<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/kms/common/resource/ui/kms_list_top.jsp"%>
<script type="text/javascript">

	function resizeInterduceParent() {
		var td_introduce = parent.document
				.getElementById("wikiEvaluationContent");
		if (td_introduce.style.height) {
			td_introduce.style.height = $('table').height() + 20;
		} else {
			td_introduce.height = $('table').height() + 20;
		}
	}

	function selectDelete(fdId,obj){
		var that = obj;
		// 移除img-dom信息--更新数据库段落信息--删除img对应数据库信息
		var img = $('img[e_id="'+fdId+'"]',window.parent.document),editorDiv = img[0],fdCatalogId;
		while (editorDiv.parentNode) {
			editorDiv = editorDiv.parentNode;
			if (editorDiv.getAttribute('name')) {
				fdCatalogId = editorDiv.getAttribute('name');
				img.remove();
				break;
			}
		}
		if (fdCatalogId) {
			jQuery
				.post(
				'<c:url value="/kms/wiki/kms_wiki_catelog/kmsWikiCatelog.do?method=updateContent"/>', {
				docContent: editorDiv.innerHTML,
				fdId: fdCatalogId
			}, function(data, textStatus, xhr) {
				jQuery
				.post(
						'<c:url value="/kms/wiki/kms_wiki_evaluation/kmsWikiEvaluation.do?method=delete"/>',
						{
							fdId : fdId
						}, function(data, textStatus, xhr) {
							// 移除dom元素
							$(that.parentNode.parentNode).remove();
							resizeInterduceParent();
							parent.refreshEvaluationNum2(jQuery('img[e_id]', window.parent.document).size());
						});
				});
		}
	}
	
	jQuery( function() {
		var e_ids = "";
		jQuery('img[e_id]', window.parent.document).each(
				function(i) {
					if (jQuery(this).attr('e_id')) {
						e_ids += (i == 0 ? $(this).attr('e_id')
								: (';' + $(this).attr('e_id')));
					}
				});
		if(e_ids){
			jQuery
			.post(
					'<c:url value="/kms/wiki/kms_wiki_evaluation/kmsWikiEvaluation.do?method=viewAll"/>',
					{
						e_ids : e_ids
					}, function(data, textStatus, xhr) {
						if(data){
							$('#evaluation_tbody').html( KmsTmpl(document.getElementById('kmsWikiEvaluation').innerHTML)
									.render( {
										"data" : data
									}));
							$('#evaluation_div').show();
							$('#noneRecord').hide();
							resizeInterduceParent();
						}
					});
		}else{
			resizeInterduceParent();
		}
	});

</script>

<script type="text/html" id="kmsWikiEvaluation">
for(var i = 0;i<data.length;i++){
if(i%2===0){
	{$<tr onclick='parent.scrollTo("{%data[i].fdId%}")' style="cursor:pointer;">$}
}else{
	{$<tr class='t_b_a' onclick='parent.scrollTo("{%data[i].fdId%}")' style="cursor:pointer;"> $}
}
{$
	<td>
		{%i+1%}
	</td>
	<td style="text-align: left;" title="{%data[i].docSubject%}">
		{%resetStrLength(data[i].docSubject||'',60)%}
	</td>
	<td>
	</td>
	<td style="text-align: left;">
		{%resetStrLength(data[i].fdEvaluationContent||'',60)%}
	</td>
	<td>
		{%data[i].fdEvaluatorName%}
	</td>
	<td>
 		<kmss:auth  requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=delEvaluateSub&categoryId=${param.fdCategoryId}" requestMethod="GET">
		<a href="javascript:void(0)" onclick="selectDelete('{%data[i].fdId%}',this);">
			<bean:message key="button.delete" />
		</a>
		 </kmss:auth>
	</td>
</tr>
$}
}
</script>
<html:form action="/kms/wiki/kms_wiki_evaluation/kmsWikiEvaluation.do">
	<center id="noneRecord"><bean:message
		key="kmsWikiEvaluation.showText.noneRecord" bundle="kms-wiki" /></center>
	<div style="display: none;" id="evaluation_div">
	<table id="List_ViewEvaluationTable" class="t_b" border="0"
		cellspacing="0" cellpadding="0" width="100%">
		<tr>
			<td width="8%" class="t_b_b">NO.</td>
			<td width="35%"><bean:message bundle="kms-wiki"
				key="kmsWikiEvaluation.fdEvaluationContent" /></td>
			<td width="2%"></td>
			<td width="35%"><bean:message bundle="kms-wiki"
				key="kmsWikiEvaluation.docSubject" /></td>
			<td width="10%"><bean:message bundle="kms-wiki"
				key="kmsWikiEvaluation.fdEvaluator" /></td>
			<td width="10%"></td>
		</tr>
		<tbody id="evaluation_tbody">
		</tbody>
	</table>

	</div>

</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>

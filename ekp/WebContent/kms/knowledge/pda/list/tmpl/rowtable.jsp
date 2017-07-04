<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
{$
	<ul class="lui-rowtable-table">
$}
for(var i=0;i<data.length;i++){
{$
		<li onclick="window.open('${LUI_ContextPath}/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDoc.do?method=view&fdKnowledgeType={% data[i].fdKnowledgeType %}&fdId={% data[i].fdId %}','_self')">
			<article>
				<a>
					<img src="${LUI_ContextPath}{% data[i]['fdImageUrl'] %}"/>
				</a>
				<h3 class="textEllipsis"><a href="javascript:;">{% data[i]['docSubject'] %}</a></h3>
				<p class="textEllipsis">{% data[i]['fdDescription'] %}</p>
				<ul class="lui-grid-b clearfloat">
					<li ><em class="lui-icon-s-s lui-eval-icon">{%  data[i]['docEvalCount'] %}</em></li>
					<li ><em class="lui-icon-s-s lui-read-icon">{%  data[i]['docReadCount'] %}</em></li>
					<li ><em class="lui-icon-s-s lui-intro-icon">{% data[i]['docIntrCount'] %}</em></li>
				</ul>
			</article>
		</li>
$}
}
{$
	</ul>
$}
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
for(var i=0;i<data.length;i++){
{$
	
		<article class='___falls___'>
			<a href="${LUI_ContextPath}/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDoc.do?method=view&fdKnowledgeType={% data[i].fdKnowledgeType %}&fdId={% data[i].fdId %}">
				<img src="${LUI_ContextPath}/{% data[i]['fdImageUrl'] %}" width="100%" height="auto" class="___fallsimg___"/>
			</a>
			<div></div>
			<ul class="lui-grid-b clearfloat">
				<li ><em class="lui-icon-s-s lui-eval-icon-on">{%  data[i]['docEvalCount'] %}</em></li>
				<li ><em class="lui-icon-s-s lui-read-icon-on">{%  data[i]['docReadCount'] %}</em></li>
				<li ><em class="lui-icon-s-s lui-intro-icon-on">{% data[i]['docIntrCount'] %}</em></li>
			</ul>
		</article>
	
$}
}

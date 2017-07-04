<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
{$
	<ul class="lui-column-table">
$}

for(var i=0;i<data.length;i++){
{$
		<li>
			<h3 class="textEllipsis"><a href="${LUI_ContextPath}/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDoc.do?method=view&fdKnowledgeType={% data[i].fdKnowledgeType %}&fdId={% data[i].fdId %}">{% data[i]['label'] %}</a></h3>
		</li>
$}
}
{$
	</ul>
$}

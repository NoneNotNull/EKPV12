<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
{$
	<ul class="lui-column-table">
$}
for(var i=0;i<data.length;i++){
{$
		<li onclick="window.open('${LUI_ContextPath}/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDoc.do?method=view&fdKnowledgeType={% data[i].fdKnowledgeType %}&fdId={% data[i].fdId %}','_self')">
			<h3 class="textEllipsis"><a>{% data[i]['docSubject'] %}</a></h3>
			<p>{% data[i]['fdDescription'] %}</p>
			<ul class="clearfloat info">
				<li>
					{% data[i]['docCategory.fdName'] %}
				</li>
				
				<li>
					{% data[i]['docPublishTime'] %}
				</li>
			</ul>
		</li>
$}
}
{$
	</ul>
$}

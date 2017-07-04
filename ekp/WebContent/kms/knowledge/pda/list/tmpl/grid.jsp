<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
{$
	<ul class="lui-grid-table">
$}
for(var i=0;i<data.length;i++){
var href = '${LUI_ContextPath}/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDoc.do?method=view&fdKnowledgeType='+data[i].fdKnowledgeType+'&fdId='+data[i].fdId ;
{$
		<li onclick="window.open('{% href %}','_self')">
			<h3 class="textEllipsis"><a href="{% href %}">{% data[i]['docSubject'] %}</a></h3>
			<div class="info">
				<a href="{% href %}">
					<img src="${LUI_ContextPath}{% data[i]['fdImageUrl'] %}" alt="{% data[i]['docSubject'] %}">
				</a>
				<p class="description textEllipsis">{% Pda.Util.textEllipsis(data[i]['fdDescription'],84) %}</p>
				<span class="clearfloat">
					<p class="date">{% data[i]['docPublishTime'] %}</p>
					<ul class="lui-grid-b clearfloat">
						<li><em class="lui-icon-s-s lui-eval-icon">{%  data[i]['docEvalCount'] %}</em></li>
						<li><em class="lui-icon-s-s lui-read-icon">{%  data[i]['docReadCount'] %}</em></li>
						<li><em class="lui-icon-s-s lui-intro-icon">{% data[i]['docIntrCount'] %}</em></li>
					</ul>
				</span>
			</div>
		</li>
$}
}
{$
	</ul>
$}
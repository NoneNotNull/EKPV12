<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
{$
	<div class="lui-column-table">
$}

for(var i=0;i<data.length;i++){
{$
			<li onclick="window.open('${LUI_ContextPath}/kms/ask/kms_ask_topic/kmsAskTopic.do?method=view&fdId={%data[i]['fdId']%}','_self')">
				<h3 class="lui-ask-subject"> 
$}
				if(data[i]['fdStatus']==0){
					{$<span class="lui-ask-topic-ask lui-ask-topic-status"></span>$}
				} else {
					{$<span class="lui-ask-topic-ok lui-ask-topic-status" ></span>$}
				}
{$					
					<a>{% data[i]['label'] %}</a>
$}
				if(data[i].fdScore > 0) {
					{$ <span class="lui-ask-score"> {%data[i].fdScore%}</span> $}
				}
{$
				</h3>
				<ul class="clearfloat info">
					<li>
						回答 : {%data[i].fdReplyCount%}
					</li>
					<li>
						{%data[i].docCreateTime%}
					</li>
				</ul>
			</li>
$}
}
{$
	</div>
$}

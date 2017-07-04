<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:col-serial title="${ lfn:message('page.serial') }" headerStyle="width:5%"></list:col-serial>
<list:col-html title="${lfn:message('sys-evaluation:sysEvaluation.evalDoc') }" style="width:20%;text-align:left;padding:0 8px">
	var json = {};
	json['evalId'] = row['fdId'];
	json['modelId'] = row['fdModelId'];
	json['modelName'] = row['fdModelName'];
	if(!LUI("main_overView").evalDocSubject){
		LUI("main_overView").evalDocSubject = [];
	}
	LUI("main_overView").evalDocSubject.push(JSON.stringify(json));
							
	{$
		{%row['evalDocSubject']%}
	$}
</list:col-html>
<list:col-auto props="fdEvaluatorName;fdEvaluationTime;"></list:col-auto>
<list:col-html title="${lfn:message('sys-evaluation:sysEvaluation.evalContent')}" style="width:25%;text-align:left;padding:0 8px">
	{$	
		<span title="{%row['fdEvaluationContent']%}">
			{% strutil.textEllipsis(row['fdEvaluationContent'], 100) %}
		</span>
	$}
</list:col-html>
<list:col-auto props="fdEvaluationScore;docPraiseCount;fdReplyCount"></list:col-auto>
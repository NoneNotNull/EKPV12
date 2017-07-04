<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<c:set var="sysEvaluationForm" value="${requestScope[param.formName]}" />
<!-- 点赞 -->
<c:import
	url="/sys/evaluation/import/sysEvaluationMain_view_praise.jsp"
	charEncoding="UTF-8">
	<c:param name="praiseAreaName" value="eval_main" />
	<c:param name="listChannel" value="eval_chl" />
</c:import>
<list:listview channel="eval_chl" id="main_view">
	<ui:source type="AjaxJson">
		{url:'/sys/evaluation/sys_evaluation_main/sysEvaluationMain.do?method=list' +
				'&orderby=fdEvaluationTime&ordertype=down&forward=listUi&fdModelId=${sysEvaluationForm.evaluationForm.fdModelId}' +
				'&fdModelName=${sysEvaluationForm.evaluationForm.fdModelName}'}
	</ui:source>
	<list:rowTable channel="rowtable" isDefault="true" target="_blank" cfg-norecodeLayout="simple">
		<ui:layout type="Template">
			{$<div class="eval_record" data-lui-mark='table.content.inside'>
			</div>$}
		</ui:layout>
		<list:row-template>
			<c:import
				url="/sys/evaluation/import/sysEvaluationMain_view_tmpl.jsp"
				charEncoding="UTF-8">
				<c:param name="isViewMain" value="true" />
				<c:param name="fdModelName" value="com.landray.kmss.sys.evaluation.model.SysEvaluationMain" />
				<c:param name="eval_validateAuth" value="${param.eval_validateAuth=='true'}" />
			</c:import>
		</list:row-template>
	</list:rowTable>	
	<ui:event topic="list.loaded" args="vt"> 
		$("#eval_main").css({height:"auto"});
		var showReplyInfo = $("input[name='showReplyInfo']")[0].value;
		if(showReplyInfo!='false'){
			var ids = vt.table.ids;
			if(ids){
				for(var i=0;i<ids.length;i++){
					eval_opt.listReply(ids[i]);
				}
				vt.table.ids = [];
			}
		}
	</ui:event>
</list:listview>	
<list:paging channel="eval_chl" layout="sys.ui.paging.simple"></list:paging>
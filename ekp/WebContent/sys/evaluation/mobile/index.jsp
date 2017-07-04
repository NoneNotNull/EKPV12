<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="mobile.list">
	<template:replace name="head">
		<c:set var="s_requestUrl" value="/sys/evaluation/sys_evaluation_main/sysEvaluationMain.do?method=add&fdModelName=${param.modelName}&fdModelId=${param.modelId}" />
		<script type="text/javascript">
			require([ "dojo/topic", "dojo/dom","dojo/query","dijit/registry","dojo/domReady!" ], function(
					topic, dom, query,registry) {

				// 没数据给最小高度
				topic.subscribe('/mui/list/noData',function(){
					var muiOpt = registry.byId('muiEvalOpt');
					if (muiOpt)
						muiOpt.showMask();
					
					var h = dom.byId('eval_scollView').offsetHeight
							- dom.byId('eval_header').offsetHeight - 20;
					query('.muiListNoData').style({
						'line-height' : h + 'px',
						'height' : h + 'px'
					});
				});
			});
		</script>
	</template:replace>
	<template:replace name="content">
		
		<div id="eval_scollView"
			data-dojo-type="mui/view/DocScrollableView"
			data-dojo-mixins="mui/list/_ViewPushAppendMixin,mui/list/_ViewPullReloadMixin">
			<div data-dojo-type="sys/evaluation/mobile/js/EvaluationHeader" id="eval_header"
			 	data-dojo-props="fdModelId:'${param.modelId}',fdModelName:'${param.modelName}'">
			</div>
			
			<ul class="muiEvalStoreList" data-dojo-type="mui/list/JsonStoreList"
				data-dojo-mixins="${LUI_ContextPath}/sys/evaluation/mobile/js/EvaluationItemListMixin.js"
				data-dojo-props="url:'/sys/evaluation/sys_evaluation_main/sysEvaluationMain.do?method=list&forward=mobileList&fdModelId=${param.modelId}&fdModelName=${param.modelName}',lazy:false">
			</ul> 
		</div>
		<kmss:auth requestURL="${s_requestUrl}" requestMethod="GET">
			<div style="display: none;" id="eval_formData">
				<input type="hidden" name="fdId" /> 
				<input type="hidden" name="fdEvaluatorName" value="${KMSS_Parameter_CurrentUserName}" />
				<input type="hidden" name="fdEvaluationTime" /> 
				<input type="hidden" name="fdKey" value="${param.key}" /> 
				<input type="hidden" name="fdModelId" value="${param.modelId}" /> 
				<input type="hidden" name="fdModelName" value="${param.modelName}" /> 
				<input type="hidden" name="fdEvaluationScore" value="1" /> 
				<input type="hidden" name="isNotify" value="${param.isNotify == 'no' ? '' : 'yes'}" />
				<kmss:editNotifyType property="fdNotifyType" value="todo" />
			</div>
		</kmss:auth>

		<ul data-dojo-type="mui/tabbar/TabBar" id="eval_tabbar" fixed="bottom">
			<li data-dojo-type="mui/back/BackButton" id="eval_back"></li>
			<kmss:auth requestURL="${s_requestUrl}" requestMethod="GET">
				<li>
					<div class="muiEvalOpt" data-dojo-type="${LUI_ContextPath}/sys/evaluation/mobile/js/Eval.js" id="muiEvalOpt">
						<input type="text" readonly="readonly" class="muiEvalText" placeholder="我来说两句..." />
					</div>
				</li>
			</kmss:auth>
		</ul>

	</template:replace>
</template:include>
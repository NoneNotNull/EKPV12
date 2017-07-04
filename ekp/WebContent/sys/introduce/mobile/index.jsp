<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="mobile.list">
	<template:replace name="head">
		<c:set var="s_requestUrl" value="/sys/introduce/sys_introduce_main/sysIntroduceMain.do?method=add&fdModelName=${param.modelName}&fdModelId=${param.modelId}" />
		<script type="text/javascript">
			require([ "dojo/topic", "dojo/dom","dojo/query","dijit/registry","dojo/domReady!" ], function(
					topic, dom, query,registry) {
				
				// 监听事件，改变推荐数
				topic.subscribe("/mui/list/loaded", function(obj) {
						if(obj.id != 'muiIntrStoreList')
							return;
						var count = 0;
						if(obj){
							count = obj.totalSize;
						}
						dom.byId("intr_count").innerHTML = count;
				});
				
				// 没数据给最小高度
				topic.subscribe('/mui/list/noData',function(obj){
					if(obj.id != 'muiIntrStoreList')
						return;
					var muiOpt = registry.byId('muiIntrOpt');
					if (muiOpt)
						muiOpt.showMask();
					
					var h = dom.byId('intr_scollView').offsetHeight
							- query('.muiIntrTitle')[0].offsetHeight - 20;
					query('.muiListNoData').style({
						'line-height' : h + 'px',
						'height' : h + 'px'
					});
				});
			});
		</script>
	</template:replace>
	<template:replace name="content">

		<div id="intr_scollView"
			data-dojo-type="mui/list/StoreScrollableView">
			<div class="muiIntrTitle">
				<span></span>
				<div>
					最新推荐（<span class="muiIntrCount" id="intr_count"></span>）
				</div>
			</div>
			<ul class="muiIntrStoreList" data-dojo-type="mui/list/JsonStoreList" id="muiIntrStoreList"
				data-dojo-mixins="${LUI_ContextPath}/sys/introduce/mobile/js/IntroduceItemListMixin.js"
				data-dojo-props="url:'/sys/introduce/sys_introduce_main/sysIntroduceMain.do?method=viewAll&forward=mobileList&fdModelId=${param.modelId}&fdModelName=${param.modelName}',lazy:false">
			</ul>
		</div>
		<kmss:auth requestURL="${s_requestUrl}" requestMethod="GET">
			<div style="display: none;" id="intr_formData">
				<input type="hidden" name="fdKey" value="${param.fdKey}"/>
				<input name="fdIsNotify" type="checkbox" value="1" checked="checked">
				<input type="hidden" name="fdModelId" value="${param.modelId}"/>
				<input type="hidden" name="fdModelName" value="${param.modelName}"/>
				<kmss:editNotifyType property="fdNotifyType" value="todo"/>
			</div>
		</kmss:auth>

		<ul data-dojo-type="mui/tabbar/TabBar" id="intr_tabbar" fixed="bottom">
			<li data-dojo-type="mui/back/BackButton"></li>
			<kmss:auth requestURL="${s_requestUrl}" requestMethod="GET">
				<li>
					<div class="muiIntrOpt" data-dojo-type="${LUI_ContextPath}/sys/introduce/mobile/js/Intr.js" id="muiIntrOpt">
						<input type="text" readonly="readonly" class="muiIntrText" placeholder="我来说两句..." />
					</div>
				</li>
			</kmss:auth>
		</ul>

	</template:replace>
</template:include>
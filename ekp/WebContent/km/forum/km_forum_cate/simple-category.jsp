<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.dialog">
	<template:replace name="content">
		<div style="width: 773px; margin: 0 auto;" id="categoryCtx"></div>
	</template:replace>
</template:include>
<script type="text/javascript">
	function serializeParams(params) {
		var array = [];
		for ( var kk in params) {
			array.push('qq.' + encodeURIComponent(kk) + '='
					+ encodeURIComponent(params[kk]));
		}
		var str = array.join('&');
		return str;
	}
	seajs.use( [ 'theme!common', 'theme!icon', 'theme!category' ]);
	var interval = setInterval(____Interval, "50");
	function ____Interval() {
		if (!window['$dialog'])
			return;
		seajs
				.use(
						[ 'lui/category/category', 'lui/jquery', 'lui/topic' ],
						function(category, $, topic) {
							var url = '/km/forum/criteria/sysSimpleCategoryCriteria.do?method=select&modelName=${param.modelName}&parentId=!{parentId}&searchText=!{searchText}&currId=!{currId}&type=!{type}&authType=${param.authType}&pAdmin=!{pAdmin}';
							if (window['$dialog'].___params)
								url += ("&" + serializeParams(window['$dialog'].___params));
							var cate = new category.Category( {
								elem : '#categoryCtx',
								url : url,
								mulSelect : "${param.mulSelect}",
								currId : "${param.currId}",
								modelName : "${param.modelName}",
								errorMessage:"${lfn:message('sys-ui:ui.dialog.category.message')}",
								noFavorite : "${param.noFavorite}"
							});
							cate.draw();
							topic
									.subscribe(
											'category.selected.changed',
											function(evt) {
												if (!evt || !evt.data
														|| evt.data.length == 0) {
													// 置空临时变量
													window.urlParams = [];
													return;
												}
												var ids = '', names = '';

												for ( var i = 0; i < evt.data.length; i++) {
													var data = evt.data[i].data[0];
													if (data && !data.nodeType) {
														ids += i === 0 ? data.value
																: ';' + data.value;
														names += i === 0 ? data.text
																: ';' + data.text;
													}
												}
												window.urlParams = [];
												if (ids != '') {
													window.urlParams = [ ids,
															names ];
												}
											});
						});
		clearInterval(interval);
	}
</script>
<style>
	body{background-color: white !important;}
</style>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script>
	var _dialog;
	seajs.use( [ 'lui/dialog' ], function(dialog) {
		_dialog = dialog;
	});
	function gotoResultView(method, moduleType, fdTimeUnit, yearStartTime,
			yearEndTime, startTime, endTime, operatorId,
			docCategoryId, fdModelId, knowledgeType,isWin) {
		url = 'kms/log/kms_log_app/kmsLogApp.do?method=gotoResultView&type=' + method;
		if (null != moduleType) {
			url += "&moduleType=" + moduleType;
		}
		if (null != fdTimeUnit) {
			url += "&fdTimeUnit=" + fdTimeUnit;
		}
		if(fdTimeUnit=="0"){
			if (null != startTime) {
				url += "&startTime=" + startTime;
			}
			if (null != endTime) {
				url += "&endTime=" + endTime;
			}
		}else{
			if (null != yearStartTime) {
				url += "&yearStartTime=" + yearStartTime;
			}
			if (null != yearEndTime) {
				url += "&yearEndTime=" + yearEndTime;
			}
			if (null != startTime) {
				url += "&monthStartTime=" + startTime;
			}
			if (null != endTime) {
				url += "&monthEndTime=" + endTime;
			}
		}
		if (null != operatorId) {
			url += "&operatorId=" + operatorId;
		}
		if (null != docCategoryId) {
			url += "&docCategoryId=" + docCategoryId;
		}
		if (null != fdModelId) {
			url += "&fdModelId=" + fdModelId;
		}
		if (null != knowledgeType) {
			url += "&knowledgeType=" + knowledgeType;
		}
		if(!isWin){
			seajs.use( [ 'lui/dialog' ], function(dialog) {
				dialog.iframe(url, "统计明细", function() {
				}, {
					"width" : 750,
					"height" : 550
				});
			});
		}else{
			window.open('${LUI_ContextPath}/'+url, "_blank", "");
		}
	}

	function gotoSearchResultView(searchMethod, fdTimeUnit, yearStartTime,
			yearEndTime, monthStartTime, monthEndTime, operatorId) {
		url = 'kms/log/kms_log_search/kmsLogSearch.do?method=gotoResultView';
		if (null != searchMethod) {
			url += "&searchMethod=" + searchMethod;
		}
		if (null != fdTimeUnit) {
			url += "&fdTimeUnit=" + fdTimeUnit;
		}
		if (null != yearStartTime) {
			url += "&yearStartTime=" + yearStartTime;
		}
		if (null != yearEndTime) {
			url += "&yearEndTime=" + yearEndTime;
		}
		if (null != monthStartTime) {
			url += "&monthStartTime=" + monthStartTime;
		}
		if (null != monthEndTime) {
			url += "&monthEndTime=" + monthEndTime;
		}
		if (null != operatorId) {
			url += "&operatorId=" + operatorId;
		}
		seajs.use( [ 'lui/dialog' ], function(dialog) {
			dialog.iframe(url, "统计明细", function() {
			}, {
				"width" : 800,
				"height" : 642
			});
		});
	}

	function checkDelete(url) {
		seajs
				.use(
						[ 'lui/dialog' ],
						function(dialog) {
							dialog
									.confirm(
											"${lfn:message('kms-evaluate:kmsEvaluateCommon.confirmDeleteCount')}",
											function(flag) {
												if (flag) {
													Com_OpenWindow(url, '_self');
												}
											});
						});
	}
</script>
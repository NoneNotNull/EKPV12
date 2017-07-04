<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/resource/js/common.js"></script>
<script>
	Com_IncludeFile('jquery.js', "${kmsResourcePath }/js/lib/", "js", true);
</script>
<script>
	// ekpJS
	Com_IncludeFile(
			"docutil.js|optbar.js|validator.jsp|validation.jsp|doclist.js|dialog.js|data.js",
			null, "js");
</script>
<script>
	// kmsJS
	Com_IncludeFile('json2.js|jquery.form.js|kms.js',
			"${kmsResourcePath }/js/lib/", "js", true);
	Com_IncludeFile(
			'template.js|kms_tmpl.js|kms_portlet.js|kms_common.js|kms_utils.js',
			"${kmsResourcePath }/js/", "js", true);
</script>
<script type="text/javascript"
	src="${kmsResourcePath }/js/artdialog/artdialog.js?skin=blue"></script>
<script type="text/javascript"
	src="${kmsResourcePath }/js/artdialog/artdialog.iframe.js"></script>
<script src="${kmsResourcePath }/js/kms_opera.js"></script>
<script src="${kmsResourcePath }/js/kms_navi_selector.js"></script>
<script src="${kmsContextPath }kms/ask/kms_ask_kk/resource/js/kk2ask.js"></script>
<link
	href="${kmsContextPath }kms/ask/kms_ask_kk/resource/css/kk2ask.css"
	rel="stylesheet" type="text/css" />
<script>
	var jsonUrl = '${kmsResourcePath}/jsp/get_json_feed.jsp';

	function kmsAsk_Com_Submit(type) {
		var fdCategoryIds = $("input[name = 'fdKmsAskCategoryId']").val();
		if (!fdCategoryIds) {
			showAlert("<bean:message bundle='kms-ask' key='kmsAskTopic.fdCategoryIds.null'/>");
			return false;
		}
		var docSubject = $('textarea[name = "docSubject"]').val();
		if (!docSubject) {
			showAlert("<bean:message bundle='kms-ask' key='kmsAskTopic.docSubject.null'/>");
			return false;
		} else {
			// 判断标题是否超出限制
			var len = ( function(s) {
				var l = 0;
				var a = s.split("");
				for ( var i = 0; i < a.length; i++) {
					if (a[i].charCodeAt(0) < 299) {
						l++;
					} else {
						l += 2;
					}
				}
				return l;
			})(docSubject);
			if (len >= 100) {
				showAlert("<bean:message bundle='kms-ask' key='kmsAskTopic.docSubject.maxlength'/>");
				return false;
			}
			// 判断爱问库中是否存在相同标题的问题--2013-01-05
			$
					.ajax( {
						type : "POST",
						url : jsonUrl,
						data : {
							s_bean : 'kmsHomeAskService',
							s_method : 'checkDocSubject',
							s_subject : docSubject
						},
						cache : false,
						success : function(data) {
							if (data && data['flag'] == true) {
								showAlert("已存在相同标题的问题");
								return false;
							} else {
								$
										.ajax( {
											type : "POST",
											url : '<c:url value="/kms/ask/kms_ask_kk/kmsKk2Ask.do?method=save" />',
											data : $(document.forms[0])
													.serialize(),
											cache : false,
											success : function(data) {
												artDialog
														.confirm(
																"是否打开该问题？",
																function() {
																	window
																			.open(
																					'<c:url value="/kms/ask/kms_ask_topic/kmsAskTopic.do?method=view&fdId=" />' + data['fdId'],
																					'_blank');
																	window.external
																			.winclose();
																},
																function() {
																	window.external
																			.winclose();
																});
											},
											error : function() {
												showAlert("保存失败");
											}
										});
							}
						}
					})
		}

	};

	$(document)
			.ready(
					function() {
						var expandOptions = {
							s_modelName : 'com.landray.kmss.kms.ask.model.KmsAskCategory',
							s_bean : 'kmsHomeAskService',
							s_method : 'getCategoryList',
							width : '638px',
							yesFn : function(naviSelector) {
								var selectedCache = naviSelector.selectedCache;
								// 未选择分类~
								if (selectedCache.length == 0) {
									art.artDialog.alert("请选择分类！");
									return;
								}
								if (selectedCache.last()._data["isShowCheckBox"] == "0") {
									art.artDialog.alert("您没有当前目录使用权限！");
									return;
								}
								var fdCategoryId = selectedCache.last()._data["value"];
								ajaxCategoryPath(fdCategoryId);
							}
						};
						var selectCate = new KMS.opera(expandOptions,
								$('#selectAreaNames'));
						selectCate.bind_expand();

						var fdSelectCategoryId = '${param.fdCategoryId}' || '${kmsAskTopicForm.fdKmsAskCategoryId}';
						if (fdSelectCategoryId) {
							ajaxCategoryPath(fdSelectCategoryId);
						}

						// 爱问标题字数限制显示
						( function(maxN) {
							$('textarea[name="docSubject"]')
									.bind(
											'keyup',
											function(event) {
												var $target = $(event.target), docSubject = $target
														.val(), len = ( function(
														s) {
													var l = 0;
													var a = s.split("");
													for ( var i = 0; i < a.length; i++) {
														if (a[i].charCodeAt(0) < 299) {
															l++;
														} else {
															l += 2;
														}
													}
													return l;
												})(docSubject);
												if (len) {
													var aS = '<a style="font-family: Constantia, Georgia;font-size: 24px;">';
													var aE = '</a>';
													var warn = [ aS, 0, aE, '字' ];
													if (len <= maxN) {
														warn[1] = Math
																.abs(parseInt((maxN - len) / 2));
														warn.unshift("还可以输入");
													} else {
														warn[1] = Math
																.abs(parseInt((maxN - len) / 2)) + 1;
														warn.unshift("已经超过");
													}
													$('.p_b').html(
															warn.join(''));
												}
											})
						})(100);
						//kk2ask();
					});

	// 异步请求分类路径
	function ajaxCategoryPath(fdCategoryId) {
		$.ajax( {
			type : "GET",
			url : jsonUrl,
			data : {
				s_bean : 'kmsHomeAskService',
				s_method : 'getCategoryNamePath',
				fdCategoryId : fdCategoryId
			},
			cache : false,
			success : function(data) {
				var arrayPath = new Array();
				var len = data.length;
				$.each(data, function(i, n) {
					arrayPath[len - i - 1] = n;
				});
				var path = arrayPath.join('>>');
				$('input[name="fdKmsAskCategoryId"]').val(fdCategoryId);
				$('#fdKmsAskCategoryName').html(path);
			},
			error : function() {
			}
		});
	}

	function kk2ask(data) {
		var xml = new KMS.Kk2ask('otherPostsListDiv', {
			'data' : data,
			'kkIp' : '${kkIp}',
			'kkPort' : '${kkPort}'
		});
	}
</script>
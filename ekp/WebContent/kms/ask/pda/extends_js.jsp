<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<link href="${kmsResourcePath }/favicon.ico" rel="shortcut icon">
<link href="${kmsBasePath }/ask/pda/css/ask_pda.css" rel="stylesheet"
	type="text/css" />
<script type="text/javascript"
	src="<%=request.getContextPath()%>/resource/js/common.js"></script>
<script>
	Com_IncludeFile("jquery.js|kms_tmpl.js");
</script>
<script>
	Com_IncludeFile('kms_portlet.js', "${kmsResourcePath }/js/", "js", true);
</script>
<script>
	//滚动显示更多
	var slider = function(context, options) {
		that = this;
		this.context = $('#' + context);
		this.options = {
			//	templateId : 'other_posts_list_tmpl',
			//	requestURL : KMS_PORTLET_URL,
			//  pageno : 0,
			// 是否有下一页
			hasNextPage : true,
			// 线程控制
			lock : false
		};
		$.extend(that.options, options);
		this.request = function() {
			$.getJSON(
					that.options.requestURL + "s_bean=" + that.options.s_bean,
					that.options.dataSource, function(data) {
						that.options.hasNextPage = data.page.hasNextPage;
						that.appendTmpl(that.buildTmpl(data));
						that.context.attr('pageno',
								that.options.dataSource.pageno);
						that.options.afterFunc(that.options);
						that.options.lock = false;
					});
		};

		this.appendTmpl = function(html) {
			that.context.append($(html));
		};

		this.buildTmpl = function(data) {
			var html = KmsTmpl(
					document.getElementById(that.options.templateId).innerHTML)
					.render( {
						"data" : data
					});
			return html;
		};

		this.sliderEvent = function(e) {
			var body = document.body;
			var scrollTop = body.scrollTop, clientH = body.clientHeight, scrollH = body.scrollHeight;
			if (scrollTop / (scrollH - clientH) >= 13.5) {
				if (that.options.hasNextPage && !that.options.lock) {
					that.options.lock = true;
					that.options.beforeFunc(that.options);
					var pageno = that.context.attr('pageno') ? (Number(that.context
							.attr('pageno')) + 1)
							: 1;
					$.extend(that.options.dataSource, {
						pageno : pageno
					});
					that.request();
				}
			}
		};

		this.init = function() {
			if (!that.options.lock) {
				that.options.lock = true;
				that.options.beforeFunc(that.options);
				var pageno = 1;
				$.extend(that.options.dataSource, {
					pageno : pageno
				});
				that.context.html('');
				that.request();
			}
		};

		this.replySubmit = function() {
			var docContents = $('input[name="docContent"]').val();
			if (docContents == null || docContents == "") {
				alert("请填写回复内容！");
				return false;
			}
			$.ajax( {
				url : document.kmsAskPostForm.action,
				data : $(document.kmsAskPostForm).serialize(),
				type : 'post',
				success : function(data) {
					that.init();
					$('#ask_reply').hide();
				}
			});
		};

		this.bindEvent = function() {
			// 移动端事件
			Com_AddEventListener(window, "touchstart", that.sliderEvent);
			// 滚动到底部时加载新内容~网页端事件
			window.onmousewheel = document.onmousewheel = that.sliderEvent;
			if ($('#submitPost').length > 0) {
				Com_AddEventListener($('#submitPost')[0], "click",
						that.replySubmit);
			}
		};

		that.bindEvent();
		that.init();
	};

	// 置为最佳
	function bestPost(postId) {
		if (confirm("确定将本回复置为最佳？")) {
			$
					.ajax( {
						url : '<c:url value="/kms/ask/kms_ask_post/kmsAskPost.do?method=best&fdTopicId=${param.fdId}" />',
						data : {
							fdPostId : postId
						},
						cache : false,
						success : function(data) {
							window.location.reload();
						}
					});
		}
	}

	var sliderData = {
		dataSource : {
			s_method : 'listOtherPosts',
			fdTopicId : '${param.fdId}',
			fdIsOrderByTime : 'true',
			pageno : 0
		},
		s_bean : 'kmsAskViewInfoService',
		templateId : 'other_posts_list_tmpl',
		requestURL : KMS_PORTLET_URL,
		// 前置事件
		beforeFunc : function(options) {
			if ($('#loading').css('display') == 'none') {
				$('#loading').css('display', 'block');
			}
		},
		// 后置事件
		afterFunc : function(options) {
			if ($('#loading').css('display') == 'block') {
				$('#loading').css('display', 'none');
			}
		}
	};
	$(document)
			.ready( function() {
				// JS模板缓存map
					var js_template = {};

					// 初始化js模板
					( function() {
						var jsTmplNodes = $('.js_tmpl');
						for ( var c = 0, len = jsTmplNodes.length; c < len; c++) {
							var node = jsTmplNodes[c];
							if (node.id) {
								js_template[node.id] = node.innerHTML;
							}
						}
					}());

					// 问题模块事件代理
					( function() {

						// --删除问题验证--
						function delAskConfirm() {
							if (confirm("<bean:message key='page.comfirmDelete'/>")) {
								Com_OpenWindow(
										'kmsAskTopic.do?method=delete&fdId=${param.fdId}',
										'_self');
							}
						}

						// 结束问题
						function closeTopic() {
							if (confirm('您是否确定结束问题？')) {
								Com_OpenWindow(
										'<c:url value="/kms/ask/kms_ask_topic/kmsAskTopic.do" />?method=close&fdId=${param.fdId}',
										'_self');
							}
						}
						$('#spanId').click( function(event) {
							var $target = $(event.target);
							if ($target.is('#deleteTopic')) { // 删除问题
									delAskConfirm();
								} else if ($target.is('#endTopic')) { // 结束问题
									closeTopic();
								}
							});
					}());

					new slider('portlet_otherPostsListDiv', sliderData);

				});
</script>
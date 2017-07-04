<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<link href="${kmsResourcePath }/favicon.ico" rel="shortcut icon">
<link href="${kmsBasePath }/ask/pda/css/ask_pda.css" rel="stylesheet"
	type="text/css" />
<script src="${kmsBasePath }/common/resource/js/lib/jquery.js"></script>
<script>

	function kmsAsk_Com_Submit(type) {

		function showDiv(elem) {
			elem.show();
			var body = document.body;
			var left = (body.clientWidth - elem[0].clientWidth) / 2
					+ body.scrollLeft, top = (body.clientHeight - elem[0].clientHeight)
					/ 2 + body.scrollTop - 30;
			var style = elem[0].style;
			style.left = left + 'px';
			style.top = top + 'px';
			elem.fadeOut(2000);
		}
		var _$elem = $('.warn_div'), _$subject = $('textarea[name="docSubject"]'), _$elem2 = $('.warn2_div');
		if (!_$subject.val()) {
			showDiv(_$elem);
			return;
		} else {
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
			})(_$subject.val());
			if (len > 100) {
				showDiv(_$elem2);
				return;
			}
		}
		// 提交保存
		$
				.ajax( {
					url : "<c:url value='/kms/ask/kms_ask_topic/kmsAskTopic.do?method=savePda' />",
					data : $(document.kmsAskTopicForm).serialize(),
					type : 'post',
					success : function(data) {
						if (data && data['fdId']) {
							window
									.open(
											"<c:url value='/kms/ask/kms_ask_topic/kmsAskTopic.do?method=view&isAppflag=1' />&fdId="
													+ data['fdId'], '_self');
						}
					}
				});
	};

	// 验证货币
	function validateScore(el) {
		var score = '${fdScore}';
		if (parseInt(el.value) > score) {
			alert("<bean:message bundle='kms-ask' key='error.kmsAskTopic.fdScore'/>");
			el.value = "0";
			el.focus();
		}
	}

	// 悬赏货币显示
	$( function() {
		var totalScore = '${fdScore}';
		totalScore = parseInt(totalScore);
		$('.money_content ul li').each( function() {
			var score = $(this).attr('score');
			score = parseInt(score);
			if (totalScore >= score) {
				$(this).bind('click', function(event) {
					$('input[name="fdScore"]').val(score);
					$('.score_box').html(score);
					$('.money_content ul li').each( function() {
						if ($(this).hasClass('on')) {
							$(this).removeClass('on');
							$(this).addClass('out');
						}
					});
					var t = $(event.target);
					if (t.attr('score')) {
						t.removeClass('out');
						t.addClass('on');
					}
				});
			} else {
				$(this).addClass('disable_score');
			}
		});
	});
</script>
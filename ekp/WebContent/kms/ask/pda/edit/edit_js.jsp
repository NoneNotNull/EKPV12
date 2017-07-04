<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<link href="${LUI_ContextPath }/kms/ask/pda/css/ask_pda.css" rel="stylesheet" type="text/css" />
<script>
	function updateCategory(data) {
		if (data) {
			$("input[name=fdKmsAskCategoryName]").val(data.name);
			$("input[name=fdKmsAskCategoryId]").val(data.id);
		}
	}
	$(function() {

		setTimeout(function() {
			var fdCategoryId = "${param.fdCategoryId }";
			if (!fdCategoryId)
				selectCategory();
		}, 300);
	});
	function selectCategory() {
		var currId = $("input[name=fdKmsAskCategoryId]").val(), currName = $(
				"input[name=fdKmsAskCategoryName]").val()
		canClose = currId ? true : false;
		Pda.simpleCategoryForNewFile({
			modelName : "com.landray.kmss.kms.ask.model.KmsAskCategory",
			action : updateCategory,
			currId : currId,
			currName : currName,
			canClose : canClose
		});
	}

	function save() {
		function showDiv(elem) {
			elem.css({
				"opacity" : "0.6"
			}).show();
			var body = document.body;
			var left = (body.clientWidth - elem[0].clientWidth) / 2
					+ body.scrollLeft, top = (body.clientHeight - elem[0].clientHeight)
					/ 2 + body.scrollTop - 30;
			var style = elem[0].style;
			style.left = left + 'px';
			style.top = top + 'px';
			elem.animate({
				"opacity" : "0"
			}, 4000, function() {
				elem.hide();
			});
			//elem.fadeOut(2000);
		}
		var _$elem = $('.warn_div'), _$subject = $('textarea[name="docSubject"]'), _$elem2 = $('.warn2_div');
		if (!_$subject.val()) {
			showDiv(_$elem);
			return;
		} else {
			var len = (function(s) {
				var l = 0;
				var a = s.split("");
				for (var i = 0; i < a.length; i++) {
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
		Pda.Topic.emit('submit');
		document["kmsAskTopicForm"].submit();
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
	$(function() {
		var totalScore = '${fdScore}';
		totalScore = parseInt(totalScore);
		$('.money_content ul li').each(function() {
			var score = $(this).attr('score');
			score = parseInt(score);
			if (totalScore >= score) {
				$(this).bind('click', function(event) {
					$('input[name="fdScore"]').val(score);
					$('.score_box').html(score);
					$('.money_content ul li').each(function() {
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

	//字数限制显示
	$(function() {
		var maxN = 100;
		$('#docSubject').on("input", function(event) {
			var $target = $(event.target),
				docSubject = $target.val(),
				len = (function(
				s) {
					var l = 0;
					var a = s.split("");
					for (var i = 0; i < a.length; i++) {
						if (a[i].charCodeAt(0) < 299) {
							l++;
						} else {
							l += 2;
						}
					}
					return l;
				})(docSubject);
			var aS = '<a style="font-family: Constantia, Georgia;font-size: 24px;">';
			var aE = '</a>';
			var warn = [aS, 0, aE, '${lfn:message('kms-ask:kmsAskTopic.word')}'];
			if (len == 0) {
				warn[1] = 50;
				warn.unshift("${lfn:message('kms-ask:kmsAskTopic.moreWord')}");
			} else {
				if (len <= maxN) {
					warn[1] = Math.abs(parseInt((maxN - len) / 2));
					warn.unshift("${lfn:message('kms-ask:kmsAskTopic.moreWord')}");
				} else {
					warn[0] = '<a style="font-family: Constantia, Georgia;font-size: 24px;color:#d02300">';
					warn[1] = Math.abs(parseInt((maxN - len) / 2)) + 1;
					warn.unshift("${lfn:message('kms-ask:kmsAskTopic.exceed')}");
				}
			}
			$('.lui-ask-word').html(warn.join(''));
		});
	});
</script>
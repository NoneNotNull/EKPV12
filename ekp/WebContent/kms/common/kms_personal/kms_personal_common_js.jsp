<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script src="${kmsResourcePath }/js/kms_list.js"></script>
<script>
	// 计算个人积分比的样式class
	function calculatePcClass(score, up, down) {
		// 积分取值区间
		var region = up - down, p = region / 10;
		var found = 0, curRegion = down;
		for ( var i = 0; i < 11; i++) {
			if (score <= curRegion) {
				found = i;
				break;
			}
			curRegion += p;
		}

		return "percent" + found;
	}

	function myKmDetails(kmPath) {
		if (arguments.length > 1) {
			var fdCategoryId = "fdCategoryId=" + arguments[1];
		}
		var baseUrl = '<c:url value="/kms/common/kms_person_info/kmsPersonInfo.do?method=myKmDetails" />';
		var docScrollTop = "docScrollTop="
				+ (document.documentElement || document.body).scrollTop;
		var url = [ baseUrl, kmPath, "fdPersonId=${param.fdPersonId}",
				docScrollTop, "expert=${param.expert}",
				'fdExpertId=${param.fdExpertId}', fdCategoryId ].join("&");
		location.href = url;
		return false;
	}

	function myPage(method) {
		var url = "";
		var docScrollTop = "docScrollTop="
				+ (document.documentElement || document.body).scrollTop;
		if ('${param.expert}' && method.equals('method=personalInfo')) {
			url = [
					'<c:url value="/kms/expert/kms_expert_info/kmsExpertInfo.do?method=view" />',
					'expert=${param.expert}', 'fdPersonId=${param.fdPersonId}',
					'fdExpertId=${param.fdExpertId}', docScrollTop ].join('&');
		} else {
			var baseUrl = '<c:url value="/kms/common/kms_person_info/kmsPersonInfo.do?" />' + method;
			url = [ baseUrl, "fdPersonId=${param.fdPersonId}",
					'expert=${param.expert}', 'fdExpertId=${param.fdExpertId}',
					docScrollTop ].join("&");
		}
		location.href = url;
		return false;
	}

	var addEvent = function(obj, evt, func) {
		if (obj.addEventListener) { // DOM2
			obj.addEventListener(evt, func, false);
		} else if (obj.attachEvent) { // IE5+
			obj.attachEvent('on' + evt, func);
		} else { // DOM0
			obj['on' + evt] = func;
		}
	};

	var setBookmarkCategory = function() {
		window
				.open(
						"<c:url value='/moduleindex.jsp?nav=/sys/tree_mysetting.jsp' />",
						"");
	};

	// 页面定位到上次的垂直位置上
	addEvent(
			window,
			"load",
			function() {
				var docScrollTop = parseInt("${param.docScrollTop}", 10);
				document.documentElement ? document.documentElement.scrollTop = docScrollTop
						: document.body.scrollTop = docScrollTop;
				( function() {
					var inter = setInterval( function() {
						if ($('span[kk="kk_span"]').length > 0) {
							clearInterval(inter);
							var _$kk_span = $('span[kk="kk_span"]');
							var _$position = _$kk_span.position();
							//_$kk_span.append($('#kk_div'));
							$('#kk_div').css( {
								"top" : (_$position.top + 13),
								"left" : (_$position.left - 8 )
							});
							$('#kk_div').show();
						}
					}, 1)
				})()
			});
</script>
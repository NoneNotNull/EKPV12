<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/portal/portal.tld" prefix="portal"%>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/sys/ui/jsp/jshead.jsp"%>
<script type="text/javascript">
	seajs.use(['theme!list', 'theme!portal']);
	function openQuery() {

		var mC = LUI.$('#mainContent');
		var qur = LUI.$("#queryListView");
		if (qur.is(":hidden")) {
			var w = mC.width();
			var h = mC.height();
			qur.parent().css( {
				"position" : "relative",
				"overflow" : "hidden",
				"height" : h
			});
			mC.css( {
				"position" : "absolute",
				"left" : w
			}).animate( {
				"left" : 0,
				"opacity" : 0
			}, function() {
				qur.parent().css( {
					"position" : "",
					"overflow" : "",
					"height" : ""
				});
				mC.css( {
					"display" : "none",
					"position" : "",
					"left" : 0
				});
			});

			qur.css( {
				"position" : "absolute",
				"left" : w,
				"opacity" : 0,
				"display" : ""
			}).animate( {
				"left" : 0,
				"opacity" : 1
			}, function() {
				qur.css( {
					"position" : ""
				});
			});
		}
	}
	function openPage(url) {

		var ifr = LUI.$("#mainIframe");
		var qur = LUI.$("#queryListView");
		if(url){
			ifr.attr("src", url).load( function() {
				var sh = this.contentWindow.document.body.scrollHeight;
				var oh = this.contentWindow.document.body.offsetHeight;
				this.style.height = (sh > 0 ? sh : oh) + 'px';
			});
		}

		var mC = LUI.$('#mainContent');
		LUI.$("html,body").animate( {
			scrollTop : qur.offset().top
		}, 300);
		if (mC.is(":hidden")) {
			var w = qur.width();
			var h = qur.height();
			qur.parent().css( {
				"position" : "relative",
				"overflow" : "hidden",
				"height" : h
			});
			qur.css( {
				"position" : "absolute",
				"left" : 0,
				"opacity" : 1,
				"display" : ""
			}).animate( {
				"left" : w,
				"opacity" : 0
			});
			mC.css( {
				"position" : "absolute",
				"left" : 0,
				"opacity" : 0,
				"display" : "",
				"width" : w
			}).animate( {
				"left" : w,
				"opacity" : 1
			}, function() {
				qur.parent().css( {
					"position" : "",
					"overflow" : "",
					"height" : ""
				});
				qur.css( {
					"display" : "none",
					"position" : "",
					"left" : w,
					"opacity" : 1
				});
				mC.css( {
					"position" : ""
				});
			});
		}
	}
</script>
<title>
<template:block name="title" />
</title>
<template:block name="head" />
</head>
<body class="lui_list_body">
	<template:block name="path" />
	<template:block name="content" />
</body>
</html>

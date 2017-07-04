<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.util.*"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1,minimum-scale=1.0,maximum-scale=1.0">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/kms/common/pda/template/jshead.jsp"%>
<title>
<template:block name="title" />
</title>
<template:block name="head" />

</head>
<body>
	<div data-lul-role="body" style="position: relative;height: 100%">
		<div data-lui-role="page" id="page" style="height: 100%">
			<template:block name="header">
			</template:block>
			<div class="lui-content" style="padding-top: 40px;padding-bottom: 50px;">
				<template:block name="message" />
				<template:block name="description" />
				<template:block name="photoswipe" />
				<div class="lui-docContent">
					<template:block name="docContent" />
				</div>
			</div>
			
			<div class="lui-footer clearfloat">
				<div style="position: relative;">
					<div data-lui-role="button" id="button_top" style="display: none">
						<script type="text/config">
						{
							currentClass : 'lui-top',
							onclick : "toTop()",
							group : 'group_top',
						}
						</script>
					</div>
				</div>
				<template:block name="footer">
				</template:block>
			</div>
		</div>
	</div>
	<script type="text/javascript">
		function toTop() {
			$("html,body").scrollTop(0);
			$("#button_top").hide();
		}
		$(function() {
		   var top = $("#button_top");
		   if(!top) return;
			var  isShow = function() {
				if ($("html").scrollTop() > 30
						|| $("body").scrollTop() > 30) {
						//兼容zepto
						if (top.css('display'=='none')) {
							top.show();
						}
				} else {
					top.hide();
				}
			}
			$(window).bind({
				"scroll" : function() {
					isShow();
				},
				"resize" : function() {
					isShow();
				}
			});
		});
		
		
		// 图片按比例缩放
		$(".lui-docContent").find("img").each(function(){
				if($(this).width() > ($(window).width() - 20))  {
					$(this).width($(window).width() -20);
					$(this).css({"height":"auto"});
				}
		});
		
		$(".lui-docContent").find("table").each(function(){
			if($(this).width() > ($(window).width() - 20))  {
				$(this).width($(window).width() -20);
				$(this).css({"height":"auto"});
			}
		});
	</script>
</body>
</html>

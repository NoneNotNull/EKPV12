<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>EKP</title>
<style type="text/css">
.black{padding:0px;margin:0px;}
.newMaskAll{position:absolute;height:100%;width:100%;background:#575757;z-index:10020;left:0}
.newMaskText{top:30%;position:absolute;width:100%;color:#fff;font-size:1.7em;text-align:center}
.newMaskLogo{background:#fff;color:#000;position:absolute;width:100%;top:41%;text-align:center;margin:20px 0;padding:30px 0;height:97px}
.newMaskLogo a{width:246px;height:80px;display:inline-block;position:relative;margin:0 auto;margin-left:50px}
.newMaskChrome{background:url(./resource/images/chrome_logo.png) no-repeat}
.newMaskFirefox{background:url(./resource/images/ff_logo.png) no-repeat}
</style>
</head>
<body class="black">

<DIV class=newMaskAll>
	<DIV class=newMaskText>您的浏览器版本太低，建议您使用以下浏览器进行访问：</DIV>
	<DIV class=newMaskLogo><A title=点击跳转到chrome浏览器下载页
	class=newMaskChrome
	href="https://www.google.com/intl/en/chrome/browser/" target=_blank></A><A
	title=点击跳转到Firefox浏览器下载页 class=newMaskFirefox
	href="http://firefox.com.cn/" target=_blank></A></DIV>
</DIV>
</body>
</html>

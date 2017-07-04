<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%> 
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<script>
Com_IncludeFile('jquery.js');
</script>
<script type="text/javascript" src="${KMSS_Parameter_ContextPath}sys/attachment/js/flashviewer.js"></script>
<script type="text/javascript">
	$(document).ready(
					function() {
						var flashEnabled = '${flashEnabled}';
						if (flashEnabled) {
							var pageCount = '${swfPageCount}';
							var swfUrl = "${swfDocUrl}";
							if (pageCount > 0) {
								createFlashViewer("swfviewer",swfUrl, pageCount);
							} else {
								$("#swfviewer")
										.html(
												'<img src="${KMSS_Parameter_ContextPath}resource/style/common/images/loading.gif">文档转换中，请稍后刷新页面..');
							}
						}

						$(window).resize(function(){
							var winw = $(window).width() >= document.body.clientWidth ? $(window).width() : document.body.clientWidth, 
							     winh = $(window).height() >= document.body.clientHeight ? $(window).height() : document.body.clientHeight;
							var pw = winw - 2;
							var ph = winh - 2;
							$("#att_swf_viewer").width(pw).height(ph);
						});
						
						$(window).resize();
					});
	
</script>
</head>
<body style="margin: 0px;padding: 1px;">
<div id="swfviewer"></div>
</body>
</html>
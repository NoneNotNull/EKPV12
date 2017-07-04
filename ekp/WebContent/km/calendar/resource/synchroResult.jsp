<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="
	com.landray.kmss.util.KmssMessageWriter,
	com.landray.kmss.util.KmssReturnPage,
	java.util.List" %>
<%
KmssMessageWriter msgWriter = null;
if(request.getAttribute("KMSS_RETURNPAGE")!=null){
	msgWriter = new KmssMessageWriter(request, (KmssReturnPage)request.getAttribute("KMSS_RETURNPAGE"));
}else{
	msgWriter = new KmssMessageWriter(request, null);
}

	if(request.getHeader("accept")!=null){
		if(request.getHeader("accept").indexOf("application/json") >=0){
			out.write(msgWriter.DrawJsonMessage(true).toString());
			return;
		}
	}
%>
<%@ page errorPage="/resource/jsp/jsperror.jsp" %>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.message">
	<template:replace name="title">${lfn:message('return.systemInfo') }</template:replace>
	<template:replace name="head">
		<script type="text/javascript" src="${KMSS_Parameter_StylePath}promptBox/syntaxhighlighter/scripts/shBrushBash.js"></script>
		<link type="text/css" rel="stylesheet" href="${KMSS_Parameter_StylePath}promptBox/syntaxhighlighter/styles/shCore.css"/>
		<link type="text/css" rel="stylesheet" href="${KMSS_Parameter_StylePath}promptBox/syntaxhighlighter/styles/shThemeDefault.css"/>
		<script type="text/javascript">
			SyntaxHighlighter.config.clipboardSwf = '${KMSS_Parameter_StylePath}promptBox/syntaxhighlighter/scripts/clipboard.swf';
			SyntaxHighlighter.all();
		</script>
		<script>
		function showMoreErrInfo(index, spanObj) {
			seajs.use(['lui/dialog','lui/jquery'], function(dialog,$) {
				var obj = document.getElementById("moreErrInfo" + index);
				if (obj != null) {
					if (obj.style.display == "none") {
	
						dialog.build( {
							config : {
								width : 700,
								height : 400,
								lock : true,
								cache : true,
								content : {
									type : "element",
									elem : obj
								},
								title : $('.errorlist').text()
							},
	
							callback : function(value, dialog) {
	
							},
							actor : {
								type : "default"
							},
							trigger : {
								type : "default"
							}
						}).show();
					}
				}
			});
		}
		</script>
	</template:replace>
	<template:replace name="body">
		<div class="prompt_frame">
			<div class="prompt_centerL">
				<div class="prompt_centerR">
					<div class="prompt_centerC">
						<div class="prompt_container clearfloat">
							<div>
								<div class="prompt_content_error"></div>
								<div class="prompt_content_right">
									<div class="prompt_content_inside" style="margin-top: 15px;margin-bottom: 0px">
										<bean:message key="return.title" />
										<div class="errortitle">同步结果：</div>
									<%=msgWriter.DrawMessages()%>
									</div>
									<div class="prompt_buttons clearfloat">
										<%=msgWriter.DrawButton()%>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</template:replace>
</template:include>
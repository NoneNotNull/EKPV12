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
			response.setStatus(500);
			out.write(msgWriter.DrawJsonMessage(true).toString());
			return;
		}
	}
%>
<%@ page errorPage="/resource/jsp/jsperror.jsp" %>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<!doctype html>
<html>
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<%@ include file="/sys/ui/jsp/jshead.jsp"%>
		<link type="text/css" rel="stylesheet" href="${LUI_ContextPath }/<%=(JSONObject.fromObject(SysUiPluginUtil.getThemes(request))).getJSONArray("prompt").get(0)%>"/>
		<script>
			seajs.use( [ 'lui/jquery'], function($) {
				$( function() {
					try {
						var arguObj = document.getElementsByTagName("div")[0];
						if(window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
							window.frameElement.style.height = Math.max(document.documentElement.scrollHeight, document.body.scrollHeight) + "px";
						}
					} catch(e) {
					}
				});
			});
		</script>
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
									title : $(spanObj).parent().find('.errorlist').text()
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
		<title>${lfn:message('return.systemInfo') }</title>
	</head>
	<body>
		<div class="prompt_frame">
			<div class="promt_headerL">
				<div class="promt_headerR">
					<div class="promt_headerC clearfloat">
					</div>
				</div>
			</div>
			<div class="prompt_centerL">
				<div class="prompt_centerR">
					<div class="prompt_centerC">
						<div class="prompt_container clearfloat">
							<div>
								<div class="prompt_content_error clearfloat">
								</div>
								<div class="prompt_content_right">
									<div class="prompt_content_inside clearfloat" style="margin-top: 15px;margin-bottom: 0px">
										<span class="prompt_title">
											${lfn:message('return.title') }
											<span class="prompt_message">
												<%= msgWriter.DrawTitle(true)%>
											</span>
										</span>
										<span class="prompt_message">
											<%= msgWriter.DrawMessages()%>
										</span>
									</div>
									<div class="prompt_buttons clearfloat">
										<%= msgWriter.DrawButton()%>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="promt_footerL">
				<div class="promt_footerR">
					<div class="promt_footerC clearfloat">
					</div>
				</div>
			</div>
		</div>
	</body>
</html>
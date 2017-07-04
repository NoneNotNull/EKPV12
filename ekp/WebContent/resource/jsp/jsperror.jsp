<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page isErrorPage="true" %>
<%@ page import="com.landray.kmss.web.filter.ResourceCacheFilter"%>
<%@ page import="com.landray.kmss.sys.ui.plugin.SysUiPluginUtil"%>
<%@ page import="com.landray.kmss.util.UserUtil"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/template.tld" prefix="template"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/list.tld" prefix="list"%>
<%@ taglib uri="/WEB-INF/kmss.tld" prefix="kmss"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/sunbor.tld" prefix="sunbor"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
if(request.getAttribute("LUI_ContextPath")==null){
	String LUI_ContextPath = request.getContextPath();
	request.setAttribute("LUI_ContextPath", LUI_ContextPath);
	request.setAttribute("LUI_CurrentTheme",SysUiPluginUtil.getThemeById("default"));
	request.setAttribute("LUI_Cache",ResourceCacheFilter.cache);
	request.setAttribute("KMSS_Parameter_Style", "default");
	request.setAttribute("KMSS_Parameter_ContextPath", LUI_ContextPath+"/");
	request.setAttribute("KMSS_Parameter_ResPath", LUI_ContextPath+"/resource/");
	request.setAttribute("KMSS_Parameter_StylePath", LUI_ContextPath+"/resource/style/default/");
	request.setAttribute("KMSS_Parameter_CurrentUserId", UserUtil.getKMSSUser(request).getUserId());
	request.setAttribute("KMSS_Parameter_Lang", UserUtil.getKMSSUser(request).getLocale().toString().toLowerCase().replace('_', '-'));
}
%>
<%@ page import="
	com.landray.kmss.util.KmssMessages,
	com.landray.kmss.util.KmssMessageWriter,
	com.landray.kmss.util.KmssReturnPage" %>
<%
try{
	KmssReturnPage rtnPage = KmssReturnPage.getInstance(request);
	KmssMessages msgs = new KmssMessages();
	msgs.addError(exception);
	rtnPage.addMessages(msgs);
	KmssMessageWriter msgWriter = new KmssMessageWriter(request, rtnPage);
	if(request.getHeader("accept")!=null){
		if(request.getHeader("accept").indexOf("application/json") >=0){
			out.write("{\"status\":false}");
			msgWriter.DrawMessages();
			return;
		}
	}
%>
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
<%
}catch(Exception e){
	try{
		if(exception != null){
			e.printStackTrace();
			out.println("<br><br>"+exception);
			out.println("<pre>");
			exception.printStackTrace( new java.io.PrintWriter( out ) );
			out.println("</pre>");
		}
	}catch(Exception ex){
		ex.printStackTrace();
	}
}
%>
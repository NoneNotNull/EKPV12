<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.util.KmssMessageWriter"%>
<%@page import="com.landray.kmss.util.KmssReturnPage"%>
<% if(request.getAttribute("KMSS_RETURNPAGE")!=null){ 
	KmssMessageWriter msgWriter = new KmssMessageWriter(request, (KmssReturnPage)request.getAttribute("KMSS_RETURNPAGE"));
%>
	<script type="text/javascript" src="${KMSS_Parameter_StylePath}promptBox/syntaxhighlighter/scripts/shBrushBash.js"></script>
	<link type="text/css" rel="stylesheet" href="${KMSS_Parameter_StylePath}promptBox/syntaxhighlighter/styles/shCore.css"/>
	<link type="text/css" rel="stylesheet" href="${KMSS_Parameter_StylePath}promptBox/syntaxhighlighter/styles/shThemeDefault.css"/>
	<script type="text/javascript">
		SyntaxHighlighter.config.clipboardSwf = '${KMSS_Parameter_StylePath}promptBox/syntaxhighlighter/scripts/clipboard.swf';
		SyntaxHighlighter.all();
		seajs.use(['theme!prompt']);
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
	<div class="prompt_frame_simple">
		<table>
			<tr>
				<td class="caution_msg">
					<span class="caution_msg_title"><%=msgWriter.DrawTitle()%></span>
					<%=msgWriter.DrawMessages()%>
				</td>
			</tr>
		</table>
	</div>
<% }%>

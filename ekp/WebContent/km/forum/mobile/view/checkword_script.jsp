<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="com.landray.kmss.km.forum.model.KmForumConfig"%>
<%
	 String isCheckWord = new KmForumConfig().getIsWordCheck();
	 request.setAttribute("isCheckWord",isCheckWord);
%>
function  forum_wordCheck(content,warnText){
	var result = true;
	<c:if test="${isCheckWord==true}">
		var url = "${LUI_ContextPath}/km/forum/km_forum/kmForumPost.do?method=getIsHasSensitiveword";
		var data ={content:encodeURIComponent(content)};
		request.post(url, {
					data : data,
					handleAs : 'json',
					sync: true
				}).then(function(data){
					var hasWarn = (data==true || data=='true'); 
					if(hasWarn){
						Tip.fail({text:warnText});
					}
					result = !hasWarn;
				},function(data){
					result = true;
				});
	</c:if>
	return result;
}
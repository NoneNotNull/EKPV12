<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
 
<a href="#" onclick="ShowBookmarkDialog();" title="收藏" <c:if test='${not empty param.fdClass}'>class='${param.fdClass}'</c:if>><span><bean:message key="button.bookmark" bundle="sys-bookmark"/></span></a> 
		 
<script language="JavaScript">
 //OptBar_AddOptBar("bookmarkBtn");
function ShowBookmarkDialog() {
	var openurl = "<c:url value="/sys/bookmark/include/bookmark_edit.jsp" />";
	var width = 500;
	var height = 380;
	// for IE and FF3
	Bookmark_PopupWindow(openurl, width, height, {
		'url': GetBookmarkUrl(), 
		'subject': GetBookmarkSubject(), 
		'fdModelId': '${param.fdModelId}',
		'fdModelName': '${param.fdModelName}'
	});
}
function GetBookmarkSubject() {
	var subject = "<c:out value="${param.fdSubject}" />";
	if (subject.length < 1) {
		var title = document.getElementsByTagName("title");
		if (title != null && title.length > 0) {
			subject = title[0].text;
			if (subject == null) 
				subject = "";
			else
				subject = subject.replace(/(^\s*)|(\s*$)/g, "");
		}
	}
	return subject;
}
function GetBookmarkUrl() {
	var url = "<c:out value="${param.fdUrl}" />";
	var context = "<%=request.getContextPath() %>";
	if (url.length < 1) {
		url = window.location.href;
		url = url.substring(url.indexOf('//') + 2, url.length);
		url = url.substring(url.indexOf('/'), url.length);
		if (context.length > 1) {
			url = url.substring(context.length, url.length);
		}
	}
	return url;
}
function Bookmark_PopupWindow(url,width, height, parameter){
	width = width==null?640:width;
	height = height==null?820:height;
	var left = (screen.width-width)/2;
	var top = (screen.height-height)/2;
	var winStyle = "resizable:1;dialogwidth:"+width+"px;dialogheight:"+height+"px;dialogleft:"+left+";dialogtop:"+top;
	url = "<c:url value="/resource/jsp/frame.jsp?url=" />" + encodeURIComponent(url);
	return showModalDialog(url, parameter, winStyle);
}
</script>

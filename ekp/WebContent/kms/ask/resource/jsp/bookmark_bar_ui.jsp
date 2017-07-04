<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui"%>
<script src='${ KMSS_Parameter_ContextPath }sys/bookmark/import/bookmark.js'></script>
<a href="#" onclick="___BookmarkDialog({'url': GetBookmarkUrl(), 'subject': GetBookmarkSubject(), 'fdModelId': '${param.fdModelId}','fdModelName': '${param.fdModelName}'});" title="收藏" <c:if test='${not empty param.fdClass}'>class='${param.fdClass}'</c:if>><span><bean:message key="button.bookmark" bundle="sys-bookmark"/></span></a> 
		 
<script language="JavaScript">
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
</script>

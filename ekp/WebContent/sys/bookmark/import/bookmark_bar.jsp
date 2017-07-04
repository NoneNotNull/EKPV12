<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui"%>
<script src='${ KMSS_Parameter_ContextPath }sys/bookmark/import/bookmark.js'></script>
<ui:button order="1" parentId="toolbar" text="${ lfn:message('sys-bookmark:button.bookmark') }" 
	onclick="___BookmarkDialog({'url': GetBookmarkUrl(), 'subject': GetBookmarkSubject(), 'fdModelId': '${param.fdModelId}','fdModelName': '${param.fdModelName}'});">
</ui:button>
<script>
function GetBookmarkSubject() {
	var subject = "${lfn:escapeJs(param.fdSubject)}";
	if (subject.length < 1) {
		var title = document.getElementsByTagName("title");
		if (title != null && title.length > 0) {
			subject = title[0].text;
			if (subject == null) {
				subject = "";
			} else {
				subject = subject.replace(/(^\s*)|(\s*$)/g, "");
			}
		}
	}
	return subject;
}
function GetBookmarkUrl() {
	var url = "${lfn:escapeJs(param.fdUrl)}";
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
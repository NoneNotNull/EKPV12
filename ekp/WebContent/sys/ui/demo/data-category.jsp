<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%

String pre = request.getParameter("categoryId");
if (pre == null || pre.length() < 0) {
	pre = "1-";
} else {
	pre = pre + "-";
}
%>
[
<%
for (int i = 0; i < 20; i ++) {
	StringBuilder html = new StringBuilder();
	if (i > 0) {
		html.append(",");
	}
	html.append("{\"text\":\"选项:").append(pre).append(i + 1).append("\"");
	html.append(",\"value\":\"").append(pre).append(i + 1).append("\"}");
	out.println(html);
}
%>
]
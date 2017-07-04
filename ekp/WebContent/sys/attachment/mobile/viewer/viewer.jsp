<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String viewerStyle = "";
	String viewerParam = request.getAttribute("viewerParam").toString();
	
	String[] paramArray = viewerParam.split(",");
	for (int i = 0; i < paramArray.length; i++) {
		String[] param = paramArray[i].split(":");
		if ("viewerStyle".equals(param[0])) {
			viewerStyle = param[1];
		}
	}
	if (viewerStyle.equals("excel")) {
		request.getRequestDispatcher(
				"/sys/attachment/mobile/viewer/excel/excelViewer.jsp")
				.forward(request, response);
	}
	if (viewerStyle.equals("word")||viewerStyle.equals("pdf")) {
		request.getRequestDispatcher(
				"/sys/attachment/mobile/viewer/doc/docViewer.jsp")
				.forward(request, response);
	}

	if (viewerStyle.equals("ppt")) {
		request.getRequestDispatcher(
				"/sys/attachment/mobile/viewer/ppt/pptViewer.jsp")
				.forward(request, response);
	}
%>
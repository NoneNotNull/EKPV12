<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String toolPosition = request.getParameter("toolPosition");
	String showAllPage = request.getParameter("showAllPage") == null ? "false"
			: request.getParameter("showAllPage");
	request.setAttribute("toolPosition", toolPosition);
	String newOpen = request.getParameter("newOpen");
	request.setAttribute("newOpen", newOpen);
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
				"/sys/attachment/viewer/aspose_htmlexcelviewer.jsp")
				.forward(request, response);
	}
	if (viewerStyle.equals("word") || viewerStyle.equals("ppt")
			|| viewerStyle.equals("pdf")) {
		if (showAllPage.equals("true")) {
			request
					.getRequestDispatcher(
							"/sys/attachment/viewer/aspose_htmlallpageviewer.jsp")
					.forward(request, response);
		} else {
			request.getRequestDispatcher(
					"/sys/attachment/viewer/aspose_htmlpageviewer.jsp")
					.forward(request, response);
		}
	}
%>
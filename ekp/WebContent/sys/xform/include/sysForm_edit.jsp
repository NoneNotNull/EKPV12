<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%request.setAttribute("SysForm.showStatus","readOnly"); %>
<%request.setAttribute("SysForm.base.showStatus", "readOnly"); %>
<%pageContext.setAttribute("SysForm.importType", "edit"); %>
<%@ include file="/sys/xform/include/sysForm_main.jsp" %>
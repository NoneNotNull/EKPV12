<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="/sys/ui/jsp/common.jsp"%>

<c:import url="/sys/mobile/sys_mobile_module_category_config/sysMobileModuleCategoryConfig.do?method=view">
	<c:param name="fdModelName" value="<%=request.getParameter("fdModelName") %>" />
</c:import>
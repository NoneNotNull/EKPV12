<%@ include file="/resource/jsp/common.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="com.landray.kmss.sys.metadata.interfaces.IExtendDataForm"%>
<%@ page import="com.landray.kmss.util.StringUtil"%>
<%@ page import="com.landray.kmss.sys.property.util.FileWriterUtil"%>
<%
	String sysPropFormBeanName = request.getParameter("formName");

	IExtendDataForm sysPropMainForm = (IExtendDataForm) request
			.getAttribute(sysPropFormBeanName);

	if (StringUtil.isNotNull(sysPropMainForm.getExtendDataFormInfo()
			.getExtendFilePath())) {
		String _formFilePath = sysPropMainForm.getExtendDataFormInfo()
				.getExtendFilePath() + "_pda.jsp";
		if (FileWriterUtil.checkFileExist(FileWriterUtil
				.getWebContentPath() + _formFilePath)) {
%>
<c:import url="<%=_formFilePath%>" charEncoding="UTF-8">
</c:import>
<%
	}
	}
%>
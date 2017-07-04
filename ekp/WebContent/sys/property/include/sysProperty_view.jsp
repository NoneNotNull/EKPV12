<%@ include file="/resource/jsp/common.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.metadata.interfaces.IExtendDataForm"%>
<%@ page import="com.landray.kmss.util.StringUtil"%>
<%@ page import="com.landray.kmss.sys.property.util.FileWriterUtil"%>
<%
String sysPropFormBeanName = request.getParameter("formName");
String sysPropIsExt = request.getParameter("isExt");
IExtendDataForm sysPropMainForm = (IExtendDataForm) request.getAttribute(sysPropFormBeanName);
if (StringUtil.isNotNull(sysPropMainForm.getExtendDataFormInfo().getExtendFilePath())) {
	String _formFilePath = sysPropMainForm.getExtendDataFormInfo().getExtendFilePath()
			+ ("true".equals(sysPropIsExt) ? "_ext" : "") + ".jsp";
	if (FileWriterUtil.checkFileExist(FileWriterUtil.getWebContentPath() + _formFilePath)) {
%>
	<xform:text property="extendDataFormInfo.extendFilePath" showStatus="noShow" />
	<c:import url="<%=_formFilePath%>" charEncoding="UTF-8">
	</c:import>
<%
	}
}
%>
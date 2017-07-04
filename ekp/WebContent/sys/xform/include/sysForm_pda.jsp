<%@ include file="/resource/jsp/common.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="org.apache.commons.beanutils.PropertyUtils"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%
boolean isEditMode = "edit".equals(request.getParameter("method"))||"add".equals(request.getParameter("method"));
if(isEditMode){
	request.setAttribute("SysForm.showStatus","readOnly"); 
	request.setAttribute("SysForm.base.showStatus", "readOnly"); 
	pageContext.setAttribute("SysForm.importType", "edit");
}else{
	request.setAttribute("SysForm.showStatus", "view");
	request.setAttribute("SysForm.base.showStatus", "view");
	pageContext.setAttribute("SysForm.importType", "view");
}
%>
<%
String formBeanName = request.getParameter("formName");
String mainFormName = null;
String xformFormName = null;
int indexOf = formBeanName.indexOf('.');
if (indexOf > -1) {
	mainFormName = formBeanName.substring(0, indexOf);
	xformFormName = formBeanName.substring(indexOf + 1);
	pageContext.setAttribute("_formName", xformFormName);
} else {
	mainFormName = formBeanName;
	pageContext.setAttribute("_formName", null);
}

Object mainForm = request.getAttribute(mainFormName);
Object xform = xformFormName == null ? mainForm : PropertyUtils.getProperty(mainForm, xformFormName);
String path = (String) PropertyUtils.getProperty(xform, "extendDataFormInfo.extendFilePath");

if (!isEditMode) {
	if (mainForm instanceof com.landray.kmss.sys.workflow.interfaces.ISysWfMainForm 
			&& "view".equals(pageContext.getAttribute("SysForm.importType"))) {
		com.landray.kmss.sys.workflow.interfaces.ISysWfMainForm wfForm = (com.landray.kmss.sys.workflow.interfaces.ISysWfMainForm) mainForm;
		if (wfForm.getDocStatus().charAt(0) < '3') {
			//request.setAttribute("SysForm.showStatus", "readOnly");
			request.setAttribute("SysForm.base.showStatus", "readOnly");
		}
	}
}

request.setAttribute("_xformMainForm", mainForm);
request.setAttribute("_xformForm", xform);
pageContext.setAttribute("_formFilePath", path);

%>
<c:if test="${_formFilePath!=null}">
	<xform:config formName="${_formName}" >
		<c:import url="/${_formFilePath}.4pda.jsp" charEncoding="UTF-8">
			<c:param name="method" value="${param.method}" />
			<c:param name="fdKey" value="${param.fdKey}" />
			<c:param name="optType" value="${pageScope['SysForm.importType']}"/>
		</c:import>
	</xform:config>
</c:if>
<%
pageContext.removeAttribute("_formName");
pageContext.removeAttribute("_formFilePath");
request.removeAttribute("SysForm.base.showStatus");
request.removeAttribute("SysForm.isPrint");
request.removeAttribute("SysForm.showStatus");
request.removeAttribute("_xformMainForm");
request.removeAttribute("_xformForm");
%>
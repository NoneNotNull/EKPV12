<%@ include file="/resource/jsp/common.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="org.apache.commons.beanutils.PropertyUtils"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="com.landray.kmss.sys.xform.service.SysFormFileMannager"%>
<%@page import="com.landray.kmss.sys.xform.base.model.BaseFormTemplateHistory"%>
<%@page import="com.landray.kmss.util.SpringBeanUtil"%>
<%@page import="com.landray.kmss.sys.xform.base.dao.ISysFormTemplateHistoryDao"%>
<%@page import="com.landray.kmss.sys.xform.base.dao.ISysFormCommonTempHistoryDao"%>
<%@page import="com.landray.kmss.sys.xform.base.model.AbstractFormTemplate"%>
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

boolean xform_isPrint = "true".equals(request.getParameter("isPrint")); // 是否为打印,同时为优化打印做准备
// SysForm.showStatus 代表了，控件为只读情况下，只读方式为 view,还是readOnly
if (xform_isPrint) {
	request.setAttribute("SysForm.isPrint", "true");
	request.setAttribute("SysForm.showStatus", "view");
	request.setAttribute("SysForm.base.showStatus", "view");
} else {
	if (mainForm instanceof com.landray.kmss.sys.workflow.interfaces.ISysWfMainForm 
			&& "view".equals(pageContext.getAttribute("SysForm.importType"))) {
		com.landray.kmss.sys.workflow.interfaces.ISysWfMainForm wfForm = (com.landray.kmss.sys.workflow.interfaces.ISysWfMainForm) mainForm;
		if (wfForm.getDocStatus().charAt(0) < '3') {
			//request.setAttribute("SysForm.showStatus", "readOnly");
			request.setAttribute("SysForm.base.showStatus", "readOnly");
		}
	}
}

String path = (String) PropertyUtils.getProperty(xform, "extendDataFormInfo.extendFilePath");

if (StringUtil.isNotNull(path)) {
	if (path.startsWith("/")) {
		path = path.substring(1);
	}
	request.setAttribute("_xformMainForm", mainForm);
	request.setAttribute("_xformForm", xform);
	pageContext.setAttribute("_formFilePath", path);
	// 兼容EKP3.1代码
	//out.println("<!-- 执行兼容EKP3.01代码  -->");
	Object originFormBean = pageContext.getAttribute("org.apache.struts.taglib.html.BEAN", PageContext.REQUEST_SCOPE);
	pageContext.setAttribute("org.apache.struts.taglib.html.BEAN", mainForm, PageContext.REQUEST_SCOPE);
	
	boolean isUseTab = !"false".equals(request.getParameter("useTab"));
	boolean isUseScript = !"false".equals(request.getParameter("useScript"));
	out.println("<input type=\"hidden\" name=\"" + (xformFormName == null ? "" : xformFormName + ".") + "extendDataFormInfo.extendFilePath\" value=\"" + path + "\" />");
	
	SysFormFileMannager fileMannager = SysFormFileMannager.getInstance();
	AbstractFormTemplate history = null;
	
	if (fileMannager.isDefineTemp(path)) {
		
		history =((ISysFormTemplateHistoryDao)SpringBeanUtil.getBean("sysFormTemplateHistoryDao")).findByFileName(path);
	} else if (fileMannager.isCommonTemp(path)) {
		history =((ISysFormCommonTempHistoryDao)SpringBeanUtil.getBean("sysFormCommonTempHistoryDao")).findByFileName(path);
	}
	Boolean isUpTab = false;
	if(history !=null){
		isUpTab = history.getFdIsUpTab();
	}
	//通过是否提升的标记判断是否需要显示外围的标签 @作者：曹映辉 @日期：2012年3月16日 
	if(isUpTab !=null && isUpTab){
		isUseTab=false;
	}
	
%>
<% if (isUseScript) {%>
<%@ include file="/sys/xform/include/sysForm_script.jsp" %>
<%}%>
<% if (isUseTab) {%>
<tr
	LKS_LabelName="<kmss:message key="${not empty param.messageKey ? param.messageKey : 'sys-xform:sysForm.tab.label'}" />"
	style="display: none">
	<td>
<%}%>
	<script>Com_IncludeFile("xform.js|calendar.js");</script>
	<xform:config formName="${_formName}" >
	<c:import url="/${_formFilePath}.jsp" charEncoding="UTF-8">
		<c:param name="method" value="${param.method}" />
		<c:param name="fdKey" value="${param.fdKey}" />
	</c:import>
	</xform:config>
<% if (isUseTab) {%>
	</td>
	</tr>
<%}%>
<%
	//兼容EKP3.1代码
	pageContext.setAttribute("org.apache.struts.taglib.html.BEAN", originFormBean, PageContext.REQUEST_SCOPE);
}
pageContext.removeAttribute("_formName");
pageContext.removeAttribute("_formFilePath");
request.removeAttribute("SysForm.base.showStatus");
request.removeAttribute("SysForm.isPrint");
request.removeAttribute("SysForm.showStatus");
request.removeAttribute("_xformMainForm");
request.removeAttribute("_xformForm");
%>
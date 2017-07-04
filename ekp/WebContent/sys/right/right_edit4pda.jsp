<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ page import="java.util.Set" %>
<%@ page import="com.landray.kmss.sys.config.dict.SysDataDict" %>
<%@ page import="com.landray.kmss.sys.right.interfaces.IExtendAuthForm" %>
<%@ page import="com.landray.kmss.sys.right.interfaces.IBaseAuthForm" %>
<%
	String moduleModelName = request.getParameter("moduleModelName");
	String formName = request.getParameter("formName");
	Set propertyNameSet =  SysDataDict.getInstance().getModel(moduleModelName).getPropertyMap().keySet();
%>
		<c:set var="rightForm" value="${requestScope[param.formName]}" />
    	<%-- 主模型中含有默认读者设置时显示逻辑--%>
		<% if(propertyNameSet.contains("authReaders")){ %>
				<% if(propertyNameSet.contains("authRBPFlag")){ %>
			    <html:hidden property="authRBPFlag"  value="${rightForm.authRBPFlag}"/>
			    <% } %>
				<%--是否允许起草人更改默认阅读者--%>				
				<c:if test="${not empty rightForm.authReaderNames}">
					 <html:hidden property="authReaderIds"/>
				</c:if>
		<% } %>
		<%-- 主模型中含有默认编辑者设置时显示逻辑--%>
		<% if(propertyNameSet.contains("authEditors")){ %>
				<% if(propertyNameSet.contains("authChangeEditorFlag") && ((IBaseAuthForm)pageContext.getAttribute("rightForm")).getAuthChangeEditorFlag() == true ){ %>
					<c:if test="${not empty rightForm.authEditorNames}">
						 <html:hidden property="authEditorIds"/>
					</c:if>
				<% } %>		
		<%} %>
		<%-- 主模型中含有附件权限设置时显示逻辑--%>
		<% if(propertyNameSet.contains("authAttCopys")
				|| propertyNameSet.contains("authAttDownloads")
				|| propertyNameSet.contains("authAttPrints")){ %>
				<%--是否允许起草人更改默认的附件权限设置--%>	
				<% if(propertyNameSet.contains("authChangeAtt") && ((IExtendAuthForm)pageContext.getAttribute("rightForm")).getAuthChangeAtt().booleanValue() == true ){ %>
					<%--附件拷贝--%>	
					<% if(propertyNameSet.contains("authAttCopys")){ %>
						<html:hidden property="authAttCopyIds" />
						<html:hidden property="authAttNocopy" />
					<%} %>
					<%--附件下载--%>	
					<% if(propertyNameSet.contains("authAttDownloads")){ %>
						<html:hidden property="authAttDownloadIds" />
						<html:hidden property="authAttNodownload" />
					<%}%>
					<%--附件打印--%>	
					<% if(propertyNameSet.contains("authAttPrints")){ %>
						<html:hidden property="authAttPrintIds" />
						<html:hidden property="authAttNoprint" />
					<%} %>
				
				<% }else{ %>
					<%--附件拷贝--%>
					<% if(propertyNameSet.contains("authAttCopys")){ %> 
						<html:hidden property="authAttCopyIds" />
						<html:hidden property="authAttCopyNames" />
					<%} %>
					<%--附件下载--%>	
					<% if(propertyNameSet.contains("authAttDownloads")){ %>
						<html:hidden property="authAttDownloadIds" />
						<html:hidden property="authAttNodownload" />
					<%}%>
					<%--附件打印--%>	
					<% if(propertyNameSet.contains("authAttPrints")){ %>
						<html:hidden property="authAttPrintIds" />
						<html:hidden property="authAttNoprint" />
					<%} %>
				
				<% } %>
		<%} %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ page import="java.util.Set" %>
<%@ page import="com.landray.kmss.sys.config.dict.SysDataDict" %>
<%
	String moduleModelName = request.getParameter("moduleModelName");
	Set propertyNameSet =  SysDataDict.getInstance().getModel(moduleModelName).getPropertyMap().keySet();
%>
<c:set var="tmpRightForm" value="${requestScope[param.formName]}" />
	<% if(propertyNameSet.contains("authTmpReaders")){ %>
		<tr>
			<td class="td_normal_title" width="15%"><bean:message
				bundle="sys-right" key="right.read.authTmpReaders" /></td>
			<td width="85%">
			<c:if test="${empty tmpRightForm.authTmpReaderNames}">
				<c:if test="${tmpRightForm.authReaderNoteFlag=='1'}">
				<bean:message bundle="sys-right" key="right.all.person" />
				</c:if>
				<c:if test="${tmpRightForm.authReaderNoteFlag=='2'}">
				<bean:message bundle="sys-right" key="right.other.person" />
				</c:if>
			</c:if>
			<c:if test="${not empty tmpRightForm.authTmpReaderNames}">
				${tmpRightForm.authTmpReaderNames}
			</c:if>
			</td>
		</tr>
		<%} %>
		
		<% if(propertyNameSet.contains("authTmpEditors")){ %>
		<tr>
			<td class="td_normal_title"><bean:message bundle="sys-right"
				key="right.edit.authTmpEditors" /></td>
			<td>
			<c:if test="${empty tmpRightForm.authTmpEditorNames}">
				<bean:message bundle="sys-right" key="right.other.person.edit" />
			</c:if>
			<c:if test="${not empty tmpRightForm.authTmpEditorNames}">
				${tmpRightForm.authTmpEditorNames}
			</c:if>
			</td>
		</tr>
		<%} %>
		
		<% if(propertyNameSet.contains("authTmpAttCopys")
				|| propertyNameSet.contains("authTmpAttDownloads")
				|| propertyNameSet.contains("authTmpAttPrints")){ %>
		<tr>
			<td class="td_normal_title" width="15%"><bean:message
				bundle="sys-right" key="right.att.label" /></td>
			<td width="85%">
			<% if(propertyNameSet.contains("authTmpAttCopys")){ 
			boolean isJGEnabled = com.landray.kmss.sys.attachment.util.JgWebOffice.isJGEnabled();
			boolean isJGPDFEnabled = com.landray.kmss.sys.attachment.util.JgWebOffice.isJGPDFEnabled();
			if(isJGEnabled){
			    if(isJGPDFEnabled){%>
				<bean:message bundle="sys-right" key="right.att.authAttCopys.jg.pdf" />	
				<%}
			    else{%>
			    <bean:message bundle="sys-right" key="right.att.authAttCopys.jg" />		
			   <%}}
			 else{
				 if(isJGPDFEnabled){%>
				 <bean:message bundle="sys-right" key="right.att.authAttCopys.pdf" />
				 <%}
				 else{%>
				 <bean:message bundle="sys-right" key="right.att.authAttCopys" />
			<%}}%>	
			<c:if test="${tmpRightForm.authTmpAttNocopy == 'true'}">
				<bean:message key="right.att.authAttNocopy" bundle="sys-right"/>
			</c:if>
			<c:if test="${tmpRightForm.authTmpAttNocopy != 'true'}">
				<c:if test="${empty tmpRightForm.authTmpAttCopyNames}">
					<bean:message bundle="sys-right" key="right.no.restr" />
				</c:if>
				<c:if test="${not empty tmpRightForm.authTmpAttCopyNames}">
					${tmpRightForm.authTmpAttCopyNames}
				</c:if>			
			</c:if>
			<br>
			<%} %>
			
			<% if(propertyNameSet.contains("authTmpAttDownloads")){ %>
				<%if(com.landray.kmss.sys.attachment.util.JgWebOffice.isJGPDFEnabled()){%>
				    <bean:message bundle="sys-right" key="right.att.authAttDownloads.pdf" />
				<%}else{ %>
					<bean:message bundle="sys-right" key="right.att.authAttDownloads" />
				<%}%>
			<c:if test="${tmpRightForm.authTmpAttNodownload == 'true'}">
				<bean:message key="right.att.authAttNodownload" bundle="sys-right"/>
			</c:if>
			<c:if test="${tmpRightForm.authTmpAttNodownload != 'true'}">
				<c:if test="${empty tmpRightForm.authTmpAttDownloadNames}">
					<bean:message bundle="sys-right" key="right.no.restr" />
				</c:if>
				<c:if test="${not empty tmpRightForm.authTmpAttDownloadNames}">
					${tmpRightForm.authTmpAttDownloadNames}
				</c:if>			
			</c:if>
			<br>
			<%} %>
			
			<% if(propertyNameSet.contains("authTmpAttPrints")){ %>
				<%if(com.landray.kmss.sys.attachment.util.JgWebOffice.isJGPDFEnabled()){%>
				    <bean:message bundle="sys-right" key="right.att.authAttPrints.pdf" />
				<%}else{ %>
					<bean:message bundle="sys-right" key="right.att.authAttPrints" />
				<%}%>
			<c:if test="${tmpRightForm.authTmpAttNoprint == 'true'}">
				<bean:message key="right.att.authAttNoprint" bundle="sys-right"/>
			</c:if>
			<c:if test="${tmpRightForm.authTmpAttNoprint != 'true'}">
				<c:if test="${empty tmpRightForm.authTmpAttPrintNames}">
					<bean:message bundle="sys-right" key="right.no.restr" />
				</c:if>
				<c:if test="${not empty tmpRightForm.authTmpAttPrintNames}">
					${tmpRightForm.authTmpAttPrintNames}
				</c:if>			
			</c:if>
			<%} %>

			</td>
		</tr>	
	<%} %>

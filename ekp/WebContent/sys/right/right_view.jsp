<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%><%@ include file="/resource/jsp/common.jsp"%>
<%@ page import="java.util.Set" %>
<%@ page import="com.landray.kmss.sys.config.dict.SysDataDict" %>
<%
	String moduleModelName = request.getParameter("moduleModelName");
	Set propertyNameSet =  SysDataDict.getInstance().getModel(moduleModelName).getPropertyMap().keySet();
%>
<style>
.div_img{
}
.div_img span{
	position: relative;
	top: 6px
}
</style>
<c:set var="rightForm" value="${requestScope[param.formName]}" />
	<% if(propertyNameSet.contains("authReaders")){ %>
		<tr>
			<td class="td_normal_title" width="15%"><bean:message
				bundle="sys-right" key="right.read.authReaders" /></td>
			<td width="85%">
			<c:if test="${empty rightForm.authReaderNames}">
				<c:if test="${rightForm.authReaderNoteFlag=='1'}">
				<bean:message bundle="sys-right" key="right.all.person" />
				</c:if>
				<c:if test="${rightForm.authReaderNoteFlag=='2'}">
				<bean:message bundle="sys-right" key="right.other.person" />
				</c:if>
			</c:if>
			<c:if test="${not empty rightForm.authReaderNames}">
				${rightForm.authReaderNames}
			</c:if>
			</td>
		</tr>
		<%} %>
		
		<% if(propertyNameSet.contains("authEditors")){ %>
		<tr>
			<td class="td_normal_title"><bean:message bundle="sys-right"
				key="right.edit.authEditors" /></td>
			<td>
			<c:if test="${empty rightForm.authEditorNames}">
				<bean:message bundle="sys-right" key="right.other.person.edit" />
			</c:if>
			<c:if test="${not empty rightForm.authEditorNames}">
				${rightForm.authEditorNames}
			</c:if>
			</td>
		</tr>
		<%} %>
		
		<% if(propertyNameSet.contains("authAttCopys")
				|| propertyNameSet.contains("authAttDownloads")
				|| propertyNameSet.contains("authAttPrints")){ %>
		<tr>
			<td class="td_normal_title" width="15%"><bean:message
				bundle="sys-right" key="right.att.label" /></td>
			<td width="85%">
			<% if(propertyNameSet.contains("authAttCopys")){ 
			boolean isJGEnabled = com.landray.kmss.sys.attachment.util.JgWebOffice.isJGEnabled(); 
			boolean isJGPDFEnabled = com.landray.kmss.sys.attachment.util.JgWebOffice.isJGPDFEnabled();
			if(isJGEnabled){
			    if(isJGPDFEnabled){%>
				<bean:message bundle="sys-right" key="right.att.authAttCopys.jg.pdf" />
				<bean:message bundle="sys-right" key="right.colon" />	
				<%}
			    else{%>
			    <bean:message bundle="sys-right" key="right.att.authAttCopys.jg" />	
				<bean:message bundle="sys-right" key="right.colon" />	
			   <%}}
			 else{
				 if(isJGPDFEnabled){%>
				 <bean:message bundle="sys-right" key="right.att.authAttCopys.pdf" />
				 <bean:message bundle="sys-right" key="right.colon" />
				 <%}
				 else{%>
				 <bean:message bundle="sys-right" key="right.att.authAttCopys" />
				 <bean:message bundle="sys-right" key="right.colon" />
			<%}}%>
			<input type="hidden" name="authAttNocopy" value="${rightForm.authAttNocopy}" />
			<c:if test="${rightForm.authAttNocopy == 'true'}">
				<bean:message key="right.att.authAttNocopy" bundle="sys-right"/>
			</c:if>
			<c:if test="${rightForm.authAttNocopy != 'true'}">
				<c:if test="${empty rightForm.authAttCopyNames}">
					<bean:message bundle="sys-right" key="right.no.restr" />
				</c:if>
				<c:if test="${not empty rightForm.authAttCopyNames}">
					${rightForm.authAttCopyNames}
				</c:if>			
			</c:if>
			<br>
			<%} %>
			
			<% if(propertyNameSet.contains("authAttDownloads")){ %>
				<%if(com.landray.kmss.sys.attachment.util.JgWebOffice.isJGPDFEnabled()){%>
				    <bean:message bundle="sys-right" key="right.att.authAttDownloads.pdf" />
				 	<bean:message bundle="sys-right" key="right.colon" />
				<%}else{ %>
					<bean:message bundle="sys-right" key="right.att.authAttDownloads" />
				 	<bean:message bundle="sys-right" key="right.colon" />
				<%}%>
			<input type="hidden" name="authAttNodownload" value="${rightForm.authAttNodownload}" />
			<c:if test="${rightForm.authAttNodownload == 'true'}">
				<bean:message key="right.att.authAttNodownload" bundle="sys-right"/>
			</c:if>
			<c:if test="${rightForm.authAttNodownload != 'true'}">
				<c:if test="${empty rightForm.authAttDownloadNames}">
					<bean:message bundle="sys-right" key="right.no.restr" />
				</c:if>
				<c:if test="${not empty rightForm.authAttDownloadNames}">
					${rightForm.authAttDownloadNames}
				</c:if>			
			</c:if>
			<br>
			<%} %>
			
			<% if(propertyNameSet.contains("authAttPrints")){ %>
				<%if(com.landray.kmss.sys.attachment.util.JgWebOffice.isJGPDFEnabled()){%>
				    <bean:message bundle="sys-right" key="right.att.authAttPrints.pdf" />
				 	<bean:message bundle="sys-right" key="right.colon" />
				<%}else{ %>
					<bean:message bundle="sys-right" key="right.att.authAttPrints" />
				 	<bean:message bundle="sys-right" key="right.colon" />
				<%}%>
			<input type="hidden" name="authAttNoprint" value="${rightForm.authAttNoprint}" />
			<c:if test="${rightForm.authAttNoprint == 'true'}">
				<bean:message key="right.att.authAttNoprint" bundle="sys-right"/>
			</c:if>
			<c:if test="${rightForm.authAttNoprint != 'true'}">
				<c:if test="${empty rightForm.authAttPrintNames}">
					<bean:message bundle="sys-right" key="right.no.restr" />
				</c:if>
				<c:if test="${not empty rightForm.authAttPrintNames}">
					${rightForm.authAttPrintNames}
				</c:if>			
			</c:if>
			<%} %>
            <div class="div_img">
                <bean:message bundle="sys-right" key="right.att.surport" />                           
				<span><img src="${KMSS_Parameter_ContextPath}sys/right/resource/images/Word.png" height="20" width="20" title="MS Word "/></span>
				<span><img src="${KMSS_Parameter_ContextPath}sys/right/resource/images/Excel.png" height="20" width="20" title="MS Excel"/></span>
				<span><img src="${KMSS_Parameter_ContextPath}sys/right/resource/images/PowerPoint.png" height="20" width="20" title="MS PowerPoint"/></span>
				<span><img src="${KMSS_Parameter_ContextPath}sys/right/resource/images/Project.png" height="20" width="20" title="MS Project"/></span>
				<span><img src="${KMSS_Parameter_ContextPath}sys/right/resource/images/Visio.png" height="20" width="20" title="MS Visio"/></span>
				<span><img src="${KMSS_Parameter_ContextPath}sys/right/resource/images/AdobePdf.png" height="20" width="20" title="PDF"/></span>
			</div>
			</td>
		</tr>
	<%} %>
			
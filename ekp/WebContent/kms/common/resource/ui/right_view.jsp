<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%><%@ include file="/resource/jsp/common.jsp"%>
<%@ page import="java.util.Set" %>
<%@ page import="com.landray.kmss.sys.config.dict.SysDataDict" %>
<%
	String moduleModelName = request.getParameter("moduleModelName");
	Set propertyNameSet =  SysDataDict.getInstance().getModel(moduleModelName).getPropertyMap().keySet();
%>
<tr LKS_LabelName="<bean:message bundle="sys-right" key="right.moduleName" />" style="display:none"  >
 <td>  
 <table border="0" cellspacing="0" width="100%" cellpadding="0"   >
	 <tr>
				<td> <br> 

 <table class='t_d' border="1" cellspacing="0" width="100%" cellpadding="0"  >
 <c:set var="rightForm" value="${requestScope[param.formName]}" />
	<% if(propertyNameSet.contains("authReaders")){ %>
		 <tr class='t_d_a'>
			<td class="td_normal_titles" width="15%"><bean:message
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
		<tr  class='t_d_b'>
			<td class="td_normal_titles"><bean:message bundle="sys-right"
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
		<tr  class='t_d_a'>
			<td class="td_normal_titles" width="15%"><bean:message
				bundle="sys-right" key="right.att.label" /></td>
			<td width="85%">
			<% if(propertyNameSet.contains("authAttCopys")){ 
			boolean isJGEnabled = com.landray.kmss.sys.attachment.util.JgWebOffice.isJGEnabled(); 
			if(isJGEnabled){%>
			<bean:message
				bundle="sys-right" key="right.att.authAttCopys.jg" />								
			<%}else{ %>
			<bean:message
				bundle="sys-right" key="right.att.authAttCopys" />	
				<%} %>	
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
			<bean:message
				bundle="sys-right" key="right.att.authAttDownloads" />
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
			<bean:message
				bundle="sys-right" key="right.att.authAttPrints" />
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

			</td>
		</tr>	
	<%} %>
    </table>
     </td>
 </tr>	
  </table>
   </td>
 </tr>						
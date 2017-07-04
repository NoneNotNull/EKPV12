<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%><%@ include file="/resource/jsp/common.jsp"%>
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
	<% if(propertyNameSet.contains("authReaders")){ %>
		<tr>
			<th><nobr><bean:message
				bundle="sys-right" key="right.read.authReaders" /></nobr></th>
			<td>
			<% if(propertyNameSet.contains("authChangeReaderFlag") && ((IBaseAuthForm)pageContext.getAttribute("rightForm")).getAuthChangeReaderFlag().booleanValue() == true ){ %>
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
				<html:hidden property="authReaderIds" />				
			<% }else{ %>
				<html:hidden property="authReaderIds" /> <html:textarea
				property="authReaderNames" readonly="true"
				style="width:90%;height:90px" styleClass="inputmul" /> 
				<a href="#"
					onclick="Dialog_Address(true, 'authReaderIds','authReaderNames', ';', ORG_TYPE_ALL);">
				<bean:message key="dialog.selectOrg" /> </a>
				<br>
				<c:if test="${rightForm.authReaderNoteFlag=='1'}">
				<bean:message
				bundle="sys-right" key="right.read.authReaders.note" />
				</c:if>
				<c:if test="${rightForm.authReaderNoteFlag=='2'}">
				<bean:message
				bundle="sys-right" key="right.read.authReaders.note1" />
				</c:if>
			<% }%>
			
			</td>
		</tr>
		<% } %>
		
		<% if(propertyNameSet.contains("authEditors")){ %>
		<tr>
			<th ><bean:message bundle="sys-right"
				key="right.edit.authEditors" /> </th>
			<td>
			<% if(propertyNameSet.contains("authChangeEditorFlag") && ((IBaseAuthForm)pageContext.getAttribute("rightForm")).getAuthChangeEditorFlag().booleanValue() == true ){ %>
				<c:if test="${empty rightForm.authEditorNames}">
				<bean:message bundle="sys-right" key="right.other.person.edit" />
				</c:if>
				<c:if test="${not empty rightForm.authEditorNames}">
					${rightForm.authEditorNames}
				</c:if>
			<% }else{ %>
				<html:hidden property="authEditorIds" /> <html:textarea
				property="authEditorNames" style="width:90%;height:90px"
				styleClass="inputmul" readonly="true" /> 
				<a href="#"
					onclick="Dialog_Address(true, 'authEditorIds','authEditorNames', ';', ORG_TYPE_ALL);">
				<bean:message key="dialog.selectOrg" /> </a>
				<br>
				<bean:message
				bundle="sys-right" key="right.read.authEditors.note" />		
			<% } %>		
			</td>
		</tr>
		<%} %>
		
		<% if(propertyNameSet.contains("authAttCopys")
				|| propertyNameSet.contains("authAttDownloads")
				|| propertyNameSet.contains("authAttPrints")){ %>
		<tr>
			<th  ><bean:message
				bundle="sys-right" key="right.att.label" /></th>
			<td>
			<% if(propertyNameSet.contains("authChangeAtt") && ((IExtendAuthForm)pageContext.getAttribute("rightForm")).getAuthChangeAtt().booleanValue() == true ){ %>
			
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
			
			<% }else{ %>
				<% if(propertyNameSet.contains("authAttCopys")){ 
				boolean isJGEnabled = com.landray.kmss.sys.attachment.util.JgWebOffice.isJGEnabled(); 
			if(isJGEnabled){%>
			<bean:message
				bundle="sys-right" key="right.att.authAttCopys.jg" />								
			<%}else{ %>
			<bean:message
				bundle="sys-right" key="right.att.authAttCopys" />	
				<%} %>	
				<html:checkbox property="authAttNocopy" value="1" onclick="refreshDisplay(this,'copyDiv')"/>
							<bean:message key="right.att.authAttNocopy" bundle="sys-right"/>
				<br>
				<div id="copyDiv" <c:if test="${rightForm.authAttNocopy == 'true'}">style="display:none"</c:if> > 						
				<html:hidden property="authAttCopyIds" /> <html:textarea
					property="authAttCopyNames" readonly="true"
					style="width:90%;height:90px" styleClass="inputmul" /> 
					<a href="#"
						onclick="Dialog_Address(true, 'authAttCopyIds','authAttCopyNames', ';', ORG_TYPE_ALL);">
					<bean:message key="dialog.selectOrg" /> </a>
					<br>
					<bean:message key="right.att.authAttCopys.note" bundle="sys-right"/>
				</div>
				<%} %>
				
				<% if(propertyNameSet.contains("authAttDownloads")){ %>
				<bean:message
					bundle="sys-right" key="right.att.authAttDownloads" />
				<html:checkbox property="authAttNodownload" value="1" onclick="refreshDisplay(this,'downloadDiv')"/>
							<bean:message key="right.att.authAttNodownload" bundle="sys-right"/> 
				<br>
				<div id="downloadDiv" <c:if test="${rightForm.authAttNodownload == 'true'}">style="display:none"</c:if> > 						
				<html:hidden property="authAttDownloadIds" /> <html:textarea
					property="authAttDownloadNames" readonly="true"
					style="width:90%;height:90px" styleClass="inputmul" /> 
					 <a href="#"
						onclick="Dialog_Address(true, 'authAttDownloadIds','authAttDownloadNames', ';', ORG_TYPE_ALL);">
					 <bean:message key="dialog.selectOrg" /> </a> 
					<br>
					<bean:message key="right.att.authAttDownloads.note" bundle="sys-right"/>
				</div>
				<%} %>
				
				<% if(propertyNameSet.contains("authAttPrints")){ %>
				<bean:message
					bundle="sys-right" key="right.att.authAttPrints" />
				<html:checkbox property="authAttNoprint" value="1" onclick="refreshDisplay(this,'printDiv')"/>
							<bean:message key="right.att.authAttNoprint" bundle="sys-right"/>
				<br>
				<div id="printDiv" <c:if test="${rightForm.authAttNoprint == 'true'}">style="display:none"</c:if> > 						
				<html:hidden property="authAttPrintIds" /> <html:textarea
					property="authAttPrintNames" readonly="true"
					style="width:90%;height:90px" styleClass="inputmul" /> 
					<a href="#"
						onclick="Dialog_Address(true, 'authAttPrintIds','authAttPrintNames', ';', ORG_TYPE_ALL);">
					<bean:message key="dialog.selectOrg" /> </a>
					<br>
					<bean:message key="right.att.authAttPrints.note" bundle="sys-right"/>
				</div>
				<%} %>
				
			<% } %>
			
			</td>
		</tr>	
		 	
	<%} %>
	
<script>
function refreshDisplay(obj,divName){
	var divObj = document.getElementById(divName);
	divObj.style.display=(obj.checked?"none":"");
}
</script>

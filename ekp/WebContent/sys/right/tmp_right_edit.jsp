<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ page import="java.util.Set" %>
<%@ page import="com.landray.kmss.sys.config.dict.SysDataDict" %>
<%@ page import="com.landray.kmss.sys.right.interfaces.IExtendAuthTmpForm" %>
<%@ page import="com.landray.kmss.sys.right.interfaces.IBaseAuthTmpForm" %>
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
		<% if(propertyNameSet.contains("authChangeReaderFlag")){ %>				
				<html:checkbox property="authChangeReaderFlag" value="1"/><bean:message bundle="sys-right" key="right.read.authChangeReaderFlag" />					
			<% } %>	
			<% if(propertyNameSet.contains("authRBPFlag")){ %>	
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<bean:message bundle="sys-right" key="right.effect.time" />	
					<sunbor:enums property="authRBPFlag" enumsType="sys_rbp_flag" elementType="radio" bundle="sys-right"/>		
			<% } %>					
			<html:hidden property="authTmpReaderIds" /> <html:textarea
				property="authTmpReaderNames" readonly="true"
				style="width:90%;height:90px" styleClass="inputmul" /> 
				<a href="#"
					onclick="Dialog_Address(true, 'authTmpReaderIds','authTmpReaderNames', ';', ORG_TYPE_ALL|ORG_TYPE_ROLE);">
				<bean:message key="dialog.selectOrg" /> </a>
				<br>
				<c:if test="${tmpRightForm.authReaderNoteFlag=='1'}">
				<bean:message
				bundle="sys-right" key="right.read.authReaders.note" />
				</c:if>
				<c:if test="${tmpRightForm.authReaderNoteFlag=='2'}">
				<bean:message
				bundle="sys-right" key="right.read.authReaders.note1" />
				</c:if><br>
						
			</td>
		</tr>
		<%} %>
		
		<% if(propertyNameSet.contains("authTmpEditors")){ %>
		<tr>
			<td class="td_normal_title"><bean:message bundle="sys-right"
				key="right.edit.authTmpEditors" /></td>
			<td>
			<% if(propertyNameSet.contains("authChangeEditorFlag")){ %>				
				<html:checkbox property="authChangeEditorFlag" value="1"/><bean:message bundle="sys-right" key="right.edit.authChangeEditorFlag" />						
			<% } %>
			<html:hidden property="authTmpEditorIds" /> <html:textarea
				property="authTmpEditorNames" style="width:90%;height:90px"
				styleClass="inputmul" readonly="true" /> 
				<a href="#"
					onclick="Dialog_Address(true, 'authTmpEditorIds','authTmpEditorNames', ';', ORG_TYPE_ALL|ORG_TYPE_ROLE);">
				<bean:message key="dialog.selectOrg" /> </a>
				<br>
				<bean:message
				bundle="sys-right" key="right.read.authEditors.note" />				
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
			<% if(propertyNameSet.contains("authChangeAtt")){ %>				
				<html:checkbox property="authChangeAtt" value="1"/><bean:message bundle="sys-right" key="right.att.authChangeAttFlag" /><br>					
			<% } %>
			<% if(propertyNameSet.contains("authTmpAttCopys")){ 
			boolean isJGEnabled = com.landray.kmss.sys.attachment.util.JgWebOffice
			.isJGEnabled(); 
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
			<html:checkbox property="authTmpAttNocopy" value="1" onclick="refreshDisplay(this,'copyDiv')"/>
						<bean:message key="right.att.authAttNocopy" bundle="sys-right"/>
			<br>
			<div id="copyDiv" <c:if test="${tmpRightForm.authTmpAttNocopy == 'true'}">style="display:none"</c:if> > 						
			<html:hidden property="authTmpAttCopyIds" /> <html:textarea
				property="authTmpAttCopyNames" readonly="true"
				style="width:90%;height:90px" styleClass="inputmul" /> 
				<a href="#"
					onclick="Dialog_Address(true, 'authTmpAttCopyIds','authTmpAttCopyNames', ';', ORG_TYPE_ALL|ORG_TYPE_ROLE);">
				<bean:message key="dialog.selectOrg" /> </a>
				<br>
				<bean:message key="right.att.authAttCopys.note" bundle="sys-right"/>
			</div>
			<%} %>
			
			<% if(propertyNameSet.contains("authTmpAttDownloads")){ %>
				<%if(com.landray.kmss.sys.attachment.util.JgWebOffice.isJGPDFEnabled()){%>
				    <bean:message bundle="sys-right" key="right.att.authAttDownloads.pdf" />
				<%}else{ %>
					<bean:message bundle="sys-right" key="right.att.authAttDownloads" />
				<%}%>
			<html:checkbox property="authTmpAttNodownload" value="1" onclick="refreshDisplay(this,'downloadDiv')"/>
						<bean:message key="right.att.authAttNodownload" bundle="sys-right"/>
			<br>
			<div id="downloadDiv" <c:if test="${tmpRightForm.authTmpAttNodownload == 'true'}">style="display:none"</c:if> > 						
			<html:hidden property="authTmpAttDownloadIds" /> <html:textarea
				property="authTmpAttDownloadNames" readonly="true"
				style="width:90%;height:90px" styleClass="inputmul" /> 
				<a href="#"
					onclick="Dialog_Address(true, 'authTmpAttDownloadIds','authTmpAttDownloadNames', ';', ORG_TYPE_ALL|ORG_TYPE_ROLE);">
				<bean:message key="dialog.selectOrg" /> </a>
				<br>
				<bean:message key="right.att.authAttDownloads.note" bundle="sys-right"/>
			</div>
			<%} %>
			
			<% if(propertyNameSet.contains("authTmpAttPrints")){ %>
				<%if(com.landray.kmss.sys.attachment.util.JgWebOffice.isJGPDFEnabled()){%>
				    <bean:message bundle="sys-right" key="right.att.authAttPrints.pdf" />
				<%}else{ %>
					<bean:message bundle="sys-right" key="right.att.authAttPrints" />
				<%}%>
			<html:checkbox property="authTmpAttNoprint" value="1" onclick="refreshDisplay(this,'printDiv')"/>
						<bean:message key="right.att.authAttNoprint" bundle="sys-right"/>
			<br>
			<div id="printDiv" <c:if test="${tmpRightForm.authTmpAttNoprint == 'true'}">style="display:none"</c:if> > 						
			<html:hidden property="authTmpAttPrintIds" /> <html:textarea
				property="authTmpAttPrintNames" readonly="true"
				style="width:90%;height:90px" styleClass="inputmul" /> 
				<a href="#"
					onclick="Dialog_Address(true, 'authTmpAttPrintIds','authTmpAttPrintNames', ';', ORG_TYPE_ALL|ORG_TYPE_ROLE);">
				<bean:message key="dialog.selectOrg" /> </a>
				<br>
				<bean:message key="right.att.authAttPrints.note" bundle="sys-right"/>
			</div>
			<%} %>
			
			</td>
		</tr>	
	<%} %>
			
<script>
function refreshDisplay(obj,divName){
	var divObj = document.getElementById(divName);
	divObj.style.display=(obj.checked?"none":"");
}
</script>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>	
<c:set var="downMethod" value="viewDownload" />
<object classid="clsid:764BFF15-D431-4640-961C-1B98F94F2383" id="AttachmentOCX_${param.fdKey}" codebase="${KMSS_Parameter_ContextPath}sys/attachment/plusin/lksframer.ocx#version=1,0,2,15" 
	<c:if test="${param.fdAttType != 'office'}">
 		width="0" height="0" style="display:none" 		
 	</c:if>
	<c:if test="${param.fdAttType == 'office'}">
		width="100%"
		<c:if test="${param.attHeight!=null}">
			height="${param.attHeight}"
		</c:if>
 		 <c:if test="${param.attHeight==null}">
			height="600"
		</c:if>
 	</c:if>
 > 	
	  <PARAM name="Server" value="<%=request.getServerName()%>">
	  <%if(!request.getScheme().equalsIgnoreCase("https")){%>
	  <PARAM name="Port" value="<%=request.getServerPort()%>">
	  <%} %>
	  <%if(request.getScheme().equalsIgnoreCase("https")){%>
	  <PARAM name="Port" value="<%=request.getServerPort()%>">
	  <PARAM name='security' value='1'>
	  
	  <%} %>
	  <PARAM name="FileInputName" value="formFiles">
	  <PARAM name="OrgId" value="${param.fdModelId}">
	  <PARAM name="OrgId" value="${param.fdModelId}">
	  <PARAM name="AttId" value="${param.fdKey}">
	  <param name="forDomino" value="0">
	  <PARAM name="Encoding" value="<%=request.getCharacterEncoding()%>">
	  <PARAM name="DbPath" value="${KMSS_Parameter_ContextPath}resource/plusin/">
	<c:if test="${param.fdAttType == 'office'}">
		  <c:if test="${not empty param.attachmentId}">
				<c:if test="${param.editMode!=null}">
					<c:if test="${param.canCopy=='1' && param.editMode=='3'}">
						<c:if test="${param.Mode == '' || param.Mode == null}">
							<PARAM name="Mode" value="4">		
						</c:if>		
						<c:if test="${param.Mode != '' && param.Mode != null}">
							<PARAM name="Mode" value="${param.Mode}">		
						</c:if>			
					</c:if>
					<c:if test="${param.canCopy!='1' || param.editMode!='3'}">
						<c:if test="${param.Mode == '' || param.Mode == null}">
							<PARAM name="Mode" value="${param.editMode}"> 
						</c:if>
						<c:if test="${param.Mode != '' && param.Mode != null}">
							<PARAM name="Mode" value="${param.Mode}">		
						</c:if>	
					</c:if>
					<c:if test="${param.editMode=='2'}">
						<c:set var="downMethod" value="editDownload" />
					</c:if>
				</c:if>
				<c:if test="${empty param.editMode}">
					<c:if test="${param.Mode == '' || param.Mode == null}">
						<PARAM name="Mode" value="2">
					</c:if>
					<c:if test="${param.Mode != '' && param.Mode != null}">
							<PARAM name="Mode" value="${param.Mode}">		
						</c:if>	
					<c:set var="downMethod" value="editDownload" />
				</c:if>
				<c:if test="${param.trackRevisions=='1'}">
					<PARAM name="TrackRevisions" value="1"> 
				</c:if>
		  		<PARAM name="ReceiveForm" value="<c:url value="/sys/attachment/sys_att_main/sysAttMain.do?method=update&fdModelId=${param.fdModelId}&fdModelName=${param.fdModelName}&fdKey=${param.fdKey}&fdAttType=${param.fdAttType}&fdId=${param.attachmentId}&s_seq=1"/>">
		  		<PARAM name="FileName" value="${param.fdFileName}">
		  		<PARAM name="FileUrl" value="<c:url value="/sys/attachment/sys_att_main/sysAttMain.do?method=${downMethod}&fdId=${param.attachmentId}&fdFileName=${param.fdFileName}" />">
		</c:if>
		<c:if test="${empty param.attachmentId}">
			<c:if test="${not empty param.templateId}">
				<PARAM name="TemplateUrl" value="<c:url value="/sys/attachment/sys_att_main/sysAttMain.do?method=viewDownload&fdId=${param.templateId}" />">
			</c:if>
			<c:if test="${param.Mode == '' || param.Mode == null}">
				<PARAM name="Mode" value="1">
			</c:if>
			<c:if test="${param.Mode != '' && param.Mode != null}">
				<PARAM name="Mode" value="${param.Mode}">		
			</c:if>	
		</c:if>
		<c:if test="${empty param.fdOfficeType}">
			<PARAM name="FileExt" value="doc">
		</c:if>
		<c:if test="${not empty param.fdOfficeType}">
			<PARAM name="FileExt" value="${param.fdOfficeType}">
		</c:if>
		<c:if test="${not empty param.bookMarks}">
			<c:forTokens var="token" items="${param.bookMarks}" delims="," varStatus="vstatus">
				<PARAM name="Bookmark_${vstatus.index+1}" value="${token}">
			</c:forTokens>
		</c:if>
	</c:if>			
	<c:if test="${param.canPrint=='1'}">
	  		<PARAM name="AllowPrint" value="1">
	  		<PARAM name="AllowPrintPreview" value="1">
	</c:if>
	<c:if test="${param.canPrint!='1'}">
	  	<PARAM name="AllowPrint" value="0">
	  	<PARAM name="AllowPrintPreview" value="0">
	</c:if>	 	
	<PARAM name="UserName" value="<%=com.landray.kmss.util.UserUtil.getKMSSUser(request).getPerson().getFdName()%>">		
	<c:if test="${param.fdAttType != 'office' || param.attachmentId == ''}">
	  <PARAM name="ReceiveForm" value="<c:url value="/sys/attachment/sys_att_main/sysAttMain.do?method=save&fdModelId=${param.fdModelId}&fdModelName=${param.fdModelName}&fdKey=${param.fdKey}&fdAttType=${param.fdAttType}&s_seq=1&width=${param.width}&height=${param.height}&proportion=${param.proportion}"/>">
	</c:if>
	<PARAM name="ShowRevisions" value="${param.showRevisions}">
	<PARAM name="PrintRevisions" value="0">	    
	<PARAM name="Progress" value="1">
	<PARAM name="isThread" value="1">	
</object>	
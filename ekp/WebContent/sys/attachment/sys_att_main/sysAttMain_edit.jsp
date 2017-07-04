<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:choose>
	<c:when test="${ param.fdAttType == 'office'}">
		<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit_ocx.jsp" charEncoding="UTF-8">
			<c:param name="fdKey" value="${ param.fdKey }" />
			<c:param name="fdModelName" value="${ param.fdModelName }" />
			<c:param name="fdModelId" value="${ param.fdModelId }" />
			<c:param name="fdMulti" value="${ param.fdMulti }" />
			<c:param name="fdAttType" value="${ param.fdAttType }" />
			<c:param name="fdViewType" value="${ param.fdViewType }" />
			<c:param name="formBeanName" value="${param.formBeanName }" />	
			
			<c:param name="fdImgHtmlProperty" value="${param.fdImgHtmlProperty }" />
			<c:param name="fdShowMsg" value="${ param.fdShowMsg }" />
			<c:param name="showDefault" value="${ param.showDefault }" />
			<c:param name="buttonDiv" value="${ param.buttonDiv }" />
			<c:param name="fdOfficeType" value="${param.fdOfficeType}" />
			<c:param name="bookMarks" value="${param.bookMarks}" />
			<c:param name="width" value="${param.picWidth}" />
			<c:param name="height" value="${param.picHeight}" />
			<c:param name="proportion" value="${param.proportion}" />
			
			<c:param name="isTemplate" value="${ param.isTemplate }" />
			<c:param name="fdTemplateModelId" value="${param.fdTemplateId}" />
			<c:param name="fdTemplateModelName" value="${param.fdTemplateModelName}" />
			<c:param name="fdTemplateKey" value="${param.fdTemplateKey}" />
			<c:param name="templateBeanName" value="${param.templateBeanName}"/>
			<c:param name="fdSupportLarge" value="${param.fdSupportLarge}"/>
		</c:import>
	</c:when>
	<c:otherwise>
		<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit_swf.jsp" charEncoding="UTF-8">
			<c:param name="fdKey" value="${ param.fdKey }" />
			<c:param name="fdModelName" value="${ param.fdModelName }" />
			<c:param name="fdModelId" value="${ param.fdModelId }" />
			<c:param name="fdMulti" value="${ param.fdMulti }" />
			<c:param name="fdAttType" value="${ param.fdAttType }" />
			<c:param name="fdViewType" value="${ param.fdViewType }" />
			<c:param name="fdRequired" value="${ param.fdRequired }" />
			<c:param name="formBeanName" value="${ param.formBeanName }" />	
			<c:param name="enabledFileType" value="${ param.enabledFileType }" />	
			
			<c:param name="fdImgHtmlProperty" value="${ param.fdImgHtmlProperty }" />
			<c:param name="fdShowMsg" value="${ param.fdShowMsg }" />
			<c:param name="showDefault" value="${ param.showDefault }" />
			<c:param name="buttonDiv" value="${ param.buttonDiv }" />
			<c:param name="fdOfficeType" value="${param.fdOfficeType}" />
			<c:param name="bookMarks" value="${param.bookMarks}" />
			<c:param name="width" value="${param.picWidth}" />
			<c:param name="height" value="${param.picHeight}" />
			<c:param name="proportion" value="${param.proportion}" />
			
			<c:param name="isTemplate" value="${ param.isTemplate }" />
			<c:param name="fdTemplateModelId" value="${param.fdTemplateId}" />
			<c:param name="fdTemplateModelName" value="${param.fdTemplateModelName}" />
			<c:param name="fdTemplateKey" value="${param.fdTemplateKey}" />
			<c:param name="templateBeanName" value="${param.templateBeanName}" />
			<c:param name="fdSupportLarge" value="${param.fdSupportLarge}"/>
			
			<c:param name="extParam" value="${param.extParam}"/>
			<c:param name="fdLayoutType" value="${param.fdLayoutType}" />	
			<c:param name="fdPicContentWidth" value="${param.fdPicContentWidth}" />	
			<c:param name="fdPicContentHeight" value="${param.fdPicContentHeight}" />	
		</c:import>
	</c:otherwise>
</c:choose>

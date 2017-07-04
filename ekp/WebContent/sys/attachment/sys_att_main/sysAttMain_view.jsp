<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.landray.kmss.util.UserUtil"%>
<script>
	if(typeof Com_Parameter.__sysAttMainlocale__ == "undefined")
		Com_Parameter.__sysAttMainlocale__= "<%= UserUtil.getKMSSUser(request).getLocale().toString().toLowerCase().replace('_', '-') %>";
</script>
<c:choose>
	<c:when test="${ param.fdAttType == 'office'}">
		<c:import url="/sys/attachment/sys_att_main/sysAttMain_view_ocx.jsp" charEncoding="UTF-8">
			<c:param name="formBeanName" value="${ param.formBeanName }" />	
			<c:param name="fdModelName" value="${ param.fdModelName }" />
			<c:param name="fdModelId" value="${ param.fdModelId }" />
			<c:param name="fdMulti" value="${ param.fdMulti }" />
			<c:param name="fdAttType" value="${ param.fdAttType }" />
			<c:param name="fdViewType" value="${ param.fdViewType }" />
			<c:param name="fdImgHtmlProperty" value="${ param.fdImgHtmlProperty }" />
			<c:param name="fdShowMsg" value="${ param.fdShowMsg }" />
			<c:param name="showDefault" value="${ param.showDefault }" />
			<c:param name="buttonDiv" value="${ param.buttonDiv }" />
			<c:param name="isTemplate" value="${ param.isTemplate }" />
			<c:param name="fdKey" value="${ param.fdKey }" />
			<c:param name="fdOfficeType" value="${param.fdOfficeType}" />
			<c:param name="bookMarks" value="${param.bookMarks}" />
			<c:param name="width" value="${param.picWidth}" />
			<c:param name="height" value="${param.picHeight}" />
		</c:import>
	</c:when>
	<c:otherwise>
		<c:import url="/sys/attachment/sys_att_main/sysAttMain_view_swf.jsp" charEncoding="UTF-8">
			<c:param name="formBeanName" value="${ param.formBeanName }" />	
			<c:param name="fdModelName" value="${ param.fdModelName }" />
			<c:param name="fdModelId" value="${ param.fdModelId }" />
			<c:param name="fdMulti" value="${ param.fdMulti }" />
			<c:param name="fdAttType" value="${ param.fdAttType }" />
			<c:param name="fdViewType" value="${ param.fdViewType }" />
			<c:param name="fdImgHtmlProperty" value="${ param.fdImgHtmlProperty }" />
			<c:param name="fdForceDisabledOpt" value="${ param.fdForceDisabledOpt }" />
			<c:param name="fdShowMsg" value="${ param.fdShowMsg }" />
			<c:param name="showDefault" value="${ param.showDefault }" />
			<c:param name="buttonDiv" value="${ param.buttonDiv }" />
			<c:param name="isTemplate" value="${ param.isTemplate }" />
			<c:param name="fdKey" value="${ param.fdKey }" />
			<c:param name="fdOfficeType" value="${param.fdOfficeType}" />
			<c:param name="bookMarks" value="${param.bookMarks}" />
			<c:param name="width" value="${param.picWidth}" />
			<c:param name="height" value="${param.picHeight}" />
			<c:param name="fdLayoutType" value="${param.fdLayoutType}" />	
			<c:param name="fdPicContentWidth" value="${param.fdPicContentWidth}" />	
			<c:param name="fdPicContentHeight" value="${param.fdPicContentHeight}" />	
		</c:import>
	</c:otherwise>
</c:choose>

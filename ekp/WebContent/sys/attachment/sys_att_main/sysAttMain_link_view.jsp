<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp" charEncoding="UTF-8">
	<c:param name="viewType" value="link" />
	<c:param name="formBeanName" value="${ param.formBeanName }" />	
	<c:param name="fdModelName" value="${ param.fdModelName }" />
	<c:param name="fdModelId" value="${ param.fdModelId }" />
	<c:param name="fdMulti" value="${ param.fdMulti }" />
	<c:param name="fdAttType" value="${ param.fdAttType }" />
	<c:param name="fdImgHtmlProperty" value="${ param.fdImgHtmlProperty }" />
	<c:param name="fdShowMsg" value="${ param.fdShowMsg }" />
	<c:param name="showDefault" value="${ param.showDefault }" />
	<c:param name="buttonDiv" value="${ param.buttonDiv }" />
	<c:param name="isTemplate" value="${ param.isTemplate }" />
	<c:param name="fdKey" value="${ param.fdKey }" />
</c:import>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:choose>
	<c:when test="${param.isShowImg}">
		<c:import url="/sys/attachment/sys_att_main/jg/sysAttMain_view_image.jsp" charEncoding="UTF-8">
			<c:param name="fdKey" value="${param.fdKey}" />
				<c:param name="fdAttType" value="${param.fdAttType}"/>
				<c:param name="fdModelId" value="${param.fdModelId}"/>
				<c:param name="fdModelName"
					value="${param.fdModelName}"/>
				<c:param name="formBeanName" value="${param.formBeanName}" />
		</c:import>
	</c:when>
	<c:otherwise>
		<c:import url="/sys/attachment/sys_att_main/jg/sysAttMain_view.jsp" charEncoding="UTF-8">
			<c:param name="fdKey" value="${param.fdKey}" />
				<c:param name="fdAttType" value="${param.fdAttType}"/>
				<c:param name="fdModelId" value="${param.fdModelId}"/>
				<c:param name="fdModelName"
					value="${param.fdModelName}"/>
				<c:param name="formBeanName" value="${param.formBeanName}"/>
		</c:import>
	</c:otherwise>
</c:choose>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<c:import url="/sys/attachment/mobile/import/view.jsp" charEncoding="UTF-8">
	<%-- fdKey要改成参数配进来 --%>
	<c:param name="fdKey" value="attachment"/>
	<c:param name="formName" value="${formBeanName }"/>
	<c:param name="fdViewType" value="simple"/>
</c:import>
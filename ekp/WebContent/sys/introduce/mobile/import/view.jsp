<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<c:set var="sysIntroduceForm" value="${requestScope[param.formName]}" />
<c:if test="${sysIntroduceForm.introduceForm.fdIsShow=='true'}">
	<c:set var="_intr_count" value="" />
	<c:if
		test="${sysIntroduceForm.introduceForm.fdIntroduceCount!=null && sysIntroduceForm.introduceForm.fdIntroduceCount!=''}">
		<c:set var="_intr_count"
			value="${sysIntroduceForm.introduceForm.fdIntroduceCount}" />
		<c:set var="_intr_count" value="${fn:replace(_intr_count,'(','')}" />
		<c:set var="_intr_count" value="${fn:replace(_intr_count,')','')}" />
	</c:if>
	<li data-dojo-type="mui/tabbar/TabBarButton"
		data-dojo-props='icon1:"mui mui-intr",align:"${param.align}",
			badge:"${_intr_count}",href:"/sys/introduce/mobile/index.jsp?modelName=${sysIntroduceForm.modelClass.name}&modelId=${sysIntroduceForm.fdId}&fdKey=${param.fdKey }"'>
	</li>
</c:if>

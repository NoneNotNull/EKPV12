<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.person.service.plugin.*" %>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="person.home">
	<template:replace name="content">
		<iframe id="mainIframe" style="width: 100%;border: 0px;height:800px;" src="${param.url }"></iframe>
		<script>
		domain.register('fireEvent', function(evt) {
			$('#mainIframe').height(evt.data.height);
		});
		</script>
	</template:replace>
</template:include>
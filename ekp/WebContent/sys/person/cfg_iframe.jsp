<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.person.service.plugin.*" %>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="person.cfg">
	<template:replace name="content">
		<iframe id="mainIframe" style="width: 100%;border: 0px;height:100%;" src="${empty cfg_url ? param.url : cfg_url }" frameborder="no" border="0" marginwidth="0" marginheight="0" scrolling="no" allowtransparency="yes"></iframe>
		<script>Com_IncludeFile('domain.js');</script>
		<script>
		domain.register('fireEvent', function(evt) {
			$('#mainIframe').height(evt.data.height);
		});
		</script>
	</template:replace>
</template:include>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp" %>
<template:include file="/sys/ui/help/varkind/varkind-help.jsp">
	<template:replace name="detail">
		<pre>
{"js":"对话框代码"}
对dialog.js中的函数调用，如：
Dialog_Address(false, '!{idField}', '!{nameField}', null, ORG_TYPE_ORGORDEPT);
</pre>
	</template:replace>
</template:include>

<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp" %>
<template:include file="/sys/ui/help/varkind/varkind-help.jsp">
	<template:replace name="detail">
		<pre>
参数格式：
{
	"max":100,
	"min":0,
	"help":"数值变量传值"
}
</pre>
	</template:replace>
</template:include>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp" %>
<template:include file="/sys/ui/help/varkind/varkind-help.jsp">
	<template:replace name="detail">
		<pre>
参数格式：
{
	"values":[{
		"text":"{messageKey}",
		"value":"1"
	}],
	"showType":"select/radio/checkbox",
	"help":"枚举变量传值，多值选择将以;分隔"
}
</pre>
	</template:replace>
</template:include>
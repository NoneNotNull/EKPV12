<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp" %>
<template:include file="/sys/ui/help/varkind/varkind-help.jsp">
	<template:replace name="detail">
		<pre>
{"model":"模板的modelName"}
全局分类有可能选择了类别，也有可能选择了模板，因此该变量的返回值有点特殊，格式为：“类型:ID”，如：
“CATEGORY:131e5eb728e687761d255ff4ee8bdf72”表示选择了分类
“TEMPLATE:13ab9ffcf3bb0f5886c0bdc41399b93f”表示选择了模板

</pre>
	</template:replace>
</template:include>

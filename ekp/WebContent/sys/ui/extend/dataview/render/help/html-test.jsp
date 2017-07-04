<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
下面是获取简单列表的样例数据：
<ui:dataview format="sys.ui.classic">
	<ui:source type="AjaxJson">
		{"url":"/sys/ui/extend/dataview/format/classic-example.jsp"}
	</ui:source>
</ui:dataview>
<%@page
	import="com.landray.kmss.sys.property.mobile.builder.MobileOuterFilterBuilder"%>
<%@page import="com.landray.kmss.util.SpringBeanUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<div data-dojo-type="mui/header/Header"
	data-dojo-props="height:'3.8rem'">
	<div data-dojo-type="mui/header/HeaderItem"
		data-dojo-mixins="mui/folder/_Folder,mui/property/PropertyFilterCancel"
		data-dojo-props="label:'取消'"></div>
</div>

<div data-dojo-type="mui/view/DocScrollableView" class="gray"
	data-dojo-mixins="mui/property/PropertyFilterValuesMixin">

	<%
		MobileOuterFilterBuilder builder = (MobileOuterFilterBuilder) SpringBeanUtil
				.getBean("mobileOuterFilterBuilder");
		String fdCategoryId = request.getParameter("fdCategoryId");
		String modelName = request.getParameter("modelName");
		out.print(builder.build(fdCategoryId, modelName));
	%>
</div>

<div data-dojo-type="mui/header/Header"
	data-dojo-props="height:'3.8rem'" fixed="bottom">
	<div data-dojo-type="mui/header/HeaderItem"
		data-dojo-mixins="mui/folder/_Folder,mui/property/PropertyFilterOk"
		data-dojo-props="label:'确定',listId:'{referListId}'"></div>
</div>



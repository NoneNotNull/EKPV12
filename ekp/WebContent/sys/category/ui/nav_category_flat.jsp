<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="java.util.Map"%>
<%
	Object _varParams = request.getAttribute("varParams");
	if (_varParams != null) {
		Map<String, Object> varParams = (Map) _varParams;
		Object _href = varParams.get("href");
		if (_href != null) {
			String urlParam = "categoryId=!{value}&nodeType=!{nodeType}";
			String href = String.valueOf(_href);
			if (href.indexOf('?') > 0) {
				href += "&" + urlParam;
			} else {
				href += "?" + urlParam;
			}
			pageContext.setAttribute("href", href);
		}
	}
%>

	<c:if
		test="${empty varParams.categoryId}">
		<ui:dataview>
			<ui:source type="AjaxJson">
				{"url":"/sys/category/criteria/sysCategoryCriteria.do?method=index&modelName=${varParams.modelName }&parentId=!{value}&showTemp=${ varParams.showTemp}&expand=true"}
			</ui:source>
			<ui:render ref="sys.ui.cate.default" var-href="${href }" var-target="${empty varParams.target ? '_self' : varParams.target}">
			</ui:render>
		</ui:dataview>
	</c:if>
	<c:if test="${not empty varParams.categoryId }">
		<ui:menu layout="sys.ui.menu.ver.cate.slide">
			<ui:menu-source href="${href }" target="${empty varParams.target ? '_self' : varParams.target}" cfg-currId="${varParams.categoryId}">
				<ui:source type="AjaxJson">
					{"url":"/sys/category/criteria/sysCategoryCriteria.do?method=index&modelName=${varParams.modelName }&__currId=${varParams.categoryId}&currId=!{currId}&parentId=!{value}&showTemp=${varParams.showTemp}&expand=true"} 
				</ui:source>
			</ui:menu-source>
		</ui:menu>
	</c:if>

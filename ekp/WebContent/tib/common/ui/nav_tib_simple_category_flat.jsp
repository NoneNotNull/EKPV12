<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="java.util.Map"%>
<%
	Object _varParams = request.getAttribute("varParams");
	if (_varParams != null) {
		Map<String, Object> varParams = (Map) _varParams;
		Object _href = varParams.get("href");
		if (_href != null) {
			String urlParam = "categoryId=!{value}";
			String href = String.valueOf(_href);
			/*if (href.indexOf('?') > 0) {
				href += "&" + urlParam;
			} else {
				href += "?" + urlParam;
			}*/
			request.setAttribute("href", href);
		}
	}
%>
<c:if test="${varParams.categoryId!= null}">
	<ui:dataview>
		<ui:source type="AjaxJson">
			{"url":"/sys/simplecategory/criteria/sysSimpleCategoryCriteria.do?method=index&modelName=${varParams.modelName }&parentId=!{value}&expand=true${extProps}"}
		</ui:source>
		<ui:render ref="sys.ui.cate.default" var-href="${href }" var-target="${empty varParams.target ? '_self' : varParams.target}">
		</ui:render>
	</ui:dataview>
</c:if>
<ui:menu layout="sys.ui.menu.ver.default">
	<ui:menu-source href="${href }" target="${empty varParams.target ? '_self' : varParams.target}">
		<ui:source type="AjaxJson">
			{"url":"/sys/simplecategory/criteria/sysSimpleCategoryCriteria.do?method=cate&modelName=${varParams.modelName }&currId=${varParams.categoryId}&parentId=!{value}&expand="} 
		</ui:source>
	</ui:menu-source>
</ui:menu>
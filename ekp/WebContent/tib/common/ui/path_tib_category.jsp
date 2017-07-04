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
			/*if (href.indexOf('?') > 0) {
				href += "&" + urlParam;
			} else {
				href += "?" + urlParam;
			}*/
			request.setAttribute("href", href);
		}
	}
%>
<c:set var="path_hrefDisable" value="false"/>
<xform:editShow>
	<c:set var="path_hrefDisable" value="true"/>
</xform:editShow>
<c:choose>
	<c:when test="${ path_hrefDisable == true }">
		<ui:menu layout="sys.ui.menu.nav" id="${varParams.id }">
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home">
			</ui:menu-item>
			<ui:menu-item text="${varParams.moduleTitle }">
			</ui:menu-item>
			<ui:menu-source autoFetch="${empty varParams.autoFetch ? 'true' : varParams.autoFetch}">
				<ui:source type="AjaxJson">
					{"url":"/sys/category/criteria/sysCategoryCriteria.do?method=path&modelName=${varParams.modelName }&categoryId=${varParams.categoryId}&currId=!{value}&nodeType=!{nodeType}&showTemp=${ varParams.showTemp}"} 
				</ui:source>
			</ui:menu-source>
		</ui:menu>
	</c:when>
	<c:otherwise>
		<ui:menu layout="sys.ui.menu.nav" id="${varParams.id }">
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home" href="/" target="${empty varParams.target ? '_self' : varParams.target}">
			</ui:menu-item>
			<ui:menu-item text="${varParams.subHome}" href="javascript:void(0);" target="${empty varParams.target ? '_self' : varParams.target}">
			</ui:menu-item>
			<ui:menu-item text="${varParams.moduleTitle }" href="${varParams.href }" target="${empty varParams.target ? '_self' : varParams.target}">
			</ui:menu-item>
			<ui:menu-source autoFetch="false" 
					target="${empty varParams.target ? '_self' : varParams.target}" 
					href="${href }">
				<ui:source type="AjaxJson">
					{"url":"/sys/category/criteria/sysCategoryCriteria.do?method=path&modelName=${varParams.modelName }&categoryId=${varParams.categoryId}&currId=!{value}&nodeType=!{nodeType}&showTemp=${ varParams.showTemp}"} 
				</ui:source>
			</ui:menu-source>
		</ui:menu>
	</c:otherwise>
</c:choose>

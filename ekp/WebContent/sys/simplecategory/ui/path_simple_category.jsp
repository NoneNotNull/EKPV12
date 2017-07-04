<%@page import="com.landray.kmss.util.StringUtil"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="java.util.Map"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.util.Iterator"%>
<%@page import="net.sf.json.JSONArray"%>
<%
	Object _varParams = request.getAttribute("varParams");
	if (_varParams != null) {
		Map<String, Object> varParams = (Map) _varParams;
		Object _href = varParams.get("href");
		if (_href != null) {
			String urlParam = "categoryId=!{value}";
			String href = String.valueOf(_href);
			if (href.indexOf('?') > 0) {
				href += "&" + urlParam;
			} else {
				href += "?" + urlParam;
			}
			request.setAttribute("href", href);
		}
		// 扩展查询字段
		Object extProps = varParams.get("extProps");
		if (extProps != null) {
			JSONObject ___obj = JSONObject.fromObject(extProps);
			Iterator it = ___obj.keys();
			JSONArray array = new JSONArray();
			while (it.hasNext()) {
				Object key = it.next();
				array.add(("qq." + key + "=" + ___obj.getString(key
						.toString())).toString());
			}
			String ___extProps = StringUtil.join(array, "&");
			request.setAttribute("extProps", "&" + ___extProps);
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
					{"url":"/sys/simplecategory/criteria/sysSimpleCategoryCriteria.do?method=path&modelName=${varParams.modelName }&categoryId=${varParams.categoryId}&currId=!{value}"} 
				</ui:source>
			</ui:menu-source>
		</ui:menu>
	</c:when>
	<c:otherwise>
		<ui:menu layout="sys.ui.menu.nav" id="${varParams.id }">
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home" href="/" target="${empty varParams.target ? '_self' : varParams.target}">
			</ui:menu-item>
			<ui:menu-item text="${varParams.moduleTitle }" href="${varParams.href }" target="${empty varParams.target ? '_self' : varParams.target}">
			</ui:menu-item>
			<ui:menu-source autoFetch="${empty varParams.autoFetch ? 'true' : varParams.autoFetch}" 
					target="${empty varParams.target ? '_self' : varParams.target}" 
					href="${href}">
				<ui:source type="AjaxJson">
					{"url":"/sys/simplecategory/criteria/sysSimpleCategoryCriteria.do?method=path&modelName=${varParams.modelName }&categoryId=${varParams.categoryId}&currId=!{value}${extProps }"} 
				</ui:source>
			</ui:menu-source>
		</ui:menu>
	</c:otherwise>
</c:choose>

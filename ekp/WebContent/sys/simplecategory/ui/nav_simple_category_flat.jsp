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
			pageContext.setAttribute("href", href);
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
			pageContext.setAttribute("extProps", "&" + ___extProps);
		}
	}
%>
<c:if
	test="${empty varParams.categoryId}">
	<ui:dataview>
		<ui:source type="AjaxJson">
			{"url":"/sys/simplecategory/criteria/sysSimpleCategoryCriteria.do?method=index&modelName=${varParams.modelName }&parentId=!{value}&expand=true${extProps}"}
		</ui:source>
		<ui:render ref="sys.ui.cate.default" var-href="${href }" var-target="${empty varParams.target ? '_self' : varParams.target}">
		</ui:render>
	</ui:dataview>
</c:if>

<c:if test="${not empty varParams.categoryId }">
	<ui:menu layout="sys.ui.menu.ver.cate.slide">
		<ui:menu-source href="${href }"
			target="${empty varParams.target ? '_self' : varParams.target}"
			cfg-currId="${varParams.categoryId}">
			<ui:source type="AjaxJson">
				{"url":"/sys/simplecategory/criteria/sysSimpleCategoryCriteria.do?method=index&modelName=${varParams.modelName }&__currId=${varParams.categoryId}&currId=!{currId}&parentId=!{value}&expand=true${extProps}"} 
			</ui:source>
		</ui:menu-source>
	</ui:menu>
</c:if>

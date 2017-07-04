<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="java.util.Map"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<ui:ajaxtext>
<%
	Object url = request.getParameter("url");
	if (url != null) {
		String urlParam = "categoryId=!{value}";
		String href = String.valueOf(url);
		if (href.indexOf('?') > 0) {
			href += "&" + urlParam;
		} else {
			href += "?" + urlParam;
		}
		request.setAttribute("href", href);
	}
	// 扩展查询字段
	Object extProps = request.getParameter("extProps");
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
%>
<c:if test="${param.categoryId!= ''}">
	<ui:dataview>
		<ui:source type="AjaxJson">
			{"url":"/sys/simplecategory/criteria/sysSimpleCategoryCriteria.do?method=currentCate&modelName=${param.modelName }&currId=${param.categoryId}"}
		</ui:source>
		<ui:render type="Template">
			{$
				<div class="lui_list_nav_curPath_frame">
					<div class="lui_icon_s lui_icon_s_icon_position"></div>
					<div class="lui_list_nav_curPath">{% env.fn.formatText(data[0].text)%}</div>
				</div>
			$}
		</ui:render>
	</ui:dataview>
</c:if>
<ui:menu layout="sys.ui.menu.ver.default">
	<ui:menu-source  href="${href }" target="${empty param.target ? '_self' : param.target}">
		<ui:source type="AjaxJson">
			{"url":"/sys/simplecategory/criteria/sysSimpleCategoryCriteria.do?method=index2&modelName=${param.modelName }&currId=${param.categoryId}&parentId=!{value}&expand=${extProps}"} 
		</ui:source>
	</ui:menu-source>
</ui:menu>
</ui:ajaxtext>
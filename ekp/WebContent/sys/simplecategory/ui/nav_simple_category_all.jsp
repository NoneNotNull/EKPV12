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
			pageContext.setAttribute("extProps", "&" + ___extProps);
		}
	}
%>

<div class="lui_list_cate_all" data-lui-switch-class="lui_list_cate_toggle_up">
	<div class="lui_list_cate_all_content">
		<div class="lui_list_cate_all_txt">${lfn:message('sys-simplecategory:sysSimpleCategory.title.allcate') }</div>
		<div class="lui_list_cate_toggle">
		</div>
	</div>
	
	<ui:popup borderWidth="1" align="down-left" style="background:white;" >
		<ui:dataview>
			<ui:source type="AjaxJson">
				{"url":"/sys/simplecategory/criteria/sysSimpleCategoryCriteria.do?method=index&modelName=${varParams.modelName }&parentId=!{value}&expand=true${extProps}"}
			</ui:source>
			<ui:render ref="sys.ui.cate.default" var-href="${href }" var-target="${empty varParams.target ? '_self' : varParams.target}">
			</ui:render>
		</ui:dataview>
		<ui:event event="show">
			this.element.css('width',this.positionObject.width());
		</ui:event>
	</ui:popup>
</div>
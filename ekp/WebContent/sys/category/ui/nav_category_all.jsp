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
			Object _extHash = varParams.get("extHash");
			if (_extHash != null) {
				String extHash = String.valueOf(_extHash);
				href += "#" + extHash;
			}
			pageContext.setAttribute("href", href);
		}
	}
%>

<div class="lui_list_cate_all" data-lui-switch-class="lui_list_cate_toggle_up">
	<div class="lui_list_cate_all_content">
		<div class="lui_list_cate_all_txt">${lfn:message('sys-category:sysCategoryMain.title.allcate') }</div>
		<div class="lui_list_cate_toggle">
		</div>
	</div>
	
	<ui:popup borderWidth="1" align="down-left" style="background:white;" >
		<ui:dataview>
			<ui:source type="AjaxJson">
				{"url":"/sys/category/criteria/sysCategoryCriteria.do?method=index&modelName=${varParams.modelName }&currId=${varParams.categoryId}&parentId=!{value}&expand=true&showTemp=${ varParams.showTemp}"}
			</ui:source>
			<ui:render ref="sys.ui.cate.default" var-href="${href }" var-target="${empty varParams.target ? '_self' : varParams.target}">
			</ui:render>
		</ui:dataview>
		<ui:event event="show">
			this.element.css('width',this.positionObject.width());
		</ui:event>
	</ui:popup>
</div>




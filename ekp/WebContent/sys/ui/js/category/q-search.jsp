<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
{$
	<div class="lui_category_search_box">
		<input type="text" placeholder="${lfn:message('sys-ui:ui.category.keyword')}" data-lui-mark="search.input"/>
		<a href="javascript:;" data-lui-mark="search.btn">${lfn:message('sys-ui:ui.category.quick.search')}</a>
	</div>
$}

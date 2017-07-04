<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
{$
	<div class="lui_category_gcategory_select_box">$}
		{$<select class="lui_category_gcategory_select_favorite">$}
		{$<option value="">${lfn:message('sys-ui:ui.category.gcategory.msg') }</option>$}
		for (var i = 0; i < data.length; i ++) {
			{$<option value="{%data[i].value%}">{%data[i].text%}</option>$}
		}
		{$</select>$}
		{$<label>
			<a href="javascript:;" class="lui_category_gcategory_add_favorite">${lfn:message('sys-ui:ui.category.gcategory.add') }</a>
		</label>$}
	{$</div>
$}

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
{$
<table class="selected_table" style="width: 100%;" border="0">
	<col width="50">
	<col width="*">
	<col width="50">
	<tr>
		<td style="font-weight: bolder;color: #7A5B00;">${ lfn:message('sys-ui:portlet.page.selected') }：</td>
		<td class="selected_values"> $}
		if (data == null || data.length == 0) {
			{$${ lfn:message('sys-ui:portlet.page.notselected') }$}
		}
		if (data != null) {
			for (var i = 0, ln = data.length; i < ln; i ++) {
				{$<a href='javascript:;' data-id="{%data[i].id%}" class="com_btn_link" style='color:#F19703;margin-right:5px;'>{%data[i].name%}</a>$}
			}
		}
		{$ </td>
		<td><a href="javascript:;" class="com_btn_link selected_removeall">${ lfn:message('sys-ui:portlet.page.clear') }</a></td>
	</tr>
</table>
$}
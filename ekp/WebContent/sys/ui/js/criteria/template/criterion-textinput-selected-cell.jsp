<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
{$
	<li>
		<span class="criteria-input-text">
			<input type="text" name="{%data[0].name%}" data-lui-date-input-name="{%data[0].name%}"
				 placeholder="{%data[0].placeholder%}">
			<input type="button" class="criteria-input-cancel" title="${lfn:message('sys-ui:ui.search.cancel') }" style="display: none;">	 
			<input type="button" class="criteria-input-ok" title="${lfn:message('sys-ui:ui.search.doit') }">
		</span>
	</li>
$}

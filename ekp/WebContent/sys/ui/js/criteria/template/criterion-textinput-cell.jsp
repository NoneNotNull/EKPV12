<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
{$
	<li>
		<span class="criteria-input-text">
			<input type="text" name="{%data[0].name%}" data-lui-date-input-name="{%data[0].name%}"
				 placeholder="{%data[0].placeholder%}">
		</span>
		<input type="button" class="commit-action" value="${lfn:message('button.ok')}" />
	</li>
$}

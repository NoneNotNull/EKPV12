<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
{$
	<div class="criterion-title">${lfn:message('sys-ui:ui.criteria.selectedCondition')}:</div>
	<div class="criterion-value">
		<ul class="criterion-expand">
			<li class="criterion-other">
			</li>
			<li class="commit-action" style="display:none" title="${lfn:message('button.ok')}">
				<a href="javascript:;">${lfn:message('button.ok')}</a>
			</li>
		</ul>
		
		<div class="criterion-options">
			<a href="javascript:;" class="multi-option" title="${lfn:message('sys-ui:ui.criteria.multi') }">${lfn:message('sys-ui:ui.criteria.multi') }</a>
		</div>
	</div>
$}
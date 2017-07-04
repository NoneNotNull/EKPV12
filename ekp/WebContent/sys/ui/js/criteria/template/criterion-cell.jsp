<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

var isRequired = render.parent.isRequired();
if (!isRequired) {
{$
<li class="criterion-all">
	<a href="javascript:;" title="${lfn:message('sys-ui:ui.criteria.all')}" class="selected"><span class="text">${lfn:message('sys-ui:ui.criteria.all')}</span></a>
</li>
$}
}
for (var i = 0, ln = data.length; i < ln; i ++) {
{$
<li><a href="javascript:;" title="{%data[i].text%}" 
	data-lui-val="{%data[i].value%}"><i class="checkbox"></i><span class="text">{%data[i].text%}</span></a></li>
$}
}
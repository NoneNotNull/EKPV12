<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
{$ <ul class="lui-filter-items"> $}
	for(var i=0;i<data.length;i++){
	{$
		<li>
			<span class="lui-filter-item-subject textEllipsis" data-lui-id="{%data[i]['value']%}">{%data[i]['name']%}</span>
			<div class="lui-tip">
				<em></em>
				<span></span>
			</div>
		</li>		
	$}	
	}
{$ </ul> $}
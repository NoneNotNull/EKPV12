<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
var paging = layout.parent;
	{$<div class="lui_zone_similar_tags">
		<a href="javascript:void(0);"
	$}
	if (paging.hasPre) {
		{$
		   title="${page.thePrev}"	class="up" data-lui-paging-num="{% paging.currentPage-1 %}"
		$}
	}else{
		{$ class="noneup"$}
	}
	{$></a><a  href="javascript:void(0);"$}
	if (paging.hasNext) {
		{$
			title="${lfn:message('page.theNext')}" class="down" data-lui-paging-num="{% paging.currentPage+1 %}"
		$}
	}else{
		{$ class="nonedown"$}
	}
	{$></a>
	<input type="hidden" data-lui-mark="paging.pageno" value="{%paging.currentPage%}"/>
	<input type="hidden" data-lui-mark="paging.amount" value="{%paging.pageSize%}"/>
	<input type="hidden"  value="{%paging.totalPage%}"/>
	</div>
	$}

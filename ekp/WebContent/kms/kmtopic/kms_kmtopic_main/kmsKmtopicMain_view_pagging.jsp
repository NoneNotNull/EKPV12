<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>

<%-- 列表分页 --%>
	var paging = layout.parent;
	{$
	<span class="page_set">{%paging.currentPage%}/{%paging.totalPage%}</span>
	$}
    if (paging.hasPre) {
		{$
		<i class="btn_pre" data-lui-paging-num="{% paging.currentPage-1 %}"></i>
		$}
	}else if(!paging.hasPre && paging.hasNext){
		{$
		<i class="btn_preno"></i>
		$}
	}
	
	if (paging.hasNext) {
		{$
		<i class="btn_next" data-lui-paging-num="{% paging.currentPage+1 %}"></i>
		$}
	}else if(!paging.hasNext && paging.hasPre){
		{$
		<i class="btn_nextno"></i>
		$}
	}
	
	{$
                 <input type="hidden" data-lui-mark="paging.pageno" value="{%paging.currentPage%}" />
                 <input type="hidden" data-lui-mark="paging.amount" value="{%paging.pageSize%}"/>
	$}

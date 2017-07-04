<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
var parent = component.parent;
var fdName = '所有分类';
var fdId = '';
if(parent){
	if(parent.parentName)
		fdName = parent.parentName;
	if(parent.parentId)
		fdId = parent.parentId;
}

{$<header class="lui-header lui-category-header">
		<ul class="clearfloat">
			<li style="float: left;padding-left: 10px;">
				<a class="lui-icon-s lui-back-icon">
				</a>
			</li>
			<li class="lui-docSubject">
				<h2 class="textEllipsis">{% fdName %}</h2>
			</li>
			<li data-category-type="doc" style="float: right;padding-right: 15px;">
				<a class="lui-icon-s lui-doc-icon" data-category-type="doc">
				</a>
			</li>
		</ul>
</header>$}
{$ <ul class="lui-category"> $}
if(data.list) {
	var cates = data.list;
	for(var i=0;i<cates.length;i++){
	{$
		<li>
			<span class="lui-category-subject textEllipsis" data-lui-id="{%cates[i]['value']%}">{%cates[i]['text']%}</span>
			<div class="lui-tip">
				<em></em>
				<span></span>
			</div>
		</li>		
	$}	
	}
}
{$ </ul> $}
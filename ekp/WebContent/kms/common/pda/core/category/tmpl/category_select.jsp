<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
var parent = component.parent;
var fdName = '所有分类';
var fdId = '';
var hasOk = true;

if(parent){
	if(parent.parentName)
		fdName = parent.parentName;
	if(parent.parentId)
		fdId = parent.parentId;
	if(!parent.parent || parent.disable=='true')
		hasOk = false;
}

<% %>
var href = '${param.href}';
href = Pda.Util.variableResolver(href,{categoryId:fdId});
{$<header class="lui-header lui-category-header" style="left: 0;">
		<ul class="clearfloat">
			<li style="float: left;padding-left: 10px;">
$}
				if(parent.parent) {
{$
					<a class="lui-icon-s lui-back-icon">
					</a>
$}
				}
{$			</li>
			<li class="lui-docSubject" style="right: 60px">
				<h2 class="textEllipsis">{% fdName %}</h2>
			</li>
$}
		if(hasOk){
			{$<li data-category-type="ok" style="float: right;padding-right: 15px;">
				<a class="lui-category-submit-btn" data-category-type="ok">
					确定
				</a>
			</li>$}
		}			
{$			
		</ul>
</header>$}
{$ <ul class="lui-category"> $}
if(data.list) {
	var cates = data.list;
	for(var i=0;i<cates.length;i++){
	{$
		<li>
			<span class="lui-category-subject textEllipsis" data-lui-id="{%cates[i]['value']%}" data-lui-disable="{%cates[i]['nodeType']%}">{%cates[i]['text']%}</span>
			<div class="lui-tip">
				<em></em>
				<span></span>
			</div>
		</li>		
	$}	
	}
}
{$ </ul> $}
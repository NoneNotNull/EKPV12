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
fdName+='-筛选';
{$<header class="lui-header lui-category-header">
		<ul class="clearfloat">
			<li class="lui-back">
				<a class="lui-icon-s lui-back-icon">
				</a>
			</li>
			<li class="lui-docSubject">
				<h2 class="textEllipsis">{% fdName %}</h2>
			</li>
			<li style="float: right;padding-right: 15px;">
				<a class="lui-category-submit-btn">
					确定
				</a>
			</li>
		</ul>
</header>$}
{$ <ul class="lui-filter"> $}
	var filters = data['filters'];
	if(!filters)
		return;
	for(var i=0;i<filters.length;i++){
	{$
		<li>
			<span class="lui-filter-subject textEllipsis" data-lui-id="{%filters[i]['settingId']%}">{%filters[i]['title']%}</span>
			<span class="lui-filter-item">
				不限
			</span>
		</li>		
	$}	
	}
{$ </ul> $}
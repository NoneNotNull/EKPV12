<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 当前路径 -->
<script type="text/template" id="portlet_ask_path_tmpl">
{$
	<a title="首页" class="home" href="${kmsBasePath }/common/kms_common_main/kmsCommonMain.do?method=module">首页</a>&gt;
	<a title="爱问" href="${kmsBasePath }/ask/kms_ask_topic/kmsAskTopic.do?method=indexList&fdId=${param.fdId}">爱问</a>
$}
for(i=0;i<data.sPath.length;i++){
	if(i==data.sPath.length-1){
{$
		&gt;<span>{%data.sPath[i].fdName%}</span>
$}
	}else{
{$
		&gt;<a title="{%data.sPath[i].fdName%}" href="{%data.sPath[i].fdUrl+'&fdId=${param.fdId}'%}">{%data.sPath[i].fdName%}</a>
$}
	}
}
</script>

<!--爱问达人 -->
<script type="text/template" id="portlet_ask_per_tmpl">
{$
	<div class="title1"><h2>{%parameters.kms.title%}</h2></div>
	<div class="box2">
	<ul class="l_g c">
$}
for(i=0;i<data.perOfAsks.length;i++){
{$
	<li>
		<a title="" class="img_a" href="{%data.perOfAsks[i].fdUrl%}"><img alt="" src="{%data.perOfAsks[i].imgUrl%}" onload="javascript:drawImage(this,this.parentNode)"/></a>
		<ul class="l_h">
			<li><strong>知识达人：</strong><span class="b">{%data.perOfAsks[i].fdName%}</span></li>
			<li><strong>精通领域：</strong>{%resetStrLength(data.perOfAsks[i].categoryName||'',10)%}</li>
			<li><strong>本月回答数：</strong><span>{%data.perOfAsks[i].num%}</span></li>
$}
			if(data.perOfAsks[i].flag){
{$
				<li><div class="btn_d"><a href="javascript:void(0)" title="向他提问" onclick="askToExpert('{%data.perOfAsks[i].fdExpertId%}')"><span>向他提问</span></a></div></li>
$}
			}
{$
		</ul>
	</li>
$}
}
{$
	</ul></div>
$}
</script>

<!-- 列表tab标签 -->
<script id="portlet_ask_list_nav_tmpl" type="text/template">
	{$ <div class="title4 tabview"><ul id="tags" class="c tab_ul"> $} 
		for(i=0;i<tabs.length;i++){
			{$ <li><a href="javascript:KMS_TAB_PORTLET_CHANGE('{%parameters.kms.id%}','{%tabs[i].kms.id%}')">{%tabs[i].kms.title%}</a></li> $} 
		}
	{$ </ul> 
	<div class="btns_box">
		<kmss:auth requestURL="/kms/ask/kms_ask_topic/kmsAskTopic.do?method=add" requestMethod="GET">
			<div class="btn_a"><a title="<bean:message key="button.add"/>" href="javascript:void(0)" id="addButton"><span><bean:message key="button.add"/></span></a></div>
		</kmss:auth>
		<kmss:auth requestURL="/kms/ask/kms_ask_topic/kmsAskTopic.do?method=deleteall" requestMethod="GET">
			<div class="btn_a"><a title="<bean:message key="button.delete"/>" href="javascript:void(0)" id="delButton" ><span><bean:message key="button.delete"/></span></a></div>
		</kmss:auth>
	</div>
	</div>
$}
</script>

<!-- 爱问列表 -->
<script type="text/template" id="portlet_ask_list_tmpl">
var itemList = data.itemList;
{$
<div class="km_list2">
<table width="100%" cellspacing="0" cellpadding="0" border="0" class="t_g m_t10" id="{%parameters.kms.id%}-tbObj">
	<thead class="t_g_a">
		<tr class="tal">
			<th width="5%"><input type="checkbox" id="{%parameters.kms.id%}-listcheck"></th>
			<th width="5%">NO.</th>
			<th width="10%">悬赏币</th>
			<th width="30%">标题</th>
			<th width="10%">回复数</th>
			<th width="10%">状态</th>
			<th class="t_g_b" width="20%">提问时间</th>
		</tr>
	</thead>
	<tbody>
$}
	for(j=0;j<itemList.length;j++){
{$
		<tr 
$}
			if(j%2!=0){{$ class="t_g_c" $}}{$>
			<td><input type="checkbox" name="List_Selected" value="{%itemList[j].fdId%}"></td>
			<td>{%j+1%}</td>
			<td><span class="score">{%itemList[j].fdScore%}</span></td>
			<td class="tal">
				<a href="<c:url value="/kms/ask/kms_ask_topic/kmsAskTopic.do?method=view&fdId=" />{%itemList[j].fdId%}" 
			target="_blank" title=""><span>[{%itemList[j].fdCategoryNames%}]</span>{%itemList[j].docSubject%}</a></td>
			<td><span class="answer_num">{%itemList[j].fdReplyCount%} 回答</span></td>
			<td><span class="{%itemList[j].fdStatus > 0 ? 'state' : 'state2' %}"></span></td>
			<td>{%itemList[j].docCreateTime%}</td>
		</tr>
$}
	}
{$
</div>
</tbody>
</table>
<div class="page c" id="{%parameters.kms.id%}-page">
<p class="jump">每页<input type="text" value="{%data.page.rowsize%}" class="i_a" id="_page_rowsize">条<input type="text" value="{%data.page.pageno%}" class="i_a m_l20" id="_page_pageno">/共{%data.page.totalPage%}页<span class="btn_b"><a href="javascript:KMS.page.jump();" title="跳转到"><span>Go</span></a></span></p>
<div class="page_box c">
	<div class="btn_b"><a title="首页" href="javascript:KMS.page.setPageTo(0, {%data.page.rowsize%});"><span>首页</span></a></div>
$}
	if(data.page.hasPrePage){
{$
		<div class="btn_b"><a title="上一页" href="javascript:KMS.page.setPageTo({%data.page.pageno-1%}, {%data.page.rowsize%});"><span>上一页</span></a></div>
$}
	}
{$
	<p class="page_list">
$}
		for(k=0;k<data.page.pagingList.length;k++){ 
			var pgn = data.page.pagingList[k];
{$			
			
			<a title="第{%pgn%}页" href="javascript:KMS.page.setPageTo({%pgn%}, {%data.page.rowsize%});" {%data.page.pageno == pgn ? 'class="on"' : ''%}>{%pgn%}</a>
$}
		}
		if(data.page.hasNextPageList){
{$
			……
$}
		}
{$
	</p>
$}
	if(data.page.hasNextPage){
{$
		<div class="btn_b"><a title="下一页" href="javascript:KMS.page.setPageTo({%data.page.pageno+1%}, {%data.page.rowsize%});"><span>下一页</span></a></div>
$}
	}
{$
	<div class="btn_b"><a title="尾页" href="javascript:KMS.page.setPageTo({%data.page.totalPage%}, {%data.page.rowsize%});"><span>尾页</span></a></div>
	<div class="btn_b"><a title="刷新" href="javascript:KMS.page.setPageTo({%data.page.pageno%}, {%data.page.rowsize%});"><span>刷新</span></a></div>
</div>
</div>
$}

</script>

<!-- 分类筛选 -->
<script type="text/template" id="portlet_ask_filter_tmpl">
{$
	<div class="text_list">
$}
if(data.categoryFilters.length==0){
{$
	该分类下没有子类！
$}
}
for(i=0;i<data.categoryFilters.length;i++){
	if(i==5){
{$		
		<a  href='javascript:void(0)' onclick='showMore(this)' class='more2' >更多</a>
$}
	}
	if(i%5==0&&i/5>0){
{$
		<br/>
$}
	}
{$
	<a href="{%data.categoryFilters[i].fdUrl+'&fdId=${param.fdId}'%}" title="{%data.categoryFilters[i].fdName%}">{%data.categoryFilters[i].fdName%}<span>({%data.categoryFilters[i].count%})</span></a>
$}
}
{$
	</div>
$}
</script>

<script>
	function escapeChar(str){
		if(str){
			str = str.replace(/\&/g, '&amp;');
			str = str.replace(/\</g, '&lt;');
			str = str.replace(/\>/g, '&gt;');
			str = str.replace(/\"/g, '&#034;');
			str = str.replace(/\'/g, '&#039;');
		}
	}

</script>
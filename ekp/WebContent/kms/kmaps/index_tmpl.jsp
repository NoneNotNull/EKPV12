<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 知识地图列表 -->
<script type="text/template" id="portlet_kmaps_list_tmpl">
var itemList = data.jsonArray[0].itemList;
{$
<div class="km_list2">
<table width="100%" cellspacing="0" cellpadding="0" border="0" class="t_b" id="{%parameters.kms.id%}-tbObj">
	<thead>
		<tr>
			<th class="t_b_b"><input type="checkbox" name="" id = "{%parameters.kms.id%}-listcheck"></th>
			<th  width="7%">NO.</th>
			<th  width="45%">标题</th>
			<th  width="9%">作者</th>
			<th  width="9%">浏览次数</th>
			<th  width="9%">点评次数</th>
			<th  width="15%" class="t_b_c">创建时间</th>
		</tr>
	</thead>
	<tbody>
$}
	for(j=0;j<itemList.length;j++){
{$
		<tr 
$}
			if(j%2!=0){{$ class="t_b_a" $}}{$>
			<td><input type="checkbox" name="List_Selected" value="{%itemList[j].fdId%}"></td>
			<td>{%j+1%}</td>
			<td class="tal"><a title="{%itemList[j].docSubject%}" href="{%itemList[j].fdUrl%}" target="_blank"><span>[{%itemList[j].docCategoryName%}]</span>{%itemList[j].docSubject%}</a></td>
			<td>{%itemList[j].docCreator%}</td>
			<td>{%itemList[j].docReadCount%}</td>
			<td>{%itemList[j].docEvalCount%}</td>
			<td>{%itemList[j].docCreateTime%}</td>
		</tr>
$}
	}
{$
</div>
</tbody>
</table>
<div class="page c" id="{%parameters.kms.id%}-page">
<p class="jump">每页<input type="text" value="{%data.jsonArray[0].pageWrapper.page.rowsize%}" class="i_a" id="_page_rowsize">条<input type="text" value="{%data.jsonArray[0].pageWrapper.page.pageno%}" class="i_a m_l20" id="_page_pageno">/共{%data.jsonArray[0].pageWrapper.page.totalPage%}页<span class="btn_b"><a href="javascript:KMS.page.jump();" title="跳转到"><span>Go</span></a></span></p>
<div class="page_box c">
	<div class="btn_b"><a title="首页" href="javascript:KMS.page.setPageTo(0, {%data.jsonArray[0].pageWrapper.page.rowsize%});"><span>首页</span></a></div>
$}
	if(data.jsonArray[0].pageWrapper.page.hasPrePage){
{$
		<div class="btn_b"><a title="上一页" href="javascript:KMS.page.setPageTo({%data.jsonArray[0].pageWrapper.page.pageno-1%}, {%data.jsonArray[0].pageWrapper.page.rowsize%});"><span>上一页</span></a></div>
$}
	}
{$
	<p class="page_list">
$}
		for(k=0;k<data.jsonArray[0].pageWrapper.page.pagingList.length;k++){ 
			var pgn = data.jsonArray[0].pageWrapper.page.pagingList[k];
{$			
			
			<a title="第{%pgn%}页" href="javascript:KMS.page.setPageTo({%pgn%}, {%data.jsonArray[0].pageWrapper.page.rowsize%});" {%data.jsonArray[0].pageWrapper.page.pageno == pgn ? 'class="on"' : ''%}>{%pgn%}</a>
$}
		}
		if(data.jsonArray[0].pageWrapper.page.hasNextPageList){
{$
			……
$}
		}
{$
	</p>
$}
	if(data.jsonArray[0].pageWrapper.page.hasNextPage){
{$
		<div class="btn_b"><a title="下一页" href="javascript:KMS.page.setPageTo({%data.jsonArray[0].pageWrapper.page.pageno+1%}, {%data.jsonArray[0].pageWrapper.page.rowsize%});"><span>下一页</span></a></div>
$}
	}
{$
	<div class="btn_b"><a title="尾页" href="javascript:KMS.page.setPageTo({%data.jsonArray[0].pageWrapper.page.totalPage%}, {%data.jsonArray[0].pageWrapper.page.rowsize%});"><span>尾页</span></a></div>
	<div class="btn_b"><a title="刷新" href="javascript:KMS.page.setPageTo({%data.jsonArray[0].pageWrapper.page.pageno%}, {%data.jsonArray[0].pageWrapper.page.rowsize%});"><span>刷新</span></a></div>
</div>
</div>
$}

</script>

<!-- 知识地图概览 -->
<script type="text/template" id="portlet_kmaps_pre_tmpl">
{$ 
<div class="title1"><h2 class="h2_1">{% parameters.kms.title %}</h2></div>
<div class="box2">
	<dl class="dl_a" >
		<dd id="category_Detail" style="border-bottom:0px">
$}
			for(i=0;i<data.jsonArray.length;i++){
{$ 
				{% data.jsonArray[i].content %}
$}
			}
{$
		</dd>
	</dl>
</div>
$}
</script>

<!-- 知识地图数 -->
<script type="text/template" id="portlet_kmaps_count_tmpl">
for(i=0;i<data.jsonArray.length;i++){
{$
	<p>地图库目前已有地图<span>{%data.jsonArray[i].totalCount%}</span>个；本周更新地图 <span >{%data.jsonArray[i].weekCount%}</span>个</p>
	<kmss:auth requestURL="/kms/kmaps/kms_kmaps_main/kmsKmapsMain.do?method=add" requestMethod="GET">
		<ul>
			<li><a title="我要创建地图" class="btn_map" id ="createMap" href="#" ></a></li>
		</ul>
	</kmss:auth>
$}
}
</script>

<!-- 知识地图路径 -->
<script type="text/template" id="portlet_kmaps_location_tmpl">
{$
	<a title="首页" class="home" href="${kmsBasePath}/common/kms_common_main/kmsCommonMain.do?method=module">首页</a>&gt;
	<a title="知识地图" href="${kmsBasePath}/common/kms_common_main/kmsCommonMain.do?method=module&fdId=com.landray.kmss.kms.kmaps">知识地图</a>
$}

	for(j=0;j<data.jsonArray.length;j++){

		var path = data.jsonArray[j];
		if(j==data.jsonArray.length-1){
{$
			&gt;<span>{%path.fdName%}</span>
$}
		}else{
{$
			&gt;<a title="{%path.fdName%}" href="{%path.fdUrl%}">{%path.fdName%}</a>
$}
		}
	}
</script>

<!-- 列表tab标签 -->
<script id="portlet_kmaps_list_nav_tmpl" type="text/template">
{$ 
	<div class="title4 tabview">
		<ul id="tags" class="c tab_ul"> $} 
		for(i=0;i<tabs.length;i++){
			{$ <li><a href="javascript:KMS_TAB_PORTLET_CHANGE('{%parameters.kms.id%}','{%tabs[i].kms.id%}')">{%tabs[i].kms.title%}</a></li> $} 
		}
	{$ </ul> 
	<div class="btns_box">
	<kmss:auth requestURL="/kms/kmaps/kms_kmaps_main/kmsKmapsMain.do?method=add" requestMethod="GET">
		<div class="btn_a"><a title="<bean:message key="button.add"/>" href="javascript:void(0)" id="addButton"><span><bean:message key="button.add"/></span></a></div>
	</kmss:auth>
	<kmss:auth requestURL="/kms/kmaps/kms_kmaps_main/kmsKmapsMain.do?method=deleteall" requestMethod="GET">
		<div class="btn_a"><a title="<bean:message key="button.delete"/>" href="javascript:void(0)" id="delButton" ><span><bean:message key="button.delete"/></span></a></div>
	</kmss:auth>	
	</div>
</div>
$}
</script>

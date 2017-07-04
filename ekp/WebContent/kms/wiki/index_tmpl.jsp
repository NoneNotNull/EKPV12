<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 当前路径 -->
<script type="text/template" id="portlet_wiki_path_tmpl">
{$
	<a title="首页" class="home" href="${kmsBasePath }/common/kms_common_main/kmsCommonMain.do?method=module">首页</a>&gt;
	<a title="维基库" href="${kmsBasePath }/common/kms_common_main/kmsCommonMain.do?method=module&fdId=com.landray.kmss.kms.wiki">维基库</a>
$}
for(i=0;i<data.sPath.length;i++){
	if(i==data.sPath.length-1){
{$
		&gt;<span>{%data.sPath[i].fdName%}</span>
$}
	}else{
{$
		&gt;<a title="{%data.sPath[i].fdName%}" href="{%data.sPath[i].fdUrl%}">{%data.sPath[i].fdName%}</a>
$}
	}
}
</script>


<!-- 列表tab标签 -->
<script id="portlet_wiki_list_nav_tmpl" type="text/template">
	{$ <div class="title4 tabview"><ul id="tags" class="c tab_ul"> $} 
		for(i=0;i<tabs.length;i++){
			{$ <li><a href="javascript:KMS_TAB_PORTLET_CHANGE('{%parameters.kms.id%}','{%tabs[i].kms.id%}')">{%tabs[i].kms.title%}</a></li> $} 
		}
	{$ </ul> 
	<div class="btns_box">
		<div class="btn_a"><a title="查询" href="javascript:void(0)"  style='display:none' id='searchBtn' onclick='searchMulti()'><span>查询</span></a></div>
		<kmss:auth requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=add" requestMethod="GET">
			<div class="btn_a"><a title="<bean:message key="button.add"/>" href="javascript:void(0)" id="addButton"><span><bean:message key="button.add"/></span></a></div>
		</kmss:auth>
		<kmss:auth requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=deleteallList&fdCategoryId=${param.fdCategoryId}" requestMethod="GET">
			<div class="btn_a"><a title="<bean:message key="button.delete"/>" href="javascript:void(0)" id="delButton" ><span><bean:message key="button.delete"/></span></a></div>
		</kmss:auth>
		<kmss:auth  requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=cateChgEdit&fdId=${kmsWikiMainForm.fdId}" requestMethod="GET">
			<div class="btn_a" id="changeCategory">
				<a href="javascript:void(0)" onclick="changeTemp();" title="<bean:message key="sysSimpleCategory.chg.button" bundle="sys-simplecategory"/>">
					<span><bean:message key="sysSimpleCategory.chg.button" bundle="sys-simplecategory"/></span></a>
			</div> 
		</kmss:auth>
		<kmss:auth  requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=editPropertys&categoryId=${param.fdCategoryId}" requestMethod="GET">
			<div class="btn_a" id="editProperty">				
				<a href="javascript:void(0)" onclick="editProperty();" title="<bean:message key="button.chengeProperty" bundle="kms-wiki"/>">
					<span><bean:message key="button.chengeProperty" bundle="kms-wiki"/></span></a>
			</div>		 
		 </kmss:auth>	
		 <kmss:auth  requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=rightDocChange&categoryId=${param.fdCategoryId}" requestMethod="GET">
			<div class="btn_a" id="editChangeRight">	
				<a href="javascript:void(0)" onclick="editChangeRight();" title="<bean:message key="kmsWiki.button.changeRight" bundle="kms-wiki"/>">
					<span><bean:message key="kmsWiki.button.changeRight" bundle="kms-wiki"/></span></a>
			</div>		 
		 </kmss:auth>
		</div>
	</div>
$}
</script>

<!-- 百科列表 -->
<script type="text/template" id="portlet_wiki_list_tmpl">
var itemList = data.itemList;
{$
<div class="km_list2">
<table width="100%" cellspacing="0" cellpadding="0" border="0" class="t_b" id="{%parameters.kms.id%}-tbObj">
	<thead>
		<tr>
			<th class="t_b_b"><input type="checkbox" id="{%parameters.kms.id%}-listcheck"></th>
			<th width="5%">NO.</th>
			<th width="30%">词条名</th>
			<th width="9%">浏览次数</th>
			<th width="15%">创建者</th>
			<th width="9%">完善次数</th>
			<th width="15%">最后完善时间</th>
			<th class="t_g_b" width="12%">最后完善人</th>
		</tr>
	</thead>
	<tbody>
$}
	for(j=0;j<itemList.length;j++){
{$
		<tr 
$}
			if(j%2!=0){{$ class="t_b_a" $}}{$>
			<td><input type="checkbox" name="List_Selected" value="{%itemList[j].fdId%}"><input type="hidden" id="{%itemList[j].fdId%}" value="{%itemList[j].docCategory%}"></td>
			<td>{%j+1%}</td>
			<td class="tal"><a title="{%itemList[j].docSubject%}" href="{%itemList[j].fdUrl%}" target="_blank">{%itemList[j].docSubject%}</a></td>
			<td>{%itemList[j].docReadCount%}</td>
			<td>{%itemList[j].docCreator%}</td>
			<td>{%itemList[j].fdVersion%}</td>
			<td>{%itemList[j].fdLastModifiedTime%}</td>			
			<td>{%itemList[j].fdLastCreator%}</td>
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
		<div class="btn_b"><a title="下一页" href="javascript:KMS.page.setPageTo({%data.page.pageno+1%}, {%data.page.rowsize%})"><span>下一页</span></a></div>
$}
	}
{$
	<div class="btn_b"><a title="尾页" href="javascript:KMS.page.setPageTo({%data.page.totalPage%}, {%data.page.rowsize%});"><span>尾页</span></a></div>
	<div class="btn_b"><a title="刷新" href="javascript:KMS.page.setPageTo({%data.page.pageno%}, {%data.page.rowsize%});"><span>刷新</span></a></div>
</div>
</div>
$}

</script>

<!-- 百科知识数 -->
<script type="text/template" id="portlet_wiki_count_tmpl">
{$
	<p>经全体人员努力，目前已收录词条<span>{%data.totalCount%}</span>份；一周内共新建<span>{%data.newWikiWeek%}</span>份</p>
	<ul class="ul2">
		<kmss:auth requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=add" requestMethod="GET">
			<li><a href="javascript:void(0)" class="btn_wiki" title="新建词条"></a></li>
		</kmss:auth>
	</ul>
$}
</script>

<!-- 最新推荐词条 -->
<script type="text/template" id="portlet_wiki_intro_tmpl">
{$
	<div class="title1"><h2>{%parameters.kms.title%}</h2></div>
	<div class="box2">
	<ul class="l_a4 m_t10" >
$}
	for(i=0;i<data.itemList.length;i++){
{$
		<li>
			<a href = "{%data.itemList[i].fdUrl%}" target="_blank" title = "{%data.itemList[i].docSubject%}"><span>[{%data.itemList[i].docCategoryName%}]</span>{%resetStrLength(data.itemList[i].docSubject,15)%}</a>
		</li>
$}
	}
{$
	</div>
	</ul>
$}
</script>


<!-- 分类筛选 -->
<script type="text/template" id="portlet_wiki_filter_tmpl">
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
		<a  href='javascript:void(0)' onclick='showMore(this)' class='more2' >收起</a>
$}
	}
	if(i%5==0&&i/5>0){
{$
		<br/>
$}
	}
{$
	<a href="{%data.categoryFilters[i].fdUrl%}" title="{%data.categoryFilters[i].fdName%}">{%data.categoryFilters[i].fdName%}<span>({%data.categoryFilters[i].count%})</span></a>
$}
}
{$
	</div>
$}
</script>

<script id="portlet_nav_tmpl" type="text/template">
	{$ <div class="title4 tabview"><ul id="tags" class="c tab_ul"> $} 
		for(i=0;i<tabs.length;i++){
			{$ <li><a href="javascript:KMS_TAB_PORTLET_CHANGE('{%parameters.kms.id%}','{%tabs[i].kms.id%}')">{%tabs[i].kms.title%}</a></li> $} 
		}
	{$ </ul>
		<div class="btns_box">
			<div class="btn_a"><a title="版本对比" href="javascript:void(0)" id="compareVersion" onclick="compareVersion();"><span>版本对比</span></a></div>
	</div>
	</div> $} 
</script>
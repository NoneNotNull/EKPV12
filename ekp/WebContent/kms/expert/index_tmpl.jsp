<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 当前路径 -->
<script type="text/html" id="portlet_expert_location_tmpl" class="js_tmpl">
{$
<a title="首页" class="home" href="${kmsBasePath }/common/kms_common_main/kmsCommonMain.do?method=module">首页</a>&gt;
<a title="专家" href="${kmsBasePath }/common/kms_common_main/kmsCommonMain.do?method=module&fdId=com.landray.kmss.kms.expert">专家</a>
$}
for(i=0;i<data.sPath.length;i++){
	if(i==data.sPath.length-1){
{$
		&gt;<span>{%data.sPath[i].fdName%}</span>
$}
	}else {
{$
		&gt;<a title="{%data.sPath[i].fdName%}" href="{%data.sPath[i].fdUrl%}">{%data.sPath[i].fdName%}</a>
$}
	}
}
</script>

<!-- 专家数统计 -->
<script type="text/template" id="portlet_expert_count_tmpl">
{$
	<p>专家库目前已有专家<span>{%data.totalCount%}</span>名；本周新增专家<span>{%data.newWeekCount%}</span>名</p>
	<kmss:auth requestURL="/kms/expert/kms_expert_info/kmsExpertInfo.do?method=add" requestMethod="GET">
		<ul>
			<li><a href="javascript:void(0)" class="btn_expert" title="我要新建专家" id="createExpert"></a></li>
		</ul>
	</kmss:auth>
$}
</script>


<!-- 专家列表 -->
<script type="text/template" id="portlet_expert_list_tmpl">
{$
<div class="tagContent">
	<ul class="l_g2 c" >
$}
		for(i=0;i<data.itemList.length;i++){
			var itemList = data.itemList[i];
{$
			<li >
				<a href="{%itemList.fdUrl%}" class="img_e" title="" target="_blank"><img src="{%itemList.fdImgUrl%}" alt="" onload="javascript:	drawImage(this,this.parentNode)"/></a>				
				<ul class="l_h">
					<li><strong>专家：</strong><span class="b">{%itemList.fdName%}</span></li>
					<li title="{%itemList.fdDeptName%}"><strong>部门：</strong>{%resetStrLength(itemList.fdDeptName||'',25)%}</li>
					<li title="{%itemList.fdPersonPost%}"><strong>职位：</strong>{%resetStrLength(itemList.fdPersonPost||'',25)%}</li>
					<li title="{%itemList.expertType%}"><strong>精通领域：</strong>{%resetStrLength(itemList.expertType||'',20)%}</li>
$}
					if(itemList.hasAsk){
						{$<li><div class="btn_d" style="float:left;" ><a href="javascript:void(0)" title="向他提问" onclick="askToExpert('{%itemList.fdId%}')"><span>向他提问</span></a></div></li>$}
					}
{$
				</ul>
			</li>
$}
		}
{$
	</ul>
</div>
$}
{$	
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

<!-- 列表tab标签 -->
<script id="portlet_expert_list_nav_tmpl" type="text/template">
	{$ <div class="title4 tabview"><ul id="tags" class="c tab_ul"> $} 
		for(i=0;i<tabs.length;i++){
			{$ <li><a href="javascript:KMS_TAB_PORTLET_CHANGE('{%parameters.kms.id%}','{%tabs[i].kms.id%}')">{%tabs[i].kms.title%}</a></li> $} 
		}
	{$ </ul> 
	<div class="btns_box">
	<kmss:auth requestURL="/kms/expert/kms_expert_info/kmsExpertInfo.do?method=add" requestMethod="GET">
		<div class="btn_a"><a title="<bean:message key="button.add"/>" href="javascript:void(0)" id="addButton"><span><bean:message key="button.add"/></span></a></div>
	</kmss:auth>
	</div>
	</div>
$}
</script>
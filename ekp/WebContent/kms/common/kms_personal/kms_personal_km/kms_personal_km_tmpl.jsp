<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script type="text/html" id="KS_TMP_INTEGRAL">
{{#each jsonArray as json index}}
	<td>{{json.fdTotalScore}}</td>
	<td>{{json.fdRecordScore}}</td>
	<td>{{json.fdCreateScore}}</td>
	<td>{{json.fdEvaluationScore}}</td>
	<td>{{json.fdIntroduceScore}}</td>
	<td>{{json.fdReadScore}}</td>
	<td>{{json.fdContributeSocre}}</td>
	<td>{{json.fdAskScore}}</td>
{{/each}}
</script>

<!-- 列表tab标签 -->
<script id="portlet_todo_list_nav_tmpl" type="text/template">
	{$ <div class="title4 tabview"><ul id="tags" class="c tab_ul"> $} 
		for(i=0;i<tabs.length;i++){
			{$ <li><a href="javascript:KMS_TAB_PORTLET_CHANGE('{%parameters.kms.id%}','{%tabs[i].kms.id%}')">{%tabs[i].kms.title%}</a></li> $} 
		}
	{$ </ul></div> 
$}
</script>

<!--消息列表 -->
<script type="text/template" id="portlet_todo_list_tmpl">
var itemList = data.itemList;
if(parameters.kms.id == 'portlet_sysNotifyTodo'){{$ 
<div class="btns_box">
	<div class="btn_a" style="float:right;margin:10px 10px;"><a title="取消待阅" href="javascript:void(0)" id="setButton"><span>取消待阅</span></a></div>
</div>
$}}{$
<div class="km_list2">
<table width="100%" cellspacing="0" cellpadding="0" border="0" class="t_b" id="{%parameters.kms.id%}-tbObj">
	<thead class="t_g_a">
		<tr>
  			$}if(parameters.kms.id == 'portlet_sysNotifyTodo'){{$<th width="5%"><input type="checkbox" id="{%parameters.kms.id%}-listcheck"></th>$}}{$
			<th width="5%">NO.</th>
			<th width="70%">内容</th>
			<th class="t_b_c">时间</th>
		</tr>
	</thead>
	<tbody>
$}
	for(j=0;j<itemList.length;j++){
{$
		<tr 
$}
			if(j%2!=0){{$ class="t_b_a" $}}{$>
			$}if(parameters.kms.id == 'portlet_sysNotifyTodo'){{$<td><input type="checkbox" name="List_Selected" value="{%itemList[j].fdId%}"></td>$}}{$
			<td>{%j+1%}</td>
			<td class="tal">
				<a href="{%itemList[j].fdUrl%}" target="_blank">
					{%itemList[j].fdSubject%}
				</a>
			</td>
			<td>{%itemList[j].fdCreateTime%}</td>
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
	<p class="page_list">
$}
	  var aa=data.page.pageno;
         var bb=data.page.totalPage;

		for(k=0;k<data.page.pagingList.length;k++){ 

			var pgn = data.page.pagingList[k];
       if(k==0){
          if(aa!=1){
{$			
			<a title="上一页" href="javascript:KMS.page.setPageTo({%aa-1%}, {%data.page.rowsize%});"><span><<</span></a>
			<a title="第{%pgn%}页" href="javascript:KMS.page.setPageTo({%pgn%}, {%data.page.rowsize%});" {%data.page.pageno == pgn ? 'class="on"' : ''%}>{%pgn%}</a>
$}
}else{               
{$			
			
			<a title="第{%pgn%}页" href="javascript:KMS.page.setPageTo({%pgn%}, {%data.page.rowsize%});" {%data.page.pageno == pgn ? 'class="on"' : ''%}>{%pgn%}</a>
$}
}

         continue;
        } 
       if(k==data.page.pagingList.length-1){ 
        if(aa!=bb){
{$			
			
			<a title="第{%pgn%}页" href="javascript:KMS.page.setPageTo({%pgn%}, {%data.page.rowsize%});" {%data.page.pageno == pgn ? 'class="on"' : ''%}>{%pgn%}</a>
<a title="下一页" href="javascript:KMS.page.setPageTo({%aa+1%}, {%data.page.rowsize%});"><span>>></span></a>
$}
}else{

{$			
			
			<a title="第{%pgn%}页" href="javascript:KMS.page.setPageTo({%pgn%}, {%data.page.rowsize%});" {%data.page.pageno == pgn ? 'class="on"' : ''%}>{%pgn%}</a>
$}
}

         continue;
        }
        if(0<k<data.page.pagingList.length-1){
{$			
			
			<a title="第{%pgn%}页" href="javascript:KMS.page.setPageTo({%pgn%}, {%data.page.rowsize%});" {%data.page.pageno == pgn ? 'class="on"' : ''%}>{%pgn%}</a>
$}
continue;
        }

		}
{$
	</p>
	<div class="btn_b"><a title="尾页" href="javascript:KMS.page.setPageTo({%data.page.totalPage%}, {%data.page.rowsize%});"><span>尾页</span></a></div>
	<div class="btn_b"><a title="刷新" href="javascript:KMS.page.setPageTo({%data.page.pageno%}, {%data.page.rowsize%});"><span>刷新</span></a></div>
</div>
</div>
$}
</script>

<script type="text/template" id="portlet_km_cko_tmpl">
{$
	<h3 class="h3_2 m_t40">
		<span>{%parameters.kms.title%}</span>
	</h3>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="t_h m_t10">
		<tr>
			<th>总积分</th>
$}
			for(var i = 0; i<data.lists.length;i++){
{$				
				<th>{%data.lists[i].title%}积分</th>
$}
			}
{$
		</tr>
		<tr id="myIntegralPortlet">
			<td>{%data.fdTotalScore%}</td>
$}
			for(var i = 0; i<data.lists.length;i++){
{$				
				<td>{%data[data.lists[i].unid]%}</td>
$}
			}
{$
		</tr>
	</table>
	<br />
	<p>
		<span class="help_cko">帮助提示</span>
	</p>
	<div class="help_cko_info">
		<p>
			<span>个人总积分 = 
$}	
			for(var j = 0; j<data.lists.length;j++){
				if(j==data.lists.length-1){
{$					
					个人{%data.lists[j].title%}积分
$}
					break;
				}
{$				
				个人{%data.lists[j].title%}积分 + 	
$}
			}
{$		
			</span>
		</p>
	</div>
$}
</script>

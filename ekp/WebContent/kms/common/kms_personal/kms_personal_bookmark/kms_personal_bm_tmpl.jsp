<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 列表tab标签 -->
<script id="portlet_bm_list_nav_tmpl" type="text/template">
	{$ <div class="title4 tabview"><ul id="tags" class="c tab_ul"> $} 
		for(i=0;i<tabs.length;i++){
			{$ <li><a href="javascript:KMS_TAB_PORTLET_CHANGE('{%parameters.kms.id%}','{%tabs[i].kms.id%}')">{%tabs[i].kms.title%}</a></li> $} 
		}
	{$ </ul> 
	<div class="btns_box">
		<div class="btn_a"><a title="<bean:message key="button.add"/>" href="javascript:void(0)" id="addButton"><span><bean:message key="button.add"/></span></a></div>
		<div class="btn_a"><a title="<bean:message key="button.delete"/>" href="javascript:void(0)" id="delButton" ><span><bean:message key="button.delete"/></span></a></div>
	</div>
	</div>
$}
</script>

<!--收藏列表 -->
<script type="text/template" id="portlet_bm_list_tmpl">
var itemList = data.itemList;
{$
<div class="km_list2">
<table width="100%" cellspacing="0" cellpadding="0" border="0" class="t_b" id="{%parameters.kms.id%}-tbObj">
	<thead class="t_g_a">
		<tr>
			<th width="5%" class="t_b_b"><input type="checkbox" id="{%parameters.kms.id%}-listcheck"></th>
			<th width="5%">NO.</th>
			<th width="40%">标题</th>
			<th width="10%">创建者</th>
			<th width="20%">类别</th>
			<th width="20%" class="t_b_c">创建时间</th>
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
			<td class="tal"><a href="{%itemList[j].href%}" title="{%itemList[j].docSubject%}" target="_blank">{%itemList[j].docSubject%}</a></td>
			<td>{%itemList[j].docCreatorName%}</td>
			<td>{%itemList[j].docCategoryName%}</td>
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
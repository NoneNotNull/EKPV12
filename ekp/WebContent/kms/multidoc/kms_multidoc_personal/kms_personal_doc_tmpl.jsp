<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 列表tab标签 -->
<script id="portlet_doc_list_nav_tmpl" type="text/template">
	{$ <div class="title4 tabview"><ul id="tags" class="c tab_ul"> $} 
		for(i=0;i<tabs.length;i++){
			{$ <li><a href="javascript:KMS_TAB_PORTLET_CHANGE('{%parameters.kms.id%}','{%tabs[i].kms.id%}')">{%tabs[i].kms.title%}</a></li> $} 
		}
	{$ </ul> 
	<div class="btns_box">
		<kmss:auth requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=add" requestMethod="GET">
			<div class="btn_a"><a title="<bean:message key="button.add"/>" href="javascript:void(0)" id="addButton"><span><bean:message key="button.add"/></span></a></div>
		</kmss:auth>
		<kmss:auth requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=deleteall" requestMethod="GET">
			<div class="btn_a"><a title="<bean:message key="button.delete"/>" href="javascript:void(0)" id="delButton" ><span><bean:message key="button.delete"/></span></a></div>
		</kmss:auth>
	</div>
	<div id="portlet_myDoc-selector" class="display_box">
		显示
		<select class="m_l5" onchange="KMS.page.setDocStatus(this);">
			<option value="all" selected="selected">所有</option>
			<option value="30">已发布</option>
			<option value="00">废弃</option>
			<option value="10">草稿</option>
			<option value="11">驳回</option>
			<option value="20">待审</option>
			<option value="40">过期</option>
		</select>
	</div>
	<div id="portlet_myReview-selector" class="display_box" style="display:none;">
		显示
		<select class="m_l5" onchange="KMS.page.setWorkflowStatus(this)">
			<option value="1" selected="selected">已审核</option>
			<option value="0">未审核</option>
		</select>
	</div>
	</div>
$}
</script>

<!-- 多维库列表 -->
<script type="text/template" id="portlet_doc_list_tmpl">
var itemList = data.itemList;
{$
<div class="km_list2">
<table width="100%" cellspacing="0" cellpadding="0" border="0" class="t_b" id="{%parameters.kms.id%}-tbObj">
	<thead >
		<tr>
			<th width="5%" class="t_b_b"><input id="{%parameters.kms.id%}-listcheck" type="checkbox"></th>
			<th width="5%">NO.</th>
			<th width="30%">标题</th>
			<th width="10%">作者</th>
			<th width="10%">浏览次数</th>
			<th width="10%">点评次数</th>
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
			<td class="tal">
				<span>
				<a href="<c:url value="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=view&fdId=" />{%itemList[j].fdId%}" 
					target="_blank" title="{%itemList[j].docSubject%}">
					<span>[{%itemList[j].docTemplateName%}]</span>
					{%resetStrLength(itemList[j].docSubject, 26)%}
				</a>
			</td>
			<td>{%itemList[j].docAuthorName%}</td>
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

<!-- 个人主页积分信息 -->
<script type="text/template" id="portlet_km_cko_tmpl">
{$
	<h3 class="h3_2 m_t40">
		<span>{%parameters.kms.title%}</span>
	</h3>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="t_h m_t10">
		<tr>
			<th>多维知识库积分</th>
			<th>贡献积分</th>
			<th>阅读积分</th>
			<th>录入积分</th>
			<th>原创积分</th>
			<th>点评积分</th>
			<th>推荐积分</th>
			<th>被修改积分</th>
		</tr>
		<tr id="myIntegralPortlet">
			<td>{%data.fdTotalScore||0%}</td>
			<td>{%data.fdContributeSocre||0%}</td>
			<td>{%data.fdReadScore||0%}</td>
			<td>{%data.fdRecordScore||0%}</td>
			<td>{%data.fdCreateScore||0%}</td>
			<td>{%data.fdEvaluationScore||0%}</td>
			<td>{%data.fdIntroduceScore||0%}</td>
			<td>{%data.fdAlterScore||0%}</td>
		</tr>
	</table>
		<br />
		<p>
			<span class="help_cko">帮助提示</span>
		</p>
		<div class="help_cko_info">
			<p>
				<span>贡献积分=“所创建的文档被点评、被推荐、被阅读时所获得的积分”</span>
			</p>
			<p>
				<span>阅读积分=“阅读文档获得的积分值”</span>
			</p>
			<p>
				<span>录入积分=“上传文档时所获得的积分值”</span>
			</p>
			<p>
				<span>原创积分=“文档作者所获得的积分值”</span>
			</p>
			<p>
				<span>点评积分=“点评文档时所获得的积分值”</span>
			</p>
			<p>
				<span>推荐积分=“推荐文档时所获得的积分值”</span>
			</p>
			<p>
				<span>被修改积分=“在多维知识库内被修改的积分值”</span>
			</p>
			<p>
				<span>个人多维知识库积分 = 贡献积分 + 阅读积分 + 录入积分 + 原创积分 + 点评积分 + 推荐积分 + 被修改积分</span>
			</p>
		</div>
$}
</script>
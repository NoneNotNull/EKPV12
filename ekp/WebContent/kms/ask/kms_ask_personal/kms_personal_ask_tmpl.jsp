<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

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
	<div id="myAsk-selector" class="display_box">
		显示
		<select class="m_l5" onchange="KMS.page.setDocStatus(this);">
			<option value="0" selected="selected">未解决</option>
			<option value="2">已解决</option>
			<option value="1">最佳</option>
		</select>
	</div>
	<div id="myAnswer-selector" class="display_box" style="display:none;">
		显示
		<select class="m_l5" onchange="KMS.page.setDocStatus(this);">
			<option value="0" selected="selected">未解决</option>
			<option value="2">已解决</option>
			<option value="1">最佳</option>
		</select>
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

<!-- 个人主页积分显示 -->
<script type="text/template" id="portlet_km_cko_tmpl">
{$
	<h3 class="h3_2 m_t40">
		<span>{%parameters.kms.title%}</span>
	</h3>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="t_h m_t10">
		<tr>
			<th>知识问答积分</th>
			<th>发表问题</th>
			<th>回答问题</th>
			<th>置为最佳答案</th>
			<th>回复被赞</th>
			<th>回复被推荐</th>
			<th>问题被删</th>
			<th>答案被删</th>
			<th>被修改积分</th>
		</tr>
		<tr id="myIntegralPortlet">
			<td>{%data.fdAnswerScore%}</td>
			<td>{%data.fdAnswerCreateScore%}</td>
			<td>{%data.fdAnswerReplyScore%}</td>
			<td>{%data.fdAnswerBeBestScore%}</td>
			<td>{%data.fdAnswerBeVotedScore%}</td>
			<td>{%data.fdAnswerBeIntroducedScore%}</td>
			<td>{%data.fdAnswerDeleteScore%}</td>
			<td>{%data.fdAnswerReplyDeleteScore%}</td>
			<td>{%data.fdAnswerAlterScore%}</td>
		</tr>
	</table>
	<br />
	<p>
		<span class="help_cko score">帮助提示</span>
	</p>
	<div class="help_cko_info score">
		<p>
			<span>发表问题=“提出问题后,作为提问者获得的积分值”</span>
		</p>
		<p>
			<span>回答问题=“回答问题后,作为回答者获得的积分值”</span>
		</p>
		<p>
			<span>置为最佳答案=“给出的答案被至为最佳时,获得的积分值”</span>
		</p>
		<p>
			<span>回复被赞=“给出的答案被称赞成时,获得的积分值”</span>
		</p>
		<p>
			<span>问题被推荐=“提出的问题被推荐时,作为提问者获得的积分值”</span>
		</p>
		<p>
			<span>问题被删=“提出的问题被删除时,作为提问者被扣除的积分值”</span>
		</p>
		<p>
			<span>答案被删=“给出的答案被删除时,作为回答者者被扣除的积分值”</span>
		</p>
		<p>
			<span>被修改积分=“在知识问答模块内被修改的积分值”</span>
		</p>
		<p>
			<span>知识问答积分 = 发表问题得分 + 回答问题得分 + 置为最佳答案得分 + 回复被赞得分  + 问题被推荐得分 + 问题被删扣分 + 答案被删扣分</span>
		</p>
	</div>
$}
</script>

<!-- 财富明细 -->
<script type="text/template" id="portlet_ask_money_tmpl">
{$
	<h3 class="h3_2 m_t40">
		<span>{%parameters.kms.title%}</span>
	</h3>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="t_h m_t10">
		<tr>
			<th>总币值</th>
			<th>已支付币值</th>
			<th>获得币值</th>
			<th>被修改币值</th>
		</tr>
		<tr id="myIntegralPortlet">
			<td>{%data.fdTotalMoney%}</td>
			<td>{%data.fdMoneySpend%}</td>
			<td>{%data.fdMoneyWin%}</td>
			<td>{%data.fdMoneyFree%}</td>
		</tr>
	</table>
	<br />
	<p>
		<span class="help_cko money">帮助提示</span>
	</p>
	<div class="help_cko_info money">
		<p>
			<span>总货币值=“当前财富币总值”</span>
		</p>
		<p>
			<span>已支付币值=“已支付给他人的财富币值”</span>
		</p>
		<p>
			<span>获得币值=“回答问题被置为最佳得到的财富币值”</span>
		</p>
		<p>
			<span>被修改币值=“被修改的财富币值”</span>
		</p>
		<p>
			<span>总币值 = 已支付币值 + 获得币值 + 被修改币值</span>
		</p>
	</div>
$}
</script>
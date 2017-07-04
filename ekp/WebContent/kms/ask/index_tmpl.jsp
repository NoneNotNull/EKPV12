<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 推荐问题 -->
<script id="portlet_ask_intro_tmpl" type="text/template">
{$
	<div class="title1"><h2>{%parameters.kms.title%}</h2>
$}
	if(data.more){
{$
		<a href="${kmsBasePath }/ask/kms_ask_topic/kmsAskTopic.do?method=indexList&fdId=${param.fdId}&more=3" class="more" title="" target="_blank">更多&nbsp;&gt;</a>
$}
	}
{$
	</div>

	<div class="box2">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="t_c m_t10">
		<tr>
			<th width="10%">悬赏币</th>
			<th width="45%">标题</th>
			<th width="15%">回复数</th>
			<th width="10%">状态</th>
			<th width="20%">推荐时间</th>
		</tr>
$}
	for(i=0;i<data.introduceAsks.length;i++){
		var introduceAsk = data.introduceAsks[i];
{$
		<tr>
			<td><span class="score">{%introduceAsk.score%}</span></td>
			<td><a target="_blank" title="" href="{%introduceAsk.docCategoryUrl%}"><span>[{%introduceAsk.categoryName%}]</span></a><a href="{%introduceAsk.fdUrl%}" target="_blank" title="{%introduceAsk.docSubject%}">{%resetStrLength(introduceAsk.docSubject,25)%}</a></td>
			<td><span class="answer_num">{%introduceAsk.replyCount%} 回答</span></td>
$}
			if(introduceAsk.status==0)
{$
				<td><span class="state2"></span></td>
$}
			else if(introduceAsk.status==1||introduceAsk.status==2){
{$
				<td><span class="state"></span></td>
$}
			}
{$
			<td>{%introduceAsk.docCreateTime%}</td>
		</tr>
$}
	}
{$
</table>
</div>
$}
</script>

<!-- 进行中的问题 -->
<script id="portlet_ask_unsolve_tmpl" type="text/template">
{$
	<div class="title1"><h2>{%parameters.kms.title%}</h2>
$}
	if(data.more){
{$
		<a href="${kmsBasePath }/ask/kms_ask_topic/kmsAskTopic.do?method=indexList&fdId=${param.fdId}&more=0" class="more" title="" target="_blank">更多&nbsp;&gt;</a>
$}
	}
{$
	</div>

	<div class="box2">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="t_c m_t10">
		<tr>
			<th width="10%">悬赏币</th>
			<th width="45%">标题</th>
			<th width="15%">回复数</th>
			<th width="10%">状态</th>
			<th width="20%">提问时间</th>
		</tr>
$}
	for(i=0;i<data.unsolveAsks.length;i++){
		var unsolveAsk = data.unsolveAsks[i];
{$
		<tr>
			<td><span class="score">{%unsolveAsk.score%}</span></td>
			<td><a target="_blank" title="" href="{%unsolveAsk.docCategoryUrl%}"><span>[{%unsolveAsk.categoryName%}]</span></a><a href="{%unsolveAsk.fdUrl%}" target="_blank" title="{%unsolveAsk.docSubject%}">{%resetStrLength(unsolveAsk.docSubject,25)%}</a></td>
			<td><span class="answer_num">{%unsolveAsk.replyCount%} 回答</span></td>
$}
			if(unsolveAsk.status==0)
{$
				<td><span class="state2"></span></td>
$}
			else if(unsolveAsk.status==1||unsolveAsk.status==2){
{$
				<td><span class="state"></span></td>
$}
			}
{$
			<td>{%unsolveAsk.docCreateTime%}</td>
		</tr>
$}
	}
{$
</table>
</div>
$}
</script>

<!-- 最新解决问题  -->
<script id="portlet_ask_end_tmpl" type="text/template">
{$
	<div class="title1"><h2>{%parameters.kms.title%}</h2>
$}
	if(data.more){
{$
		<a href="${kmsBasePath }/ask/kms_ask_topic/kmsAskTopic.do?method=indexList&fdId=${param.fdId}&more=1" class="more" title="" target="_blank">更多&nbsp;&gt;</a>
$}
	}
{$
	</div>

	<div class="box2">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="t_c m_t10">
		<tr>

			<th width="10%">悬赏币</th>
			<th width="45%">标题</th>
			<th width="15%">回复数</th>
			<th width="10%">状态</th>
			<th width="20%">提问时间</th>
		</tr>
$}
	for(i=0;i<data.newestEndAsks.length;i++){
		var newestEndAsk = data.newestEndAsks[i];
{$
		<tr>
			<td><span class="score">{%newestEndAsk.score%}</span></td>
			<td><a target="_blank" title="" href="{%newestEndAsk.docCategoryUrl%}"><span>[{%newestEndAsk.categoryName%}]</span></a><a href="{%newestEndAsk.fdUrl%}" target="_blank" title="{%newestEndAsk.docSubject%}">{%resetStrLength(newestEndAsk.docSubject,25)%}</a></td>
			<td><span class="answer_num">{%newestEndAsk.replyCount%} 回答</span></td>
$}
			if(newestEndAsk.status==0)
{$
				<td><span class="state2"></span></td>
$}
			else if(newestEndAsk.status==1||newestEndAsk.status==2){
{$
				<td><span class="state"></span></td>
$}
			}
{$
			<td>{%newestEndAsk.docCreateTime%}</td>
		</tr>
$}
	}
{$
</table>
</div>
$}
</script>

<!-- 爱问知识数 -->
<script type="text/template" id="portlet_ask_count_tmpl">
{$
	<p>经全体人员努力，目前已收录知识问答<span>{%data.totalCount%}</span>份；一周内共提问<span>{%data.askWeek%}</span>份，回复<span>{%data.replyWeek%}</span>份，结束问题<span>{%data.endWeek%}</span>份，推荐问题<span>{%data.introduceWeek%}</span>份</p>
	<kmss:auth requestURL="/kms/ask/kms_ask_topic/kmsAskTopic.do?method=add" requestMethod="GET">
	<ul class="ul2">
		<li><a href="javascript:void(0)" class="btn_ask" title="我有问题要问"></a></li>
	</ul>
	</kmss:auth>
$}
</script>

<!-- 爱问达人 -->
<script type="text/template" id="portlet_ask_per_tmpl">
{$
	<div class="title1"><h2>{%parameters.kms.title%}</h2></div>
	<div class="box2">
$}
for(i=0;i<data.perOfAsks.length;i++){
	var perOfAsk = data.perOfAsks[i];
{$
<ul class="l_g c" >
	<li>
		<a title="" class="img_a" href="{%perOfAsk.fdUrl%}"><img alt="" src="{%perOfAsk.imgUrl%}"  onload="javascript:drawImage(this,this.parentNode)"/></a>
		<ul class="l_h">
			<li><strong>知识达人：</strong><span class="b">{%perOfAsk.fdName%}</span></li>
			<li><strong>精通领域：</strong>{%resetStrLength(perOfAsk.categoryName||'',10)%}</li>
			<li><strong>总回答数：</strong><span>{%perOfAsk.num%}</span></li>
$}
			if(perOfAsk.flag){
{$
				<li><div class="btn_d"><a href="javascript:void(0)" title="向他提问" onclick="askToExpert('{%perOfAsk.fdExpertId%}')"><span>向他提问</span></a></div></li>
$}
			}
{$
		</ul>
	</li>
</ul>	
$}
}
{$</div>$}
</script>
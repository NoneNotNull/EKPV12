<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!-- 知识阅读模板 -->
<script id="portlet_doc_read_tmpl" type="text/template">
{$
	<div class="title1"><h2>{% parameters.kms.title %}</h2></div>
	<div class="box2">
		<ul class="l_c l_c2">
$}
	for(i=0;i<data.docList.length;i++){
{$	
		<li>
			<span class="view_times">阅读次数:<em>{%data.docList[i].readCount%}</em></span>
			<span class="date">{%data.docList[i].docCreateTime%}</span>
			<span class="author">{%resetStrLength(data.docList[i].docCreator,10)%}</span>
			<div><a class="a_classify" href="{%data.docList[i].docCategoryUrl%}" target = "_blank" title="{%data.docList[i].docCategory%}">[{%resetStrLength(data.docList[i].docCategory,10)%}]</a>
			<a class="a_text" title="{%data.docList[i].docSubject%}" target="_blank" href="{%data.docList[i].fdUrl%}">{%resetStrLength(data.docList[i].docSubject,20)%}</a></div>
		</li>
$}
	}
{$
		</ul>
	</div>
$}

</script>

<!-- 知识推荐模板 -->
<script id="portlet_doc_intro_tmpl" type="text/template">
{$
	<div class="title1"><h2>{% parameters.kms.title %}</h2></div>
	<div class="box2">
		<ul class="l_c l_c2">
$}
	for(i=0;i<data.docList.length;i++){
{$	
		<li>
			<span class="view_times">推荐次数:<em>{%data.docList[i].introCount%}</em></span>
			<span class="date">{%data.docList[i].docCreateTime%}</span>
			<span class="author">{%resetStrLength(data.docList[i].docCreator,10)%}</span>
			<div><a class="a_classify" href="{%data.docList[i].docCategoryUrl%}" target = "_blank" title="{%data.docList[i].docCategory%}">[{%resetStrLength(data.docList[i].docCategory,10)%}]</a>
			<a class="a_text" title="{%data.docList[i].docSubject%}" target="_blank" href="{%data.docList[i].fdUrl%}">{%resetStrLength(data.docList[i].docSubject,20)%}</a></div>
		</li>
$}
	}
{$
		</ul>
	</div>
$}

</script>


<!-- 多维库知识数 -->
<script type="text/template" id="portlet_multidoc_count_tmpl">
{$
	<p>经全体人员努力已收录知识<span>{%data.totalCount%}</span>份；今日更新<span>{%data.updateTodayCount%}</span>份；共<span>{%data.introTotalCount%}</span>份被推荐</p>
	<kmss:auth requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=add" requestMethod="GET">
		<ul>
			<li><a title="我要分享文档" class="btn_share"  href="javascript:void(0)" ></a></li>
		</ul>
	</kmss:auth>
$}
</script>

<!-- 知识模板の带星星 -->
<script id="portlet_doc_star_tmpl" type="text/template">
{$
	<div class="title1"><h2>{% parameters.kms.title %}</h2></div>
	<div class="box2">
		<ul class="l_c l_c3">
$}
	for(ii=0;ii<data.docList.length;ii++){
{$	
		<li>
			<span style="float:right; margin-top:6px;display:inline-block;text-align:center; vertical-align:middle;">{%showStars(data.docList[ii].score||0)%}</span>
			<span class="date">{%data.docList[ii].docCreateTime%}</span>
			<span class="author">{%resetStrLength(data.docList[ii].docCreator,10)%}</span>
			<div><a class="a_classify" href="{%data.docList[ii].docCategoryUrl%}" target = "_blank" title="{%data.docList[ii].docCategory%}">[{%resetStrLength(data.docList[ii].docCategory,10)%}]</a>
			<a class="a_text" title="{%data.docList[ii].docSubject%}" target="_blank" href="{%data.docList[ii].fdUrl%}">{%resetStrLength(data.docList[ii].docSubject,20)%}</a></div>
		</li>
$}
	}
{$
		</ul>
	</div>
$}
</script>

<!-- 知识库推荐知识 -->
<script id="portlet_intro_doc_tmpl" type="text/template">
{$<div class="title1"><h2>{% parameters.kms.title %}</h2></div>
<div class="box2">
$}
if(data.docIntroList.length>0){
{$
	<dl class="dl_b dl_b2">
	<dt class="b">{%data.docIntroList[0].fdTopName%}</dt>
	<dd>{%resetStrLength(data.docIntroList[0].fdTopContent||'', 220)%}<a href="{%data.docIntroList[0].fdTopUrl%}" title="{%data.docIntroList[0].fdTopContent%}" target="_ ">[详情]</a></dd>
</dl>
<div>
	<h2 class="h2_4">{%parameters.kms.title%}</h2>
	<ul class="l_e l_e2 c">
$}
		for(j=0;j<data.docIntroList[0].relatedDocList.length;j++){
			var relatedDoc = data.docIntroList[0].relatedDocList[j];
			if(j<4){
				if(j%2==0 && j/2>0){
{$					
					<div style="clear:both"><div>
$}
				}
{$
					<li >
						<a href="{%relatedDoc.fdUrl%}" target="_blank" title="{%relatedDoc.fdName%}" >
							{%relatedDoc.fdName%}
						</a>
					</li>
$}
			}
		}
{$
</div>
$}
}
</script>

<!-- 最新知识模板 -->
<script id="portlet_doc_tmpl" type="text/template">
{$
	<div class="title1 c"><h2>{% parameters.kms.title %}</h2></div>
	<div class="box2">
		<ul class="l_c">
$}

for(i=0;i<data.docList.length;i++){
	{$	
		<li>
			<span class="date">{%data.docList[i].docCreateTime%}</span>
			<span class="author">{%resetStrLength(data.docList[i].docCreator,10)%}</span>
			<div><a class="a_classify" href="{%data.docList[i].docCategoryUrl%}" target = "_blank" title="{%data.docList[i].docCategory%}">[{%resetStrLength(data.docList[i].docCategory,10)%}]</a>
			<a class="a_text" title="{%data.docList[i].docSubject%}" target="_blank" href="{%data.docList[i].fdUrl%}">{%resetStrLength(data.docList[i].docSubject,20)%}</a></div>
		</li>
	$}
}
{$
		</ul>
	</div>
$}
</script>

<!-- 知识查询方式 -->
<script id="portlet_doc_filterList_tmpl" type="text/template">
{$
	<div class="title1"><h2>{% parameters.kms.title %}</h2></div>
	<div class="box2 box2_2">
		<ul class="l_e c" id="filterList">
$}

	for(var i=0;i<data.length;i++){
{$
		<li  style='width: 95px;' >
			<a href="${kmsBasePath}/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=index&filterConfigId={%data[i].fdId%}" target="_blank">{%resetStrLength(data[i].fdName,6)%}</a>
		</li>
$}
	}
{$		
		</ul>
	</div>
$}
</script>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>


<!-- 广告图片 -->
<script type="text/template" id="portlet_intro_pic_tmpl">
{$
    <div id="idTransformView" class="lunz">
			<ul id="idSlider">
$}
				for(i=0;i<data.docIntroList.length;i++){
{$
				 <li><a href="{%data.docIntroList[i].fdUrl%}" target="_blank" ><img border="0" height="215px" width="779px" alt="" src="{%data.docIntroList[i].fdImgUrl%}"></a></li>
$}
				}
{$
			</ul>
		<div class="mask_lz"></div>
      			<ul id="idIntro" class="intro">
$}
				for(i=0;i<data.docIntroList.length;i++){
{$
					<li style="display: none;"><h2 style="text-align:left"><a href="{%data.docIntroList[i].fdUrl%}" target="_blank">{%data.docIntroList[i].fdTopName%}</a></h2>
					<p>{%resetStrLength(data.docIntroList[i].fdTopContent||'',100)%}&nbsp;&nbsp;&gt;&gt;<a href="{%data.docIntroList[i].fdUrl%}" target="_blank" title="{%data.docIntroList[i].fdTopContent%}">[详情]</a></p>
					</li>
$}				
				}
{$
			</ul>
			<ul id="idNum">
$}
				for(i=0;i<data.docIntroList.length;i++){
{$
					<li class="current">{%i+1%}</li>
$}
				}
{$
			</ul>
	</div>
$}
</script>

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

<!-- 新书速递 -->
<script type="text/template" id="portlet_new_pic_tmpl">
{$        
	<ul class="imgLists">
$}
  			for(var i=0;i<data.docList.length;i++){
{$
			<li>
				<a href="{%data.docList[i].fdUrl%}" class="pic" target="_blank">
					<img src="{%data.docList[i].fdImgUrl%}" />
					<b class="{%data.docList[i].fdExtension%}"></b>
				</a>
				<h3><a href="{%data.docList[i].fdUrl%}" title="{%data.docList[i].docSubject%}" target="_blank"><div title="{%data.docList[i].docSubject%}" style="word-wrap:break-word;break-all;">{%resetStrLength(data.docList[i].docSubject, 19)%}</div></a></h3>
			</li>
$}
		    } 
{$
     </ul>      
     <a class="pre">‹</a>
     <a class="next">›</a>
$}
</script>
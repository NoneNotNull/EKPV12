<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!-- 最佳答案 -->
<script id="best_post_tmpl" type="text/template">
var bestPost = data.bestPost;
{$
	<h2 class="h2_7"></h2>
	<span class="best_content">
		<p >{%bestPost.docContent%}</p>
	</span>
	<div class="per_info">
		<ul class="l_e c">
			<span>回答者 : {%bestPost.posterName%}</span>
			<span class="grade">等级 : {%bestPost.bestPosterGrade%}</span>
		</ul>
	</div>
$}
</script>

<!-- 其他回复列表 -->
<script id="other_posts_list_tmpl" type="text/template">
	for(var i=0;i<data.itemList.length;i++){
		var post = data.itemList[i];
{$
	<div class="box6">
		<dl class="c">
			<dt class="doc_content">{%post.docContent%}</dt>
		</dl>

		<div class="per_info">
			<span>回答者 : {%post.fdPosterName%}</span>
$}
			if(post.flagSetBest){
{$
				<a href="javascript:void(0)" onclick="bestPost('{%post.fdId%}');" >
				<span class="beBest">置为最佳</span></a>
$}
			}
{$
			<span class="grade">等级 : {%post.fdPosterGrade%}</span>
		</div>
	</div>
$}
	}
</script>
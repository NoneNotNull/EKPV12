<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/kms/common/resource/jsp/tags.jsp"%>
<!doctype html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<%@ include file="/kms/common/resource/jsp/include_ekp.jsp" %>
<%@ include file="/kms/common/resource/jsp/include_kms.jsp" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/resource/js/common.js"></script>
<script src="${kmsResourcePath }/js/lib/jquery.js"></script>
<script src="${kmsResourcePath }/js/lib/json2.js"></script>
<script type="text/javascript">
	Com_IncludeFile("kms_tmpl.js", null, "js");
</script>
<script src="${kmsResourcePath }/js/kms_portlet.js"></script>
<script src="${kmsResourcePath }/js/kms_utils.js"></script>
<link href="${kmsThemePath }/public.css" rel="stylesheet" type="text/css" />
<script type="text/template" id="portlet_wiki_newest_tmpl">
{$
	
	<div class="box2">
		<ul class="l_c">
$}

for(i=0;i<data.newestWikis.length;i++){
	{$	
		<li>
			<span class="date">{%data.newestWikis[i].docCreateTime%}</span>
			<span class="author">{%data.newestWikis[i].creatorName%}</span>
			<div><a class="a_classify" href="{%data.newestWikis[i].docCategoryUrl%}" target = "_blank" title="{%data.newestWikis[i].categoryName%}">[{%resetStrLength(data.newestWikis[i].categoryName,10)%}]</a>
			<a class="a_text" title="{%data.newestWikis[i].docSubject%}" target="_blank" href="{%data.newestWikis[i].fdUrl%}">{%resetStrLength(data.newestWikis[i].docSubject,20)%}</a></div>
		</li>
	$}
}
{$
		</ul>
	</div>
$}
</script>


<kms:portlet title="最新词条"  id="newWiki" dataType="Bean" dataBean="kmsHomeWikiService" beanParm="{rowsize:15,s_method:\"getNewestWiki\",orderby:\"docCreateTime\",ordertype:\"down\",fdCategoryId :\"${param.fdCategoryId}\"}" template="portlet_wiki_newest_tmpl" ></kms:portlet>
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
<script id="portlet_doc_tmpl" type="text/template">
{$
	
	<div class="box2">
		<ul class="l_c">
$}

for(i=0;i<data.docList.length;i++){
	{$	
		<li>
			<span class="date">{%data.docList[i].docCreateTime%}</span>
			<span class="author">{%data.docList[i].docCreator%}</span>
			<div><a class="a_classify" href="{%data.docList[i].docCategoryUrl%}" target = "_blank" title="{%data.docList[i].docCategory%}">[{%data.docList[i].docCategory%}]</a>
			<a class="a_text" title="{%data.docList[i].docSubject%}" target="_blank" href="{%data.docList[i].fdUrl%}">{%data.docList[i].docSubject%}</a></div>
		</li>
	$}
}
{$
		</ul>
	</div>
$}
</script>
<kms:portlet title="最新知识" id="kmsLatestDocPortlet" dataType="Bean" dataBean="kmsDocKnowledgePortlet" beanParm="{rowsize:6,fdCategoryId:\"${ param.fdCategoryId}\",ordertype:\"down\",orderby:\"docCreateTime\"}" template="portlet_doc_tmpl"></kms:portlet>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/kms/common/resource/jsp/tags.jsp"%>
<!doctype html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<%@ include file="/kms/common/resource/jsp/include_ekp.jsp" %>
<%@ include file="/kms/common/resource/jsp/include_kms.jsp" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/resource/js/common.js"></script>
<script src="${KMSS_Parameter_ContextPath }kms/common/resource/js/lib/jquery.js"></script>
<script src="${KMSS_Parameter_ContextPath }kms/common/resource/js/lib/json2.js"></script>
<script type="text/javascript">
	Com_IncludeFile("kms_tmpl.js", null, "js");
</script>
<script src="${KMSS_Parameter_ContextPath }kms/common/resource/js/kms_portlet.js"></script>
<script src="${kmsResourcePath }/js/kms_utils.js"></script>
<link href="${kmsThemePath }/public.css" rel="stylesheet" type="text/css" />
<script id="portlet_doc_read_tmpl" type="text/template">
{$
	
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
<kms:portlet title="知识阅读排行" id="kmsReadCountMultidoc" dataType="Bean" dataBean="kmsHomeMultidocService" beanParm="{rowsize:6,s_method:\"findKnowledgeSortByReadCount\",fdCategoryId:\"${ param.fdCategoryId}\",ordertype:\"down\",orderby:\"docReadCount\"}" template="portlet_doc_read_tmpl"></kms:portlet>
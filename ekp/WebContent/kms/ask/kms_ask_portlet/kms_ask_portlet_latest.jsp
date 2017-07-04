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
<script type="text/template" id="portlet_lightBlue_ask_tmpl">
{$ <ul class="l_d m_t10"> $}
	for(i=0;i<data.topicList.length;i++){
		{$<li>
			<span class="answer_num"><em>{% data.topicList[i].fdReplyCount %}</em>&nbsp&nbsp回答</span>
			<span class={% data.topicList[i].fdStatus <= 0 ? 'state2': 'state' %} ></span>
			<span class="score">{% data.topicList[i].fdScore %}</span>
			<a href="{% data.topicList[i].fdUrl %}" target="_blank" title="{% data.topicList[i].docSubject %}">{% resetStrLength(data.topicList[i].docSubject,54) %}</a>
		</li>$}
	}
{$ </ul> $}
</script>


<kms:portlet title="最新问答" id="kmsLatestAskPortlet" cssStyle="height:340px" dataType="Bean" dataBean="kmsIAskDocPortlet" beanParm="{rowsize:10,s_method:\"getLatestAsk\"}" template="portlet_lightBlue_ask_tmpl"></kms:portlet>
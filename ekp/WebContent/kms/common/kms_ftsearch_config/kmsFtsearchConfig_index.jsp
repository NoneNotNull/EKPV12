<%@ include file="/kms/common/resource/jsp/index_top.jsp" %> 
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ include file="/sys/ui/jsp/jshead.jsp"%>
<%@ include file="kmsFtsearchConfig_index_js.jsp"%>
<%@ include file="kmsFtsearchConfig_index_tmpl.jsp"%>
<%@ include file="/sys/ftsearch/autocomplete_include.jsp" %>

<link style="text/css" rel="stylesheet" href="${LUI_ContextPath}/sys/ftsearch/styles/search.css">
<link href="${kmsContextPath}kms/common/kms_ftsearch_config/style/ftsearch.css" rel="stylesheet" type="text/css" />

<title>${model.title}</title>
<c:import url="/kms/common/resource/theme/default/template.jsp" charEncoding="UTf-8"></c:import>
</head>
<body>
<div id="search_wrapper">
<div id="search_head">
		<div class="box c" style="margin-left:170px">
			<a href="#" class="logo" title=""></a>
			<ul class="search_box" style="margin: 5px 0 0 30px;display:block;">
				<li class="range" id="lui_search">
					<%
					    JSONArray searchList = (JSONArray)request.getAttribute("searchList");
						for(int i=0;i<searchList.size();i++){%>
							<a href="#" id="range_a" <%=(i==searchList.size()-1?"class=none":"")%> rel="<%=((JSONObject)searchList.get(i)).get("modelClass") %>"><%=((JSONObject)searchList.get(i)).get("searchText") %></a>
					<% 	}
					%>
				</li>
				<li class="search" style="height:36px;margin-bottom:2px;">
					<input style="height:32px;" type="text" class="input_search" id="q5"  onkeydown="if (event.keyCode == 13 && this.value !='') onSearch();"
						value="${param.queryString}" onfocus="if(value=='请输入关键字'){value=''}" onblur="if(value==''){value='请输入关键字'}">
					<script>
			   			$(function() {
						     $("#q5").autocomplete({
						         source: function(request, response) {
						             $.ajax({
						                 url: "${KMSS_Parameter_ContextPath}sys/ftsearch/expand/sys_ftsearch_chinese_legend/sysFtsearchChineseLegend.do?method=searchTip&q="+encodeURI($("#q5").val()),
						                 dataType: "json",
						                 data: request,
						                 success: function(data) {
						                     response(data);
						                 }
						             });
						         }
						     });
						 });
					</script>
					<a style="height:33px;cursor:pointer;" id="ftSearchBtn" class="btn_search" title="${lfn:message('sys-ftsearch-db:search.ftsearch.button.search')}">
						<span>${lfn:message('sys-ftsearch-db:search.ftsearch.button.search')}</span>
					</a>
				</li>
				<li class="lui_hotword" style="margin-bottom:-10px;">
					<a href="#" class="title" title=""><span><em style="font-style: normal;">${lfn:message('sys-ftsearch-db:search.ftsearch.current.hot.search')}</em></span></a>
					<c:if test="${hotwordList!=null}">
						<div class="hotwordList">
							<c:forEach items="${hotwordList}" var="hotword"  varStatus="status">
							     <a href="#" onclick="searchWord(this)">${hotword}</a>				
							</c:forEach>
						
						</div>
					</c:if>
				</li>
				<li class="group">
					<c:if test="${not empty modelGroupList}">
						<c:forEach items="${modelGroupList}" var="element" varStatus="status">
							<input id='${element.fdId }' type="checkbox" value="${element.fdCategoryName}" name="modelGroups"
								onclick="selectModelGroup(this,'${element.fdCategoryModel}')" 
								<c:if test="${fn:contains(modelGroupChecked, element.fdCategoryName)}">
									checked
								</c:if>
							>&nbsp;&nbsp;${element.fdCategoryName}
						</c:forEach>	
					</c:if>
				</li>	
			</ul>
			<div style=" position: relative; width: 100%;">
				<input type="button" class="btn_return" onclick="window.location.href='${KMSS_Parameter_ContextPath}'" value="${lfn:message('sys-ftsearch-db:search.ftsearch.search.return')}"/>
			</div>
		</div>
	</div><!-- search_head end -->
</div>
<div id="wrapper">
	<div id="main" style="height:430px;width:80%" class="box c">
		<div style="float: right;margin: 0 0 0 -220px;width: 80%;">
			<div class="content2" style="min-height: 500px;">
				<div id="condition_result" class="condition_div"></div>
				<div class="div_sort_btn">
					<ul class="btn_box" style="width:304px";>
						<li><a href="#" id="time" onclick="sortResult(this)"
						class="btn_a" 
						title=""><span><em><bean:message bundle="sys-ftsearch-db" key="search.ftsearch.sort.by.time" /></em></span></a></li>
						<li><a href="#" id="score" onclick="sortResult(this)"
						class="btn_a_selected" 
						title=""><span><em><bean:message bundle="sys-ftsearch-db" key="search.ftsearch.sort.by.score" /></em></span></a></li>
					</ul>
					<p><bean:message bundle="sys-ftsearch-db" key="search.ftsearch.probably" />&nbsp;
						<span id="searchCount"></span>&nbsp;<bean:message bundle="sys-ftsearch-db" key="search.ftsearch.itemResult" />
					</p>
				</div>
				<div class="clear"></div>
				<kms:portlet title="搜索结果 " id="searchResult" dataType="Bean"
					dataBean="kmsFtsearchConfigPortlet"
					beanParm="{s_method:\"search\",pageno:1,rowsize:10,queryString:\"${param.queryString}\",selfModelName:\"${param.modelName}\"}" template="portlet_ftsearch_list_tmpl" callBack="KMS.listCallBack">
				</kms:portlet>
				<!-- 分页 -->
				<list:paging></list:paging>
				
				<div id="search_btn">
				</div>
			</div>
		</div>
		
		<div class="leftbar" id="ftSearchTree">
			<dl class="dl_b category_Tree" id="ftsearch_facet">
			</dl>
			<dl class="dl_b" id="field">
				<dt>搜索范围</dt>
				<dd><a href="#" onclick="selectByRange(this)"><input checked name="field" value="title;subject" type="checkbox" />&nbsp;标题</a></dd>
				<dd><a href="#" onclick="selectByRange(this)"><input checked name="field" value="content" type="checkbox" />&nbsp;内容</a></dd>
				<dd><a href="#" onclick="selectByRange(this)"><input checked name="field" value="attachment" type="checkbox" />&nbsp;附件</a></dd>
				<dd><a href="#" onclick="selectByRange(this)"><input checked name="field" value="creator" type="checkbox" />&nbsp;创建者</a></dd>
				<dd><a href="#" onclick="selectByRange(this)"><input checked name="field" value="tag" type="checkbox" />&nbsp;标签</a></dd>
			</dl>
			<div id="module" class="moduleRange"></div>
			<div id="category"></div>
			<div id="propertyText">
				<table id="TVN_10" cellpadding="0" cellspacing="0" border="0">
					<tbody><tr><td valign="middle" nowrap=""><a href="javascript:LKSTree2.ExpandNode(10)">
					<img src="/kms/resource/style/default/tree/openfolder.gif" border="0"></a></td>
					<td valign="middle" nowrap="">
						<a lks_nodeid="10" title="属性输入筛选" href="javascript:void(0)" >属性输入筛选</a>
					</td></tr>
					</tbody>
				</table>
			</div>
			<div id="property"></div>
			<dl class="dl_b" id="relevantWord">
				<dt><bean:message key="search.ftsearch.relate.word" bundle="sys-ftsearch-db" /></dt>
			</dl>
		</div>
		<form id="sysFtsearchReadLogForm" name="sysFtsearchReadLogForm"  action="<c:url value="/sys/ftsearch/expand/sys_ftsearch_read_log/sysFtsearchReadLog.do?method=save" />" method="post" target="_blank">
			<input id="fdDocSubject" name="fdDocSubject" type="hidden">
			<input id="fdModelName" name="fdModelName" type="hidden">
			<input id="fdCategory" name="fdCategory" type="hidden">
			<input id="fdUrl" name="fdUrl" type="hidden">
			<input id="fdSearchWord" name="fdSearchWord" type="hidden">
			<input id="fdHitPosition" name="fdHitPosition" type="hidden">
			<input id="fdModelId" name="fdModelId" type="hidden">
		</form>
	</div>
</div>
<%@ include file="/kms/common/resource/jsp/index_down.jsp" %> 
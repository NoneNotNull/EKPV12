<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.authorization.constant.ISysAuthConstant"%>
<script type="text/template" id="portlet_ftsearch_list_tmpl">
LUI.ready(
	function(){
		listPage(data.page.pageno,data.page.rowsize,data.page.totalrows);
});

var itemList = data.itemList;
$("#searchCount").text(data.page.totalrows);
$("#q5").val(data.query.queryString);
if(itemList && itemList.length>0){
{$
<div  class="lui_list_rowtable_summary_box" data-lui-mark='table.content.inside'>
$}
for (var i = 0; i < itemList.length; i ++) {
		var row = itemList[i];
	{$
	<dl class="lui_list_rowtable_summary_content_box">
		<dt>
		$}		
		if(row.fileName){
			var fileName = GetIconNameByFileName(row.title);
		{$
			<img src="${KMSS_Parameter_ResPath}style/common/fileIcon/{%fileName%}" height="16" width="16" border="0" />
		$}
		}
		{$	 
			<a onclick="readDoc('{%row.title%}','{%row.modelName%}','{%row.category%}','{%row.linkStr%}','{%row.systemName%}','0');" href="#" >
				{%row.subject%}
			</a>
		</dt>
		<dd>
			<span>
				{%row.content%}
			</span>
		</dd>
		<dd class="lui_list_rowtable_summary_content_box_foot_info">
			所属模块：{%row.modelName%}
			<span>|</span>
			<span>创建者：{%row.creator%}</span>
			<span>|</span>
		 	<span>创建时间：{%row.createTime%}</span>
		</dd>
	</dl>
	$}
}

var relevantWord =  data.relevantWord;
$("#relevantWord").empty();
$("#relevantWord").append("<dt><bean:message key='search.ftsearch.relate.word' bundle='sys-ftsearch-db' /></dt>");
if(relevantWord){
	for (var i = 0; i < relevantWord.length; i ++) {
		$("#relevantWord").append("<dd><a href='#' onclick='searchWord(this)'>"+relevantWord[i]+"</a></dd>");
	}
}

listPage(data.page.pageno,data.page.rowsize,data.page.totalrows);

}else{
{$
	<div class="search_con" style="height: 400px">
		<ul class="search_none">
			<li><h3><bean:message bundle="sys-ftsearch-db" key="sysFtsearchDb.sorry"/><span style="color: red">{%data.query.queryString%}</span><bean:message bundle="sys-ftsearch-db" key="sysFtsearchDb.about" />
			</h3></li>
			<li><bean:message bundle="sys-ftsearch-db" key="sysFtsearchDb.advice" /></li>
			<li><bean:message bundle="sys-ftsearch-db" key="sysFtsearchDb.checkWrong" /></li>
			<li><bean:message bundle="sys-ftsearch-db" key="sysFtsearchDb.deleteSome" /></li>
		</ul>
	</div>

$}
listPage(0,0,0);
}

$("#search_btn").html(KmsTmpl("portlet_search_tmpl").render({"data":data}));
$("#ftsearch_facet").html(KmsTmpl("portlet_ftsearch_facet_tmpl").render({"facets":data.facets}));
$("#condition_result").html(KmsTmpl("portlet_ftsearch_condition_tmpl").render({"conditions":data.conditionArray}));

</script>

<script type="text/template" id="portlet_ftsearch_facet_tmpl">
var itemList = facets;
{$
	<dt>类别</dt>
$}
	if(itemList[0].facetType=="category"){
	{$
		<dd><a href='#' onclick='comeBackFacet()'><span>返回任何类别</span></a></dd>
	$}
	}
	for (var i = 1; i < itemList.length; i ++) {
		var row = itemList[i];
		if(row.type=="model"){
{$
	<dd><a href='#' onclick='facetSearch(this.id)' id='{% row.modelName %}'>{% row.modelLabel %}&nbsp;<span>({% row.count %})</span></a></dd>
$}
		}else{
{$
	<dd><a href='#' onclick='facetSearch("{% row.modelName %}",this.id)' id='{% row.cagegoryName %}'>{% row.cagegoryLabel %}&nbsp;<span>({% row.count %})</span></a></dd>
$}
		}
	}

</script>
<script type="text/template" id="portlet_ftsearch_condition_tmpl">
var itemList = conditions;
var modelFilterHtml = showFilterHTML("module","模块");
var categoryFilterHtml = showFilterHTML("category","分类");
var propertyFilterHtml = showFilterHTML("property","属性");
var propertyTextHtml = showFilterProTextHTML("propertyText","属性");
{$
	<a href='#' onclick='comeBackFacet("all")'>全部</a>&nbsp;<span>›</span>
$}
	for (var i = 0; i < itemList.length; i ++) {
		var row = itemList[i];
		if(row.type=="model"){
{$
	<a href='#' onclick='deleteCondition(this.id,null,"modelName")' id='{% row.value %}'>{% row.name %}&nbsp;</a>
	<span>›</span>
$}
		}else if(row.type=="category"){
{$
	<a href='#' onclick='deleteCondition("{% row.modelName %}",this.id,"category")' id='{% row.value %}'>{% row.name %}&nbsp;</a>
	<span>›</span>
$}
		}else{
{$
		<span>"{% row.name %}"</span>
		{% modelFilterHtml %}
		{% categoryFilterHtml %}
		{% propertyFilterHtml %}
		{% propertyTextHtml %}
$}
		}
	}


</script>


<script id="kms_header_ftsearch" type="text/template">
{$ 
				<li class="range">
$}
				for(i=0;i<data.length;i++){
alert(data[i].searchText%});
	     			{$<a href="#" {%i==data.length-1?'class=none':''%} rel="{%data[i].modelClass%}">{%data[i].searchText%}</a>$}
				}
{$				
				</li>
$}

</script>
<script type="text/template" id="portlet_search_tmpl">

var itemList = data.itemList;
if(itemList && itemList.length>0){
	{$
		<div class="search_bottom" style="width:735px;height:33px; margin-top:50px;">
				<input type="text" class="input_search" name="queryString" value="{%data.query.queryString%}" style="height:29px!important;width:435px;"
					id="q6" onkeydown="if (event.keyCode == 13 && this.value !='') commitSearch();">
				<a style="height:33px!important;cursor:pointer;" class="btn_search" onclick="commitSearch();" title="<bean:message key="search.ftsearch.button.search" bundle="sys-ftsearch-db" />">
					<span><bean:message key="search.ftsearch.button.search" bundle="sys-ftsearch-db" /></span>
				</a>
				<a style="cursor:pointer;" href="#" class="btn_b" title="<bean:message key="search.ftsearch.search.on.result" bundle="sys-ftsearch-db" />" onclick="searchOnResult();"><span><em><bean:message key="search.ftsearch.search.on.result" bundle="sys-ftsearch-db" /></em></span></a>
		</div>
 	$}
}
</script>

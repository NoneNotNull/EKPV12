<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="java.util.Map"%>
<%@page import="com.landray.kmss.sys.portal.util.PortalUtil"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.landray.kmss.sys.ui.xml.model.SysUiPortlet"%>
<%@page import="java.util.Collection"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.landray.kmss.util.IDGenerator"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="title">选择portlet</template:replace>
	<template:replace name="body">
	<script>
		seajs.use(['theme!form']);
		function buttonSearch(){
			//LUI("sourceList");
			var keyword = LUI.$("#searchInput :text").val();
			seajs.use(['lui/topic'],function(topic){
				var topicEvent = {
						criterions : [],
						query : []
					};
				
				topicEvent.criterions.push({"key":"__keyword","value":[keyword]});
				topic.publish("criteria.changed", topicEvent);				
			});
		}
		LUI.ready(function(){
			buttonSearch();
		});

		function addWiki(){
				var categoryId = "${param.categoryId}" ;
				if(categoryId!=null && categoryId.length==32){
					window.open("<c:url value='${param.kmsCommonPushAction}&modelName=com.landray.kmss.kms.wiki.model.KmsWikiMain&fdModelId=${param.fdModelId}&fdCategoryId=${param.categoryId}'/>");
					window.parent.$dialog.hide();
					return false ;
				}
				seajs.use(['sys/ui/js/dialog'], function(dialog) {
					var create_url =  '${param.kmsCommonPushAction}&fdCategoryId=!{id}&modelName=com.landray.kmss.kms.wiki.model.KmsWikiMain&fdModelId=${param.fdModelId}&fdCategoryId=${param.categoryId}';
					dialog.simpleCategoryForNewFile(
						'com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory',
						create_url,
						false,
						function(rtn) {
							if (!true && !rtn){
								window.close();
							}
							window.parent.$dialog.hide();
						},
						null,
						LUI.$('input[name=docCategoryId]').val(),
						"_blank", 
						true, {
							'fdTemplateType': '2,3'
						}
					);
				});
		}
		function editWiki(){
			var wikiRadio =  LUI.$('input:radio[name="wikiRadio"]:checked').val();
			if(wikiRadio==null || wikiRadio.length<32){
				alert("${lfn:message('kms-wiki:kmsWikiMain.not.Choice.edit.wiki')}");
				return false ;
			}
			window.open("<c:url value='${param.kmsCommonPushAction}&flag=edit&modelName=com.landray.kmss.kms.wiki.model.KmsWikiMain&fdId='/>"+wikiRadio+"&fdModelId=${param.fdModelId}");
			window.parent.$dialog.hide();
		}
	</script>
	<html:form action="/kms/common/kms_common_push/kmsCommonDatapush.do">
	<div style="margin:20px auto;width:95%;">
		<div style="border: 1px #e8e8e8 solid;padding: 5px;">
				<table class="tb_noborder" style="width: 100%">
					<tr>
						<td width="100" style="text-align: center;">关键字</td>
						<td>
						
						<div id="searchInput" data-lui-type="lui/search_box!SearchBox">
							<script type="text/config">
							{
								placeholder: "请输入关键字查询",
								width: '90%'
							}
							</script>
							<ui:event event="search.changed" args="evt">
								buttonSearch();
							</ui:event>
						</div>
						</td>
						<td  style="text-align: center;padding-left:30px;vertical-align:middle;"> 
						<ui:button  text="${lfn:message('button.edit') }" order="2" onclick="editWiki();">
						</ui:button>
						</td>
						<c:if test="${param.categoryId == null}">
							<kmss:auth requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=add" requestMethod="GET">
								<td > 
									<ui:button  text="${lfn:message('button.add') }" order="2" onclick="addWiki();">
									</ui:button>
								</td>
							</kmss:auth>
						</c:if>
						<c:if test="${param.categoryId != null}">
							<kmss:auth requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=add&fdCategoryId=${param.categoryId}" requestMethod="GET">
								<td > 
									<ui:button  text="${lfn:message('button.add') }" order="2" onclick="addWiki();">
									</ui:button>
								</td>
							</kmss:auth>
						</c:if>
					</tr>
				</table>
			</div>	 
			<%-- &q.__module=<%= (moduleId == null ? "" : moduleId) %> --%>
			<div style="border: 1px #e8e8e8 solid;border-top-width: 0px;padding: 5px;height:430px;">
				<%--列表视图  --%>
		<list:listview id="listview">
			<ui:source type="AjaxJson">
				{url:'/kms/wiki/kms_wiki_main_index/kmsWikiMianIndex.do?method=pushList&categoryId=${param.categoryId}&rowsize=8&orderby=fdLastModifiedTime&ordertype=down'}
			</ui:source>
			<%-- 列表视图--%>
			<list:colTable layout="sys.ui.listview.columntable" name="columntable"
				rowHref="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=view&fdId=!{fdId}&id=!{fdFirstId}">
				<list:col-html title=" " headerStyle="width:5%" style="text-align:left;padding:0 8px">
					{$<input type="radio" name="wikiRadio" value="{%row['fdId']%}"/>$}
				</list:col-html>
				<list:col-serial title="${ lfn:message('page.serial') }" headerStyle="width:3%"></list:col-serial>	  
				<list:col-html title="${ lfn:message('kms-wiki:kmsWiki.list.subject')}" headerStyle="width:60%" style="text-align:left;padding:0 2px">
					if(row['docIsIntroduced']=='true') {
						{$
						<img src="${LUI_ContextPath}/kms/knowledge/resource/img/jing.gif" 
							border=0 title="${lfn:message('kms-knowledge:kmsKnowledge.introduced')}" />
						$}
					}
					{$
						<span class="com_subject">{%row['docSubject']%}</span>
					$}
				</list:col-html>
				<list:col-html headerStyle="width:10%" title="${lfn:message('kms-wiki:kmsWiki.list.author') }">
					{$	 
						{% row['docAuthor.fdName']%}
					 $}
				</list:col-html>
				<list:col-html headerStyle="width:20%" title="${lfn:message('kms-wiki:kmsWiki.list.fdLastModifiedTime') }">
					{$	 
						{% row['fdLastModifiedTime']%}
					 $}
				</list:col-html>
				
		<%--	   <list:col-html title="${lfn:message('kms-wiki:kmsWiki.list.category') }" >
			   		{$
						<span>{% strutil.textEllipsis(row['fdTemplateName'], 20) %}</span>
					$}	
			   </list:col-html>--%>
			</list:colTable>
			
			<list:gridTable name="gridtable" columnNum="4" gridHref="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=view&fdId=!{fdId}&id=!{fdFirstId}">
				<ui:source type="AjaxJson">
					{url:'/kms/wiki/kms_wiki_main_index/kmsWikiMianIndex.do?method=pushList&categoryId=${param.categoryId}&rowsize=8&listType=gridtable&orderby=fdLastModifiedTime&ordertype=down'}
				</ui:source>
				<list:row-template ref="sys.ui.listview.gridtable" >
				</list:row-template>
			</list:gridTable>
		</list:listview>
		<%-- 列表分页 --%>
				<div style="height: 10px;"></div>
				<list:paging layout="sys.ui.paging.simple"></list:paging>
			</div>
	</div>
	<html:hidden property="fdId" />
	<html:hidden property="docSubject" />
	<html:hidden property="docContent" />	
	</html:form>
	</template:replace>
</template:include>
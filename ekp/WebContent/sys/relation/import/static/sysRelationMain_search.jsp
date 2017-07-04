<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.landray.kmss.util.SpringBeanUtil"%>
<%@page import="com.landray.kmss.sys.ftsearch.db.service.ISysFtsearchConfigService"%>
<%@page import="com.landray.kmss.sys.relation.util.SysRelationUtil"%>
<%@page import="com.landray.kmss.common.actions.RequestContext"%>

<template:include ref="default.dialog">
	<template:replace name="content"> 
		<script type="text/javascript" >
			Com_IncludeFile("validator.jsp|validation.jsp|validation.js|plugin.js|jquery.js", null, "js");
			Com_IncludeFile("rela.css", Com_Parameter.ContextPath + "sys/relation/import/resource/","css",true);
		</script>
		<script type="text/javascript">
			
			function CommitSearch(){	
				var url ='/sys/relation/otherurl/ftsearch/searchBuilder.do?method=search&forward=resultUi';	 
				var queryString = $("input[name='queryString']").val();
				 $("input[name='fdResultFlag']").removeAttr("validate");
				 $("input[name='queryString']").attr("validate","required");
				if(!window.S_Valudator.validate()){
					return false;
				}
				url = Com_SetUrlParameter(url, "queryString",queryString);
				var modelName = $("select[name='modelName']").val();
				//如果选择了全系统，则按全系统搜索，否则按模块
				if("entireSystem" == modelName){
					url = Com_SetUrlParameter(url, "type", "1");
					url = Com_SetUrlParameter(url, "flag", "1");
				}else{
					url = Com_SetUrlParameter(url, "modelName", modelName);	
				}
				url = Com_SetUrlParameter(url, "rowsize", 10);
				seajs.use(['lui/base', 'lui/data/source', 'lui/util/env'], function(base,
						source, env) {
					var table = base.byId('rela_static_tab');
					table.redrawBySource(new source.AjaxJson({
						url :url,
						parent : table
					}));
				});
			}
			var s_returnCfg = null;
			var s_modelMap = {};
			function selectItem(thisObj,url){
				var selectObj = $(thisObj);
				if(selectObj.is(":checked")){
					var tdObj = selectObj.parents("td");
					var subject = tdObj.next("td").text();
					var config = {"fdName":subject,"fdLink":url};
					if(s_returnCfg==null)
						s_returnCfg={};
					s_returnCfg[url] = config;
				}else{
					if(s_returnCfg[url]!=null){
						s_returnCfg[url] = null;
					}
				}
			}
			function saveSelect(){
				$("input[name='fdResultFlag']").attr("validate","select_staic");
				$("input[name='queryString']").removeAttr("validate");
				if(!window.S_Valudator.validate()){
					$("input[name='queryString']").attr("validate","required");
					return;
				}	
				return s_returnCfg;
			}
			LUI.ready(function(){
					if(window.S_Valudator == null)
						window.S_Valudator = $GetKMSSDefaultValidation();
					window.S_Valudator.addValidator("select_staic",
							"${lfn:message('sys-relation:sysRelationMain.fdOtherUrl.selectTip')}",function(v,elem) {
						if(window.s_returnCfg==null) return false;
						var isNotNull = false; 
						for(var tmpKey in window.s_returnCfg){
							if(window.s_returnCfg[tmpKey]!=null){
								isNotNull = true;
								break;
							}
						}
						return isNotNull;
					});
					 $("input[name='queryString']").each(function(){
						 window.S_Valudator.addElements(this);
					 });
					 $("input[name='fdResultFlag']").each(function(){
						 window.S_Valudator.addElements(this);
					 });
				});
		</script>
		<%
			List modelList = new ArrayList();
			ISysFtsearchConfigService cfgService= (ISysFtsearchConfigService)SpringBeanUtil.getBean("sysFtsearchConfigService");
			modelList = cfgService.getListSearch(new RequestContext(request));
			modelList = SysRelationUtil.sortByChina(modelList, "title");
			request.setAttribute("modelList", modelList);// 模块列表
		%>
		<div class=rela_config_subset>
			<table class="tb_simple">
				<tr>
					<td>
						<bean:message bundle="sys-relation" key="sysRelationMain.staticPage.searchDilog1" />
						<select name="modelName" class="inputsgl">
							<option value="entireSystem"><bean:message bundle="sys-relation" key="sysRelationEntry.ftsearch.entireSystem" /></option>
							<c:forEach items="${modelList}" var="element" varStatus="status">
								<option value="${element['modelName']}" <c:if test="${currModelName eq element['modelName']}"> selected="selected" </c:if>>${element['title']}</option>
								<script type="text/javascript">
									s_modelMap['${element["modelName"]}']='${element["title"]}';
								</script>
							</c:forEach>
						</select>
						<bean:message bundle="sys-relation" key="sysRelationMain.staticPage.searchDilog2" />
					</td>
					<td>
						<div class="inputselectsgl" style="width:280px;margin-top: 8px;">
							<div class="input">
								<input type="text" name="queryString" validate="required" 
									subject="${lfn:message('sys-relation:sysRelationMain.fdDynamicUrl') }"/>
							</div>
							<div class="search" id="rela_static_search" onclick="CommitSearch();">
							</div>
						</div>
					</td>
				</tr>
				<tr><td width="100%" style="padding: 0px;" colspan="2">
					<list:listview channel="rela_static_channel" style="width:100%" >
						<ui:source type="AjaxJson">
							{"url":"/sys/relation/otherurl/ftsearch/searchBuilder.do?method=search&forward=resultUi"}
						</ui:source>
						<list:colTable isDefault="true" id="rela_static_tab" layout="sys.ui.listview.listtable" cfg-norecodeLayout="simple">
							<list:col-html style="width:10px;">
								var _link = row['link'];
								{$
									<input type="checkbox" onclick="selectItem(this,'{%_link%}');"/>
								$}
							</list:col-html>
							<list:col-html style="word-break:break-all;word-wrap:break-word;width:40%;" title="${lfn:message('sys-ftsearch-db:search.ftsearch.field.title')}">
								{$ {%row['subject']%} $}
							</list:col-html>
							<list:col-html style="width:15%"  title="${lfn:message('sys-ftsearch-db:search.search.creator')}">
								{$ {%row['creator']%} $}
							</list:col-html>
							<list:col-html style="width:15%" title="${lfn:message('sys-ftsearch-db:search.search.createDate')}">
								{$ {%row['created']%} $}
							</list:col-html>
							<list:col-html style="width:20%"  title="${lfn:message('sys-ftsearch-db:search.search.modelName')}">
								var _moduleName = row['moduleName'];
								if(_moduleName!=null && _moduleName!=''){
									_moduleName = _moduleName.substring(_moduleName.lastIndexOf('.')+1);
								}
								{$ {%s_modelMap[_moduleName]%} $}
							</list:col-html>
						</list:colTable>						
					</list:listview>
					<list:paging channel="rela_static_channel" layout="sys.ui.paging.simple"></list:paging>
				</td></tr>
				<tr><td colspan="2">
					<div style="display:none;">
						<!-- 此字段无实际意义，用作校验 -->
						<input type="text" name="fdResultFlag" value="" validate="select_staic"/>
					</div>
				</td></tr>
			</table>
		</div>
	</template:replace>
</template:include>

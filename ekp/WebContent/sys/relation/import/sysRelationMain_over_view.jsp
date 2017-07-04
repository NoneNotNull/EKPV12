<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="com.landray.kmss.sys.config.design.SysConfigs"%>
<%@page import="com.landray.kmss.sys.config.design.SysCfgRelation"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Map"%>
<template:include ref="default.simple" sidebar="no">
	<template:replace name="head">
		<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/sys/relation/import/resource/overView.css" />
		<template:super/>
		<script type="text/javascript">
			seajs.use(['theme!form' ]);
			Com_IncludeFile("rela_over_view.js","${KMSS_Parameter_ContextPath}sys/relation/import/resource/","js",true);
		</script>
	</template:replace>
	<template:replace name="title">
		${lfn:message('sys-relation:title.sysRelationMain.overView') }
	</template:replace>
	<template:replace name="body">
		<div>
			<table class="over_view_table">
				<tr>
					<td><span class="over_view_words">${lfn:message('sys-relation:sysRelationEntry.fdSearchScope')}</span>
						<select name="modelName" class="over_view_select" id="searchRange">
							<option value="allSystem">${lfn:message('sys-relation:relationOverView.search.entireSystem')}</option>
							<%
								Map relationsMap = SysConfigs.getInstance().getRelations();
								Iterator<String> iter = relationsMap.keySet().iterator();
								
								while (iter.hasNext()) {
								    String key = iter.next();
								    Object obj = relationsMap.get(key);
								    if(obj instanceof SysCfgRelation){
								    	String messageKey = ((SysCfgRelation) obj).getMessageKey();
								    	String mesg = ResourceUtil.getString(messageKey);
								    	String modelName = ((SysCfgRelation) obj).getModelName();
							%>
								<option value="<%=modelName%>"><%=mesg%></option>
							<% 
								    }
								}
							%>
							
						</select>
						<span style="margin-left:10px;">
							<span class="over_view_words">${lfn:message('sys-relation:relationOverView.search.object')}</span>
							<xform:radio property="fdSearchTarget" value="0" showStatus="edit">
		        				<xform:enumsDataSource enumsType="sysSearchTarget"></xform:enumsDataSource>		        			
		        			</xform:radio>
		        		</span>
					</td>
				</tr>
				<tr>
					<td>
	        			<span class="over_view_words">${lfn:message('sys-relation:relationOverView.source.subject')}</span>
	        			<input type="text" name="relateDocSubject" value="" class="inputsgl">
	        		</td>
	        		<td>
	        			<span><ui:button  text="${lfn:message('sys-relation:relationOverView.search')}" id="query_rela_btn" onclick="queryRelateDoc()"></ui:button>
	        			</span>
					</td>
				</tr>
			</table>
		</div>
		<div style="margin:20px;">
				<list:listview id="main_overView" channel="main">
				<ui:source type="AjaxJson">
					{url:'/sys/relation/sys_relation_main/sysRelationOverView.do?method=listOverView&rowsize=8'}
				</ui:source>
				<%--列表形式--%>
				<list:colTable layout="sys.ui.listview.columntable" name="columntable"
						rowHref="">
					<list:col-serial title="${ lfn:message('page.serial') }" headerStyle="width:5%"></list:col-serial>
					<list:col-html title="${lfn:message('sys-relation:relationOverView.source.doc2')}" style="width:40%;text-align:left;padding:0 8px">
					{$
						{%row['fdSourceDocSubject']%}
					$}
					</list:col-html>
					<list:col-html title="${lfn:message('sys-relation:relationOverView.related.doc')}" style="width:40%;text-align:left;padding:0 8px">
					{$
						{%row['fdRelatedDocSubject']%}
					$}
					</list:col-html>
					<list:col-auto props="fdRelatedType"></list:col-auto>
				</list:colTable>
				<ui:event topic="list.loaded" args="vt"> 
				</ui:event>
			</list:listview> 
		 	<list:paging channel="main"></list:paging>
		</div>
	</template:replace>
</template:include>
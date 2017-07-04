<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
		<list:criteria id="kmsMultidocCriteria" expand="true">	
			<c:if test="${empty TA}">
				<c:set var="TA" value="ta"/>
			</c:if>	
			<%--与ta相关--%>
			<list:cri-criterion title="${lfn:message(lfn:concat('kms-multidoc:kmsMultidoc.kmsMultidocKnowledge.zone.', TA))}" key="mydoc" multi="false">
				<list:box-select>
					<list:item-select cfg-defaultValue="myOriginal" cfg-required="true">
						<ui:source type="Static">
							[
							{text:"${lfn:message(lfn:concat('kms-multidoc:kmsMultidoc.zone.original.', TA)) }", value:'myOriginal'},
							{text:"${lfn:message(lfn:concat('kms-multidoc:kmsMultidoc.zone.create.', TA)) }", value: 'myCreate'},
							{text:"${lfn:message(lfn:concat('kms-multidoc:kmsMultidoc.zone.intro.', TA))}",value:'myIntro'},
							{text:"${lfn:message(lfn:concat('kms-multidoc:kmsMultidoc.zone.eva.', TA)) }",value:'myEva'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
		</list:criteria>
	     <div class="lui_list_operation">
					<div style="float:left;">
						${ lfn:message('list.orderType') }：
					</div>
					<%-- 排序--%>
					<div  style="float:left;padding-top: 3px;">
						<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" >
							<list:sort property="docPublishTime" text="${lfn:message('kms-multidoc:kmsMultidoc.kmsMultidocKnowledge.docPublishTime') }" group="sort.list"></list:sort>
							<list:sort property="docReadCount" text="${lfn:message('kms-multidoc:kmsMultidoc.kmsMultidocKnowledge.readCount') }" group="sort.list"></list:sort>
						</ui:toolbar>
					</div >
					<div style="float:right;padding-top: 3px;">
						<ui:toolbar count="3">
							<kmss:auth requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=add" requestMethod="GET">
								<ui:button text="${lfn:message('button.add')}" onclick="addDoc()" id="add_doc"></ui:button>
							</kmss:auth>
						</ui:toolbar>
					</div>	
		</div>
			<ui:fixed elem=".lui_list_operation"></ui:fixed>
		<%--list视图--%>
		<list:listview id="listview">
			<ui:source type="AjaxJson">
				{url:'/kms/multidoc/kms_multidoc_index/kmsMultidocKnowledgeIndex.do?method=listPerson&orderby=docPublishTime&ordertype=down&userId=${param.userId}&personType=other'}
			</ui:source>
			<%--列表形式--%>
			<list:colTable layout="sys.ui.listview.columntable" name="columntable"
			rowHref="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=view&fdId=!{fdId}">
					<%@ include file="/kms/multidoc/kms_multidoc_ui/kmsMultidocKnowledge_col_tmpl.jsp" %>
			</list:colTable>
		</list:listview> 
	 	<list:paging></list:paging>
	 	<script>
	 	//新建
		function addDoc() {
			seajs.use(['lui/dialog'], function(dialog) { 
				dialog
						.simpleCategoryForNewFile(
								'com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory',
								'/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=add&fdTemplateId=!{id}',
								false,null,null,'${param.categoryId}',null,null,{'fdTemplateType':'1,3'});
			});
		}

	   </script>
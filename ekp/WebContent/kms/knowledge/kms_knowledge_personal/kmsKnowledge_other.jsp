<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
		<list:criteria  expand="true">	
			<c:if test="${empty TA}">
				<c:set var="TA" value="ta"/>
			</c:if>	
			<%--与ta相关--%>
			<list:cri-criterion title="${lfn:message(lfn:concat('kms-knowledge:kmsKnowledge.', TA))}" 
								key="mydoc" 
								multi="false">
				<list:box-select>
					<list:item-select cfg-defaultValue="myCreate" cfg-required="true">
						<ui:source type="Static">
							[{text:"${lfn:message(lfn:concat('kms-knowledge:kmsKnowledge.create.', TA)) }", value: 'myCreate'},
							{text:"${lfn:message(lfn:concat('kms-knowledge:kmsKnowledge.original.', TA)) }", value:'myOriginal'},
							{text:"${lfn:message(lfn:concat('kms-knowledge:kmsKnowledge.intro.', TA))}",value:'myIntro'},
							{text:"${lfn:message(lfn:concat('kms-knowledge:kmsKnowledge.eva.', TA)) }",value:'myEva'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
			<%--知识模板 --%>
			<list:cri-criterion title="${lfn:message('kms-knowledge:kmsKnowledgeCategory.fdTemplateType') }" 
						key="template" 
						expand="false">
				<list:box-select >
					<list:item-select >
						<ui:source type="Static">
							[{text:'${ lfn:message('kms-knowledge:title.kms.multidoc') }', value:'1'},
									{text:'${ lfn:message('kms-knowledge:title.kms.wiki') }',value:'2'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
		</list:criteria>
	     <div class="lui_list_operation">
				<table width="100%">
					<tr>
						<td style='width: 70px;'>${ lfn:message('list.orderType') }：</td>
							<%-- 排序--%>
							<td>
								<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" > 
									<list:sort property="kmsKnowledgeBaseDoc.docPublishTime" 
											   text="${lfn:message('kms-knowledge:kmsKnowledge.docPublishTime') }" 
											   group="sort.list"/>
									<list:sort property="kmsKnowledgeBaseDoc.docReadCount" 
											   text="${lfn:message('kms-knowledge:kmsKnowledge.readCount') }" 
											   group="sort.list"/>	
								</ui:toolbar>
							</td>
							<td align="right">
								<ui:toolbar count="3">
									<kmss:auth requestURL="/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDoc.do?method=add" requestMethod="GET">
										<ui:button text="${lfn:message('button.add')}" onclick="addDoc()" id="add_doc"></ui:button>
									</kmss:auth>
								</ui:toolbar>
							</td>
					</tr>
				</table>
			</div>	
			
		<ui:fixed elem=".lui_list_operation"></ui:fixed>
		<list:listview id="listview">
			<ui:source type="AjaxJson">
				{url:'/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDocIndex.do?method=listPerson&orderby=docPublishTime&ordertype=down&rowsize=16&userId=${param.userId}&personType=other'}
			</ui:source>
			<%--列表形式--%>
			<list:colTable layout="sys.ui.listview.columntable" name="columntable"
				rowHref="/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDoc.do?method=view&fdId=!{fdId}&fdKnowledgeType=!{fdKnowledgeType}">
				<%@ include file="/kms/knowledge/kms_knowledge_ui/kmsKnowledge_col_tmpl.jsp"%>
			</list:colTable>
		</list:listview> 
	 	<list:paging></list:paging>
	 	<script>
			//新建
		function addDoc() {
			seajs.use(['kms/knowledge/kms_knowledge_ui/js/create'],function(create) {
				create.addDoc();
			});
		}
	   </script>
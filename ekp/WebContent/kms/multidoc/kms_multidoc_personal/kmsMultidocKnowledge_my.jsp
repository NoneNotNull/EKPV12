<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:criteria id="kmsMultidocCriteria" expand="true">		
			<%--与我相关--%>
			<list:cri-criterion title="${ lfn:message('kms-multidoc:kmsMultidoc.kmsMultidocKnowledge.zone.my') }" key="mydoc" multi="false">
				<list:box-select>
					<list:item-select cfg-defaultValue="myOriginal" cfg-required="true">
						<ui:source type="Static">
							[
							{text:"${lfn:message('kms-multidoc:kmsMultidoc.zone.original.my') }", value:'myOriginal'},
							{text:"${lfn:message('kms-multidoc:kmsMultidoc.zone.create.my') }", value: 'myCreate'},
							{text:"${lfn:message('kms-multidoc:kmsMultidoc.person.myApproval') }",value:'myApproval'},
							{text:"${lfn:message('kms-multidoc:kmsMultidoc.person.myApproved') }",value:'myApproved'},
							{text:"${lfn:message('kms-multidoc:kmsMultidoc.zone.intro.my') }",value:'myIntro'},
							{text:"${lfn:message('kms-multidoc:kmsMultidoc.person.IntroToMe') }",value:'myIntroTo'},
							{text:"${lfn:message('kms-multidoc:kmsMultidoc.zone.eva.my') }",value:'myEva'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
			<%--我的上传 状态--%>
			<list:cri-criterion title="文档状态" key="status" >
				<list:box-select>
					<list:item-select  id="c_status" >
						<ui:source type="Static">
								[{text:"${lfn:message('status.draft') }", value:'10'},
								{text:"${lfn:message('status.examine') }", value: '20'},
								{text:"${lfn:message('status.discard') }", value:'00'},  
								{text:"${lfn:message('status.refuse') }", value: '11'},
								{text:"${lfn:message('status.publish') }", value: '30'},
								{text:"${lfn:message('status.expire') }", value: '40'}
								]
						</ui:source>
				 </list:item-select>
			   </list:box-select>
			</list:cri-criterion>
			<%--我的已审 --%>
			<list:cri-criterion title="文档状态" key="_status" >
				<list:box-select>
					<list:item-select  id="c_status_myApproved" cfg-enable="false">
						<ui:source type="Static" >
								[
								{text:"${lfn:message('status.examine') }", value: '20'},
								{text:"${lfn:message('status.publish') }", value: '30'},
								{text:"${lfn:message('status.expire') }", value: '40'},
								{text:"${lfn:message('status.discard') }", value:'00'},  
								{text:"${lfn:message('status.refuse') }", value: '11'}
								]
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
								<list:sort property="docPublishTime" text="${lfn:message('kms-multidoc:kmsMultidoc.kmsMultidocKnowledge.docPublishTime') }" group="sort.list"></list:sort>
								<list:sort property="docReadCount" text="${lfn:message('kms-multidoc:kmsMultidoc.kmsMultidocKnowledge.readCount') }" group="sort.list"></list:sort>
							</ui:toolbar>
							</td>
						<td align="right">
							<ui:toolbar count="3">
								<kmss:auth requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=add" requestMethod="GET">
									<ui:button text="${lfn:message('button.add')}" onclick="addDoc()" id="add_doc"></ui:button>
								</kmss:auth>
								
								<kmss:auth requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=deleteall&status=${param.status}" requestMethod="GET">
									<ui:button text="${lfn:message('button.delete')}" onclick="delDoc()" id="delete_doc"></ui:button>
								</kmss:auth>
							</ui:toolbar>
						</td>
					</tr>
				</table>
			</div>	
			
			<ui:fixed elem=".lui_list_operation"></ui:fixed>
		<%--list视图--%>
		<list:listview id="listview">
			<ui:source type="AjaxJson">
				{url:'/kms/multidoc/kms_multidoc_index/kmsMultidocKnowledgeIndex.do?method=listPerson&orderby=docPublishTime&ordertype=down&rowsize=16'}
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
			//删除
			function delDoc() {
				var values = [];
				var selected;
				var select = document.getElementsByName("List_Selected");
				for (var i = 0; i < select.length; i++) {
					if (select[i].checked) {
						values.push(select[i].value);
						selected = true;
					}
				}
				if (selected) {
					seajs.use(['lui/dialog', 'lui/topic', 'lui/jquery', 'lui/util/env'],
							function(dialog, topic, $, env) {
								dialog.confirm("${lfn:message('page.comfirmDelete')}", function(flag, d) {
									if (flag) {
										var loading = dialog.loading();
										$.post(env.fn.formatUrl('/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=deleteall'),
												$.param({"List_Selected":values},true), function(data, textStatus,
																xhr) {
															if (data.status) {
																loading.hide();
																dialog.success("${lfn:message('kms-multidoc:kmsMultidoc.delete.success')}",
																		'#listview');
																topic.publish('list.refresh');
															} else {
																dialog.failure("${lfn:message('kms-multidoc:kmsMultidoc.delete.fail')}",
																		'#listview');
															}
														}, 'json');
									}
								});
							});
				} else {
					seajs.use(['lui/dialog'], function(dialog) {
								dialog.alert("${lfn:message('page.noSelect')}");
							});
				}
			}
			//隐藏掉删除按钮
			LUI.ready(function(){
				if(LUI('delete_doc')) {
					LUI('delete_doc').setVisible(false);
				}
			});


		   seajs.use(['lui/jquery','lui/topic','lui/toolbar'], function($, topic,toolbar) {
		 		topic.subscribe('criteria.changed',function(evt){
		 			if(LUI('delete_doc')) {
						LUI('delete_doc').setVisible(false);
					}
		 			for(var i=0; i<evt['criterions'].length; i++){
		 				if(evt['criterions'][i].key=="mydoc"){
		 					if(evt['criterions'][i].value[0]== "myCreate" ){
								//我创建的
		 						_setEnable('c_status',true);
								_setEnable('c_status_myApproved',false);
		 					}else if(evt['criterions'][i].value[0]== "myApproved" ) {
			 					//我已审批的
		 						_setEnable('c_status_myApproved',true);
		 						_setEnable('c_status',false);
			 				}
							else {
			 					_setEnable('c_status',false);
			 					_setEnable('c_status_myApproved',false);
				 			}
		 				}
		 				if (evt['criterions'][i].key == "status") {
			 				//只选择了草稿状态,出现删除按钮
 							if(evt['criterions'][i].value.length==1){
 								if(evt['criterions'][i].value[0]=="10"){
 									if( LUI('delete_doc') ) {
 	 									LUI('delete_doc').setVisible(true);
 	 								}
 								}
 							}
 					   }
	 				
		 			}
		 		});
		 	});
			//让筛选器隐藏显示
		 	function _setEnable(_id,status) {
		 		if(LUI(_id)){
						LUI(_id).setEnable(status);
				}
			 }

	   </script>
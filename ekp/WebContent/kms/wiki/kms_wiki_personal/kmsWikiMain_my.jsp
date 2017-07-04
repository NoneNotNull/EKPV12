<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%> 
<list:criteria id="kmsWikiCriteria" expand="true">		
			<%--与我相关--%>
			<list:cri-criterion title="${lfn:message('kms-wiki:kmsWikiMain.zone.my') }" key="_mydoc" multi="false">
				<list:box-select>
					<list:item-select cfg-defaultValue="myCreate" cfg-required="true">
						<ui:source type="Static">
							[{text:"${lfn:message('kms-wiki:kmsWikiMain.zone.create.my') }", value: 'myCreate'},
							{text:"${lfn:message('kms-wiki:kmsWikiMain.zone.perfect.my') }", value:'myEd'},
							{text:"${lfn:message('list.approval') }",value:'myApproval'},
							{text:"${lfn:message('list.approved') }",value:'myApproved'},
							{text:"${lfn:message('kms-wiki:kmsWikiMain.zone.intro.my') }",value:'myIntro'},
							{text:"${lfn:message('kms-wiki:kmsWikiMain.person.IntroToMe') }",value:'IntroToMe'},
							{text:"${lfn:message('kms-wiki:kmsWikiMain.zone.eva.my') }",value:'myEva'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
			<%--我的创建 状态--%>
			<list:cri-criterion title="${lfn:message('kms-wiki:kmsWikiMain.docStatus')}" key="docStatus" >
				<list:box-select>
					<list:item-select  id="c_status" >
						<ui:source type="Static">
								[{text:"${lfn:message('status.draft') }", value:'10'},
								{text:"${lfn:message('status.examine') }", value: '20'},
								{text:"${lfn:message('status.discard') }", value:'00'},  
								{text:"${lfn:message('status.refuse') }", value: '11'},
								{text:"${lfn:message('status.publish') }", value: '30'}
								]
						</ui:source>
				 </list:item-select>
			   </list:box-select>
			</list:cri-criterion>
			<%--我的已审 --%>
			<list:cri-criterion title="${lfn:message('kms-wiki:kmsWikiMain.docStatus')}" key="docStatus" >
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
					<td style='color: #979797;width: 45px;text-align: center'>
						${ lfn:message('kms-wiki:kmsWiki.list.orderType') }：
					</td>
					<%--排序按钮  --%>
					<td>
						<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" count="4">
							<list:sort property="docPublishTime" text="${lfn:message('kms-wiki:kmsWiki.list.orderDocPublishTime') }" group="sort.list"></list:sort>
							<list:sort property="fdLastModifiedTime" text="${lfn:message('kms-wiki:kmsWiki.list.fdLastModifiedTime') }" group="sort.list" value="down"></list:sort>
							<list:sort property="fdVersion" text="${lfn:message('kms-wiki:kmsWiki.rightInfo.addVersionTimes') }" group="sort.list"></list:sort>
							<list:sort property="docReadCount" text="${lfn:message('kms-wiki:kmsWiki.list.readCountTimes') }" group="sort.list"></list:sort>
						</ui:toolbar>
					</td>
					<%--操作按钮  --%>
					<td align="right">
						<ui:toolbar count="4">
							<kmss:auth requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=add" requestMethod="GET">
								<ui:button text="${lfn:message('button.add')}" onclick="addDoc()" order="1"></ui:button>
							</kmss:auth>
							<kmss:auth requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=deleteall&status=${param.status}&categoryId=${param.categoryId}&nodeType=${param.nodeType}" requestMethod="GET">
								<ui:button text="${lfn:message('button.delete')}" onclick="delDoc()" order="1" id="delete_doc"></ui:button>
							</kmss:auth>
						</ui:toolbar>
					</td>
				</tr>
			</table>
		</div>
		<ui:fixed elem=".lui_list_operation"></ui:fixed>
		<list:listview id="listview">
			<ui:source type="AjaxJson">
				{url:'/kms/wiki/kms_wiki_main_index/kmsWikiMianIndex.do?method=listPerson'}
			</ui:source>
			<list:colTable layout="sys.ui.listview.columntable" name="columntable"
				rowHref="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=view&fdId=!{fdId}&id=!{fdFirstId}">
				<%@ include file="/kms/wiki/kms_wiki_main_ui/kmsWikiMain_col_tmpl.jsp"  %>
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
							'/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=add&fdCategoryId=!{id}',
							false,null,null,'${param.categoryId}',null,null,{'fdTemplateType':'2,3'});
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
								$.ajax({
									url : env.fn.formatUrl('/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=deleteall'),
									cache : false,
									data : {"List_Selected":values},
									type : 'post',
									dataType :'json',
									success : function(data) {
										if (data.flag.success == "true") {
											loading.hide();
											dialog.success("${lfn:message('kms-multidoc:kmsMultidoc.delete.success')}",
													'#listview');
											topic.publish('list.refresh');
										} else {
											loading.hide();
											dialog.failure(data.errorMessage.error,'#listview');
										}
									},
									error : function(error) {
									}
								});
								
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
		 				if(evt['criterions'][i].key=="_mydoc"){
		 					if(evt['criterions'][i].value[0]== "myCreate" || evt['criterions'][i].value[0]== "myEd" ){
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
		 				if (evt['criterions'][i].key == "docStatus") {
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
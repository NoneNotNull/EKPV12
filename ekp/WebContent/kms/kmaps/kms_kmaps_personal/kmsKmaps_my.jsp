<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:criteria id="kmsKmapsCriteria" expand="true">		
			<%--与我相关--%>
			<list:cri-criterion title="${ lfn:message('kms-kmaps:km.kmap.person.my') }" key="_mydoc" multi="false">
				<list:box-select>
					<list:item-select cfg-defaultValue="myOriginal" cfg-required="true">
						<ui:source type="Static">
							[
							{text:"${lfn:message('kms-kmaps:km.kmap.original.my') }", value:'myOriginal'},
							{text:"${lfn:message('kms-kmaps:km.kmap.create.my') }", value: 'myCreate'},
							{text:"${lfn:message('kms-kmaps:km.kmap.approval.my') }",value:'myApproval'},
							{text:"${lfn:message('kms-kmaps:km.kmap.approved.my') }",value:'myApproved'},
							{text:"${lfn:message('kms-kmaps:km.kmap.eva.my') }",value:'myEva'},
							{text:"${lfn:message('kms-kmaps:km.kmap.intro.my') }",value:'myIntro'},
							{text:"${lfn:message('kms-kmaps:km.kmap.my.introToMe') }",value:'IntroToMe'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
			<%--我的上传 状态--%>
			<list:cri-criterion title="${lfn:message('kms-kmaps:km.kmap.docStatus') }" key="docStatus" >
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
			<list:cri-criterion title="${lfn:message('kms-kmaps:km.kmap.docStatus') }" key="_status" >
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
	     <%-- 按钮 --%>
		<div class="lui_list_operation">
			<table width="100%">
				<tr>
					<td style='color: #979797;width: 39px'>
						${lfn:message('kms-kmaps:km.kmap.listOrder')}：
					</td>
					<%--排序按钮  --%>
					<td>
						<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" count="4">
							<list:sort property="kmsKmapsMain.docReadCount" text="${lfn:message('kms-kmaps:km.kmap.readCount')}" group="sort.list"></list:sort>
						</ui:toolbar> 
					</td>
					<%--操作按钮  --%>
					<td align="right">
						<ui:toolbar count="3"> 
							<%-- 新增删除--%>
							<kmss:auth requestURL="/kms/kmaps/kms_kmaps_main/kmsKmapsMain.do?method=add" requestMethod="GET">
								<ui:button text="${lfn:message('button.add')}" onclick="addMaps()"></ui:button>
							</kmss:auth>
							<kmss:auth requestURL="/kms/kmaps/kms_kmaps_main/kmsKmapsMain.do?method=deleteall&status=${param.status}&categoryId=${param.categoryId}" requestMethod="GET">
								<ui:button text="${lfn:message('button.delete')}" onclick="delDoc()" id="delete_doc"></ui:button>
							</kmss:auth>
						</ui:toolbar>
					</td>
				</tr>
			</table>
		</div>
		
		<%--列表视图  --%>
		<list:listview id="listview">
			<ui:source type="AjaxJson">
				{url:'/kms/kmaps/kms_kmaps_index/kmsKmapsMainIndex.do?method=listPerson'}
			</ui:source>
			
			<%-- 列表视图--%>
			<list:colTable layout="sys.ui.listview.columntable" name="columntable"
				rowHref="/kms/kmaps/kms_kmaps_main/kmsKmapsMain.do?method=view&fdId=!{fdId}"> 
				<list:col-checkbox name="List_Selected" style="width:5%"></list:col-checkbox>
				<list:col-serial title="${ lfn:message('page.serial') }" headerStyle="width:5%"></list:col-serial>
				<list:col-html title="${ lfn:message('kms-kmaps:kmsKmapsMain.docSubject')}" headerStyle="width:40%" style="text-align:left;padding:0 8px">
					{$
						<span class="com_subject">{%row['docSubject']%}</span>
					$}
				</list:col-html>
				<list:col-html title="${ lfn:message('kms-kmaps:kmsKmapsMain.docCreator')}" >
					{$
						<span class="com_author">{%row['docCreator.fdName']%}</span>  
					$}
				</list:col-html>
				<list:col-auto props="docCategory.fdName;docCreateTime"></list:col-auto>
			</list:colTable>
			
		</list:listview>
		<%-- 列表分页 --%>
	 	<list:paging></list:paging>
<script>
//新建

function addMaps() {
	seajs.use(['lui/dialog'], function(dialog) {
		dialog
				.simpleCategoryForNewFile(
						'com.landray.kmss.kms.kmaps.model.KmsKmapsCategory',
						'/kms/kmaps/kms_kmaps_main/kmsKmapsMain.do?method=add&categoryId=!{id}',
						false,null,null,'${param.categoryId}');
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
							$.post(env.fn.formatUrl('/kms/kmaps/kms_kmaps_main/kmsKmapsMain.do?method=deleteall'),
									$.param({"List_Selected":values},true), function(data, textStatus,
													xhr) {
												if (data.status) {
													loading.hide();
													dialog.success("${lfn:message('kms-kmaps:kmsKmapsMain.delete.success')}",
															'#listview');
													topic.publish('list.refresh');
												} else {
													dialog.failure("${lfn:message('kms-kmaps:kmsKmapsMain.delete.fail')}",
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
	LUI.ready( function() {
		if (LUI('delete_doc')) {
			LUI('delete_doc').setVisible(false);
		}
	});


	seajs.use( [ 'lui/jquery', 'lui/topic', 'lui/toolbar' ], function($, topic,
			toolbar) {
		topic.subscribe('criteria.changed', function(evt) {
			if (LUI('delete_doc')) {
				LUI('delete_doc').setVisible(false);
			}
			for ( var i = 0; i < evt['criterions'].length; i++) {
				if (evt['criterions'][i].key == "_mydoc") {
					if (evt['criterions'][i].value[0] == "myCreate") {
						//我创建的
				_setEnable('c_status', true);
				_setEnable('c_status_myApproved', false);
			} else if (evt['criterions'][i].value[0] == "myApproved") {
				//我已审批的
				_setEnable('c_status_myApproved', true);
				_setEnable('c_status', false);
			} else {
				_setEnable('c_status', false);
				_setEnable('c_status_myApproved', false);
			}
		}
		if (evt['criterions'][i].key == "docStatus") {
			//只选择了草稿状态,出现删除按钮
			if (evt['criterions'][i].value.length == 1) {
				if (evt['criterions'][i].value[0] == "10") {
					if (LUI('delete_doc')) {
						LUI('delete_doc').setVisible(true);
					}
				}
			}
		}
	}
}		);
	});
	//让筛选器隐藏显示
	function _setEnable(_id, status) {
		if (LUI(_id)) {
			LUI(_id).setEnable(status);
		}
	}
</script>

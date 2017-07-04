<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/portal/portal.tld"
	prefix="portal"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="title">
		<c:out value="${ lfn:message('sys-filestore:filestore.moduleName') }"></c:out>
	</template:replace>
	<template:replace name="body">
		<div style="margin: 0 auto; width: 95%"><%-- 筛选器 --%> <list:criteria
			id="criteria1">
			<list:cri-auto
				modelName="com.landray.kmss.sys.filestore.model.SysFileConvertQueue"
				property="fdConverterKey;fdConvertNumber" expand="true" />
			<list:cri-criterion
				title="${lfn:message('sys-filestore:convertQueue.status')}"
				key="fdConvertStatus" expand="true">
				<list:box-select>
					<list:item-select cfg-defaultValue="30">
						<ui:source type="Static">
							[
							{text:'${ lfn:message('sys-filestore:convertStatus.0') }', value:0},
							{text:'${ lfn:message('sys-filestore:convertStatus.2') }', value:2},
							{text:'${ lfn:message('sys-filestore:convertStatus.3') }',value:3},
							{text:'${ lfn:message('sys-filestore:convertStatus.5') }',value:5},
							{text:'${ lfn:message('sys-filestore:convertStatus.6') }',value:6},
							{text:'${ lfn:message('sys-filestore:convertStatus.4') }',value:4}
							]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
		</list:criteria> <!-- 排序 -->
		<div class="lui_list_operation">
		<table width="100%">
			<tr>
				<td class="lui_sort">${ lfn:message('list.orderType') }：</td>
				<td><ui:toolbar layout="sys.ui.toolbar.sort" style="float:left"
					count="6">
					<list:sort property="fdCreateTime"
						text="${lfn:message('sys-filestore:convertQueue.inQueueTime')}"
						group="sort.list"></list:sort>
					<list:sort property="fdStatusTime"
						text="${lfn:message('sys-filestore:convertQueue.statusTime')}"
						group="sort.list"></list:sort>
				</ui:toolbar></td>
				<td align="right"><ui:toolbar count="2" id="btnToolBar">
					<kmss:auth
						requestURL="/sys/filestore/sys_filestore_queue/sysFileConvertQueue.do?method=reDistribute"
						requestMethod="GET">
						<ui:button
							text="${lfn:message('sys-filestore:button.reAllDistribute')}"
							onclick="reAllDistribute();" order="1"></ui:button>
					</kmss:auth>
					<kmss:auth
						requestURL="/sys/filestore/sys_filestore_queue/sysFileConvertQueue.do?method=reDistribute"
						requestMethod="GET">
						<ui:button
							text="${lfn:message('sys-filestore:button.reDistribute')}"
							onclick="reDistribute();" order="1"></ui:button>
					</kmss:auth>
				</ui:toolbar></td>
			</tr>
		</table>
		</div>

		<ui:fixed elem=".lui_list_operation"></ui:fixed> <list:listview
			id="listview">
			<ui:source type="AjaxJson">
					{url:'/sys/filestore/sys_filestore_queue/sysFileConvertQueue.do?method=data'}
			</ui:source>
			<list:colTable isDefault="false" layout="sys.ui.listview.columntable"
				onRowClick="viewConvertLog('!{fdId}')" name="columntable">
				<list:col-html
					title="<input type='checkbox' value='' name='List_Tongle' onclick='selectAll(this);' />">
				if(row['fdConvertStatus']=="${ lfn:message('sys-filestore:convertStatus.3') }"||row['fdConvertStatus']=="${ lfn:message('sys-filestore:convertStatus.5') }"||row['fdConvertStatus']=="${ lfn:message('sys-filestore:convertStatus.6') }"){
					{$
					<input type='checkbox' value='{%row.fdId%}' name='List_Selected' />
					$}
				}
				</list:col-html>
				<list:col-serial></list:col-serial>
				<list:col-auto
					props="fdAttMainId;fdModule;fdFileExtName;fdConverterKey;fdConvertNumber;fdConvertStatus;fdStatusTime;fdCreateTime"></list:col-auto>
			</list:colTable>

		</list:listview> <list:paging></list:paging> <script
			src="${ LUI_ContextPath }/sys/ui/extend/template/module/list.js?s_cache=${LUI_Cache}"></script>
		<script type="text/javascript">
	seajs.use( [ 'theme!list', 'theme!portal' ]);

	function selectAll(obj) {
		var failures = document.getElementsByName("List_Selected");
		for ( var i = 0; i < failures.length; i++) {
			var failure = failures[i];
			failure.checked = obj.checked;
		}
	}

	var otherFailure = true;
	var asposeFailure = false;
	var timeoutFailure = false;

	function getChoosedFailureType() {
		var choosedFailureType = "";
		if (otherFailure) {
			choosedFailureType += "3;";
		}
		if (asposeFailure) {
			choosedFailureType += "5;";
		}
		if (timeoutFailure) {
			choosedFailureType += "6;";
		}
		if (choosedFailureType.length > 0) {
			choosedFailureType = choosedFailureType.substring(0,
					choosedFailureType.length - 1);
		}
		if(choosedFailureType==""){
			return [];
		}
		return choosedFailureType.split(";");
	}

	function failureClick(obj) {
		if (obj.checked) {
			if (obj.value == 3) {
				otherFailure = true;
			}
			if (obj.value == 5) {
				asposeFailure = true;
			}
			if (obj.value == 6) {
				timeoutFailure = true;
			}
		} else {
			if (obj.value == 3) {
				otherFailure = false;
			}
			if (obj.value == 5) {
				asposeFailure = false;
			}
			if (obj.value == 6) {
				timeoutFailure = false;
			}
		}
	}

	function viewConvertLog(queueId) {
		seajs
				.use(
						'lui/dialog',
						function(dialog) {
							dialog
									.iframe(
											'/sys/filestore/sys_filestore_queue/sysFileConvertLog.do?method=viewLog&queueId=' + queueId,
											'转换日志', function() {
											}, {
												width : 760,
												height : 460
											});
						});
	}

	seajs
			.use(
					[ 'lui/dialog', 'lui/topic' ],
					function(dialog, topic) {
						window.reDistribute = function() {
							var values = [];
							$("input[name='List_Selected']:checked").each(
									function() {
										values.push($(this).val());
									});
							if (values.length == 0) {
								dialog
										.alert('<bean:message key="page.noSelect"/>');
								return;
							}
							dialog
									.confirm(
											'<bean:message key="sys-filestore:confirm.redistribute"/>',
											function(value) {
												if (value == true) {
													window.del_load = dialog
															.loading();
													$
															.post(
																	'<c:url value="/sys/filestore/sys_filestore_queue/sysFileConvertQueue.do?method=reDistribute"/>',
																	$
																			.param(
																					{
																						"Redistribute_All" : "false",
																						"List_Selected" : values
																					},
																					true),
																	reDisCallback,
																	'json');
												}
											});
						};

						window.reAllDistribute = function() {
							var reDistributeType = [];
							dialog
									.confirm(
											'<input type="checkbox" name="convert_failure" value="3" checked="true" onclick="failureClick(this);" />其他失败 <input type="checkbox" name="convert_failure" value="5" onclick="failureClick(this);" />aspose失败 <input type="checkbox" name="convert_failure" value="6" onclick="failureClick(this);" />超时失败<br/>',
											function(value) {
												if (value == true) {
													reDistributeType = getChoosedFailureType();
													window.del_load = dialog
															.loading();
													$
															.post(
																	'<c:url value="/sys/filestore/sys_filestore_queue/sysFileConvertQueue.do?method=reDistribute"/>',
																	$
																			.param(
																					{
																						"Redistribute_All" : "true",
																						"Convert_Failure" : reDistributeType
																					},
																					true),
																	reDisCallback,
																	'json');
												}
											});
						};

						window.reDisCallback = function(data) {
							if (window.del_load != null)
								window.del_load.hide();
							if (data != null && data.status == true) {
								topic.publish("list.refresh");
								dialog
										.success('<bean:message key="return.optSuccess" />');
							} else {
								dialog
										.failure('<bean:message key="return.optFailure" />');
							}
						};
					});
</script></div>
	</template:replace>
</template:include>
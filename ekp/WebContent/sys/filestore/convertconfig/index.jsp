<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/portal/portal.tld"
	prefix="portal"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="title">
		<c:out value="转换配置"></c:out>
	</template:replace>
	<template:replace name="body">
		<div style="margin: 0 auto; width: 95%"><%-- 筛选器 --%> <list:criteria
			id="criteria1">
			<list:cri-auto
				modelName="com.landray.kmss.sys.filestore.model.SysFileConvertConfig"
				property="fdFileExtName;fdModelName;fdConverterKey" expand="true" />
		</list:criteria> <!-- 排序 -->
		<div class="lui_list_operation">
		<table width="95%">
			<tr>
				<td class="lui_sort">${ lfn:message('list.orderType') }：</td>
				<td><ui:toolbar layout="sys.ui.toolbar.sort" style="float:left"
					count="6">
					<list:sort property="fdFileExtName" text="文档扩展名" group="sort.list"></list:sort>
				</ui:toolbar></td>
				<td align="right"><ui:toolbar count="3" id="btnToolBar">
					<kmss:auth
						requestURL="/sys/filestore/sys_filestore_queue/sysFileConvertConfig.do?method=edit"
						requestMethod="GET">
						<ui:button
							text="${lfn:message('sys-filestore:button.exportinitialdata')}"
							onclick="exportInitialData();" order="2"></ui:button>
					</kmss:auth>
					<kmss:auth
						requestURL="/sys/filestore/sys_filestore_queue/sysFileConvertConfig.do?method=add"
						requestMethod="GET">
						<ui:button text="${lfn:message('button.add')}"
							onclick="addConvertConfig();" order="2"></ui:button>
					</kmss:auth>
					<kmss:auth
						requestURL="/sys/filestore/sys_filestore_queue/sysFileConvertConfig.do?method=edit"
						requestMethod="GET">
						<ui:button text="${lfn:message('button.edit')}"
							onclick="editConvertConfig();" order="3"></ui:button>
					</kmss:auth>
					<kmss:auth
						requestURL="/sys/filestore/sys_filestore_queue/sysFileConvertConfig.do?method=deleteall"
						requestMethod="GET">
						<ui:button text="${lfn:message('button.delete')}"
							onclick="deleteConvertConfigs();" order="4"></ui:button>
					</kmss:auth>
				</ui:toolbar></td>
			</tr>
		</table>
		</div>

		<ui:fixed elem=".lui_list_operation"></ui:fixed>
		<form
			action="${LUI_ContextPath }/sys/datainit/sys_datainit_main/sysDatainitMain.do?method=export&formName=sysFileConvertConfigForm"
			name="sysFileConvertConfigForm" method="post"><list:listview
			id="listview">
			<ui:source type="AjaxJson">
					{url:'/sys/filestore/sys_filestore_queue/sysFileConvertConfig.do?method=data'}
			</ui:source>
			<list:colTable isDefault="false" layout="sys.ui.listview.columntable"
				name="columntable" onRowClick="editConvertConfig('!{fdId}')">
				<list:col-checkbox></list:col-checkbox>
				<list:col-serial></list:col-serial>
				<list:col-auto
					props="fdFileExtName;fdModelName;fdConverterKey;fdDispenser"></list:col-auto>
			</list:colTable>

		</list:listview> <list:paging></list:paging></form>
		<script
			src="${ LUI_ContextPath }/sys/ui/extend/template/module/list.js?s_cache=${LUI_Cache}"></script>
		<script type="text/javascript">
	seajs.use( [ 'theme!list', 'theme!portal' ]);
	seajs
			.use(
					[ 'lui/dialog', 'lui/topic' ],
					function(dialog, topic) {
						window.addConvertConfig = function() {
							dialog
									.iframe(
											'/sys/filestore/sys_filestore_queue/sysFileConvertConfig.do?method=add',
											'新增转换配置', function() {
											}, {
												width : 990,
												height : 560
											});
						};

						window.editConvertConfig = function(fdId) {
							var values = [];
							if (fdId != null) {
								values.push(fdId);
							} else {
								$("input[name='List_Selected']:checked").each(
										function() {
											values.push($(this).val());
										});
								if (values.length == 0) {
									dialog
											.alert('<bean:message key="page.noSelect"/>');
									return;
								}
								if (values.length > 1) {
									dialog.alert('不能同时编辑多项');
									return;
								}
							}
							dialog
									.iframe(
											'/sys/filestore/sys_filestore_queue/sysFileConvertConfig.do?method=edit&fdId=' + values[0],
											'修改转换配置', function() {
											}, {
												width : 990,
												height : 560
											});
						};

						window.deleteConvertConfigs = function() {
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
											'<bean:message key="page.comfirmDelete"/>',
											function(value) {
												if (value == true) {
													window.del_load = dialog
															.loading();
													$
															.post(
																	'<c:url value="/sys/filestore/sys_filestore_queue/sysFileConvertConfig.do?method=deleteall"/>',
																	$
																			.param(
																					{
																						"List_Selected" : values
																					},
																					true),
																	delCallback,
																	'json');
												}
											});
						};
						window.delCallback = function(data) {
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

						window.exportInitialData = function() {
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
							var exportForm = document
									.getElementsByName("sysFileConvertConfigForm")[0];
							exportForm.submit();
						};
					});
</script></div>
	</template:replace>
</template:include>
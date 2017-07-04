<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/kmss.tld" prefix="kmss"%>

<!-- 地图模版新建 -->
<kmss:auth requestURL="/kms/kmaps/kms_kmaps_template/kmsKmapsTemplate.do?method=add" requestMethod="GET">
	<script>
	function addMaps() {
		seajs.use(['lui/dialog'], function(dialog) {
			dialog
					.simpleCategoryForNewFile(
							'com.landray.kmss.kms.kmaps.model.KmsKmapsTemplCategory',
							'/kms/kmaps/kms_kmaps_template/kmsKmapsTemplate.do?method=add&categoryId=!{id}',
							false,null,null,'${param.categoryId}');
		});
	}
	</script>
	<ui:button text="${lfn:message('button.add')}" onclick="addMaps()"></ui:button>
</kmss:auth>

<!-- 地图模版删除 -->
<kmss:auth requestURL="/kms/kmaps/kms_kmaps_template/kmsKmapsTemplate.do?method=deleteall&status=${param.status}&categoryId=${param.categoryId}" requestMethod="GET">
	<script>
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
									$.post(env.fn.formatUrl('/kms/kmaps/kms_kmaps_template/kmsKmapsTemplate.do?method=deleteall&categoryId=${param.categoryId}'),
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
	</script>
	<ui:button text="${lfn:message('button.delete')}" onclick="delDoc()"></ui:button>
</kmss:auth>

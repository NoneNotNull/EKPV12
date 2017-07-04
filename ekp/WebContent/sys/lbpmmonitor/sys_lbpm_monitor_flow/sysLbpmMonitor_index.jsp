<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ page import="com.landray.kmss.sys.config.design.SysConfigs,com.landray.kmss.sys.simplecategory.model.ISysSimpleCategoryModel"%>
<template:include ref="default.simple">
	<template:replace name="head">
		<template:super />
		<style type="text/css">
		html,body {
			height: 100%;
		}
		</style>
		<script type="text/javascript">
			seajs.use(['theme!list', 'theme!portal']);	
		</script>
		<script
			src="${ LUI_ContextPath }/sys/ui/extend/template/module/list.js?s_cache=${LUI_Cache}"></script>
	</template:replace>
	<template:replace name="body">
		<div id="tbody-view" style="padding: 10px">
			<table style="width: 100%">
				<tr>
					<td valign="top">
						<c:if test="${param.method != 'getRecentHandle'}">
									<list:criteria id="criteria1" expand="false">
										<%--分类导航--%>
										<c:if test="${not empty param.modelName }">
											<%
												String modelName = request.getParameter("modelName");
												String templateModelName = SysConfigs.getInstance().getFlowDefByMain(modelName).getTemplateModelName();
												Class clazz = Class.forName(templateModelName);
												boolean isSimpleCategory = ISysSimpleCategoryModel.class.isAssignableFrom(clazz);
												pageContext.setAttribute("templateModelName", templateModelName);
												pageContext.setAttribute("isSimpleCategory", isSimpleCategory);
											%>
											<c:if test="${isSimpleCategory}">
												<list:cri-ref ref="criterion.sys.simpleCategory"
													key="simpleCategory" multi="false"
													title="${lfn:message('sys-lbpmmonitor:sysLbpmMonitor.flow.categoryNav') }"
													expand="true">
													<list:varParams modelName="${templateModelName}" />
												</list:cri-ref>
											</c:if>
											<c:if test="${!isSimpleCategory}">
												<list:cri-ref ref="criterion.sys.category" key="docCategory"
													multi="false"
													title="${lfn:message('sys-lbpmmonitor:sysLbpmMonitor.flow.categoryNav') }"
													expand="true">
													<list:varParams modelName="${templateModelName}" />
												</list:cri-ref>
											</c:if>
										</c:if>
										<c:if test="${param.fdType!='finish'}">
											<%--当前处理人--%>
											<list:cri-ref ref="criterion.sys.person"
												key="fdCurrentHandler" multi="false"
												title="${lfn:message('sys-lbpmmonitor:sysLbpmMonitor.flow.currentHandler') }" />
										</c:if>
										<%--创建者--%>
										<list:cri-ref ref="criterion.sys.person" key="fdCreator"
											multi="false"
											title="${lfn:message('sys-lbpmmonitor:sysLbpmMonitor.flow.docAuthor') }" />
										<%--创建时间--%>
										<list:cri-ref ref="criterion.sys.calendar" key="fdCreateTime"
											title="${lfn:message('sys-lbpmmonitor:sysLbpmMonitor.flow.docAuthorTime') }" />
									</list:criteria>
								</c:if>
								<!-- 排序 -->
								<c:if test="${param.method != 'getRecentHandle'}">
								<div class="lui_list_operation">
									<table width="100%">
										<tr>
											<td class="lui_sort">${ lfn:message('list.orderType') }：</td>
											<td><ui:toolbar layout="sys.ui.toolbar.sort"
													style="float:left" count="6">
													<list:sort property="fdCreateTime"
														text="${lfn:message('sys-lbpmmonitor:sysLbpmMonitor.order.creatorTime')}"
														group="sort.list" value="down"></list:sort>
													<list:sort property="fdStatus"
															text="${lfn:message('sys-lbpmmonitor:sysLbpmMonitor.order.status')}"
															group="sort.list"></list:sort>
													</ui:toolbar>
											</td>
											<td align="right"> 
												<c:if test="${param.fdType=='running' || param.fdType=='error' || param.method=='getInvalidHandler'}">
													<ui:toolbar id="Btntoolbar">
														<ui:button id="privilBtn"
															text="${lfn:message('sys-lbpmmonitor:button.batchModifyHandler')}"
															onclick="batchModifyHandler('${group.fdUrl}')" order="1"></ui:button>
													</ui:toolbar>
												</c:if> 
												<c:if test="${param.fdType=='error'}">
													<ui:toolbar id="Btntoolbar">
														<ui:button id="privilBtn"
															text="${lfn:message('sys-lbpmmonitor:button.batchPrivi')}"
															onclick="batchPrivil()" order="2"></ui:button>
													</ui:toolbar>
												</c:if></td>

										</tr>
									</table>
								</div>
								</c:if>
								<ui:fixed elem=".lui_list_operation"></ui:fixed>
								<list:listview id="listview">
									<ui:source type="AjaxJson">
													{url:'/sys/lbpmmonitor/sys_lbpmmonitor_flow/SysLbpmMonitorFlow.do?method=${param.method}&modelName=${param.modelName }&fdStatus=${param.fdStatus}&fdType=${param.fdType}'}
											</ui:source>
									<list:colTable isDefault="false"
										layout="sys.ui.listview.columntable"
										rowHref="/sys/lbpmmonitor/sys_lbpmmonitor_flow/SysLbpmMonitorFlow.do?method=view&fdId=!{fdId}&fdModelName=!{fdModelName}"
										name="columntable">
										<list:col-checkbox></list:col-checkbox>
										<list:col-serial></list:col-serial>
										<list:col-auto props=""></list:col-auto>
									</list:colTable>
								</list:listview>
								<c:if test="${param.method != 'getRecentHandle'}">
								<list:paging></list:paging>
								</c:if>
								<script>
								//批量特权操作
								function batchPrivil() {
									var selected;
									var select = document.getElementsByName("List_Selected");
									for ( var i = 0; i < select.length; i++) {
										if (select[i].checked) {
											selected = true;
											break;
										}
									}
									if (selected) {
										var url = '/sys/lbpmmonitor/sys_lbpm_monitor_flow/batchPirvil_flow.jsp';
										seajs.use([ 'lui/dialog', 'lui/topic' ], function(dialog, topic) {
											dialog.iframe(url,
													"${lfn:message('sys-lbpmmonitor:button.batchPrivi')}",
													function(value) {
													}, {
														"width" : 600,
														"height" : 400
													});
										});
										return;
									} else {
										seajs.use([ 'lui/dialog' ], function(dialog) {
											dialog.alert("${lfn:message('page.noSelect')}");
										});
									}
								}
								//批量修改处理人
								function batchModifyHandler(fdUrl) {
									var selected;
									var select = document.getElementsByName("List_Selected");
									for ( var i = 0; i < select.length; i++) {
										if (select[i].checked) {
											selected = true;
											break;
										}
									}
									if (selected) {
										var url =fdUrl+'/sys/lbpmmonitor/sys_lbpm_monitor_flow/batchModifyHandler.jsp';
										seajs.use([ 'lui/dialog', 'lui/topic' ], function(dialog, topic) {
											dialog.iframe(url,
													"${lfn:message('sys-lbpmmonitor:button.batchModifyHandler')}",
													function(value) {
													}, {
														"width" : 600,
														"height" : 400
													});
										});
										return;
									} else {
										seajs.use([ 'lui/dialog' ], function(dialog) {
											dialog.alert("${lfn:message('page.noSelect')}");
										});
									}
								}
							 	
								domain.autoResize();
								seajs.use(['lui/topic'], function(topic) {
									// 监听新建更新等成功后刷新
									topic.subscribe('successReloadPage', function() {
										window.setTimeout(function() {
											topic.publish('list.refresh');
										}, 2000);
									});
								});
								</script>
					</td>
				</tr>
			</table>
		</div>
	</template:replace>
</template:include>
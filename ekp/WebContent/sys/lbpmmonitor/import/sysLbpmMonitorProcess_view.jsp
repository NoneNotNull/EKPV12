<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="sysWfBusinessForm" value="${requestScope[param.formName]}" />
<c:set var="lbpmProcessForm" value="${sysWfBusinessForm.sysWfBusinessForm.internalForm}" />
<c:set var="resize_prefix" value="_" scope="request" />
<c:if test="${sysWfBusinessForm.sysWfBusinessForm!=null}">
	<!-- 流程信息 -->
	<ui:content id="tab_flowInfo"
		title="${ lfn:message('sys-lbpmmonitor:sysLbpmMonitor.tab.flowInfo') }"
		expand="true">
		<ui:event event="show">
			bindOnResize(this);
		</ui:event>
		<%@ include file="../include/process_view.jsp"%>
	</ui:content>
	<!-- 流程图 -->
	<ui:content id="tab_flowGraphic"
		title="${ lfn:message('sys-lbpmmonitor:sysLbpmMonitor.tab.flowGraphic') }">
		<table width="100%" border=0>
			<tr id="flowGraphic">
				<td id="workflowInfoTD" ${resize_prefix}onresize="lbpm.flow_chart_load_Frame();">
						<iframe width="100%" height="100%" scrolling="no"
							id="${sysWfBusinessFormPrefix}WF_IFrame"></iframe> <script>
							$("#${sysWfBusinessFormPrefix}WF_IFrame").ready(function() {
								var lbpm_panel_reload = function() {
									$("#${sysWfBusinessFormPrefix}WF_IFrame").attr('src', function (i, val) {return val;});
								};
								lbpm.events.addListener(lbpm.constant.EVENT_MODIFYNODEATTRIBUTE, lbpm_panel_reload);
								lbpm.events.addListener(lbpm.constant.EVENT_MODIFYPROCESS, lbpm_panel_reload);
								lbpm.events.addListener(lbpm.constant.EVENT_SELECTEDMANUAL, lbpm_panel_reload);
							});
						</script>
				</td>
			</tr>
		</table>
		<ui:event event="show">
			bindOnResize(this);
		</ui:event>
	</ui:content>
	<!-- 流程表格 -->
	<ui:content id="tab_flowTable"
		title="${ lfn:message('sys-lbpmmonitor:sysLbpmMonitor.tab.flowTable') }">
		<table width="100%" border=0 >
			<tr id="_flowTable">
				<td id="workflowTableTD"
							${resize_prefix}onresize="lbpm.flow_table_load_Frame();"><iframe
								width="100%" height="100%" scrolling="no"
								id="${sysWfBusinessFormPrefix}WF_TableIFrame" FRAMEBORDER=0></iframe>
						</td>
			</tr>
		</table>
		<ui:event event="show">
			bindOnResize(this);
		</ui:event>
	</ui:content>
	<!-- 流转日记 -->
	<ui:content id="tab_flowLog"
		title="${ lfn:message('sys-lbpmmonitor:sysLbpmMonitor.tab.flowLog') }">
		<table width="100%" border=0 >
			<tr id="_flowLog">
				<td id="flowLogTableTD"
						${resize_prefix}onresize="lbpm.flow_log_load_Frame();"><iframe
							width="100%" height="100%" scrolling="no" FRAMEBORDER=0></iframe>
					</td>
			</tr>
		</table>
		<ui:event event="show">
			bindOnResize(this);
		</ui:event>
	</ui:content>
	<script>
		function bindOnResize(obj){
			if (obj.isBindOnResize) {
				return;
			}
			var element = obj.element;
			function onResize() {
				element.find("*[_onresize]").each(function(){
					var elem = $(this);
					var funStr = elem.attr("_onresize");
					var show = elem.closest('tr').is(":visible");
					var init = elem.attr("data-init-resize");
					if(funStr!=null && funStr!="" && show && init == null){
						elem.attr("data-init-resize", 'true');
						var tmpFunc = new Function(funStr);
						tmpFunc.call();
					}
				});
			}
			obj.isBindOnResize = true;
			onResize();
			element.click(onResize);
		}
		
	</script>
</c:if>
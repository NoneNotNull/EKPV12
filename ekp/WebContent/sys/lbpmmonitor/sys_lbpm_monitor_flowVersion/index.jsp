<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ page import="com.landray.kmss.sys.config.design.SysConfigs,com.landray.kmss.sys.simplecategory.model.ISysSimpleCategoryModel"%>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/sys/ui/jsp/jshead.jsp"%>
<script type="text/javascript">
	seajs.use(['theme!list', 'theme!portal']);	
</script>
<script src="${ LUI_ContextPath }/sys/ui/extend/template/module/list.js?s_cache=${LUI_Cache}"></script>
<body style="padding:10px;">
<!-- 分类导航筛选器 -->
<list:criteria id="criteria1" expand="false">
	<c:if test="${not empty param.modelName }">
		<%	
			String modelName=request.getParameter("modelName");
			String templateModelName = SysConfigs.getInstance().getFlowDefByMain(modelName).getTemplateModelName();
			Class clazz = Class.forName(templateModelName);
			boolean isSimpleCategory=ISysSimpleCategoryModel.class.isAssignableFrom(clazz);
			pageContext.setAttribute("templateModelName", templateModelName);
			pageContext.setAttribute("isSimpleCategory", isSimpleCategory);
		%>
		<c:if test="${isSimpleCategory}">
			<list:cri-ref ref="criterion.sys.simpleCategory" key="docCategory"
				multi="false"
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
</list:criteria>

<!-- 排序 -->
<div class="lui_list_operation">
	<table width="100%">
		<tr>
			<td class="lui_sort">${ lfn:message('list.orderType') }：</td>
			<td><ui:toolbar layout="sys.ui.toolbar.sort" style="float:left"
					count="6">
					<list:sort property="fdModelName"
						text="${lfn:message('sys-lbpmmonitor:sysLbpmMonitor.flow.order.module')}"
						group="sort.list" value="down"></list:sort>
					<list:sort property="fdCreateTime"
						text="${lfn:message('sys-lbpmmonitor:sysLbpmMonitor.flow.order.fdCreateTime')}"
						group="sort.list"></list:sort>
				</ui:toolbar></td>
			<td align="right"><ui:toolbar id="Btntoolbar">
				</ui:toolbar></td>
		</tr>
	</table>
</div>

<ui:fixed elem=".lui_list_operation"></ui:fixed>
<list:listview id="listview">
	<ui:source type="AjaxJson">
					{url:'/sys/lbpmmonitor/sys_lbpmmonitor_flow/SysLbpmMonitorFlowVersion.do?method=listChildren&modelName=${param.modelName }'}
			</ui:source>
	<list:colTable isDefault="false" layout="sys.ui.listview.columntable"
		rowHref="/sys/lbpmmonitor/sys_lbpmmonitor_flow/SysLbpmMonitorFlowVersion.do?method=view&fdId=!{fdId}&fdTemplateName=!{fdTemplateName}&fdTemplateId=!{fdTemplateId}"
		name="columntable">
		<list:col-checkbox></list:col-checkbox>
		<list:col-serial></list:col-serial>
		<list:col-auto props=""></list:col-auto>
	</list:colTable>
</list:listview>
<list:paging></list:paging>

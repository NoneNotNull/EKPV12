<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

	<list:group-popup title="${lfn:message('sys-ui:ui.criteria.category') }" multi="false" key="docCatergroyMain">
		<list:varDef name="select">
			<list:item-select type="lui/criteria/criteria!CriterionHierarchyDatas">
				<ui:source type="AjaxJson">
					{url: "/sys/category/criteria/sysCategoryCriteria.do?method=criteria&modelName=${varParams['modelName']}&parentId=!{value}&nodeType=!{nodeType}"}
				</ui:source>
			</list:item-select>
		</list:varDef>
	</list:group-popup>

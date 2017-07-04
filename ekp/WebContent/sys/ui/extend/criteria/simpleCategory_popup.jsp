<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

	<list:group-popup title="${lfn:message('sys-ui:ui.criteria.simplecategory') }" multi="false" key="simpleCategory">
		<list:varDef name="select">
			<list:item-select type="lui/criteria/select_panel!CriterionHierarchyDatas">
				<ui:source type="AjaxJson">
					{url: "/sys/simplecategory/criteria/sysSimpleCategoryCriteria.do?method=criteria&modelName=${varParams['modelName']}&parentId=!{value}"}
				</ui:source>
			</list:item-select>
		</list:varDef>
	</list:group-popup>

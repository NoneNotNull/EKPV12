<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

	<list:group-popup title="${lfn:message('sys-ui:ui.criteria.categoryproperty') }" multi="false" key="docProperties">
		<list:varDef name="select">
			<list:item-select type="lui/criteria/criteria!CriterionHierarchyDatas">
				<ui:source type="AjaxJson">
					{url: "/sys/category/criteria/sysCategoryCriteria.do?method=property&parentId=!{value}"}
				</ui:source>
			</list:item-select>
		</list:varDef>
	</list:group-popup>

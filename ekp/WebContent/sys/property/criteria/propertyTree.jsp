<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<list:cri-criterion title="自定义树" expand="false" key="${criterionAttrs['key']}">
	<list:box-select>
		<list:item-select type="lui/criteria!CriterionHierarchyDatas">
			<ui:source type="AjaxJson">
				{url: "/sys/property/sys_property_criteria/sysPropertyCriteria.do?method=treeCriteria&parentId=!{value}&treeRootId=${varParams['treeId'] }"}
			</ui:source>
		</list:item-select>
	</list:box-select>
</list:cri-criterion>
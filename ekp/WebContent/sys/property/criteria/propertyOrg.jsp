<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ page import="com.landray.kmss.util.UserUtil" %>

<list:cri-criterion title="组织架构" expand="false" key="${criterionAttrs['key']}">
	<list:box-select>
		<list:item-select type="lui/criteria!CriterionHierarchyDatas">
			<ui:source type="AjaxJson">
				{url: "/sys/property/sys_property_criteria/sysPropertyCriteria.do?method=orgCriteria&parentId=!{value}&orgType=${varParams['type']}"}
			</ui:source>
		</list:item-select>
	</list:box-select>
</list:cri-criterion>
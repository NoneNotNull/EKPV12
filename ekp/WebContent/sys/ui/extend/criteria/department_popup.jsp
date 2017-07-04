<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ page import="com.landray.kmss.util.UserUtil" %>
	<list:group-popup title="${lfn:message('sys-ui:ui.criteria.dept') }" multi="false" key="docDept">
		<list:varDef name="select">
			<%
				String lookValue = "";
				if (UserUtil.getKMSSUser() != null
						&& UserUtil.getUser().getFdParent() != null
						&& UserUtil.getUser().getFdParent().getFdParent() != null) {
					lookValue = UserUtil.getUser().getFdParent().getFdParent().getFdId();
				}
				pageContext.setAttribute("lookValue", lookValue);
			%>
			<list:item-select type="lui/criteria!CriterionHierarchyDatas" cfg-lookValue="${lookValue }">
				<ui:source type="AjaxJson">
					{url: "/sys/organization/sys_org_element/sysOrgElementCriteria.do?method=criteria&parentId=!{value}&orgType=3&__hierarchy=true"}
				</ui:source>
			</list:item-select>
		</list:varDef>
	</list:group-popup>

<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<list:cri-criterion title="${lfn:message('sys-ui:ui.criteria.docAuthor') }" expand="false" key="docCreator">
	<list:box-title>
		<div style="line-height: 30px">${criterionAttrs['title']}</div>
		<div class="person">
			<list:item-search width="50px" height="22px">
				<ui:event event="search.changed" args="evt">
					var se = this.parent.parent.selectBox.criterionSelectElement;
					var source = se.source;
					if(evt.searchText)
						evt.searchText = encodeURIComponent(evt.searchText);
					source.resolveUrl(evt);
					source.one('data', function(data) {
						if (data && data.length == 1) {
							if (se.multi)
								se.selectedValues.add(data[0].value);
							else
								se.selectedValues.set(data[0].value);
						}
					});
					source.get();
				</ui:event>
			</list:item-search>
		</div>
	</list:box-title>
	
	<list:box-select style="min-height:60px">
		<%
			String parentId = "";
			if (UserUtil.getUser() != null
					&& UserUtil.getUser().getFdParent() != null) {
				parentId = UserUtil.getUser().getFdParent().getFdId();
			} else if (UserUtil.getUser() != null
					&& UserUtil.getUser().getFdParentOrg() != null) {
				parentId = UserUtil.getUser().getFdParentOrg()
						.getFdId();
			}
			if (StringUtil.isNotNull(parentId)) {
				parentId = "&parentId=" + parentId;
			}
			pageContext.setAttribute("parentId", parentId);
		%>
		<list:item-select type="lui/criteria/select_panel!CriterionSelectDatas">
			<ui:source type="AjaxJson">
				{url: "/sys/organization/sys_org_element/sysOrgElementCriteria.do?method=criteria${parentId }&searchText=!{searchText}&orgType=8"}
			</ui:source>
		</list:item-select>
	</list:box-select>
	
</list:cri-criterion>
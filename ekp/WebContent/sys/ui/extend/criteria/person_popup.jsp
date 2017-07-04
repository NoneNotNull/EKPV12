<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
	<list:group-popup title="${lfn:message('sys-ui:ui.criteria.docAuthor') }" multi="false" key="docAutor">
			<div style="float:right;background-color: #fff;margin: 3px 8px 0 8px;">
				<div data-lui-type="lui/search_box!SearchBox" style="display:none;">
					<script type="text/config">
					{
						placeholder: "${lfn:message('sys-ui:ui.criteria.search')}${criterionAttrs['title']}",
						width: '200px'
					}
					</script>
					<ui:event event="search.changed" args="evt">
						var se = this.parent.parent.criterionSelectElement;
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
				</div>
			</div>
			<%
				String parentId = "";
				if (UserUtil.getUser() != null 
						&& UserUtil.getUser().getFdParent() != null) {
					parentId = UserUtil.getUser().getFdParent().getFdId();
				} else if (UserUtil.getUser() != null 
						&& UserUtil.getUser().getFdParentOrg() != null) {
					parentId = UserUtil.getUser().getFdParentOrg().getFdId();
				}
				pageContext.setAttribute("parentId", parentId);
			%>
			<div class="clr"></div>
			
			<list:item-select type="lui/criteria/select_panel!CriterionSelectDatas">
				<ui:source type="AjaxJson">
					{url: "/sys/organization/sys_org_element/sysOrgElementCriteria.do?method=criteria&parentId=${parentId }&searchText=!{searchText}&orgType=8"}
				</ui:source>
			</list:item-select>
	</list:group-popup>

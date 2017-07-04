<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<list:cri-criterion title="${lfn:message('sys-ui:ui.criteria.category') }" expand="true" key="docCatergroyMain">
	<list:box-title>
		<div class="criterion-title-popup-div">
		 <ui:menu layout="sys.ui.menu.nav"> 
			<ui:menu-item text="${criterionAttrs['title']}">
				<ui:menu-source autoFetch="true" 
					href="javascript:luiCriteriaTitlePopupItemClick('${criterionAttrs['channel']}', '${criterionAttrs['key']}', '!{value}');">
					<ui:source type="AjaxJson">
						{"url":"/sys/category/criteria/sysCategoryCriteria.do?method=criteria&modelName=${varParams['modelName']}&parentId=!{value}&nodeType=!{nodeType}&key=${criterionAttrs['key']}&channel=${criteriaAttrs['channel'] }"} 
					</ui:source>
				</ui:menu-source>
			</ui:menu-item>
		</ui:menu>
		</div>
	</list:box-title>
	<list:box-select>
		<list:item-select type="lui/criteria!CriterionHierarchyDatas">
			<ui:source type="AjaxJson">
				{url: "/sys/category/criteria/sysCategoryCriteria.do?method=criteria&modelName=${varParams['modelName']}&parentId=!{value}&nodeType=!{nodeType}"}
			</ui:source>
		</list:item-select>
	</list:box-select>
</list:cri-criterion>
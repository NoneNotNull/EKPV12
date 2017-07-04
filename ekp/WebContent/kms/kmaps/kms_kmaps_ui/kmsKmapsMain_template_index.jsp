<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.list" width="980px">
	<template:replace name="title">${lfn:message('kms-kmaps:table.kmsKmapsMain') }</template:replace>
	<%-- 当前路径 --%>
	<template:replace name="path">
		 <ui:menu layout="sys.ui.menu.nav"  id="simplecategoryId">
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home" href="/" target="_self">
			</ui:menu-item>
			<ui:menu-item text="${lfn:message('kms-kmaps:table.kmsKmapsMain') }" href="/kms/kmaps/kms_kmaps_ui/kmsKmapsMain_index.jsp" target="_self">
			</ui:menu-item>
			<ui:menu-item text="${lfn:message('kms-kmaps:kmsKmapsMain.mapTemplate') }" href="/kms/kmaps/kms_kmaps_ui/kmsKmapsMain_template_index.jsp" target="_self">
			   <ui:menu-item text="${lfn:message('kms-kmaps:table.kmsKmapsMain') }" href="/kms/kmaps/kms_kmaps_ui/kmsKmapsMain_index.jsp" target="_self">
			   </ui:menu-item>
			</ui:menu-item>
			<ui:menu-source autoFetch="true" 
					target="_self" 
					href="/kms/kmaps/kms_kmaps_ui/kmsKmapsMain_template_index.jsp?categoryId=!{value}">
				<ui:source type="AjaxJson">
					{"url":"/sys/simplecategory/criteria/sysSimpleCategoryCriteria.do?method=path&modelName=com.landray.kmss.kms.kmaps.model.KmsKmapsTemplCategory&categoryId=${param.categoryId }&currId=!{value}"} 
				</ui:source>
			</ui:menu-source>
		</ui:menu>
	</template:replace>
	<%-- 左边栏 --%>
	<template:replace name="nav">
	
		<!-- 所有分类 -->
		<ui:combin ref="menu.nav.simplecategory.all"> 
			<ui:varParams 
				modelName="com.landray.kmss.kms.kmaps.model.KmsKmapsCategory" 
				href="/kms/kmaps/" />
		</ui:combin>
		
		<%-- 我要分享--按钮 --%>
		<ui:combin ref="menu.nav.create"> 
			<ui:varParam name="title" value="${lfn:message('kms-kmaps:kmsKmapsMain.mapTemplate') }"></ui:varParam>
			<ui:varParam name="button">
				[
					<kmss:authShow roles="ROLE_KMSKMAPS_TEMP_CREATE">
					{
						"text": "${lfn:message('kms-kmaps:kmsKmapsMain.createTemps') }",
						"href": "javascript:addMaps()",
						"icon": "lui_icon_l_icon_38"
					}
					</kmss:authShow>
				]
			</ui:varParam>
		</ui:combin>
		<div class="lui_list_nav_frame">
			<ui:accordionpanel>
				<%-- 地图分类 --%>
				<ui:content title="${lfn:message('kms-kmaps:table.kmsKmapsMain') }" style="padding:0px">
					<ui:combin ref="menu.nav.simplecategory.flat">
						<ui:varParams 
							modelName="com.landray.kmss.kms.kmaps.model.KmsKmapsCategory" 
							href="/kms/kmaps/kms_kmaps_ui/kmsKmapsMain_index.jsp"
							expand="true" />
					</ui:combin> 
				</ui:content>
				
				<%-- 地图模版 --%>
				<ui:content title="${lfn:message('kms-kmaps:kmsKmapsMain.mapTemplate') }" style="padding:0px">
					<ui:combin ref="menu.nav.simplecategory.flat">
						<ui:varParams 
							modelName="com.landray.kmss.kms.kmaps.model.KmsKmapsTemplCategory" 
							href="/kms/kmaps/kms_kmaps_ui/kmsKmapsMain_template_index.jsp"
							categoryId="${param.categoryId }"
							expand="true" />
					</ui:combin>
					<c:if test="${not empty param.categoryId}">
						<ui:operation href="javascript:LUI('simplecategoryId').gotoNav(-1)" target="_self" name="${lfn:message('list.lever.up') }" align ="left"/>
					</c:if>				
				</ui:content>
				
				<%-- 后台配置 --%>
				<ui:content title="${ lfn:message('list.otherOpt')}">  
					<ul class='lui_list_nav_list'>
						<kmss:authShow roles="ROLE_KMSKMAPS_BACKSTAGE_MANAGER">
							<li><a href="${LUI_ContextPath }/sys/?module=kms/kmaps" target="_blank">${ lfn:message('list.manager') }</a></li>
						</kmss:authShow>
					</ul>
				</ui:content>
			</ui:accordionpanel>
		</div>
	</template:replace>
	<%-- 右边栏 --%>
	<template:replace name="content">
	
		<%-- 按钮 --%>
		<div class="lui_list_operation">
			<table width="100%">
				<tr>
					<td style='color: #979797;width: 39px'>
						${ lfn:message('kms-kmaps:km.kmap.listOrder') }：
					</td>
					<%--排序按钮  --%>
					<td>
						<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" count="4">
							<list:sort property="docCreateTime" text="${lfn:message('kms-kmaps:kmsKmapsMain.docCreateTime') }" group="sort.list"></list:sort>
						</ui:toolbar>
					</td>
					<%--操作按钮  --%>
					<td align="right"> 
						<ui:toolbar count="3">
							<%-- 新增删除--%>
							<c:import url="/kms/kmaps/kms_kmaps_ui/kmsKmapsMain_template_button.jsp" charEncoding="UTF-8"></c:import>
							<%-- 分类转移 --%>
							<c:import url="/sys/simplecategory/import/doc_cate_change_button.jsp" charEncoding="UTF-8">
								<c:param name="modelName" value="com.landray.kmss.kms.kmaps.model.KmsKmapsTemplate" />
								<c:param name="docFkName" value="docCategory" />
								<c:param name="cateModelName" value="com.landray.kmss.kms.kmaps.model.KmsKmapsTemplCategory" />
							</c:import>
						</ui:toolbar>
					</td>
				</tr>
			</table>
		</div>
		
		<%--列表视图  --%>
		<list:listview id="listview">
			<ui:source type="AjaxJson">
				{url:'/kms/kmaps/kms_kmaps_index/kmsKmapsMainIndex.do?method=getTempCategory&categoryId=${param.categoryId}&orderby=docCreateTime&ordertype=down'}
			</ui:source>
			
			<%-- 列表视图--%>
			<list:colTable layout="sys.ui.listview.columntable" name="columntable"
				rowHref="/kms/kmaps/kms_kmaps_template/kmsKmapsTemplate.do?method=view&fdId=!{fdId}"> 
				<list:col-checkbox name="List_Selected" style="width:5%"></list:col-checkbox>
				<list:col-serial title="${ lfn:message('page.serial') }" headerStyle="width:5%"></list:col-serial>
				<list:col-html title="${lfn:message('kms-kmaps:kmsKmapsMain.templSubject') }" headerStyle="width:40%" style="text-align:left;padding:0 8px">
					{$
						<span class="com_subject">{%row['fdName']%}</span>
					$}
				</list:col-html>
				<list:col-html title="${ lfn:message('kms-kmaps:kmsKmapsMain.docCreator')}" >
					{$
						{%row['docCreator']%}
					$}
				</list:col-html>
				<list:col-auto props="docCategory.fdName;docCreateTime;"></list:col-auto>
			</list:colTable>
			
		</list:listview>
		<%-- 列表分页 --%>
	 	<list:paging></list:paging>
	</template:replace>
</template:include>


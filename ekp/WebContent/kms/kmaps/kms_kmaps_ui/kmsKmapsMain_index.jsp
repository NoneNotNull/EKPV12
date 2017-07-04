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
			<ui:menu-item text="${lfn:message('kms-kmaps:table.kmsKmapsMain') }" href="/kms/kmaps/kms_kmaps_ui/kmsKmapsMain_index.jsp" target="_self">
			   <ui:menu-item text="${lfn:message('kms-kmaps:kmsKmapsMain.mapTemplate') }" href="/kms/kmaps/kms_kmaps_ui/kmsKmapsMain_template_index.jsp" target="_self">
			   </ui:menu-item>
			</ui:menu-item>
			<ui:menu-source autoFetch="true" 
					target="_self" 
					href="/kms/kmaps/kms_kmaps_ui/kmsKmapsMain_index.jsp?categoryId=!{value}">
				<ui:source type="AjaxJson">
					{"url":"/sys/simplecategory/criteria/sysSimpleCategoryCriteria.do?method=path&modelName=com.landray.kmss.kms.kmaps.model.KmsKmapsCategory&categoryId=${param.categoryId }&currId=!{value}"} 
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
			<ui:varParam name="title" value="${lfn:message('kms-kmaps:module.kms.kmaps') }"></ui:varParam>
			<ui:varParam name="button">
				[
					<kmss:authShow roles="ROLE_KMSKMAPS_CREATE">
					{
						"text": "${lfn:message('kms-kmaps:kmsKmapsMain.createMaps') }",
						"href": "javascript:addMaps()",
						"icon": "lui_icon_l_icon_38"
					}
					</kmss:authShow>
				]
			</ui:varParam>
		</ui:combin>
		<div class="lui_list_nav_frame">
			<ui:accordionpanel>
				<%-- 常用分类 --%>
				<ui:combin ref="menu.nav.favorite.category">
					<ui:varParams 
						modelName="com.landray.kmss.kms.kmaps.model.KmsKmapsCategory" 
						href="/kms/kmaps/?categoryId=!{value}" />
				</ui:combin>
				
				<%-- 地图 --%>
				<ui:content title="${lfn:message('kms-kmaps:table.kmsKmapsMain') }" style="padding:0px">
					<ui:combin ref="menu.nav.simplecategory.flat">
						<ui:varParams 
							modelName="com.landray.kmss.kms.kmaps.model.KmsKmapsCategory" 
							href="/kms/kmaps/kms_kmaps_ui/kmsKmapsMain_index.jsp"
							categoryId="${param.categoryId }"
							expand="true" />
					</ui:combin> 
					<c:if test="${not empty param.categoryId}"> 
						<ui:operation href="javascript:LUI('simplecategoryId').gotoNav(-1)" target="_self" name="${lfn:message('list.lever.up') }" align ="left"/>
					</c:if>				
					<ui:operation 
						href="javascript:openPage('${LUI_ContextPath }/sys/sc/categoryPreivew.do?method=forward&service=kmsKmapsCategoryPreManagerService&currid=${param.categoryId}')" 
						name="${lfn:message('sys-category:menu.sysCategory.overview') }" 
						target="_self" />
				</ui:content>
				
				<%-- 地图模版 --%> 
				<ui:content title="${lfn:message('kms-kmaps:kmsKmapsMain.mapTemplate') }" style="padding:0px">
					<ui:combin ref="menu.nav.simplecategory.flat">
						<ui:varParams 
							modelName="com.landray.kmss.kms.kmaps.model.KmsKmapsTemplCategory" 
							href="/kms/kmaps/kms_kmaps_ui/kmsKmapsMain_template_index.jsp"
							expand="true" />
					</ui:combin>
				</ui:content>
				
				<%-- 常用查询 --%>
				<ui:content title="${ lfn:message('list.search') }">
					<ul class='lui_list_nav_list'>
						<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('mydoc', 'create');">${ lfn:message('list.create') }</a></li>
						<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('mydoc', 'approval');">${ lfn:message('list.approval') }</a></li>
						<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('mydoc', 'approved');">${ lfn:message('list.approved') }</a></li>
						<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('introduce','intro');">${ lfn:message('kms-kmaps:kmsKmapsMain.introduceMaps')}</a></li>
						<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').clearValue();">${ lfn:message('kms-kmaps:all.kmsKmapsMain') }</a></li>
						<li>
							<a href="javascript:void(0)" 
							   onclick="openQuery();LUI('criteria1').setValue('docStatus','10');">
							  ${lfn:message("kms-kmaps:kmsKmapsMain.my.drafts") }
							</a>
						</li>
					</ul>
				</ui:content>
				
				<%-- 后台配置 --%>
				<kmss:authShow roles="ROLE_KMSKMAPS_BACKSTAGE_MANAGER">
					<ui:content title="${ lfn:message('list.otherOpt')}">  
						<ul class='lui_list_nav_list'>
							<li><a href="${LUI_ContextPath }/sys/?module=kms/kmaps" target="_blank">${ lfn:message('list.manager') }</a></li>
						</ul>
					</ui:content>
				</kmss:authShow>
			</ui:accordionpanel>
		</div>
	</template:replace>
	<%-- 右边栏 --%>
	<template:replace name="content">
	
		<list:criteria id="criteria1">
			<list:cri-ref key="docSubject" ref="criterion.sys.docSubject">
			</list:cri-ref>
			<list:cri-property modelName="com.landray.kmss.kms.kmaps.model.KmsKmapsCategory" categoryId="${param.categoryId }"/>
			<list:cri-ref key="dept" ref="criterion.sys.dept" title="${ lfn:message('kms-kmaps:kmsKmapsMain.dept')}">
			</list:cri-ref>
			<list:cri-auto modelName="com.landray.kmss.kms.kmaps.model.KmsKmapsMain" property="docAuthor"/>
			<list:cri-auto modelName="com.landray.kmss.kms.kmaps.model.KmsKmapsMain" 
				property="docStatus"/>
			<list:cri-criterion title="${ lfn:message('kms-kmaps:kmsKmapsMain.isIntroduce')}" key="introduce" expand="false" multi="true"> 
				<list:box-select > 
					<list:item-select >
						<ui:source type="Static"> 
							[{text:'${ lfn:message('kms-kmaps:kmsKmapsMain.yes')}', value:'intro'},{text:'${ lfn:message('kms-kmaps:kmsKmapsMain.no')}',value:'notintro'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
			<list:cri-criterion title="${ lfn:message('kms-kmaps:kmsKmapsMain.myMap')}" key="mydoc" expand="false" multi="false"> 
				<list:box-select > 
					<list:item-select >
						<ui:source type="Static"> 
							[{text:'${ lfn:message('list.create') }', value:'create'},{text:'${ lfn:message('list.approval') }',value:'approval'}, {text:'${ lfn:message('list.approved') }', value: 'approved'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
		</list:criteria>
		
		<%-- 按钮 --%>
		<div class="lui_list_operation">
					<div style='color: #979797;width: 39px;float:left;padding-top:1px;'>
						${ lfn:message('kms-kmaps:km.kmap.listOrder') }：
					</div>
					<%--排序按钮  --%>
					<div style="float:left">
						<div style="display: inline-block;vertical-align: middle;">
							<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" count="4">
								<list:sort property="docCreateTime" text="${lfn:message('kms-kmaps:kmsKmapsMain.docCreateTime')}" group="sort.list"></list:sort>
								<list:sort property="docReadCount" text="${lfn:message('kms-kmaps:km.kmap.readCount')}" group="sort.list"></list:sort>
								<list:sort property="docPublishTime" text="${lfn:message('kms-kmaps:kmsKmapsMain.postTime')}" group="sort.list"></list:sort>
							</ui:toolbar>
						</div> 
					</div>
					<div style="float:left;">
						<list:paging layout="sys.ui.paging.top"></list:paging>
					</div>
					<%--操作按钮  --%>
					<div style="float:right">
						<div style="display: inline-block;vertical-align: middle;">
						<ui:toolbar count="3" id="kmaps_toolbar"> 
							<ui:togglegroup order="0">
								<ui:toggle icon="lui_icon_s_liebiao" 
									title="${ lfn:message('list.columnTable') }"  group="tg_1" value="columntable"
									text="${ lfn:message('list.columnTable') }" onclick="LUI('listview').switchType(this.value);LUI('fileType');">
								</ui:toggle>
								<ui:toggle icon="lui_icon_s_tuwen" title="${lfn:message('list.gridTable') }" group="tg_1" value="gridtable"
									text="${lfn:message('list.gridTable') }" onclick="LUI('listview').switchType(this.value);LUI('fileType');">
								</ui:toggle>
							</ui:togglegroup>
							
							<%-- 新增删除--%>
							<c:import url="/kms/kmaps/kms_kmaps_ui/kmsKmapsMain_button.jsp" charEncoding="UTF-8"></c:import>
							<%-- 修改权限 --%>
							<c:import url="/sys/right/import/doc_right_change_button.jsp" charEncoding="UTF-8">
								<c:param name="modelName" value="com.landray.kmss.kms.kmaps.model.KmsKmapsMain" />
								<c:param name="categoryId" value="${param.categoryId }" />
							</c:import>
							 							
							<%-- 分类转移 --%>
							<c:import url="/sys/simplecategory/import/doc_cate_change_button.jsp" charEncoding="UTF-8">
								<c:param name="modelName" value="com.landray.kmss.kms.kmaps.model.KmsKmapsMain" />
								<c:param name="docFkName" value="docCategory" />
								<c:param name="cateModelName" value="com.landray.kmss.kms.kmaps.model.KmsKmapsCategory" />
							</c:import>
							
							<%-- 取消推荐 --%>
							<c:import url="/sys/introduce/import/sysIntroduceMain_cancelbtn.jsp" charEncoding="UTF-8">
								<c:param name="fdModelName" value="com.landray.kmss.kms.kmaps.model.KmsKmapsMain" />
							</c:import> 
							
						</ui:toolbar>
					</div>
				</div>
		</div>
		
		<%--列表视图  --%>
		<list:listview id="listview">
			<ui:source type="AjaxJson">
				{url:'/kms/kmaps/kms_kmaps_index/kmsKmapsMainIndex.do?method=index&orderby=docPublishTime&ordertype=down&categoryId=${param.categoryId}&rowsize=16'}
			</ui:source>
			
			<%-- 列表视图--%>
			<list:colTable layout="sys.ui.listview.columntable" name="columntable"
				rowHref="/kms/kmaps/kms_kmaps_main/kmsKmapsMain.do?method=view&fdId=!{fdId}"> 
				<list:col-checkbox name="List_Selected" style="width:5%"></list:col-checkbox>
				<list:col-serial title="${ lfn:message('page.serial') }" headerStyle="width:5%"></list:col-serial>
				<list:col-html title="${ lfn:message('kms-kmaps:kmsKmapsMain.docSubject')}" headerStyle="width:40%" style="text-align:left;padding:0 8px">
					{$
						<span class="com_subject">{%row['docSubject']%}</span> 
					$}
				</list:col-html>
				<list:col-html title="${ lfn:message('kms-kmaps:kmsKmapsMain.Author')}" >
					{$
						{%row['docAuthor.fdName']%}
					$}
				</list:col-html>
				<list:col-auto props="docCategory.fdName;docCreateTime;docPublishTime"></list:col-auto>
			</list:colTable>
			
			<%-- 视图列表 --%>
			<list:gridTable name="gridtable"  gridHref="/kms/kmaps/kms_kmaps_main/kmsKmapsMain.do?method=view&fdId=!{fdId}">
				<ui:source type="AjaxJson">
					{url:'/kms/kmaps/kms_kmaps_index/kmsKmapsMainIndex.do?method=index&orderby=docPublishTime&ordertype=down&categoryId=${param.categoryId}&rowsize=16&dataType=pic'}
				</ui:source>
				<list:row-template ref="sys.ui.listview.gridtable" >
				</list:row-template>
			</list:gridTable>
		</list:listview>
		<%-- 列表分页 --%>
	 	<list:paging></list:paging>
	</template:replace>
</template:include>


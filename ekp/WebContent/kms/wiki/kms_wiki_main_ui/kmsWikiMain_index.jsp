<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ include file="/kms/knowledge/kms_knowledge_ui/kmsKnowledge_categoryId_handle.jsp"%>
<template:include ref="default.list" width="980px">
	<template:replace name="title">${lfn:message('kms-wiki:title.kms.kmsWiki') }</template:replace>
	<template:replace name="head">
		<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/kms/wiki/kms_wiki_main_ui/style/index.css">
	</template:replace>
	<%-- 当前路径 --%>
	<template:replace name="path">
		<ui:combin ref="menu.path.simplecategory">
			<ui:varParams 
				id="simplecategoryId"
				modelName="com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory" 
				moduleTitle="${lfn:message('kms-wiki:title.kms.kmsWiki') }"
				href="/kms/wiki/"	
				categoryId="${categoryId }"
				extProps="{'fdTemplateType':'2,3'}" />
		</ui:combin>
	</template:replace>
	<%-- 左边栏 --%>
	<template:replace name="nav">
		<!-- 所有分类 -->
		<ui:combin ref="menu.nav.simplecategory.all"> 
			<ui:varParams 
				modelName="com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory" 
				href="/kms/wiki/"
				extProps="{'fdTemplateType':'2,3'}" />
		</ui:combin>
		<%-- 我要分享--按钮 --%>
		<ui:combin ref="menu.nav.create"> 
			<ui:varParam name="title" value="${lfn:message('kms-wiki:kmsWiki.tree.title') }"></ui:varParam>
			<ui:varParam name="button">
				[
					<kmss:auth requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=add" requestMethod="GET">
					{
						"text": "${lfn:message('kms-wiki:table.kmsWikiMain.subject') }",
						"href": "javascript:addDoc()",
						"icon": "lui_icon_l_icon_1"
					}
					</kmss:auth>
				]
			</ui:varParam>
		</ui:combin>
		<div class="lui_list_nav_frame">
			<ui:accordionpanel>
				<%-- 常用分类 --%>
				<ui:combin ref="menu.nav.favorite.category">
					<ui:varParams 
						modelName="com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory" 
						href="/kms/wiki/?categoryId=!{value}"/>
				</ui:combin>
				
				<%-- 分类索引 --%>
				<ui:content title="${lfn:message('sys-simplecategory:menu.sysSimpleCategory.index') }" style="padding:0px">
					<ui:combin ref="menu.nav.simplecategory.flat">
						<ui:varParams 
							content="false"
							modelName="com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory" 
							href="/kms/wiki/"
							categoryId="${categoryId }"
							expand="true"
							extProps="{'fdTemplateType':'2,3'}" />
					</ui:combin>
					<c:if test="${not empty categoryId}">
						<ui:operation href="javascript:LUI('simplecategoryId').gotoNav(-1)" target="_self" name="${lfn:message('list.lever.up') }" align ="left"/>
					</c:if>				 
					<ui:operation href="javascript:openPage('${LUI_ContextPath }/sys/sc/categoryPreivew.do?method=forward&service=kmsWikiCategoryPreManagerService&currid=${categoryId}')" name="${lfn:message('sys-category:menu.sysCategory.overview') }" target="_self" />
				</ui:content>
				
				<%-- 常用查询 --%>
				<ui:content title="${ lfn:message('list.search') }">
					<ul class='lui_list_nav_list'>
						<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('_mydoc', 'myCreated');">${ lfn:message('kms-wiki:kmsWiki.list.myCreated') }</a></li>
						<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('_mydoc', 'myEd');">${ lfn:message('kms-wiki:kmsWiki.list.myEd') }</a></li>
						<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('_mydoc', 'approval');">${ lfn:message('list.approval') }</a></li>
						<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('_mydoc', 'approved');">${ lfn:message('list.approved') }</a></li>
						<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('docIsIntroduced','1');">${lfn:message('km-doc:kmDoc.tree.introduced')}</a></li>
						<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').clearValue();">${ lfn:message('list.alldoc') }</a></li>
						<li>
							<a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('docStatus', '10');">我的草稿箱</a>
						</li>
					</ul>
				</ui:content>
				
				<%-- 后台配置 --%>
				<kmss:authShow roles="ROLE_KMSWIKIMAIN_BACKSTAGE_MANAGER">
					<ui:content title="${ lfn:message('list.otherOpt') }" >
						<ul class='lui_list_nav_list'>
							<li><a href="${LUI_ContextPath }/sys/?module=kms/knowledge" target="_blank">${ lfn:message('list.manager') }</a></li>
						</ul>
					</ui:content>
				</kmss:authShow>
				<%--
				<ui:content title="百科积分排行榜">
					<ui:tabpanel layout="sys.ui.tabpanel.light">
						<ui:content title="本月排行">
							<c:import url="/kms/communitycko/kms_communitycko_portlet_ui/kms_communitycko_portlet.jsp">
								<c:param name="sortType" value="month"/>
								<c:param name="rowsize" value="5"/>
								<c:param name="moudule" value="com.landray.kmss.kms.wiki"/>
							</c:import>
						</ui:content>
						<ui:content title="总排行">
							<c:import url="/kms/communitycko/kms_communitycko_portlet_ui/kms_communitycko_portlet.jsp">
								<c:param name="sortType" value="total"/>
								<c:param name="rowsize" value="5"/>
								<c:param name="moudule" value="com.landray.kmss.kms.wiki"/>
							</c:import>
						</ui:content>
					</ui:tabpanel>
				</ui:content>
				 --%>
			</ui:accordionpanel>
		</div>
	</template:replace>
	<%-- 右边栏 --%>
	<template:replace name="content">
	
		<list:criteria id="criteria1">
				<list:cri-ref key="docSubject" ref="criterion.sys.docSubject">
				</list:cri-ref>
				<list:cri-property modelName="com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory" categoryId="${categoryId }"/>
				<list:cri-auto modelName="com.landray.kmss.kms.wiki.model.KmsWikiMain" 
					property="docDept,docAuthor"/>
				<list:cri-criterion title="${lfn:message('kms-multidoc:kmsMultidoc.kmsMultidocKnowledge.my') }" key="_mydoc" multi="false">
					<list:box-select>
						<list:item-select>
							<ui:source type="Static" >
								[{text:'${ lfn:message('kms-wiki:kmsWiki.list.myCreated') }', value:'myCreated'},{text:'${ lfn:message('kms-wiki:kmsWiki.list.myEd') }', value:'myEd'},{text:'${ lfn:message('list.approval') }',value:'approval'}, {text:'${ lfn:message('list.approved') }', value: 'approved'}]
							</ui:source>
						</list:item-select>
					</list:box-select>
				</list:cri-criterion>
				<list:cri-auto modelName="com.landray.kmss.kms.wiki.model.KmsWikiMain" 
					property="docStatus" />
				<list:cri-auto modelName="com.landray.kmss.kms.wiki.model.KmsWikiMain" 
					property="docIsIntroduced" multi="false"/>
		</list:criteria>
		
		<%-- 按钮 --%>
		<div class="lui_list_operation">
			<div style="width:100%">
					<div style='color: #979797;width: 45px;text-align: center;float:left;padding-top:1px;'>
						${ lfn:message('kms-wiki:kmsWiki.list.orderType') }：
					</div>
					<%--排序按钮  --%>
					<div style="float: left;">
						<div style="display:inline-block;vertical-align:middle;" 
						     class="lui_wiki_sort_box">
							<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" count="4">
								<list:sort property="docPublishTime" text="${lfn:message('kms-wiki:kmsWiki.list.orderDocPublishTime') }" group="sort.list" value="down"></list:sort>
								<list:sort property="fdLastModifiedTime" text="${lfn:message('kms-wiki:kmsWiki.list.fdLastModifiedTime') }" group="sort.list" ></list:sort>
								<list:sort property="fdVersion" text="${lfn:message('kms-wiki:kmsWiki.rightInfo.addVersionTimes') }" group="sort.list"></list:sort>
								<list:sort property="docReadCount" text="${lfn:message('kms-wiki:kmsWiki.list.readCountTimes') }" group="sort.list"></list:sort>
							</ui:toolbar>
						</div>
					</div>
					<div style="float:left;">
						<list:paging layout="sys.ui.paging.top">		
						</list:paging>
					</div>
					<%--操作按钮  --%>
					<div style="float:right;">
						<div style="display:inline-block;vertical-align: middle;">
							<ui:toolbar count="4" id="knowledge_toolbar">
								<ui:togglegroup order="0">
									<ui:toggle icon="lui_icon_s_zaiyao" title="${ lfn:message('list.rowTable') }" group="tg_1" value="rowtable"
										text="${ lfn:message('list.rowTable') }" onclick="LUI('listview').switchType(this.value);" >
									</ui:toggle>
									<ui:toggle icon="lui_icon_s_tuwen" title="${lfn:message('list.gridTable') }" group="tg_1" value="gridtable"
										text="${lfn:message('list.gridTable') }" onclick="LUI('listview').switchType(this.value);">
									</ui:toggle>
									<ui:toggle icon="lui_icon_s_liebiao" 
										title="${ lfn:message('list.columnTable') }"  group="tg_1" value="columntable"
										text="${ lfn:message('list.columnTable') }" onclick="LUI('listview').switchType(this.value);">
									</ui:toggle>
								</ui:togglegroup>
								<%-- 收藏 --%>
								<c:import url="/sys/bookmark/import/bookmark_bar_all.jsp" charEncoding="UTF-8">
									<c:param name="fdTitleProName" value="docSubject" />
									<c:param name="fdModelName"	value="com.landray.kmss.kms.wiki.model.KmsWikiMain" />
								</c:import>
								<%-- 新增删除--%>
								<c:import url="/kms/wiki/kms_wiki_main_ui/kmsWikiMain_button.jsp" charEncoding="UTF-8">
									<c:param name="categoryId" value="${categoryId}"></c:param>
								</c:import>			
								<%-- 修改权限 --%> 
								<c:import url="/sys/right/import/doc_right_change_button.jsp" charEncoding="UTF-8">
									<c:param name="modelName" value="com.landray.kmss.kms.wiki.model.KmsWikiMain" />
									<c:param name="categoryId" value="${categoryId }" />
								</c:import>							
								<%-- 分类转移 --%>
								<c:import url="/sys/simplecategory/import/doc_cate_change_button.jsp" charEncoding="UTF-8">
									<c:param name="modelName" value="com.landray.kmss.kms.wiki.model.KmsWikiMain" />
									<c:param name="docFkName" value="docCategory" />
									<c:param name="cateModelName" value="com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory" />
									<c:param name="extProps" value="fdTemplateType:2;fdTemplateType:3" />
								</c:import>
								<%-- 取消推荐 --%>
								<c:import url="/sys/introduce/import/sysIntroduceMain_cancelbtn.jsp" charEncoding="UTF-8">
									<c:param name="fdModelName" value="com.landray.kmss.kms.wiki.model.KmsWikiMain" />
								</c:import>
							</ui:toolbar>
						</div>
					</div>
				</div>
		</div>
		<ui:fixed elem=".lui_list_operation"></ui:fixed>
		<%--列表视图  --%>
		<list:listview id="listview">
			<ui:source type="AjaxJson">
				{url:'/kms/wiki/kms_wiki_main_index/kmsWikiMianIndex.do?method=list&categoryId=${categoryId}&orderby=docPublishTime&ordertype=down'}
			</ui:source>
			
			<%-- 摘要视图--%>
			<list:rowTable layout="sys.ui.listview.rowtable" 
				name="rowtable" onRowClick="" rowHref="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=view&fdId=!{fdId}&id=!{fdFirstId}" 
				style="" target="_blank" isDefault="true">
				<ui:source type="AjaxJson">
					{url:'/kms/wiki/kms_wiki_main_index/kmsWikiMianIndex.do?method=list&categoryId=${categoryId}&listType=rowtable&orderby=docPublishTime&ordertype=down'}
				</ui:source>
				<list:row-template ref="sys.ui.listview.rowtable">
					{showOtherProps:'fdLastModifiedTime,editTimes,docReadCount,docScore'}
				</list:row-template>
			</list:rowTable>

			<%-- 列表视图--%>
			<list:colTable layout="sys.ui.listview.columntable" name="columntable"
				rowHref="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=view&fdId=!{fdId}&id=!{fdFirstId}">
				<%@ include file="/kms/wiki/kms_wiki_main_ui/kmsWikiMain_col_tmpl.jsp"  %>
			</list:colTable>
			
			<list:gridTable name="gridtable" columnNum="4" gridHref="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=view&fdId=!{fdId}&id=!{fdFirstId}">
				<ui:source type="AjaxJson">
					{url:'/kms/wiki/kms_wiki_main_index/kmsWikiMianIndex.do?method=list&categoryId=${categoryId}&listType=gridtable&orderby=docPublishTime&ordertype=down'}
				</ui:source>
				<list:row-template ref="sys.ui.listview.gridtable" >
				</list:row-template>
			</list:gridTable>
		</list:listview>
		<%-- 列表分页 --%>
	 	<list:paging></list:paging>
	</template:replace>
</template:include>
<script src="${LUI_ContextPath}/resource/js/calendar.js"></script>
<script type="text/javascript">
	seajs.use('kms/multidoc/kms_multidoc_ui/style/index.css');
</script>
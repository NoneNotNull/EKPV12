<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.list" width="980px">
	<template:replace name="title">${lfn:message('kms-kmtopic:module.kms.kmtopic') }</template:replace>
	<%-- 当前路径 --%>
	<template:replace name="path">
		<ui:combin ref="menu.path.simplecategory">
			<ui:varParams 
				id="simplecategoryId"
				modelName="com.landray.kmss.kms.kmtopic.model.KmsKmtopicCategory" 
				moduleTitle="${lfn:message('kms-kmtopic:module.kms.kmtopic') }"
				href="/kms/kmtopic/"
				categoryId="${param.categoryId }"/>
		</ui:combin>
	</template:replace>
	<%-- 左边栏 --%>
	<template:replace name="nav">
	
		<!-- 所有分类 -->
		<ui:combin ref="menu.nav.simplecategory.all"> 
			<ui:varParams 
				modelName="com.landray.kmss.kms.kmtopic.model.KmsKmtopicCategory" 
				href="/kms/kmtopic/"/>
		</ui:combin>
		
		<%-- 我要分享--按钮 --%>
		<ui:combin ref="menu.nav.create"> 
			<ui:varParam name="title" value="${lfn:message('kms-kmtopic:module.kms.kmtopic') }"></ui:varParam>
			<ui:varParam name="button">
				[
					<kmss:authShow roles="ROLE_KMSKMTOPIC_CREATE">
					{
						"text": "${lfn:message('kms-kmtopic:kmsKmtopic.share') }",
						"href": "javascript:addTopic()",
						"icon": "lui_icon_l_icon_28"
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
						modelName="com.landray.kmss.kms.kmtopic.model.KmsKmtopicCategory"
						href="/kms/kmtopic/?categoryId=!{value}" />
				</ui:combin>
				
				<%-- 分类索引 --%>
				<ui:content title="${lfn:message('sys-simplecategory:menu.sysSimpleCategory.index') }" style="padding:0px">
					<ui:combin ref="menu.nav.simplecategory.flat">
						<ui:varParams 
							modelName="com.landray.kmss.kms.kmtopic.model.KmsKmtopicCategory" 
							href="/kms/kmtopic/"
							categoryId="${param.categoryId }"
							expand="true" />
					</ui:combin>
					<c:if test="${not empty param.categoryId}">
						<ui:operation href="javascript:LUI('simplecategoryId').gotoNav(-1)" target="_self" name="${lfn:message('list.lever.up') }" align ="left"/>
					</c:if>		
					<ui:operation href="javascript:openPage('${LUI_ContextPath }/sys/sc/categoryPreivew.do?method=forward&service=kmsKmtopicCategoryPreManagerService&currid=${param.categoryId}')" name="${lfn:message('sys-category:menu.sysCategory.overview') }" target="_self" />
				</ui:content>
				<%-- 常用查询 --%>
				<ui:content title="${ lfn:message('list.search') }">
					<ul class='lui_list_nav_list'>
						<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('mydoc', 'create');">${ lfn:message('list.create') }</a></li>
						<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('mydoc', 'approval');">${ lfn:message('list.approval') }</a></li>
						<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('mydoc', 'approved');">${ lfn:message('list.approved') }</a></li>
						<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('docIsIntroduced','1');">${lfn:message('kms-kmtopic:kmsKmtopic.tree.introduced')}</a></li>
						<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').clearValue();">${ lfn:message('kms-kmtopic:kmsKmtopic.tree.all') }</a></li>
					</ul>
				</ui:content>
				
				<%-- 后台配置 --%>
				<kmss:authShow roles="ROLE_KMSKMTOPIC_BACKSTAGE_MANAGER">
					<ui:content title="${ lfn:message('list.otherOpt')}">  
						<ul class='lui_list_nav_list'>
							<li><a href="${LUI_ContextPath }/sys/?module=kms/kmtopic" target="_blank">${ lfn:message('list.manager') }</a></li>
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
			<list:cri-criterion title="${lfn:message('kms-kmtopic:kmsKmtopic.myTopic') }" key="mydoc" expand="false" multi="false">
				<list:box-select >
					<list:item-select >
						<ui:source type="Static">
							[{text:'${ lfn:message('list.create') }', value:'create'},{text:'${ lfn:message('list.approval') }',value:'approval'}, {text:'${ lfn:message('list.approved') }', value: 'approved'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
			<list:cri-auto modelName="com.landray.kmss.kms.kmtopic.model.KmsKmtopicMain" 
				property="docStatus;docIsIntroduced"/>
			<list:cri-auto modelName="com.landray.kmss.kms.kmtopic.model.KmsKmtopicMain" 
				property="docAuthor;docDept"/>
			<list:cri-property modelName="com.landray.kmss.kms.kmtopic.model.KmsKmtopicCategory" categoryId="${param.categoryId }"/>
		</list:criteria>
		
		<%-- 按钮 --%>
		<div class="lui_list_operation">
					<div style='color: #979797;float: left;padding-top:1px;'> 
						${ lfn:message('kms-kmtopic:kmsKmtopic.list.orderType') }：
					</div>
					<%--排序按钮  --%>
					<div style="float: left;">
						<div style="display: inline-block;vertical-align: middle;">
							<ui:toolbar layout="sys.ui.toolbar.sort" >
								<list:sort property="kmsKmtopicMain.docPublishTime" text="${lfn:message('kms-kmtopic:kmsKmtopic.docPublishTime') }" group="sort.list"></list:sort>
								<list:sort property="kmsKmtopicMain.docReadCount" text="${lfn:message('kms-kmtopic:kmsKmtopic.readCount') }" group="sort.list"></list:sort>
							</ui:toolbar>
						</div>
					</div>
					<div style="float:left;">
						<list:paging layout="sys.ui.paging.top"> 		
						</list:paging>
					</div>
					<%--操作按钮  --%>
					<div style="float: right;">
						<div style="display: inline-block;vertical-align: middle;">
							<ui:toolbar count="4">
								<ui:togglegroup order="0">
									<ui:toggle icon="lui_icon_s_zaiyao" title="${ lfn:message('list.rowTable') }" selected="true" group="tg_1" value="rowtable"
										text="${ lfn:message('list.rowTable') }" onclick="LUI('listview').switchType(this.value);LUI('fileType');">
									</ui:toggle>
									<ui:toggle icon="lui_icon_s_tuwen" title="${lfn:message('list.gridTable') }" group="tg_1" value="gridtable"
										text="${lfn:message('list.gridTable') }" onclick="LUI('listview').switchType(this.value);LUI('fileType');">
									</ui:toggle>
									<ui:toggle icon="lui_icon_s_liebiao" 
										title="${ lfn:message('list.columnTable') }"  group="tg_1" value="columntable"
										text="${ lfn:message('list.columnTable') }" onclick="LUI('listview').switchType(this.value);LUI('fileType');">
									</ui:toggle>
								</ui:togglegroup>
								<%-- 新增删除属性修改--%>
								<c:import url="/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain_button.jsp" charEncoding="UTF-8"></c:import>
								<%-- 收藏 --%>
								<c:import url="/sys/bookmark/import/bookmark_bar_all.jsp" charEncoding="UTF-8">
									<c:param name="fdTitleProName" value="docSubject" />
									<c:param name="fdModelName"	value="com.landray.kmss.kms.kmtopic.model.KmsKmtopicMain" />
								</c:import>
								<%-- 修改权限 --%>
									<c:import url="/sys/right/import/doc_right_change_button.jsp" charEncoding="UTF-8">
									<c:param name="modelName" value="com.landray.kmss.kms.kmtopic.model.KmsKmtopicMain" />
									<c:param name="categoryId" value="${param.categoryId }" />
								</c:import>							
								<%-- 分类转移 --%>
								<c:import url="/sys/simplecategory/import/doc_cate_change_button.jsp" charEncoding="UTF-8">
									<c:param name="modelName" value="com.landray.kmss.kms.kmtopic.model.KmsKmtopicMain" />
									<c:param name="docFkName" value="docCategory" />
									<c:param name="cateModelName" value="com.landray.kmss.kms.kmtopic.model.KmsKmtopicCategory" />
								</c:import>
								<%-- 取消推荐 --%>
								<c:import url="/sys/introduce/import/sysIntroduceMain_cancelbtn.jsp" charEncoding="UTF-8">
									<c:param name="fdModelName" value="com.landray.kmss.kms.kmtopic.model.KmsKmtopicMain" />
								</c:import>
							</ui:toolbar>
						</div>
				</div>
		</div>
		
		<ui:fixed elem=".lui_list_operation"></ui:fixed>
		
		<%--列表视图  --%>
		<list:listview id="listview">
			<ui:source type="AjaxJson">
				{url:'/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMainIndex.do?method=listChildren&categoryId=${param.categoryId}&orderby=docPublishTime&ordertype=down&rowsize=16'}
			</ui:source>
			
			<%-- 摘要视图--%>
			<list:rowTable layout="sys.ui.listview.rowtable" 
				name="rowtable" onRowClick="" rowHref="/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain.do?method=view&fdId=!{fdId}" 
				style="" target="_blank"> 
				<list:row-template ref="sys.ui.listview.rowtable">
				{
					showOtherProps:"docReadCount;docScore"
				}
				</list:row-template>
			</list:rowTable>
			
			<%-- 列表视图--%>  
			<list:colTable layout="sys.ui.listview.columntable" name="columntable"
				rowHref="/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain.do?method=view&fdId=!{fdId}">
				<%@ include file="/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain_col_tmpl.jsp" %>
			</list:colTable>
			
			<%-- 视图列表 --%>
			<list:gridTable name="gridtable" columnNum="4" gridHref="/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain.do?method=view&fdId=!{fdId}">
				<ui:source type="AjaxJson">
					{url:'/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMainIndex.do?method=listChildren&categoryId=${param.categoryId}&rowsize=16&orderby=docPublishTime&ordertype=down&dataType=pic'}
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
	var SYS_SEARCH_MODEL_NAME = "com.landray.kmss.kms.kmtopic.model.KmsKmtopicMain";
</script>

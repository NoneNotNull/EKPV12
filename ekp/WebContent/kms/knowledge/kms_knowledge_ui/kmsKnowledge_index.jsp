<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ include file="/kms/knowledge/kms_knowledge_ui/kmsKnowledge_categoryId_handle.jsp"%>
<template:include ref="default.list" width="980px">
	<template:replace name="title">${lfn:message('kms-knowledge:module.kms.knowledge') }</template:replace>
	<template:replace name="head">
		<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/kms/knowledge/kms_knowledge_ui/style/index.css">
	</template:replace>
	<%-- 当前路径 --%>
	<template:replace name="path">
		<ui:combin ref="menu.path.simplecategory">
			<ui:varParams 
				id="simplecategoryId"
				modelName="com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory" 
				moduleTitle="${lfn:message('kms-knowledge:module.kms.knowledge') }"
				href="/kms/knowledge/"
				categoryId="${categoryId }" />
		</ui:combin>
	</template:replace>
	<%-- 左边栏 --%>
	<template:replace name="nav">
	
		<!-- 所有分类 -->
		<ui:combin ref="menu.nav.simplecategory.all"> 
			<ui:varParams 
				modelName="com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory" 
				href="/kms/knowledge/" />
		</ui:combin>
		
		<%-- 我要分享--按钮 --%>
		<ui:combin ref="menu.nav.create"> 
			<ui:varParam name="title" value="${lfn:message('kms-knowledge:module.kms.knowledge') }"></ui:varParam>
			<ui:varParam name="button">
				[
					<kmss:auth requestURL="/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDoc.do?method=add" requestMethod="GET">
					{
						"text": "${lfn:message('kms-knowledge:kmsKnowledge.share') }",
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
						href="/kms/knowledge/?categoryId=!{value}"/>
				</ui:combin>
				
				<%-- 分类索引 --%>
				<ui:content title="${lfn:message('sys-simplecategory:menu.sysSimpleCategory.index') }" style="padding:0px">
					<ui:combin ref="menu.nav.simplecategory.flat">
						<ui:varParams 
							modelName="com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory" 
							href="/kms/knowledge/"
							categoryId="${categoryId }"
							expand="true" />
					</ui:combin>
					<c:if test="${not empty categoryId}">
						<ui:operation href="javascript:LUI('simplecategoryId').gotoNav(-1)" target="_self" name="${lfn:message('list.lever.up') }" align ="left"/>
					</c:if>				
					<ui:operation 
						href="javascript:openPage('${LUI_ContextPath }/sys/sc/categoryPreivew.do?method=forward&service=kmsKnowledgeCategoryPreManagerService&currid=${categoryId}')" 
						name="${lfn:message('sys-category:menu.sysCategory.overview') }" 
						target="_self" />
				</ui:content>
				<%-- 常用查询 --%>
				<ui:content title="${ lfn:message('list.search') }">
					<ul class='lui_list_nav_list'>
						<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('mydoc', 'create');">${ lfn:message('list.create') }</a></li>
						<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('mydoc', 'approval');">${ lfn:message('list.approval') }</a></li>
						<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('mydoc', 'approved');">${ lfn:message('list.approved') }</a></li>
						<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('docIsIntroduced','1');">${lfn:message('kms-knowledge:kmsKnowledge.introduced')}</a></li>
						<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').clearValue();">${ lfn:message('list.alldoc') }</a></li>
						<li>
							<a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('docStatus', '10');">我的草稿箱</a>
						</li>
					</ul>
				</ui:content>
				
				<%-- 后台配置 --%>
				<kmss:authShow roles="ROLE_KMSKNOWLEDGE_BACKSTAGE_MANAGER">
					<ui:content title="${ lfn:message('list.otherOpt')}">  
						<ul class='lui_list_nav_list'>
							<li><a href="${LUI_ContextPath }/sys/?module=kms/knowledge" target="_blank">${ lfn:message('list.manager') }</a></li>
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
			<list:cri-property modelName="com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory" categoryId="${categoryId }"/>
			<list:cri-auto modelName="com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc" 
				property="docDept;docAuthor"/>
			<list:cri-criterion title="${lfn:message('kms-knowledge:kmsKnowledge.myknowledge') }" key="mydoc" expand="false" multi="false">
				<list:box-select >
					<list:item-select >
						<ui:source type="Static">
							[{text:'${ lfn:message('list.create') }', value:'create'},{text:'${ lfn:message('list.approval') }',value:'approval'}, {text:'${ lfn:message('list.approved') }', value: 'approved'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
			<list:cri-criterion title="${lfn:message('kms-knowledge:kmsKnowledgeCategory.fdTemplateType') }" key="template" expand="false">
				<list:box-select >
					<list:item-select >
						<ui:source type="Static">
							[{text:'${ lfn:message('kms-knowledge:title.kms.multidoc') }', value:'1'},{text:'${ lfn:message('kms-knowledge:title.kms.wiki') }',value:'2'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
			<list:cri-criterion title="${lfn:message('kms-knowledge:kmsKnowledge.fileType')}" key="fileType" expand="false" multi="true"> 
				<list:box-select >
					<list:item-select cfg-enable="false" id="fileType">
						<ui:source type="Static">
							[{text:'DOC', value:'doc'}, {text:'PPT', value: 'ppt'}, {text:'PDF',value:'pdf'},{text:'XLS', value: 'excel'},
							{text:'${lfn:message('kms-knowledge:kmsKnowledge.pic')}', value: 'pic'},{text:'${lfn:message('kms-knowledge:kmsKnowledge.sound')}', value: 'sound'}, 
							{text:'${lfn:message('kms-knowledge:kmsKnowledge.video')}', value: 'video'},
							{text:'${lfn:message('kms-knowledge:kmsKnowledge.others')}', value: 'others'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
			<list:cri-auto modelName="com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc" 
				property="docStatus;docIsIntroduced"/>
		</list:criteria>
		
		<%-- 按钮 --%>
		<div class="lui_list_operation">
				<div class="lui_knowledge_order_text"> 
					${lfn:message('kms-knowledge:kmsKnowledge.list.orderType')}：
				</div>
				<%--排序按钮  --%>
				<div  class="lui_knowledge_order_btn">
					<div  class="lui_knowledge_order_btn_inner">
						<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" > 
							<list:sort property="kmsKnowledgeBaseDoc.docPublishTime" 
									   text="${lfn:message('kms-knowledge:kmsKnowledge.docPublishTime') }" 
									   group="sort.list" value="down"/>
							<list:sort property="kmsKnowledgeBaseDoc.docReadCount" 
									   text="${lfn:message('kms-knowledge:kmsKnowledge.readCount') }" 
									   group="sort.list"/>	
						</ui:toolbar>
					</div>
				</div>
				<div  class="lui_knowledge_page_top">
					<list:paging layout="sys.ui.paging.top" > 		
					</list:paging>
				</div>
				<div  class="lui_knowledge_toolbar">
					<div  class="lui_knowledge_toolbar_inner">
						<ui:toolbar count="4" id="knowledge_toolbar">
							<ui:togglegroup order="0">
								<ui:toggle icon="lui_icon_s_zaiyao" title="${ lfn:message('list.rowTable') }" selected="true" group="tg_1" value="rowtable"
									text="${ lfn:message('list.rowTable') }" onclick="LUI('listview').switchType(this.value);LUI('fileType').setEnable(false);">
								</ui:toggle>
								<ui:toggle icon="lui_icon_s_tuwen" title="${lfn:message('list.gridTable') }" group="tg_1" value="gridtable"
									text="${lfn:message('list.gridTable') }" onclick="LUI('listview').switchType(this.value);LUI('fileType').setEnable(false);">
								</ui:toggle>
								<ui:toggle icon="lui_icon_s_liebiao" 
									title="${ lfn:message('list.columnTable') }"  group="tg_1" value="columntable"
									text="${ lfn:message('list.columnTable') }" onclick="LUI('listview').switchType(this.value);LUI('fileType').setEnable(false);">
								</ui:toggle>
								<ui:toggle icon="lui_icon_s_fujian" 
									title="${ lfn:message('kms-knowledge:kmsKnowledge.att')}"  group="tg_1" value="attmaintable"
									text="${lfn:message('kms-knowledge:kmsKnowledge.att')}" onclick="LUI('listview').switchType(this.value);LUI('fileType').setEnable(true);">
								</ui:toggle>
							</ui:togglegroup>
							<%-- 新增删除属性修改--%>
							<c:import url="/kms/knowledge/kms_knowledge_ui/kmsKnowledge_button.jsp" charEncoding="UTF-8">
								<c:param name="categoryId" value="${categoryId}"></c:param>
							</c:import>
							<%-- 收藏 --%>
							<c:import url="/sys/bookmark/import/bookmark_bar_all.jsp" charEncoding="UTF-8">
								<c:param name="fdTitleProName" value="docSubject" />
								<c:param name="fdModelName"	value="com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc" />
							</c:import>
							<%-- 修改权限 --%>
							<c:import url="/sys/right/import/doc_right_change_button.jsp" charEncoding="UTF-8">
								<c:param name="modelName" value="com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc" />
								<c:param name="categoryId" value="${categoryId }" />
							</c:import>							
							<%-- 取消推荐 --%>
							<c:import url="/sys/introduce/import/sysIntroduceMain_cancelbtn.jsp" charEncoding="UTF-8">
								<c:param name="fdModelName" value="com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc" />
							</c:import>
							<%--批量导入 --%>
							<kmss:auth requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=add" requestMethod="GET">
	                            <c:import url="/kms/knowledge/kms_knowledge_multiple_upload/kms_multiple_upload.jsp" charEncoding="UTF-8">
									<c:param name="fdCategoryModelName"	value="com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory" />
									<c:param name="fdMainModelName"	value="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge" />
									<c:param name="categoryIndicateName" value="fdTemplateId" />
									<c:param name="fdKey" value="attachment" />
									<c:param name="pathTitle"	value="kms-multidoc:title.kms.multidoc" />
							    </c:import>	
                            </kmss:auth>
						</ui:toolbar>
					</div>
				</div>
		</div>
		<ui:fixed elem=".lui_list_operation"></ui:fixed>
		<%--列表视图  --%>
		<list:listview id="listview">
			<ui:source type="AjaxJson">
				{url:'/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDocIndex.do?method=listChildren&categoryId=${categoryId}&orderby=kmsKnowledgeBaseDoc.docPublishTime&ordertype=down'}
			</ui:source>
			
			<%-- 摘要视图--%>
			<list:rowTable layout="sys.ui.listview.rowtable" 
				name="rowtable" onRowClick="" rowHref="/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDoc.do?method=view&fdId=!{fdId}&fdKnowledgeType=!{fdKnowledgeType}" 
				style="" target="_blank"> 
				<list:row-template ref="sys.ui.listview.rowtable">
				{
					showOtherProps:"docReadCount;docScore"
				}
				</list:row-template>
			</list:rowTable>
			
			
			<%-- 列表视图--%>
			<list:colTable layout="sys.ui.listview.columntable" name="columntable"
				rowHref="/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDoc.do?method=view&fdId=!{fdId}&fdKnowledgeType=!{fdKnowledgeType}">
				<%@ include file="/kms/knowledge/kms_knowledge_ui/kmsKnowledge_col_tmpl.jsp"%>
			</list:colTable>
			<%-- 视图列表 --%>
			<list:gridTable name="gridtable" columnNum="4" gridHref="/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDoc.do?method=view&fdId=!{fdId}&fdKnowledgeType=!{fdKnowledgeType}">
				<ui:source type="AjaxJson">
					{url:'/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDocIndex.do?method=listChildren&categoryId=${categoryId}&orderby=kmsKnowledgeBaseDoc.docPublishTime&ordertype=down&dataType=pic'}
				</ui:source>
				<list:row-template ref="sys.ui.listview.gridtable" >
				</list:row-template>
			</list:gridTable>
			
			<%-- 附件视图--%>
			<list:colTable layout="sys.ui.listview.columntable" name="attmaintable"
				rowHref="/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDoc.do?method=view&fdId=!{fdId}&fdKnowledgeType=!{fdKnowledgeType}">
				<ui:source type="AjaxJson"> 
					{url:'/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDocIndex.do?method=getSysAttList&orderby=kmsKnowledgeBaseDoc.docPublishTime&categoryId=${categoryId}'}
				</ui:source>
				<list:col-checkbox name="List_Selected" style="width:5%"></list:col-checkbox>
				<list:col-serial title="${ lfn:message('page.serial') }" headerStyle="width:5%"></list:col-serial>
				<list:col-html title="${lfn:message('kms-knowledge:kmsKnowledge.attName')}" style="width:35%;text-align:left;padding:0 8px">
					{$
						<span class="com_subject">{%row['attName']%}</span> 
					$}
				</list:col-html>
				<list:col-html title="${lfn:message('kms-knowledge:kmsKnowledge.uploader')}" >
					{$
						<span class="com_author">{%row['attCreator']%}</span> 
					$}
				</list:col-html>
				<list:col-auto props="attSize;uploadTime"></list:col-auto>
				<list:col-html title="${lfn:message('kms-knowledge:kmsKnowledge.docSubject')}" style="width:25%;text-align:left;padding:0 8px">
					{$
						<span class="com_subject">{%row['docSubject']%}</span> 
					$}
				</list:col-html>
			</list:colTable>
		</list:listview>
		<%-- 列表分页 --%>
	 	<list:paging></list:paging>
	</template:replace>
</template:include>
<script> 
	Com_IncludeFile("calendar.js"); 
</script>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ include file="/kms/knowledge/kms_knowledge_ui/kmsKnowledge_categoryId_handle.jsp"%>
<template:include ref="default.list" width="980px">
	<template:replace name="title">${lfn:message('kms-multidoc:title.kms.multidoc') }</template:replace>
	<%-- 当前路径 --%>
	<template:replace name="path">
		<ui:combin ref="menu.path.simplecategory">
			<ui:varParams 
				id="simplecategoryId"
				modelName="com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory" 
				moduleTitle="${lfn:message('kms-multidoc:title.kms.multidoc') }"
				href="/kms/multidoc/"
				categoryId="${categoryId }"
				extProps="{'fdTemplateType':'1,3'}" />
		</ui:combin>
	</template:replace>
	<%-- 左边栏 --%>
	<template:replace name="nav">
	
		<!-- 所有分类 -->
		<ui:combin ref="menu.nav.simplecategory.all"> 
			<ui:varParams 
				modelName="com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory" 
				href="/kms/multidoc/" 
				extProps="{'fdTemplateType':'1,3'}"/>
		</ui:combin>
		
		<%-- 我要分享--按钮 --%>
		<ui:combin ref="menu.nav.create"> 
			<ui:varParam name="title" value="${lfn:message('kms-multidoc:title.kms.multidoc') }"></ui:varParam>
			<ui:varParam name="button">
				[
					<kmss:authShow roles="ROLE_KMSKNOWLEDGE_CREATE">
					{
						"text": "${lfn:message('kms-multidoc:kmsMultidoc.share') }",
						"href": "javascript:addDoc()",
						"icon": "lui_icon_l_icon_1"
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
						modelName="com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory"
						href="/kms/multidoc/?categoryId=!{value}" />
				</ui:combin>
				
				<%-- 分类索引 --%>
				<ui:content title="${lfn:message('sys-simplecategory:menu.sysSimpleCategory.index') }" style="padding:0px">
					<ui:combin ref="menu.nav.simplecategory.flat">
						<ui:varParams 
							modelName="com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory" 
							href="/kms/multidoc/"
							categoryId="${categoryId }"
							extProps="{'fdTemplateType':'1,3'}"/>
					</ui:combin>
					<c:if test="${not empty categoryId}">
						<ui:operation href="javascript:LUI('simplecategoryId').gotoNav(-1)" target="_self" name="${lfn:message('list.lever.up') }" align ="left"/>
					</c:if>				
					<ui:operation href="javascript:openPage('${LUI_ContextPath }/sys/sc/categoryPreivew.do?method=forward&service=kmsMultidocCategoryPreManagerService&currid=${categoryId}')" name="${lfn:message('sys-category:menu.sysCategory.overview') }" target="_self" />
				</ui:content>
				<%-- 常用查询 --%>
				<ui:content title="${ lfn:message('list.search') }">
					<ul class='lui_list_nav_list'>
						<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('mydoc', 'create');">${ lfn:message('list.create') }</a></li>
						<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('mydoc', 'approval');">${ lfn:message('list.approval') }</a></li>
						<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('mydoc', 'approved');">${ lfn:message('list.approved') }</a></li>
						<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('docIsIntroduced','1');">${lfn:message('kms-multidoc:kmsMultidoc.tree.introduced')}</a></li>
						<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').clearValue();">${ lfn:message('list.alldoc') }</a></li>
						<li>
							<a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('docStatus','10');">我的草稿箱</a>
						</li>
		           </ul>
				</ui:content>
				
				<%-- 后台配置 --%>
				<kmss:authShow roles="ROLE_KMSMULTIDOC_BACKSTAGE_MANAGER">
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
			<list:cri-auto modelName="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge" 
				property="docDept;docAuthor"/>
			<list:cri-criterion title="${lfn:message('kms-multidoc:kmsMultidoc.kmsMultidocKnowledge.my') }" key="mydoc" expand="false" multi="false">
				<list:box-select >
					<list:item-select >
						<ui:source type="Static">
							[{text:'${ lfn:message('list.create') }', value:'create'},{text:'${ lfn:message('list.approval') }',value:'approval'}, {text:'${ lfn:message('list.approved') }', value: 'approved'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
			<list:cri-criterion title="${lfn:message('kms-multidoc:kmsMultidoc.fileType')}" key="fileType" expand="false" multi="true"> 
				<list:box-select >
					<list:item-select cfg-enable="false" id="fileType">
						<ui:source type="Static">
							[{text:'DOC', value:'doc'}, {text:'PPT', value: 'ppt'}, {text:'PDF',value:'pdf'},{text:'XLS', value: 'excel'},
							{text:'${lfn:message('kms-multidoc:kmsMultidoc.pic')}', value: 'pic'},{text:'${lfn:message('kms-multidoc:kmsMultidoc.sound')}', value: 'sound'}, 
							{text:'${lfn:message('kms-multidoc:kmsMultidoc.video')}', value: 'video'},
							{text:'${lfn:message('kms-multidoc:kmsMultidoc.others')}', value: 'others'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
			<list:cri-auto modelName="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge" 
				property="docStatus;docIsIntroduced"/>
		</list:criteria>
		
		<%-- 按钮 --%>
		<div class="lui_list_operation">
					<div style='color: #979797;float: left;padding-top:1px;'> 
						${ lfn:message('kms-multidoc:kmsMultidocKnowledge.list.orderType') }：
					</div>
					<%--排序按钮  --%>
					<div style="float:left">
						<div style="display: inline-block;vertical-align: middle;">
						<ui:toolbar layout="sys.ui.toolbar.sort" >
							<list:sort property="kmsMultidocKnowledge.docPublishTime" text="${lfn:message('kms-multidoc:kmsMultidoc.kmsMultidocKnowledge.docPublishTime') }" group="sort.list" value="down"></list:sort>
							<list:sort property="kmsMultidocKnowledge.docReadCount" text="${lfn:message('kms-multidoc:kmsMultidoc.kmsMultidocKnowledge.readCount') }" group="sort.list"></list:sort>
						</ui:toolbar>
						</div>
					</div>
					<div style="float:left;">
						<list:paging layout="sys.ui.paging.top">		
						</list:paging>
					</div>
					<%--操作按钮  --%>
					<div style="float:right">
						<div style="display: inline-block;vertical-align: middle;">
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
									title="${ lfn:message('kms-multidoc:kmsMultidoc.attList')}"  group="tg_1" value="attmaintable"
									text="${lfn:message('kms-multidoc:kmsMultidoc.attList')}" onclick="LUI('listview').switchType(this.value);LUI('fileType').setEnable(true);">
								</ui:toggle>
							</ui:togglegroup>
							<%-- 新增删除属性修改--%>
							<c:import url="/kms/multidoc/kms_multidoc_ui/kmsMultidocKnowledge_button.jsp" charEncoding="UTF-8">
								<c:param name="categoryId" value="${categoryId}"></c:param>
							</c:import>
							<%-- 收藏 --%>
							<c:import url="/sys/bookmark/import/bookmark_bar_all.jsp" charEncoding="UTF-8">
								<c:param name="fdTitleProName" value="docSubject" />
								<c:param name="fdModelName"	value="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge" />
							</c:import>
							<%-- 修改权限 --%>
							<c:import url="/sys/right/import/doc_right_change_button.jsp" charEncoding="UTF-8">
								<c:param name="modelName" value="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge" />
								<c:param name="categoryId" value="${categoryId }" />
							</c:import>							
							<%-- 分类转移 --%>
							<c:import url="/sys/simplecategory/import/doc_cate_change_button.jsp" charEncoding="UTF-8">
								<c:param name="modelName" value="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge" />
								<c:param name="docFkName" value="docCategory" />
								<c:param name="cateModelName" value="com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory" />
								<c:param name="extProps" value="fdTemplateType:1;fdTemplateType:3" />
							</c:import>
							<%-- 取消推荐 --%>
							<c:import url="/sys/introduce/import/sysIntroduceMain_cancelbtn.jsp" charEncoding="UTF-8">
								<c:param name="fdModelName" value="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge" />
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
				{url:'/kms/multidoc/kms_multidoc_index/kmsMultidocKnowledgeIndex.do?method=listChildren&categoryId=${categoryId}&orderby=docPublishTime&ordertype=down'}
			</ui:source>
			
			<%-- 摘要视图--%>
			<list:rowTable layout="sys.ui.listview.rowtable" 
				name="rowtable" onRowClick="" rowHref="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=view&fdId=!{fdId}" 
				style="" target="_blank"> 
				<list:row-template ref="sys.ui.listview.rowtable">
				{
					showOtherProps:"docReadCount;docScore"
				}
				</list:row-template>
			</list:rowTable>
			
			<%-- 列表视图--%>
			<list:colTable layout="sys.ui.listview.columntable" name="columntable"
				rowHref="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=view&fdId=!{fdId}">
				<%@ include file="/kms/multidoc/kms_multidoc_ui/kmsMultidocKnowledge_col_tmpl.jsp" %>
			</list:colTable>
			<%-- 视图列表 --%>
			<list:gridTable name="gridtable" columnNum="4" gridHref="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=view&fdId=!{fdId}">
				<ui:source type="AjaxJson">
					{url:'/kms/multidoc/kms_multidoc_index/kmsMultidocKnowledgeIndex.do?method=listChildren&categoryId=${categoryId}&orderby=docPublishTime&ordertype=down&dataType=pic'}
				</ui:source>
				<list:row-template ref="sys.ui.listview.gridtable" >
				</list:row-template>
			</list:gridTable>
			
			<%-- 附件视图--%>
			<list:colTable layout="sys.ui.listview.columntable" name="attmaintable"
				rowHref="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=view&fdId=!{fdId}">
				<ui:source type="AjaxJson">
					{url:'/kms/multidoc/kms_multidoc_index/kmsMultidocKnowledgeIndex.do?method=getSysAttList&orderby=docPublishTime&categoryId=${categoryId}'}
				</ui:source>
				<list:col-checkbox name="List_Selected" style="width:5%"></list:col-checkbox>
				<list:col-serial title="${ lfn:message('page.serial') }" headerStyle="width:5%"></list:col-serial>
				<list:col-html title="${lfn:message('kms-multidoc:kmsMultidoc.attName')}" style="width:35%;text-align:left;padding:0 8px">
					{$
						<span class="com_subject">{%row['attName']%}</span> 
					$}
				</list:col-html>
				<list:col-html title="${lfn:message('kms-multidoc:kmsMultidoc.uploader')}" >
					{$
						<span class="com_author">{%row['attCreator']%}</span> 
					$}
				</list:col-html>
				<list:col-auto props="attSize;uploadTime"></list:col-auto>
				<list:col-html title="${lfn:message('kms-multidoc:kmsMultidoc.docSubject')}" style="width:25%;text-align:left;padding:0 8px">
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
<script src="${LUI_ContextPath}/resource/js/calendar.js"></script>
<script type="text/javascript">
	seajs.use('kms/multidoc/kms_multidoc_ui/style/index.css');
	var SYS_SEARCH_MODEL_NAME = "com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge";
</script>

<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<template:include ref="default.list" width="980px">
	<template:replace name="head">
		<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/kms/ask/kms_ask_ui/style/index.css" />
	</template:replace>
	<template:replace name="title">${lfn:message('kms-ask:title.kms.ask') }</template:replace>
	<template:replace name="path">
		<ui:combin ref="menu.path.simplecategory">
			<ui:varParams id="simplecategoryId"
				modelName="com.landray.kmss.kms.ask.model.KmsAskCategory" 
				moduleTitle="${lfn:message('kms-ask:title.kms.ask') }"
				href="/kms/ask/"
				categoryId="${param.categoryId }" />
		</ui:combin>
	</template:replace>
	<template:replace name="nav">
		<!-- 所有分类 -->
		<ui:combin ref="menu.nav.simplecategory.all"> 
			<ui:varParams 
				modelName="com.landray.kmss.kms.ask.model.KmsAskCategory" 
				href="/kms/ask/" />
		</ui:combin>
		
		<%-- 我要分享--按钮 --%>
		<ui:combin ref="menu.nav.create"> 
			<ui:varParam name="title" value="${lfn:message('kms-ask:title.kms.ask') }"></ui:varParam>
			<ui:varParam name="button">
				[
					<kmss:authShow roles="ROLE_KMSASKTOPIC_CREATE">
					{
						"text": "${lfn:message('kms-ask:kmsAsk.ask') }",
						"href": "javascript:addAsk()",
						"icon": "lui_icon_l_icon_45"
					}
					</kmss:authShow>
				]
			</ui:varParam>
		</ui:combin>
		<div class="lui_list_nav_frame">
			<ui:accordionpanel>
				<!-- 常用分类 -->
				<ui:combin ref="menu.nav.favorite.category">
					<ui:varParams 
						modelName="com.landray.kmss.kms.ask.model.KmsAskCategory"
						href="/kms/ask/?categoryId=!{value}" />
				</ui:combin>
				<!-- 分类索引 -->
				<ui:content title="${lfn:message('sys-simplecategory:menu.sysSimpleCategory.index') }" style="padding:0px">
					<ui:combin ref="menu.nav.simplecategory.flat">
						<ui:varParams 
							content="false"
							modelName="com.landray.kmss.kms.ask.model.KmsAskCategory" 
							href="/kms/ask/"
							categoryId="${param.categoryId }"
							expand="true" />
					</ui:combin>
					<c:if test="${not empty param.categoryId}">
						<ui:operation href="javascript:LUI('simplecategoryId').gotoNav(-1)" target="_self" name="${lfn:message('list.lever.up') }" align ="left"/>
					</c:if>	
					<ui:operation 
						href="javascript:openPage('${LUI_ContextPath }/sys/sc/categoryPreivew.do?method=forward&service=kmsAskTopicCategoryPreManagerService&currid=${param.categoryId}')" 
						name="${lfn:message('sys-category:menu.sysCategory.overview') }" 
						target="_self" />	
				</ui:content>
				<%-- 常用查询 --%>
				<ui:content title="${ lfn:message('list.search') }">
					<ul class='lui_list_nav_list'>
						<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('myknow', 'myask');">${ lfn:message('kms-ask:kmsAskTopic.fdMyAsk') }</a></li>
						<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('myknow', 'myanswer');">${ lfn:message('kms-ask:kmsAskTopic.fdMyAnswer') }</a></li>
						<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').clearValue();">${ lfn:message('kms-ask:kmsAskTopic.fdAllKnow') }</a></li>
						<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('intro', 'introduce');">${ lfn:message('kms-ask:kmsAskTopic.fdIntroKnow') }</a></li>
					</ul>
				</ui:content>
				<%-- 后台配置 --%>
				<kmss:authShow roles="ROLE_KMSASKTOPIC_BACKSTAGE_MANAGER">
					<ui:content title="${ lfn:message('list.otherOpt') }">
						<ul class='lui_list_nav_list'>
							<li><a href="${LUI_ContextPath }/sys/?module=kms/ask" target="_blank">${ lfn:message('list.manager') }</a></li>
						</ul>
					</ui:content>
				</kmss:authShow>
			</ui:accordionpanel>
		</div>
	</template:replace>
	 
	<template:replace name="content">
		<list:criteria id="criteria1">
			<list:cri-ref key="docSubject" ref="criterion.sys.docSubject">
			</list:cri-ref>
			<list:cri-criterion title="${lfn:message('kms-ask:kmsAskTopic.fdStatus') }" key="status">
				<list:box-select>
					<list:item-select>
						<ui:source type="Static">
							[{text:'${ lfn:message('kms-ask:kmsAskTopic.fdWait') }', value:'waitSolve'},{text:'${ lfn:message('kms-ask:kmsAskTopic.fdSolve') }',value:'solve'},{text:'${ lfn:message('kms-ask:kmsAskTopic.fdBest') }',value:'best'},{text:'${ lfn:message('kms-ask:kmsAskTopic.fdHighScore') }',value:'highscore'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
		
			<list:cri-criterion title="${lfn:message('kms-ask:kmsAskTopic.fdmyknow') }" key="myknow">
				<list:box-select>
					<list:item-select>
						<ui:source type="Static">
							[{text:'${ lfn:message('kms-ask:kmsAskTopic.fdMyAsk') }', value:'myask'},{text:'${ lfn:message('kms-ask:kmsAskTopic.fdMyAnswer') }',value:'myanswer'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
			
			<list:cri-criterion title="${lfn:message('kms-ask:kmsAskTopic.fdIntroduce') }" key="intro">
				<list:box-select>
					<list:item-select>
						<ui:source type="Static">
							[{text:'${ lfn:message('kms-ask:kmsAskTopic.fdTrue') }', value:'introduce'},{text:'${ lfn:message('kms-ask:kmsAskTopic.fdFalse') }',value:'notIntro'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
			
			<list:cri-ref key="dept" ref="criterion.sys.dept" title="${ lfn:message('kms-ask:kmsAskTopic.anDept')}">
			</list:cri-ref>
			
			<list:cri-auto modelName="com.landray.kmss.kms.ask.model.KmsAskTopic" 
				property="docCreator" />
			
		</list:criteria>
		
		<%-- 按钮 --%>
		<div class="lui_list_operation">
					<div style='color: #979797;width: 39px;float:left;padding-top:1px;'>
						${ lfn:message('kms-ask:kmsAskTopic.list.orderType') }：
					</div>
					<%--排序按钮  --%>
					<div style="float:left">
						<div style="display: inline-block;vertical-align: middle;">
							<ui:toolbar layout="sys.ui.toolbar.sort"  count="5" >
								<list:sort property="kmsAskTopic.docCreateTime" text="${lfn:message('kms-ask:kmsAskTopic.fdAskTime') }"  group="sort.list"></list:sort>
								<list:sort property="kmsAskTopic.fdLastPostTime" text="${lfn:message('kms-ask:kmsAskTopic.fdLastPostTime') }"  group="sort.list"></list:sort>
								<list:sort property="kmsAskTopic.fdStatus" text="${lfn:message('kms-ask:kmsAskTopic.fdAskStatus') }" group="sort.list"></list:sort>
								<list:sort property="kmsAskTopic.fdScore" text="${lfn:message('kms-ask:kmsAskTopic.fdScores') }" group="sort.list"></list:sort>
								<list:sort property="kmsAskTopic.fdReplyCount" text="${lfn:message('kms-ask:kmsAskTopic.replyCount')}" group="sort.list"></list:sort>
							</ui:toolbar>
						</div>
					</div>
					<div style="float:left">
							<list:paging layout="sys.ui.paging.top">		
							</list:paging> 
					</div>
					<div style="float:right">
						<div style="display: inline-block;vertical-align: middle;">
							<ui:toolbar>
								<%-- 新增删除--%>
								<c:import url="/kms/ask/kms_ask_ui/kmsAskTopic_button.jsp" charEncoding="UTF-8"></c:import>
								<%-- 收藏 --%>
								<c:import url="/sys/bookmark/import/bookmark_bar_all.jsp" charEncoding="UTF-8">
									<c:param name="fdTitleProName" value="docSubject" />
									<c:param name="fdModelName"	value="com.landray.kmss.kms.ask.model.KmsAskTopic" />
								</c:import>
								<%-- 分类转移 --%>
								<c:import url="/sys/simplecategory/import/doc_cate_change_button.jsp" charEncoding="UTF-8">
									<c:param name="modelName" value="com.landray.kmss.kms.ask.model.KmsAskTopic" />
									<c:param name="docFkName" value="fdKmsAskCategory" />
									<c:param name="cateModelName" value="com.landray.kmss.kms.ask.model.KmsAskCategory" />
								</c:import>
								<%-- 取消推荐 --%>
								<kmss:auth
									requestURL="/kms/ask/kms_ask_introduce/kmsAskIntroduce.do?method=cancelIntro"
									requestMethod="GET">
									<ui:button id="cancelIntroduce"   
												text="${lfn:message('sys-introduce:sysIntroduceMain.cancel.button') }"
												onclick="introduce_cancelIntroduce();" order="4">
									</ui:button>
								</kmss:auth>
							</ui:toolbar>
						</div>
					</div>
		</div>
		
		<ui:fixed elem=".lui_list_operation"></ui:fixed>
		
		<c:if test="${not empty param.categoryId}">
			<c:set var="categoryParam" value="&q.kmsAskCategory=${param.categoryId }" />
		</c:if>
		
		<%--列表视图  --%>
		<list:listview id="listview">
			<ui:source type="AjaxJson">
				{url:'/kms/ask/kms_ask_index/kmsAskTopicIndex.do?method=index&categoryId=${param.categoryId}${categoryParam }'}
			</ui:source>
		
			<%-- 列表视图--%>
			<list:colTable layout="sys.ui.listview.columntable" name="columntable"
				rowHref="/kms/ask/kms_ask_topic/kmsAskTopic.do?method=view&fdId=!{fdId}" sort="false">
				<list:col-checkbox name="List_Selected" style="width:5%" ></list:col-checkbox>
				<list:col-serial title="${ lfn:message('page.serial') }" headerStyle="width:5%"></list:col-serial>
				<list:col-html title="${ lfn:message('kms-ask:kmsAskTopic.fdScores')}" >
					{$
						<span class="lui_ask_index_score">{%row['fdScore']%}</span>
					$}
				</list:col-html>
				<list:col-html title="${ lfn:message('kms-ask:kmsAskTopic.docSubject')}" headerStyle="width:35%" style="text-align:left;padding:0 8px" >
					{$
						<div class="com_subject">{%row['docSubject']%}</div>
					$} 
				</list:col-html>
				<list:col-html title="${lfn:message('kms-ask:kmsAskTopic.fdPoster')}" >
					{$
						<span class="com_author">{%row['fdPoster']%}</span> 
					$}
				</list:col-html>
				<list:col-html title="${ lfn:message('kms-ask:kmsAskTopic.fdAskStatus')}" >
					if(row['fdStatus']==0){
						{$
							<span ><img src="${KMSS_Parameter_StylePath}answer/icn_time.gif" border="0"></span>
						$}
					}else{
						{$
							<span ><img src="${KMSS_Parameter_StylePath}answer/icn_ok.gif" border="0"></span>
						$}
					}
				</list:col-html>
				<list:col-auto props="fdReplyCount,docCreateTime,fdLastPostTime"></list:col-auto>
			</list:colTable>
		</list:listview>
	 	<list:paging></list:paging>
	</template:replace>
</template:include>
<script>
	var Com_Parameter = {
			ContextPath:"${KMSS_Parameter_ContextPath}",
			JsFileList:new Array,
			ResPath:"${KMSS_Parameter_ResPath}"
		};
	var SYS_SEARCH_MODEL_NAME = "com.landray.kmss.kms.ask.model.KmsAskTopic";
</script>

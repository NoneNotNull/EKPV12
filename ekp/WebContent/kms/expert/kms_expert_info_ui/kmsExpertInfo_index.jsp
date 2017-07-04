<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.kms.expert.util.KmsExpertPluginUtil"%>
<%@page import="java.util.List,
				com.landray.kmss.kms.expert.model.KmsArea,
				com.landray.kmss.util.ResourceUtil" %>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.list" width="980px">
	<template:replace name="head">
		<script src="${LUI_ContextPath}/kms/expert/resource/js/kmsExpert_util.js"></script>
		<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/kms/expert/kms_expert_info_ui/style/index.css">		
	</template:replace>
	<template:replace name="title">${lfn:message('kms-expert:title.kms.expert') }</template:replace>
	<%-- 当前路径 --%>
	<template:replace name="path">
		<ui:combin ref="menu.path.simplecategory">
			<ui:varParams 
				id="simplecategoryId"
				modelName="com.landray.kmss.kms.expert.model.KmsExpertType" 
				moduleTitle="${lfn:message('kms-expert:title.kms.expert') }"
				href="/kms/expert/"
				categoryId="${param.categoryId }" />
		</ui:combin>
	</template:replace>
	<%-- 左边栏 --%>
	<template:replace name="nav">
		<!-- 所有分类 -->
		<ui:combin ref="menu.nav.simplecategory.all"> 
			<ui:varParams 
				modelName="com.landray.kmss.kms.expert.model.KmsExpertType" 
				href="/kms/expert/" />
		</ui:combin>
		<%--新建专家 --%>
		<ui:combin ref="menu.nav.create">
			<ui:varParam name="title" value="${lfn:message('kms-expert:title.kms.expert') }"></ui:varParam>
			<ui:varParam name="button">
				[
					<kmss:auth requestURL="/kms/expert/kms_expert_info/kmsExpertInfo.do?method=add" requestMethod="GET">
					{
						"text": "${lfn:message('kms-expert:kmsExpert.add') }",
						"href": "javascript:addExpert()",
						"icon": "lui_icon_l_icon_43"
					}
					</kmss:auth>
				]
			</ui:varParam>			
	    </ui:combin>
	    <div class="lui_list_nav_frame">
			<ui:accordionpanel>
				<%--常用分类 --%>
				<ui:combin ref="menu.nav.favorite.category">
					<ui:varParams
						modelName="com.landray.kmss.kms.expert.model.KmsExpertType" 
						href="/kms/expert/?categoryId=!{value}" />
				</ui:combin>
				<%-- 专家领域(分类索引)--%>
				<ui:content title="${lfn:message('kms-expert:kmsExpert.expertArea') }" style="padding:0px">
					<ui:combin ref="menu.nav.simplecategory.flat">
						<ui:varParams 
							content="false"
							modelName="com.landray.kmss.kms.expert.model.KmsExpertType" 
							href="/kms/expert/"
							categoryId="${param.categoryId }"
							expand="true" />
					</ui:combin>
					<c:if test="${not empty param.categoryId}">
						<ui:operation href="javascript:LUI('simplecategoryId').gotoNav(-1)" target="_self" name="${lfn:message('list.lever.up') }" align ="left"/>
					</c:if>
					<%--分类概览 --%>
					<ui:operation 
						href="javascript:openPage('${LUI_ContextPath }/sys/sc/categoryPreivew.do?method=forward&service=kmsExpertCategoryPreManagerService&currid=${param.categoryId}')" 
						name="${lfn:message('sys-category:menu.sysCategory.overview') }" 
						target="_self" />
				</ui:content>
			    <%-- 后台配置 --%>
			    <kmss:authShow roles="ROLE_KMSEXPERT_BACKSTAGE_MANAGER">
					<ui:content title="${ lfn:message('list.otherOpt') }" >
						<ul class='lui_list_nav_list'>
							<li><a href="${LUI_ContextPath }/sys/?module=kms/expert" target="_blank">${ lfn:message('list.manager') }</a></li>
						</ul>
					</ui:content>
				</kmss:authShow>
			</ui:accordionpanel>
		</div>
	</template:replace>
	
	<%-- 右边栏 --%>
	<template:replace name="content">
		<%--筛选器 --%>
		<list:criteria id="criteria1" expand="false"> 
			<list:cri-ref ref="criterion.sys.docSubject" key="fdName" title="${lfn:message('kms-expert:kmsExpert.SearchName')}"></list:cri-ref>
			<list:cri-criterion title="${lfn:message('kms-expert:table.kmsIntroExpert') }" key="intro" multi="false">
				<list:box-select >
					<list:item-select >
						<ui:source type="Static">
							[{text:"${lfn:message('message.yes') }", value:'true'},{text:"${lfn:message('message.no') }", value:'false'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
			<%--按部门 --%>
			<list:cri-ref key="dept" ref="criterion.sys.dept" title="${lfn:message('kms-expert:kmsExpert.criteriaByDep') }" />
			<%--领域 --%>
			<%
				List<KmsArea> list = KmsExpertPluginUtil.getAreas();
				for (KmsArea kmsArea : list) { 
					String title = ResourceUtil.getMessage(kmsArea.getAreaMessageKey());
					String area =  kmsArea.getUuid();
			%>
				<list:cri-ref key="<%=area%>" ref="criterion.sys.simpleCategory" 
							  title="<%=title%>" >
						<ui:varParams modelName="<%=kmsArea.getCateModelName() %>"/>
				</list:cri-ref>
			<%	
				}
			%>
			<list:cri-property modelName="com.landray.kmss.kms.expert.model.KmsExpertType" categoryId="${param.categoryId }"/>
		</list:criteria>
		<%-- 排序和搜索--%>
		<%-- 按钮 --%>
		<div class="lui_list_operation">
			<div style='color: #979797;width: 39px;float:left;padding-top:1px;'>
				${ lfn:message('list.orderType') }：
			</div>
			<%--排序按钮  --%>
			<div style="float:left">
				<div style="display: inline-block;vertical-align: middle;">
					<ui:toolbar layout="sys.ui.toolbar.sort"  >
						<list:sort property="fdCreateTime" text="${lfn:message('kms-expert:kmsExpert.SortBycreatTime') }"  group="sort.list"></list:sort>
						<list:sort property="fdName" text="${lfn:message('kms-expert:kmsExpert.SortByfdName') }" group="sort.list"></list:sort>
					</ui:toolbar>
				</div>
			</div>
			<div style="float:left;">
				<list:paging layout="sys.ui.paging.top">		
				</list:paging>
			</div>
			<%--按钮 --%>
			<div style="float:right">
				<div style="display: inline-block;vertical-align: middle;">
					<ui:toolbar>
						<c:import url="/kms/expert/kms_expert_info_ui/kmsExpertInfo_button.jsp" charEncoding="UTF-8"></c:import>
					</ui:toolbar>
				</div>
			</div>				
		</div>
		
		<ui:fixed elem=".lui_list_operation"></ui:fixed>
		
		<%--格子列表 --%>
		<list:listview id="listview" >
			<ui:source type="AjaxJson">
				{url:'/kms/expert/kms_expert_index/kmsExpertIndex.do?method=list&s_block=all&categoryId=${param.categoryId}&rowsize=16'}
			</ui:source>		
			<list:gridTable name="gridtable" columnNum="2" >
				<list:row-template >
					<c:import url="/kms/expert/kms_expert_info_ui/expert_box_content_tmpl.jsp" charEncoding="UTF-8"></c:import>
				</list:row-template>
			</list:gridTable>
		</list:listview>
		<list:paging ></list:paging>		 		
	</template:replace>
</template:include>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%-- 上会材料 --%>
<template:include ref="default.list">
	<%-- 标签页标题 --%>
	<template:replace name="title">
		<c:out value="${lfn:message('km-imeeting:module.km.imeeting')}"></c:out>
	</template:replace>
	
	<%-- 导航路径 --%>
	<template:replace name="path"> 
		<ui:menu layout="sys.ui.menu.nav"  id="categoryId"> 
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home" href="/" target="_self"></ui:menu-item>
			<ui:menu-item text="${ lfn:message('km-imeeting:module.km.imeeting') }" href="/km/imeeting/" target="_self"></ui:menu-item>
			<ui:menu-item text="${ lfn:message('km-imeeting:kmImeeting.tree.uploadAtt') }" href="#" target="_self">
			</ui:menu-item>
		</ui:menu>
	</template:replace>
	
	<%-- 左侧导航栏 --%>
	<template:replace name="nav">
		
		<ui:combin ref="menu.nav.create">
			<ui:varParam name="title" value="${lfn:message('km-imeeting:module.km.imeeting')}"></ui:varParam>
			<ui:varParam name="button">
				[]
			</ui:varParam>
		</ui:combin>
		
		<div class="lui_list_nav_frame">
			<ui:accordionpanel>
				<c:import url="/km/imeeting/import/nav.jsp" charEncoding="UTF-8">
					<c:param name="key" value="uploadAtt"></c:param>
				   	<c:param name="criteria" value=""></c:param>
				</c:import>
			</ui:accordionpanel>
		</div>
	
	</template:replace>
	
	<%-- 右侧内容区域 --%>
	<template:replace name="content"> 
		
		<%-- 筛选器 --%>
		<list:criteria id="imeetingCriteria">
			<list:cri-ref key="fdName" ref="criterion.sys.docSubject"> </list:cri-ref>
			<%-- 分类导航 --%>
			<list:cri-ref ref="criterion.sys.category" key="fdTemplate" multi="false" title="${lfn:message('sys-category:menu.sysCategory.index') }" expand="true">
			  <list:varParams modelName="com.landray.kmss.km.imeeting.model.KmImeetingTemplate"/>
			</list:cri-ref>
			<%-- 召开时间 --%>
			<list:cri-auto modelName="com.landray.kmss.km.imeeting.model.KmImeetingMain" property="fdHoldDate" expand="true"/>
		</list:criteria>
		
		<%-- 操作栏 --%>
		<div class="lui_list_operation">
			<div style='color: #979797;float: left;padding-top:1px;'>
				${ lfn:message('list.orderType') }：
			</div>
			<div style="float:left">
				<div style="display: inline-block;vertical-align: middle;">
					<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" >
						<list:sort property="fdHoldDate" text="${lfn:message('km-imeeting:kmImeetingMain.fdHoldDate') }" group="sort.list" value="down"></list:sort>
					</ui:toolbar>
				</div>
			</div>
			<div style="float:left;">	
				<list:paging layout="sys.ui.paging.top" > 		
				</list:paging>
			</div>
		</div>
		<ui:fixed elem=".lui_list_operation"></ui:fixed>
		
		<%-- 列表视图 --%>
		<list:listview id="listview">
			<ui:source type="AjaxJson">
					{url:'/km/imeeting/km_imeeting_main/kmImeetingMain.do?method=listChildren&isUploadAtt=true&categoryId=${param.categoryId}&nodeType=${param.nodeType}'}
			</ui:source>
			<list:colTable isDefault="true" layout="sys.ui.listview.columntable" 
				rowHref="/km/imeeting/km_imeeting_main/kmImeetingMain.do?method=viewUpdateAtt&fdId=!{fdId}" name="columntable">
				<list:col-checkbox name="List_Selected" headerStyle="width:5%"></list:col-checkbox>
				<list:col-serial title="${ lfn:message('page.serial')}" headerStyle="width:5%"></list:col-serial>
				<list:col-html  title="${ lfn:message('km-imeeting:kmImeetingMain.fdName') }" style="text-align:left">
				 {$ <span class="com_subject" >{%row['fdName']%}</span> $}
				</list:col-html>
				<list:col-auto props="fdHost;fdHoldDate;fdFinishDate;fdPlace;fdTemplate.fdName"></list:col-auto>
			</list:colTable>
		</list:listview>
	 	<list:paging></list:paging>
		
	</template:replace>
</template:include>
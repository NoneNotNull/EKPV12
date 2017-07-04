<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.list">
	<template:replace name="title">
		<c:out value="${ lfn:message('km-comminfo:module.km.comminfo') }"></c:out>
	</template:replace>
	<template:replace name="path">
			<ui:menu layout="sys.ui.menu.nav" style="height:40px;line-height:40px;">
				<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home" href="/" target="_self">
				</ui:menu-item>
				<ui:menu-item text="${ lfn:message('km-comminfo:module.km.comminfo') }" href="/km/comminfo/" target="_self">
				</ui:menu-item>
			</ui:menu>
	</template:replace>
	<template:replace name="nav">
		<ui:combin ref="menu.nav.create">
			<ui:varParam name="title" value="${ lfn:message('km-comminfo:module.km.comminfo') }" />
			<ui:varParam name="button">
				[
				<kmss:authShow roles="ROLE_COMMINFO_MAIN_CREATE">
					{
						"text": "${ lfn:message('km-comminfo:kmComminfoMain.shareBtn') }",
						"href": "javascript:addShare();",
						"icon": "lui_icon_l_icon_42"
					}
				</kmss:authShow>
				]
			</ui:varParam>
		</ui:combin>
		<div class="lui_list_nav_frame">
			<ui:accordionpanel>
				<ui:content title="${ lfn:message('list.otherOpt') }">
					<ul class='lui_list_nav_list'>
						<li><a href="${LUI_ContextPath }/sys/?module=km/comminfo" target="_blank">${ lfn:message('list.manager') }</a></li>
					</ul>
				</ui:content>
			</ui:accordionpanel>
		</div>
	</template:replace>
	
	<template:replace name="content">
		<!-- 筛选器 -->
		<list:criteria id="criteria1">
			<list:cri-ref key="docSubject" ref="criterion.sys.docSubject">
			</list:cri-ref>
			<list:cri-criterion title="${ lfn:message('km-comminfo:kmComminfoMain.categoryName') }" key="docCategory" expand="false">
				<list:box-select>
					<list:item-select>
						<ui:source type="AjaxJson">
							{url:'/km/comminfo/km_comminfo_category/kmComminfoCategory.do?method=getComminfoCategory'}
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
			<!-- 创建人，创建时间 -->
			<list:cri-auto modelName="com.landray.kmss.km.comminfo.model.KmComminfoMain" 
				property="docCreator;docCreateTime" />
		</list:criteria>
		<%@ include file="/km/comminfo/km_comminfo_ui/kmComminfoMain_listview.jsp" %>
	</template:replace> 
	
</template:include>

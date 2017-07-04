<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include file="/sys/zone/address/address.list.jsp" width="980px">
	<template:replace name="title">${lfn:message('sys-zone:sysZonePerson.address.list.zone')}</template:replace>
	<%-- 当前路径 --%>
	<template:replace name="path">
		<ui:menu layout="sys.ui.menu.nav" >
			<ui:menu-item text="${lfn:message('home.home')}" href="/index.jsp" icon="lui_icon_s_home" />
			<ui:menu-item text="${lfn:message('sys-zone:module.sys.zone') }" href="/sys/zone" target="_self"/>
			<ui:menu-item text="${lfn:message('sys-zone:sysZonePerson.address.list') }" />
		</ui:menu>
	</template:replace>
	<%-- 右边栏 --%>
	<template:replace name="content">
		<list:criteria id="criteria1"  expand="true">
				<list:cri-ref key="fdPersonInfo" ref="criterion.sys.docSubject" style="width:115px;" 
					title="${lfn:message('sys-zone:sysZonePerson.address.phone.email')}">
				</list:cri-ref>
				<list:cri-ref key="_fdId" ref="criterion.sys.person" title="${lfn:message('sys-zone:sysZonePerson.name')}" >
				</list:cri-ref>
				<list:cri-auto modelName="com.landray.kmss.sys.organization.model.SysOrgPerson" 
					property="hbmParent" />
		</list:criteria>
		
		<%-- 按钮 --%>
		<div class="lui_list_operation">
			<div style="width:100%">
					<div style='color: #979797;width: 45px;text-align: center;float:left;padding-top:1px;'>
						${ lfn:message('list.orderType') }：
					</div>
					<%--排序按钮  --%>
					<div style="float: left;">
						<div style="display:inline-block;vertical-align:middle;" 
						     class="lui_wiki_sort_box">
							<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" count="4">
								<list:sort property="fdNamePinYin" text="${lfn:message('sys-zone:sysZonePersonInfo.username') }" 
									group="sort.list"></list:sort>
							</ui:toolbar>
						</div>
					</div>
					<div style="float:left;">
						<list:paging layout="sys.ui.paging.top">		
						</list:paging>
					</div>
				</div>
		</div>
		<ui:fixed elem=".lui_list_operation"></ui:fixed>
		<%--列表视图  --%>
		<list:listview id="listview">
			<ui:source type="AjaxJson">
				{url:'/sys/zone/sys_zone_addreass/sysZoneAddress.do?method=list&orderby=fdNamePinYin'}
			</ui:source>
			
			<%-- 摘要视图--%>
			<list:colTable layout="sys.ui.listview.columntable" 
				name="rowtable"  rowHref="/sys/person/sys_person_zone/sysPersonZone.do?method=view&fdId=!{fdId}" 
				 target="_blank" >
				 <list:col-serial title="${ lfn:message('page.serial') }" headerStyle="width:3%"></list:col-serial>	 
				 <list:col-auto props="fdName;fdSex;fdMobileNo;fdEmail;fdWorkPhone;hbmParent.fdName"></list:col-auto>
				
			</list:colTable>
		</list:listview>
		<%-- 列表分页 --%>
	 	<list:paging></list:paging>
	</template:replace>
</template:include>

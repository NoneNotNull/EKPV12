<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.edit">
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float"> 
			<ui:button text="关闭" order="5"  onclick="Com_CloseWindow()" />
		</ui:toolbar>  
	</template:replace>
	<template:replace name="path">
		<%@ include file="nav.jsp" %>
		<ui:menu layout="sys.ui.menu.nav">
			<ui:menu-item text="首页" icon="lui_icon_s_home" />
			<ui:menu-item text="知识中心" />
			<ui:menu-source>
				<ui:source type="AjaxJson">
					{"url":"/sys/ui/help/menu/pathdata-example.jsp?currId=1"} 
				</ui:source>
			</ui:menu-source>
		</ui:menu>
	</template:replace>
	<template:replace name="content">
	
	</template:replace>
	<template:replace name="nav">
		<ui:accordionpanel style="min-width:200px;"> 
			<ui:content title="文档信息" toggle="false">
				<ul class='lui_form_info'>
					<li>创建者：<ui:person personId="1183b0b84ee4f581bba001c47a78b2d9" personName="管理员"/></li>
					<li>所属部门：蓝凌软件</li>
					<li>文档状态：发布</li>
					<li>版本：1.0</li>
					<li>录入时间：2013-12-04 10:43</li>			
				</ul>
			</ui:content>
		</ui:accordionpanel>
		<ui:accordionpanel style="min-width:200px;"> 
			<ui:content title="同作者">
				<template:include file="/sys/ui/help/dataview/dataview-demo.jsp" format="sys.ui.classic">
					<template:replace name="render">
						<ui:render ref="sys.ui.classic.tile" var-showCate="false" />
					</template:replace>
				</template:include>
			</ui:content>
		</ui:accordionpanel>
	</template:replace>
</template:include>
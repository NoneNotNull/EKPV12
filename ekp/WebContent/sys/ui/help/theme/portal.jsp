<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="template.default">
	<template:replace name="body1">
		<%@ include file="nav.jsp" %>
		<%@ include file="changeheader.jsp" %>
		<table width="100%"><tr><td width="180px" style="vertical-align: top;" rowspan="2">
				
			<ui:accordionpanel>
				<ui:content title="分类导航">
					<template:include file="/sys/ui/help/dataview/dataview-demo.jsp"
						format="sys.ui.cate" render="sys.ui.cate.default"/>
					<ui:operation name="更多" href="#" />
				</ui:content>
				<ui:content title="文本菜单-默认">
					<template:include file="/sys/ui/help/dataview/dataview-demo.jsp"
						format="sys.ui.textMenu" render="sys.ui.textMenu.default" />
					<ui:operation name="更多" href="#" />
				</ui:content>
				<ui:content title="文本菜单-按钮">
					<template:include file="/sys/ui/help/dataview/dataview-demo.jsp"
						format="sys.ui.textMenu" render="sys.ui.textMenu.button" />
					<ui:operation name="更多" href="#" />
				</ui:content>
			</ui:accordionpanel>
					
		</td><td width="15px" rowspan="2"></td><td width="785px" style="vertical-align: top;">
		<table width="100%"><tr><td width="390px" style="vertical-align: top;">
			
			<ui:panel layout="sys.ui.panel.default" height="240" scroll="true">
				<ui:content title="简单列表-表格">
					<template:include file="/sys/ui/help/dataview/dataview-demo.jsp" format="sys.ui.classic">
						<template:replace name="render">
							<ui:render ref="sys.ui.classic.default" var-highlight="true" var-newDay="2" />
						</template:replace>
					</template:include>
					<ui:operation name="更多" href="#" />
				</ui:content>
			</ui:panel>
			
		</td><td width="15px"></td><td width="390px" style="vertical-align: top;">
				
			<ui:panel layout="sys.ui.panel.light" height="240" scroll="true">
				<ui:content title="简单列表-平铺">
					<template:include file="/sys/ui/help/dataview/dataview-demo.jsp" format="sys.ui.classic">
						<template:replace name="render">
							<ui:render ref="sys.ui.classic.tile" var-highlight="true" var-newDay="2" />
						</template:replace>
					</template:include>
					<ui:operation name="更多" href="#" />
				</ui:content>
			</ui:panel>
			
		</td></tr></table>
		<div style="height:15px;"></div>
		<table width="100%"><tr><td style="vertical-align: top;">
		
			<ui:tabpanel height="240" scroll="true" layout="sys.ui.tabpanel.border" var-width="1:2" >
				<ui:content title="图片菜单">
					<template:include file="/sys/ui/help/dataview/dataview-demo.jsp"
						format="sys.ui.slide" render="sys.ui.slide.default" />
					<ui:operation name="更多" href="#" />
				</ui:content>
				<ui:content title="列表视图">
					<template:include file="/sys/ui/help/dataview/dataview-demo.jsp" format="sys.ui.listtable">
						<template:replace name="render">
							<ui:render ref="sys.ui.listtable.default" var-showTableTitle="true" />
						</template:replace>
					</template:include>
					<ui:operation name="更多" href="#" />
				</ui:content>
			</ui:tabpanel>
			
			<div style="height:15px;"></div>
			
			<ui:tabpanel layout="sys.ui.tabpanel.default" height="240" scroll="true">
				<ui:content title="图片菜单">
					<template:include file="/sys/ui/help/dataview/dataview-demo.jsp"
						format="sys.ui.picMenu" render="sys.ui.picMenu.default" />
					<ui:operation name="更多" href="#" />
				</ui:content>
				<ui:content title="二级树菜单-默认">
					<template:include file="/sys/ui/help/dataview/dataview-demo.jsp"
						format="sys.ui.treeMenu2" render="sys.ui.treeMenu2.default" />
					<ui:operation name="更多" href="#" />
				</ui:content>
				<ui:content title="二级树菜单-分类">
					<template:include file="/sys/ui/help/dataview/dataview-demo.jsp"
						format="sys.ui.treeMenu2" render="sys.ui.treeMenu2.cate" />
					<ui:operation name="更多" href="#" />
				</ui:content>
			</ui:tabpanel>
			
			<div style="height:15px;"></div>
			
			<ui:tabpanel layout="sys.ui.tabpanel.light">
				<ui:content title="三级树菜单-默认">
					<template:include file="/sys/ui/help/dataview/dataview-demo.jsp"
						format="sys.ui.treeMenu3" render="sys.ui.treeMenu3.default" />
					<ui:operation name="更多" href="#" />
				</ui:content>
				<ui:content title="三级树菜单-瀑布">
					<template:include file="/sys/ui/help/dataview/dataview-demo.jsp"
						format="sys.ui.treeMenu3" render="sys.ui.treeMenu.fall" />
					<ui:operation name="更多" href="#" />
				</ui:content>
				<ui:content title="三级树菜单-平铺">
					<template:include file="/sys/ui/help/dataview/dataview-demo.jsp"
						format="sys.ui.treeMenu3" render="sys.ui.treeMenu.flat" />
					<ui:operation name="更多" href="#" />
				</ui:content>
			</ui:tabpanel>
					
		</td></tr></table>
		</td></tr></table>
	</template:replace>
</template:include>
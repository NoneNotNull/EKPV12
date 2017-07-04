<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="body">
	
	Menu 样例 Demo <br>
	<ui:menu layout="sys.ui.menu.nav" >
		<ui:menu-item text="menu1"></ui:menu-item>
		<ui:menu-item text="menu2"></ui:menu-item> 
		<ui:menu-source href="#?categoryId=!{value}">
				<ui:source type="Static">
					[
						<ui:trim sign=",">
							<kmss:auth requestURL="">
								,{
									text:"s1",
									href:"s2"
								}
							</kmss:auth>
								,{
									text:"s2",
									href:"s2"
								}
							<kmss:auth requestURL="">
								,
								{
									text:"s3",
									href:"s3"
								}
							</kmss:auth>
						</ui:trim>						 
					]
				</ui:source>
			</ui:menu-source>
		</ui:menu>	
	</template:replace>
</template:include>
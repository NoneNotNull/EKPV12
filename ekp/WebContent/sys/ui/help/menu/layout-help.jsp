<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include file="/sys/ui/help/layout-help.jsp">
	<template:replace name="example">
		<script type="text/javascript">
					seajs.use('theme!dataview');
					function testReplace(){
						seajs.use([ 'lui/jquery','lui/LUI','lui/base','lui/menu'], function($,LUI,base,menu) {
							var replaceVar = base.byId("test_replace");
							var replacedVar =  base.byId("source_replace");
							var menuObj =  base.byId("inner_menu");
							menuObj.insertBefore(replaceVar,replacedVar);
							menuObj.removeChild(replacedVar);
						});
					}
		</script>
		<input type="button" value="替换menusouce" onclick="testReplace();"/>
		<br/><br/><br/>
		<ui:menu layout="${param.fdId}" id="menu_test">
			<ui:menu-item title="营销门户" icon="lui_icon_l_icon_1" text="营销门户">
				<ui:menu-item title="营销门户" icon="lui_icon_l_icon_2" text="营销门户1">
					<ui:menu-item title="营销门户" icon="lui_icon_l_icon_2" text="营销门户1_1">
						<ui:menu-item title="营销门户" icon="lui_icon_l_icon_2" text="营销门户1_1_1">
						</ui:menu-item>
						<ui:menu-item title="营销门户" icon="lui_icon_l_icon_2" text="营销门户1_1_2">
							<ui:menu-item title="营销门户" icon="lui_icon_l_icon_2" text="营销门户1_1_2_1">
								<ui:menu-item title="营销门户" icon="lui_icon_l_icon_2" text="营销门户1_1_2_1_1">
								</ui:menu-item>
							</ui:menu-item>
						</ui:menu-item>
					</ui:menu-item>
					<ui:menu-item title="营销门户" icon="lui_icon_l_icon_2" text="营销门户1_2">
						<ui:menu-item title="营销门户" icon="lui_icon_l_icon_3" text="营销门户1_2_1">
							<ui:menu-item title="营销门户" icon="lui_icon_l_icon_3" text="营销门户1_2_1_1">
							</ui:menu-item>
							<ui:menu-item title="营销门户" icon="lui_icon_l_icon_3" text="营销门户1_2_1_2">
							</ui:menu-item>
						</ui:menu-item>
						<ui:menu-item title="营销门户" icon="lui_icon_l_icon_3" text="营销门户1_2_2">
							<ui:menu-item title="营销门户" icon="lui_icon_l_icon_3" text="营销门户1_2_2_1">
							</ui:menu-item>
							<ui:menu-item title="营销门户" icon="lui_icon_l_icon_3" text="营销门户1_2_2_2">
							</ui:menu-item>
						</ui:menu-item>
					</ui:menu-item>
				</ui:menu-item>
				<ui:menu-item title="营销门户" icon="lui_icon_l_icon_3" text="营销门户2">
					<ui:menu-item title="营销门户" icon="lui_icon_l_icon_3" text="营销门户2_1">
					</ui:menu-item>
					<ui:menu-item title="营销门户" icon="lui_icon_l_icon_3" text="营销门户2_2">
					</ui:menu-item>
				</ui:menu-item>
				
				<ui:menu-popup text="样例" icon="lui_icon_l_icon_23" align="right-top">
					<ui:menu layout="sys.ui.menu.ver.default" id="inner_menu">
						<ui:menu-item title="测试pop" icon="lui_icon_l_icon_1" text="测试pop">
						</ui:menu-item>
						<ui:menu-source id="source_replace">
							<ui:source type="Static">
								[
									{"text":"我的门户","icon":"lui_icon_l_icon_40","children":[{"text":"个人设置","icon":"lui_icon_l_icon_44"}],"autofresh":false},
									{"text":"UI配置","icon":"lui_icon_l_icon_42","href":"/sys/ui/","target":"blank"}
								]
							</ui:source>
					</ui:menu-source>
					</ui:menu>
				</ui:menu-popup>
			</ui:menu-item>
			
			<ui:menu-item title="个人门户" icon="lui_icon_l_icon_16" text="个人门户">
			</ui:menu-item>
			<ui:menu-item title="项目门户" icon="lui_icon_l_icon_17" text="项目门户">
			</ui:menu-item>
		</ui:menu>
		<br/><br/><br/><br/><br/><br/><br/><br/>
	
	</template:replace>
	
	<template:replace name="detail">
		
	</template:replace>
</template:include> 

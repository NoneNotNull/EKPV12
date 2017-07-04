<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="${LUI_ContextPath}/resource/js/sea.js" 
	data-config="${LUI_ContextPath}/resource/js/seaconfig.jsp#">
</script>
<script type="text/javascript">
seajs.use([ 'lui/parser', 'lui/jquery','theme!common','theme!icon' ], function(parser, $) {
	window.$ = $;
	$(document).ready(function() {
		parser.parse();
	});
});
</script>
</head>
<body>
		<ui:menu layout="sys.ui.menu.default">
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
								<ui:menu-item title="营销门户" icon="lui_icon_l_icon_3" text="营销门户1_2_2_1_1">
								</ui:menu-item>
								<ui:menu-item title="营销门户" icon="lui_icon_l_icon_3" text="营销门户1_2_2_1_2">
									<ui:menu-item title="营销门户" icon="lui_icon_l_icon_3" text="营销门户1_2_2_1_2_1">
									</ui:menu-item>
								</ui:menu-item>
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
					<ui:menu layout="sys.ui.menu.ver.default">
						<ui:menu-item title="测试pop" icon="lui_icon_l_icon_1" text="测试pop">
						</ui:menu-item>
					</ui:menu>
				</ui:menu-popup>
			</ui:menu-item>
			<ui:menu-source>
				<ui:source type="Static">
					[
						{"text":"我的门户","icon":"lui_icon_l_icon_40","children":[{"text":"个人设置","icon":"lui_icon_l_icon_44"}],"children-source":{},"autofresh":false},
						{"text":"UI配置","icon":"lui_icon_l_icon_42","href":"/sys/ui/","target":"blank"}
					]
				</ui:source>
			</ui:menu-source>
			<ui:menu-item title="个人门户" icon="lui_icon_l_icon_40" text="个人门户">
			</ui:menu-item>
			<ui:menu-item title="项目门户" icon="lui_icon_l_icon_17" text="项目门户">
			</ui:menu-item>
			<ui:menu-popup text="样例" icon="lui_icon_l_icon_23" align="down-left">
				<ui:menu layout="sys.ui.menu.ver.default">
					<ui:menu-item title="测试pop" icon="lui_icon_l_icon_1" text="测试pop">
					</ui:menu-item>
				</ui:menu>
			</ui:menu-popup>
		</ui:menu>
</body>
</html>
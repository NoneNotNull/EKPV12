<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp" %>
<template:include file="/sys/ui/help/dataview/render-help.jsp">

	<template:replace name="detail">
	<textarea style="width:100%;height:400px;">
图片菜单展示说明：
	1、使用说明： picmenu接收外部参数“超出范围显示更多菜单”（showMore），如果为true，则当菜单数目超过外层宽度和高度时，就会显示更多菜单。
				如果为其他值，则平铺展示。
				如果为空，则根据外层HTML的高宽，进行判断是否显示更多菜单。
	
	2、样式定义：picmenu接收rander定义中传递extend参数，来更改样式，class计算规则是  “class关键字” + “_” + extend。
	            picmenu接收rander定义中传递iconChange参数，定义在鼠标移动时，图标是否切换，参数值：true/false。
 
数据展示HTML说明:
	<div class="lui_dataview_render_picmenulist">
		<!-- 默认顶层class为：lui_dataview_render_picmenulist，模块内菜单class为lui_dataview_render_picmenulist_mod -->
		<div class="lui_dataview_render_picmenu">	
			<!--选中class为：lui_dataview_render_picmenu_on, 更多按钮class为：lui_dataview_render_picmenu_more, 
				更多按钮选中class为:lui_dataview_render_picmenu_more_on -->
			<div class="lui_dataview_render_picmenu_left">
				<div class="lui_dataview_render_picmenu_right">
					<div class="lui_dataview_render_picmenu_content">
						<div class="lui_icon_l">
							<div class="lui_icon_l lui_icon_l_add"></div>
						</div>
						<div class="lui_dataview_render_picmenu_txt">name</div>
					</div>
				</div>
			</div>
		</div>
		...
	</div>
	</textarea>
	</template:replace>
</template:include>
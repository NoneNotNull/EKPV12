<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<!-- 面板 -->
<ui:panel id="" width="100%" height="" toggle="" expand=""
	scroll="false" layout="sys.ui.panel.default" style="" channel="">
	<ui:layout ref="+" type="+" />
	<!-- 引用portlet定义 -->
	<portal:portlet id="" ref="*" title="*" toggle="" expand="" />
	<!-- 自定义内容 -->
	<ui:content id="" title="*" type="" toggle="" expand="">
		HTML
		<ui:operation id="" name="" icon="" href="" target="" type="" />
	</ui:content>
</ui:panel>

<ui:tabpanel id="" width="100%" height="" scroll="false"
	selectedIndex="0" layout="sys.ui.tabpanel.default" style="" channel="" />

<ui:accordionpanel id="" width="100%" toggle="" expand=""
	layout="sys.ui.accordionpanel.default" style=""
	channel="" />

<!-- 数据展现 -->
<ui:dataview id="" source="" render="" format="" refresh="0"
	channel="">
	<ui:source ref="+" type="+">
	</ui:source>
	<ui:render ref="+" type="+">
	</ui:render>
</ui:dataview>

<!-- OK -->
<!-- 数据格式转换 -->
<ui:dataformat id="">
	<ui:source />
	<ui:transform id="" type="">
	{
		"key": data.id,
		"value": data.name
	}
	</ui:transform>
</ui:dataformat>

<!-- OK -->
<!-- 弹出菜单 -->
<ui:popup id="" arrow="false" align="" border="" triggerEvent=""
	triggerObject="" layout="sys.ui.popupmenu.default" style="" channel="">
	<ui:layout ref="+" type="+" />
	<!-- 文本区 -->
	<ui:text />
	<!-- 弹出区 -->
	<ui:container id="" style="admini">
		HTML
	</ui:container>
</ui:popup>

<!-- 简单文本 -->
<ui:text id="" text="" title="" icon="" style="" channel="">
	HTML
</ui:text>

<!-- OK -->
<!-- 操作条 -->
<ui:toolbar id="" layout="sys.ui.toolbar.default" style="" channel="">
	<ui:layout ref="+" type="+" />
	<ui:button />
	<ui:toggle />
	<ui:popup />
</ui:toolbar>

<!-- OK -->
<!-- 普通按钮 -->
<ui:button id="" text="" title="" icon="" href="" target="" onclick=""
	channel="">
	<ui:text />
</ui:button>
<!-- OK -->
<!-- 带选中状态的按钮，group相同，仅有一个被选中 -->
<ui:toggle id="" text="" title="" icon="" href="" target="" group=""
	onchanged="" selected="true" channel="">
	<ui:text />
</ui:toggle>

<!-- 事件 -->
<ui:event name="*" for="">
</ui:event>
<ui:topic name="*" channel="">
</ui:topic>

<!-- OK -->
<!-- 其它 -->
<ui:enumsource enumType="*" keyName="key" valueName="value" />
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include file="/sys/ui/help/layout-help.jsp">
	<template:replace name="example">
			<script type="text/javascript">
					function testAddNewBtn(thisObj){
						seajs.use([ 'lui/jquery','lui/base','lui/toolbar'], function($,base,toolbar) {
							LUI.fire({
								"type":"topic",
								"name":"btn_add",
								"target":"opt_toolbar",
								"data":{
									"target":toolbar.buildButton({
											text:"删除此按钮",
											click:"testDeleteBtn(this);",
											order:1
										})
								}
							}, window);
						});
						
					}
					function testAddBtn(thisObj){
						seajs.use([ 'lui/jquery','lui/base','lui/toolbar'], function($,base,toolbar) {
							var toolsbar = base.byId('sys_tools_bar_test');
							toolsbar.addButton(base.byId(thisObj.getAttribute('id')));
						});
					}
					function testDeleteBtn(thisObj){
						seajs.use([ 'lui/jquery','lui/base','lui/toolbar'], function($,base,toolbar) {
							var toolsbar = base.byId('sys_tools_bar_test');
							toolsbar.removeButton(base.byId(thisObj.getAttribute('id')));
						});
					}
					function testVisableBtn(thisObj){
						seajs.use([ 'lui/jquery','lui/base','lui/toolbar'], function($,base,toolbar) {
							var btn = base.byId('lui_toolbar_btn_del');
							btn.setVisible(false);
						});
					}

					function testDisableBtn(thisObj){
						seajs.use([ 'lui/jquery','lui/base','lui/toolbar'], function($,base,toolbar) {
							alert("可用");
							var btn = base.byId('lui_toolbar_btn_disable');
							btn.setDisabled(true);
						});
					}
					
			</script>
			<br/><br/>
			<ui:button onclick="testAddBtn(this);" icon="lui_icon_s_icon_exclamation_sign" 
				target="_blank" style="" title="将本按钮通过toolbar的api加到toolbar中" order="2">
					<ui:text>将本按钮通过toolbar的api加到toolbar中</ui:text>
			</ui:button>
			
			<ui:button onclick="testAddBtn(this);" icon="lui_icon_s_icon_plus" 
				target="_blank" style="" title="将本按钮通过toolbar的api加到toolbar的更多区域中"  order="1">
					<ui:text>将本按钮通过toolbar的api加到toolbar的更多区域中</ui:text>
			</ui:button>
			
			<ui:button onclick="testAddNewBtn(this);" icon="lui_icon_s_icon_edit" 
					target="_blank" style="" title="通过事件新建一个可以删除button的按钮到toolbar">
					<ui:text>通过事件新建一个可以删除button的按钮到toolbar</ui:text>
			</ui:button>
			<ui:button href="http://www.sina.com" icon="" id="test_abled"
					target="_blank" style="" title="设置按钮不可用" onclick="LUI('test_abled').setDisabled(true);" order="2">
						<ui:text>设置按钮不可用</ui:text>
				</ui:button>
			<br/><br/><br/>
			<% 
				//top down right left
				String verLayout = request.getParameter("fdId");
				String align = "down-right";
				if(verLayout.indexOf(".ver")>-1){
					align = "right-down";
				}
			%>
			<c:set var="verLayout" value="<%=verLayout%>"/>
			<c:set var="align" value="<%=align%>"/>
			<ui:toolbar layout="${param.fdId}" id="sys_tools_bar_test" style="width:100%" channel="opt_toolbar" count="3">
				<ui:button icon="" style="" title="测试" order="2">
					<ui:text>测试</ui:text>
				</ui:button>
				
				<ui:button href="http://www.sina.com" icon="" 
					target="_blank" style="" title="设置按钮不可见" id='lui_toolbar_btn_del' onclick="testVisableBtn(this);" order="2">
					<ui:text>设置按钮不可见</ui:text>
				</ui:button>
				
				<ui:button href="http://www.sina.com" icon="" 
					target="_blank" style="" title="设置按钮不可用" id='lui_toolbar_btn_disable' onclick="testDisableBtn(this);" order="2">
						<ui:text>设置按钮不可用</ui:text>
				</ui:button>
				
				<ui:button onclick="testDeleteBtn(this);">
					<ui:text>删除当前按钮</ui:text>
				</ui:button>
				<ui:toggle icon="lui_icon_s_tuwen" title="图文列表" selected="true" group="test2">
				</ui:toggle>
				<ui:toggle icon="lui_icon_s_zaiyao" title="摘要列表" group="test2" >
				</ui:toggle>
				
				<list:sort property="docCreateTime" text="提交日期"></list:sort>
				<list:sort property="docReadCount" text="浏览次数"></list:sort>
				
				<ui:button order="5">
					<ui:text>点   评</ui:text>
				</ui:button>
				<ui:button order="5">
					<ui:text>推  荐</ui:text>
				</ui:button>
				<ui:button order="5">
					<ui:text>授  权</ui:text>
				</ui:button>
			</ui:toolbar>
			<br/><br/><br/>
	</template:replace>
</template:include> 

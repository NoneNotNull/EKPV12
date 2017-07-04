<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.sys.ui.plugin.SysUiTools"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<template:include ref="default.simple">
	<template:replace name="head">
		<template:super/>
		<style>
			body{
				background-color: #F9F9F9;
			}
			.one_icon{
				display:inline-block;
				border: #C0C0C0 1px solid;
				margin: 4px 2px;
			}
			.color_block{
				display:inline-block;
				border: #C0C0C0 1px solid;
				width:30px;
				height:20px;
				cursor:pointer;
			}
		</style>
	</template:replace>
	
	<template:replace name="body">
		<div style="margin: 20px;">
			<div>
				背景：
				<c:forEach items="<%=new String[]{"#47B5E6", "#FFFFFF", "#000", "#FDAA04"} %>" var="color" varStatus="i">
					<label>
						<input type="radio" name="fdColor" value="${color}" onclick="changeBgColor(value);" <c:if test="${i.index == 0 }">checked</c:if> >
						<div class="color_block" style="background-color:${color}" ></div>
					</label>
				</c:forEach>
			</div>
		</div>
		
		<ui:accordionpanel>
			<ui:content title="无状态">
				<div lui-icon-frame="true" style="padding:5px;">
					<c:forEach items="<%=SysUiTools.scanIconCssName("l", false) %>" var="icon">
						<div class="one_icon">
							<div class="lui_icon_l ${icon}" title="${icon}" onclick="onIconClick(this.title, false, 'l');"></div>
						</div>
					</c:forEach>
				</div>
			</ui:content>
			
			<ui:content title="有状态">
				<div lui-icon-frame="true" style="padding:5px;">
					<c:forEach items="<%=SysUiTools.scanIconCssName("l", true) %>" var="icon">
						<div class="one_icon">
							<div class="lui_icon_l" lui-icon-status="true">
								<div class="lui_icon_l ${icon}" title="${icon}" onclick="onIconClick(this.title, true, 'l');"></div>
							</div>
						</div>
					</c:forEach>
				</div>
			</ui:content>
		</ui:accordionpanel>
	
	<script>
	seajs.use(['lui/jquery'], function($) {
		$(document).ready(function(){
			$("[lui-icon-status]").mouseover(function(){
				$(this).addClass("lui_icon_on").css('background-color', '#fff');
			}).mouseout(function(){
				$(this).removeClass("lui_icon_on").css('background-color', $("[name='fdColor']:checked").val());
			});
			
			changeBgColor($("[name='fdColor']:checked").val());
		});
	});
	function changeBgColor(color){
		seajs.use(['lui/jquery'], function($) {
			$("[lui-icon-frame]").css("background-color", color);
		});
	}
	function onIconClick(value, isOn, type){
		window.returnValue = value;
		window.close();
	}
	</script>
	</template:replace>
</template:include>



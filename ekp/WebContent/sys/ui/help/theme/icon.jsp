<%@page import="com.landray.kmss.sys.ui.plugin.SysUiTools"%>
<%@page import="java.util.List"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%!
public void putToRequest(HttpServletRequest request, String type) throws Exception{
	List<String> icon_on = SysUiTools.scanIconCssName(type, true);
	List<String> icon = SysUiTools.scanIconCssName(type, false);
	icon.removeAll(icon_on);
	request.setAttribute("icons_on", icon_on);
	request.setAttribute("icons", icon);
}
%>
<%
String[] titles = {"小图标（16*16）", "中图标（32*32）", "大图标（48*48）"};
String[] types = {"s", "m", "l"};
String[] colors = {"#FFFFFF", "#47B5E6", "#FDAA04"};
request.setAttribute("colors", colors);
%>
<template:include ref="default.simple">
	<template:replace name="head">
		<template:super/>
		<style>
			body{background-color: #F9F9F9;}
			.one_icon{
				margin-top:2px;
				display:inline-block;
				border: #C0C0C0 1px solid;
				line-height: 1px;
			}
			.color_block{
				display:inline-block;
				border: #C0C0C0 1px solid;
				width:30px;
				height:20px;
				cursor:pointer;
			}
		</style>
		<script>
			var fdStatus = "auto";
			seajs.use(['lui/jquery'], function($) {
				window.$ = $;
				$(document).ready(function(){
					var divs = $("[lui-icon-status]");
					divs.mouseover(function(){
						if(fdStatus=="auto")
							$(this).addClass("lui_icon_on");
					});
					divs.mouseout(function(){
						if(fdStatus=="auto")
							$(this).removeClass("lui_icon_on");
					});
					$("[name=fdColor]").get(0).checked = true;
				});
			});
			function changeBgColor(color){
				$("[lui-icon-frame]").css("background-color", color);
			}
			function changeStatus(status){
				fdStatus = status;
				if(status=="on"){
					$("[lui-icon-status]").addClass("lui_icon_on");
				}else{
					$("[lui-icon-status]").removeClass("lui_icon_on");
				}
			}
			function onIconClick(obj, isOn, type){
				var value = obj.title;
				var field = $("#fdSelect");
				field.val(value);
				field.select();
				var example = $("#iconExcample");
				var x;
				if(isOn){
					x = '非选中状态：<br>'+
						'&lt;div class="lui_icon_'+type+'"&gt;<br>'+
						'&nbsp;&nbsp;&nbsp;&nbsp;&lt;div class="lui_icon_'+type+' '+value+'"&gt;&lt;/div&gt;<br>'+
						'&lt;/div&gt;<br><br>'+
						'选中状态：<br>'+
						'&lt;div class="lui_icon_'+type+' lui_icon_on"&gt;<br>'+
						'&nbsp;&nbsp;&nbsp;&nbsp;&lt;div class="lui_icon_'+type+' '+value+'"&gt;&lt;/div&gt;<br>'+
						'&lt;/div&gt;<br><br>'+
						'说明：<br>外层的DIV不是必须，选中状态只需要在外层元素中增加lui_icon_on样式即可。';
				}else{
					x = '&lt;div class="lui_icon_'+type+' '+value+'"&gt;&lt;/div&gt;';
				}
				example.html(x);
				$('[selectflag=1]').css('border-color', '');
				selectIcon(obj);
			}
			function selectIcon(obj){
				for(var o=obj; o!=null; o=o.parentNode){
					if(o.className=='one_icon')
						break;
				}
				$(o).css('border-color', 'red');
				$(o).attr('selectflag', '1');
			}
			function searchIcon(input){
				var e = Com_GetEventObject();
				if(e.keyCode==13){
					$('[selectflag=1]').css('border-color', '');
					var value = input.value;
					$('.'+input.value).each(function(){
						selectIcon(this);
					});
				}
			}
		</script>
	</template:replace>
	<template:replace name="body">
		<ui:top />
		<%@ include file="nav.jsp" %>
		<div style="height:10px;"></div>
		<div style="width:1000px; margin:0px auto; background-color: white; padding:10px;">
			<div class="com_subject" style="margin:10px auto 5px; font-size:18px; text-align:center;">
				<c:out value="${ theme.fdName }"/>（${ theme.fdId }）
			</div>
			<div style="padding-bottom:8px; color:#999999;">提示：点击图标，按“Ctrl+C”可以直接拷贝</div>
			<div class="clr"></div>
			<div style="float: left;">
				背景：
				<c:forEach items="${colors}" var="color" varStatus="i">
					<label>
						<input type="radio" name="fdColor" value="${color}" onclick="changeBgColor(value);">
						<div class="color_block" style="background-color:${color}" ></div>
					</label>
				</c:forEach>
			</div>
			<div style="float:right;margin-top:8px;">
				<label>
					<input type="radio" name="fdStatus" value="auto" checked onclick="changeStatus(value);">
					鼠标悬浮切换状态
				</label>
				<label>
					<input type="radio" name="fdStatus" value="on" onclick="changeStatus(value);">
					始终显示选中状态
				</label>
				<label>
					<input type="radio" name="fdStatus" value="off" onclick="changeStatus(value);">
					始终显示非选中状态
				</label>
			</div>
			<div style="float:right; margin-right:25px; padding:6px; cursor:pointer;">
				调用代码
				<ui:popup style="background:white;padding:8px;">
					<span id="iconExcample">请先选择一个图标</span>
				</ui:popup>
			</div>
			<div style="float:right; margin-right:25px; margin-top:4px;">
				选中：<input id="fdSelect" style="border: #C0C0C0 1px solid; height:20px;" onkeydown="searchIcon(this);">
			</div>
			<div class="clr" style="height:3px;"></div>
			<ui:accordionpanel>
				<%
					for(int i=0; i<types.length; i++){
						putToRequest(request, types[i]);
						String title1 = titles[i]+" - 无状态 - 共 " + ((List)request.getAttribute("icons")).size() + "个";
						String title2 = titles[i]+" - 带状态 - 共 " + ((List)request.getAttribute("icons_on")).size() + "个";
						
				%>
				<c:if test="${not empty icons}">
					<ui:content title="<%= title1 %>">
						<div lui-icon-frame="true" style="padding:5px;">
							<c:forEach items="${icons}" var="icon">
								<div class="one_icon">
									<div class="lui_icon_<%= types[i] %> ${icon}" title="${icon}" onclick="onIconClick(this, false, '<%= types[i] %>');"></div>
								</div>
							</c:forEach>
						</div>
					</ui:content>
				</c:if>
				<c:if test="${not empty icons_on}">
					<ui:content title="<%= title2 %>">
						<div lui-icon-frame="true" style="padding:5px;">
							<c:forEach items="${icons_on}" var="icon">
								<div class="one_icon">
									<div class="lui_icon_<%= types[i] %>" lui-icon-status="true">
										<div class="lui_icon_<%= types[i] %> ${icon}" title="${icon}" onclick="onIconClick(this, true, '<%= types[i] %>');"></div>
									</div>
								</div>
							</c:forEach>
						</div>
					</ui:content>
				</c:if>
				<%
					}
				%>
			</ui:accordionpanel>
		</div>
	</template:replace>
</template:include>
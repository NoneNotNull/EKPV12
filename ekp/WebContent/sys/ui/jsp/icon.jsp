<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="com.landray.kmss.sys.ui.plugin.SysUiTools"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="title">选择Icon</template:replace>
	<template:replace name="head">
		<template:super/>
		<style type="text/css">
			html,body {
				height: 100%;
			}
			.flt {
				float: left;
				cursor: pointer;
				padding: 5px;
			}
		</style>
		<script>
			function onIconClick(title){
				window.$dialog.hide(title);
			}
			LUI.ready(function(){
				LUI.$(".lui_icon_l").hover(
					function(){
						LUI.$(this).addClass("lui_icon_on");
					},
					function(){
						LUI.$(this).removeClass("lui_icon_on");						
					}
				);
			});
		</script>
	</template:replace>
	<template:replace name="body">
		<%
		String type = request.getParameter("type");
		String status = request.getParameter("status");
		if(StringUtil.isNull(type)){
			type = "l";
		}
		if(StringUtil.isNull(status)){
			status = "true";
		}
		List<String> icon = SysUiTools.scanIconCssName(type,Boolean.valueOf(status));
		request.setAttribute("icons", icon);
		%> 
		<div style="padding:0px;height:100%;overflow: auto;text-align: center;">
			<div style="padding:5px;">
				<c:forEach items="${icons}" var="icon">
					<div class="one_icon flt">
						<div class="lui_icon_l">
							<div class="lui_icon_l ${icon}" style="background-color: #C78700;" title="${icon}" onclick="onIconClick(this.title);"></div>
						</div>
					</div>
				</c:forEach>
			</div>
		</div>  
	</template:replace>
</template:include>
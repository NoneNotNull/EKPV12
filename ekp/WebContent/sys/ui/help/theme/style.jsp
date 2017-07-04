<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="head">
		<template:super/>
		<style>
			body{background-color: #F9F9F9;}
			.headline {font-size:14px; font-weight: bold; color: #333; border-bottom: 1px #CCC solid; padding:10px 10px 5px; margin-bottom: 2px;}
			.helptext {line-height:30px; padding: 0px 10px; background-color: #F9F9F9; margin-bottom:2px;}
			.helptitle {line-height:30px; padding: 0px 10px; background-color: #F9F9F9; margin-bottom:2px; color:#333;}
			.textcolor span {display:inline-block; min-width:200px; line-height:30px; margin-left:20px;}
			.container_frame {display:inline-block; border:1px yellow dashed; padding:2px; width:480px; margin:10px; vertical-align: top;}
		</style>
	</template:replace>
	<template:replace name="body">
		<ui:top />
		<%@ include file="nav.jsp" %>
		<div style="height:10px;"></div>
		<div style="margin:0px 20px;">
			<div style="padding:5px 10px; background-color: #FFFFFF;">
				<div class="com_subject" style="margin:10px auto 5px; font-size:18px; text-align:center;">
					<c:out value="${ theme.fdName }"/>（${ theme.fdId }）
				</div>
				<div class="headline">
					字体颜色
				</div>
				<div class="helptext">
					说明：字体颜色一般用于强调文字，直接在html对象的指定类名即可。
				</div>
				<div class="textcolor">
					<span>默认</span>
					<span class="com_subject">标题（com_subject）</span>
					<span class="com_subhead">子标题（com_subhead）</span>
					<span class="com_author">作者（com_author）</span>
					<span class="com_number">数字（com_number）</span>
					<span class="com_warn">警告（com_warn）</span>
					<span class="com_help">辅助（com_help）</span>
				</div>
				
				<div class="headline">
					超链接
				</div>
				<div class="helptext">
					说明：一般的超链接无需声明类名，若该超链接当作按钮使用，请在 A 中加上的类名。
				</div>
				<div class="textcolor">
					<span><a href="#">默认超链接</a></span>
					<span><a href="#" class="com_btn_link">按钮类超链接</a>（com_btn_link）</span>
					<span><a href="#" class="com_btn_link_light">弱化的按钮类超链接</a>（com_btn_link_light）</span>
				</div>
				
				<div class="headline">
					表格布局
				</div>
				<div class="helptext">
					说明：有边框的表格，在 TABLE 中加上类名（tb_normal），无边框的表格，在 TABLE 中加上类名（td_simple）。<br>
					标题行统一在 TR 中加上类名（tr_normal_title）。标题列统一在 TD 中加上类名（td_normal_title）。
				</div>
				<div class="container_frame">
					<table class="tb_normal" width="100%">
						<tr class="tr_normal_title">
							<td colspan="2">有边框-标题行</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="30%">标题列</td>
							<td width="70%">普通列</td>
						</tr>
					</table>
				</div>
				<div class="container_frame">
					<table class="tb_simple" width="100%">
						<tr class="tr_normal_title">
							<td colspan="2">无边框-标题行</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="30%">标题列</td>
							<td width="70%">普通列</td>
						</tr>
					</table>
				</div>
				
				<div class="headline">
					样式引入
				</div>
				<div class="helptext">
					说明：系统默认会加载common和icon的样式，调用时无需引入样式文件。
				</div>

				<div class="headline">
					特殊按钮
				</div>
				<div class="helptext">
					说明：用在页面特殊需求的按钮。主题对按钮分别进行了背景，边框，字体颜色的定义，按钮大小等其他属性由开发人员自己去定义。
				</div>
				<div class="textcolor">
				  <p style="margin-bottom:5px;"><span style="display:inline-block; min-width:50px; line-height:24px; padding:0px 8px; margin-right:8px; cursor:pointer;" class="com_bgcolor_d com_bordercolor_d com_fontcolor_d">强调按钮</span><span style="margin-right:8px;" class="">背景色（com_bgcolor_d）</span><span class="" style="margin-right:8px;">边框线（com_bordercolor_d）</span><span class="" style="margin-right:8px;">字体颜色（com_fontcolor_d）</span></p>
				  <p style="margin-bottom:5px;"><span style="display:inline-block; min-width:50px; line-height:24px; padding:0px 8px; margin-right:8px; cursor:pointer;" class="com_bgcolor_n com_bordercolor_n com_fontcolor_n">正常按钮</span><span style="margin-right:8px;" class="">背景色（com_bgcolor_n）</span><span class="" style="margin-right:8px;">边框线（com_bordercolor_n）</span><span class="" style="margin-right:8px;">字体颜色（com_fontcolor_n）</span></p>
				  <p style="margin-bottom:5px;"><span style="display:inline-block; min-width:50px; line-height:24px; padding:0px 8px; margin-right:8px; cursor:pointer;" class="com_bgcolor_l com_bordercolor_l com_fontcolor_l">弱化按钮</span><span style="margin-right:8px;" class="">背景色（com_bgcolor_l）</span><span class="" style="margin-right:8px;">边框线（com_bordercolor_l）</span><span class="" style="margin-right:8px;">字体颜色（com_fontcolor_l）</span></p>
				</div>

			</div>
		</div>
		<div style="height:5px;"></div>
	</template:replace>
</template:include>
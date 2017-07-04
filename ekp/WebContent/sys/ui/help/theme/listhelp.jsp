<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="head">
		<template:super/>
		<style>
			.headline {font-size:14px; font-weight: bold; color: #333; border-bottom: 1px #CCC solid; padding:10px 10px 5px; margin-bottom: 2px;}
			.helptext {line-height:30px; padding: 0px 10px; background-color: #F9F9F9; margin-bottom:2px;}
			.helptitle {line-height:30px; padding: 0px 10px; background-color: #F9F9F9; margin-bottom:2px; color:#333;}
			.textcolor span {display:inline-block; min-width:200px; line-height:30px; margin-left:20px;}
			.container_frame {display:inline-block; border:1px yellow dashed; padding:2px; width:480px; margin:10px; vertical-align: top;}
		</style>
	</template:replace>
	<template:replace name="body">
			<div style="padding:5px 10px;">
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
					说明：当您使用默认default.list时，模板会自动加载list样式，若您期望在其它页面中使用list样式相关的类，请在代码中加上：<br>
					&lt;script type="text/javascript"&gt; seajs.use('theme!list'); &lt;/script&gt;
				</div>
			</div>
	</template:replace>
</template:include>
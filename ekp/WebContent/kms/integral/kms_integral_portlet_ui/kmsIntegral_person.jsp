<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="person.home">
	<template:replace name="head">
		<link href="${LUI_ContextPath}/kms/integral/kms_integral_portlet_ui/style/person.css" type="text/css" rel="stylesheet" />
	</template:replace>
	<template:replace name="title">
		${lfn:message('kms-integral:kmsIntegral.my.integral')}
	</template:replace>
	<template:replace name="content">
		<ui:dataview>
			<ui:source type="AjaxJson">
				{url:'/kms/integral/kms_integral_module_total/kmsIntegralModuleTotal.do?method=getMyIntegral'}
			</ui:source>
			<ui:render type="Template">
				<%-- 积分范围 --%>
				{$
				<div style="padding: 10px;background-color: #FFFFFF;" class="clearfloat">
					<h3 class="lui_integral_title_info">
						<img alt="积分范围" style="margin-bottom: -5px" src="style/images/point.jpg"><span>积分范围</span>
					</h3>
					<table class="tb_simple" style="border:1px #d2d2d2 solid;" width="100%">
					$}
						for(var i = 0; i<data.moduleTypes.length; i++) {
					{$	
						<tr>
							<td style="text-align:right;width:120px;">{%data.moduleTypes[i].fdName%}：</td>
							<td>{%data.moduleTypes[i].moduleNameStr%}</td>
						</tr>
					$}
						}
					{$
					</table>
					$}
					
					<%-- 我的积分 --%>
					
					{$
						<h3 class="lui_integral_title_info">
							<img alt="我的积分" style="margin-bottom: -5px" src="style/images/point.jpg"><span>我的积分</span>
						</h3>
						<table width="100%"  class="tb_normal lui_integral_td_center">
							<tr>
					$}
								for(var i = 0; i<data.scoreModules.length; i++) {
					{$				
									<td class="lui_integral_bg">{%data.scoreModules[i]%}</td>
					$}
								}
					{$
							</tr>
							<tr>
					$}
								for(var i = 0; i<data.exps.length;i++){
					{$				
									<td>{%data.exps[i]||0%}</td>
					$}
								}
					{$
							</tr>
							<tr>
					$}
								for(var i = 0; i<data.riches.length;i++){
					{$				
									<td>{%data.riches[i]||0%}</td>
					$}
								}
					{$
							</tr>
						</table>
						<br /><!--
						<span class="lui_detail_cko">查看详细明细</span>
						<span class="lui_help_cko">帮助提示</span>
						--><br />
						<div id="detailview" class="clr" style="display: none;">
					$}
			</ui:render>
			<ui:event event="load" args="evt">
				LUI.$('.lui_detail_cko').click(bindButton);
				LUI.$('.lui_help_cko').click(bindHelpButton);
			</ui:event>
		</ui:dataview>
		<script>
			<%--绑定按钮 --%>
			function bindButton() {
				var $obj = LUI.$('#detailview');
				if ($obj.is(":hidden")) {
					$obj.slideDown("slow");
					LUI.$('.lui_detail_cko').addClass('lui_cko_detail_slideDown');
				}
				else {
					$obj.slideUp("slow");
					LUI.$('.lui_detail_cko').removeClass('lui_cko_detail_slideDown');
				}
			}

			function bindHelpButton() {
				Com_OpenWindow("${LUI_ContextPath}/kms/integral/kms_integral_portlet_ui/kmsIntegral_person_help.jsp", '_blank', null, false);
			}
		</script>
	</template:replace>
</template:include>


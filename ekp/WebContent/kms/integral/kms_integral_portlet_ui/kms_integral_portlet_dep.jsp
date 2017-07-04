<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/person/person.tld" prefix="person"%>
<ui:ajaxtext>
	<script>
		seajs.use("kms/integral/kms_integral_portlet_ui/style/portlet_dep.css");
		// 积分取整
		function subStr(score){
			var str = score.toString();
			var index = str.indexOf('.');
			if(index>0){
				return str.substring(0,index); 
			}
			return str;
		}
	</script>
	<ui:dataview>
		<ui:source type="AjaxJson">
			{url:'/kms/integral/kms_integral_portlet_month/kmsIntegralPortletMonth.do?method=getMonthScore&rowsize=${param.rowsize}&type=${param.type}&deptId=${param.deptId}&orderby=${param.orderby}&showType=dept'}
		</ui:source>
		<ui:render type="Template">
				{$ 
					<table width="100%" border="0" cellspacing="0" 
							cellpadding="0" class="lui_score_dep_tb lui_score_dep_tb_personal" >
						<tr>
							<th >${lfn:message('kms-integral:kmsIntegral.fdRank')}</th>
							<th class="lui_score_dep_name_th">${lfn:message('kms-integral:kmsIntegral.name')}</th>
							<c:if test="${param.showScore == 'yes'}">
								<th >${lfn:message('kms-integral:kmsIntegralCommon.fdTotalScore')}</th>
							</c:if>
							<c:if test="${param.showRiches == 'yes'}">
								<th >${lfn:message('kms-integral:kmsIntegralCommon.fdTotalRiches') }</th>
							</c:if>
						</tr>
				$}
						for(var i=0; i<data.personalIntegrals.length; i++){
							if(i<3){
				{$ 				<tr class="lui_score_dep_top3">
								<td class="lui_score_dep_num lui_score_dep_pre_{%i+1%}" style="width:18%">
				$}
							}else{
				{$ 				<tr class="lui_score_dep_top_common">
								<td class="lui_score_dep_num" style="width:18%">
				$}
							}
							
				{$
								<span class="lui_score_dep_num_flag">{%i+1%}</span></td>
								<td class="lui_score_dep_center lui_score_dep_name" style="width:27%">
									<div class="lui_score_dep_head_name">
										<span class="lui_score_dep_head">
											<img src="${LUI_ContextPath}/sys/person/sys_person_zone/sysPersonZone.do?method=img&fdId={%data.personalIntegrals[i].fdId%}&size=s" alt="">
										</span>
										<a title="{%data.personalIntegrals[i].fdName%}" href="${LUI_ContextPath}/sys/person/sys_person_zone/sysPersonZone.do?method=view&fdId={%data.personalIntegrals[i].fdId%}"
											target="_blank">
											{%data.personalIntegrals[i].fdName%}
										</a>
									</div>
								</td>
								<c:if test="${param.showScore == 'yes'}">
									<td class="com_number lui_score_dep_center lui_score_dep_score" style="width:30%">			
										{% subStr(data.personalIntegrals[i].score) %}
									</td>
								</c:if>
								<c:if test="${param.showRiches == 'yes'}">
									<td class="lui_score_dep_center lui_score_dep_piece" style="width:25%">
										{%data.personalIntegrals[i].riches%}
									</td>
								</c:if>
							</tr>
				$}
						}
				{$
					</table>
				$}
		</ui:render>
	</ui:dataview>
</ui:ajaxtext>
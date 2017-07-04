<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<ui:ajaxtext>
	<script>
		seajs.use("kms/integral/kms_integral_portlet_ui/style/portlet_team.css");
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
			{url:'/kms/integral/kms_integral_portlet_month/kmsIntegralPortletMonth.do?method=getMonthScore&rowsize=${param.rowsize}&type=${param.type}&deptId=${param.deptId}&orderby=${param.orderby}&showType=team'}
		</ui:source> 
		<ui:render type="Template">
				{$ 
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="lui_score_tb lui_score_tb_personal" >
						<tr>
							<th >${lfn:message('kms-integral:kmsIntegral.fdRank')}</th>
							<th >${lfn:message('kms-integral:kmsIntegralTeamRank.fdTeam')}</th>
							<th >${lfn:message('kms-integral:kmsIntegralTeamRank.personCount')}</th>
							<c:if test="${param.showScore == 'yes' }">
								<th >${lfn:message('kms-integral:kmsIntegralCommon.fdTotalScore')}</th>
							</c:if>
							<c:if test="${param.showRiches == 'yes' }">
								<th >${lfn:message('kms-integral:kmsIntegralCommon.fdTotalRiches') }</th>
							</c:if>
						</tr>
				$}
						for(var i=0; i<data.teamIntegrals.length; i++){
							if(i<3){
				{$ 				<tr class="lui_score_top3">
								<td class="lui_score_num lui_score_pre_{%i+1%}" >
				$}
							}else{
				{$ 				<tr class="lui_score_top_common">
								<td class="lui_score_num">
				$}
							}
				{$
								<span class="lui_score_num_flag">{%i+1%}</span></td>
								<td class="lui_score_center lui_score_name" >{%data.teamIntegrals[i].fdName%}</td>
								<td class="lui_score_center lui_score_name" >{%data.teamIntegrals[i].fdPersonCount%}</td>
								<c:if test="${param.showScore == 'yes' }">
									<td class="com_number lui_score_center lui_score_score" >			
										{% subStr(data.teamIntegrals[i].score) %}
									</td>
								</c:if>
								<c:if test="${param.showRiches == 'yes' }">
									<td class="lui_score_center lui_score_piece" >{%data.teamIntegrals[i].riches%}</td>
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
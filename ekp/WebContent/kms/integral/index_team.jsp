<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/portal/portal.tld" prefix="portal"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<template:include ref="default.simple" >
	<template:replace name="title">
		${lfn:message('kms-integral:kmsIntegral.portlet.points.ranking') }
	</template:replace>
	<template:replace name="head">
		<template:super/>
		<script>
			seajs.use(['theme!list','theme!portal']);
		</script>
	</template:replace>
	<template:replace name="body">
		<portal:header var-width="100%" />
		<%--模块筛选 --%>
		<div style="width:90%; min-width:980px; margin:4px auto 15px auto;">
			<list:criteria id="module_sort" expand="true">		
				<list:cri-criterion title="${lfn:message('kms-integral:kmsIntegralCommon.isTime') }" key="time" multi="false">
					<list:box-select>
						<list:item-select cfg-defaultValue="fdWeek" cfg-required="true">
							<ui:source type="Static">
								[{text:"${lfn:message('kms-integral:kmsIntegralCommon.fdWeek') }", value: 'fdWeek'},
								{text:"${lfn:message('kms-integral:kmsIntegralCommon.fdMonth') }", value:'fdMonth'},
								{text:"${lfn:message('kms-integral:kmsIntegralCommon.fdYear') }", value:'fdYear'},
								{text:"${lfn:message('kms-integral:kmsIntegralCommon.fdTotal') }", value:'fdTotal'}]
							</ui:source>
						</list:item-select>
					</list:box-select>
				</list:cri-criterion>
	
				<list:cri-criterion title="${lfn:message('kms-integral:kmsIntegralCommon.isType') }" key="score" multi="false">
					<list:box-select>
						<list:item-select cfg-defaultValue="fdTotalScore" cfg-required="true">
							<ui:source type="Static">
								[{text:"${lfn:message('kms-integral:kmsIntegralCommon.fdTotalScore') }", value: 'fdTotalScore'},
								{text:"${lfn:message('kms-integral:kmsIntegralCommon.fdTotalRiches') }", value:'fdTotalRiches'}]
							</ui:source>
						</list:item-select>
					</list:box-select>
				</list:cri-criterion>
				<list:cri-ref key="fdTeamName" ref="criterion.sys.docSubject" title="团队名称">
			</list:cri-ref>
			</list:criteria>
			<ui:fixed elem=".lui_list_operation"></ui:fixed>
			<%--list视图--%>
			<list:listview id="listview">
				<ui:source type="AjaxJson">
					{url:'/kms/integral/kms_integral_team_rank/kmsIntegralTeamRank.do?method=data'}
				</ui:source>
				<%--列表形式--%>
				<list:colTable layout="sys.ui.listview.columntable" name="columntable">
						<list:col-serial title="${lfn:message('kms-integral:kmsIntegral.fdRank')}" headerStyle="width:5%"/>
						
						<list:col-html title="${lfn:message('kms-integral:kmsIntegralTeam.fdName')}" style="width:20%" >
							{$
								<span>{%row['name']%}</span>
							$}
				  	 	</list:col-html>
				  	 	
				  	 	<list:col-html title="${lfn:message('kms-integral:kmsIntegralTeamRank.personCount')}" style="width:10%" >
							{$
								<span>{%row['fdPersonCount']%}</span>
							$}
				  	 	</list:col-html>
				  	 	
				  	 	<list:col-html title="${lfn:message('kms-integral:kmsIntegralCommon.fdTotalScore')}" style="width:10%" >
							{$
								<span>{%row['fdTotalScore']%}</span>
							$}
				  	 	</list:col-html>
				  	 	<list:col-html title="${lfn:message('kms-integral:kmsIntegralTeamRank.avg.fdScoreValue')}" style="width:10%" >
							{$
								<span>{%row['fdAvgScore']%}</span>
							$}
				  	 	</list:col-html>
				  	 	<list:col-html title="${lfn:message('kms-integral:kmsIntegralCommon.fdTotalRiches')}" style="width:10%" >
							{$
								<span>{%row['fdTotalRiches']%}</span>
							$}
				  	 	</list:col-html>
				  	 	<list:col-html title="${lfn:message('kms-integral:kmsIntegralTeamRank.avg.fdRichesValue')}" style="width:10%" >
							{$
								<span>{%row['fdAvgRiches']%}</span>
							$}
				  	 	</list:col-html>
				</list:colTable>
			</list:listview> 
		 	<list:paging></list:paging>
	 	</div>
	 	<portal:footer var-width="100%" />
	</template:replace>
</template:include>

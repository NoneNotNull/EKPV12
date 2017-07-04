<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/kms/integral/kms_integral_team_rank/kmsIntegralTeamRank.do">
<br/>	
<style>
.tab tr{line-height: 20px;}
.tab tr td{color:#797874;}
</style>
<script>
Com_IncludeFile("dialog.js|plugin.js"); 
</script>
<table class="tab" >
	<tr><td width="50px" align="right"><bean:message bundle="kms-integral" key="kmsIntegralCommon.isTime"/>: </td>
		<td width="80px" style="padding-left:10px;"><label for="week" style="cursor: pointer;"><input type="radio" name="time" <c:if test="${'week'==param.time||null==param.time||''==param.time}" >checked="checked"</c:if> value="week" onchange="clickTime('week');" id="week"/><bean:message bundle="kms-integral" key="kmsIntegralCommon.fdWeek"/></label></td>
		<td width="80px" ><label for="month" style="cursor: pointer;"><input type="radio" name="time" value="month"  <c:if test="${'month'==param.time}" >checked="checked"</c:if> onchange="clickTime('month');" id="month"/><bean:message bundle="kms-integral" key="kmsIntegralCommon.fdMonth"/></label></td>
		<td width="80px" ><label for="year" style="cursor: pointer;"><input type="radio" name="time" value="year" <c:if test="${'year'==param.time}">checked="checked"</c:if> onchange="clickTime('year');" id="year"/><bean:message bundle="kms-integral" key="kmsIntegralCommon.fdYear"/></label></td>
		<td	width="80px" ><label for="all" style="cursor: pointer;"><input type="radio" name="time" value="all" <c:if test="${'all'==param.time}">checked="checked"</c:if> onchange="clickTime('all');" id="all"/><bean:message bundle="kms-integral" key="kmsIntegralCommon.fdTotal"/></label></td>
		<td colspan="5">&nbsp;</td>
	</tr>
	<tr><td align="right"><bean:message bundle="kms-integral" key="kmsIntegralCommon.isType"/>: </td>
		<td style="padding-left:10px;"><label for="fdTotalScore" style="cursor: pointer;"><input type="radio" name="score" <c:if test="${'fdTotalScore'==param.score||null==param.score||''==param.score}" >checked="checked"</c:if> value="fdTotalScore" onchange="clickScore('fdTotalScore');" id="fdTotalScore"><bean:message bundle="kms-integral" key="kmsIntegralCommon.fdTotalScore"/></label></td>
		<td><label for="fdExpScore" style="cursor: pointer;"><input type="radio" name="score" value="fdExpScore"  <c:if test="${'fdExpScore'==param.score}" >checked="checked"</c:if> onchange="clickScore('fdExpScore');" id="fdExpScore"><bean:message bundle="kms-integral" key="kmsIntegralCommon.fdExpScore"/></label></td>
		<td><label for="fdDocScore" style="cursor: pointer;"><input type="radio" name="score" value="fdDocScore"  <c:if test="${'fdDocScore'==param.score}" >checked="checked"</c:if> onchange="clickScore('fdDocScore');" id="fdDocScore"><bean:message bundle="kms-integral" key="kmsIntegralCommon.fdDocScore"/></label></td>
		<td><label for="fdOtherScore" style="cursor: pointer;"><input type="radio" name="score" value="fdOtherScore"  <c:if test="${'fdOtherScore'==param.score}" >checked="checked"</c:if> onchange="clickScore('fdOtherScore');" id="fdOtherScore"><bean:message bundle="kms-integral" key="kmsIntegralCommon.fdOtherScore"/></label></td>
		<td width="70px"><label for="fdTotalRiches" style="cursor: pointer;"><input type="radio" name="score" value="fdTotalRiches"  <c:if test="${'fdTotalRiches'==param.score}" >checked="checked"</c:if> onchange="clickScore('fdTotalRiches');" id="fdTotalRiches"><bean:message bundle="kms-integral" key="kmsIntegralCommon.fdTotalRiches"/></label></td>
		<td width="70px"><label for="fdExpRiches" style="cursor: pointer;"><input type="radio" name="score" value="fdExpRiches"  <c:if test="${'fdExpRiches'==param.score}" >checked="checked"</c:if> onchange="clickScore('fdExpRiches');" id="fdExpRiches"><bean:message bundle="kms-integral" key="kmsIntegralCommon.fdExpRiches"/></label></td>
		<td width="70px"><label for="fdDocRiches" style="cursor: pointer;"><input type="radio" name="score" value="fdDocRiches"  <c:if test="${'fdDocRiches'==param.score}" >checked="checked"</c:if> onchange="clickScore('fdDocRiches');" id="fdDocRiches"><bean:message bundle="kms-integral" key="kmsIntegralCommon.fdDocRiches"/></label></td>
		<td width="70px"><label for="fdOtherRiches" style="cursor: pointer;"><input type="radio" name="score" value="fdOtherRiches"  <c:if test="${'fdOtherRiches'==param.score}" >checked="checked"</c:if> onchange="clickScore('fdOtherRiches');" id="fdOtherRiches"><bean:message bundle="kms-integral" key="kmsIntegralCommon.fdOtherRiches"/></label></td>
		<td colspan="1">&nbsp;</td>
	</tr>
	<tr>
		<td align="left" colspan="10" style="padding-left:10px;"><bean:message bundle="kms-integral" key="kmsIntegralCommon.lastUpdateTime"/>: &nbsp;&nbsp;${fdLastTime}</td>
	</tr>
</table>	
<span style="line-height: 2px;height:2px;" class=txtlistpath>&nbsp;</span>			
	
<c:if test="${queryPage.totalrows==0}">
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
</c:if>
<c:if test="${queryPage.totalrows>0}">
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
				<td width="5%">
					&nbsp;
				</td>
				<td width="10%">
					<bean:message bundle="kms-integral" key="kmsIntegralTeam.fdName"/>
				</td>
				<td width="10%">
					<bean:message bundle="kms-integral" key="kmsIntegralTeamRank.personCount"/>
				</td>
				<td>
					<bean:message bundle="kms-integral" key="kmsIntegralCommon.fdTotalScore"/>
				</td>
				<td>
					<bean:message bundle="kms-integral" key="kmsIntegralCommon.fdExpScore"/>
				</td>
				<td>
					<bean:message bundle="kms-integral" key="kmsIntegralCommon.fdDocScore"/>
				</td>
				<td>
					<bean:message bundle="kms-integral" key="kmsIntegralCommon.fdOtherScore"/>
				</td>
				<td>
					<bean:message bundle="kms-integral" key="kmsIntegralTeamRank.avg.fdScoreValue"/>
				</td>
				<td>
					<bean:message bundle="kms-integral" key="kmsIntegralCommon.fdTotalRiches"/>
				</td>
				<td>
					<bean:message bundle="kms-integral" key="kmsIntegralCommon.fdExpRiches"/>
				</td>
				<td> 
					<bean:message bundle="kms-integral" key="kmsIntegralCommon.fdDocRiches"/>
				</td>
				<td>
					<bean:message bundle="kms-integral" key="kmsIntegralCommon.fdOtherRiches"/>
				</td>
				<td> 
					<bean:message bundle="kms-integral" key="kmsIntegralTeamRank.avg.fdRichesValue"/>
				</td>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsIntegralTeamRank" varStatus="vstatus">
			<tr>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmsIntegralTeamRank.fdTeam.fdName}" />
				</td>
				<td>
					<c:out value="${kmsIntegralTeamRank.fdPersonCount}" />
				</td>
				<c:if test="${'week'==param.time ||  '' ==param.time || null ==param.time}">
					<td>
						<c:out value="${kmsIntegralTeamRank.fdWeek.fdTotalScore}" />
					</td>
					<td>
						<c:out value="${kmsIntegralTeamRank.fdWeek.fdExpScore}" />
					</td>
					<td>
						<c:out value="${kmsIntegralTeamRank.fdWeek.fdDocScore}" />
					</td>
					<td>
						<c:out value="${kmsIntegralTeamRank.fdWeek.fdOtherScore}" />
					</td>
					<td>
						<c:out value="${kmsIntegralTeamRank.fdWeek.fdAvgScore}" />
					</td>
					<td>
						<c:out value="${kmsIntegralTeamRank.fdWeek.fdTotalRiches}" />
					</td>
					<td>
						<c:out value="${kmsIntegralTeamRank.fdWeek.fdExpRiches}" />
					</td>
					<td>
						<c:out value="${kmsIntegralTeamRank.fdWeek.fdDocRiches}" />
					</td>
					<td>
						<c:out value="${kmsIntegralTeamRank.fdWeek.fdOtherRiches}" />
					</td>
					<td>
						<c:out value="${kmsIntegralTeamRank.fdWeek.fdAvgRiches}" />
					</td>
				</c:if>
				<c:if test="${'month'==param.time}">
					<td>
						<c:out value="${kmsIntegralTeamRank.fdMonth.fdTotalScore}" />
					</td>
					<td>
						<c:out value="${kmsIntegralTeamRank.fdMonth.fdExpScore}" />
					</td>
					<td>
						<c:out value="${kmsIntegralTeamRank.fdMonth.fdDocScore}" />
					</td>
					<td>
						<c:out value="${kmsIntegralTeamRank.fdMonth.fdOtherScore}" />
					</td>
					<td>
						<c:out value="${kmsIntegralTeamRank.fdMonth.fdAvgScore}" />
					</td>
					<td>
						<c:out value="${kmsIntegralTeamRank.fdMonth.fdTotalRiches}" />
					</td>
					<td>
						<c:out value="${kmsIntegralTeamRank.fdMonth.fdExpRiches}" />
					</td>
					<td>
						<c:out value="${kmsIntegralTeamRank.fdMonth.fdDocRiches}" />
					</td>
					<td>
						<c:out value="${kmsIntegralTeamRank.fdMonth.fdOtherRiches}" />
					</td>
					<td>
						<c:out value="${kmsIntegralTeamRank.fdMonth.fdAvgRiches}" />
					</td>
				</c:if>
				<c:if test="${'year'==param.time}">
					<td>
						<c:out value="${kmsIntegralTeamRank.fdYear.fdTotalScore}" />
					</td>
					<td>
						<c:out value="${kmsIntegralTeamRank.fdYear.fdExpScore}" />
					</td>
					<td>
						<c:out value="${kmsIntegralTeamRank.fdYear.fdDocScore}" />
					</td>
					<td>
						<c:out value="${kmsIntegralTeamRank.fdYear.fdOtherScore}" />
					</td>
					<td>
						<c:out value="${kmsIntegralTeamRank.fdYear.fdAvgScore}" />
					</td>
					<td>
						<c:out value="${kmsIntegralTeamRank.fdYear.fdTotalRiches}" />
					</td>
					<td>
						<c:out value="${kmsIntegralTeamRank.fdYear.fdExpRiches}" />
					</td>
					<td>
						<c:out value="${kmsIntegralTeamRank.fdYear.fdDocRiches}" />
					</td>
					<td>
						<c:out value="${kmsIntegralTeamRank.fdYear.fdOtherRiches}" />
					</td>
					<td>
						<c:out value="${kmsIntegralTeamRank.fdYear.fdAvgRiches}" />
					</td>
				</c:if>
				<c:if test="${'all'==param.time}">
					<td>
						<c:out value="${kmsIntegralTeamRank.fdTotal.fdTotalScore}" />
					</td>
					<td>
						<c:out value="${kmsIntegralTeamRank.fdTotal.fdExpScore}" />
					</td>
					<td>
						<c:out value="${kmsIntegralTeamRank.fdTotal.fdDocScore}" />
					</td>
					<td>
						<c:out value="${kmsIntegralTeamRank.fdTotal.fdOtherScore}" />
					</td>
					<td>
						<c:out value="${kmsIntegralTeamRank.fdTotal.fdAvgScore}" />
					</td>
					<td>
						<c:out value="${kmsIntegralTeamRank.fdTotal.fdTotalRiches}" />
					</td>
					<td>
						<c:out value="${kmsIntegralTeamRank.fdTotal.fdExpRiches}" />
					</td>
					<td>
						<c:out value="${kmsIntegralTeamRank.fdTotal.fdDocRiches}" />
					</td>
					<td>
						<c:out value="${kmsIntegralTeamRank.fdTotal.fdOtherRiches}" />
					</td>
					<td>
						<c:out value="${kmsIntegralTeamRank.fdTotal.fdAvgRiches}" />
					</td>
				</c:if>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<script>
var s_path = encodeURIComponent('<bean:message key="table.kmsIntegralTeamRank" bundle="kms-integral" />');
function clickTime(obj){
	var score = $("input[type=radio][name=score][checked]").val();
	var url = "<c:url value='/kms/integral/kms_integral_team_rank/kmsIntegralTeamRank.do?method=list&s_path=' />"+s_path+"&time="+obj+"&score="+score ;
	window.location.href=url ;
}
function clickScore(obj){
	var time = $("input[type=radio][name=time][checked]").val();
	var url = "<c:url value='/kms/integral/kms_integral_team_rank/kmsIntegralTeamRank.do?method=list&s_path=' />"+s_path+"&time="+time+"&score="+obj ;
	window.location.href=url ;
}

function afterAddress(rtnVal){
	var fdCreatorId = document.getElementsByName("fdCreatorId")[0].value ;
	if(fdCreatorId.length > 32){
		document.getElementsByName("fdCreatorId")[0].value="" ;
		document.getElementsByName("fdCreatorName")[0].value="" ;
		alert('<bean:message bundle="kms-integral" key="kmsIntegralCommon.select.fdDept"/>');
		return false ;
	}
	var fdCreatorName = encodeURIComponent($("input[type=text][name=fdCreatorName]").val());
	var url = "<c:url value='/kms/integral/kms_integral_team_rank/kmsIntegralTeamRank.do?method=list&s_path=' />"+s_path+'&fdCreatorId='+fdCreatorId+"&fdCreatorName="+fdCreatorName+"&time=${param.time}&score=${param.score}" ;
	setTimeout('window.location.href="' + url + '";',100);
}
</script>
<%@ include file="/resource/jsp/list_down.jsp"%>
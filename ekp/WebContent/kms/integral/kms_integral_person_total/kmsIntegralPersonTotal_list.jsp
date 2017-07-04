<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/kms/integral/kms_integral_person_total/kmsIntegralPersonTotal.do"><br/>
<style>
.tab tr{line-height: 20px;}
.tab tr td{color:#797874;}
</style>
<table class="tab" style="width:100%;">
	<tr><td width="50px" align="right"><bean:message bundle="kms-integral" key="kmsIntegralCommon.isTime"/>: </td>
		<td width="80px" style="padding-left:10px;"><label for="week" style="cursor: pointer;"><input type="radio" name="time" <c:if test="${'week'==param.time||null==param.time||''==param.time}" >checked="checked"</c:if> value="week" onchange="clickTime('week');" id="week"><bean:message bundle="kms-integral" key="kmsIntegralCommon.fdWeek"/></label></td>
		<td	width="80px"><label for="month" style="cursor: pointer;"><input type="radio" name="time" value="month"  <c:if test="${'month'==param.time}" >checked="checked"</c:if> onchange="clickTime('month');" id="month"><bean:message bundle="kms-integral" key="kmsIntegralCommon.fdMonth"/></label></td>
		<td	width="80px"><label for="year" style="cursor: pointer;"><input type="radio" name="time" value="year" <c:if test="${'year'==param.time}">checked="checked"</c:if> onchange="clickTime('year');" id="year"><bean:message bundle="kms-integral" key="kmsIntegralCommon.fdYear"/></label></td>
		<td	width="80px"><label for="total" style="cursor: pointer;"><input type="radio" name="time" value="total" <c:if test="${'total'==param.time}">checked="checked"</c:if> onchange="clickTime('total');" id="total"><bean:message bundle="kms-integral" key="kmsIntegralCommon.fdTotal"/></label></td>
		<td colspan="5">&nbsp;</td>
	</tr>
	<tr><td align="right"><bean:message bundle="kms-integral" key="kmsIntegralCommon.isType"/>: </td>
		<td style="padding-left:10px;"><label for="fdTotalScore" style="cursor: pointer;"><input type="radio" name="score" <c:if test="${'fdTotalScore'==param.score||null==param.score||''==param.score}" >checked="checked"</c:if> value="fdTotalScore" onchange="clickScore('fdTotalScore');" id="fdTotalScore"><bean:message bundle="kms-integral" key="kmsIntegralCommon.fdTotalScore"/></label></td>
		<td><label for="fdExpScore" style="cursor: pointer;"><input type="radio" name="score" value="fdExpScore"  <c:if test="${'fdExpScore'==param.score}" >checked="checked"</c:if> onchange="clickScore('fdExpScore');" id="fdExpScore"><bean:message bundle="kms-integral" key="kmsIntegralCommon.fdExpScore"/></label></td>
		<td><label for="fdDocScore" style="cursor: pointer;"><input type="radio" style="cursor: pointer;" name="score" value="fdDocScore"  <c:if test="${'fdDocScore'==param.score}" >checked="checked"</c:if> onchange="clickScore('fdDocScore');" id="fdDocScore"><bean:message bundle="kms-integral" key="kmsIntegralCommon.fdDocScore"/></label></td>
		<td><label for="fdOtherScore" style="cursor: pointer;"><input type="radio" style="cursor: pointer;" name="score" value="fdOtherScore"  <c:if test="${'fdOtherScore'==param.score}" >checked="checked"</c:if> onchange="clickScore('fdOtherScore');" id="fdOtherScore"><bean:message bundle="kms-integral" key="kmsIntegralCommon.fdOtherScore"/></label></td>
		<td width="70px"><label for="fdTotalRiches" style="cursor: pointer;"><input type="radio" name="score" value="fdTotalRiches"  <c:if test="${'fdTotalRiches'==param.score}" >checked="checked"</c:if> onchange="clickScore('fdTotalRiches');" id="fdTotalRiches"><bean:message bundle="kms-integral" key="kmsIntegralCommon.fdTotalRiches"/></label></td>
		<td width="70px"><label for="fdExpRiches" style="cursor: pointer;"><input type="radio" name="score" value="fdExpRiches"  <c:if test="${'fdExpRiches'==param.score}" >checked="checked"</c:if> onchange="clickScore('fdExpRiches');" id="fdExpRiches"><bean:message bundle="kms-integral" key="kmsIntegralCommon.fdExpRiches"/></label></td>
		<td width="70px"><label for="fdDocRiches" style="cursor: pointer;"><input type="radio" name="score" value="fdDocRiches"  <c:if test="${'fdDocRiches'==param.score}" >checked="checked"</c:if> onchange="clickScore('fdDocRiches');" id="fdDocRiches"><bean:message bundle="kms-integral" key="kmsIntegralCommon.fdDocRiches"/></label></td>
		<td width="70px"><label for="fdOtherRiches" style="cursor: pointer;"><input type="radio" name="score" value="fdOtherRiches"  <c:if test="${'fdOtherRiches'==param.score}" >checked="checked"</c:if> onchange="clickScore('fdOtherRiches');" id="fdOtherRiches"><bean:message bundle="kms-integral" key="kmsIntegralCommon.fdOtherRiches"/></label></td>
		<td colspan="1">&nbsp;</td>
	</tr>
	<tr>
		<td width="50px" align="right"><bean:message bundle="kms-integral" key="kmsIntegralCommon.isDept"/>: </td>
		<td align="left" colspan="9">
				<html:hidden  property="fdPersonId"/><html:text property="fdPersonName" style="width:150px;cursor: pointer;" readonly="true" styleClass="inputsgl" 
				onclick="Dialog_Address(true, 'fdPersonId', 'fdPersonName', ';', ORG_TYPE_DEPT,afterAddress);"/>
				<a href="#" onclick="Dialog_Address(true, 'fdPersonId', 'fdPersonName', ';', ORG_TYPE_DEPT,afterAddress);">
					<bean:message key="dialog.selectOrg"/>
				</a>
		    	<c:if test="${'' == kmsIntegralPersonTotalForm.fdPersonId || null == kmsIntegralPersonTotalForm.fdPersonId || 'person'!=flag }">
					<input type="checkbox" name="person" disabled="disabled"><bean:message bundle="kms-integral" key="kmsIntegralAlter.fdStatus.false"/>
				</c:if>
				<c:if test="${'' != kmsIntegralPersonTotalForm.fdPersonId && null != kmsIntegralPersonTotalForm.fdPersonId && 'person'==flag}">
					<input type="checkbox" name="person"  checked="checked" disabled="disabled"><bean:message bundle="kms-integral" key="kmsIntegralAlter.fdStatus.true"/>
				</c:if> 	
		</td>
	</tr>
	<tr>
		<td align="right"><bean:message bundle="kms-integral" key="kmsIntegralCommon.isRole"/>: </td>
		<td colspan="5" style="padding-left:10px;">
			<input type="hidden" name="roleId" value="${param.roleId}"/>
			<html:text property="roleName" style="width:150px;cursor: pointer;" readonly="true" styleClass="inputsgl" onclick="clickRole();" value="${param.roleName}"/>
			<a href="javascript:void(0)"  onclick="Dialog_Tree(false,'roleId','roleName',null,'kmsIntegralRoleTree','<bean:message  bundle="kms-integral" key="kmsIntegralCommon.personRole" />',null,updateRole,null,null,null,'<bean:message bundle="kms-integral" key="kmsIntegralCommon.role.select" />');">
		    <bean:message key="button.select" /></a> 
			<c:if test="${'' == kmsIntegralPersonTotalForm.roleId || null == kmsIntegralPersonTotalForm.roleId || 'role'!=flag}">
				<input type="checkbox" name="role" disabled="disabled"><bean:message bundle="kms-integral" key="kmsIntegralAlter.fdStatus.false"/>
			</c:if>
			<c:if test="${'' != kmsIntegralPersonTotalForm.roleId && null != kmsIntegralPersonTotalForm.roleId && 'role'==flag}">
				<input type="checkbox" name="role" checked="checked" disabled="disabled"><bean:message bundle="kms-integral" key="kmsIntegralAlter.fdStatus.true"/>
			</c:if>
		</td>
	</tr>
	<%/** 
	<tr>
		<td align="right"><bean:message bundle="kms-integral" key="kmsIntegralCommon.isTeam"/>: </td>
		<td colspan="5" style="padding-left:10px;">
			<input type="hidden" name="teamId" value="${param.teamId}"/>
			<html:text property="teamName" style="width:150px;cursor: pointer;" readonly="true" styleClass="inputsgl" onclick="clickTeam();" value="${param.teamName}"/>
			<a href="javascript:void(0)"  onclick="Dialog_Tree(false,'teamId','teamName',null,'kmsIntegralTeamTree','<bean:message  bundle="kms-integral" key="kmsIntegralRule.fdCategory" />',null,updateNotice,null,null,null,'<bean:message bundle="kms-integral" key="kmsIntegralCommon.team.select" />');">
		    <bean:message key="button.select" /></a> 
			<c:if test="${'' == kmsIntegralPersonTotalForm.teamId || null == kmsIntegralPersonTotalForm.teamId || 'team'!=flag}">
				<input type="checkbox" name="team" disabled="disabled"><bean:message bundle="kms-integral" key="kmsIntegralAlter.fdStatus.false"/>
			</c:if>
			<c:if test="${'' != kmsIntegralPersonTotalForm.teamId && null != kmsIntegralPersonTotalForm.teamId && 'team'==flag}">
				<input type="checkbox" name="team" checked="checked" disabled="disabled"><bean:message bundle="kms-integral" key="kmsIntegralAlter.fdStatus.true"/>
			</c:if>
		</td>
	</tr> */ %>
	<tr>
		<td align="left" colspan="6" style="padding-left:10px;"><bean:message bundle="kms-integral" key="kmsIntegralCommon.lastUpdateTime"/>: &nbsp;&nbsp;${fdLastTime}</td>
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
				<td width="10pt">
					<input type="checkbox" name="List_Tongle">
				</td>
				<td width="40pt">
					<bean:message key="page.serial"/>
				</td>
				<td>
					<bean:message bundle="kms-integral" key="kmsIntegralCommon.name"/>
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
		<!-- 	<td>
					<bean:message bundle="kms-integral" key="kmsIntegralCommon.fdUsedScore"/>
				</td>  -->	
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
			<!-- 	<td>
					<bean:message bundle="kms-integral" key="kmsIntegralCommon.fdUsedRiches"/>
				</td>  -->	
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsIntegralPersonTotal" varStatus="vstatus">
			<tr>
				<td>
					<input type="checkbox" name="List_Selected" value="${kmsIntegralPersonTotal.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmsIntegralPersonTotal.fdPerson.fdName}" />
				</td>
				<c:if test="${'week'==param.time ||  '' ==param.time || null ==param.time}">
				<td>
					<c:out value="${kmsIntegralPersonTotal.fdWeek.fdTotalScore}" />
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResultView('fdExpScore','${kmsIntegralPersonTotal.fdPerson.fdId}','week','${kmsIntegralPersonTotal.fdPerson.fdName}');">
						<c:out value="${kmsIntegralPersonTotal.fdWeek.fdExpScore}" />
					</a>
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResultView('fdDocScore','${kmsIntegralPersonTotal.fdPerson.fdId}','week','${kmsIntegralPersonTotal.fdPerson.fdName}');">
						<c:out value="${kmsIntegralPersonTotal.fdWeek.fdDocScore}" />
					</a>
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResultView('fdOtherScore','${kmsIntegralPersonTotal.fdPerson.fdId}','week','${kmsIntegralPersonTotal.fdPerson.fdName}');">
					<c:out value="${kmsIntegralPersonTotal.fdWeek.fdOtherScore}" />
					</a>
				</td>
			<!-- 	<td>
					<c:out value="${kmsIntegralPersonTotal.fdWeek.fdUsedScore}" />  
				</td> -->	
				<td>
					<c:out value="${kmsIntegralPersonTotal.fdWeek.fdTotalRiches}" />
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResultView('fdExpRiches','${kmsIntegralPersonTotal.fdPerson.fdId}','week','${kmsIntegralPersonTotal.fdPerson.fdName}');">
					<c:out value="${kmsIntegralPersonTotal.fdWeek.fdExpRiches}" />
					</a>
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResultView('fdDocRiches','${kmsIntegralPersonTotal.fdPerson.fdId}','week','${kmsIntegralPersonTotal.fdPerson.fdName}');">
					<c:out value="${kmsIntegralPersonTotal.fdWeek.fdDocRiches}" />
					</a>
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResultView('fdOtherRiches','${kmsIntegralPersonTotal.fdPerson.fdId}','week','${kmsIntegralPersonTotal.fdPerson.fdName}');">
					<c:out value="${kmsIntegralPersonTotal.fdWeek.fdOtherRiches}" />
					</a>
				</td>
			<!-- 	<td>
					<c:out value="${kmsIntegralPersonTotal.fdWeek.fdUsedRiches}" />
				</td> -->	
			</c:if>
			
			<c:if test="${'month'==param.time}">
				<td>
					<c:out value="${kmsIntegralPersonTotal.fdMonth.fdTotalScore}" />
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResultView('fdExpScore','${kmsIntegralPersonTotal.fdPerson.fdId}','month','${kmsIntegralPersonTotal.fdPerson.fdName}');">
						<c:out value="${kmsIntegralPersonTotal.fdMonth.fdExpScore}" />
					</a>
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResultView('fdDocScore','${kmsIntegralPersonTotal.fdPerson.fdId}','month','${kmsIntegralPersonTotal.fdPerson.fdName}');">
						<c:out value="${kmsIntegralPersonTotal.fdMonth.fdDocScore}" />
					</a>
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResultView('fdOtherScore','${kmsIntegralPersonTotal.fdPerson.fdId}','month','${kmsIntegralPersonTotal.fdPerson.fdName}');">
					<c:out value="${kmsIntegralPersonTotal.fdMonth.fdOtherScore}" />
					</a>
				</td>
			<!-- 	<td>
					<c:out value="${kmsIntegralPersonTotal.fdMonth.fdUsedScore}" />  
				</td> -->	
				<td>
					<c:out value="${kmsIntegralPersonTotal.fdMonth.fdTotalRiches}" />
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResultView('fdExpRiches','${kmsIntegralPersonTotal.fdPerson.fdId}','month','${kmsIntegralPersonTotal.fdPerson.fdName}');">
					<c:out value="${kmsIntegralPersonTotal.fdMonth.fdExpRiches}" />
					</a>
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResultView('fdDocRiches','${kmsIntegralPersonTotal.fdPerson.fdId}','month','${kmsIntegralPersonTotal.fdPerson.fdName}');">
					<c:out value="${kmsIntegralPersonTotal.fdMonth.fdDocRiches}" />
					</a>
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResultView('fdOtherRiches','${kmsIntegralPersonTotal.fdPerson.fdId}','month','${kmsIntegralPersonTotal.fdPerson.fdName}');">
					<c:out value="${kmsIntegralPersonTotal.fdMonth.fdOtherRiches}" />
					</a>
				</td>
			<!-- 	<td>
					<c:out value="${kmsIntegralPersonTotal.fdMonth.fdUsedRiches}" />
				</td> -->	
			</c:if>
			
			<c:if test="${'year'==param.time}">
				<td>
					<c:out value="${kmsIntegralPersonTotal.fdYear.fdTotalScore}" />
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResultView('fdExpScore','${kmsIntegralPersonTotal.fdPerson.fdId}','year','${kmsIntegralPersonTotal.fdPerson.fdName}');">
						<c:out value="${kmsIntegralPersonTotal.fdYear.fdExpScore}" />
					</a>
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResultView('fdDocScore','${kmsIntegralPersonTotal.fdPerson.fdId}','year','${kmsIntegralPersonTotal.fdPerson.fdName}');">
						<c:out value="${kmsIntegralPersonTotal.fdYear.fdDocScore}" />
					</a>
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResultView('fdOtherScore','${kmsIntegralPersonTotal.fdPerson.fdId}','year','${kmsIntegralPersonTotal.fdPerson.fdName}');">
					<c:out value="${kmsIntegralPersonTotal.fdYear.fdOtherScore}" />
					</a>
				</td>
			<!-- 	<td>
					<c:out value="${kmsIntegralPersonTotal.fdYear.fdUsedScore}" />  
				</td> -->	
				<td>
					<c:out value="${kmsIntegralPersonTotal.fdYear.fdTotalRiches}" />
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResultView('fdExpRiches','${kmsIntegralPersonTotal.fdPerson.fdId}','year','${kmsIntegralPersonTotal.fdPerson.fdName}');">
					<c:out value="${kmsIntegralPersonTotal.fdYear.fdExpRiches}" />
					</a>
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResultView('fdDocRiches','${kmsIntegralPersonTotal.fdPerson.fdId}','year','${kmsIntegralPersonTotal.fdPerson.fdName}');">
					<c:out value="${kmsIntegralPersonTotal.fdYear.fdDocRiches}" />
					</a>
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResultView('fdOtherRiches','${kmsIntegralPersonTotal.fdPerson.fdId}','year','${kmsIntegralPersonTotal.fdPerson.fdName}');">
					<c:out value="${kmsIntegralPersonTotal.fdYear.fdOtherRiches}" />
					</a>
				</td>
			<!-- 	<td>
					<c:out value="${kmsIntegralPersonTotal.fdYear.fdUsedRiches}" />
				</td> -->	
			</c:if>
			
			<c:if test="${'total'==param.time}">
				<td>
					<c:out value="${kmsIntegralPersonTotal.fdTotal.fdTotalScore}" />
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResultView('fdExpScore','${kmsIntegralPersonTotal.fdPerson.fdId}','total','${kmsIntegralPersonTotal.fdPerson.fdName}');">
						<c:out value="${kmsIntegralPersonTotal.fdTotal.fdExpScore}" />
					</a>
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResultView('fdDocScore','${kmsIntegralPersonTotal.fdPerson.fdId}','total','${kmsIntegralPersonTotal.fdPerson.fdName}');">
						<c:out value="${kmsIntegralPersonTotal.fdTotal.fdDocScore}" />
					</a>
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResultView('fdOtherScore','${kmsIntegralPersonTotal.fdPerson.fdId}','total','${kmsIntegralPersonTotal.fdPerson.fdName}');">
					<c:out value="${kmsIntegralPersonTotal.fdTotal.fdOtherScore}" />
					</a>
				</td>
			<!-- 	<td>
					<c:out value="${kmsIntegralPersonTotal.fdTotal.fdUsedScore}" />  
				</td> -->	
				<td>
					<c:out value="${kmsIntegralPersonTotal.fdTotal.fdTotalRiches}" />
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResultView('fdExpRiches','${kmsIntegralPersonTotal.fdPerson.fdId}','total','${kmsIntegralPersonTotal.fdPerson.fdName}');">
					<c:out value="${kmsIntegralPersonTotal.fdTotal.fdExpRiches}" />
					</a>
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResultView('fdDocRiches','${kmsIntegralPersonTotal.fdPerson.fdId}','total','${kmsIntegralPersonTotal.fdPerson.fdName}');">
					<c:out value="${kmsIntegralPersonTotal.fdTotal.fdDocRiches}" />
					</a>
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResultView('fdOtherRiches','${kmsIntegralPersonTotal.fdPerson.fdId}','total','${kmsIntegralPersonTotal.fdPerson.fdName}');">
					<c:out value="${kmsIntegralPersonTotal.fdTotal.fdOtherRiches}" />
					</a>
				</td>
			<!-- 	<td>
					<c:out value="${kmsIntegralPersonTotal.fdTotal.fdUsedRiches}" />
				</td> -->	
			</c:if>
				
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
<input type="hidden" name="flag" value="${param.flag }"/>
</html:form>
<script>
var s_path = encodeURIComponent('<bean:message key="table.kmsIntegralPersonTotal" bundle="kms-integral" />');
function clickTime(obj){
	var score = $("input[type=radio][name=score][checked]").val();
	var url = "<c:url value='/kms/integral/kms_integral_person_total/kmsIntegralPersonTotal.do?method=list&s_path=' />"+s_path+"&time="+obj+"&score="+score ;
	createUrl(url) ;
}
function clickScore(obj){
	var time = $("input[type=radio][name=time][checked]").val();
	var url = "<c:url value='/kms/integral/kms_integral_person_total/kmsIntegralPersonTotal.do?method=list&s_path=' />"+s_path+"&time="+time+"&score="+obj ;
	createUrl(url) ;
	//Com_Submit(document.kmsEvaluateDocDetailForm, 'list');
}
//function clickTeam(){
//	Dialog_Tree(false,'teamId','teamName',null,'kmsIntegralTeamTree','<bean:message  bundle="kms-integral" key="kmsIntegralRule.fdCategory" />',null,updateNotice,null,null,null,'<bean:message bundle="kms-integral" key="kmsIntegralCommon.team.select" />')
//}

function clickRole(){
	Dialog_Tree(false,'roleId','roleName',null,'kmsIntegralRoleTree','<bean:message  bundle="kms-integral" key="kmsIntegralRule.fdCategory" />',null,updateRole,null,null,null,'<bean:message bundle="kms-integral" key="kmsIntegralCommon.team.select" />')
}

function createUrl(url){
	//var teamId = $("input[type=hidden][name=teamId]").val();
	//if(teamId!=null && teamId.length>30){
	////	var teamName = encodeURIComponent($("input[type=text][name=teamName]").val());
	//	url += "&teamId="+teamId+"&teamName="+teamName ;
	//}
	var fdPersonId = $("input[type=hidden][name=fdPersonId]").val();
	if(fdPersonId!=null && fdPersonId.length>30){
		var fdPersonName = encodeURIComponent($("input[type=text][name=fdPersonName]").val());
		url += "&fdPersonId="+fdPersonId+"&fdPersonName="+fdPersonName ;
	}
	var roleId = $("input[type=hidden][name=roleId]").val();
	if(roleId!=null && roleId.length>30){
		var roleName = encodeURIComponent($("input[type=text][name=roleName]").val());
		url += "&roleId="+roleId+"&roleName="+roleName ;
	}
	var flag = document.getElementsByName("flag")[0].value;
	url += "&flag="+flag ;
	window.location.href=url ;
}

Com_IncludeFile("dialog.js|plugin.js");
function afterAddress(rtnVal){
	var fdPersonId = document.getElementsByName("fdPersonId")[0].value ;
	if(fdPersonId.length > 32){
		document.getElementsByName("fdPersonId")[0].value="" ;
		document.getElementsByName("fdPersonName")[0].value="" ;
		alert('<bean:message bundle="kms-integral" key="kmsIntegralCommon.select.fdDept"/>');
		return false ;
	}
	var fdPersonName = encodeURIComponent($("input[type=text][name=fdPersonName]").val());
	var flag = document.getElementsByName("flag")[0];
	flag.value = "person";
	//Com_Submit(document.kmsIntegralPersonTotalForm, 'list');
	var url = "<c:url value='/kms/integral/kms_integral_person_total/kmsIntegralPersonTotal.do?method=list&s_path=' />"+s_path+'&fdPersonId='+fdPersonId+"&fdPersonName="+fdPersonName+"&time=${param.time}&score=${param.score}&flag=person" ;
	setTimeout('window.location.href="' + url + '";',100);
}

function gotoResultView(scoreType,operatorId,time,fdPersonName){
	var fdPersonName = encodeURIComponent(fdPersonName);
	var url = "<c:url value='/kms/integral/kms_integral_person_total/kmsIntegralPersonTotal.do?method=gotoResultView&time=' />"+time;
	if(null != scoreType){
		url += "&scoreType="+scoreType ;
	}
	if(null != operatorId){
		url += "&operatorId="+operatorId +"&fdPersonName="+fdPersonName;
	}
	window.open(url) ;
}

function updateRole(val){
	var roleId = document.getElementsByName("roleId")[0].value ;
	if(roleId.length > 31){
		var roleName = encodeURIComponent($("input[type=text][name=roleName]").val());
		var flag = document.getElementsByName("flag")[0];
		flag.value = "role";
		var url = "<c:url value='/kms/integral/kms_integral_person_total/kmsIntegralPersonTotal.do?method=list&s_path=' />"+s_path+'&roleId='+roleId+"&roleName="+roleName+"&time=${param.time}&score=${param.score}&flag=role" ;
		setTimeout('window.location.href="' + url + '";',100);
	}
}

//function updateNotice(val){
//	var teamId = document.getElementsByName("teamId")[0].value ;
//	if(teamId.length > 31){
//		var teamName = encodeURIComponent($("input[type=text][name=teamName]").val());
//		var flag = document.getElementsByName("flag")[0];
//		flag.value = "team";
//		var url = "<c:url value='/kms/integral/kms_integral_person_total/kmsIntegralPersonTotal.do?method=list&s_path=' />"+s_path+'&teamId='+teamId+"&teamName="+teamName+"&time=${param.time}&score=${param.score}&flag=team" ;
//		setTimeout('window.location.href="' + url + '";',100);
//	}
	//Com_Submit(document.kmsIntegralPersonTotalForm, 'list');
//}
</script>
<%@ include file="/resource/jsp/list_down.jsp"%>
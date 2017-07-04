<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
if(request.getAttribute("LUI_ContextPath")==null){
	String LUI_ContextPath = request.getContextPath();
	request.setAttribute("LUI_ContextPath", LUI_ContextPath);
	request.setAttribute("LUI_CurrentTheme",SysUiPluginUtil.getThemeById("default"));
	request.setAttribute("LUI_Cache",ResourceCacheFilter.cache);
	request.setAttribute("KMSS_Parameter_Style", "default");
	request.setAttribute("KMSS_Parameter_ContextPath", LUI_ContextPath+"/");
	request.setAttribute("KMSS_Parameter_ResPath", LUI_ContextPath+"/resource/");
	request.setAttribute("KMSS_Parameter_StylePath", LUI_ContextPath+"/resource/style/default/");
	request.setAttribute("KMSS_Parameter_CurrentUserId", UserUtil.getKMSSUser(request).getUserId());
	request.setAttribute("KMSS_Parameter_Lang", UserUtil.getKMSSUser(request).getLocale().toString().toLowerCase().replace('_', '-'));
}
%>
<%@ include file="/sys/ui/jsp/jshead.jsp"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<%@ include file="/kms/evaluate/resource/jsp/kmsEvaluateGotoResult_js.jsp"%>
<html:form action="/kms/evaluate/kms_evaluate_personal_detail/kmsEvaluatePersonalDetail.do?method=list">
<br/>
<style>
.tab tr{line-height: 20px;}
.tab tr td{color:#797874;}
</style>
<script>
function clickTime(obj){
	var s_path = encodeURIComponent('个人知识应用');
	var url = Com_SetUrlParameter(location.href, "time", obj);
	window.location.href=url;
}
function afterAddress(rtnVal){
	var fdCreatorId = document.getElementsByName("fdCreatorId")[0].value;
	var fdCreatorName = document.getElementsByName("fdCreatorName")[0].value;
	var url = Com_SetUrlParameter(window.location.href, "fdCreatorId", fdCreatorId);
	url = Com_SetUrlParameter(url, "fdCreatorName", fdCreatorName);
	that._commit(url);
}
var that = this;
function _commit(url){
	setTimeout('window.location.href="' + url + '";',100);
}
</script>
<script>
Com_IncludeFile("dialog.js|plugin.js");
</script>
<div id="optBarDiv">
	<c:if test="${param.method != 'result'}">
		<input type="button" value="<bean:message key="button.search"/>"
			onclick="Com_OpenWindow('<c:url value="/sys/search/search.do?method=condition&fdModelName=com.landray.kmss.kms.evaluate.model.KmsEvaluatePersonalDetail&time=week" />','_blank');">
	</c:if>
	<c:if test="${param.method == 'result'}">
		<input type="button"
			value="<bean:message key="button.close"/>"
			onclick="Com_CloseWindow();">
	</c:if>	
</div>
<table class="tab" style="width:300px;float:left;">
	<tr><td width="12%" align="right">周期: </td>
		<td width="8%" style="padding-left:10px;"><input type="radio" style="cursor: pointer;" name="time" <c:if test="${'week'==param.time||null==param.time||''==param.time}" >checked="checked"</c:if> value="week" onchange="clickTime('week');" id="week"><label for="week">本周</label></td>
		<td	width="8%"><input type="radio" style="cursor: pointer;" name="time" value="month"  <c:if test="${'month'==param.time}" >checked="checked"</c:if> onchange="clickTime('month');" id="month"><label for="month">本月</label></td>
		<td	width="8%"><input type="radio" style="cursor: pointer;" name="time" value="year" <c:if test="${'year'==param.time}">checked="checked"</c:if> onchange="clickTime('year');" id="year"><label for="year">本年</label></td>
		<td	width="8%"><input type="radio" style="cursor: pointer;" name="time" value="all" <c:if test="${'all'==param.time}">checked="checked"</c:if> onchange="clickTime('all');" id="all"><label for="all">累计</label></td>
	</tr>
	<tr><td width="12%" align="right">按部门: </td>
		<td width="8%" style="padding-left:10px;" colspan="4">
			<html:hidden  property="fdCreatorId" value="${param.fdCreatorId}"/>
			<html:text property="fdCreatorName" value="${param.fdCreatorName}" style="width:150px;cursor: pointer;" readonly="true" styleClass="inputsgl" 
				onclick="Dialog_Address(true, 'fdCreatorId', 'fdCreatorName', ';', ORG_TYPE_DEPT,afterAddress);"/>
			<a href="#" onclick="Dialog_Address(true, 'fdCreatorId', 'fdCreatorName', ';', ORG_TYPE_DEPT,afterAddress);">
				<bean:message key="dialog.selectOrg"/>
			</a>
		</td>
	</tr>
</table>	
<span style="height:18px;float:right;" class=txtlistpath>
	<bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.lastUpdateTime"/>：${lastUpdateTime}
</span>	
<c:if test="${queryPage.totalrows==0}">
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
</c:if>
<c:if test="${queryPage.totalrows>0}">
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt">
					<input type="checkbox" name="List_Tongle">
				</td>
				<td width="40pt">
					<bean:message key="page.serial"/>
				</td>
				<sunbor:column property="kmsEvaluatePersonalDetail.fdCreator.fdName">
					<bean:message key="model.fdCreator"/>
				</sunbor:column>
				<td>
					<bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.personal.fdDept"/>
				</td>
				<c:if test="${'week'==param.time ||  '' ==param.time || null ==param.time}">
					<sunbor:column property="kmsEvaluatePersonalDetail.docWeekCount.docAddCount">
						<bean:message bundle="kms-evaluate" key="kmsEvaluatePersonalRank.docAddCount"/>
					</sunbor:column>
					<sunbor:column property="kmsEvaluatePersonalDetail.docWeekCount.docUpdateCount">
						<bean:message bundle="kms-evaluate" key="kmsEvaluatePersonalRank.docUpdateCount"/>
					</sunbor:column>
					<sunbor:column property="kmsEvaluatePersonalDetail.docWeekCount.docDeleteCount">
						<bean:message bundle="kms-evaluate" key="kmsEvaluatePersonalRank.docDeleteCount"/>
					</sunbor:column>
					<sunbor:column property="kmsEvaluatePersonalDetail.docWeekCount.docReadCount">
						<bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docReadCountNumber"/>
					</sunbor:column>
					<sunbor:column property="kmsEvaluatePersonalDetail.docWeekCount.docIntroduceCount">
						<bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docIntroduceCountNumber"/>
					</sunbor:column>
					<sunbor:column property="kmsEvaluatePersonalDetail.docWeekCount.docEvaluationCount">
						<bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docEvaluationCountNumber"/>
					</sunbor:column>
				</c:if>
				
				<c:if test="${'month'==param.time}">
					<sunbor:column property="kmsEvaluatePersonalDetail.docMonthCount.docAddCount">
						<bean:message bundle="kms-evaluate" key="kmsEvaluatePersonalRank.docAddCount"/>
					</sunbor:column>
					<sunbor:column property="kmsEvaluatePersonalDetail.docMonthCount.docUpdateCount">
						<bean:message bundle="kms-evaluate" key="kmsEvaluatePersonalRank.docUpdateCount"/>
					</sunbor:column>
					<sunbor:column property="kmsEvaluatePersonalDetail.docMonthCount.docDeleteCount">
						<bean:message bundle="kms-evaluate" key="kmsEvaluatePersonalRank.docDeleteCount"/>
					</sunbor:column>
					<sunbor:column property="kmsEvaluatePersonalDetail.docMonthCount.docReadCount">
						<bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docReadCountNumber"/>
					</sunbor:column>
					<sunbor:column property="kmsEvaluatePersonalDetail.docMonthCount.docIntroduceCount">
						<bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docIntroduceCountNumber"/>
					</sunbor:column>
					<sunbor:column property="kmsEvaluatePersonalDetail.docMonthCount.docEvaluationCount">
						<bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docEvaluationCountNumber"/>
					</sunbor:column>
				</c:if>
				<c:if test="${'year'==param.time}">
					<sunbor:column property="kmsEvaluatePersonalDetail.docYearCount.docAddCount">
						<bean:message bundle="kms-evaluate" key="kmsEvaluatePersonalRank.docAddCount"/>
					</sunbor:column>
					<sunbor:column property="kmsEvaluatePersonalDetail.docYearCount.docUpdateCount">
						<bean:message bundle="kms-evaluate" key="kmsEvaluatePersonalRank.docUpdateCount"/>
					</sunbor:column>
					<sunbor:column property="kmsEvaluatePersonalDetail.docYearCount.docDeleteCount">
						<bean:message bundle="kms-evaluate" key="kmsEvaluatePersonalRank.docDeleteCount"/>
					</sunbor:column>
					<sunbor:column property="kmsEvaluatePersonalDetail.docYearCount.docReadCount">
						<bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docReadCountNumber"/>
					</sunbor:column>
					<sunbor:column property="kmsEvaluatePersonalDetail.docYearCount.docIntroduceCount">
						<bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docIntroduceCountNumber"/>
					</sunbor:column>
					<sunbor:column property="kmsEvaluatePersonalDetail.docYearCount.docEvaluationCount">
						<bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docEvaluationCountNumber"/>
					</sunbor:column>
				</c:if>
				<c:if test="${'all'==param.time}">
					<sunbor:column property="kmsEvaluatePersonalDetail.docCumulativeCount.docAddCount">
						<bean:message bundle="kms-evaluate" key="kmsEvaluatePersonalRank.docAddCount"/>
					</sunbor:column>
					<sunbor:column property="kmsEvaluatePersonalDetail.docCumulativeCount.docUpdateCount">
						<bean:message bundle="kms-evaluate" key="kmsEvaluatePersonalRank.docUpdateCount"/>
					</sunbor:column>
					<sunbor:column property="kmsEvaluatePersonalDetail.docCumulativeCount.docDeleteCount">
						<bean:message bundle="kms-evaluate" key="kmsEvaluatePersonalRank.docDeleteCount"/>
					</sunbor:column>
					<sunbor:column property="kmsEvaluatePersonalDetail.docCumulativeCount.docReadCount">
						<bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docReadCountNumber"/>
					</sunbor:column>
					<sunbor:column property="kmsEvaluatePersonalDetail.docCumulativeCount.docIntroduceCount">
						<bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docIntroduceCountNumber"/>
					</sunbor:column>
					<sunbor:column property="kmsEvaluatePersonalDetail.docCumulativeCount.docEvaluationCount">
						<bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docEvaluationCountNumber"/>
					</sunbor:column>
				</c:if>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsEvaluatePersonalDetail" varStatus="vstatus">
			<tr>
				<td>
					<input type="checkbox" name="List_Selected" value="${kmsEvaluatePersonalDetail.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmsEvaluatePersonalDetail.fdCreator.fdName}" />
				</td>
				<td>
					<c:out value="${kmsEvaluatePersonalDetail.fdCreator.fdParent.fdName}" />
				</td>
				
				<c:if test="${'week'==param.time ||  '' ==param.time || null ==param.time}">
				<td>
					<a style="cursor: pointer;" onclick="gotoResult('add','${kmsEvaluatePersonalDetail.fdCreator.fdId}')">
						<c:out value="${kmsEvaluatePersonalDetail.docWeekCount.docAddCount}" />
					</a>
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResult('update','${kmsEvaluatePersonalDetail.fdCreator.fdId}')">
						<c:out value="${kmsEvaluatePersonalDetail.docWeekCount.docUpdateCount}" />
					</a>
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResult('delete','${kmsEvaluatePersonalDetail.fdCreator.fdId}')">
						<c:out value="${kmsEvaluatePersonalDetail.docWeekCount.docDeleteCount}" />
					</a>
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResult('read','${kmsEvaluatePersonalDetail.fdCreator.fdId}')">
						<c:out value="${kmsEvaluatePersonalDetail.docWeekCount.docReadCount}" />
					</a>
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResult('introduce','${kmsEvaluatePersonalDetail.fdCreator.fdId}')">
						<c:out value="${kmsEvaluatePersonalDetail.docWeekCount.docIntroduceCount}" />
					</a>
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResult('evaluation','${kmsEvaluatePersonalDetail.fdCreator.fdId}')">
						<c:out value="${kmsEvaluatePersonalDetail.docWeekCount.docEvaluationCount}" />
					</a>
				</td>
				</c:if>
				
				<c:if test="${'month'==param.time}">
				<td>
					<a style="cursor: pointer;" onclick="gotoResult('add','${kmsEvaluatePersonalDetail.fdCreator.fdId}')">
						<c:out value="${kmsEvaluatePersonalDetail.docMonthCount.docAddCount}" />
					</a>
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResult('update','${kmsEvaluatePersonalDetail.fdCreator.fdId}')">
						<c:out value="${kmsEvaluatePersonalDetail.docMonthCount.docUpdateCount}" />
					</a>
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResult('delete','${kmsEvaluatePersonalDetail.fdCreator.fdId}')">
						<c:out value="${kmsEvaluatePersonalDetail.docMonthCount.docDeleteCount}" />
					</a>
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResult('read','${kmsEvaluatePersonalDetail.fdCreator.fdId}')">
						<c:out value="${kmsEvaluatePersonalDetail.docMonthCount.docReadCount}" />
					</a>
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResult('introduce','${kmsEvaluatePersonalDetail.fdCreator.fdId}')">
						<c:out value="${kmsEvaluatePersonalDetail.docMonthCount.docIntroduceCount}" />
					</a>
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResult('evaluation','${kmsEvaluatePersonalDetail.fdCreator.fdId}')">
						<c:out value="${kmsEvaluatePersonalDetail.docMonthCount.docEvaluationCount}" />
					</a>
				</td>
				</c:if>
				
				<c:if test="${'year'==param.time}">
				<td>
					<a style="cursor: pointer;" onclick="gotoResult('add','${kmsEvaluatePersonalDetail.fdCreator.fdId}')">
						<c:out value="${kmsEvaluatePersonalDetail.docYearCount.docAddCount}" />
					</a>
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResult('update','${kmsEvaluatePersonalDetail.fdCreator.fdId}')">
						<c:out value="${kmsEvaluatePersonalDetail.docYearCount.docUpdateCount}" />
					</a>
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResult('delete','${kmsEvaluatePersonalDetail.fdCreator.fdId}')">
						<c:out value="${kmsEvaluatePersonalDetail.docYearCount.docDeleteCount}" />
					</a>
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResult('read','${kmsEvaluatePersonalDetail.fdCreator.fdId}')">
						<c:out value="${kmsEvaluatePersonalDetail.docYearCount.docReadCount}" />
					</a>
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResult('introduce','${kmsEvaluatePersonalDetail.fdCreator.fdId}')">
						<c:out value="${kmsEvaluatePersonalDetail.docYearCount.docIntroduceCount}" />
					</a>
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResult('evaluation','${kmsEvaluatePersonalDetail.fdCreator.fdId}')">
						<c:out value="${kmsEvaluatePersonalDetail.docYearCount.docEvaluationCount}" />
					</a>
				</td>
				</c:if>
				
				<c:if test="${'all'==param.time}">
				<td>
					<a style="cursor: pointer;" onclick="gotoResult('add','${kmsEvaluatePersonalDetail.fdCreator.fdId}')">
						<c:out value="${kmsEvaluatePersonalDetail.docCumulativeCount.docAddCount}" />
					</a>
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResult('update','${kmsEvaluatePersonalDetail.fdCreator.fdId}')">
						<c:out value="${kmsEvaluatePersonalDetail.docCumulativeCount.docUpdateCount}" />
					</a>
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResult('delete','${kmsEvaluatePersonalDetail.fdCreator.fdId}')">
						<c:out value="${kmsEvaluatePersonalDetail.docCumulativeCount.docDeleteCount}" />
					</a>
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResult('read','${kmsEvaluatePersonalDetail.fdCreator.fdId}')">
						<c:out value="${kmsEvaluatePersonalDetail.docCumulativeCount.docReadCount}" />
					</a>
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResult('introduce','${kmsEvaluatePersonalDetail.fdCreator.fdId}')">
						<c:out value="${kmsEvaluatePersonalDetail.docCumulativeCount.docIntroduceCount}" />
					</a>
				</td>
				<td>
					<a style="cursor: pointer;" onclick="gotoResult('evaluation','${kmsEvaluatePersonalDetail.fdCreator.fdId}')">
						<c:out value="${kmsEvaluatePersonalDetail.docCumulativeCount.docEvaluationCount}" />
					</a>
				</td>
				</c:if>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<script>
function gotoResult(method,operate){
	gotoResultView(method,'doc','0','','','${startTime}','${endTime}',operate,null,null,null,true);
}
</script>
<%@ include file="/resource/jsp/list_down.jsp"%>
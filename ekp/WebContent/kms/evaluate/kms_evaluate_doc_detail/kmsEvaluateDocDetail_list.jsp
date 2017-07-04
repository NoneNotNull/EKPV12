<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@page import="java.util.List"%>
<template:include ref="default.simple">
	<template:replace name="head"> <template:super/>
		<script type="text/javascript" src="${KMSS_Parameter_ContextPath}resource/js/jquery.js"> </script>
		<style>
			.tab tr{line-height: 20px;}
			.tab tr td{color:#797874;}
		</style>
	</template:replace>
	<template:replace name="body">
	<%@ include file="/resource/jsp/list_top.jsp"%>
		<html:form action="/kms/evaluate/kms_evaluate_doc_detail/kmsEvaluateDocDetail.do">
<br/>
<div id="optBarDiv">
	<c:if test="${param.method != 'result'}">
		<input type="button" value="<bean:message key="button.search"/>"
			onclick="Com_OpenWindow('<c:url value="/sys/search/search.do?method=condition&fdModelName=com.landray.kmss.kms.evaluate.model.KmsEvaluateDocDetail&type=read&time=week" />','_blank');">
	</c:if>
	<c:if test="${param.method == 'result'}">
		<input type="button"
			value="<bean:message key="button.close"/>"
			onclick="Com_CloseWindow();">
	</c:if>	
</div>
<table class="tab" style="width:350px;float:left;">
	<tr><td width="10%" align="right">周期: </td>
		<td width="10%" style="padding-left:10px;"><input type="radio" style="cursor: pointer;" id="week" name="time" value="week" <c:if test="${'week'==param.time||null==param.time||''==param.time}" >checked="checked"</c:if> onchange="clickTime('week');"><label for="week">本周</label></td>
		<td	width="10%" style="padding-left:10px;"><input type="radio" style="cursor: pointer;" name="time" value="month" <c:if test="${'month'==param.time}" >checked="checked"</c:if> onchange="clickTime('month');" id="month"><label for="month">本月</label></td>
		<td	width="10%"><input type="radio" name="time" style="cursor: pointer;" value="year" <c:if test="${'year'==param.time}">checked="checked"</c:if> onchange="clickTime('year');" id="year"><label for="year">本年</label></td>
		<td	width="10%"><input type="radio" name="time" style="cursor: pointer;" value="all" <c:if test="${'all'==param.time}">checked="checked"</c:if> onchange="clickTime('all');" id="all"><label for="all">累计</label></td>
	</tr>
	<tr><td align="right" >知识分类: </td>
		<td style="padding-left:10px;"><input type="radio" style="cursor: pointer;" id="categoryAllCheck" onchange="clickAllCategory();" <c:if test="${'true'!=param.categoryCheck}">checked="checked"</c:if> name="categoryAllCheck"><label for="categoryAllCheck">所有</label></td>
		<td colspan="3">
		<input type="hidden" name="fdCategoryId" value="${param.fdCategoryId}"/>
		<html:text property="fdCategoryName" value="${param.fdCategoryName}" style="width:150px;cursor: pointer;" readonly="true" styleClass="inputsgl" />
		<a href="javascript:void(0)"  onclick="Dialog_Tree(false,'fdCategoryId','fdCategoryName',null,'kmsLogContextCategoryTree&type=doc&docCategoryId=!{value}','<bean:message  bundle="kms-log" key="kmsLogDocContext.fdCategory" />',null,updateNotice,null,null,null,'<bean:message bundle="kms-log" key="table.kmsLogContextCategory.select" />');">
		<bean:message key="button.select" /></a>
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
				<td width="5%">
					<input type="checkbox" name="List_Tongle">
				</td>
				<td width="5%">
					<bean:message key="page.serial"/>
				</td>
				<td  width="30%">
					<bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docSubject"/>
				</td>
				<sunbor:column property="read">
					<bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docReadCountNumber"/>
				</sunbor:column>
				<sunbor:column property="introduce">
					<bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docIntroduceCountNumber"/>
				</sunbor:column>
				<sunbor:column property="evaluation">
					<bean:message bundle="kms-evaluate" key="kmsEvaluateCommon.docEvaluationCountNumber"/>
				</sunbor:column>
				<td width="10%">
					<bean:message bundle="kms-evaluate" key="kmsEvaluateDocDetail.author"/>
				</td>
				<td width="20%">
					<bean:message bundle="kms-evaluate" key="kmsEvaluateDocDetail.docCreateTime"/>
				</td>
			</sunbor:columnHead>
		</tr>
		<%   
			List list = ((Page) request.getAttribute("queryPage")).getList();  
			for(int i=0;i<list.size();i++)      {        
				Object[] obj = (Object[])list.get(i);     
		%>
			<tr>
				<td>
					<input type="checkbox" name="List_Selected" value="<%=obj[0]%>">
				</td>
				<td>
					<%=i+1%>
				</td>
				<td style="text-align:left;">
					<%=obj[1]%>
				</td>
				<td><%=obj[5]%></td>
				<td><%=obj[6]%></td>
				<td><%=obj[7]%></td>
				<td>
					<%=obj[3]%>
				</td>	
				<td>
					<%=obj[2]%>
				</td>	
			</tr>
		<%} %>
	</table> 
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
	</template:replace>
</template:include>
<script>
	Com_IncludeFile("dialog.js");

	function updateNotice(val){

		var time = $("input[type=radio][name=time][checked]").val();
		var type = $("input[type=radio][name=type][checked]").val();
		var url = Com_SetUrlParameter(location.href, "type", type);
		url = Com_SetUrlParameter(url, "time", time);
		url = Com_SetUrlParameter(url, "fdCategoryId", val.data[0].id);
		url = Com_SetUrlParameter(url, "fdCategoryName", val.data[0].name);
		url = Com_SetUrlParameter(url, "categoryCheck", "true");
		setTimeout('window.location.href="' + url + '";',100);
	}
	var _dialog;
	seajs.use(['lui/dialog'], function(dialog) {
		_dialog = dialog;
	});
	var s_path = encodeURIComponent('<bean:message bundle="kms-evaluate" key="table.kmsEvaluateDocDetail"/>');
	function clickTime(obj){
		var url = Com_SetUrlParameter(location.href, "time", obj);
		createUrl(url);
	}
	function createUrl(url){
		var fdCategoryId = $("input[type=hidden][name=fdCategoryId]").val();
		if(fdCategoryId!=null && fdCategoryId.length>30){
			var fdCategoryName = encodeURIComponent($("input[type=text][name=fdCategoryName]").val());
			url = "&fdCategoryId="+fdCategoryId+"&fdCategoryName="+fdCategoryName +"&categoryCheck=true";
		}
		window.location.href=url ;
	}
	function clickAllCategory(){
		var time = $("input[type=radio][name=time][checked]").val();
		var type = $("input[type=radio][name=type][checked]").val();
		var url = Com_SetUrlParameter(location.href, "time", time);
		window.location.href=url ;
	}
</script>


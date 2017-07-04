<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/kms/log/kms_log_search/kmsLogSearch.do">
<style>
.tb_normal tr{
	line-height: 30px;
}
.tb_normal tr td{
	vertical-align: middle;
}
.td_normal_title{
	text-align: right;
	font-weight: bold;
	font-size: 14px;
}
.inputselectsgl{
	display:inline-block;
}
.inputselectsgl input {	
	color: #0066FF;
	border-color: #999999;
	border-style: solid;
	border-width: 0px 0px 1px 0px;
	font-size:12px
}
.td_search{
	display:inline-block;
	float:right;
	width:60px;
	text-align: right;
}
.validation-advice{
	display:inline-block;
	vertical-align: middle; 
	
}
.validation-advice td{
	color: red;
}
.input{
	width:100px;
}
.listtable_box{
width: 90%;
margin-left: 5%;
}
</style>
<script>
Com_IncludeFile("dialog.js|plugin.js");
</script>

<p class="txttitle" style="text-align: center;font-size: 16px;">
<bean:message bundle="kms-log" key="kmsLogApp.personal.details"/></p>
<p class="txttitle" style="text-align: right;">
<bean:message bundle="kms-log" key="kmsLogApp.count.time"/>${startDate } ~ ${endDate }
<!--<bean:message bundle="kms-log" key="kmsLogApp.log.detail.description"/>
--></p>
<c:if test="${queryPage.totalrows==0}">
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
</c:if>
<c:if test="${queryPage.totalrows>0}">
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
				<td width="40pt">
					<bean:message key="page.serial"/>
				</td>
				<td>
					<bean:message bundle="kms-log" key="kmsEvaluateDocSearchCount.fdSearchKey"/>
				</td>
				<c:if test="${param.searchMethod=='searchKey' }">
					<td>
						<bean:message bundle="kms-log" key="kmsEvaluateDocSearchCount.fdIp"/>
					</td>
				</c:if>
				<c:if test="${param.searchMethod=='searchDoc' }">
					<td>
						<bean:message bundle="kms-log" key="kmsLogContextModule.fdModule"/>
					</td>
				</c:if>
				<td>
					<bean:message bundle="kms-log" key="kmsLogApp.fdOperator"/>
				</td>
				<td>
					<bean:message bundle="kms-log" key="kmsLogApp.fdCreateTime"/>
				</td>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsLogSearch" varStatus="vstatus">
			<tr>
				<td width="5%">
					${vstatus.index+1}
				</td>
				<td width="40%">
					<c:out value="${kmsLogSearch[0]}" />
				</td>
				<td width="15%">
					<c:out value="${kmsLogSearch[1]}" />
				</td>
				<td width="15%">
					<c:out value="${kmsLogSearch[2]}" />
				</td>
				<td width="20%">
					<kmss:showDate value="${kmsLogSearch[3]}" />
				</td>
			</tr>
		</c:forEach>
	</table>
</c:if>
<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
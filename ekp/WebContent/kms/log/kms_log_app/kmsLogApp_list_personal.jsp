<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/kms/log/kms_log_app/kmsLogApp.do">
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
			<sunbor:columnHead htmlTag="td">
				<td width="40pt">
					<bean:message key="page.serial"/>
				</td>
				<sunbor:column property="kmsLogApp.modelName">
					<bean:message bundle="kms-log" key="kmsLogApp.modelName"/>
				</sunbor:column>
				<sunbor:column property="kmsLogApp.fdOprateMethod">
					<bean:message bundle="kms-log" key="kmsLogApp.fdOprateMethod"/>
				</sunbor:column>
				<sunbor:column property="kmsLogApp.fdSubject">
					<bean:message bundle="kms-log" key="kmsLogApp.fdSubject"/>
				</sunbor:column>
				<sunbor:column property="kmsLogApp.fdOperatorName">
					<bean:message bundle="kms-log" key="kmsLogApp.fdOperator"/>
				</sunbor:column>
				<sunbor:column property="kmsLogApp.fdCreateTime">
					<bean:message bundle="kms-log" key="kmsLogApp.fdCreateTime"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsLogApp" varStatus="vstatus">
			<tr>
				<td width="5%">
					${vstatus.index+1}
				</td>
				<td width="8%">
					<c:out value="${kmsLogApp.moduleName}" />
				</td>
				<td  width="8%">
					<c:out value="${kmsLogApp.operateText}" />
				</td>
				<td width="37%"> 
					<c:out value="${kmsLogApp.fdSubject}" />
				</td>
				<td width="10%">
					<c:out value="${kmsLogApp.fdOperatorName}" />
				</td>
				<td width="12%">
					<kmss:showDate value="${kmsLogApp.fdCreateTime}" />
				</td>
			</tr>
		</c:forEach>
	</table>
</c:if>
<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
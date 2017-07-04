<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
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
.txttitle {
text-align: center;
font-size: 20px;
line-height: 30px;
}
.txttitle {
color: #3e9ece;
}
</style>
<script>
Com_IncludeFile("dialog.js|plugin.js");
</script>
<p class="txttitle">${fdPersonName }<bean:message bundle="kms-integral" key="kmsIntegralCommon.scoreDetail"/></p>
<p style="text-align: right;">
<bean:message bundle="kms-integral" key="kmsIntegralCommon.docCreateTime"/>：
${date1 } ~ ${date2 } 
</p>

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
					<bean:message bundle="kms-integral" key="kmsIntegralCommon.moduleName"/>
				</td>
				<td>
					<bean:message bundle="kms-integral" key="kmsIntegralCommon.fdOprateMethod"/>
				</td>
				<td>
					${scoreUnit}
				</td>
				<td>
					<bean:message key="model.fdCreateTime"/>
				</td>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsIntegral" varStatus="vstatus">
			<tr>
				<td width="5%">
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmsIntegral[0]}" />
				</td>
				<td >
					<c:out value="${kmsIntegral[1]}" />
				</td>
				<td > 
					<c:out value="${kmsIntegral[2]}" />
				</td>
				<td>
					<kmss:showDate value="${kmsIntegral[3]}" />
				</td>
			</tr>
		</c:forEach>
	</table>
</c:if>
<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
<%@ include file="/resource/jsp/list_down.jsp"%>
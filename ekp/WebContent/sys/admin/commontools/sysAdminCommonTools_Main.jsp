<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<title><bean:message bundle="sys-admin" key="sys.sysAdminCommonTools"/></title>
<style type="text/css">
<!--
.btn{
	width:48%;
	margin:5px;
	float:left;
	height:100%;
	border:1px solid #e6e6e6;
}
.btn_1{
	margin:10px 10px 15px 10px;
}
.btn_1 input{
	padding:4px 10px;
	cursor:pointer;
}
-->
</style>
<p class="txttitle"><bean:message bundle="sys-admin" key="sys.sysAdminCommonTools"/></p>
<center>
<table width=95%>
	<tr>
		<td style="border: 0" width="25%">
		<c:forEach items="${tools}" var="tools" varStatus="vstatus">
			<div class="btn"> 
		    	<div class="btn_1">
		    		<input type="button" 
		    			value="${tools['name']}" 
		    			onclick="Com_OpenWindow('<c:url value="${tools['path']}"/>','_blank');">
		    	</div>
		     	<div class="btn_1">
		     		${tools['description']}
		     	</div>
		   	</div>
			<c:if test="${(vstatus.index+1) mod 2 eq 0}">
				</td>
				</tr>
			<c:if test="${!(vstatus.last)}">
				<tr>
					<td>
			</c:if>
			</c:if>
		</c:forEach>
		<c:if test="${fn:length(tools) mod 2 eq 1}">
		   		</td>
		   	</tr>
		</c:if>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
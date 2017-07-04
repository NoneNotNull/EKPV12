<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<table class="tb_normal" width=100%>
	<tr>
		<td class="td_normal_title" align="center" width=80%>
			<bean:message key="lbpmOperations.fdOperName" bundle="sys-lbpmservice-support" />
		</td>
		<td class="td_normal_title" align="center" width=20%>
			<bean:message key="lbpmOperations.fdOperType" bundle="sys-lbpmservice-support"/>
		</td>
	</tr>
	<c:forEach items="${lbpmOperMainForm.handlerOperations}" var="lbpmOperationsForm" varStatus="vstatus">
	<tr>
	    <td>
			<c:out value="${lbpmOperationsForm.fdOperName}" />
		</td>
		<td>
		    <xform:select property="fdOperType" value="${lbpmOperationsForm.fdOperType}">
			    <xform:customizeDataSource className="com.landray.kmss.sys.lbpmservice.support.service.spring.HandlerOperationDataSource" />
			</xform:select>
		</td>
	</tr>	
	</c:forEach>
</table>
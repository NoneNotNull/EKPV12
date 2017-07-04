<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script>
DocList_Info = new Array("TABLE_DocList_Draft");
</script>
<c:set var="operType" value="操作类型"/>
<c:set var="operName" value="操作名称" />
<table class="tb_normal" width=100% id="TABLE_DocList_Draft">
	<tr>
		<td class="td_normal_title" align="center" width=20%>
			<bean:message key="lbpmOperations.fdOperType" bundle="sys-lbpmservice-support"/>
		</td>
		<td class="td_normal_title" align="center" width=50%>
			<bean:message key="lbpmOperations.fdOperName" bundle="sys-lbpmservice-support" />
		</td>
		<td class="td_normal_title" align="center" width=30%>
			<img style="cursor:pointer" class=optStyle src="<c:url value="/resource/style/default/icons/add.gif"/>" 
				 title="<bean:message key="button.create" />" 
				 onclick="AddRow_InitDrafterSelect();"> 
		</td>
	</tr>
	<tr KMSS_IsReferRow="1" style="display:none">
		<td align="center">
			<input type="hidden" name="drafterOperations[!{index}].fdId">
			<xform:select property="drafterOperations[!{index}].fdOperType" showPleaseSelect="true" required="true" subject="${operType}" onValueChange="selectOperType">
			</xform:select>
		</td>
		<td align="center">
			<xform:text property="drafterOperations[!{index}].fdOperName" required="true" subject="${operName}" style="width:85%"/>
		</td>
		<td align="center">
		    <img style="cursor:pointer" class=optStyle src="<c:url value="/resource/style/default/icons/delete.gif"/>" 
				title="<bean:message key="button.delete" />"
				onclick="DocList_DeleteRow();">
			<img style="cursor:pointer" class=optStyle src="<c:url value="/resource/style/default/icons/up.gif"/>" 
				title="<bean:message key="button.moveup" />"
				onclick="DocList_MoveRow(-1);"> 
			<img style="cursor:pointer" class=optStyle src="<c:url value="/resource/style/default/icons/down.gif"/>" 
				title="<bean:message key="button.movedown" />"
				onclick="DocList_MoveRow(1);"> 
		</td>
	</tr>
	<c:forEach items="${lbpmOperMainForm.drafterOperations}" var="lbpmOperationsForm" varStatus="vstatus">
	<tr KMSS_IsContentRow="1">
		<td align="center">
			<input type="hidden" name="drafterOperations[${vstatus.index}].fdId" value="${lbpmOperationsForm.fdId}"/>
			<c:if test="${lbpmOperMainForm.method_GET=='edit'}">
			    <xform:select property="drafterOperations[${vstatus.index}].fdOperType" value="${lbpmOperationsForm.fdOperType}" showPleaseSelect="true" required="true" subject="${operType}" onValueChange="selectOperType">
			        <xform:customizeDataSource className="com.landray.kmss.sys.lbpmservice.support.service.spring.DrafterOperationDataSource" />
			    </xform:select>
			</c:if>
			<c:if test="${lbpmOperMainForm.method_GET=='add'}">
			    <xform:select property="drafterOperations[${vstatus.index}].fdOperType" value="${lbpmOperationsForm.fdOperType}" showPleaseSelect="true" required="true" subject="${operType}" onValueChange="selectOperType">
			    </xform:select>
			</c:if>
		</td>
		<td align="center">	
			<xform:text property="drafterOperations[${vstatus.index}].fdOperName" required="true" subject="${operName}" style="width:85%" value="${lbpmOperationsForm.fdOperName}"/>
		</td>
		<td align="center">
			<img style="cursor:pointer" class=optStyle src="<c:url value="/resource/style/default/icons/delete.gif"/>" 
				title="<bean:message key="button.delete" />"
				onclick="DocList_DeleteRow();">
			<img style="cursor:pointer" class=optStyle src="<c:url value="/resource/style/default/icons/up.gif"/>" 
				title="<bean:message key="button.moveup" />"
				onclick="DocList_MoveRow(-1);"> 
			<img style="cursor:pointer" class=optStyle src="<c:url value="/resource/style/default/icons/down.gif"/>" 
				title="<bean:message key="button.movedown" />"
				onclick="DocList_MoveRow(1);">
		</td>
	</tr>	
	</c:forEach>
</table>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>

<style>
<!--
	.title{width: 95%;height: 32px;text-align: left;font-size:16px;padding-top:7px;color:green;margin-bottom:10px;margin-top:10px;}
-->
</style>
<html:form action="/km/collaborate/km_collaborate_main/kmCollaborateMain.do">
<div id="optBarDiv">
	<c:if test="${kmCollaborateMainForm.method_GET=='editContent'}">
		<input type=button value="<bean:message key="button.save"/>"
			 onclick="Com_Submit(document.kmCollaborateMainForm, 'updateContent');"> 
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="km-collaborate" key="table.kmCollaborateMainTitle"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%><bean:message bundle="km-collaborate" key="kmCollaborateMain.docSubject"/></td>
		<td colspan="3">
			<xform:text property="docSubject" style="width:85%" showStatus="edit"/>
		
			<xform:checkbox property="fdIsPriority"  dataType="boolean" showStatus="edit">
	   				<xform:simpleDataSource value="true"><bean:message bundle="km-collaborate" key="kmCollaborateMain.fdIsPriority"/></xform:simpleDataSource>
	 		</xform:checkbox>
 		</td>
	</tr>
	<tr>
	    <td class="td_normal_title" width=15%><bean:message bundle="km-collaborate" key="kmCollaborateMain.fdCategory"/></td>
	    <td width="35%" colspan=3>
			<xform:select property="fdCategoryId" showStatus="edit" validators="required" subject="类型">
				<xform:beanDataSource serviceBean="kmCollaborateCategoryService" selectBlock="fdId,fdName" orderBy="fdOrder" />
			</xform:select><span class="txtstrong">*</span>
		</td> 
	</tr>
	<c:if test="${not empty kmCollaborateMainForm.fdSourceUrl}">
	<tr>
	     <td class="td_normal_title" width="15%">
			<bean:message bundle="km-collaborate" key="kmCollaborateMain.fdSource" />
		</td>
	    <td>
	      <html:hidden property="fdModelId" />
		  <html:hidden property="fdModelName" />
		  <html:hidden property="fdKey" />
	      <html:hidden property="fdSourceUrl" />
          <html:hidden property="fdSourceSubject" />
			
			 <a href="<c:url value="${kmCollaborateMainForm.fdSourceUrl}"/>" target="_blank">${kmCollaborateMainForm.fdSourceSubject}</a>
			
	   </td>
	</tr>
	</c:if>
	<tr>
		<td class="td_normal_title" width=15%><bean:message bundle="km-collaborate" key="kmCollaborateMain.fdContent"/></td>
		<td width="35%" colspan="3">
			<xform:rtf property="fdContent" showStatus="edit" height="400"/>
		</td>
	</tr>
	<tr >
	    <td class="td_normal_title" width=15%><bean:message bundle="km-collaborate" key="kmCollaborateMain.related.attachment"/></td>
	    <td width="35%" colspan="3">
		   <c:import  url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8" >
		   		<c:param name="fdKey" value="attachment"/>
		   </c:import>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%><bean:message bundle="km-collaborate" key="kmCollaborateMain.participant"/></td>
		<td width="35%" colspan=3>
			<xform:address  propertyId="participantIds" propertyName="participantNames" mulSelect="true" orgType="ORG_TYPE_ALL" textarea="true" style="width:85%" />
		</td>
	</tr>
	<tr>  
	    <td class="td_normal_title" width=15%><bean:message bundle="km-collaborate" key="kmCollaborateMain.docCreator"/></td>
		<td width="35%">
			<xform:address propertyId="docCreatorId" propertyName="docCreatorName" orgType="ORG_TYPE_PERSON" showStatus="view" />
		</td>
	    <td class="td_normal_title" width=15%><bean:message bundle="km-collaborate" key="kmCollaborateMain.docCreateTime"/></td>
		<td width="35%">
			<xform:datetime property="docCreateTime" />
		</td>
	</tr>	
</table>
	
<table class="tb_normal" width="95%">
	<tr disabled>
		<td class="td_normal_title" width=15%><bean:message bundle="km-collaborate" key="kmCollaborateMain.fdNotifyType"/></td>
		<td  >
			<kmss:editNotifyType property="fdNotifyType" />
		</td>
	</tr>
	<tr disabled>
		<td class="td_normal_title" width=15%><bean:message bundle="km-collaborate" key="kmCollaborateMain.fdIsReminders"/></td>
		<td >
			<xform:radio property="fdIsReminders" onValueChange="doReminderOp(this);" value="${fdIsReminders}">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:radio>
             &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<span id="todoDays" class="txtstrong" <c:if test="${kmCollaborateMain.fdIsReminders ne 'true'}">style="display:none"</c:if>>
				(<xform:text property="fdRemindersDay" style="width:20px" required="true" validators="min(0)" />
				<bean:message bundle="km-collaborate" key="kmCollaborateMain.fdReceiveHint" />)
			</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%><bean:message bundle="km-collaborate" key="kmCollaborateMain.fdPartnerOperating"/></td>
		<td >
			<xform:checkbox property="fdPartnerOperating" showStatus="edit" >
			    <xform:simpleDataSource value="true"><bean:message bundle="km-collaborate" key="kmCollaborateMain.allow.append.partnerInfo"/></xform:simpleDataSource>
			</xform:checkbox>&nbsp;&nbsp;&nbsp;&nbsp;
			<xform:checkbox property="fdEditAtt" showStatus="edit">
			    <xform:simpleDataSource value="true"><bean:message bundle="km-collaborate" key="kmCollaborateMain.fdEditAtt"/></xform:simpleDataSource>
			</xform:checkbox>
		</td>
	</tr>
</table>
</center>
<html:hidden property="docStatus"/>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	function doReminderOp(el){
		var todoD = document.getElementById("todoDays");
		if(el.value=="true"){
			todoD.style.display = "";
		}else{
			var fdDay = document.getElementsByName("fdRemindersDay")[0];
			var advice = $KMSSValidation_GetAdvice(fdDay);
			if (advice) advice.style.display = "none";
			todoD.style.display = "none";
		}
	}
	Com_IncludeFile("dialog.js");
	$KMSSValidation();
	
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>
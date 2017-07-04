<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>

<style>
<!--
	.title{width: 95%;height: 32px;background: url('../img/title_bg.jpg');text-align: left;font-size:16px;padding-top:7px;color:green;margin-bottom:10px;margin-top:10px;}
-->
</style>
<script type="text/javascript">
Com_IncludeFile("jquery.js");
</script>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
	
}
	function CloseWindow(){
		
		
		window.close();
	}
	
	$(document).ready(function(){
		
		$("#kmfdContent").find("img").each(function (){
			var width= $(this).width();
			var height=$(this).height();
			if(height>100) { $(this).height(100);}
			if(width>100) {$(this).width(Math.round(width*100/height));}
		}).click(function(){
			
			$(this).width("");
			$(this).height("");
			var width= $(this).width();
			var height=$(this).height();
			if(height>600) 
			   {
				  $(this).height(600);
			      $(this).width(Math.round(width*600/height));
			   }
			$(this).show();
			SetWinHeight(window.parent.document.getElementById("win"));
		}).dblclick( function(){
			$(this).hide();
			var width= $(this).width();
			var height=$(this).height();
			if(height>100) 
			   {
				  $(this).height(100);
			      $(this).width(Math.round(width*100/height));
			   }
			$(this).show();
			
		});
		
		
	});
	
</script>
<html:form action="/km/collaborate/km_collaborate_main/kmCollaborateMain.do">
<div id="optBarDiv">
	<kmss:auth requestURL="/km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('kmCollaborateMain.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('kmCollaborateMain.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="km-collaborate" key="table.kmCollaborateMain"/></p>

<center>
<p class="title" style="margin-top:40px;">&nbsp;&nbsp;<bean:message bundle="km-collaborate" key="kmCollaborateMain.main.content"/></p>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%><bean:message bundle="km-collaborate" key="kmCollaborateMain.docSubject"/></td>
		<td colspan="2">
			<xform:text property="docSubject" style="width:85%" showStatus="view"/>
	    </td><td>	    
			<xform:checkbox property="fdIsPriority"  dataType="boolean" showStatus="view">
	   				<xform:simpleDataSource value="true"><bean:message bundle="km-collaborate" key="kmCollaborateMain.fdIsPriority"/></xform:simpleDataSource>
	 		</xform:checkbox>
 		</td>
	</tr>
	<tr>
	    <td class="td_normal_title" width=15%><bean:message bundle="km-collaborate" key="kmCollaborateMain.fdCategory"/></td>
	    <td width="35%" colspan=3>
			<xform:select property="fdCategoryId" showStatus="view">
				<xform:beanDataSource serviceBean="kmCollaborateCategoryService" selectBlock="fdId,fdName" orderBy="fdOrder" />
			</xform:select>
		</td> 
	</tr>
	<tr>
		<td class="td_normal_title" width=15%><bean:message bundle="km-collaborate" key="kmCollaborateMain.fdContent"/></td>
		<td width="35%" colspan="3" id="kmfdContent">
			<xform:rtf property="fdContent" showStatus="view" />
		</td>
	</tr>
	<tr >
	    <td class="td_normal_title" width=15%><bean:message bundle="km-collaborate" key="kmCollaborateMain.related.attachment"/></td>
	    <td width="35%" colspan="3">
		  <c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp"
					charEncoding="UTF-8">
					<c:param name="fdKey" value="attachment" />
					<c:param name="fdModelId" value="${param.fdId }" />
					<c:param name="formBeanName" value="kmCollaborateMainForm" />
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
	
<p class="title">&nbsp;&nbsp;<bean:message bundle="km-collaborate" key="kmCollaborateMain.options"/></p>
<table class="tb_normal" width="95%">
	<tr >
		<td class="td_normal_title" width=15%><bean:message bundle="km-collaborate" key="kmCollaborateMain.fdNotifyType"/></td>
		<td  >
			<kmss:showNotifyType  value="${kmCollaborateMainForm.fdNotifyType}"  /> 
		</td>
	</tr>
	<tr >
		<td class="td_normal_title" width=15%><bean:message bundle="km-collaborate" key="kmCollaborateMain.fdIsReminders"/></td>
		<td >
			<xform:radio property="fdIsReminders" showStatus="view"  onValueChange="doReminderOp(this);" value="${fdIsReminders}">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:radio>
             &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            
			<span id="todoDays"  <c:if test="${kmCollaborateMainForm.fdIsReminders ne 'true'}">style="display:none"</c:if>>
				(<xform:text property="fdRemindersDay" style="width:20px" required="true" validators="min(0)" />
				<bean:message bundle="km-collaborate" key="kmCollaborateMain.fdReceiveHint" />)
			</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%><bean:message bundle="km-collaborate" key="kmCollaborateMain.fdPartnerOperating"/></td>
		<td >
			<xform:checkbox property="fdPartnerOperating" showStatus="view" >
			    <xform:simpleDataSource value="true"><bean:message bundle="km-collaborate" key="kmCollaborateMain.allow.append.partnerInfo"/></xform:simpleDataSource>
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
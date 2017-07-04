<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script type="text/javascript">
   Com_IncludeFile("jquery.js");
   Com_IncludeFile("dialog.js");
</script>
<style>
<!--
   .title{width: 95%;height: 32px;text-align: left;font-size:16px;padding-top:7px;color:green;margin-bottom:10px;margin-top:10px;}
   .notNull{padding-left:10px;border:solid #DFA387 1px;padding-top:8px;padding-bottom:8px;background:#FFF6D9;color:#C30409;margin-top:3px;}
   .txttitle{width: 95%;text-align: center;font-size: 20px;}
-->
</style>

<html:form action="/km/collaborate/km_collaborate_main/kmCollaborateMain.do">
<div id="optBarDiv">
	<c:if test="${kmCollaborateMainForm.method_GET=='edit'}">
		<%-- 暂存­ --%>
		<input type="button" value="<bean:message key="button.savedraft" />"
			onclick="Com_Submit(document.kmCollaborateMainForm, 'updateDraft')" />
		<input type=button value="<bean:message key="button.submit"/>"
			onclick="checkIfMore('update');" />
	</c:if>
	<c:if test="${kmCollaborateMainForm.method_GET=='add'}">
		<%-- 暂存 --%>
		<input type="button" value="<bean:message key="button.savedraft" />"
			onclick=" Com_Submit(document.kmCollaborateMainForm, 'saveDraft')" />
		<input type=button value="<bean:message key="button.submit"/>"
			onclick="checkIfMore('save');" />
		
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="km-collaborate" key="table.kmCollaborateMainTitle"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%><bean:message bundle="km-collaborate" key="kmCollaborateMain.docSubject"/></td>
		<td colspan="3">
			<xform:text property="docSubject" style="width:85%" />
			<xform:checkbox property="fdIsPriority"  dataType="boolean">
   				<xform:simpleDataSource value="true"><bean:message bundle="km-collaborate" key="kmCollaborateMain.highPriority"/></xform:simpleDataSource>
 			</xform:checkbox>
		</td>
		
	</tr>
	<tr>
	    <td class="td_normal_title" width=15%><bean:message bundle="km-collaborate" key="kmCollaborateMain.fdCategory"/></td>
		<td width="35%" colspan=3>
			<xform:select property="fdCategoryId" validators="required" subject="类型">
				<xform:beanDataSource serviceBean="kmCollaborateCategoryService" selectBlock="fdId,fdName" whereBlock="fdDeleted = true" orderBy="fdOrder,fdName" />
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
	
	<tr >
		<td class="td_normal_title" width=15%><bean:message bundle="km-collaborate" key="kmCollaborateMain.fdContent"/></td>
		<td width="35%" colspan="3" >
		
			<xform:rtf property="fdContent"  height="400px"/>
		 
		</td>
	</tr>
	<tr>
	    <td class="td_normal_title" width=15%><bean:message bundle="km-collaborate" key="kmCollaborateMain.related.attachment"/></td>
		<td width="35%" colspan="3">
		   <c:import  url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" 
		     charEncoding="UTF-8" >
		     <c:param name="fdKey" value="attachment"/>
		   </c:import>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%><bean:message bundle="km-collaborate" key="kmCollaborateMain.participant"/></td>
		<td width="35%" colspan=3>
		
			<input name="participantIds" validate="required" value="${kmCollaborateMainForm.participantIds}" type="hidden" />
			<textarea subject="参与者" name="participantNames" validate="required"  id="participantNames"  style="width:85%" readOnly >${kmCollaborateMainForm.participantNames }</textarea>
			<a id="partnerInfos" href="#" onclick="Dialog_Address(true,'participantIds','participantNames',';',ORG_TYPE_ALL);return false;"><bean:message bundle="km-collaborate" key="kmCollaborateMain.choose"/></a><span class="txtstrong">*</span>
			<%-- <div class="notNull" id="participantIds">×&nbsp;&nbsp;&nbsp;<bean:message bundle="km-collaborate" key="kmCollaborateMain.choose.partnerInfos"/></div> --%>
		</td>
	</tr>
	<tr>  
	    <td class="td_normal_title" width=15%><bean:message bundle="km-collaborate" key="kmCollaborateMain.docCreator"/></td>
		<td width="35%">
			<xform:address propertyId="docCreatorId" propertyName="docCreatorName" orgType="ORG_TYPE_PERSON" showStatus="view" />
		</td>
	    <td class="td_normal_title" width=15%><bean:message bundle="km-collaborate" key="kmCollaborateMain.docCreateTime"/></td>
		<td width="35%">
			<xform:datetime property="docCreateTime" showStatus="view" />
		</td>
	</tr>	
</table>

<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%><bean:message bundle="km-collaborate" key="kmCollaborateMain.fdNotifyType"/></td>
		<td >
			<kmss:editNotifyType property="fdNotifyType"/>
			<div class="notNull" id="fdNotifyType">×&nbsp;&nbsp;&nbsp;<bean:message bundle="km-collaborate" key="kmCollaborateMain.choose.notifytype"/></div>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%><bean:message bundle="km-collaborate" key="kmCollaborateMain.fdIsReminders"/></td>
		<td >
			<xform:radio property="fdIsReminders" onValueChange="doReminderOp(this);" value="${kmCollaborateMainForm.fdIsReminders!=null ? kmCollaborateMainForm.fdIsReminders : 'false' }" >
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:radio>
             &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<span id="todoDays" class="txtstrong" <c:if test="${!kmCollaborateMainForm.fdIsReminders}">style="display:none"</c:if>>
				<input type="hidden" value="${fdRemindersDay}" name="fdRemindersDay_hidden" id="fdRemindersDay_hidden"/> 
				(<xform:text property="fdRemindersDay" style="width:20px" required="true" validators="min(0)" />
				<bean:message bundle="km-collaborate" key="kmCollaborateMain.fdReceiveHint" />)
			</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%><bean:message bundle="km-collaborate" key="kmCollaborateMain.fdPartnerOperating"/></td>
		<td >
			<xform:checkbox property="fdPartnerOperating">
			    <xform:simpleDataSource value="true"><bean:message bundle="km-collaborate" key="kmCollaborateMain.allow.append.partnerInfo"/></xform:simpleDataSource>
			</xform:checkbox>&nbsp;&nbsp;&nbsp;&nbsp;
			<xform:checkbox property="fdEditAtt">
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
	$(function(){
		$("#fdNotifyType").hide();
		$("#participantIds").hide();
		// name会发生改变
		var fdNotifyType = document.getElementsByName("fdNotifyType")[0];
		$("input[name^='__notify_type_']").click(function() {
			checkNotifyType();
		});
		$("#partnerInfos").click(function(){
			checkParticipantIds();
		});
	});
</script>
<script>
  function checkIfMore(method){
   var participantIds=document.getElementsByName("participantIds")[0];
   var url="${KMSS_Parameter_ContextPath}km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=checkIfMore"; 
   $.ajax({     
	     type:"post",     
	     url:url,     
	     data:{type:"check",personIds:participantIds.value},    
	     async:true,     
	     success:function(data){ 
	    	 if(data.indexOf("true")>-1){		    		 
	      		  alert("<bean:message key='kmCollaborate.jsp.morethan.comNum' bundle='km-collaborate' />");
	      		  return false;
	      	  } else{
	      		Com_Submit(document.kmCollaborateMainForm, method);
	      	  }   
		   }     
      });			 
};
	  
    $KMSSValidation();
    Com_Parameter.event["submit"][Com_Parameter.event["submit"].length] = function() {
    		if(validator_km())
    			 return true ;
    		else 
    			return false ;
    	  
    	}
	function doReminderOp(el){
		var todoD = document.getElementById("todoDays");
		if(el.value=="true"){
			todoD.style.display = "";
		}else{
			var fdDay = document.getElementsByName("fdRemindersDay")[0];
			document.getElementsByName("fdRemindersDay")[0].value= document.getElementsByName("fdRemindersDay")[0].value=="" ? document.getElementsByName("fdRemindersDay_hidden")[0].value :document.getElementsByName("fdRemindersDay")[0].value;
			var advice = $KMSSValidation_GetAdvice(fdDay);
			if (advice) advice.style.display = "none";
			todoD.style.display = "none";
		}
	}
	function validator_km(){
		var r1=checkNotifyType();
		var r2=checkParticipantIds();
		return r1&&r2;
	}
	function checkNotifyType() {
		var fdNotifyType = document.getElementsByName("fdNotifyType")[0].value;
		if(null == fdNotifyType || fdNotifyType==""){
			$("#fdNotifyType").show();
			$("input[type='checkbox']").focus();
			return false;
		}else{
			$("#fdNotifyType").hide();
			return true;
		}
	}
	
	function checkParticipantIds() {
		var participantIds = document.getElementsByName("participantIds")[0].value;
		if(null == participantIds || participantIds==""){
			$("#participantNames").focus();
			$("#participantIds").show();
			return false;
		}else{
			$("#participantIds").hide();
			return true;
		}
	}

	
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script type="text/javascript">
<!--
	Com_IncludeFile("calendar.js");
	Com_IncludeFile("dialog.js");
	function changeSelect(obj){
		if(obj=='2'){
			document.getElementById("dept_id").style.display="none";
			document.getElementById("person_id").style.display="";
		}else{
			document.getElementById("dept_id").style.display="";
			document.getElementById("person_id").style.display="none";
		}
	}
	function ResetForm(){
		document.sysTaskAnalyzeForm.reset();
		document.getElementsByName("fdBoundIds")[0].value = "";
	}
	function setIframSrc(){
		var analyzeObjType_radio = document.getElementsByName("fdAnalyzeObjType");
		var analyzeObjType;
		for(var i=0;i<analyzeObjType_radio.length;i++)   
		{   
		 if(analyzeObjType_radio[i].checked)  analyzeObjType= analyzeObjType_radio[i].value;  
		}
		var analyzeStartDate = document.getElementsByName("fdStartDate")[0].value;
		var analyzeEndDate = document.getElementsByName("fdEndDate")[0].value;
		var fdBoundIds = document.getElementsByName("fdBoundIds")[0].value;
		var analyzeType_radio = document.getElementsByName("fdAnalyzeType");
		var dateQueryTypeList = document.getElementsByName("dateQueryTypeList");
		var isincludechild_radio =document.getElementsByName("fdIsincludechild");
		var isincludechildtask_radio=document.getElementsByName("fdIsincludechildTask");
        var isincludechild;
        var isincludechildtask;
		var analyzeType;
		var dateQueryType = "";
		for(i=0;i<analyzeType_radio.length;i++)   
		{   
		 	if(analyzeType_radio[i].checked)  analyzeType= analyzeType_radio[i].value;  
		}
		for(i = 0 ; i < dateQueryTypeList.length; i++ ){
			if(dateQueryTypeList[i].checked){
				dateQueryType = dateQueryType+dateQueryTypeList[i].value;
			}
		}
		if(analyzeStartDate != undefined || analyzeEndDate != undefined) {
			if(dateQueryType == ""){
				alert("<bean:message bundle='sys-task' key='sysTaskAnalyze.dateQueryType.message'/>");
				return ;
			}
		}
		//判断是否包含子部门
	    for(var i=0;i<isincludechild_radio.length;i++)   
		{   
		 if(isincludechild_radio[i].checked)  isincludechild= isincludechild_radio[i].value ; 
		}
		//判断是否包含子任务
		 for(var i=0;i<isincludechildtask_radio.length;i++)   
		{   
		 if(isincludechildtask_radio[i].checked)  isincludechildtask= isincludechildtask_radio[i].value;  
		}
		document.getElementById("iframe_id").style.display="";
		document.getElementById("iframe_id").src="${KMSS_Parameter_ContextPath}sys/task/sys_task_analyze/sysTaskAnalyze.do?method=listPriviewResult"
		+"&objType="+analyzeObjType
		+"&fdStartDate="+analyzeStartDate
		+"&fdEndDate="+analyzeEndDate
		+"&boundIds="+fdBoundIds
		+"&analyzeType="+analyzeType
		+"&type="+analyzeType
		+"&isincludechild="+isincludechild
		+"&isincludechildtask="+isincludechildtask
		+"&dateQueryType="+dateQueryType;
		//alert(document.getElementById("iframe_id").src);
	}
	function my_submit(obj){
		if(validateSysTaskAnalyzeForm(obj)){
			var analyzeStartDate = document.getElementsByName("fdStartDate")[0].value;
			var analyzeEndDate = document.getElementsByName("fdEndDate")[0].value;
			var dateQueryTypeList = document.getElementsByName("dateQueryTypeList");
			var dateQueryType = "";
			for(i = 0 ; i < dateQueryTypeList.length; i++ ){
				if(dateQueryTypeList[i].checked){
					dateQueryType = dateQueryType+dateQueryTypeList[i].value;
				}
			}
			if(analyzeStartDate != undefined || analyzeEndDate != undefined) {
				if(dateQueryType == ""){
					alert("<bean:message bundle='sys-task' key='sysTaskAnalyze.dateQueryType.message'/>");
					return false;
				}
			}
			return true;
		}else{
			return false;
		}
	}
//-->
</script>
<html:form action="/sys/task/sys_task_analyze/sysTaskAnalyze.do" onsubmit="return my_submit(this);">
<div id="optBarDiv">
	<c:if test="${sysTaskAnalyzeForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysTaskAnalyzeForm, 'update');">
	</c:if>
	<c:if test="${sysTaskAnalyzeForm.method_GET=='add' || sysTaskAnalyzeForm.method_GET=='quoteAdd'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysTaskAnalyzeForm, 'save');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message  bundle="sys-task" key="table.sysTaskAnalyze"/></p>
<center>
<table class="tb_normal" width=95%>
		<html:hidden property="fdId"/>
	<tr>
		<td class="td_normal_title" width=10% >
			<bean:message  bundle="sys-task" key="sysTaskAnalyze.docSubject"/>
		</td>
		<td width=85% colspan=3>
			<html:text size="100" property="docSubject"/><span class="txtstrong">*</span>	
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=10%>
			<bean:message  bundle="sys-task" key="sysTaskAnalyze.analyzeObj.type"/>
		</td><td width=35%>
			<sunbor:enums enumsType="sysTaskAnalyze_analyzeObj_type"  elementType = "radio" property="fdAnalyzeObjType"  />
		</td>
		<td class="td_normal_title" width=10%>
			<bean:message  bundle="sys-task" key="sysTaskAnalyze.analyze.type"/>
		</td><td width=35%>
			<sunbor:enums enumsType="sysTaskFreedback_analyze_type"  elementType = "radio" property="fdAnalyzeType" />
		</td>
	</tr>			
	<tr>
	<table class="tb_normal" width=95%>
		<tr class="txttitle" width=10% >
		<td colspan=6 style="text-align:left;font-size:18px;font-weight:bold;border:0;padding:0;">
			<bean:message  bundle="sys-task" key="sysTaskAnalyze.analyzeObj.bound"/>
			</td>
		</tr>
		<tr>
		   <td class="td_normal_title" width="10%" ><bean:message  bundle="sys-task" key="sysTaskAnalyze.org"/></td>
		   <td colspan=5>
			<html:hidden property="fdBoundIds"/>
			<html:textarea style="width:80%" readonly="true" property="fdBoundNames"/>
			<a href="#" onclick="Dialog_Address(true, 'fdBoundIds', 'fdBoundNames', ';', ORG_TYPE_DEPT|ORG_TYPE_ORG|ORG_TYPE_PERSON)"/><bean:message key="dialog.selectOrg" /></a>
			<span class="txtstrong">*</span>
		   </td>	   
	    </tr>
	    <tr>
	     <td class="td_normal_title" width="10%" ><bean:message  bundle="sys-task" key="sysTaskAnalyze.fdIsincludechild"/></td>
	     <td colspan=5>
	     	<sunbor:enums enumsType="sysTaskAnalyze_fdIsincludechild"  elementType = "radio" property="fdIsincludechild"  />	     
	     </td>
	    </tr>
	    <tr>
	       <td class="td_normal_title" width="10%"><bean:message  bundle="sys-task" key="sysTaskAnalyze.time"/></td>
	       <td class="td_normal_title" width="10%">
			<bean:message  bundle="sys-task" key="sysTaskAnalyze.startDate"/>
		    </td><td width=15%>
			<html:text property="fdStartDate"/><a href="#" onclick="selectDate('fdStartDate');"> <bean:message
				key="dialog.selectTime" />
		    </td>
		    <td class="td_normal_title" width="10%">
			<bean:message  bundle="sys-task" key="sysTaskAnalyze.endDate"/>
		    </td><td width=15%>
			<html:text property="fdEndDate"/><a href="#" onclick="selectDate('fdEndDate');"> <bean:message
				key="dialog.selectTime" />
		    </td>
		   	<td  class="td_normal_title" ><sunbor:multiSelectCheckbox formName="sysTaskAnalyzeForm"  enumsType="sysTaskAnalyze_fdDateQueryType" property="dateQueryTypeList"></sunbor:multiSelectCheckbox></td>
		    	    
	    </tr>
	    <tr>
	         <td class="td_normal_title" width="10%"><bean:message  bundle="sys-task" key="sysTaskAnalyze.fdIsincludechildTask"/></td>
	         <td colspan=5>
	     	<sunbor:enums enumsType="sysTaskAnalyze_fdIsincludechildTask"  elementType = "radio" property="fdIsincludechildTask"  />	     
	         </td>
	    </tr>	
	</table>
	</tr>
	<tr>
		<td colspan="4">
			<center><input type="button" value="<bean:message bundle="sys-task" key="button.reset"/>" onclick="ResetForm();"/>&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" value="<bean:message bundle="sys-task" key="button.priview"/>" onclick="setIframSrc();"/></center>
		</td>
	</tr>
	<tr>
		<td colspan="4" width="100%" height="700">
			<iframe style="display:none" id = "iframe_id" width="100%" height="100%" style="width:100%;height:100%" frameborder="0" src="${KMSS_Parameter_ContextPath}sys/task/sys_task_analyze/sysTaskAnalyze.do?method=listPriviewResult&objType=${sysTaskAnalyzeForm.fdAnalyzeObjType}&startDate=${sysTaskAnalyzeForm.fdStartDate}&endDate=${sysTaskAnalyzeForm.fdEndDate}&boundIds=${sysTaskAnalyzeForm.fdBoundIds}&analyzeType=${sysTaskAnalyzeForm.fdAnalyzeType}"></iframe>
		</td>
	</tr>
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<html:javascript formName="sysTaskAnalyzeForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>

<%@ include file="/resource/jsp/edit_down.jsp"%>
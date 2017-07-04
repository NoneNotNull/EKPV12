
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<tr LKS_LabelName="<bean:message bundle="tib-sap-sync" key="tibSapSyncJob.lang.mappingRelation"/>">
			<td>
			<table id="TABLE_DocList" class="tb_normal" width="100%">
	<tr class="td_normal_title" >
	    <td rowspan="100" align="center"><bean:message bundle="tib-sap-sync" key="tibSapSyncJob.lang.syncJob"/></td>
		<td><bean:message bundle="tib-sap-sync" key="tibSapSyncJob.lang.number"/></td>
		<td>BAPI<bean:message bundle="tib-sap-sync" key="tibSapSyncJob.lang.name"/></td>
		<td><bean:message bundle="tib-sap-sync" key="tibSapSyncJob.fdUseExplain"/></td>
		<td>
			<img
			src="${KMSS_Parameter_StylePath}icons/add.gif" alt="<bean:message bundle="tib-sap-sync" key="tibSapSyncJob.lang.add"/>"
			onclick="add_row('TABLE_DocList')" style="cursor: hand">
		</td>
	</tr>
	<!--基准行-->
	<tr KMSS_IsReferRow="1" style="display:none">
		<td KMSS_IsRowIndex="1">
		</td>
		<td>
		<input type="hidden" name="fdSapInfoForms[!{index}].fdSendType"/> <!--是否启用文件传输-->
		<input type="hidden" name="fdSapInfoForms[!{index}].fdId"/>
		<input type="hidden" name="fdSapInfoForms[!{index}].fdRfcSettingId" value=""/>
		<input type="hidden" name="fdSapInfoForms[!{index}].fdInvokeType"  value="0"/><!--0表示表单事件-->
		<input type="hidden" name="fdSapInfoForms[!{index}].fdEditorTime"/><!--传入参数json字符串-->
		<input type="hidden" name="fdSapInfoForms[!{index}].fdRfcXml"/>
		<input type="hidden" name="fdSapInfoForms[!{index}].fdUse"/> <!--是否启用-->
		<input type="hidden" name="fdSapInfoForms[!{index}].fdQuartzTime"/> <!--时间撮-->
		<input type="hidden" name="fdSapInfoForms[!{index}].fdQuartzId" value="${tibSapSyncJobForm.fdId}"/> <!-- 定时任务id -->
		<input type="hidden" name="fdSapInfoForms[!{index}].fdQuartzName" value="${tibSapSyncJobForm.fdSubject}"/>  <!-- 定时任务名称 -->
		
		<input type="text" name="fdSapInfoForms[!{index}].fdRfcSettingName" value="" readOnly class="inputread" >
		
		</td>
		<td><input type="text" name="fdSapInfoForms[!{index}].fdFuncMark" value=""  class="inputsgl" ></td>
		<td>
			<img
			src="${KMSS_Parameter_StylePath}icons/edit.gif" alt="<bean:message bundle="tib-sap-sync" key="tibSapSyncJob.lang.edit"/>"
			onclick="editFormEventFunction(this.parentNode.parentNode.rowIndex-1);" style="cursor: hand">
				<img
			src="${KMSS_Parameter_StylePath}icons/delete.gif" alt="<bean:message bundle="tib-sap-sync" key="tibSapSyncJob.lang.delete"/>"
			onclick="DocList_DeleteRow();" style="cursor: hand">
		</td>
	</tr>
	
	<!--内容行-->
	<c:forEach items="${tibSapSyncJobForm.fdSapInfoForms}" var="fdSapInfoForm" varStatus="vstatus">
	<tr KMSS_IsContentRow="1">
		<td>${vstatus.index+1}</td>
		<td>
		<input type="hidden" name="fdSapInfoForms[${vstatus.index}].fdEditorTime" value="${fdSapInfoForm.fdEditorTime}"/>
		<input type="hidden" name="fdSapInfoForms[${vstatus.index}].fdSendType" value="${fdSapInfoForm.fdSendType}"/> <!--是否启用文件传输-->
		<input type="hidden" name="fdSapInfoForms[${vstatus.index}].fdUse" value="${fdSapInfoForm.fdUse}"/> <!--是否启用-->
		<input type="hidden" name="fdSapInfoForms[${vstatus.index}].fdQuartzTime" value="${fdSapInfoForm.fdQuartzTime}"/> <!--时间-->
		<input type="hidden" name="fdSapInfoForms[${vstatus.index}].fdQuartzId" value="${tibSapSyncJobForm.fdId}"/> <!-- 定时任务id -->
		<input type="hidden" name="fdSapInfoForms[${vstatus.index}].fdQuartzName" value="${tibSapSyncJobForm.fdSubject}"/> <!-- 定时任务名称 -->
		<input type="hidden" name="fdSapInfoForms[${vstatus.index}].fdId" value="${fdSapInfoForm.fdId}"/>
		<input type="hidden" name="fdSapInfoForms[${vstatus.index}].fdRfcSettingId" value="${fdSapInfoForm.fdRfcSettingId}"/>
		<input type="hidden" name="fdSapInfoForms[${vstatus.index}].fdInvokeType"  value="${fdSapInfoForm.fdInvokeType}"/>
		<input type="hidden" name="fdSapInfoForms[${vstatus.index}].fdRfcXml" value='${fdSapInfoForm.fdRfcXmlView}'/><!--传入参数json字符串-->
		<input type="hidden" name="fdSapInfoForms[${vstatus.index}].fdEditorTime" value="${fdSapInfoForm.fdEditorTime}"/><!--传出参数json字符串-->
		<input type="text" name="fdSapInfoForms[${vstatus.index}].fdRfcSettingName" value="${fdSapInfoForm.fdRfcSettingName}" readOnly class="inputread">
		</td>
		<td><input type="text" name="fdSapInfoForms[${vstatus.index}].fdFuncMark" value="${fdSapInfoForm.fdFuncMark}" class="inputsgl" ></td>
		<td>
			<img src="${KMSS_Parameter_StylePath}icons/edit.gif" alt="<bean:message bundle="tib-sap-sync" key="tibSapSyncJob.lang.edit"/>"
			onclick="editFormEventFunction(this.parentNode.parentNode.rowIndex-1);" style="cursor: hand">
		    <img src="${KMSS_Parameter_StylePath}icons/delete.gif" alt="<bean:message bundle="tib-sap-sync" key="tibSapSyncJob.lang.delete"/>"
			onclick="DocList_DeleteRow();" style="cursor: hand">
		</td>
	</tr>
	</c:forEach>
	
</table>
</td>
<script>

function add_row(index) {
	var length=document.getElementById(index).rows.length;
	if(length<2){
		DocList_AddRow();
	}
}


//得到函数对应xml格式数据信息
<%-- 
function getXml(){
	var fdRfcSettingId=$("#fdRfcSettingId").val();
	if(fdRfcSettingId==null||fdRfcSettingId=="")return;
	var data = new KMSSData();
	data.SendToBean("tibSapMappingFuncXmlService&fdRfcSettingId="+fdRfcSettingId,resetTable);
}
--%>
//编辑函数信息
function editFormEventFunction(index){
	var funcObject={
			"fdEditorTime":$('input[name="fdSapInfoForms['+index+'].fdEditorTime"]').val(),
			"fdSendType":$('input[name="fdSapInfoForms['+index+'].fdSendType"]').val(),
			"fdUse":$('input[name="fdSapInfoForms['+index+'].fdUse"]').val(),
			"fdEditorTime":$('input[name="fdSapInfoForms['+index+'].fdEditorTime"]').val(),
			"fdQuartzId":$('input[name="fdSapInfoForms['+index+'].fdQuartzId"]').val(),
			"fdQuartzName":$('input[name="fdSapInfoForms['+index+'].fdQuartzName"]').val(),
			"fdQuartzTime":$('input[name="fdSapInfoForms['+index+'].fdQuartzTime"]').val(),
			"fdFuncMark":$('input[name="fdSapInfoForms['+index+'].fdFuncMark"]').val(),
			"fdRfcSettingName":$('input[name="fdSapInfoForms['+index+'].fdRfcSettingName"]').val(),
			"fdRfcSettingId":$('input[name="fdSapInfoForms['+index+'].fdRfcSettingId"]').val(),
			"fdInvokeType":$('input[name="fdSapInfoForms['+index+'].fdInvokeType"]').val(),
			"fdRfcXml":$('input[name="fdSapInfoForms['+index+'].fdRfcXml"]').val()//json字符串
			};
//	if(funcObject.fdRfcXml=="undefined"||funcObject.fdRfcXml==""){
//	funcObject.fdRfcXml=
//	}
if(funcObject.fdRfcSettingId!=null||funcObject.fdRfcSettingId!=""){
	if(funcObject.fdRfcXml==null||funcObject.fdRfcXml==""){
	var data = new KMSSData();
	data.SendToBean("tibSapMappingFuncXmlService&fdRfcSettingId="+funcObject.fdRfcSettingId,function (rtnData){
		if(rtnData.GetHashMapArray().length==0)return;
		funcObject.fdRfcXml=rtnData.GetHashMapArray()[0]["funcXml"];
	});
}
};
    funcObject.cfg_model="edit";//控制阅读
	window.showModalDialog("../tib_sap_sync_temp_func/tibSapSyncTempFunc_edit.jsp?fdInvokeType=4", funcObject,"dialogWidth=1000px;dialogHeight=600px");
	//重置字段值
	 resetFormEventField(funcObject,index);
}

//编辑函数后重置字段值
function resetFormEventField(funcObject,index){
	
	$('input[name="fdSapInfoForms['+index+'].fdSendType"]').val(funcObject.fdSendType),
	$('input[name="fdSapInfoForms['+index+'].fdUse"]').val(funcObject.fdUse),
	$('input[name="fdSapInfoForms['+index+'].fdQuartzId"]').val(funcObject.fdQuartzId),
	$('input[name="fdSapInfoForms['+index+'].fdFuncMark"]').val(funcObject.fdFuncMark),
	$('input[name="fdSapInfoForms['+index+'].fdQuartzTime"]').val(funcObject.fdQuartzTime),
	$('input[name="fdSapInfoForms['+index+'].fdFuncMark"]').val(funcObject.fdFuncMark),
	$('input[name="fdSapInfoForms['+index+'].fdRfcSettingName"]').val(funcObject.fdRfcSettingName),
	$('input[name="fdSapInfoForms['+index+'].fdRfcSettingId"]').val(funcObject.fdRfcSettingId),
	$('input[name="fdSapInfoForms['+index+'].fdInvokeType"]').val(funcObject.fdInvokeType),
	$('input[name="fdSapInfoForms['+index+'].fdRfcXml"]').val(funcObject.fdRfcXml);
}
</script>
			
		
	

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<script type="text/javascript">
	Com_IncludeFile("jquery.js|json2.js|dialog.js|formula.js|xml.js|data.js");
</script>
<tr LKS_LabelName="映射关系">
	<td>
		<table id="TABLE_DocList" class="tb_normal" width="100%">
			<tr class="td_normal_title">
				<td rowspan="100" align="center">定时任务</td>
				<td>序号</td>
				<td>BAPI名称</td>
				<td>用途说明</td>
				<td></td>
			</tr>
			<!--基准行-->
			<tr KMSS_IsReferRow="1" style="display: none">
				<td KMSS_IsRowIndex="1"></td>
				<td>
					<input type="hidden" name="fdSoapInfoForms[!{index}].fdId" /> 
					<input type="hidden" name="fdSoapInfoForms[!{index}].fdSoapMainId" value="" /> 
					<input type="hidden" name="fdSoapInfoForms[!{index}].fdInvokeType" value="3" /> <!--0表示表单事件--> 
					<input type="hidden" name="fdSoapInfoForms[!{index}].fdLastDate" />
					<input type="hidden" name="fdSoapInfoForms[!{index}].fdSoapXml" /> 
					<input type="hidden" name="fdSoapInfoForms[!{index}].fdUse" /> <!--是否启用--> 
					<input type="hidden" name="fdSoapInfoForms[!{index}].fdQuartzTime" /> <!--时间撮-->
					<input type="hidden" name="fdSoapInfoForms[!{index}].fdQuartzId" value="${tibSoapSyncJobForm.fdId}" /> <!-- 定时任务id --> 
					<input type="hidden" name="fdSoapInfoForms[!{index}].fdQuartzName" value="${tibSoapSyncJobForm.fdSubject}" /> <!-- 定时任务名称 -->
					
					<input type="hidden" name="fdSoapInfoForms[!{index}].fdCompDbcpId" value="${fdSoapInfoForm.fdCompDbcpId}"/><!--数据源ID-->
					<input type="hidden" name="fdSoapInfoForms[!{index}].fdCompDbcpName" value="${fdSoapInfoForm.fdCompDbcpName}"/><!--数据源Name-->
					<input type="hidden" name="fdSoapInfoForms[!{index}].fdSyncTableXpath" value="${fdSoapInfoForm.fdSyncTableXpath}"/><!--同步表-->
					<input type="hidden" name="fdSoapInfoForms[!{index}].fdSyncType" value="${fdSoapInfoForm.fdSyncType}"/><!--同步方式-->
					<input type="hidden" name="fdSoapInfoForms[!{index}].fdTimeColumn" value="${fdSoapInfoForm.fdTimeColumn}"/><!--时间戳列-->
					<input type="hidden" name="fdSoapInfoForms[!{index}].fdDelCondition" value="${fdSoapInfoForm.fdDelCondition}"/><!--删除条件-->
		
					 
					<input type="text" name="fdSoapInfoForms[!{index}].fdSoapMainName" value="default" readOnly class="inputread">
				</td>
				<td>
				<input type="text"
					name="fdSoapInfoForms[!{index}].fdFuncMark" value="用途" readOnly
					class="inputread">
				</td>
				<td><img src="${KMSS_Parameter_StylePath}icons/edit.gif"
					title="查看"
					onclick="editFormEventFunction(this.parentNode.parentNode.rowIndex-1);"
					style="cursor: pointer">
				</td>
			</tr>

			<!--内容行-->
			<c:forEach items="${tibSoapSyncJobForm.fdSoapInfoForms}"
				var="fdSoapInfoForm" varStatus="vstatus">
				<tr KMSS_IsContentRow="1">
					<td>${vstatus.index+1}</td>
					<td> 
						<input type="hidden" name="fdSoapInfoForms[${vstatus.index}].fdUse" value="${fdSoapInfoForm.fdUse}" /> <!--是否启用--> 
						<input type="hidden" name="fdSoapInfoForms[${vstatus.index}].fdQuartzTime" value="${fdSoapInfoForm.fdQuartzTime}" /> <!--时间--> 
						<input type="hidden" name="fdSoapInfoForms[${vstatus.index}].fdQuartzId" value="${tibSoapSyncJobForm.fdId}" /> <!-- 定时任务id --> 
						<input type="hidden" name="fdSoapInfoForms[${vstatus.index}].fdQuartzName" value="${tibSoapSyncJobForm.fdSubject}" /> <!-- 定时任务名称 --> 
						<input type="hidden" name="fdSoapInfoForms[${vstatus.index}].fdId" value="${fdSoapInfoForm.fdId}" /> 
						<input type="hidden" name="fdSoapInfoForms[${vstatus.index}].fdSoapMainId" value="${fdSoapInfoForm.fdSoapMainId}" /> 
						<input type="hidden" name="fdSoapInfoForms[${vstatus.index}].fdInvokeType" value="${fdSoapInfoForm.fdInvokeType}" /> 
						<input type="hidden" name="fdSoapInfoForms[${vstatus.index}].fdSoapXml" value='${fdSoapInfoForm.fdSoapXml}' />
						<input type="hidden" name="fdSoapInfoForms[${vstatus.index}].fdLastDate" value="${fdSoapInfoForm.fdLastDate}" />
						
						<input type="hidden" name="fdSoapInfoForms[${vstatus.index}].fdCompDbcpId" value="${fdSoapInfoForm.fdCompDbcpId}"/><!--数据源ID-->
						<input type="hidden" name="fdSoapInfoForms[${vstatus.index}].fdCompDbcpName" value="${fdSoapInfoForm.fdCompDbcpName}"/><!--数据源Name-->
						<input type="hidden" name="fdSoapInfoForms[${vstatus.index}].fdSyncTableXpath" value="${fdSoapInfoForm.fdSyncTableXpath}"/><!--同步表-->
						<input type="hidden" name="fdSoapInfoForms[${vstatus.index}].fdSyncType" value="${fdSoapInfoForm.fdSyncType}"/><!--同步方式-->
						<input type="hidden" name="fdSoapInfoForms[${vstatus.index}].fdTimeColumn" value="${fdSoapInfoForm.fdTimeColumn}"/><!--时间戳列-->
						<input type="hidden" name="fdSoapInfoForms[${vstatus.index}].fdDelCondition" value="${fdSoapInfoForm.fdDelCondition}"/><!--删除条件-->
		
						<input type="text" name="fdSoapInfoForms[${vstatus.index}].fdSoapMainName" value="${fdSoapInfoForm.fdSoapMainName}" readOnly class="inputread">
					</td>
					<td><input type="text"
						name="fdSoapInfoForms[${vstatus.index}].fdFuncMark"
						value="${fdSoapInfoForm.fdFuncMark}" readOnly class="inputread">
					</td>
					<td><img
						src="${KMSS_Parameter_StylePath}icons/userinfo_icon.gif"
						title="查看" onclick="editFormEventFunction('${vstatus.index}');"
						style="cursor: pointer"> 
					</td>
				</tr>
			</c:forEach>

		</table></td>
<script>
	
	//编辑函数信息
	function editFormEventFunction(index) {
		var funcObject = {
			"fdUse" : $('input[name="fdSoapInfoForms[' + index + '].fdUse"]').val(),
			"fdLastDate" : $('input[name="fdSoapInfoForms[' + index + '].fdLastDate"]').val(),
			"fdQuartzId" : $('input[name="fdSoapInfoForms[' + index+ '].fdQuartzId"]').val(),
			"fdQuartzName" : $('input[name="fdSoapInfoForms[' + index+ '].fdQuartzName"]').val(),
			"fdQuartzTime" : $('input[name="fdSoapInfoForms[' + index+ '].fdQuartzTime"]').val(),
			"fdFuncMark" : $('input[name="fdSoapInfoForms[' + index+ '].fdFuncMark"]').val(),
			"fdSoapMainName" : $('input[name="fdSoapInfoForms[' + index+ '].fdSoapMainName"]').val(),
			"fdSoapMainId" : $('input[name="fdSoapInfoForms[' + index+ '].fdSoapMainId"]').val(),
			"fdInvokeType" : $('input[name="fdSoapInfoForms[' + index+ '].fdInvokeType"]').val(),
			"fdSoapXml" : $('input[name="fdSoapInfoForms[' + index + '].fdSoapXml"]').val(),
			"fdCompDbcpId":$('input[name="fdSoapInfoForms['+index+'].fdCompDbcpId"]').val(),
			"fdCompDbcpName":$('input[name="fdSoapInfoForms['+index+'].fdCompDbcpName"]').val(),
			"fdSyncTableXpath":$('input[name="fdSoapInfoForms['+index+'].fdSyncTableXpath"]').val(),
			"fdSyncType":$('input[name="fdSoapInfoForms['+index+'].fdSyncType"]').val(),
			"fdTimeColumn":$('input[name="fdSoapInfoForms['+index+'].fdTimeColumn"]').val(),
			"fdDelCondition":$('input[name="fdSoapInfoForms['+index+'].fdDelCondition"]').val()
		//json字符串
		};
		funcObject.cfg_model="view";//控制阅读
		if ((funcObject.fdSoapMainId != null || funcObject.fdSoapMainId != "")
				&& (funcObject.fdSoapXml == null || funcObject.fdSoapXml == "")) {
			var data = new KMSSData();
			data.SendToBean("tibSoapMappingFuncXmlService&fdSoapMainId="+ funcObject.fdSoapMainId,
				function(rtnData) {
					if (rtnData.GetHashMapArray().length == 0)
						return;
					funcObject.fdSoapXml = rtnData.GetHashMapArray()[0]["funcXml"];
					window.showModalDialog(
							"../tib_soap_sync_temp_func/tibSoapSyncTempFunc_view.jsp?fdInvokeType=4",
							funcObject,
							"dialogWidth=1000px;dialogHeight=600px");
					resetFormEventField(funcObject, index);
				}
			);
		} else {
			window.showModalDialog("../tib_soap_sync_temp_func/tibSoapSyncTempFunc_view.jsp?fdInvokeType=4",
					funcObject,
					"dialogWidth=1000px;dialogHeight=600px");
			//重置字段值
			resetFormEventField(funcObject, index);
		}
	}
	//编辑函数后重置字段值
	function resetFormEventField(funcObject, index) {
		$('input[name="fdSoapInfoForms[' + index + '].fdUse"]').val(funcObject.fdUse), 
		$('input[name="fdSoapInfoForms[' + index + '].fdLastDate"]').val(funcObject.fdLastDate), 
		$('input[name="fdSoapInfoForms[' + index + '].fdQuartzId"]').val(funcObject.fdQuartzId), 
		$('input[name="fdSoapInfoForms[' + index + '].fdFuncMark"]').val(funcObject.fdFuncMark), 
		$('input[name="fdSoapInfoForms[' + index + '].fdQuartzTime"]').val(funcObject.fdQuartzTime), 
		$('input[name="fdSoapInfoForms[' + index + '].fdFuncMark"]').val(funcObject.fdFuncMark), 
		$('input[name="fdSoapInfoForms[' + index + '].fdSoapMainName"]').val(funcObject.fdSoapMainName), 
		$('input[name="fdSoapInfoForms[' + index + '].fdSoapMainId"]').val(funcObject.fdSoapMainId), 
		$('input[name="fdSoapInfoForms[' + index + '].fdInvokeType"]').val(funcObject.fdInvokeType), 
		$('input[name="fdSoapInfoForms[' + index + '].fdSoapXml"]').val(funcObject.fdSoapXml);
		$('input[name="fdSoapInfoForms[' + index + '].fdCompDbcpId"]').val(funcObject.fdCompDbcpId);
		$('input[name="fdSoapInfoForms[' + index + '].fdCompDbcpName"]').val(funcObject.fdCompDbcpName);
		$('input[name="fdSoapInfoForms[' + index + '].fdSyncTableXpath"]').val(funcObject.fdSyncTableXpath);
		$('input[name="fdSoapInfoForms[' + index + '].fdSyncType"]').val(funcObject.fdSyncType);
		$('input[name="fdSoapInfoForms[' + index + '].fdTimeColumn"]').val(funcObject.fdTimeColumn);
		$('input[name="fdSoapInfoForms[' + index + '].fdDelCondition"]').val(funcObject.fdDelCondition);
	}
</script>

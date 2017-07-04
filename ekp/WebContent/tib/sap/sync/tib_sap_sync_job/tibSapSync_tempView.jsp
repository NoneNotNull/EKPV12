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
				<td>
					<%--
			<img
			src="${KMSS_Parameter_StylePath}icons/add.gif" alt="add"
			onclick="DocList_AddRow();" style="cursor: hand">
			 --%></td>
			</tr>
			<!--基准行-->
			<tr KMSS_IsReferRow="1" style="display: none">
				<td KMSS_IsRowIndex="1"></td>
				<td><input type="hidden"
					name="fdSapInfoForms[!{index}].fdSendType" /> <!--是否启用文件传输--> <input
					type="hidden" name="fdSapInfoForms[!{index}].fdId" /> <input
					type="hidden" name="fdSapInfoForms[!{index}].fdRfcSettingId"
					value="" /> <input type="hidden"
					name="fdSapInfoForms[!{index}].fdInvokeType" value="3" />
				<!--0表示表单事件--> <input type="hidden"
					name="fdSapInfoForms[!{index}].fdEditorTime" />
				<!--传入参数json字符串--> <input type="hidden"
					name="fdSapInfoForms[!{index}].fdRfcXml" /> <input type="hidden"
					name="fdSapInfoForms[!{index}].fdUse" /> <!--是否启用--> <input
					type="hidden" name="fdSapInfoForms[!{index}].fdQuartzTime" /> <!--时间撮-->
					<input type="hidden" name="fdSapInfoForms[!{index}].fdQuartzId"
					value="${tibSapSyncJobForm.fdId}" /> <!-- 定时任务id --> <input
					type="hidden" name="fdSapInfoForms[!{index}].fdQuartzName"
					value="${tibSapSyncJobForm.fdSubject}" /> <!-- 定时任务名称 --> <input
					type="text" name="fdSapInfoForms[!{index}].fdRfcSettingName"
					value="default" readOnly class="inputread"></td>
				<td><input type="text"
					name="fdSapInfoForms[!{index}].fdFuncMark" value="用途" readOnly
					class="inputread">
				</td>
				<td><img src="${KMSS_Parameter_StylePath}icons/edit.gif"
					title="查看"
					onclick="editFormEventFunction(this.parentNode.parentNode.rowIndex-1);"
					style="cursor: hand"> <%-- 
			<img src="${KMSS_Parameter_StylePath}icons/up.gif"
			alt="up" onclick="DocList_MoveRow(-1);" style="cursor: hand">
			<img src="${KMSS_Parameter_StylePath}icons/down.gif" alt="down"
			onclick="DocList_MoveRow(1);" style="cursor: hand">
		
				<img
			src="${KMSS_Parameter_StylePath}icons/delete.gif" alt="del"
			onclick="DocList_DeleteRow();" style="cursor: hand">
			--%></td>
			</tr>

			<!--内容行-->
			<c:forEach items="${tibSapSyncJobForm.fdSapInfoForms}"
				var="fdSapInfoForm" varStatus="vstatus">
				<tr KMSS_IsContentRow="1">
					<td>${vstatus.index+1}</td>
					<td><input type="hidden"
						name="fdSapInfoForms[${vstatus.index}].fdSendType"
						value="${fdSapInfoForm.fdSendType}" /> <!--是否启用文件传输--> <input
						type="hidden" name="fdSapInfoForms[${vstatus.index}].fdUse"
						value="${fdSapInfoForm.fdUse}" /> <!--是否启用--> <input type="hidden"
						name="fdSapInfoForms[${vstatus.index}].fdQuartzTime"
						value="${fdSapInfoForm.fdQuartzTime}" /> <!--时间--> <input
						type="hidden" name="fdSapInfoForms[${vstatus.index}].fdQuartzId"
						value="${tibSapSyncJobForm.fdId}" /> <!-- 定时任务id --> <input
						type="hidden" name="fdSapInfoForms[${vstatus.index}].fdQuartzName"
						value="${tibSapSyncJobForm.fdSubject}" /> <!-- 定时任务名称 --> <input
						type="hidden" name="fdSapInfoForms[${vstatus.index}].fdId"
						value="${fdSapInfoForm.fdId}" /> <input type="hidden"
						name="fdSapInfoForms[${vstatus.index}].fdRfcSettingId"
						value="${fdSapInfoForm.fdRfcSettingId}" /> <input type="hidden"
						name="fdSapInfoForms[${vstatus.index}].fdInvokeType"
						value="${fdSapInfoForm.fdInvokeType}" /> <input type="hidden"
						name="fdSapInfoForms[${vstatus.index}].fdRfcXml"
						value='${fdSapInfoForm.fdRfcXml}' />
					<!--传入参数json字符串--> <input type="hidden"
						name="fdSapInfoForms[${vstatus.index}].fdEditorTime"
						value="${fdSapInfoForm.fdEditorTime}" />
					<!--传出参数json字符串--> <input type="text"
						name="fdSapInfoForms[${vstatus.index}].fdRfcSettingName"
						value="${fdSapInfoForm.fdRfcSettingName}" readOnly
						class="inputread"></td>
					<td><input type="text"
						name="fdSapInfoForms[${vstatus.index}].fdFuncMark"
						value="${fdSapInfoForm.fdFuncMark}" readOnly class="inputread">
					</td>
					<td><img
						src="${KMSS_Parameter_StylePath}icons/userinfo_icon.gif"
						title="查看" onclick="editFormEventFunction('${vstatus.index}');"
						style="cursor: hand"> <%-- 
			<img src="${KMSS_Parameter_StylePath}icons/up.gif"
			alt="up" onclick="DocList_MoveRow(-1);" style="cursor: hand">
			<img src="${KMSS_Parameter_StylePath}icons/down.gif" alt="down"
			onclick="DocList_MoveRow(1);" style="cursor: hand">
		    <img src="${KMSS_Parameter_StylePath}icons/delete.gif" alt="del"
			onclick="DocList_DeleteRow();" style="cursor: hand">
			--%></td>
				</tr>
			</c:forEach>

		</table></td>
	<script>
		
	<%-- 
//得到函数对应xml格式数据信息
function getXml(){
	var fdRfcSettingId=$("#fdRfcSettingId").val();
	if(fdRfcSettingId==null||fdRfcSettingId=="")return;
	var data = new KMSSData();
	data.SendToBean("tibSapMappingFuncXmlService&fdRfcSettingId="+fdRfcSettingId,resetTable);
}
--%>
		//编辑函数信息
		function editFormEventFunction(index) {
			var funcObject = {
				"fdSendType" : $(
						'input[name="fdSapInfoForms[' + index
								+ '].fdSendType"]').val(),
				"fdUse" : $('input[name="fdSapInfoForms[' + index + '].fdUse"]')
						.val(),
				"fdEditorTime" : $(
						'input[name="fdSapInfoForms[' + index
								+ '].fdEditorTime"]').val(),
				"fdQuartzId" : $(
						'input[name="fdSapInfoForms[' + index
								+ '].fdQuartzId"]').val(),
				"fdQuartzName" : $(
						'input[name="fdSapInfoForms[' + index
								+ '].fdQuartzName"]').val(),
				"fdQuartzTime" : $(
						'input[name="fdSapInfoForms[' + index
								+ '].fdQuartzTime"]').val(),
				"fdFuncMark" : $(
						'input[name="fdSapInfoForms[' + index
								+ '].fdFuncMark"]').val(),
				"fdRfcSettingName" : $(
						'input[name="fdSapInfoForms[' + index
								+ '].fdRfcSettingName"]').val(),
				"fdRfcSettingId" : $(
						'input[name="fdSapInfoForms[' + index
								+ '].fdRfcSettingId"]').val(),
				"fdInvokeType" : $(
						'input[name="fdSapInfoForms[' + index
								+ '].fdInvokeType"]').val(),
				"fdRfcXml" : $(
						'input[name="fdSapInfoForms[' + index + '].fdRfcXml"]')
						.val()
			//json字符串
			};
			 funcObject.cfg_model="view";//控制阅读
			//	if(funcObject.fdRfcXml=="undefined"||funcObject.fdRfcXml==""){
			//	funcObject.fdRfcXml=
			//	}
			if ((funcObject.fdRfcSettingId != null || funcObject.fdRfcSettingId != "")
					&& (funcObject.fdRfcXml == null || funcObject.fdRfcXml == "")) {
				var data = new KMSSData();
				data
						.SendToBean(
								"tibSapMappingFuncXmlService&fdRfcSettingId="
										+ funcObject.fdRfcSettingId,
								function(rtnData) {
									if (rtnData.GetHashMapArray().length == 0)
										return;
									funcObject.fdRfcXml = rtnData
											.GetHashMapArray()[0]["funcXml"];
									window
											.showModalDialog(
													"../tib_sap_sync_temp_func/tibSapSyncTempFunc_view.jsp?fdInvokeType=4",
													funcObject,
													"dialogWidth=1000px;dialogHeight=600px");
									resetFormEventField(funcObject, index);
								});
			} else {
				window
						.showModalDialog(
								"../tib_sap_sync_temp_func/tibSapSyncTempFunc_view.jsp?fdInvokeType=4",
								funcObject,
								"dialogWidth=1000px;dialogHeight=600px");
				resetFormEventField(funcObject, index);

			}

			//重置字段值

		}

		//编辑函数后重置字段值
		function resetFormEventField(funcObject, index) {
			$('input[name="fdSapInfoForms[' + index + '].fdSendType"]').val(
					funcObject.fdSendType), $(
					'input[name="fdSapInfoForms[' + index + '].fdUse"]').val(
					funcObject.fdUse), $(
					'input[name="fdSapInfoForms[' + index + '].fdEditorTime"]')
					.val(funcObject.fdEditorTime), $(
					'input[name="fdSapInfoForms[' + index + '].fdQuartzId"]')
					.val(funcObject.fdQuartzId), $(
					'input[name="fdSapInfoForms[' + index + '].fdFuncMark"]')
					.val(funcObject.fdFuncMark), $(
					'input[name="fdSapInfoForms[' + index + '].fdQuartzTime"]')
					.val(funcObject.fdQuartzTime), $(
					'input[name="fdSapInfoForms[' + index + '].fdFuncMark"]')
					.val(funcObject.fdFuncMark), $(
					'input[name="fdSapInfoForms[' + index
							+ '].fdRfcSettingName"]').val(
					funcObject.fdRfcSettingName), $(
					'input[name="fdSapInfoForms[' + index
							+ '].fdRfcSettingId"]').val(
					funcObject.fdRfcSettingId), $(
					'input[name="fdSapInfoForms[' + index + '].fdInvokeType"]')
					.val(funcObject.fdInvokeType), $(
					'input[name="fdSapInfoForms[' + index + '].fdRfcXml"]')
					.val(funcObject.fdRfcXml);
		}
	</script>

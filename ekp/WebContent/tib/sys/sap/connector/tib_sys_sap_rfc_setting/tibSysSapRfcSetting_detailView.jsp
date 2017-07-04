<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script>
Com_IncludeFile("calendar.js|dialog.js|doclist.js|optbar.js|data.js|jquery.js|json2.js");
</script>
<script>

	window.onload = function() {
		setTimeout("Work_init()", 200);
	}
	function Work_init() {
		// var obj = window.dialogArguments;
		if (!!window.ActiveXObject || "ActiveXObject" in window) {
			funcObject = window.parent.dialogArguments;
		} else {
			// Firefox浏览器（画面自提交后，window.dialogArguments会丢失，同时window.opener属性存在），  
			if (window.parent.opener.funcObject == undefined) {
				window.parent.opener.funcObject = window.parent.dialogArguments;
			}
			funcObject = window.parent.opener.funcObject;
		}

		if (funcObject.nodeName == "structure") {
			funcObject = funcObject.childNodes;
		}
		if (funcObject.nodeName == "table") {
			funcObject = funcObject.childNodes[0].childNodes;
		}
		// 初始化显示顺序字段
		var optionArray = new Array();
		optionArray.push("<option value=''>=请选择=</option>");
		var Len = funcObject.length;
		for ( var i = 0; i < Len; i++) {
			DocList_AddRow("TABLE_DocList");
			// 组装显示顺序
			if (i == 0) {
				optionArray.push("<option value='1'>1(显示值)</option>");
			} else if (i == 1) {
				optionArray.push("<option value='2'>2(实际值)</option>");
			} else if (i == 2) {
				optionArray.push("<option value='3'>3(描述值)</option>");
			} else {
				optionArray.push("<option value='"+ (i+1) +"'>"+ (i+1) +"</option>");
			}
			if (funcObject[i].nodeName == "field") {
				document.getElementsByName("tibSysSapRfcImport[" + i
						+ "].fdParameterName")[0].value = funcObject[i]
						.getAttribute("name");
				document.getElementsByName("tibSysSapRfcImport[" + i
						+ "].fdParameterType")[0].value = "field";
				document.getElementsByName("tibSysSapRfcImport[" + i
						+ "].fdParameterLength")[0].value = funcObject[i]
						.getAttribute("maxlength");
				document.getElementsByName("tibSysSapRfcImport[" + i
						+ "].fdParameterTypeName")[0].value = funcObject[i]
						.getAttribute("ctype");
				if (funcObject[i].getAttribute("isoptional") == "true")
					document.getElementsByName("tibSysSapRfcImport[" + i
							+ "].fdParameterRequired")[0].checked = true;
				else
					document.getElementsByName("tibSysSapRfcImport[" + i
							+ "].fdParameterRequired")[1].checked = true;
				if (funcObject[i].getAttribute("use") == "true")
					document.getElementsByName("tibSysSapRfcImport[" + i
							+ "].fdParameterUse")[0].checked = true;
				else
					document.getElementsByName("tibSysSapRfcImport[" + i
							+ "].fdParameterUse")[1].checked = true;
				//document.getElementsByName("tibSysSapRfcImport["+i+"].fdParameterMark")[0].value=funcObject[i].getAttribute("title");
				document.getElementById("tibSysSapRfcImport[" + i
						+ "].fdParameterMark").innerHTML = funcObject[i]
						.getAttribute("title");
			}
		}
		$("select[name$='.fdDisp']").html(optionArray);
		$("select[name$='.fdDisp']").each(function(i){
			var defaultValue = funcObject[i].getAttribute("disp");
			$(this).val(defaultValue);
		});
	}
</script>
<html:form action="/tib/sys/sap/connector/tib_sys_sap_rfc_setting/tibSysSapRfcSetting.do">
	<div id="optBarDiv">
	<input type="button" value="<bean:message key="button.close"/>"
		onclick="window.close();"></div>

	<p class="txttitle"><bean:message bundle="tib-sys-sap-connector"
		key="table.tibSysSapRfcSetting" /></p>

	<center>
	<table class="tb_normal" width=95% id="TABLE_DocList">
		<tr>
			<td class="td_normal_title" width="10%"><bean:message
				bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterUse" /></td>
			<td class="td_normal_title" width="13%"><bean:message
				bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterName" /></td>
			<td class="td_normal_title" width="8%"><bean:message
				bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterType" /></td>
			<td class="td_normal_title" width="8%"><bean:message
				bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterLength" /></td>
			<td class="td_normal_title" width="8%"><bean:message
				bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterTypeName" /></td>
			<td class="td_normal_title" width="10%"><bean:message
				bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterRequired" /></td>
			<td class="td_normal_title" width="10%"><bean:message
				bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.disp" /></td>
			<td class="td_normal_title" width="20%"><bean:message
				bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterMark" /></td>
		</tr>
		<tr KMSS_IsReferRow="1" style="display: none">
		<td>
			<input type="radio"  name="tibSysSapRfcImport[!{index}].fdParameterUse" value="true" disabled>是
            <input type="radio"  name="tibSysSapRfcImport[!{index}].fdParameterUse" value="false" disabled>否
                </td>
			<td><input type="text"
				name="tibSysSapRfcImport[!{index}].fdParameterName" 
				value="${tibSysSapRfcImportForm.fdParameterName}" style="width: 85%; border: 0px solid #000000;"
				readonly="readonly"></td>
			<td><input type="hidden" name="tibSysSapRfcImport[!{index}].fdId"
				value="${tibSysSapRfcImportForm.fdId}"> <input type="hidden"
				name="tibSysSapRfcImport[!{index}].fdFunction"
				value="${tibSysSapRfcSettingForm.fdId}"> <input type="text"
				name="tibSysSapRfcImport[!{index}].fdParameterType" 
				value="${tibSysSapRfcImportForm.fdParameterType}" style="width: 85%; border: 0px solid #000000;"
				readonly="readonly"></td>
			<td><input type="text"
				name="tibSysSapRfcImport[!{index}].fdParameterLength" 
				value="${tibSysSapRfcImportForm.fdParameterLength}" style="width: 85%; border: 0px solid #000000;"
				readonly="readonly"></td>
			<td><input type="text"
				name="tibSysSapRfcImport[!{index}].fdParameterTypeName" 
				value="${tibSysSapRfcImportForm.fdParameterTypeName}" style="width: 85%; border: 0px solid #000000;"
				readonly="readonly"></td>
			<td><input type="radio"  name="tibSysSapRfcImport[!{index}].fdParameterRequired" value="true" disabled>是
                <input type="radio"  name="tibSysSapRfcImport[!{index}].fdParameterRequired" value="false" disabled>否
			</td>
			<td><select disabled="true" name="tibSysSapRfcImport[!{index}].fdDisp"></select></td>
			<td>
				<div id="tibSysSapRfcImport[!{index}].fdParameterMark"></div>
			</td>
		</tr>
		<c:forEach items="${tibSysSapRfcSettingForm.tibSysSapRfcImport}"
			var="tibSysSapRfcImportForm" varStatus="vstatus">
			<tr KMSS_IsContentRow="1">
				<td>
				<input type="radio"  name="tibSysSapRfcImport[${vstatus.index}].fdParameterUse" value="true" disabled>是
                <input type="radio"  name="tibSysSapRfcImport[${vstatus.index}].fdParameterUse" value="false" disabled>否
				</td>
				<td><input type="text"
					name="tibSysSapRfcImport[${vstatus.index}].fdParameterName"
					 value="${tibSysSapRfcImportForm.fdParameterName}"
					style="width: 85%; border: 0px solid #000000;" readonly="readonly"></td>
				<td><input type="hidden"
					name="tibSysSapRfcImport[${vstatus.index}].fdId"
					value="${tibSysSapRfcImportForm.fdId}"> <input type="hidden"
					name="tibSysSapRfcImport[${vstatus.index}].fdFunction"
					value="${tibSysSapRfcSettingForm.fdId}"> <input type="text"
					name="tibSysSapRfcImport[${vstatus.index}].fdParameterType"
					 value="${tibSysSapRfcImportForm.fdParameterType}"
					style="width: 85%; border: 0px solid #000000;" readonly="readonly"></td>
				<td><input type="text"
					name="tibSysSapRfcImport[${vstatus.index}].fdParameterLength"
					 value="${tibSysSapRfcImportForm.fdParameterLength}"
					style="width: 85%; border: 0px solid #000000;" readonly="readonly"></td>
				<td><input type="text"
					name="tibSysSapRfcImport[${vstatus.index}].fdParameterTypeName"
					 value="${tibSysSapRfcImportForm.fdParameterTypeName}"
					style="width: 85%; border: 0px solid #000000;" readonly="readonly"></td>
				<td><sunbor:enums
					property="tibSysSapRfcImport[${vstatus.index}].fdParameterRequired"
					enumsType="common_yesno" elementType="radio" bundle="sys-common" /></td>
				<td><input type="text"
					name="tibSysSapRfcImport[${vstatus.index}].fdParameterMark"
					 value="${tibSysSapRfcImportForm.fdParameterMark}"
					style="width: 85%; border: 0px solid #000000;" readonly="readonly"></td>
			</tr>
		</c:forEach>
	</table>
	</center>
	<html:hidden property="fdId" />
	<html:hidden property="method_GET" />
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>

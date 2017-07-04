<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script>
Com_IncludeFile("calendar.js|dialog.js|doclist.js|optbar.js|data.js|jquery.js|json2.js");
</script>

<html:form action="/tib/sys/sap/connector/tib_sys_sap_rfc_setting/tibSysSapRfcSetting.do">
	<div id="optBarDiv"><input type=button
		value="<bean:message key="button.save"/>" onclick="detail_save();">
	<input type="button" value="<bean:message key="button.close"/>"
		onclick="window.close();"></div>

	<p class="txttitle"><bean:message bundle="tib-sys-sap-connector"
		key="table.tibSysSapRfcSetting" /></p>

	<center>
	<table class="tb_normal" width=95% id="TABLE_DocList">
		<tr>
			<td class="td_normal_title" width="10%">
			 <input id="rfc_field" on_change_rfcfield="choiceSelect(source,this)" type="checkbox"/>
			<bean:message
				bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterUse" /></td>
			<td class="td_normal_title" width="13%"><bean:message
				bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterName" /></td>
			<td class="td_normal_title" width="8%"><bean:message
				bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterType" /></td>
			<td class="td_normal_title" width="8%"><bean:message
				bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterLength" /></td>
			<td class="td_normal_title" width="8%"><bean:message
				bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterTypeName" /></td>
			<td class="td_normal_title" width="10%">
			<input id="rfc_required" on_change_required="choiceSelect(source,this)" type="checkbox"/>
			<bean:message
				bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterRequired" /></td>
			<td class="td_normal_title" width="10%"><bean:message
				bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.disp" /></td>
			<td class="td_normal_title" width="20%"><bean:message
				bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterMark" /></td>
		</tr>
		<tr KMSS_IsReferRow="1" style="display: none">
			<td>
			<sunbor:enums  htmlElementProperties="on_change_rfcfield=\"choiceSelect(source,this)\"" 
				property="tibSysSapRfcImport[!{index}].fdParameterUse"
				enumsType="common_yesno" elementType="radio" bundle="sys-common" /> 
			
			</td>
			<td><input type="text"
				name="tibSysSapRfcImport[!{index}].fdParameterName"
				value="${tibSysSapRfcImportForm.fdParameterName}"
				style="width: 85%; border: 0px solid #000000;" readonly="readonly"></td>
			<td><input type="hidden" name="tibSysSapRfcImport[!{index}].fdId"
				value="${tibSysSapRfcImportForm.fdId}"> <input type="hidden"
				name="tibSysSapRfcImport[!{index}].fdFunction"
				value="${tibSysSapRfcSettingForm.fdId}"> <input type="text"
				name="tibSysSapRfcImport[!{index}].fdParameterType"
				value="${tibSysSapRfcImportForm.fdParameterType}"
				style="width: 85%; border: 0px solid #000000;" readonly="readonly"></td>
			<td><input type="text"
				name="tibSysSapRfcImport[!{index}].fdParameterLength"
				value="${tibSysSapRfcImportForm.fdParameterLength}"
				style="width: 85%; border: 0px solid #000000;" readonly="readonly"></td>
			<td><input type="text"
				name="tibSysSapRfcImport[!{index}].fdParameterTypeName"
				value="${tibSysSapRfcImportForm.fdParameterTypeName}"
				style="width: 85%; border: 0px solid #000000;" readonly="readonly"></td>
			<td><sunbor:enums htmlElementProperties="on_change_required=\"choiceSelect(source,this)\"" 
				property="tibSysSapRfcImport[!{index}].fdParameterRequired"
				enumsType="common_yesno" elementType="radio" bundle="sys-common" />
			</td>
			<td><select name="tibSysSapRfcImport[!{index}].fdDisp"></select></td>
			<td><input type="text"
				name="tibSysSapRfcImport[!{index}].fdParameterMark"
				value="${tibSysSapRfcImportForm.fdParameterMark}"
				style="width: 85%; border: 0px solid #000000;" readonly="readonly"></td>

		</tr>
		<c:forEach items="${tibSysSapRfcSettingForm.tibSysSapRfcImport}"
			var="tibSysSapRfcImportForm" varStatus="vstatus">
			<tr KMSS_IsContentRow="1">
				<td><sunbor:enums htmlElementProperties="on_change_rfcfield=\"choiceSelect(source,this)\""
					property="tibSysSapRfcImport[${vstatus.index}].fdParameterUse"
					enumsType="common_yesno" elementType="radio" bundle="sys-common" /></td>
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
					property="tibSysSapRfcImport[${vstatus.index}].fdParameterRequired" htmlElementProperties="on_change_required=\"choiceSelect(source,this)\"" 
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
<script>
	$KMSSValidation();
	Com_IncludeFile("eventbus.js");
</script>

<script>

	window.onload = function() {
		setTimeout("Work_init()", 200);
	};
	
	function Work_init() {
		var obj = window.dialogArguments;
		if (obj.nodeName == "structure") {
			obj = obj.childNodes;
		}
		if (obj.nodeName == "table") {
			obj = obj.childNodes[0].childNodes;
		}
		// 初始化显示顺序字段
		var optionArray = new Array();
		optionArray.push("<option value=''>=请选择=</option>");
		var Len = obj.length;
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
			//if (obj[i].nodeName == "field") {
			var fieldObj = obj[i];
				document.getElementsByName("tibSysSapRfcImport[" + i
						+ "].fdParameterName")[0].value = fieldObj
						.getAttribute("name");
				document.getElementsByName("tibSysSapRfcImport[" + i
						+ "].fdParameterType")[0].value = "field";
				document.getElementsByName("tibSysSapRfcImport[" + i
						+ "].fdParameterLength")[0].value = fieldObj
						.getAttribute("maxlength");
				document.getElementsByName("tibSysSapRfcImport[" + i
						+ "].fdParameterTypeName")[0].value = fieldObj
						.getAttribute("ctype");
				if (fieldObj.getAttribute("isoptional") == "true")
					document.getElementsByName("tibSysSapRfcImport[" + i
							+ "].fdParameterRequired")[0].checked = true;
				else
					document.getElementsByName("tibSysSapRfcImport[" + i
							+ "].fdParameterRequired")[1].checked = true;
				if (fieldObj.getAttribute("use") == "true")
					document.getElementsByName("tibSysSapRfcImport[" + i
							+ "].fdParameterUse")[0].checked = true;
				else
					document.getElementsByName("tibSysSapRfcImport[" + i
							+ "].fdParameterUse")[1].checked = true;
				document.getElementsByName("tibSysSapRfcImport[" + i
						+ "].fdParameterMark")[0].value = fieldObj
						.getAttribute("title");
			//}
		}
		$("select[name$='.fdDisp']").html(optionArray);
		$("select[name$='.fdDisp']").each(function(i){
			var defaultValue = obj[i].getAttribute("disp");
			$(this).val(defaultValue);
		});
	}

	function detail_save() {
		var obj = window.dialogArguments;
		var len = null;
		if (obj.nodeName == "structure") {
			len = obj.childNodes.length;
			for ( var i = 0; i < len; i++) {
				if (obj.childNodes[i].nodeName == "field") {
					obj.childNodes[i].setAttribute("disp", document.getElementsByName("tibSysSapRfcImport[" + i
							+ "].fdDisp")[0].value);
					if (document.getElementsByName("tibSysSapRfcImport[" + i
							+ "].fdParameterRequired")[0].checked)
						obj.childNodes[i].setAttribute("isoptional", "true");
					else
						obj.childNodes[i].setAttribute("isoptional", "false");
					if (document.getElementsByName("tibSysSapRfcImport[" + i
							+ "].fdParameterUse")[0].checked)
						obj.childNodes[i].setAttribute("use", "true");
					else
						obj.childNodes[i].setAttribute("use", "false");
				}
			}
		}
		if (obj.nodeName == "table") {
			len = obj.childNodes[0].childNodes.length;
			for ( var i = 0; i < len; i++) {

				if (obj.childNodes[0].childNodes[i].nodeName == "field") {
					obj.childNodes[0].childNodes[i].setAttribute("disp", document.getElementsByName("tibSysSapRfcImport[" + i
							+ "].fdDisp")[0].value);
					if (document.getElementsByName("tibSysSapRfcImport[" + i
							+ "].fdParameterRequired")[0].checked)
						obj.childNodes[0].childNodes[i].setAttribute(
								"isoptional", "true");
					else
						obj.childNodes[0].childNodes[i].setAttribute(
								"isoptional", "false");
					if (document.getElementsByName("tibSysSapRfcImport[" + i
							+ "].fdParameterUse")[0].checked)
						obj.childNodes[0].childNodes[i].setAttribute("use",
								"true");
					else
						obj.childNodes[0].childNodes[i].setAttribute("use",
								"false");
				}
			}
		}

		window.returnValue = (obj);
		window.close();

	}

	function checkReturn(index) {
		if (document.getElementById("tibSysSapRfcImport[" + index + "].check").style.display == "") {
			document.getElementById("tibSysSapRfcImport[" + index + "].check").style.display = "none";
			document.getElementsByName("tibSysSapRfcImport[" + index
					+ "].fdSuccess")[0].value = "";
			document.getElementsByName("tibSysSapRfcImport[" + index
					+ "].fdFail")[0].value = "";
		} else {
			document.getElementById("tibSysSapRfcImport[" + index + "].check").style.display = "";
			document.getElementsByName("tibSysSapRfcImport[" + index
					+ "].fdSuccess")[0].value = "";
			document.getElementsByName("tibSysSapRfcImport[" + index
					+ "].fdFail")[0].value = "";
		}

	}

	function choiceSelect(source, curElem) {
		if (source.id != 'rfc_field' && source.id != 'rfc_required') {
			return;
		}
		if (source.checked) {
			if (curElem.value == 'true' || curElem.value == '1') {
				curElem.checked = true;
			}
		} else {
			if (curElem.value == 'false' || curElem.value == '0') {
				curElem.checked = true;
			}
		}
	}
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>

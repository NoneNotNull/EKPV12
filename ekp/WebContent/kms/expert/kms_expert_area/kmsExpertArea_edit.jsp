<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script type="text/javascript" src="${KMSS_Parameter_ResPath}js/common.js"></script>
<script>
	Com_IncludeFile("data.js|dialog.js");
</script>
<tr height="40px">
	<th >${param.areaMessage }：</th>
	<td ><html:hidden
		property="fdKmsExpertAreaListForms[${param.index}].fdCategoryId"
		value="${kmsExpertInfoForm.fdKmsExpertAreaListForms[param.index].fdCategoryId}" />
	<html:text
		property="fdKmsExpertAreaListForms[${param.index}].fdCategoryName"
		readonly="true" styleClass="i_b"
		value="${kmsExpertInfoForm.fdKmsExpertAreaListForms[param.index].fdCategoryName}" />
	<a href="#" id="selectAreaNames[${param.index}]">选择领域</a></td>
	<html:hidden
		property="fdKmsExpertAreaListForms[${param.index}].fdModelName"
		value="${param.fdModelName }" />
	<html:hidden property="fdKmsExpertAreaListForms[${param.index}].fdKey"
		value="${param.fdKey }" />
</tr>
<script>
	function selectAreaNames() {
		Dialog_Tree(true,
				'fdKmsExpertAreaListForms[${param.index}].fdCategoryId',
				'fdKmsExpertAreaListForms[${param.index}].fdCategoryName', ';',
				'${param.treeBean}&selectId=!{value}',
				'<bean:message key="table.kmsExpertArea" bundle="kms-expert"/>');
	}
	var addEvent = function(obj, evt, func) {
		if (obj.addEventListener) { // DOM2
			obj.addEventListener(evt, func, false);
		} else if (obj.attachEvent) { // IE5+
			obj.attachEvent('on' + evt, func);
		} else { // DOM0
			obj['on' + evt] = func;
		}
	};
	addEvent(document.getElementById("selectAreaNames[${param.index}]"),
			'click', selectAreaNames);
</script>
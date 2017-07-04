<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script type="text/javascript">
Com_IncludeFile("jquery.js|json2.js|dialog.js|formula.js|xml.js|doclist.js");
</script>
<script>
function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
var RfcSearchInfo_lang = {
    serialNumber : "<bean:message bundle="tib-sys-sap-connector" key="rfcSearchInfo.lang.serialNumber"/>",
    field : "<bean:message bundle="tib-sys-sap-connector" key="rfcSearchInfo.lang.field"/>",
    formation : "<bean:message bundle="tib-sys-sap-connector" key="rfcSearchInfo.lang.formation"/>"
};
</script>

<script type="text/javascript" src="view_result.js"></script>
<div id="optBarDiv">
		<input type="button"
		value="<bean:message bundle="tib-sys-sap-connector" key="rfcSearchInfo.lang.saveAs"/>"
		onclick="SaveByExcel()">
	
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<html:form action="/tib/sys/sap/connector/tib_sys_sap_rfc_search_info/tibSysSapRfcSearchInfo.do">
<input id="fdData_xml" name="fdData" type="hidden" value="${tibSysSapRfcSearchInfoForm.fdDataView}">
<input id="fdRfcId" name="fdRfcId" type="hidden" value="${tibSysSapRfcSearchInfoForm.fdRfcId}">
<input id="docSubjectId" name="docSubject" type="hidden" value="${tibSysSapRfcSearchInfoForm.docSubject}">
</html:form>

<p class="txttitle"><label id="bapiName"></label></p>
<center>
<table id="Label_Tabel"  width=95%>
	<tr LKS_LabelName="<bean:message bundle="tib-sys-sap-connector" key="rfcSearchInfo.lang.inputTable"/>">
				<td>
	<table id="IMPORT_TABLE" class="tb_normal" width="100%" >
	
		<tr class="td_normal_title"  style="">
		<td><bean:message bundle="tib-sys-sap-connector" key="rfcSearchInfo.lang.paramType"/></td>
		<td><bean:message bundle="tib-sys-sap-connector" key="rfcSearchInfo.lang.fieldName"/></td>
		<td><bean:message bundle="tib-sys-sap-connector" key="rfcSearchInfo.lang.fieldExplain"/></td>
		<td><bean:message bundle="tib-sys-sap-connector" key="rfcSearchInfo.lang.fieldValue"/></td>
	</tr>
	<tr class="td_normal_title"  style="">
	<td colspan="4"><bean:message bundle="tib-sys-sap-connector" key="rfcSearchInfo.lang.inputTableList"/></td>
	</tr>
	
</table>
  </td></tr>
<tr LKS_LabelName="<bean:message bundle="tib-sys-sap-connector" key="rfcSearchInfo.lang.outputParam"/>"><td>
		<table id="EXPORT_TABLE" class="tb_normal" width="100%">
		<tr class="td_normal_title"  style="">
		<td><bean:message bundle="tib-sys-sap-connector" key="rfcSearchInfo.lang.paramType"/></td>
		<td><bean:message bundle="tib-sys-sap-connector" key="rfcSearchInfo.lang.fieldName"/></td>
		<td><bean:message bundle="tib-sys-sap-connector" key="rfcSearchInfo.lang.fieldExplain"/></td>
		<td><bean:message bundle="tib-sys-sap-connector" key="rfcSearchInfo.lang.fieldValue"/></td>
	</tr>
</table> 
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>

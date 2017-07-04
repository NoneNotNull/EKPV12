<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@ include file="/sys/xform/include/sysForm_script.jsp"%>
<script type="text/javascript">
Com_IncludeFile("jquery.js|json2.js|dialog.js|formula.js|xml.js|doclist.js");

var RfcSearchInfo_lang = {
    serialNumber : "<bean:message bundle="tib-sys-sap-connector" key="rfcSearchInfo.lang.serialNumber"/>",
    queryTitleNotEmpty : "<bean:message bundle="tib-sys-sap-connector" key="rfcSearchInfo.lang.queryTitleNotEmpty"/>",
    field : "<bean:message bundle="tib-sys-sap-connector" key="rfcSearchInfo.lang.field"/>",
    formation : "<bean:message bundle="tib-sys-sap-connector" key="rfcSearchInfo.lang.formation"/>"
};
</script>
<script type="text/javascript" src="query_edit.js"></script>
<div id="optBarDiv">

   	<input type="button"
		value="<bean:message bundle="tib-sys-sap-connector" key="rfcSearchInfo.lang.queryResult"/>"
		onclick="collectResutlXml();">
		
	<input type="button"
		value="<bean:message key="button.save"/>"
		onclick="formSave()">

	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><label id="bapiName"></label></p>
<center>


<html:form action="/tib/sys/sap/connector/tib_sys_sap_rfc_search_info/tibSysSapRfcSearchInfo.do">
  <table class="tb_normal" width="1024">
	<tr>
		<td class="td_normal_title" width="15%">
			<bean:message bundle="tib-sys-sap-connector" key="rfcSearchInfo.docSubject"/>
		</td><td width="25%">
			<xform:text property="docSubject"  showStatus="edit" style="width:85%" />
		    <div style='display:none' id="docSubject_div" class='validation-advice'></div>
		</td>
		<td class="td_normal_title" width="35%">
			<label><bean:message bundle="tib-sys-sap-connector" key="rfcSearchInfo.lang.setQueryAmount"/>
				<br><bean:message bundle="tib-sys-sap-connector" key="rfcSearchInfo.lang.defaultAmount"/></label>
		</td><td width="25%">
			<input type="text" class="inputsgl" name="rowsize">
		</td>
    </tr>
  </table>

  <input type="hidden" name="fdxml" id="xml_data" value="${tibSysSapRfcSearchInfoForm.fdDataView}"></input>
  <br>
  
  <c:choose>
   <c:when test="${!empty rfcId }"> 
    <input name="fdRfcSetting" id="fdRfcSettingId" type="hidden" value="${rfcId}" />
   </c:when>
   <c:otherwise> 
    <input name="fdRfcSetting" id="fdRfcSettingId" type="hidden" value="${param.rfcId}" />
   </c:otherwise>
   </c:choose>



<input type="hidden" id="formsoure_xml" value="${tibSysSapRfcSearchInfoForm.fdDataView}">

<table id="query_Table" class="tb_normal" width="1024">
	<tr>
		<td id="param">
			<table id="IMPORT_TABLE" class="tb_normal" width="1024" >
			<!-- 固定两行 -->
				<tr class="td_normal_title"  style="">
					<td width="20%" ><bean:message bundle="tib-sys-sap-connector" key="rfcSearchInfo.lang.paramType"/></td>
					<td width="25%" ><bean:message bundle="tib-sys-sap-connector" key="rfcSearchInfo.lang.fieldName"/></td>
					<td width="25%" ><bean:message bundle="tib-sys-sap-connector" key="rfcSearchInfo.lang.fieldExplain"/></td>
					<td width="30%" ><bean:message bundle="tib-sys-sap-connector" key="rfcSearchInfo.lang.fieldValue"/></td>
				</tr>
			<!-- 固定两行 -->
			
			</table>
		     <!-- 用于table类型的参数copy的表格代码 打开时先不显示 动态生成-->
			 <!-- 用于table类型的参数copy的表格代码 -->
		</td>
	</tr>
</table>
<table id="query_Table_append"></table>

</html:form>
</center>



<%@ include file="/resource/jsp/edit_down.jsp"%>

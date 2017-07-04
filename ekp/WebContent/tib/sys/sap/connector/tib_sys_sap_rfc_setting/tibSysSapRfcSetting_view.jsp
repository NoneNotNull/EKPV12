<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>Com_IncludeFile("dialog.js|jquery.js");</script>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
var detailList=[];
var exportList=[];
var importList=[];
var detailjson = {};
function createPhaseWorks(fdId,object){
	return {"fdId":fdId,"work":object};
}
window.onload=function()
{     
      
      setTimeout("Work_init()", 200);     
}
function Work_init()
{    
     var importxml = document.getElementById("TABLE_DocList0");
     var importlen=importxml.rows.length;
     for(var i=1;i<importlen;i++)
    {
   
        if(document.getElementsByName("tibSysSapRfcImport["+(i-1)+"].fdParameterType")[0].value=="structure")
        {   
        var importobject=document.getElementsByName("tibSysSapRfcImport["+(i-1)+"].fdRfcParamXml")[0].value;
        var fdimportId= document.getElementsByName("tibSysSapRfcImport["+(i-1)+"].fdId")[0].value; 
        var doc= initXMLDomFuntion();//new ActiveXObject("Microsoft.XMLDOM");
        doc.loadXML(importobject);
        detailjson = createPhaseWorks(fdimportId,doc.getElementsByTagName("structure")[0]);
        importList[i]=detailjson;
        document.getElementsByName("tibSysSapRfcImport["+(i-1)+"].fdParameterName")[0].style.cursor="pointer";
        document.getElementsByName("tibSysSapRfcImport["+(i-1)+"].fdParameterName")[0].style.color="#0066FF";
       // document.getElementsByName("tibSysSapRfcImport["+(i-1)+"].fdParameterName")[0].attachEvent("onclick",newopen(i,"1"));
         var temp =document.getElementsByName("tibSysSapRfcImport["+(i-1)+"].fdParameterName")[0];
          $(temp).bind("click",newopen(i,"1"));
        }
    }
     var exportxml = document.getElementById("TABLE_DocList1");
     var exportlen=exportxml.rows.length;
     for(var i=1;i<exportlen;i++)
    {
   
        if(document.getElementsByName("tibSysSapRfcExport["+(i-1)+"].fdParameterType")[0].value=="structure")
        {   
        var exportobject=document.getElementsByName("tibSysSapRfcExport["+(i-1)+"].fdRfcParamXml")[0].value;
        var fdexportId= document.getElementsByName("tibSysSapRfcExport["+(i-1)+"].fdId")[0].value; 
        var doc= initXMLDomFuntion();//new ActiveXObject("Microsoft.XMLDOM");
        doc.loadXML(exportobject);
        detailjson = createPhaseWorks(fdexportId,doc.getElementsByTagName("structure")[0]);
        exportList[i]=detailjson;
        document.getElementsByName("tibSysSapRfcExport["+(i-1)+"].fdParameterName")[0].style.cursor="pointer";
        document.getElementsByName("tibSysSapRfcExport["+(i-1)+"].fdParameterName")[0].style.color="#0066FF";
       // document.getElementsByName("tibSysSapRfcExport["+(i-1)+"].fdParameterName")[0].attachEvent("onclick",newopen(i,"2"));
        var temp =document.getElementsByName("tibSysSapRfcExport["+(i-1)+"].fdParameterName")[0];
        $(temp).bind("click",newopen(i,"2"));

        }
    }
     var table = document.getElementById("TABLE_DocList2");
     var tablelen=table.rows.length;
     for(var i=1;i<tablelen;i++)
    {
        var tableobject=document.getElementsByName("tibSysSapRfcTable["+(i-1)+"].fdRfcParamXml")[0].value;
      
        var fdTableId= document.getElementsByName("tibSysSapRfcTable["+(i-1)+"].fdId")[0].value; 
        var doc= initXMLDomFuntion();//new ActiveXObject("Microsoft.XMLDOM");
        doc.loadXML(tableobject);
        detailjson = createPhaseWorks(fdexportId,doc.getElementsByTagName("table")[0]);
        detailList[i]=detailjson;
        document.getElementsByName("tibSysSapRfcTable["+(i-1)+"].fdParameterName")[0].style.cursor="pointer";
         document.getElementsByName("tibSysSapRfcTable["+(i-1)+"].fdParameterName")[0].style.color="#0066FF";
        //document.getElementsByName("tibSysSapRfcTable["+(i-1)+"].fdParameterName")[0].attachEvent("onclick",newopen(i,"3"));
         var temp =document.getElementsByName("tibSysSapRfcTable["+(i-1)+"].fdParameterName")[0];
        $(temp).bind("click",newopen(i,"3"));
        
    }

}

var newopen = function(i,type)
 {
   return function()
    {
   
      detail(i,type);//该函数为外部定义的一个执行函数；
    }
 }
 
function detail(i,type)
{

     var style = "dialogWidth:900px; dialogHeight:700x; status:0;scroll:1; help:0; resizable:1";    
     var url="<c:url value='/tib/sys/sap/connector/tib_sys_sap_rfc_setting/tibSysSapRfcSetting.do?method=detailView'/>"; 
     if(type==3) 
     {
     var rtnVal = window.showModalDialog(Com_Parameter.ContextPath+"resource/jsp/frame.jsp?url="+encodeURIComponent(url),detailList[i].work,style);    
     }
      if(type==2) 
     {
     var rtnVal = window.showModalDialog(Com_Parameter.ContextPath+"resource/jsp/frame.jsp?url="+encodeURIComponent(url),exportList[i].work,style);    
     }
      if(type==1) 
     {
     var rtnVal = window.showModalDialog(Com_Parameter.ContextPath+"resource/jsp/frame.jsp?url="+encodeURIComponent(url),importList[i].work,style);    
     }
}

function query_edit()
{
	var url=Com_Parameter.ContextPath+'tib/sys/sap/connector/tib_sys_sap_rfc_search_info/tibSysSap_rfcSearchInfo_query_edit.jsp?rfcId=${param.fdId}';
	Com_OpenWindow(url);
	}

function initXMLDomFuntion(){

	var doc;
	try {
		// Internet Explorer
		doc = new ActiveXObject("Microsoft.XMLDOM");
	} catch(e) {
		try {
			// Firefox, Mozilla, Opera, etc.
			doc = document.implementation.createDocument("","",null);
	    } catch(e) {alert(e.message)}
	}
	doc.async = false;
	return doc;
}


</script>
<html:form action="/tib/sys/sap/connector/tib_sys_sap_rfc_setting/tibSysSapRfcSetting.do">
	<div id="optBarDiv"><input type="button"
		value="<bean:message bundle="tib-sys-sap-connector" key="table.rfcSearchInfo.query.edit"/>"
		onclick="query_edit();"> <kmss:auth
		requestURL="/tib/sys/sap/connector/tib_sys_sap_rfc_setting/tibSysSapRfcSetting.do?method=edit&fdId=${param.fdId}"
		requestMethod="GET">
		<c:if test="${tibSysSapRfcSettingForm.docIsNewVersion=='true'}">
			<input type="button" value="<bean:message key="button.edit"/>"
				onclick="Com_OpenWindow('tibSysSapRfcSetting.do?method=edit&fdId=${param.fdId}','_self');">
		</c:if>
		<input type="button"
			value="<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcTable.xmlView"/>"
			onclick="Com_OpenWindow('tibSysSapRfcSetting.do?method=xmlView&fdId=${param.fdId}');">
	</kmss:auth> <kmss:auth
		requestURL="/tib/sys/sap/connector/tib_sys_sap_rfc_setting/tibSysSapRfcSetting.do?method=delete&fdId=${param.fdId}"
		requestMethod="GET">
		<c:if test="${tibSysSapRfcSettingForm.docIsNewVersion=='true'}">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!confirmDelete())return;Com_OpenWindow('tibSysSapRfcSetting.do?method=delete&fdId=${param.fdId}','_self');">
		</c:if>
	</kmss:auth> <input type="button" value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();"></div>

	<p class="txttitle"><bean:message bundle="tib-sys-sap-connector"
		key="table.tibSysSapRfcSetting" />
		<c:if test="${isHasNewVersion=='true'}">
			<span style="color:red;font-size:12px;font-weight:normal;"><bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcSetting.hasNewVersion" /></span>
		</c:if>
	</p>
	
	<center>
	<table id="Label_Tabel" width=95%>
		<tr LKS_LabelName="<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcSetting.lang.funcConfig"/>">
			<td>
			<table class="tb_normal" width=100%>
				<tr>
					<td class="td_normal_title" width=15%><bean:message
						bundle="tib-sys-sap-connector" key="tibSysSapRfcSetting.fdFunctionName" /></td>
					<td width="35%" colspan="3"><xform:text
						property="fdFunctionName" style="width:85%" /></td>
				</tr>
				<tr>
					<td class="td_normal_title" width=15%><bean:message
						bundle="tib-sys-sap-connector" key="tibSysSapRfcSetting.docCategory" /></td>
					<td width="35%"><c:out
						value="${tibSysSapRfcSettingForm.docCategoryName}" /></td>
					<td class="td_normal_title" width=15%><bean:message
						bundle="tib-sys-sap-connector" key="tibSysSapRfcSetting.fdPool" /></td>
					<td width="35%"><c:out value="${tibSysSapRfcSettingForm.fdPoolName}" />
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width=15%><bean:message
						bundle="tib-sys-sap-connector" key="tibSysSapRfcSetting.fdUse" /></td>
					<td width="35%"><xform:radio property="fdUse">
						<xform:enumsDataSource enumsType="common_yesno" />
					</xform:radio></td>
					<td class="td_normal_title" width=15%><bean:message
						bundle="tib-sys-sap-connector" key="tibSysSapRfcSetting.fdFunction" /></td>
					<td width="35%"><xform:text property="fdFunction"
						style="width:50%" /></td>
				</tr>
				<tr>
					<td class="td_normal_title" width=15%><bean:message
						bundle="tib-sys-sap-connector" key="tibSysSapRfcSetting.fdWeb" /></td>
					<td width="35%"><xform:radio property="fdWeb">
						<xform:enumsDataSource enumsType="common_yesno" />
					</xform:radio></td>
					<td class="td_normal_title" width=15%><bean:message
						bundle="tib-sys-sap-connector" key="tibSysSapRfcSetting.fdCommit" /></td>
					<td width="35%"><xform:radio property="fdCommit">
						<xform:enumsDataSource enumsType="sap_no" />
					</xform:radio></td>
				</tr>
				<tr>
					<td class="td_normal_title" width=15%><bean:message
						bundle="tib-common-log" key="tibCommonLogMain.fdImportPar" /></td>
					<td width=35% colspan="3">
					<table class="tb_normal" width=100% id="TABLE_DocList0">
						<tr>
							<td class="td_normal_title" width="10%"><bean:message
								bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterUse" /></td>
							<td class="td_normal_title" width="15%"><bean:message
								bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterName" /></td>
							<td class="td_normal_title" width="15%"><bean:message
								bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterType" /></td>
							<td class="td_normal_title" width="10%"><bean:message
								bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterLength" /></td>
							<td class="td_normal_title" width="10%"><bean:message
								bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterTypeName" /></td>
							<td class="td_normal_title" width="10%"><bean:message
								bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterRequired" /></td>
							<td class="td_normal_title" width="30%"><bean:message
								bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterMark" /></td>
						</tr>
						<c:forEach items="${tibSysSapRfcSettingForm.tibSysSapRfcImport}"
							var="tibSysSapRfcImportForm" varStatus="vstatus">
							<tr KMSS_IsContentRow="1">
								<td><xform:radio
									property="tibSysSapRfcImport[${vstatus.index}].fdParameterUse">
									<xform:enumsDataSource enumsType="common_yesno" />
								</xform:radio></td>
								<td><input type="text"
									name="tibSysSapRfcImport[${vstatus.index}].fdParameterName"
									value="${tibSysSapRfcImportForm.fdParameterName}"
									style="width: 85%; border: 0px solid #000000;"
									readonly="readonly"></td>
								<td><input type="hidden"
									name="tibSysSapRfcImport[${vstatus.index}].fdId"
									value="${tibSysSapRfcImportForm.fdId}"> <input type="hidden"
									name="tibSysSapRfcImport[${vstatus.index}].fdFunctionId"
									value="${tibSysSapRfcImportForm.fdFunctionId}"> <input
									type="text"
									name="tibSysSapRfcImport[${vstatus.index}].fdParameterType"
									value="${tibSysSapRfcImportForm.fdParameterType}"
									style="width: 85%; border: 0px solid #000000;"
									readonly="readonly"></td>
								<td><input type="text"
									name="tibSysSapRfcImport[${vstatus.index}].fdParameterLength"
									value="${tibSysSapRfcImportForm.fdParameterLength}"
									style="width: 85%; border: 0px solid #000000;"
									readonly="readonly"></td>
								<td><input type="text"
									name="tibSysSapRfcImport[${vstatus.index}].fdParameterTypeName"
									value="${tibSysSapRfcImportForm.fdParameterTypeName}"
									style="width: 85%; border: 0px solid #000000;"
									readonly="readonly"></td>
								<td><xform:radio
									property="tibSysSapRfcImport[${vstatus.index}].fdParameterRequired">
									<xform:enumsDataSource enumsType="common_yesno" />
								</xform:radio></td>
								<td><input type="hidden"
									name="tibSysSapRfcImport[${vstatus.index}].fdRfcParamXml"
									value="${tibSysSapRfcImportForm.fdRfcParamXmlView}"> <input
									type="text"
									name="tibSysSapRfcImport[${vstatus.index}].fdParameterMark"
									value="${tibSysSapRfcImportForm.fdParameterMark}"
									style="width: 85%; border: 0px solid #000000;"
									readonly="readonly"></td>
							</tr>
						</c:forEach>
					</table>
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width=15%><bean:message
						bundle="tib-common-log" key="tibCommonLogMain.fdExportPar" /></td>
					<td width=35% colspan="3">
					<table class="tb_normal" width=100% id="TABLE_DocList1">
						<tr>
							<td class="td_normal_title" width="10%"><bean:message
								bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterUse" /></td>
							<td class="td_normal_title" width="15%"><bean:message
								bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterName" /></td>
							<td class="td_normal_title" width="15%"><bean:message
								bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterType" /></td>
							<td class="td_normal_title" width="10%"><bean:message
								bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterTypeName" /></td>
							<td class="td_normal_title" width="20%"><bean:message
								bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterMark" /></td>
							<td class="td_normal_title" width="20%"><bean:message
								bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdReturnType" /></td>
						</tr>
						<c:forEach items="${tibSysSapRfcSettingForm.tibSysSapRfcExport}"
							var="tibSysSapRfcExportForm" varStatus="vstatus">
							<tr KMSS_IsContentRow="1">
								<td><xform:radio
									property="tibSysSapRfcExport[${vstatus.index}].fdParameterUse">
									<xform:enumsDataSource enumsType="common_yesno" />
								</xform:radio></td>
								<td><input type="text"
									name="tibSysSapRfcExport[${vstatus.index}].fdParameterName"
									value="${tibSysSapRfcExportForm.fdParameterName}"
									style="width: 85%; border: 0px solid #000000;"
									readonly="readonly"></td>
								<td><input type="hidden"
									name="tibSysSapRfcExport[${vstatus.index}].fdId"
									value="${tibSysSapRfcExportForm.fdId}"> <input type="hidden"
									name="tibSysSapRfcExport[${vstatus.index}].fdFunctionId"
									value="${tibSysSapRfcExportForm.fdFunctionId}"> <input
									type="text"
									name="tibSysSapRfcExport[${vstatus.index}].fdParameterType"
									value="${tibSysSapRfcExportForm.fdParameterType}"
									style="width: 85%; border: 0px solid #000000;"
									readonly="readonly"></td>
								<td><input type="text"
									name="tibSysSapRfcExport[${vstatus.index}].fdParameterTypeName"
									value="${tibSysSapRfcExportForm.fdParameterTypeName}"
									style="width: 85%; border: 0px solid #000000;"
									readonly="readonly"></td>
								<td><input type="hidden"
									name="tibSysSapRfcExport[${vstatus.index}].fdRfcParamXml"
									value="${tibSysSapRfcExportForm.fdRfcParamXmlView}"><input
									type="text"
									name="tibSysSapRfcExport[${vstatus.index}].fdParameterMark"
									value="${tibSysSapRfcExportForm.fdParameterMark}"
									style="width: 85%; border: 0px solid #000000;"
									readonly="readonly"></td>
								<td><c:if test="${tibSysSapRfcExportForm.fdReturnFlag=='1'}">
									<div align="left" style="display:''"
										id="tibSysSapRfcExport[!{index}].check">
										<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcSetting.lang.success"/>
										<input type="text"
										name="tibSysSapRfcExport[!{index}].fdSuccess"
										value="${tibSysSapRfcExportForm.fdSuccess}" style=" border: 0px solid #000000;">
									<br>
									<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcSetting.lang.fail"/>
									<input type="text" name="tibSysSapRfcExport[!{index}].fdFail"
										value="${tibSysSapRfcExportForm.fdFail}" style="border: 0px solid #000000;"></div>
								</c:if></td>
							</tr>
						</c:forEach>
					</table>
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width=15%><bean:message
						bundle="tib-sys-sap-connector" key="table.tibSysSapRfcTable" /></td>
					<td width=35% colspan="3">
					<table class="tb_normal" width=100% id="TABLE_DocList2">
						<tr>
							<td class="td_normal_title" width="10%"><bean:message
								bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterUse" /></td>
							<td class="td_normal_title" width="35%"><bean:message
								bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterName" /></td>
							<td class="td_normal_title" width="10%"><bean:message
								bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterType" /></td>
							<td class="td_normal_title" width="15%"><bean:message
								bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdisin" /></td>
							<td class="td_normal_title" width="30%"><bean:message
								bundle="tib-sys-sap-connector" key="tibSysSapRfcImport.fdParameterMark" /></td>
						</tr>
						<c:forEach items="${tibSysSapRfcSettingForm.tibSysSapRfcTable}"
							var="tibSysSapRfcTableForm" varStatus="vstatus">
							<tr KMSS_IsContentRow="1">
								<td><input type="hidden"
									name="tibSysSapRfcTable[${vstatus.index}].fdRfcParamXml"
									value="${tibSysSapRfcTableForm.fdRfcParamXmlView}"><xform:radio
									property="tibSysSapRfcTable[${vstatus.index}].fdUse">
									<xform:enumsDataSource enumsType="common_yesno" />
								</xform:radio></td>
								<td><input type="text"
									name="tibSysSapRfcTable[${vstatus.index}].fdParameterName"
									value="${tibSysSapRfcTableForm.fdParameterName}"
									style="width: 85%; border: 0px solid #000000;"
									readonly="readonly"></td>
								<td><input type="hidden"
									name="tibSysSapRfcTable[${vstatus.index}].fdId"
									value="${tibSysSapRfcTableForm.fdId}"> <input type="hidden"
									name="tibSysSapRfcTable[${vstatus.index}].fdFunctionId"
									value="${tibSysSapRfcTableForm.fdFunctionId}"> <input
									type="text"
									name="tibSysSapRfcTable[${vstatus.index}].fdParameterType"
									value="${tibSysSapRfcTableForm.fdParameterType}"
									style="width: 85%; border: 0px solid #000000;"
									readonly="readonly"></td>
								<td><xform:checkbox
									property="tibSysSapRfcTable[${vstatus.index}].fdisin">
									<xform:enumsDataSource enumsType="table_type" />
								</xform:checkbox></td>
								<td><input type="text"
									name="tibSysSapRfcTable[${vstatus.index}].fdMark"
									value="${tibSysSapRfcTableForm.fdMark}"
									style="width: 85%; border: 0px solid #000000;"
									readonly="readonly"></td>

								
							</tr>
						</c:forEach>
					</table>
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width=15%><bean:message
						bundle="tib-sys-sap-connector" key="tibSysSapRfcSetting.fdDescribe" /></td>
					<td width="35%" colspan="3"><xform:text property="fdDescribe"
						style="width:85%" /></td>
				</tr>
			</table>
			</td>
		</tr>
		<c:import url="/sys/edition/include/sysEditionMain_view.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="tibSysSapRfcSettingForm" />

		</c:import>
		<c:import
			url="/tib/sys/sap/connector/tib_sys_sap_rfc_search_info/tibSysSap_rfcSearchInfo_view_history.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="tibSysSapRfcSettingForm" />
		</c:import>


	</table>
	<html:hidden property="docStatus" /> <html:hidden
		property="method_GET" /></center>
</html:form>

<%@ include file="/resource/jsp/view_down.jsp"%>

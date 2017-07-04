<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script>
	Com_IncludeFile("calendar.js|dialog.js|doclist.js|optbar.js|data.js|jquery.js|json2.js");
</script>

<script
	src="${KMSS_Parameter_ContextPath}tib/common/resource/js/custom_validations.js"
	type="text/javascript"></script>
<script type="text/javascript" src="${KMSS_Parameter_ContextPath}tib/sys/sap/connector/resource/js/zDrag.js"></script>
<script type="text/javascript" src="${KMSS_Parameter_ContextPath}tib/sys/sap/connector/resource/js/zDialog.js"></script>
<script>
/************标记修正。。。************
 * 使用国际化的资源文件
 ************************/
 //重新指定zDialog.js中图片路径位置
 var IMAGESPATH = '${KMSS_Parameter_ContextPath}tib/sys/sap/connector/resource/images/';

 
$(function(){
	var spanNode = document.createElement("span");
	spanNode.id = "Include_Custom_Validations_Span_Id";
	document.body.appendChild(spanNode);
	$("#Include_Custom_Validations_Span_Id").load(Com_Parameter.ContextPath +
			"tib/common/resource/jsp/custom_validations.jsp", call_validation);
});

function call_validation() {
	FUN_AddValidates("fdFunctionName:required", "fdFunction:required");
	$("#_tipInfo").next("span").remove();
}


	for ( var i = 0; i < 3; i++) {
		DocList_Info[i] = "TABLE_DocList" + i;
	}

	var detailList = [];
	var exportList = [];
	var importList = [];
	var detailjson = {};
	function createPhaseWorks(fdId, object) {
		return {
			"fdId" : fdId,
			"work" : object
		};
	}

	window.onload = function() {
		if (document.getElementsByName("fdFunctionName")[0].value != "")
			setTimeout("Work_init()", 200);

	}
	function Work_init() {

		var importxml = document.getElementById("TABLE_DocList0");
		var importlen = importxml.rows.length;
		for ( var i = 1; i < importlen; i++) {

			if (document.getElementsByName("tibSysSapRfcImport[" + (i - 1)
					+ "].fdParameterType")[0].value == "structure") {
				var importobject = document
						.getElementsByName("tibSysSapRfcImport[" + (i - 1)
								+ "].fdRfcParamXml")[0].value;
				var fdimportId = document
						.getElementsByName("tibSysSapRfcImport[" + (i - 1)
								+ "].fdId")[0].value;
				var doc = getXMLDom();//new ActiveXObject("Microsoft.XMLDOM");
				doc.loadXML(importobject);
				detailjson = createPhaseWorks(fdimportId, doc
						.getElementsByTagName("structure")[0]);
				importList[i - 1] = detailjson;
				document.getElementsByName("tibSysSapRfcImport[" + (i - 1)
						+ "].fdParameterName")[0].style.color = "#0066FF";
				document.getElementsByName("tibSysSapRfcImport[" + (i - 1)
						+ "].fdParameterName")[0].style.cursor = "pointer";

				 var temp =document.getElementsByName("tibSysSapRfcImport["+(i-1)+"].fdParameterName")[0];
		          $(temp).bind("click",newopen(i - 1,"1"));
			}
		}
		var exportxml = document.getElementById("TABLE_DocList1");
		var exportlen = exportxml.rows.length;
		for ( var i = 1; i < exportlen; i++) {

			if (document.getElementsByName("tibSysSapRfcExport[" + (i - 1)
					+ "].fdParameterType")[0].value == "structure") {
				var exportobject = document
						.getElementsByName("tibSysSapRfcExport[" + (i - 1)
								+ "].fdRfcParamXml")[0].value;
				var fdexportId = document
						.getElementsByName("tibSysSapRfcExport[" + (i - 1)
								+ "].fdId")[0].value;
				var doc = getXMLDom();//new ActiveXObject("Microsoft.XMLDOM");
				doc.loadXML(exportobject);
				detailjson = createPhaseWorks(fdexportId, doc
						.getElementsByTagName("structure")[0]);
				exportList[i - 1] = detailjson;
				document.getElementsByName("tibSysSapRfcExport[" + (i - 1)
						+ "].fdParameterName")[0].style.cursor = "pointer";
				document.getElementsByName("tibSysSapRfcExport[" + (i - 1)
						+ "].fdParameterName")[0].style.color = "#0066FF";
                
				var temp =document.getElementsByName("tibSysSapRfcExport["+(i-1)+"].fdParameterName")[0];
		          $(temp).bind("click",newopen(i - 1,"2"));
			}
		}
		var table = document.getElementById("TABLE_DocList2");
		var tablelen = table.rows.length;
		for ( var i = 1; i < tablelen; i++) {
			var tableobject = document.getElementsByName("tibSysSapRfcTable["
					+ (i - 1) + "].fdRfcParamXml")[0].value;
			var fdTableId = document.getElementsByName("tibSysSapRfcTable["
					+ (i - 1) + "].fdId")[0].value;
			var doc = getXMLDom();//new ActiveXObject("Microsoft.XMLDOM");
			doc.loadXML(tableobject);
			detailjson = createPhaseWorks(fdexportId, doc
					.getElementsByTagName("table")[0]);
			detailList[i - 1] = detailjson;
			document.getElementsByName("tibSysSapRfcTable[" + (i - 1)
					+ "].fdParameterName")[0].style.cursor = "pointer";
			document.getElementsByName("tibSysSapRfcTable[" + (i - 1)
					+ "].fdParameterName")[0].style.color = "#0066FF";
			var temp =document.getElementsByName("tibSysSapRfcTable["+(i-1)+"].fdParameterName")[0];
	          $(temp).bind("click",newopen(i - 1,"3"));
		}

	}

	
		

	if(!(navigator.userAgent.indexOf("MSIE")>0)){
		 // prototying the XMLDocument 
		XMLDocument.prototype.selectNodes = function(cXPathString, xNode) {
		 	if( !xNode ) { 
		      xNode = this; 
			} 
			var oNSResolver = this.createNSResolver(this.documentElement); 
			var aItems = this.evaluate(cXPathString, xNode, oNSResolver,XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null) ;
			var aResult = []; 
			for( var i = 0; i < aItems.snapshotLength; i++) { 
			     aResult[i] = aItems.snapshotItem(i); 
			   } 
			   return aResult; 
		} 
		
		// prototying the Element 
		Element.prototype.selectNodes = function(cXPathString) { 
		    if(this.ownerDocument.selectNodes) { 
		         return this.ownerDocument.selectNodes(cXPathString, this); 
		    } else{
		         throw "For XML Elements Only";
		    } 
		 } 
	}



	
	function getXMLDom(){
		var doc; 

		try{
			doc= new ActiveXObject("Microsoft.XMLDOM");
		}catch(e){
			try {
				// Firefox, Mozilla, Opera, etc.
				doc = document.implementation.createDocument("","",null);
		         } catch(e) {alert(e.message)}
			}
		doc.async = false;
		return doc;

		}

	function getFunctionXml() {
		// 清空“清除缓存的提示”
		$("#loadClearCache").empty();
		$("#getfun_info")
				.html("<img src='"+Com_Parameter.ResPath+"style/common/images/loading.gif' />");
		$("#getfun_info").slideDown("slow");
		var name = document.getElementsByName("fdFunction")[0].value;
		var pool = document.getElementsByName("fdPoolId")[0].value;
		var url = "tibSysSapRfcSettingFunctionXmlService&name=" + name
				+ "&pool=" + pool;
		for ( var i = 0; i < 3; i++) {
			var tBodyObj = document.getElementById("TABLE_DocList" + i);
			var n = tBodyObj.rows.length;
			for ( var j = n - 1; j > 0; j--) {
				DocList_DeleteRow(tBodyObj.rows[j]);
			}
		}
		var data = new KMSSData();
		data.SendToBean(url, onClickOpt_After);
	}


	
	function onClickOpt_After(rtn) {
		var obj = rtn.GetHashMapArray()[0];
		var xml = obj['xml'];
		if (xml == "err") {
			var extractFail = "<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcSetting.lang.extractFail"/>";
			FUN_AppendValidMsg("fdFunction!"+ extractFail);
			$("#getfun_info").html("");
			//$("#getfun_info").html("<font color=red>"+ extractFail +"</font>");
		} else {
			var doc =getXMLDom(); 
			doc.loadXML(xml);
          
			var importLen = doc.selectNodes("jco/import")[0].childNodes.length;
			var exportLen = doc.selectNodes("jco/export")[0].childNodes.length;
			var tableLen = doc.selectNodes("jco/tables")[0].childNodes.length;

			for ( var i = 0; i < importLen; i++) {
				DocList_AddRow("TABLE_DocList0");

				if (doc.selectNodes("jco/import")[0].childNodes[i].nodeName == "field") {
					document.getElementsByName("tibSysSapRfcImport[" + i
							+ "].fdParameterName")[0].value = doc
							.selectNodes("jco/import")[0].childNodes[i]
							.getAttribute("name");
					document.getElementsByName("tibSysSapRfcImport[" + i
							+ "].fdParameterType")[0].value = "field";
					document.getElementsByName("tibSysSapRfcImport[" + i
							+ "].fdParameterLength")[0].value = doc
							.selectNodes("jco/import")[0].childNodes[i]
							.getAttribute("maxlength");
					document.getElementsByName("tibSysSapRfcImport[" + i
							+ "].fdParameterTypeName")[0].value = doc
							.selectNodes("jco/import")[0].childNodes[i]
							.getAttribute("ctype");
					if (doc.selectNodes("jco/import")[0].childNodes[i]
							.getAttribute("isoptional") == "true")
						document.getElementsByName("tibSysSapRfcImport[" + i
								+ "].fdParameterRequired")[0].checked = true;
					else
						document.getElementsByName("tibSysSapRfcImport[" + i
								+ "].fdParameterRequired")[1].checked = true;
					document.getElementsByName("tibSysSapRfcImport[" + i
							+ "].fdParameterMark")[0].value = doc
							.selectNodes("jco/import")[0].childNodes[i]
							.getAttribute("title");
				}
				if (doc.selectNodes("jco/import")[0].childNodes[i].nodeName == "structure") {

					var importobject = doc.selectNodes("jco/import")[0].childNodes[i];
					var fdimportId = document
							.getElementsByName("tibSysSapRfcImport[" + i
									+ "].fdId")[0].value;
					importobject = addusenew(doc, importobject);
					detailjson = createPhaseWorks(fdimportId, importobject);
					importList[i] = detailjson;
					document.getElementsByName("tibSysSapRfcImport[" + i
							+ "].fdRfcParamXml")[0].value = importobject.xml;
					document.getElementsByName("tibSysSapRfcImport[" + i
							+ "].fdParameterName")[0].style.cursor = "pointer";
					document.getElementsByName("tibSysSapRfcImport[" + i
							+ "].fdParameterName")[0].style.color = "#0066FF";
					document.getElementsByName("tibSysSapRfcImport[" + i
							+ "].fdParameterName")[0].value = doc
							.selectNodes("jco/import")[0].childNodes[i]
							.getAttribute("name");

					var temp =document.getElementsByName("tibSysSapRfcImport["+ i +"].fdParameterName")[0];
			          $(temp).bind("click",newopen(i,"1"));
			          
					document.getElementsByName("tibSysSapRfcImport[" + i
							+ "].fdParameterType")[0].value = "structure";
				}
			}

			for ( var i = 0; i < exportLen; i++) {

				DocList_AddRow("TABLE_DocList1");
				if (doc.selectNodes("jco/export")[0].childNodes[i].nodeName == "field") {

					document.getElementsByName("tibSysSapRfcExport[" + i
							+ "].fdParameterName")[0].value = doc
							.selectNodes("jco/export")[0].childNodes[i]
							.getAttribute("name");
					document.getElementsByName("tibSysSapRfcExport[" + i
							+ "].fdParameterType")[0].value = "field";
					document.getElementsByName("tibSysSapRfcExport[" + i
							+ "].fdParameterTypeName")[0].value = doc
							.selectNodes("jco/export")[0].childNodes[i]
							.getAttribute("ctype");
					document.getElementsByName("tibSysSapRfcExport[" + i
							+ "].fdParameterMark")[0].value = doc
							.selectNodes("jco/export")[0].childNodes[i]
							.getAttribute("title");
				}

				if (doc.selectNodes("jco/export")[0].childNodes[i].nodeName == "structure") {
					var exportobject = doc.selectNodes("jco/export")[0].childNodes[i];
					var fdexportId = document
							.getElementsByName("tibSysSapRfcExport[" + i
									+ "].fdId")[0].value;
					exportobject = addusenew(doc, exportobject);
					detailjson = createPhaseWorks(fdexportId, exportobject);
					exportList[i] = detailjson;
					document.getElementsByName("tibSysSapRfcExport[" + i
							+ "].fdParameterName")[0].style.cursor = "pointer";
					document.getElementsByName("tibSysSapRfcExport[" + i
							+ "].fdRfcParamXml")[0].value = exportobject.xml;
					document.getElementsByName("tibSysSapRfcExport[" + i
							+ "].fdParameterName")[0].style.color = "#0066FF";
	                document.getElementsByName("tibSysSapRfcExport[" + i
							+ "].fdParameterName")[0].value = doc
							.selectNodes("jco/export")[0].childNodes[i]
							.getAttribute("name");

					var temp =document.getElementsByName("tibSysSapRfcExport["+i+"].fdParameterName")[0];
			          $(temp).bind("click",newopen(i,"2"));
			          
					document.getElementsByName("tibSysSapRfcExport[" + i
							+ "].fdParameterType")[0].value = "structure";
				}
			}

			for ( var i = 0; i < tableLen; i++) {
				DocList_AddRow("TABLE_DocList2");
				var tableobject = doc.selectNodes("jco/tables")[0].childNodes[i];
				var fdTableId = document.getElementsByName("tibSysSapRfcTable["
						+ i + "].fdId")[0].value;
				tableobject = adduse(doc, tableobject);
				detailjson = createPhaseWorks(fdTableId, tableobject);
				detailList[i] = detailjson;
				var name = doc.selectNodes("jco/tables")[0].childNodes[i]
						.getAttribute("name");
				document.getElementsByName("tibSysSapRfcTable[" + i
						+ "].fdParameterName")[0].style.cursor = "pointer";
				document
						.getElementsByName("tibSysSapRfcTable[" + i + "].fdUse")[1].checked = true;
				document.getElementsByName("tibSysSapRfcTable[" + i
						+ "].fdParameterName")[0].value = doc
						.selectNodes("jco/tables")[0].childNodes[i]
						.getAttribute("name");
				document.getElementsByName("tibSysSapRfcTable[" + i
						+ "].fdRfcParamXml")[0].value = tableobject.xml;
				document.getElementsByName("tibSysSapRfcTable[" + i
						+ "].fdParameterName")[0].style.color = "#0066FF";

				var temp =document.getElementsByName("tibSysSapRfcTable["+ i+ "].fdParameterName")[0];
		          $(temp).bind("click",newopen(i,"3"));
		          
				document.getElementsByName("tibSysSapRfcTable[" + i
						+ "].fdParameterType")[0].value = "table";
			}
			$("#getfun_info").fadeOut("slow");
		}
	}

	var newopen = function(i, type) {
		return function() {
			detail(i, type);//该函数为外部定义的一个执行函数；
		};
	};

	function detail(i, type) {

		var style = "dialogWidth:900px; dialogHeight:700x; status:0;scroll:1; help:0; resizable:1";
		var url = "<c:url value='/tib/sys/sap/connector/tib_sys_sap_rfc_setting/tibSysSapRfcSetting.do?method=detail'/>";
		if (type == 3) {
			var rtnVal = window.showModalDialog(Com_Parameter.ContextPath
					+ "resource/jsp/frame.jsp?url=" + encodeURIComponent(url),
					detailList[i].work, style);
			if (rtnVal != null) {
				detailList[i].work = rtnVal;
				document.getElementsByName("tibSysSapRfcTable[" + i
						+ "].fdRfcParamXml")[0].value = detailList[i].work.xml;
			}
		}
		if (type == 2) {
			var rtnVal = window.showModalDialog(Com_Parameter.ContextPath
					+ "resource/jsp/frame.jsp?url=" + encodeURIComponent(url),
					exportList[i].work, style);
			if (rtnVal != null) {
				exportList[i].work = rtnVal;
				document.getElementsByName("tibSysSapRfcExport[" + i
						+ "].fdRfcParamXml")[0].value = exportList[i].work.xml;
			}
		}
		if (type == 1) {
			var rtnVal = window.showModalDialog(Com_Parameter.ContextPath
					+ "resource/jsp/frame.jsp?url=" + encodeURIComponent(url),
					importList[i].work, style);
			if (rtnVal != null) {
				importList[i].work = rtnVal;
				document.getElementsByName("tibSysSapRfcImport[" + i
						+ "].fdRfcParamXml")[0].value = importList[i].work.xml;
			}
		}
	}

	function adduse(doc, object) {
		for ( var x = 0; x < object.childNodes[0].childNodes.length; x++) {
			if (object.childNodes[0].childNodes[x].nodeType == 1) {
				var r = doc.createAttribute("use");
				r.value = "true";
				object.childNodes[0].childNodes[x].setAttributeNode(r);
			}
		}
		return object;
	}

	function addusenew(doc, object) {
		for ( var x = 0; x < object.childNodes.length; x++) {

			if (object.childNodes[x].nodeType == 1) {
				var r = doc.createAttribute("use");
				r.value = "true";
				object.childNodes[x].setAttributeNode(r);
			}
		}
		return object;
	}

	function checkReturn(index) {
		if (document.getElementById("tibSysSapRfcExport[" + index + "].check").style.display == "") {
			document.getElementsByName("tibSysSapRfcExport[" + index
					+ "].fdReturnFlag")[0].value = "0";
			document.getElementById("tibSysSapRfcExport[" + index + "].check").style.display = "none";
			document.getElementsByName("tibSysSapRfcExport[" + index
					+ "].fdSuccess")[0].value = "";
			document.getElementsByName("tibSysSapRfcExport[" + index
					+ "].fdFail")[0].value = "";
		} else {
			document.getElementsByName("tibSysSapRfcExport[" + index
					+ "].fdReturnFlag")[0].value = "1";
			document.getElementById("tibSysSapRfcExport[" + index + "].check").style.display = "";
			document.getElementsByName("tibSysSapRfcExport[" + index
					+ "].fdSuccess")[0].value = "";
			document.getElementsByName("tibSysSapRfcExport[" + index
					+ "].fdFail")[0].value = "";
		}

	}

	function choiceSelect(source, curElem) {
		if (source.id != 'importType' && source.id != 'importRequired'
			&& source.id != 'exportType' && source.id != 'rfc_tableisin'
				&& source.id != 'rfc_tableUse') {
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
<html:form
	action="/tib/sys/sap/connector/tib_sys_sap_rfc_setting/tibSysSapRfcSetting.do">
	<div id="optBarDiv"><c:if
		test="${tibSysSapRfcSettingForm.method_GET=='edit'}">
		<!-- 
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.tibSysSapRfcSettingForm, 'update');">
	   -->		
	   <input type=button value="<bean:message key="button.update"/>"
			onclick="getHistoryInfor();">
			
	</c:if> <c:if test="${tibSysSapRfcSettingForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.tibSysSapRfcSettingForm, 'save');">
	</c:if> <input type="button" value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();"></div>

	<p class="txttitle"><bean:message bundle="tib-sys-sap-connector"
		key="table.tibSysSapRfcSetting" /></p>

	<center>
	<table id="Label_Tabel" width=95%>
		<tr
			LKS_LabelName="<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcSetting.lang.funcConfig"/>">
			<td>
			<table class="tb_normal" width=100%>
				<tr>
					<td class="td_normal_title" width=15%><bean:message
						bundle="tib-sys-sap-connector"
						key="tibSysSapRfcSetting.fdFunctionName" /></td>
					<td width="35%" colspan="3"><xform:text
						property="fdFunctionName" style="width:85%" /></td>
				</tr>
				<tr>
					<td class="td_normal_title" width=15%><bean:message
						bundle="tib-sys-sap-connector"
						key="tibSysSapRfcSetting.docCategory" /></td>
					<td width="35%"><html:hidden property="docCategoryId" /> <xform:text
						property="docCategoryName" required="true" style="width:34%" /> <a
						href="#" 
						onclick="Dialog_Tree(false, 'docCategoryId', 'docCategoryName', ',', 'tibSysSapRfcCategoryTreeService&parentId=!{value}', 
			'<bean:message key="table.tibSysSapRfcCategory" bundle="tib-sys-sap-connector"/>', null, null, 
			'${tibSysSapRfcCategoryForm.fdId}', null, null, 
			'<bean:message  bundle="tib-sys-sap-connector" key="table.tibSysSapRfcCategory"/>');">
					<bean:message key="dialog.selectOther" /> </a></td>

					<td class="td_normal_title" width=15%><bean:message
						bundle="tib-sys-sap-connector" key="tibSysSapRfcSetting.fdPool" /></td>
					<td width="35%">
					
					
					<xform:select property="fdPoolId" subject="${lfn:message('tib-sys-sap-connector:tibSysSapRfcSetting.fdPool') }"
						required="true">
						<xform:beanDataSource serviceBean="tibSysSapJcoSettingService"
							selectBlock="fdId,fdPoolName" orderBy="" />
						</xform:select> 
						</td>
				</tr>
				<tr>
					<td class="td_normal_title" width=15%><bean:message
						bundle="tib-sys-sap-connector" key="tibSysSapRfcSetting.fdUse" /></td>
					<td width="35%"><xform:radio property="fdUse">
						<xform:enumsDataSource enumsType="sap_yesno" />
					</xform:radio></td>
					<td class="td_normal_title" width=15%><bean:message
						bundle="tib-sys-sap-connector"
						key="tibSysSapRfcSetting.fdFunction" /></td>
					<td width="35%"><xform:text property="fdFunction"
						style="width:40%;float: left;" /><span style="float: left;" class="txtstrong">*</span>
						<div style="float: left;" id="_tipInfo" ><input type="button" class="btnopt"
								value="<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcSetting.lang.extractFunc"/>"
								onclick="getFunctionXml();">
							<span id="getfun_info" style="display: none"></span>
							<input type="button" class="btnopt" value="<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcSetting.clearcache" />"
								onclick="tib_sap_clearCache('fdPoolId','fdFunction');" /><br/>
							<span id="loadClearCache" style="display: none;color:green;"></span>
						</div>
					</td>
				</tr>

				<tr>
					<td class="td_normal_title" width=15%><bean:message
						bundle="tib-sys-sap-connector" key="tibSysSapRfcSetting.fdWeb" /></td>
					<td width="35%"><xform:radio property="fdWeb">
						<xform:enumsDataSource enumsType="sap_yesno" />
					</xform:radio></td>
					<td class="td_normal_title" width=15%><bean:message
						bundle="tib-sys-sap-connector" key="tibSysSapRfcSetting.fdCommit" />
						<img src="${KMSS_Parameter_StylePath}answer/tips.gif" style="cursor:hand" title="<bean:message
						bundle="tib-sys-sap-connector" key="tibSysSapRfcSetting.fdCommitTips" />" /></td>
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
							<td class="td_normal_title" width="10%"><input
								id="importType" on_change_import="choiceSelect(source,this)"
								type="checkbox" /> <bean:message bundle="tib-sys-sap-connector"
								key="tibSysSapRfcImport.fdParameterUse" /></td>
							<td class="td_normal_title" width="15%"><bean:message
								bundle="tib-sys-sap-connector"
								key="tibSysSapRfcImport.fdParameterName" /></td>
							<td class="td_normal_title" width="15%"><bean:message
								bundle="tib-sys-sap-connector"
								key="tibSysSapRfcImport.fdParameterType" /></td>
							<td class="td_normal_title" width="10%"><bean:message
								bundle="tib-sys-sap-connector"
								key="tibSysSapRfcImport.fdParameterLength" /></td>
							<td class="td_normal_title" width="10%"><bean:message
								bundle="tib-sys-sap-connector"
								key="tibSysSapRfcImport.fdParameterTypeName" /></td>
							<td class="td_normal_title" width="10%"><input
								id="importRequired"
								on_change_required="choiceSelect(source,this)" type="checkbox" />
							<bean:message bundle="tib-sys-sap-connector"
								key="tibSysSapRfcImport.fdParameterRequired" /></td>
							<td class="td_normal_title" width="30%"><bean:message
								bundle="tib-sys-sap-connector"
								key="tibSysSapRfcImport.fdParameterMark" /></td>
						</tr>
						<tr KMSS_IsReferRow="1" style="display: none">
							<td><xform:radio
								htmlElementProperties="on_change_import=\"choiceSelect(source,this)\""
								property="tibSysSapRfcImport[!{index}].fdParameterUse">
								<xform:enumsDataSource enumsType="sap_no" />
							</xform:radio></td>
							<td><input type="text"
								name="tibSysSapRfcImport[!{index}].fdParameterName"
								value="${tibSysSapRfcImportForm.fdParameterName}"
								style="width: 85%; border: 0px solid #000000;"
								readonly="readonly"></td>
							<td><input type="hidden"
								name="tibSysSapRfcImport[!{index}].fdId"
								value="${tibSysSapRfcImportForm.fdId}"> <input
								type="hidden" name="tibSysSapRfcImport[!{index}].fdFunctionId"
								value="${tibSysSapRfcSettingForm.fdId}"> <input
								type="text" name="tibSysSapRfcImport[!{index}].fdParameterType"
								value="${tibSysSapRfcImportForm.fdParameterType}"
								style="width: 85%; border: 0px solid #000000;"
								readonly="readonly"></td>
							<td><input type="text"
								name="tibSysSapRfcImport[!{index}].fdParameterLength"
								value="${tibSysSapRfcImportForm.fdParameterLength}"
								style="width: 85%; border: 0px solid #000000;"
								readonly="readonly"></td>
							<td><input type="text"
								name="tibSysSapRfcImport[!{index}].fdParameterTypeName"
								value="${tibSysSapRfcImportForm.fdParameterTypeName}"
								style="width: 85%; border: 0px solid #000000;"
								readonly="readonly"></td>
							<td><xform:radio
								htmlElementProperties="on_change_required=\"choiceSelect(source,this)\""
								property="tibSysSapRfcImport[!{index}].fdParameterRequired">
								<xform:enumsDataSource enumsType="common_yesno" />
							</xform:radio></td>
							<td><input type="hidden"
								name="tibSysSapRfcImport[!{index}].fdRfcParamXml"
								value="${tibSysSapRfcImportForm.fdRfcParamXmlView}"><input
								type="text" name="tibSysSapRfcImport[!{index}].fdParameterMark"
								value="${tibSysSapRfcImportForm.fdParameterMark}"
								style="width: 85%; border: 0px solid #000000;"
								readonly="readonly"></td>
						</tr>
						<c:forEach items="${tibSysSapRfcSettingForm.tibSysSapRfcImport}"
							var="tibSysSapRfcImportForm" varStatus="vstatus">
							<tr KMSS_IsContentRow="1">
								<td><xform:radio
									property="tibSysSapRfcImport[${vstatus.index}].fdParameterUse"
									htmlElementProperties="on_change_import=\"choiceSelect(source,this)\"">
									<xform:enumsDataSource enumsType="common_yesno" />
								</xform:radio></td>
								<td><input type="text"
									name="tibSysSapRfcImport[${vstatus.index}].fdParameterName"
									value="${tibSysSapRfcImportForm.fdParameterName}"
									style="width: 85%; border: 0px solid #000000;"
									readonly="readonly"></td>
								<td><input type="hidden"
									name="tibSysSapRfcImport[${vstatus.index}].fdId"
									value="${tibSysSapRfcImportForm.fdId}"> <input
									type="hidden"
									name="tibSysSapRfcImport[${vstatus.index}].fdFunctionId"
									value="${tibSysSapRfcSettingForm.fdId}"> <input
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
									htmlElementProperties="on_change_required=\"choiceSelect(source,this)\""
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

							<td class="td_normal_title" width="10%"><input
								id="exportType" on_change_export="choiceSelect(source,this)"
								type="checkbox" /> <bean:message bundle="tib-sys-sap-connector"
								key="tibSysSapRfcImport.fdParameterUse" /></td>
							<td class="td_normal_title" width="15%"><bean:message
								bundle="tib-sys-sap-connector"
								key="tibSysSapRfcImport.fdParameterName" /></td>
							<td class="td_normal_title" width="15%"><bean:message
								bundle="tib-sys-sap-connector"
								key="tibSysSapRfcImport.fdParameterType" /></td>
							<td class="td_normal_title" width="10%"><bean:message
								bundle="tib-sys-sap-connector"
								key="tibSysSapRfcImport.fdParameterTypeName" /></td>
							<td class="td_normal_title" width="20%"><bean:message
								bundle="tib-sys-sap-connector"
								key="tibSysSapRfcImport.fdParameterMark" /></td>
							<td class="td_normal_title" width="20%"><bean:message
								bundle="tib-sys-sap-connector"
								key="tibSysSapRfcImport.fdReturnType" /></td>
						</tr>
						<tr KMSS_IsReferRow="1" style="display: none">
							<td><xform:radio
								htmlElementProperties="on_change_export=\"choiceSelect(source,this)\""
								property="tibSysSapRfcExport[!{index}].fdParameterUse">
								<xform:enumsDataSource enumsType="sap_no" />
							</xform:radio></td>
							<td><input type="text"
								name="tibSysSapRfcExport[!{index}].fdParameterName"
								value="${tibSysSapRfcExportForm.fdParameterName}"
								style="width: 85%; border: 0px solid #000000;"
								readonly="readonly"></td>
							<td><input type="hidden"
								name="tibSysSapRfcExport[!{index}].fdId"
								value="${tibSysSapRfcExportForm.fdId}"> <input
								type="hidden" name="tibSysSapRfcExport[!{index}].fdFunctionId"
								value="${tibSysSapRfcSettingForm.fdId}"> <input
								type="text" name="tibSysSapRfcExport[!{index}].fdParameterType"
								value="${tibSysSapRfcExportForm.fdParameterType}"
								style="width: 85%; border: 0px solid #000000;"
								readonly="readonly"></td>
							<td><input type="text"
								name="tibSysSapRfcExport[!{index}].fdParameterTypeName"
								value="${tibSysSapRfcExportForm.fdParameterTypeName}"
								style="width: 85%; border: 0px solid #000000;"
								readonly="readonly"></td>
							<td><input type="hidden"
								name="tibSysSapRfcExport[!{index}].fdRfcParamXml"
								value="${tibSysSapRfcExportForm.fdRfcParamXmlView}"> <input
								type="text" name="tibSysSapRfcExport[!{index}].fdParameterMark"
								value="${tibSysSapRfcExportForm.fdParameterMark}"
								style="width: 85%; border: 0px solid #000000;"
								readonly="readonly"></td>
							<td><input type="checkbox"
								name="tibSysSapRfcExport[!{index}].fdReturnFlag"
								value="${tibSysSapRfcExportForm.fdReturnFlag}"
								onclick="checkReturn('!{index}');">
							<div align="left" style="display: none"
								id="tibSysSapRfcExport[!{index}].check"><bean:message
								bundle="tib-sys-sap-connector"
								key="tibSysSapRfcSetting.lang.success" /> <input type="text"
								name="tibSysSapRfcExport[!{index}].fdSuccess"
								value="${tibSysSapRfcExportForm.fdSuccess}" class="inputsgl">
							<br>
							<bean:message bundle="tib-sys-sap-connector"
								key="tibSysSapRfcSetting.lang.fail" /><input type="text"
								name="tibSysSapRfcExport[!{index}].fdFail"
								value="${tibSysSapRfcExportForm.fdFail}" class="inputsgl">
							</div>
							</td>
						</tr>
						<c:forEach items="${tibSysSapRfcSettingForm.tibSysSapRfcExport}"
							var="tibSysSapRfcExportForm" varStatus="vstatus">
							<tr KMSS_IsContentRow="1">
								<td><xform:radio
									htmlElementProperties="on_change_export=\"choiceSelect(source,this)\""
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
									value="${tibSysSapRfcExportForm.fdId}"> <input
									type="hidden"
									name="tibSysSapRfcExport[${vstatus.index}].fdFunctionId"
									value="${tibSysSapRfcSettingForm.fdId}"> <input
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
								<c:if test="${tibSysSapRfcExportForm.fdReturnFlag=='1'}">
									<td><input type="checkbox"
										name="tibSysSapRfcExport[${vstatus.index}].fdReturnFlag"
										value="${tibSysSapRfcExportForm.fdReturnFlag}"
										onclick="checkReturn('${vstatus.index}');" checked=true>
									<div align="left" style="display: ''"
										id="tibSysSapRfcExport[${vstatus.index}].check"><bean:message
										bundle="tib-sys-sap-connector"
										key="tibSysSapRfcSetting.lang.success" /> <input type="text"
										name="tibSysSapRfcExport[${vstatus.index}].fdSuccess"
										value="${tibSysSapRfcExportForm.fdSuccess}" class="inputsgl">
									<br>
									<bean:message bundle="tib-sys-sap-connector"
										key="tibSysSapRfcSetting.lang.fail" /> <input type="text"
										name="tibSysSapRfcExport[${vstatus.index}].fdFail"
										value="${tibSysSapRfcExportForm.fdFail}" class="inputsgl">
									</div>
									</td>
								</c:if>
								<c:if test="${tibSysSapRfcExportForm.fdReturnFlag!='1'}">
									<td><input type="checkbox"
										name="tibSysSapRfcExport[${vstatus.index}].fdReturnFlag"
										value="${tibSysSapRfcExportForm.fdReturnFlag}"
										onclick="checkReturn('${vstatus.index}');">
									<div align="left" style="display: none"
										id="tibSysSapRfcExport[${vstatus.index}].check"><bean:message
										bundle="tib-sys-sap-connector"
										key="tibSysSapRfcSetting.lang.success" /> <input type="text"
										name="tibSysSapRfcExport[${vstatus.index}].fdSuccess"
										value="${tibSysSapRfcExportForm.fdSuccess}" class="inputsgl">
									<br>
									<bean:message bundle="tib-sys-sap-connector"
										key="tibSysSapRfcSetting.lang.fail" /> <input type="text"
										name="tibSysSapRfcExport[${vstatus.index}].fdFail"
										value="${tibSysSapRfcExportForm.fdFail}" class="inputsgl">
									</div>
									</td>
								</c:if>
							</tr>
						</c:forEach>
					</table>
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width=15%><bean:message
						bundle="tib-sys-sap-connector" key="table.tibSysSapRfcTable" /></td>
					<td width=85% colspan="3">
					<table class="tb_normal" width=100% id="TABLE_DocList2">
						<tr>

							<td class="td_normal_title" width="10%"><input
								id="rfc_tableUse" on_change_tableuse="choiceSelect(source,this)"
								type="checkbox" /> <bean:message bundle="tib-sys-sap-connector"
								key="tibSysSapRfcImport.fdParameterUse" /></td>
							<td class="td_normal_title" width="35%"><bean:message
								bundle="tib-sys-sap-connector"
								key="tibSysSapRfcImport.fdParameterName" /></td>
							<td class="td_normal_title" width="10%"><bean:message
								bundle="tib-sys-sap-connector"
								key="tibSysSapRfcImport.fdParameterType" /></td>
							<td class="td_normal_title" width="15%"><input
								id="rfc_tableisin"
								on_change_tableisin="choiceSelect(source,this)" type="checkbox" />
							<bean:message bundle="tib-sys-sap-connector"
								key="tibSysSapRfcImport.fdisin" /></td>
							<td class="td_normal_title" width="30%"><bean:message
								bundle="tib-sys-sap-connector"
								key="tibSysSapRfcImport.fdParameterMark" /></td>
						</tr>
						<tr KMSS_IsReferRow="1" style="display: none">
							<td><input type="hidden"
								name="tibSysSapRfcTable[!{index}].fdRfcParamXml"
								value="${tibSysSapRfcTableForm.fdRfcParamXmlView}"> <xform:radio
								htmlElementProperties="on_change_tableuse=\"choiceSelect(source,this)\""
								property="tibSysSapRfcTable[!{index}].fdUse">
								<xform:enumsDataSource enumsType="common_yesno" />
							</xform:radio></td>
							<td><input type="text" class="inputsgl"
								name="tibSysSapRfcTable[!{index}].fdParameterName"
								value="${tibSysSapRfcTableForm.fdParameterName}"
								style="width: 85%; border: 0px solid #000000;"
								readonly="readonly"></td>
							<td><input type="hidden"
								name="tibSysSapRfcTable[!{index}].fdId"
								value="${tibSysSapRfcExportForm.fdId}"> <input
								type="hidden" name="tibSysSapRfcTable[!{index}].fdFunctionId"
								value="${tibSysSapRfcSettingForm.fdId}"> <input
								type="text" name="tibSysSapRfcTable[!{index}].fdParameterType"
								value="${tibSysSapRfcTableForm.fdParameterType}"
								style="width: 85%; border: 0px solid #000000;"
								readonly="readonly"></td>
							<!-- 表参数类型的复选框（传入or传出） -->
							<td><xform:checkbox required="true"
								htmlElementProperties="on_change_tableisin=\"choiceSelect(source,this)\""
								property="tibSysSapRfcTable[!{index}].fdisin">
								<xform:enumsDataSource enumsType="table_type" />
							</xform:checkbox></td>
							<td><input type="text"
								name="tibSysSapRfcTable[!{index}].fdMark"
								value="${tibSysSapRfcTableForm.fdMark}"
								style="width: 85%; border: 0px solid #000000;"
								readonly="readonly"></td>
						</tr>
						<c:forEach items="${tibSysSapRfcSettingForm.tibSysSapRfcTable}"
							var="tibSysSapRfcTableForm" varStatus="vstatus">
							<tr KMSS_IsContentRow="1">
								<td><input type="hidden"
									name="tibSysSapRfcTable[${vstatus.index}].fdRfcParamXml"
									value="${tibSysSapRfcTableForm.fdRfcParamXmlView}"> <xform:radio
									htmlElementProperties="on_change_tableuse=\"choiceSelect(source,this)\""
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
									value="${tibSysSapRfcTableForm.fdId}"> <input
									type="hidden"
									name="tibSysSapRfcTable[${vstatus.index}].fdFunctionId"
									value="${tibSysSapRfcSettingForm.fdId}"> <input
									type="text"
									name="tibSysSapRfcTable[${vstatus.index}].fdParameterType"
									value="${tibSysSapRfcTableForm.fdParameterType}"
									style="width: 85%; border: 0px solid #000000;"
									readonly="readonly"></td>
								<!-- 表参数类型的复选框（传入or传出） -->
								<td><xform:checkbox required="true" 
									htmlElementProperties="on_change_tableisin=\"choiceSelect(source,this)\""
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
						bundle="tib-sys-sap-connector"
						key="tibSysSapRfcSetting.fdDescribe" /></td>
					<td width="35%" colspan="3"><xform:textarea
						property="fdDescribe" style="width:85%" /></td>
				</tr>
			</table>
			</td>
		</tr>
		<c:import url="/sys/edition/include/sysEditionMain_edit.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="tibSysSapRfcSettingForm" />
		</c:import>

	</table>

	</center>
	<html:hidden property="docCreatorName" />
	<html:hidden property="docCreatorId" />
	<html:hidden property="docCreateTime" />
	<html:hidden property="docSubject" />
	<html:hidden property="docStatus" />
	<html:hidden property="fdId" />
	<html:hidden property="method_GET" />
	<script>
	Com_IncludeFile("eventbus.js");
	$KMSSValidation();
</script>
	<script type="text/javascript">
	//清空缓存
 	function tib_sap_clearCache(poolId, funcId){
	 		var poolName=$("select[name='"+poolId+"']").find("option:selected").text();
	 		var funcName=$("input[name='"+funcId+"']").val();
			if(poolName && funcName){
				$.ajax({
					type: "POST",
				   	url: "${KMSS_Parameter_ContextPath}tib/sys/sap/connector/tib_sys_sap_rfc_setting/tibSysSapRfcSetting.do?method=clearCache",
				   	data: "poolName="+ poolName +"&funcName="+funcName,
				   	beforeSend:function(){
					   	$("#loadClearCache").html("<img src='"+Com_Parameter.ResPath+"style/common/images/loading.gif' />");
					  	$("#loadClearCache").slideDown("slow");
				   	},
				   	success: function(data, textStatus){
					   	$("#loadClearCache").text("缓存已清除，请重新抽取函数！");
				   	}
				});
				 
			} else{
				//..
			}
 	 	}

   //检查历史查询数据
	function getHistoryInfor(){
		var data = new KMSSData();
		var url = "tibSysSapRfcSettingFunctionHistoryDataRecordService&fdId="+'${tibSysSapRfcSettingForm.fdId}';
		data.SendToBean(url, callBackFunction);
	}

   //在弹出窗口中添加自定义按钮
	function callBackFunction(rnt){
		var dataCount = rnt.GetHashMapArray().length;
        if(dataCount>0){
        	var innerHtml='<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcSetting.messageTips"/>';
        	var NoButton='<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcSetting.ButtonNo"/>';
        	var htmlMessage='<table height="80%" border="0" align="center" cellpadding="10" cellspacing="0">\
        		<tr><td align="right"><img id="Icon_' + this.ID + '" src="' + IMAGESPATH + 'icon_alert.gif" width="34" height="34" align="absmiddle"></td>\
    			<td align="left" id="Message_' + this.ID + '" style="font-size:9pt">' + innerHtml + '</td></tr>\
	      </table>';
        	var titleMessage='<bean:message bundle="tib-sys-sap-connector" key="tibSysSapRfcSetting.titleMessage"/>';
            var diag = new Dialog();
                diag.height=90;
                diag.width=340;
				diag.Title = titleMessage;
				diag.InnerHtml=htmlMessage;
                diag.OKEvent=function(){
					Com_Submit(document.tibSysSapRfcSettingForm, 'updateFunction');
	            };
				diag.show();
				diag.addButtonByCondition("NO",NoButton,function(){
					Com_Submit(document.tibSysSapRfcSettingForm, 'update');
				},2);
        }else{
        	Com_Submit(document.tibSysSapRfcSettingForm, 'update');
        }
	}
</script>


</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>

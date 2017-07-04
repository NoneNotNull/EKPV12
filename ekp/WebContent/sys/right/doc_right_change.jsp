<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple" sidebar="no">
	<template:replace name="body">
<%@ page import="java.util.Set" %>
<%@ page import="com.landray.kmss.sys.config.dict.SysDataDict" %>
<%
	String modelName = request.getParameter("modelName");
	Set mSet =  SysDataDict.getInstance().getModel(modelName).getPropertyMap().keySet();
	String[] ms = new String[]{"authReaders","authEditors","authAttCopys","authAttDownloads","authAttPrints"};
	int cm=0;
	for(int i=0;i<ms.length;i++){
		if(mSet.contains(ms[i])){
			cm++;
		}
	}
%>
	
<script type="text/javascript">
seajs.use(['theme!form']);
	Com_IncludeFile("dialog.js");
</script>

<script>
var kvd = ["authReader","authEditor","authAttCopy","authAttDownload","authAttPrint"];
var tsd =["<bean:message  bundle="sys-right" key="right.change.authReaderIds"/>",
		"<bean:message  bundle="sys-right" key="right.change.authEditorIds"/>",
		"<bean:message  bundle="sys-right" key="right.change.authAttCopyIds"/>",
		"<bean:message  bundle="sys-right" key="right.change.authAttDownloadIds"/>",
		"<bean:message  bundle="sys-right" key="right.change.authAttPrintIds"/>"
		];
window.onload = function(){
	init() ;
}
function validateDocAuthForm(of){
	if(!validateEmpty()){
		return false;
	}
	return true;
}
function init(){
	var values="";
	var __win;
	if(window.opener){
		__win = window.opener;
	}else if(window.parent){
		__win = window.parent;
	}  
	if(__win){
		var	select = __win.document.getElementsByName("List_Selected");
		for(var i=0;i<select.length;i++) {
			if(select[i].checked){
				values+=select[i].value;
				values+=",";
			}
		}
	}
	if(!values)
		values = '${param.fdIds}';
	document.getElementsByName("fdIds")[0].value=values; 
}
function validateEmpty(){
	var oprType = document.getElementsByName("oprType");
	var oprValue = getOprValue();
	if(oprValue=="1"||oprValue=="3"){
		if(!checkProperty("<bean:message  bundle="sys-right" key="right.change.doc"/>",kvd,tsd)){
			return false;
		}
	}
	return true;
}

function getOprValue(){
	var oprType = document.getElementsByName("oprType");
	var oprValue = "";
	for(var i=0;i<oprType.length;i++){
		if(oprType[i].checked){
			oprValue = oprType[i].value;
		}
	}
	return oprValue;
}

function checkProperty(zt,pn,pt){
	for(var i=0;i<pn.length;i++){
		var ids = document.getElementsByName(pn[i]+"Ids")[0];
		var chk = document.getElementsByName(pn[i]+"Check")[0];
		if(ids && chk.checked){
			if(ids.value==""){
				var re = /\{0\}/gi;
				var msg ="<bean:message key="errors.required"/>";
				msg = msg.replace(re, pt[i]);
				alert(zt+" "+msg);
				return false;
			}
		}
	}
	return true;
}

function showElementInput(el){
	document.getElementById(el.name+"Input").style.display=el.checked?"":"none";
	var oprValue = getOprValue();
	if(document.getElementById(el.name+"NotFlag")){
		document.getElementById(el.name+"NotFlag").style.display=(oprValue=="1")?"none":"";
	}
	if(document.getElementById(el.name+"Empty")){
		document.getElementById(el.name+"Empty").style.display=(oprValue=="1")?"none":"";
	}
}

function swapNotFlag(el){
	document.getElementById(el.name+"Input").style.display=el.checked?"none":"";
}

var _tmp =["authAttDownloadCheck","authAttPrintCheck","authAttCopyCheck"];
var _tmpFlag =["authAttNodownload","authAttNoprint","authAttNocopy"];
function oprOnclickFunc(el){
	for(var i=0;i<_tmp.length;i++){
		if(!document.getElementById(_tmp[i])){
			continue;
		}
		if(document.getElementById(_tmp[i]+"Input").style.display=="none"){
			continue;
		}
		if(el.value=="1"){
			document.getElementById(_tmp[i]+"NotFlag").style.display="none";
			document.getElementById(_tmp[i]+"Empty").style.display="none";
			document.getElementById(_tmpFlag[i]).checked=false;
			document.getElementById(_tmpFlag[i]+"Input").style.display="";
		}else{
			document.getElementById(_tmp[i]+"NotFlag").style.display="";
			document.getElementById(_tmp[i]+"Empty").style.display="";
			if(document.getElementById(_tmpFlag[i]).checked){
				document.getElementById(_tmpFlag[i]+"Input").style.display="none";
			}else{
				document.getElementById(_tmpFlag[i]+"Input").style.display="";
			}
		}

	}
	if(el.value=="1"){
		if(document.getElementById("authReaderNoteFlagEmpty")){
			document.getElementById("authReaderNoteFlagEmpty").style.display="none";
		}
	}else{
		if(document.getElementById("authReaderNoteFlagEmpty")){
			document.getElementById("authReaderNoteFlagEmpty").style.display="";
		}
	}
}

</script>
<kmss:windowTitle subjectKey="sys-right:right.change.title.doc"
	 moduleKey="${param.moduleMessageKey}" />

<p class="txttitle"><bean:message bundle="sys-right" key="right.change.title.doc"/><bean:message key="button.edit"/></p>

<html:form action="/sys/right/rightDocChange.do" method="post" onsubmit="return validateDocAuthForm(this);">
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=12%>
			<bean:message  bundle="sys-right" key="right.change.opr"/>
		</td>
		<td width=90%>
			<sunbor:enums
				property="oprType"
				enumsType="sys_right_add_or_reset"
				elementType="radio" htmlElementProperties="onclick='oprOnclickFunc(this);'"/>
		</td>
	</tr>	

	<tr>
		<td class="td_normal_title" colspan="2">
			<bean:message  bundle="sys-right" key="right.change.updateOption"/>
		</td>
	</tr>	

	<tr id="authReaderZone">
		<td class="td_normal_title" rowspan="<%=cm%>" width=10%>
			<bean:message  bundle="sys-right" key="right.change.doc"/>
		</td>
		<td width=90%>
			<input type="checkbox" name="authReaderCheck" value="true" onclick="showElementInput(this)">&nbsp;<bean:message  bundle="sys-right" key="right.change.authReaderIds"/><br>
			<div id="authReaderCheckInput" style="display:none">
				<xform:address textarea="true" mulSelect="true" propertyId="authReaderIds" propertyName="authReaderNames" style="width:90%;height:90px;" showStatus="edit"></xform:address>
				<html:hidden property="authReaderNoteFlag" value="${param.authReaderNoteFlag}"/>
				<c:if test="${empty param.authReaderNoteFlag or param.authReaderNoteFlag=='1'}">
				<div id="authReaderNoteFlagEmpty" style="display:none"><bean:message
				bundle="sys-right" key="right.read.authReaders.note" />
				</div>
				</c:if>
				<c:if test="${param.authReaderNoteFlag=='2'}">
				<div id="authReaderNoteFlagEmpty" style="display:none">
				<bean:message
				bundle="sys-right" key="right.read.authReaders.note1" />
				</div>
				</c:if>
			
			<div>
		</td>
	</tr>
	<% if(mSet.contains("authEditors")){ %>
	<tr id="authEditorZone">
		<td width=90%>
			<input type="checkbox" name="authEditorCheck" value="true" onclick="showElementInput(this)">
			<bean:message  bundle="sys-right" key="right.change.authEditorIds"/><br>
			<div id="authEditorCheckInput" style="display:none">
			<xform:address textarea="true" mulSelect="true" propertyId="authEditorIds" propertyName="authEditorNames" style="width:90%;height:90px;" showStatus="edit"></xform:address>
			<div>
		</td>
	</tr>
	<%}%>
	<% if(mSet.contains("authAttDownloads")){ %>
	<tr id="authAttDownloadZone">
		<td width=90%>
			<input type="checkbox" name="authAttDownloadCheck" value="true" onclick="showElementInput(this)">
			<bean:message  bundle="sys-right" key="right.change.authAttDownloadIds"/>
			<div id="authAttDownloadCheckInput" style="display:none">
			
			<div id="authAttDownloadCheckNotFlag" style="display:none">
			<input type="checkbox" name="authAttNodownload" value="true" onclick="swapNotFlag(this)">
			<bean:message key="right.att.authAttNodownload" bundle="sys-right"/>
			</div>

			<div id="authAttNodownloadInput">
			<xform:address textarea="true" mulSelect="true" propertyId="authAttDownloadIds" propertyName="authAttDownloadNames" style="width:90%;height:90px;" showStatus="edit"></xform:address>
			<div>
			<div id="authAttDownloadCheckEmpty" style="display:none">												
			<bean:message key="right.att.authAttDownloads.note" bundle="sys-right"/>
			<div>

			</div>		
		</td>
	</tr>
	<%}%>
	<% if(mSet.contains("authAttPrints")){ %>
	<tr id="authAttPrintZone">
		<td width=90%>
			<input type="checkbox" name="authAttPrintCheck" value="true" onclick="showElementInput(this)">
			<bean:message  bundle="sys-right" key="right.change.authAttPrintIds"/>
			<div id="authAttPrintCheckInput" style="display:none">
			
			<div id="authAttPrintCheckNotFlag" style="display:none">
			<input type="checkbox" name="authAttNoprint" value="true" onclick="swapNotFlag(this)">
			<bean:message key="right.att.authAttNoprint" bundle="sys-right"/>
			</div>

			<div id="authAttNoprintInput">
			<xform:address textarea="true" mulSelect="true" propertyId="authAttPrintIds" propertyName="authAttPrintNames" style="width:90%;height:90px;" showStatus="edit"></xform:address>
			<div>
			<div id="authAttPrintCheckEmpty" style="display:none">															
			<bean:message key="right.att.authAttPrints.note" bundle="sys-right"/>
			<div>

			</div>	
		</td>
	</tr>
	<%}%>
	<% if(mSet.contains("authAttCopys")){ %>
	<tr id="authAttCopyZone">
		<td width=90%>
			<input type="checkbox" name="authAttCopyCheck" value="true" onclick="showElementInput(this)">
			<bean:message  bundle="sys-right" key="right.change.authAttCopyIds"/>
			<div id="authAttCopyCheckInput" style="display:none">
			
			<div id="authAttCopyCheckNotFlag" style="display:none">
			<input type="checkbox" name="authAttNocopy" value="true" onclick="swapNotFlag(this)">
			<bean:message key="right.att.authAttNocopy" bundle="sys-right"/>
			</div>

			<div id="authAttNocopyInput">

			<xform:address textarea="true" mulSelect="true" propertyId="authAttCopyIds" propertyName="authAttCopyNames" style="width:90%;height:90px;" showStatus="edit"></xform:address>
			<div>
			<div id="authAttCopyCheckEmpty" style="display:none">															
			<bean:message key="right.att.authAttCopys.note" bundle="sys-right"/>
			<div>

			</div>	
		</td>

	</tr>	
	<%}%>
	
</table>
<div style="padding-top:17px">
       <ui:button text="${ lfn:message('button.save') }"  onclick="Com_Submit(document.docAuthForm, 'docRightUpdate','fdIds');">
	   </ui:button>
       <ui:button text="${ lfn:message('button.close') }" styleClass="lui_toolbar_btn_gray" onclick="Com_CloseWindow();">
	   </ui:button>
</div>
</center>
<html:hidden property="fdIds" value="${param.fdIds}"/>
<html:hidden property="modelName" value="${param.modelName}"/>
<html:hidden property="method_GET"/>
</html:form>
	</template:replace>
</template:include>
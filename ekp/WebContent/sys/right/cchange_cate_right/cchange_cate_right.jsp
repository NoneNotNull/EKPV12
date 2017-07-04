<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@ page import="java.util.Set" %>
<%@ page import="com.landray.kmss.sys.config.dict.SysDataDict" %>
<%
	String tmpModelName = request.getParameter("tmpModelName");
	Set tmpSet =  SysDataDict.getInstance().getModel(tmpModelName).getPropertyMap().keySet();
	String cateName = "com.landray.kmss.sys.category.model.SysCategoryMain";
	Set cateSet =  SysDataDict.getInstance().getModel(cateName).getPropertyMap().keySet();
	String modelName = request.getParameter("mainModelName");
	Set mSet =  SysDataDict.getInstance().getModel(modelName).getPropertyMap().keySet();
	String[] ts = new String[]{"authReaders","authEditors","authTmpReaders","authTmpEditors","authTmpAttCopys","authTmpAttDownloads","authTmpAttPrints"};
	String[] cs = new String[]{"authReaders","authEditors"};
	String[] ms = new String[]{"authReaders","authEditors","authAttCopys","authAttDownloads","authAttPrints"};
	int ct = 0,cc = 0, cm = 0;
	for(int i=0;i<ts.length;i++){
		if(tmpSet.contains(ts[i])){
			ct++;
		}
	}
	for(int i=0;i<cs.length;i++){
		if(cateSet.contains(cs[i])){
			cc++;
		}
	}
	for(int i=0;i<ms.length;i++){
		if(mSet.contains(ms[i])){
			cm++;
		}
	}
%>
<script type="text/javascript">
	Com_IncludeFile("dialog.js");
</script>

<kmss:windowTitle subjectKey="sys-right:right.change.title.cate"
	 moduleKey="${param.moduleMessageKey}" />

<script>
var kvc = ["authTemplateReader","authTemplateEditor","authTmpReader","authTmpEditor","authTmpAttCopy","authTmpAttDownload","authTmpAttPrint"];
var kcc = ["authCateReader","authCateEditor"];
var kvd = ["authReader","authEditor","authAttCopy","authAttDownload","authAttPrint"];
var tsc =["<bean:message  bundle="sys-right" key="right.change.authCateReaderIds"/>",
		"<bean:message  bundle="sys-right" key="right.change.authCateEditorIds"/>",
		"<bean:message  bundle="sys-right" key="right.change.authTmpReaderIds"/>",
		"<bean:message  bundle="sys-right" key="right.change.authTmpEditorIds"/>",
		"<bean:message  bundle="sys-right" key="right.change.authTmpAttCopyIds"/>",
		"<bean:message  bundle="sys-right" key="right.change.authTmpAttDownloadIds"/>",
		"<bean:message  bundle="sys-right" key="right.change.authTmpAttPrintIds"/>"
		]
var tsd =["<bean:message  bundle="sys-right" key="right.change.authReaderIds"/>",
		"<bean:message  bundle="sys-right" key="right.change.authEditorIds"/>",
		"<bean:message  bundle="sys-right" key="right.change.authAttCopyIds"/>",
		"<bean:message  bundle="sys-right" key="right.change.authAttDownloadIds"/>",
		"<bean:message  bundle="sys-right" key="right.change.authAttPrintIds"/>"
		];
var tcd =["<bean:message  bundle="sys-right" key="right.category.change.authCateReaderIds"/>",
  		"<bean:message  bundle="sys-right" key="right.category.change.authCateEditorIds"/>"
  		];

function validateCateAuthForm(of){
	clearDocAuth();
	clearCateAuth();
	clearTmpAuth();
	if(!validateEmpty()){
		return false;
	}
	return true;
}
 
function clearDocAuth(){
	if(!(document.getElementById("thisCateChildDocCheck").checked
		|| document.getElementById("thisCateDocCheck").checked)){
		for(var i=0;i<kvd.length;i++){
			if(document.getElementById(kvd[i]+"Ids")){
				document.getElementById(kvd[i]+"Ids").value="";
				document.getElementById(kvd[i]+"Names").value="";
				document.getElementById(kvd[i]+"Check").checked=false;
			}
		}  
	}
}
 
function clearCateAuth(){
	if(!(document.getElementById("thisCateCheck").checked
		|| document.getElementById("thisCateChildAndTmpCheck").checked)){ 
		for(var i=0;i<kcc.length;i++){
			if(document.getElementById(kcc[i]+"Ids")){
				document.getElementById(kcc[i]+"Ids").value="";
				document.getElementById(kcc[i]+"Names").value="";
				document.getElementById(kcc[i]+"Check").checked=false;
			}
		}
	}
}

function clearTmpAuth(){  
	if(!(document.getElementById("thisCateChildAndTmpCheck").checked)){
		for(var i=0;i<kvc.length;i++){
			if(document.getElementById(kvc[i]+"Ids")){
				document.getElementById(kvc[i]+"Ids").value="";
				document.getElementById(kvc[i]+"Names").value="";
				document.getElementById(kvc[i]+"Check").checked=false;
			}
		}
	}
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

function validateEmpty(){
	var oprValue = getOprValue();
	if(!(document.getElementById("thisCateCheck").checked
		|| document.getElementById("thisCateChildAndTmpCheck").checked
		|| document.getElementById("thisCateDocCheck").checked
		||document.getElementById("thisCateChildDocCheck").checked)){
		alert("<bean:message  bundle="sys-right" key="right.category.change.applyto.alert"/>");
		return false;
	}

	if(oprValue=="1" || oprValue=="2"){
		if(!checkProperty("<bean:message  bundle="sys-right" key="right.category.change.tmp"/>",kvc,tsc)){
			return false;
		}
		if(!checkProperty("<bean:message  bundle="sys-right" key="right.category.change.doc"/>",kvd,tsd)){
			return false;
		}
		if(!checkProperty("<bean:message  bundle="sys-right" key="right.category.change.cate"/>",kcc,tcd)){
			return false;
		}
	}
	return true;
}

function checkProperty(zt,pn,pt){
	for(var i=0;i<pn.length;i++){
		var ids = document.getElementById(pn[i]+"Ids");
		var chk = document.getElementById(pn[i]+"Check");
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

function showDocZone(){
	var flag = document.getElementById("thisCateDocCheck").checked || document.getElementById("thisCateChildDocCheck").checked
	for(var i=0;i<kvd.length;i++){
		var zone = document.getElementById(kvd[i]+"Zone");
		if(zone){
			zone.style.display=(flag?"":"none"); 
		}
	}
}

function showTmpZone(){
	var flag = document.getElementById("thisCateChildAndTmpCheck").checked
	for(var i=0;i<kvc.length;i++){
		var zone = document.getElementById(kvc[i]+"Zone");
		if(zone){
			zone.style.display=(flag?"":"none");
		}
	}
}

function showCateZone(){
	var flag = document.getElementById("thisCateCheck").checked || document.getElementById("thisCateChildAndTmpCheck").checked
	for(var i=0;i<kcc.length;i++){
		var zone = document.getElementById(kcc[i]+"Zone");
		if(zone){
			zone.style.display=(flag?"":"none");
		}
	}
}

function showElementInput(el){  
	document.getElementById(el.name+"Input").style.display=el.checked?"":"none";
	var oprValue = getOprValue();
	if(document.getElementById(el.name+"NotFlag")){
		document.getElementById(el.name+"NotFlag").style.display=(oprValue=="1" || oprValue=="2")?"none":"";
	}
	if(document.getElementById(el.name+"Empty")){
		document.getElementById(el.name+"Empty").style.display=(oprValue=="1" || oprValue=="2")?"none":"";
	}
}

function swapNotFlag(el){
	document.getElementById(el.name+"Input").style.display=el.checked?"none":"";
}

var _tmp =["authTmpAttDownloadCheck","authTmpAttPrintCheck","authTmpAttCopyCheck","authAttDownloadCheck","authAttPrintCheck","authAttCopyCheck"];
var _tmpFlag =["authNotReaderFlag","authTmpAttNodownload","authTmpAttNoprint","authTmpAttNocopy","authAttNodownload","authAttNoprint","authAttNocopy"];
function oprOnclickFunc(el){
	for(var i=0;i<_tmp.length;i++){
		if(!document.getElementById(_tmp[i])){
			continue;
		}
		if(document.getElementById(_tmp[i]+"Input").style.display=="none"){
			continue;
		}
		if(el.value=="1" || el.value=="2"){
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

	if(el.value=="1" || el.value=="2"){
		if(document.getElementById("authReaderNoteFlagEmpty")){
			document.getElementById("authReaderNoteFlagEmpty").style.display="none";
		}
	}else{
		if(document.getElementById("authReaderNoteFlagEmpty")){
			document.getElementById("authReaderNoteFlagEmpty").style.display="";
		}
	}

}

window.onload=function(){
	showTmpZone();
	showDocZone();
}

window.onload = function(){
	var fdIds = window.opener.document.getElementById('fdIds').value;
	document.getElementById('fdIds').value = fdIds;
}
</script>
<p class="txttitle"><bean:message bundle="sys-right" key="right.category.change.title.cate"/><bean:message key="button.edit"/></p>

<html:form action="/sys/right/cChangeCateRight.do" method="post" onsubmit="return validateCateAuthForm(this);">
<div id="optBarDiv">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.cChangeCateRightForm, 'cateRightUpdate','fdIds');">

	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=10%>
			<bean:message  bundle="sys-right" key="right.category.change.opr"/>
		</td>
		<td width=90%>
			<sunbor:enums
				property="oprType"
				enumsType="cchange_right_opr"
				elementType="radio" htmlElementProperties="onclick='oprOnclickFunc(this);'"/>
		</td>
	</tr>	

	<tr>
		<td class="td_normal_title" width=10%>
			<bean:message  bundle="sys-right" key="right.category.change.applyto"/>
		</td>
		<td width=90%> 
			<input type="checkbox" name="thisCateCheck" id="thisCateCheck" checked value="true" onclick="showCateZone();">
			<bean:message  bundle="sys-right" key="right.change.thisCateCheck"/>
			<input type="checkbox" name="thisCateChildAndTmpCheck" id="thisCateChildAndTmpCheck" value="true" onclick="showCateZone();showTmpZone();">
			<bean:message  bundle="sys-right" key="right.category.change.thisCateChildAndTmpCheck"/>
			<input type="checkbox" name="thisCateDocCheck"  id="thisCateDocCheck" value="true" onclick="showDocZone();">
			<bean:message  bundle="sys-right" key="right.category.change.thisCateDocCheck"/>
			<input type="checkbox" name="thisCateChildDocCheck" id="thisCateChildDocCheck"  value="true" onclick="showDocZone();">
			<bean:message  bundle="sys-right" key="right.category.change.thisCateChildDocCheck"/>
		</td>
	</tr>	

	<tr>
		<td class="td_normal_title" colspan="2">
			<bean:message  bundle="sys-right" key="right.category.change.updateOption"/>
		</td>
	</tr>	
	
	<tr id="authCateEditorZone">
		<td class="td_normal_title" rowspan="<%=cc%>" width=10%>
			<bean:message  bundle="sys-right" key="right.category.change.cate"/>
		</td>
		<td width=90%>
			<input type="checkbox" name="authCateEditorCheck" id="authCateEditorCheck" value="true" onclick="showElementInput(this)">&nbsp;<bean:message  bundle="sys-right" key="right.change.authCateEditorIds"/><br>
			<html:hidden property="authCateEditorIds" />
			<span id="authCateEditorCheckInput" style="display:none">
			<html:textarea property="authCateEditorNames" readonly="true" styleClass="inputmul" style="width:90%" />
			<a href="#" onclick="Dialog_Address(true, 'authCateEditorIds','authCateEditorNames', ';',null);">
				<bean:message key="dialog.selectOrg"/>
			</a>
			</span>
		</td>
	</tr>
	<% if(cateSet.contains("authReaders")){ %>
	<tr id="authCateReaderZone">
		<td width=90%>
			<input type="checkbox" name="authCateReaderCheck" id="authCateReaderCheck"  value="true" onclick="showElementInput(this)">
			<bean:message  bundle="sys-right" key="right.category.change.authCateReaderIds"/>
			<div id="authCateReaderCheckInput" style="display:none">
			
			<div id="authNotReaderFlagInput">
			<html:hidden property="authCateReaderIds" />
			<html:textarea property="authCateReaderNames" readonly="true" styleClass="inputmul" style="width:90%" />
			<a href="#" onclick="Dialog_Address(true, 'authCateReaderIds','authCateReaderNames', ';',null);">
				<bean:message key="dialog.selectOrg"/>
			</a>
			<div>
			<div id="authCateReaderCheckEmpty" style="display:none">
			<bean:message bundle="sys-right" key="right.category.allUse1" />
			<div>

			</div>
		</td>
	</tr>
	<%}%>
	<tr id="authTemplateEditorZone">
		<td class="td_normal_title" rowspan="<%=ct%>" width=10%>
			<bean:message  bundle="sys-right" key="right.category.change.tmp"/>
		</td>
		<td width=90%>
			<input type="checkbox" name="authTemplateEditorCheck"  id="authTemplateEditorCheck" value="true" onclick="showElementInput(this)">&nbsp;<bean:message  bundle="sys-right" key="right.change.authCateEditorIds"/><br>
			<html:hidden property="authTemplateEditorIds" />
			<span id="authTemplateEditorCheckInput" style="display:none">
			<html:textarea property="authTemplateEditorNames" readonly="true" styleClass="inputmul" style="width:90%" />
			<a href="#" onclick="Dialog_Address(true, 'authTemplateEditorIds','authTemplateEditorNames', ';',null);">
				<bean:message key="dialog.selectOrg"/>
			</a>
			</span>
		</td>
	</tr>
	<% if(tmpSet.contains("authReaders")){ %>
	<tr id="authTemplateReaderZone">
		<td width=90%>
			<input type="checkbox" name="authTemplateReaderCheck"  id="authTemplateReaderCheck" value="true" onclick="showElementInput(this)">
			<bean:message  bundle="sys-right" key="right.category.change.authCateReaderIds"/>
			<div id="authTemplateReaderCheckInput" style="display:none">
			<html:hidden property="authTemplateReaderIds" />
			<html:textarea property="authTemplateReaderNames" readonly="true" styleClass="inputmul" style="width:90%" />
			<a href="#" onclick="Dialog_Address(true, 'authTemplateReaderIds','authTemplateReaderNames', ';',null);">
				<bean:message key="dialog.selectOrg"/>
			</a>
			</div>
		</td>
	</tr>
	<%}%>
	<% if(tmpSet.contains("authTmpReaders")){ %>
	<tr id="authTmpReaderZone">
		<td width=90%>
			<input type="checkbox" name="authTmpReaderCheck" id="authTmpReaderCheck" value="true" onclick="showElementInput(this)">
			<bean:message  bundle="sys-right" key="right.category.change.authTmpReaderIds"/><br>
			<html:hidden property="authTmpReaderIds" />
			<span id="authTmpReaderCheckInput" style="display:none">
			<html:textarea property="authTmpReaderNames" readonly="true" styleClass="inputmul" style="width:90%" />
			<a href="#" onclick="Dialog_Address(true, 'authTmpReaderIds','authTmpReaderNames', ';',null);">
				<bean:message key="dialog.selectOrg"/>
			</a>						
			</span>
		</td>
	</tr>
	<%}%>
	<% if(tmpSet.contains("authTmpEditors")){ %>
	<tr id="authTmpEditorZone">
		<td width=90%>
			<input type="checkbox" name="authTmpEditorCheck"  id="authTmpEditorCheck" value="true" onclick="showElementInput(this)">
			<bean:message  bundle="sys-right" key="right.category.change.authTmpEditorIds"/><br>
			<html:hidden property="authTmpEditorIds" />
			<span id="authTmpEditorCheckInput" style="display:none">
			<html:textarea property="authTmpEditorNames" readonly="true" styleClass="inputmul" style="width:90%" />
			<a href="#" onclick="Dialog_Address(true, 'authTmpEditorIds','authTmpEditorNames', ';',null);">
				<bean:message key="dialog.selectOrg"/>
			</a>						
			</span>
		</td>
	</tr>
	<%}%>
	<% if(tmpSet.contains("authTmpAttDownloads")){ %>
	<tr id="authTmpAttDownloadZone">
		<td width=90%>
			<input type="checkbox" name="authTmpAttDownloadCheck"  id="authTmpAttDownloadCheck" value="true" onclick="showElementInput(this)">
			<bean:message  bundle="sys-right" key="right.category.change.authTmpAttDownloadIds"/>
			<div id="authTmpAttDownloadCheckInput" style="display:none">
			
			<div id="authTmpAttDownloadCheckNotFlag" style="display:none">
			<input type="checkbox" name="authTmpAttNodownload" id="authTmpAttNodownload" value="true" onclick="swapNotFlag(this)">
			<bean:message key="right.category.att.authAttNodownload" bundle="sys-right"/>
			</div>

			<div id="authTmpAttNodownloadInput">
			<html:hidden property="authTmpAttDownloadIds" />
			<html:textarea property="authTmpAttDownloadNames" readonly="true" styleClass="inputmul" style="width:90%" />
			<a href="#" onclick="Dialog_Address(true, 'authTmpAttDownloadIds','authTmpAttDownloadNames', ';',null);">
				<bean:message key="dialog.selectOrg"/>
			</a>
			<div>
			<div id="authTmpAttDownloadCheckEmpty" style="display:none">			
			<bean:message key="right.category.att.authAttDownloads.note" bundle="sys-right"/>
			<div>

			</div>						
		</td>
	</tr>
	<%}%>
	<% if(tmpSet.contains("authTmpAttPrints")){ %>
	<tr id="authTmpAttPrintZone">
		<td width=90%>
			<input type="checkbox" name="authTmpAttPrintCheck"  id="authTmpAttPrintCheck"  value="true" onclick="showElementInput(this)">
			<bean:message  bundle="sys-right" key="right.category.change.authTmpAttPrintIds"/>
			<div id="authTmpAttPrintCheckInput" style="display:none">
			
			<div id="authTmpAttPrintCheckNotFlag" style="display:none">
			<input type="checkbox" name="authTmpAttNoprint" id="authTmpAttNoprint" value="true" onclick="swapNotFlag(this)">
			<bean:message key="right.category.att.authAttNoprint" bundle="sys-right"/>
			</div>

			<div id="authTmpAttNoprintInput">
			<html:hidden property="authTmpAttPrintIds" />
			<html:textarea property="authTmpAttPrintNames" readonly="true" styleClass="inputmul" style="width:90%" />
			<a href="#" onclick="Dialog_Address(true, 'authTmpAttPrintIds','authTmpAttPrintNames', ';',null);">
				<bean:message key="dialog.selectOrg"/>
			</a>
			<div>
			<div id="authTmpAttPrintCheckEmpty" style="display:none">						
			<bean:message key="right.category.att.authAttPrints.note" bundle="sys-right"/>
			<div>

			</div>								
		</td>
	</tr>
	<%}%>
	<% if(tmpSet.contains("authTmpAttCopys")){ %>
	<tr id="authTmpAttCopyZone">
		<td width=90%>
			<input type="checkbox" name="authTmpAttCopyCheck"  id="authTmpAttCopyCheck" value="true" onclick="showElementInput(this)">
			<bean:message  bundle="sys-right" key="right.category.change.authTmpAttCopyIds"/>
			<div id="authTmpAttCopyCheckInput" style="display:none">
			
			<div id="authTmpAttCopyCheckNotFlag" style="display:none">
			<input type="checkbox" name="authTmpAttNocopy" id="authTmpAttNocopy" value="true" onclick="swapNotFlag(this)">
			<bean:message key="right.category.att.authAttNocopy" bundle="sys-right"/>
			</div>

			<div id="authTmpAttNocopyInput">
			<html:hidden property="authTmpAttCopyIds" />
			<html:textarea property="authTmpAttCopyNames" readonly="true" styleClass="inputmul" style="width:90%" />
			<a href="#" onclick="Dialog_Address(true, 'authTmpAttCopyIds','authTmpAttCopyNames', ';',null);">
				<bean:message key="dialog.selectOrg"/>
			</a>
			<div>
			<div id="authTmpAttCopyCheckEmpty" style="display:none">									
			<bean:message key="right.category.att.authAttCopys.note" bundle="sys-right"/>
			<div>

			</div>	
		</td>
	</tr>	
	<%}%>
	
	<tr id="authReaderZone">
		<td class="td_normal_title" rowspan="<%=cm%>" width=10%>
			<bean:message  bundle="sys-right" key="right.change.doc"/>
		</td>
		<td width=90%>
			<input type="checkbox" name="authReaderCheck" id="authReaderCheck" value="true" onclick="showElementInput(this)">&nbsp;<bean:message  bundle="sys-right" key="right.change.authReaderIds"/><br>
			<html:hidden property="authReaderIds" />
			<span id="authReaderCheckInput" style="display:none">
			<html:textarea property="authReaderNames" readonly="true" styleClass="inputmul" style="width:90%" />
			<a href="#" onclick="Dialog_Address(true, 'authReaderIds','authReaderNames', ';',null);">
				<bean:message key="dialog.selectOrg"/>
			</a>
				
				<html:hidden property="authReaderNoteFlag" value="${param.authReaderNoteFlag}"/>
				<c:if test="${empty param.authReaderNoteFlag or param.authReaderNoteFlag=='1'}">
				<div id="authReaderNoteFlagEmpty" style="display:none"><bean:message
				bundle="sys-right" key="right.category.read.authReaders.note" />
				</div>
				</c:if>
				<c:if test="${param.authReaderNoteFlag=='2'}">
				<div id="authReaderNoteFlagEmpty" style="display:none"><bean:message
				bundle="sys-right" key="right.category.read.authReaders.note1" />
				</div>
				</c:if>
			
			</span>
		</td>
	</tr>
	<% if(mSet.contains("authEditors")){ %>
	<tr id="authEditorZone">
		<td width=90%>
			<input type="checkbox" name="authEditorCheck"  id="authEditorCheck" value="true" onclick="showElementInput(this)">
			<bean:message  bundle="sys-right" key="right.category.change.authEditorIds"/><br>
			<html:hidden property="authEditorIds" />
			<span id="authEditorCheckInput" style="display:none">
			<html:textarea property="authEditorNames" readonly="true" styleClass="inputmul" style="width:90%" />
			<a href="#" onclick="Dialog_Address(true, 'authEditorIds','authEditorNames', ';',null);">
				<bean:message key="dialog.selectOrg"/>
			</a>						
			</span>
		</td>
	</tr>
	<%}%>
	<% if(mSet.contains("authAttDownloads")){ %>
	<tr id="authAttDownloadZone">
		<td width=90%>
			<input type="checkbox" name="authAttDownloadCheck"  id="authAttDownloadCheck" value="true" onclick="showElementInput(this)">
			<bean:message  bundle="sys-right" key="right.category.change.authAttDownloadIds"/>
			<div id="authAttDownloadCheckInput" style="display:none">
			
			<div id="authAttDownloadCheckNotFlag" style="display:none">
			<input type="checkbox" name="authAttNodownload"  id="authAttNodownload" value="true" onclick="swapNotFlag(this)">
			<bean:message key="right.category.att.authAttNodownload" bundle="sys-right"/>
			</div>

			<div id="authAttNodownloadInput">
			<html:hidden property="authAttDownloadIds" />
			<html:textarea property="authAttDownloadNames" readonly="true" styleClass="inputmul" style="width:90%" />
			<a href="#" onclick="Dialog_Address(true, 'authAttDownloadIds','authAttDownloadNames', ';',null);">
				<bean:message key="dialog.selectOrg"/>
			</a>
			
			<div>
			<div id="authAttDownloadCheckEmpty" style="display:none">									
			<bean:message key="right.category.att.authAttDownloads.note" bundle="sys-right"/>
			<div>

			</div>		
		</td>
	</tr>
	<%}%>
	<% if(mSet.contains("authAttPrints")){ %>
	<tr id="authAttPrintZone">
		<td width=90%>
			<input type="checkbox" name="authAttPrintCheck"  id="authAttPrintCheck" value="true" onclick="showElementInput(this)">
			<bean:message  bundle="sys-right" key="right.category.change.authAttPrintIds"/>
			<div id="authAttPrintCheckInput" style="display:none">
			
			<div id="authAttPrintCheckNotFlag" style="display:none">
			<input type="checkbox" name="authAttNoprint" value="true" onclick="swapNotFlag(this)">
			<bean:message key="right.category.att.authAttNoprint" bundle="sys-right"/>
			</div>

			<div id="authAttNoprintInput">
			<html:hidden property="authAttPrintIds" />
			<html:textarea property="authAttPrintNames" readonly="true" styleClass="inputmul" style="width:90%" />
			<a href="#" onclick="Dialog_Address(true, 'authAttPrintIds','authAttPrintNames', ';',null);">
				<bean:message key="dialog.selectOrg"/>
			</a>

			<div>
			<div id="authAttPrintCheckEmpty" style="display:none">												
			<bean:message key="right.category.att.authAttPrints.note" bundle="sys-right"/>
			<div>

			</div>	
		</td>
	</tr>
	<%}%>
	<% if(mSet.contains("authAttCopys")){ %>
	<tr id="authAttCopyZone">
		<td width=90%>
			<input type="checkbox" name="authAttCopyCheck" id="authAttCopyCheck" value="true" onclick="showElementInput(this)">
			<bean:message  bundle="sys-right" key="right.category.change.authAttCopyIds"/>
			<div id="authAttCopyCheckInput" style="display:none">
			
			<div id="authAttCopyCheckNotFlag" style="display:none">
			<input type="checkbox" name="authAttNocopy" value="true" onclick="swapNotFlag(this)">
			<bean:message key="right.category.att.authAttNocopy" bundle="sys-right"/>
			</div>

			<div id="authAttNocopyInput">

			<html:hidden property="authAttCopyIds" />
			<html:textarea property="authAttCopyNames" readonly="true" styleClass="inputmul" style="width:90%" />
			<a href="#" onclick="Dialog_Address(true, 'authAttCopyIds','authAttCopyNames', ';',null);">
				<bean:message key="dialog.selectOrg"/>
			</a>
			
			<div>
			<div id="authAttCopyCheckEmpty" style="display:none">												
			<bean:message key="right.category.att.authAttCopys.note" bundle="sys-right"/>
			<div>

			</div>	
		</td>

	</tr>	
	<%}%>
</table>
</center>
<input type="hidden" name="fdIds" id="fdIds" />
<input type="hidden" name="templateModelName" value="${param.tmpModelName}"/>
<input type="hidden" name="modelName" value="${param.mainModelName}"/>
<input type="hidden" name="templateName" value="${param.templateName}"/>
<input type="hidden" name="categoryName" value="${param.categoryName}"/>
<html:hidden property="method_GET"/>
</html:form>
<html:javascript formName="cChangeCateRightForm"   
                 cdata="false" 
                 dynamicJavascript="true" 
                 staticJavascript="false" />
<%@ include file="/resource/jsp/edit_down.jsp"%>


<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@ page import="java.util.Set" %>
<%@ page import="com.landray.kmss.sys.config.dict.SysDataDict" %>
<%
	String tmpModelName = request.getParameter("tmpModelName");
	Set tmpSet =  SysDataDict.getInstance().getModel(tmpModelName).getPropertyMap().keySet();
	String modelName = request.getParameter("mainModelName");
	Set mSet =  SysDataDict.getInstance().getModel(modelName).getPropertyMap().keySet();
	String[] cs = new String[]{"authReaders","authEditors","authTmpReaders","authTmpEditors","authTmpAttCopys","authTmpAttDownloads","authTmpAttPrints"};
	String[] ms = new String[]{"authReaders","authEditors","authAttCopys","authAttDownloads","authAttPrints"};
	int cc = 0,cm=0;
	for(int i=0;i<cs.length;i++){
		if(tmpSet.contains(cs[i])){
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

<kmss:windowTitle subjectKey="sys-right:right.change.title.tmp"
	 moduleKey="${param.moduleMessageKey}" />

<script>
var kvc = ["authTemplateReader","authTemplateEditor","authTmpReader","authTmpEditor","authTmpAttCopy","authTmpAttDownload","authTmpAttPrint"];
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

function validateCateAuthForm(of){
	clearDocAuth();
	clearCateAuth();
	if(!validateEmpty()){
		return false;
	}
	return true;
}

function clearDocAuth(){
	if(!(document.getElementById("thisTemplateDocCheck").checked
		|| document.getElementById("thisTemplateDocCheck").checked)){
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
	if(!(document.getElementById("thisTemplateCheck").checked
		|| document.getElementById("thisTemplateDocCheck").checked)){
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
	if(!(document.getElementById("thisTemplateCheck").checked
		|| document.getElementById("thisTemplateDocCheck").checked)){
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
	var flag = document.getElementById("thisTemplateDocCheck").checked
	for(var i=0;i<kvd.length;i++){
		var zone = document.getElementById(kvd[i]+"Zone");
		if(zone){
			zone.style.display=(flag?"":"none"); 
		}
	}
}

function showTmpZone(){
	var flag = document.getElementById("thisTemplateCheck").checked
	for(var i=0;i<kvc.length;i++){
		var zone = document.getElementById(kvc[i]+"Zone");
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
var _tmpFlag =["authTmpAttNodownload","authTmpAttNoprint","authTmpAttNocopy","authAttNodownload","authAttNoprint","authAttNocopy"];
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

window.onload=function(){
	showDocZone();

	var fdIds = window.opener.document.getElementById('fdIds').value;
	document.getElementById('fdIds').value = fdIds;
};
</script>
<p class="txttitle"><bean:message bundle="sys-right" key="right.category.change.title.tmp"/><bean:message key="button.edit"/></p>

<html:form action="/sys/right/cChangeTmpRight.do" method="post" onsubmit="return validateCateAuthForm(this);">
<div id="optBarDiv">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.cChangeTmpRightForm, 'tmpRightUpdate','fdIds');">

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
			<input type="checkbox" name="thisTemplateCheck" checked value="true" onclick="showTmpZone();">
			<bean:message  bundle="sys-right" key="right.category.change.thisTmpCheck"/>
			<input type="checkbox" name="thisTemplateDocCheck" value="true" onclick="showDocZone();">
			<bean:message  bundle="sys-right" key="right.category.change.thisTmpDocCheck"/>
		</td>
	</tr>	

	<tr>
		<td class="td_normal_title" colspan="2">
			<bean:message  bundle="sys-right" key="right.category.change.updateOption"/>
		</td>
	</tr>	

	<tr id="authTemplateEditorZone">
		<td class="td_normal_title" rowspan="<%=cc%>" width=10%>
			<bean:message  bundle="sys-right" key="right.category.change.tmp"/>
		</td>
		<td width=90%>
			<input type="checkbox" name="authTemplateEditorCheck" value="true" onclick="showElementInput(this)">&nbsp;<bean:message  bundle="sys-right" key="right.change.authCateEditorIds"/><br>
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
			<input type="checkbox" name="authTemplateReaderCheck" value="true" onclick="showElementInput(this)">
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
			<input type="checkbox" name="authTmpReaderCheck" value="true" onclick="showElementInput(this)">
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
			<input type="checkbox" name="authTmpEditorCheck" value="true" onclick="showElementInput(this)">
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
			<input type="checkbox" name="authTmpAttDownloadCheck" value="true" onclick="showElementInput(this)">
			<bean:message  bundle="sys-right" key="right.category.change.authTmpAttDownloadIds"/>
			<div id="authTmpAttDownloadCheckInput" style="display:none">
			
			<div id="authTmpAttDownloadCheckNotFlag" style="display:none">
			<input type="checkbox" name="authTmpAttNodownload" value="true" onclick="swapNotFlag(this)">
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
			<input type="checkbox" name="authTmpAttPrintCheck" value="true" onclick="showElementInput(this)">
			<bean:message  bundle="sys-right" key="right.category.change.authTmpAttPrintIds"/>
			<div id="authTmpAttPrintCheckInput" style="display:none">
			
			<div id="authTmpAttPrintCheckNotFlag" style="display:none">
			<input type="checkbox" name="authTmpAttNoprint" value="true" onclick="swapNotFlag(this)">
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
			<input type="checkbox" name="authTmpAttCopyCheck" value="true" onclick="showElementInput(this)">
			<bean:message  bundle="sys-right" key="right.category.change.authTmpAttCopyIds"/>
			<div id="authTmpAttCopyCheckInput" style="display:none">
			
			<div id="authTmpAttCopyCheckNotFlag" style="display:none">
			<input type="checkbox" name="authTmpAttNocopy" value="true" onclick="swapNotFlag(this)">
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
			<input type="checkbox" name="authReaderCheck" value="true" onclick="showElementInput(this)">&nbsp;<bean:message  bundle="sys-right" key="right.change.authReaderIds"/><br>
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
			<input type="checkbox" name="authEditorCheck" value="true" onclick="showElementInput(this)">
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
			<input type="checkbox" name="authAttDownloadCheck" value="true" onclick="showElementInput(this)">
			<bean:message  bundle="sys-right" key="right.category.change.authAttDownloadIds"/>
			<div id="authAttDownloadCheckInput" style="display:none">
			
			<div id="authAttDownloadCheckNotFlag" style="display:none">
			<input type="checkbox" name="authAttNodownload" value="true" onclick="swapNotFlag(this)">
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
			<input type="checkbox" name="authAttPrintCheck" value="true" onclick="showElementInput(this)">
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
			<input type="checkbox" name="authAttCopyCheck" value="true" onclick="showElementInput(this)">
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
<input type="hidden" name="fdIds"/>
<input type="hidden" name="templateModelName" value="${param.tmpModelName}"/>
<input type="hidden" name="modelName" value="${param.mainModelName}"/>
<input type="hidden" name="templateName" value="${param.templateName}"/>
<html:hidden property="method_GET"/>
</html:form>
<html:javascript formName="cChangeTmpRightForm" 
                 cdata="false" 
                 dynamicJavascript="true" 
                 staticJavascript="false" />
<%@ include file="/resource/jsp/edit_down.jsp"%>


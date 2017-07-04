<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@ page import="java.util.Set" %>
<%@ page import="com.landray.kmss.sys.config.dict.SysDataDict" %>
<%
	String cateModelName = request.getParameter("cateModelName");
	Set cateSet =  SysDataDict.getInstance().getModel(cateModelName).getPropertyMap().keySet();
	String modelName = request.getParameter("modelName");
	Set mSet =  SysDataDict.getInstance().getModel(modelName).getPropertyMap().keySet();
	String[] cs = new String[]{"authReaders","authEditors","authTmpReaders","authTmpEditors","authTmpAttCopys","authTmpAttDownloads","authTmpAttPrints"};
	String[] ms = new String[]{"authReaders","authEditors","authAttCopys","authAttDownloads","authAttPrints"};
	int cc = 0,cm=0;
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
var kvc = ["authCateReader","authCateEditor","authTmpReader","authTmpEditor","authTmpAttCopy","authTmpAttDownload","authTmpAttPrint"];
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
	if(!(document.getElementsByName("thisCateDocCheck")[0].checked
		|| document.getElementsByName("thisCateChildDocCheck")[0].checked)){
		for(var i=0;i<kvd.length;i++){
			if(document.getElementsByName(kvd[i]+"Ids")[0]){
				document.getElementsByName(kvd[i]+"Ids")[0].value="";
				document.getElementsByName(kvd[i]+"Names")[0].value="";
				document.getElementsByName(kvd[i]+"Check")[0].checked=false;
			}
		}
	}
}

function clearCateAuth(){
	if(!(document.getElementsByName("thisCateCheck")[0].checked
		|| document.getElementsByName("thisCateChildCheck")[0].checked)){
		for(var i=0;i<kvc.length;i++){
			if(document.getElementsByName(kvc[i]+"Ids")[0]){
				document.getElementsByName(kvc[i]+"Ids")[0].value="";
				document.getElementsByName(kvc[i]+"Names")[0].value="";
				document.getElementsByName(kvc[i]+"Check")[0].checked=false;
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
	
	if(!(document.getElementsByName("thisCateCheck")[0].checked
		|| document.getElementsByName("thisCateDocCheck")[0].checked
		|| document.getElementsByName("thisCateChildCheck")[0].checked
		|| document.getElementsByName("thisCateChildDocCheck")[0].checked)){
		alert("<bean:message  bundle="sys-right" key="right.change.applyto.alert"/>");
		return false;
	}

	if(oprValue=="1"||oprValue=="3"){
		if(!checkProperty("<bean:message  bundle="sys-right" key="right.change.cate"/>",kvc,tsc)){
			return false;
		}
		if(!checkProperty("<bean:message  bundle="sys-right" key="right.change.doc"/>",kvd,tsd)){
			return false;
		}
	}
	return true;
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

function showDocZone(){
	var flag = document.getElementsByName("thisCateDocCheck")[0].checked || document.getElementsByName("thisCateChildDocCheck")[0].checked
	for(var i=0;i<kvd.length;i++){
		var zone = document.getElementById(kvd[i]+"Zone");
		if(zone){
			zone.style.display=(flag?"":"none");
		}
	}
}

function showCateZone(){
	var flag = document.getElementsByName("thisCateCheck")[0].checked || document.getElementsByName("thisCateChildCheck")[0].checked
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
		document.getElementById(el.name+"NotFlag").style.display=(oprValue=="1")?"none":"";
	}
	if(document.getElementById(el.name+"Empty")){
		document.getElementById(el.name+"Empty").style.display=(oprValue=="1")?"none":"";
	}
}

function swapNotFlag(el){
	document.getElementById(el.name+"Input").style.display=el.checked?"none":"";
}

var _tmp =["authCateReaderCheck","authTmpAttDownloadCheck","authTmpAttPrintCheck","authTmpAttCopyCheck","authAttDownloadCheck","authAttPrintCheck","authAttCopyCheck"];
var _tmpFlag =["authNotReaderFlag","authTmpAttNodownload","authTmpAttNoprint","authTmpAttNocopy","authAttNodownload","authAttNoprint","authAttNocopy"];
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

window.onload = function(){
	showDocZone();
}

</script>
<p class="txttitle"><bean:message bundle="sys-right" key="right.change.title.cate"/><bean:message key="button.edit"/></p>

<html:form action="/sys/right/rightCateChange.do" method="post" onsubmit="return validateCateAuthForm(this);">
<div id="optBarDiv">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.cateAuthForm, 'cateRightUpdate','fdIds');">

	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=10%>
			<bean:message  bundle="sys-right" key="right.change.cate.name"/>
		</td>
		<td width=90%>
			${cateNames}
		</td>
	</tr>	
	<tr>
		<td class="td_normal_title" width=10%>
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
		<td class="td_normal_title" width=10%>
			<bean:message  bundle="sys-right" key="right.change.applyto"/>
		</td>
		<td width=90%>
			<input type="checkbox" name="thisCateCheck" checked value="true" onclick="showCateZone();">
			<bean:message  bundle="sys-right" key="right.change.thisCateCheck"/>
			<input type="checkbox" name="thisCateDocCheck" value="true" onclick="showDocZone();">
			<bean:message  bundle="sys-right" key="right.change.thisCateDocCheck"/>
			<input type="checkbox" name="thisCateChildCheck" value="true" onclick="showCateZone();">
			<bean:message  bundle="sys-right" key="right.change.thisCateChildCheck"/>
			<input type="checkbox" name="thisCateChildDocCheck" value="true" onclick="showDocZone();">
			<bean:message  bundle="sys-right" key="right.change.thisCateChildDocCheck"/>
		</td>
	</tr>	

	<tr>
		<td class="td_normal_title" colspan="2">
			<bean:message  bundle="sys-right" key="right.change.updateOption"/>
		</td>
	</tr>	

	<tr id="authCateEditorZone">
		<td class="td_normal_title" rowspan="<%=cc%>" width=10%>
			<bean:message  bundle="sys-right" key="right.change.cate"/>
		</td>
		<td width=90%>
			<input type="checkbox" name="authCateEditorCheck" value="true" onclick="showElementInput(this)">&nbsp;<bean:message  bundle="sys-right" key="right.change.authCateEditorIds"/><br>
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
			<input type="checkbox" name="authCateReaderCheck" value="true" onclick="showElementInput(this)">
			<bean:message  bundle="sys-right" key="right.change.authCateReaderIds"/>
			<div id="authCateReaderCheckInput" style="display:none">
			
			<div id="authCateReaderCheckNotFlag" style="display:none">
			<input type="checkbox" name="authNotReaderFlag" value="true" onclick="swapNotFlag(this)">
			<bean:message bundle="sys-simplecategory" key="description.main.tempReader.notUse" />
			</div>

			<div id="authNotReaderFlagInput">
			<html:hidden property="authCateReaderIds" />
			<html:textarea property="authCateReaderNames" readonly="true" styleClass="inputmul" style="width:90%" />
			<a href="#" onclick="Dialog_Address(true, 'authCateReaderIds','authCateReaderNames', ';',null);">
				<bean:message key="dialog.selectOrg"/>
			</a>
			</div>
			<div id="authCateReaderCheckEmpty" style="display:none">
			<bean:message bundle="sys-simplecategory" key="description.main.tempReader.allUse" />
			</div>

			</div>
		</td>
	</tr>
	<%}%>
	<% if(cateSet.contains("authTmpReaders")){ %>
	<tr id="authTmpReaderZone">
		<td width=90%>
			<input type="checkbox" name="authTmpReaderCheck" value="true" onclick="showElementInput(this)">
			<bean:message  bundle="sys-right" key="right.change.authTmpReaderIds"/><br>
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
	<% if(cateSet.contains("authTmpEditors")){ %>
	<tr id="authTmpEditorZone">
		<td width=90%>
			<input type="checkbox" name="authTmpEditorCheck" value="true" onclick="showElementInput(this)">
			<bean:message  bundle="sys-right" key="right.change.authTmpEditorIds"/><br>
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
	<% if(cateSet.contains("authTmpAttDownloads")){ %>
	<tr id="authTmpAttDownloadZone">
		<td width=90%>
			<input type="checkbox" name="authTmpAttDownloadCheck" value="true" onclick="showElementInput(this)">
			<bean:message  bundle="sys-right" key="right.change.authTmpAttDownloadIds"/>
			<div id="authTmpAttDownloadCheckInput" style="display:none">
			
			<div id="authTmpAttDownloadCheckNotFlag" style="display:none">
			<input type="checkbox" name="authTmpAttNodownload" value="true" onclick="swapNotFlag(this)">
			<bean:message key="right.att.authAttNodownload" bundle="sys-right"/>
			</div>

			<div id="authTmpAttNodownloadInput">
			<html:hidden property="authTmpAttDownloadIds" />
			<html:textarea property="authTmpAttDownloadNames" readonly="true" styleClass="inputmul" style="width:90%" />
			<a href="#" onclick="Dialog_Address(true, 'authTmpAttDownloadIds','authTmpAttDownloadNames', ';',null);">
				<bean:message key="dialog.selectOrg"/>
			</a>
			<div>
			<div id="authTmpAttDownloadCheckEmpty" style="display:none">			
			<bean:message key="right.att.authAttDownloads.note" bundle="sys-right"/>
			<div>

			</div>						
		</td>
	</tr>
	<%}%>
	<% if(cateSet.contains("authTmpAttPrints")){ %>
	<tr id="authTmpAttPrintZone">
		<td width=90%>
			<input type="checkbox" name="authTmpAttPrintCheck" value="true" onclick="showElementInput(this)">
			<bean:message  bundle="sys-right" key="right.change.authTmpAttPrintIds"/>
			<div id="authTmpAttPrintCheckInput" style="display:none">
			
			<div id="authTmpAttPrintCheckNotFlag" style="display:none">
			<input type="checkbox" name="authTmpAttNoprint" value="true" onclick="swapNotFlag(this)">
			<bean:message key="right.att.authAttNoprint" bundle="sys-right"/>
			</div>

			<div id="authTmpAttNoprintInput">
			<html:hidden property="authTmpAttPrintIds" />
			<html:textarea property="authTmpAttPrintNames" readonly="true" styleClass="inputmul" style="width:90%" />
			<a href="#" onclick="Dialog_Address(true, 'authTmpAttPrintIds','authTmpAttPrintNames', ';',null);">
				<bean:message key="dialog.selectOrg"/>
			</a>
			<div>
			<div id="authTmpAttPrintCheckEmpty" style="display:none">						
			<bean:message key="right.att.authAttPrints.note" bundle="sys-right"/>
			<div>

			</div>								
		</td>
	</tr>
	<%}%>
	<% if(cateSet.contains("authTmpAttCopys")){ %>
	<tr id="authTmpAttCopyZone">
		<td width=90%>
			<input type="checkbox" name="authTmpAttCopyCheck" value="true" onclick="showElementInput(this)">
			<bean:message  bundle="sys-right" key="right.change.authTmpAttCopyIds"/>
			<div id="authTmpAttCopyCheckInput" style="display:none">
			
			<div id="authTmpAttCopyCheckNotFlag" style="display:none">
			<input type="checkbox" name="authTmpAttNocopy" value="true" onclick="swapNotFlag(this)">
			<bean:message key="right.att.authAttNocopy" bundle="sys-right"/>
			</div>

			<div id="authTmpAttNocopyInput">
			<html:hidden property="authTmpAttCopyIds" />
			<html:textarea property="authTmpAttCopyNames" readonly="true" styleClass="inputmul" style="width:90%" />
			<a href="#" onclick="Dialog_Address(true, 'authTmpAttCopyIds','authTmpAttCopyNames', ';',null);">
				<bean:message key="dialog.selectOrg"/>
			</a>
			<div>
			<div id="authTmpAttCopyCheckEmpty" style="display:none">									
			<bean:message key="right.att.authAttCopys.note" bundle="sys-right"/>
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
				bundle="sys-right" key="right.read.authReaders.note" />
				</div>
				</c:if>
				<c:if test="${param.authReaderNoteFlag=='2'}">
				<div id="authReaderNoteFlagEmpty" style="display:none"><bean:message
				bundle="sys-right" key="right.read.authReaders.note1" />
				</div>
				</c:if>
			
			</span>
		</td>
	</tr>
	<% if(mSet.contains("authEditors")){ %>
	<tr id="authEditorZone">
		<td width=90%>
			<input type="checkbox" name="authEditorCheck" value="true" onclick="showElementInput(this)">
			<bean:message  bundle="sys-right" key="right.change.authEditorIds"/><br>
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
			<bean:message  bundle="sys-right" key="right.change.authAttDownloadIds"/>
			<div id="authAttDownloadCheckInput" style="display:none">
			
			<div id="authAttDownloadCheckNotFlag" style="display:none">
			<input type="checkbox" name="authAttNodownload" value="true" onclick="swapNotFlag(this)">
			<bean:message key="right.att.authAttNodownload" bundle="sys-right"/>
			</div>

			<div id="authAttNodownloadInput">
			<html:hidden property="authAttDownloadIds" />
			<html:textarea property="authAttDownloadNames" readonly="true" styleClass="inputmul" style="width:90%" />
			<a href="#" onclick="Dialog_Address(true, 'authAttDownloadIds','authAttDownloadNames', ';',null);">
				<bean:message key="dialog.selectOrg"/>
			</a>
			
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
			<html:hidden property="authAttPrintIds" />
			<html:textarea property="authAttPrintNames" readonly="true" styleClass="inputmul" style="width:90%" />
			<a href="#" onclick="Dialog_Address(true, 'authAttPrintIds','authAttPrintNames', ';',null);">
				<bean:message key="dialog.selectOrg"/>
			</a>

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

			<html:hidden property="authAttCopyIds" />
			<html:textarea property="authAttCopyNames" readonly="true" styleClass="inputmul" style="width:90%" />
			<a href="#" onclick="Dialog_Address(true, 'authAttCopyIds','authAttCopyNames', ';',null);">
				<bean:message key="dialog.selectOrg"/>
			</a>
			
			<div>
			<div id="authAttCopyCheckEmpty" style="display:none">												
			<bean:message key="right.att.authAttCopys.note" bundle="sys-right"/>
			<div>

			</div>	
		</td>

	</tr>	
	<%}%>
	
</table>
</center>
<html:hidden property="fdIds" value="${param.fdIds}"/>
<html:hidden property="modelName" value="${param.modelName}"/>
<html:hidden property="cateModelName" value="${param.cateModelName}"/>
<html:hidden property="docFkName" value="${param.docFkName}"/>
<html:hidden property="method_GET"/>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="java.util.List"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<template:include ref="default.simple" sidebar="no">
<template:replace name="body">
<script language="JavaScript">
seajs.use(['theme!form']);
</script>
<c:set var="p_defconfig" value="${p_defconfig}" scope="request"/>
<%
String base = (String)request.getAttribute("base");
String info = (String)request.getAttribute("info");
String note = (String)request.getAttribute("note");
String p_config=request.getParameter("p_config");
java.util.ArrayList showConfig = new java.util.ArrayList(3);
if (p_config == null || p_config.length() == 0 ) {
	if(!"0".equals(base))
		showConfig.add("base");
	if(!"0".equals(info))
		showConfig.add("info");
	if(!"0".equals(note))
		showConfig.add("note");
	
} else {
	String[] configs = p_config.split(";");
	for (int i = 0; i < configs.length; i ++) {
		String cfg = configs[i];
		if (cfg != null && cfg.length() != 0 ) {
			showConfig.add(cfg);
		}
	}
}
String defValue = "";
for (int i = 0; i < showConfig.size(); i ++) {
	defValue += ",'" + showConfig.get(i) + "'";
}
defValue = defValue.substring(1);
%>
<script>
Com_IncludeFile("dialog.js|doclist.js");
var defValue = [<%=defValue%>];
var defOptions = [{id:'base', name:'<bean:message bundle="km-review" key="kmReviewDocumentLableName.baseInfo" />'}, 
                  {id:'info', name:'<bean:message bundle="km-review" key="kmReviewDocumentLableName.reviewContent" />'}, 
                  {id:'note', name:'<bean:message bundle="km-review" key="kmReviewMain.flow.trail" />'}];
function ShowPrintList() {
	var optionData = new KMSSData();
	optionData.AddHashMapArray(defOptions);
	var valueData = new KMSSData();
	for (var i = 0; i < defValue.length; i ++) {
		var defV = defValue[i];
		for (var j = 0; j < defOptions.length; j ++) {
			var opt = defOptions[j];
			if (opt.id == defV) {
				valueData.AddHashMap(opt);
			}
		}
	}
	
	var dialog = new KMSSDialog(true, true);
	dialog.AddDefaultOption(optionData);
	dialog.AddDefaultValue(valueData);
	dialog.SetAfterShow(function(rtn) {
		if (rtn == null || rtn.IsEmpty()) {
			return ;
		}
		var value = '';
		var values = rtn.GetHashMapArray();
		
		for (var i = 0; i < values.length; i ++) {
			value += ';' + values[i].id;
		}
		var url = Com_SetUrlParameter(window.location.href, 'p_config', value);
		window.location.href = url;
	});
	dialog.Show();
}
var toPageBreak = false;
function ShowToPageBreak(event) {
	event.cancelBubble = true;
	toPageBreak = true;
	document.body.style.cursor = 'pointer';
}
<%--var cancelPageBreak = false;
function HiddenPageBreak() {
	event.cancelBubble = true;
	cancelPageBreak = true;
	document.body.style.cursor = 'pointer';
}--%>
function AbsPosition(node, stopNode) {
	var x = y = 0;
	for (var pNode = node; pNode != null && pNode !== stopNode; pNode = pNode.offsetParent) {
		x += pNode.offsetLeft - pNode.scrollLeft; y += pNode.offsetTop - pNode.scrollTop;
	}
	x = x + document.body.scrollLeft;
	y = y + document.body.scrollTop;
	return {'x':x, 'y':y};
};
function MousePosition(event) {
	if(event.pageX || event.pageY) return {x:event.pageX, y:event.pageY};
	return {
		x:event.clientX + document.body.scrollLeft - document.body.clientLeft,
		y:event.clientY + document.body.scrollTop  - document.body.clientTop
	};
};
function SetPageBreakLine(tr) {
	var pos = AbsPosition(tr);
	var line = document.createElement('div');
	line.className = 'page_line';
	line.style.top = pos.y + 'px';
	line.style.left = '0px';
	line.id = 'line_' + tr.uniqueID;
	document.body.appendChild(line);
}
function RemovePageBreakLine(tr) {
	var line = document.getElementById('line_' + tr.uniqueID);
	if (line != null)
		document.body.removeChild(line);
	line = null;
}
Com_AddEventListener(document, "click", function(event) {
	if (toPageBreak) {
		event = event || window.event;
		toPageBreak = false;
		document.body.style.cursor = 'default';
		var target = event.target || event.srcElement;
		while(target) {
			if (target.tagName != null && (target.tagName == 'TR' ||target.tagName=="DIV")) {
				<%--if (target.style.pageBreakBefore == 'always') {
					RemovePageBreakLine(target);
					target.style.pageBreakBefore = 'auto';
				} else {
					SetPageBreakLine(target);
					target.style.pageBreakBefore = 'always';
				}--%>
				if (target.printTr == 'true') {
					var pos = MousePosition(event);
					var tables = target.getElementsByTagName('table');
					var mtable = null, msize = 0, m = 0;
					for (var n = 0; n < tables.length; n ++) {
						var tb = tables[n];
						var tbp = AbsPosition(tb);
						if (mtable == null) {
							mtable = tb;
							msize = Math.abs(pos.y - tbp.y);
							continue;
						}
						m = Math.abs(pos.y - tbp.y);
						if (m < msize) {
							msize = m;
							mtable = tb;
						}
					}
					if (mtable == null)
						break;
					target = mtable.rows[0];
				}
				if (target.tagName=='TR' && target.rowIndex == 0) {
					target = target.parentNode.parentNode;
				}
				if (target.className.indexOf('new_page') > -1) {
					RemovePageBreakLine(target);
					target.className = target.className.replace(/new_page/g, '');
				} else if(target.className.indexOf("page_line")==-1) {
					SetPageBreakLine(target);
					target.className = 'new_page ' + target.className;
				}
				break;
			} else {
				target = target.parentNode;
			}
		}
	}
	<%--else if (cancelPageBreak) {
		event = event || window.event;
		cancelPageBreak = false;
		document.body.style.cursor = 'default';
		var target = event.target || event.srcElement;
		while(target) {
			if (target.tagName != null && target.tagName == 'TR') {
				if (target.rowIndex == 0) {
					target = target.parentNode.parentNode;
				}
				target.className = target.className.toString().replace(/new_page/g, '');
				break;
			} else {
				target = target.parentNode;
			}
		}
	}--%>
});
function ZoomFontSize(size) {
	var root = document.getElementById("printTable");
	var i = 0;
	//alert(root.currentStyle.fontSize);
	for (i = 0; i < root.childNodes.length; i++) {
		SetZoomFontSize(root.childNodes[i], size);
	}
	var tag_fontsize;
	if(root.currentStyle){
	    tag_fontsize = root.currentStyle.fontSize;  
	}  
	else{  
	    tag_fontsize = getComputedStyle(root, null).fontSize;  
	} 
	root.style.fontSize = parseInt(tag_fontsize) + size + 'px';
}
function SetZoomFontSize(dom, size) {
	if (dom.nodeType == 1 && dom.tagName != 'OBJECT' && dom.tagName != 'SCRIPT' && dom.tagName != 'STYLE' && dom.tagName != 'HTML') {
		for (var i = 0; i < dom.childNodes.length; i ++) {
			SetZoomFontSize(dom.childNodes[i], size);
		}
		var tag_fontsize;
		if(dom.currentStyle){  
		    tag_fontsize = dom.currentStyle.fontSize;  
		}  
		else{  
		    tag_fontsize = getComputedStyle(dom, null).fontSize;  
		} 
		dom.style.fontSize = parseInt(tag_fontsize) + size + 'px';
	}
}
function ClearDomWidth(dom) {
	if (dom != null && dom.nodeType == 1 && dom.tagName != 'OBJECT' && dom.tagName != 'SCRIPT' && dom.tagName != 'STYLE' && dom.tagName != 'HTML') {
		//修改打印布局为 百分比布局 #曹映辉 2014.8.7
			/****
			var w = dom.getAttribute("width");
			if (w != '100%')
				dom.removeAttribute("width");
			w = dom.style.width;
			if (w != '100%')
				dom.style.removeAttribute("width");
			****/
			if (dom.style.whiteSpace == 'nowrap') {
				dom.style.whiteSpace = 'normal';
			}
			if (dom.style.display == 'inline') {
				dom.style.wordBreak  = 'break-all';
				dom.style.wordWrap  = 'break-word';
			}
		ClearDomsWidth(dom);
	}
}
function ClearDomsWidth(root) {
	for (var i = 0; i < root.childNodes.length; i ++) {
		ClearDomWidth(root.childNodes[i]);
	}
}
function printView() {
	try {
		PageSetup_temp();
		PageSetup_Null();
		document.getElementById('WebBrowser').ExecWB(7,1);
	    PageSetup_Default();
	} catch (e) {
		alert("<bean:message key="button.printPreview.error" bundle="km-review"/>");
	}
}

Com_AddEventListener(window, "load", function() {
	
	ClearDomWidth(document.getElementById("info_content"));
});
</script>
<script>Com_IncludeFile("jquery.js");</script>

<script>
//修改打印布局为 百分比布局 #曹映辉 2014.8.7
$(function(){
	//对非百分比布局的表格 强制设置为百分比模式 
	$("#info_content").find("table[layout_scale!=true]").each(function(i,tb){
		if(tb.rows.length==0){
			return true;
		}
		tb.style.width="100%";
		var totalWidth=0;
		for(var i=0;i<tb.rows[0].cells.length;i++){
			totalWidth+=$(tb.rows[0].cells[i]).width();;
		}
		for(var i=0;i<tb.rows[0].cells.length;i++){
			tb.rows[0].cells[i].style.width=($(tb.rows[0].cells[i]).width()/totalWidth)*100+"%";
		}
	});
});
</script>
<SCRIPT language=javascript>  
var HKEY_Root,HKEY_Path,HKEY_Key;   
HKEY_Root="HKEY_CURRENT_USER";   
HKEY_Path="\\Software\\Microsoft\\Internet Explorer\\PageSetup\\";   
var head,foot,top,bottom,left,right;  
  
//取得页面打印设置的原参数数据  
function PageSetup_temp() {    
  var Wsh=new ActiveXObject("WScript.Shell");   
  HKEY_Key="header";   
//取得页眉默认值  
  head = Wsh.RegRead(HKEY_Root+HKEY_Path+HKEY_Key);   
  HKEY_Key="footer";   
//取得页脚默认值  
  foot = Wsh.RegRead(HKEY_Root+HKEY_Path+HKEY_Key);   
  HKEY_Key="margin_bottom";   
//取得下页边距  
  bottom = Wsh.RegRead(HKEY_Root+HKEY_Path+HKEY_Key);   
  HKEY_Key="margin_left";   
//取得左页边距  
  left = Wsh.RegRead(HKEY_Root+HKEY_Path+HKEY_Key);   
  HKEY_Key="margin_right";   
//取得右页边距  
  right = Wsh.RegRead(HKEY_Root+HKEY_Path+HKEY_Key);   
  HKEY_Key="margin_top";   
//取得上页边距  
  top = Wsh.RegRead(HKEY_Root+HKEY_Path+HKEY_Key);   
  
}  
  
//设置网页打印的页眉页脚和页边距  
function PageSetup_Null()   
{     
  var Wsh=new ActiveXObject("WScript.Shell");   
  HKEY_Key="header";   
//设置页眉（为空）  
  Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,"");   
  HKEY_Key="footer";   
//设置页脚（为空）  
  Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,"");   
  HKEY_Key="margin_bottom";   
//设置下页边距（0）  
  Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,"0");   
  HKEY_Key="margin_left";   
//设置左页边距（0）  
  Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,"0");   
  HKEY_Key="margin_right";   
//设置右页边距（0）  
  Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,"0");   
  HKEY_Key="margin_top";   
//设置上页边距（8）  
  Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,"0");   

}   
//设置网页打印的页眉页脚和页边距为默认值   
function  PageSetup_Default()   
{     

  var Wsh=new ActiveXObject("WScript.Shell");   
  HKEY_Key="header";   
  HKEY_Key="header";   
//还原页眉  
  Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,head);   
  HKEY_Key="footer";   
//还原页脚  
  Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,foot);   
  HKEY_Key="margin_bottom";   
//还原下页边距  
  Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,bottom);   
  HKEY_Key="margin_left";   
//还原左页边距  
  Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,left);   
  HKEY_Key="margin_right";   
//还原右页边距  
  Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,right);   
  HKEY_Key="margin_top";   
//还原上页边距  
  Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,top);    
}  
  
function printorder()  
{  
	try {
        PageSetup_temp();//取得默认值  
        PageSetup_Null();//设置页面  
        WebBrowser.execwb(6,6);//打印页面  
        PageSetup_Default();//还原页面设置  
	} catch (e) {
		alert("<bean:message key="button.printPreview.error" bundle="km-review"/>");
	}
        //factory.execwb(6,6);  
       // window.close();  
}  
</script>
<style type="text/css">
	#title {
		font-size: 22px;
		color: #000;
	}
	.tr_label_title td {
		font-weight: 900;
		font-size: 16px;
		color: #000;
	}
	.page_line {
		background-color: red;
		height: 1px;
		border: none;
		width: 100%;
		position: absolute;
		overflow: hidden;
	}
	/*
	.td_normal,
	.tb_normal,
	.tb_normal td,
	.tr_normal_title,
	.td_normal_title {
		border: 1px #000 solid;
		color: #000;
	}
	*/
	
@media print {
	#optBarDiv, #S_OperationBar {
		display: none;
	}
	.new_page {
		page-break-before : always;
	}
	.page_line {
		display: none;
	}
	body {
		font-size: 12px;
	}
	
	#printTable table, #printTable td {
		border: 1px #000 solid;
		color: #000;
		/*font-weight: 600;*/
	}
	#printTable .tb_noborder,
	#printTable table .tb_noborder,
	#printTable .tb_noborder td {
		border: none;
	}
	#printTable .tr_label_title {
		/*font-weight: 900;*/
	}
}
</style>
<OBJECT ID='WebBrowser' NAME="WebBrowser" WIDTH=0 HEIGHT=0 CLASSID='CLSID:8856F961-340A-11D0-A96B-00C04FD705A2'></OBJECT>
<div id="optBarDiv" style="text-align: right;padding-right: 40px;padding-bottom: 20px;">
	<%--input type="button" value="清除宽度" onclick="ClearDomWidth(document.getElementById('info_content'));"--%>
	<input class="lui_form_button" type="button" value="<bean:message key="button.zoom.in" bundle="km-review"/>" onclick="ZoomFontSize(5);">
	<input class="lui_form_button" type="button" value="<bean:message key="button.zoom.out" bundle="km-review"/>" onclick="ZoomFontSize(-5);">
	<input class="lui_form_button" type="button" value="<bean:message key="button.pageBreak" bundle="km-review"/>" onclick="ShowToPageBreak(event);" title="<bean:message key="button.pageBreak.title" bundle="km-review"/>">
	<%--input type="button" value="<bean:message key="button.cancelPageBreak" bundle="km-review"/>" onclick="HiddenPageBreak(event);"--%>
	<input class="lui_form_button" type="button" value="<bean:message key="button.print"/>" onclick="printorder();">
	<input class="lui_form_button" type="button" value="<bean:message key="button.printPreview" bundle="km-review"/>" onclick="printView();">
	<input class="lui_form_button" type="button" value="<bean:message key="button.printConfig" bundle="km-review"/>" onclick="ShowPrintList();">
	<input class="lui_form_button" type="button" value="<bean:message key="button.close"/>" onclick="window.close();">
</div>
<center>
<p id="title" class="txttitle"><bean:write name="kmReviewMainForm" property="fdTemplateName" /></p>
<div id="printTable" class="tb_normal" style="border: none;font-size: 12px;">
<div printTr="true" style="border: none;">

<%-- 基本信息 width="650px" --%>
<% 
for (int i = 0; i < showConfig.size(); i ++) {
	String cfg = (String) showConfig.get(i);
	if ("base".equals(cfg)) { 
%>
<table class="tb_normal" width=100%>
	<tr class="tr_normal_title tr_label_title">
		<td colspan="4">
		<bean:message bundle="km-review" key="kmReviewDocumentLableName.baseInfo" />
		</td>
	</tr>
	<!--主题-->
	<tr>
		<td class="td_normal_title" width=15%><bean:message
			bundle="km-review" key="kmReviewMain.docSubject" /></td>
		<td colspan=3><bean:write name="kmReviewMainForm"
			property="docSubject" /></td>
	</tr>
	<!--模板名称-->
	<tr>
		<td class="td_normal_title" width=15%><bean:message
			bundle="km-review" key="kmReviewTemplate.fdName" /></td>
		<td colspan=3><bean:write name="kmReviewMainForm"
			property="fdTemplateName" /></td>
	</tr>
	<!--申请人-->
	<tr>
		<td class="td_normal_title" width=15%><bean:message
			bundle="km-review" key="kmReviewMain.docCreatorName" /></td>
		<td width=35%><html:hidden name="kmReviewMainForm"
			property="docCreatorId" /> <bean:write name="kmReviewMainForm"
			property="docCreatorName" /></td>
		<td class="td_normal_title" width=15%><bean:message
			bundle="km-review" key="kmReviewMain.fdNumber" /></td>
		<td width=35%><bean:write name="kmReviewMainForm"
			property="fdNumber" /></td>
	</tr>
	<!--部门-->
	<tr>
		<td class="td_normal_title" width=15%><bean:message
			bundle="km-review" key="kmReviewMain.department" /></td>
		<td><bean:write name="kmReviewMainForm" property="fdDepartmentName"/></td>
		<td class="td_normal_title" width=15%><bean:message
			bundle="km-review" key="kmReviewMain.docCreateTime" /></td>
		<td width=35%><bean:write name="kmReviewMainForm"
			property="docCreateTime" /></td>
	</tr>
	<!--实施反馈人-->
	<tr>
		<td class="td_normal_title" width=15%><bean:message
			bundle="km-review" key="table.kmReviewFeedback" /></td>
		<td colspan=3><bean:write name="kmReviewMainForm"
			property="fdFeedbackNames" /></td>

	</tr>
	<%--流程标签可阅读者
	<tr>
		<td class="td_normal_title" width=15%><bean:message
			bundle="km-review" key="table.kmReviewMainLabelReader" /></td>
		<td colspan=3><bean:write name="kmReviewMainForm"
			property="fdLableReaderNames" /></td>
	</tr>
	--%>
	<%--可阅读者
	<tr>
		<td class="td_normal_title" width=15%><bean:message
			bundle="km-review" key="table.kmReviewMainReader" /></td>
		<td colspan=3><bean:write name="kmReviewMainForm"
			property="authReaderNames" /></td>
	</tr>
	--%>
	<!--关键字-->
	<tr>
		<td class="td_normal_title" width=15%><bean:message
			bundle="km-review" key="kmReviewKeyword.fdKeyword" /></td>
		<td colspan=3><bean:write name="kmReviewMainForm"
			property="fdKeywordNames" /></td>
	</tr>
	<!--适用岗位
	<tr>
		<td class="td_normal_title" width=15%><bean:message
			bundle="km-review" key="table.kmReviewPost" /></td>
		<td colspan=3><bean:write name="kmReviewMainForm"
			property="fdPostNames" /></td>
	</tr>
	-->
	<!--其他属性
	<tr>
		<td class="td_normal_title" width=15%><bean:message
			bundle="km-review" key="table.sysCategoryProperty" /></td>
		<td colspan=3><bean:write name="kmReviewMainForm"
			property="docPropertyNames" /></td>
	</tr>
	-->
</table>


<%-- 审批内容 --%>
<% } else if ("info".equals(cfg)) { %>
<table id="info_content" class="tb_normal" width=100% style="margin-top: 20px;">
	<tr class="tr_normal_title tr_label_title">
		<td colspan="4">
		<bean:message bundle="km-review" key="kmReviewDocumentLableName.reviewContent" />
		</td>
	</tr>
	<c:if test="${kmReviewMainForm.fdUseForm == 'false'}">
		<tr>
			<td colspan="4">
				${kmReviewMainForm.docContent}
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="km-review" key="kmReviewMain.attachment" />
			</td>
			<td colspan=3>
				<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp" charEncoding="UTF-8">
					<c:param name="fdMulti" value="true" />
					<c:param name="formBeanName" value="kmReviewMainForm" />
					<c:param name="fdKey" value="fdAttachment" />
				</c:import>
			</td>
		</tr>
	</c:if>
	<c:if test="${kmReviewMainForm.fdUseForm == 'true' || empty kmReviewMainForm.fdUseForm}">
		<tr>
			<td>
			<%-- 表单 --%>
			<c:import url="/sys/xform/include/sysForm_view.jsp"
				charEncoding="UTF-8">
				<c:param name="formName" value="kmReviewMainForm" />
				<c:param name="fdKey" value="reviewMainDoc" />
				<c:param name="messageKey" value="km-review:kmReviewDocumentLableName.reviewContent" />
				<c:param name="useTab" value="false" />
				<c:param name="isPrint" value="true" />
			</c:import>	</td>
		</tr>
 	</c:if>
	
	
</table>

<%-- 审批记录 --%>
<% } else if ("note".equals(cfg)) { %>
<table class="tb_normal" width=100% style="margin-top: 20px;">
	<!-- 审批记录 -->
	<tr class="tr_normal_title tr_label_title">
		<td colspan="4">
		<bean:message bundle="km-review" key="kmReviewMain.flow.trail" />
		</td>
	</tr>
	<tr>
		<td colspan=4>
			<c:import url="/sys/workflow/include/sysWfProcess_log.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmReviewMainForm" />
			</c:import>
		</td>
	</tr>
</table>

<%
} // end if
} // end for
%>
</div></div>
</center>
</template:replace>
		
</template:include>


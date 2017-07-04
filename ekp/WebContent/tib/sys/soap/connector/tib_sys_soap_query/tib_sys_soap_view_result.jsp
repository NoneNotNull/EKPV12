<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script type="text/javascript">
Com_IncludeFile("jquery.js|json2.js|dialog.js|formula.js|xml.js|doclist.js");
</script>
<script>

	function confirmDelete(msg) {
		var del = confirm("<bean:message key="page.comfirmDelete"/>");
		return del;
	}
	
</script>
<script src="${KMSS_Parameter_ContextPath}tib/common/resource/js/mustache.js" type="text/javascript"></script>
<script src="${KMSS_Parameter_ContextPath}tib/common/resource/js/erp.parser.js" type="text/javascript"></script>
<link href="${KMSS_Parameter_ContextPath}tib/common/resource/css/jquery.treeTable.css" rel="stylesheet" type="text/css" />
<script src="${KMSS_Parameter_ContextPath}tib/common/resource/js/jquery.treeTable.js" type="text/javascript"></script>
<script src="${KMSS_Parameter_ContextPath}tib/common/resource/js/custom_validations.js" type="text/javascript"></script>
<script src="${KMSS_Parameter_ContextPath}tib/sys/soap/connector/tib_sys_soap_query/view_script.js" type="text/javascript"></script>
<script type="text/javascript">
/************标记修正。。。************
 * 使用国际化的资源文件
 ************************/
$(function(){
	var spanNode = document.createElement("span");
	spanNode.id = "Include_Custom_Validations_Span_Id";
	document.body.appendChild(spanNode);
	$("#Include_Custom_Validations_Span_Id").load(Com_Parameter.ContextPath +
			"tib/common/resource/jsp/custom_validations.jsp");
});
</script>
<div id="optBarDiv">
		<input type="button"
		value="<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.query.saveAs"/>"
		onclick="Com_Submit(document.tibSysSoapQueryForm, 'save');">
	
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<html:form action="/tib/sys/soap/connector/tib_sys_soap_query/tibSysSoapQuery.do">

<input type="hidden" name="fdId" id="fdId" value="${tibSysSoapQueryForm.fdId}"/>
<input type="hidden" name="tibSysSoapMainId" value="${tibSysSoapQueryForm.tibSysSoapMainId }"/>
<input type="hidden" name="docSubject" id="docSubject" value="${tibSysSoapQueryForm.docSubject }"/>
<textarea name="docInputParam" id="docInputParam" style="display:none;">${tibSysSoapQueryForm.docInputParam }</textarea>
<textarea name="docOutputParam" id="docOutputParam" style="display:none;">${tibSysSoapQueryForm.docOutputParam }</textarea>
<textarea name="docFaultInfo" id="docFaultInfo" style="display:none;">${tibSysSoapQueryForm.docFaultInfo }</textarea>
<textarea name="resultXml" style="display:none;" id="resultXml">${resultXml }</textarea>

</html:form>

<center>
<p class="txttitle">${tibSysSoapQueryForm.docSubject }</p>

	<table class="tb_normal" id="Label_Tabel" width=95%>
		<tr LKS_LabelName="<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.query.inputParam"/>">
			<td>
				<table class="tb_normal" width="100%">
				<tr><td>
				<div id="erp_input_div"></div>
				</td></tr>
				</table>
			</td>
		</tr>
		<tr LKS_LabelName="<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.query.outputParam"/>">
			<td>
			<table class="tb_normal" width="100%">
				<tr><td>
				<div id="erp_output_div"></div>
				</td></tr>
				</table>
			</td>
		</tr>
		
		<tr LKS_LabelName="<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.func.faultParam"/>">
			<td>
			<table class="tb_normal" width="100%">
				<tr><td>
				<div id="erp_fault_div"></div>
				</td></tr>
				</table>
			</td>
		</tr>
	</table>
</center>

<script id="erp_query_template" type="text/mustache">
<table class="erp_template" style="width:100%" >
	<caption>{{info.caption}}</caption>
	<thead>
		<tr>
		{{#info.thead}}
			<th width='{{width}}' >{{th}}</th>
		{{/info.thead}}
		</tr>
	</thead>
	<tbody>
		{{#info.tbody}}
		<tr  id="{{nodeKey}}"  {{^root}} class="child-of-{{parentKey}}" {{/root}} >
			<td><span {{^hasNext}} class='file' {{/hasNext}} {{#hasNext}} class='folder' {{/hasNext}}  >{{nodeName}}</span></td>
			<td>{{dataType}}</td>
			<td>{{#comment.minOccurs}}  min:{{comment.minOccurs}} {{/comment.minOccurs}}  {{#comment.maxOccurs}} max:{{comment.maxOccurs}}{{/comment.maxOccurs}} </td>
			<td>
				<label> {{#comment.title}} {{comment.title}} {{/comment.title}}</label>
            <td>
		  {{^hasNext}}
 			<input type="text" style="width:100%" readOnly class="inputsgl"  erpNodeValue="true" nodeKey="{{nodeKey}}" {{#nodeValue}} value="{{nodeValue}}" {{/nodeValue}} > 
			{{/hasNext}}
			</td>			
			</tr>
	{{/info.tbody}}
	</tbody>
</table>
</script>

<script type="text/javascript">

</script>

<%@ include file="/resource/jsp/view_down.jsp"%>

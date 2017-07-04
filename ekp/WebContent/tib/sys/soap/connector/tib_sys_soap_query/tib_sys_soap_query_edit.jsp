<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@ include file="/sys/xform/include/sysForm_script.jsp"%>
<script type="text/javascript">
Com_IncludeFile("jquery.js|json2.js|dialog.js|formula.js|xml.js|doclist.js");
</script>
<script src="${KMSS_Parameter_ContextPath}tib/common/resource/js/mustache.js" type="text/javascript"></script>
<script src="${KMSS_Parameter_ContextPath}tib/common/resource/js/erp.parser.js" type="text/javascript"></script>
<link href="${KMSS_Parameter_ContextPath}tib/common/resource/css/jquery.treeTable.css" rel="stylesheet" type="text/css" />

<script src="${KMSS_Parameter_ContextPath}tib/common/resource/js/jquery.treeTable.js" type="text/javascript"></script>

<script src="${KMSS_Parameter_ContextPath}tib/sys/soap/connector/tib_sys_soap_query/query_script.js" type="text/javascript"></script>

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
		value="<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.query.queryResult"/>"
		onclick="Erp_execute_func(document.tibSysSoapQueryForm,'getXmlResult');">

	<%-- <input type="button"
		value="<bean:message key="button.save"/>"
		onclick="executeFuncXml('save');"> --%>

	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<center>
<p class="txttitle">${tibSysSoapMainName }</p>

<html:form action="/tib/sys/soap/connector/tib_sys_soap_query/tibSysSoapQuery.do">
  <table class="tb_normal" width=81%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.query.title"/>
		</td><td colspan="3" width="85%">
			<xform:text property="docSubject"  showStatus="edit" style="width:85%" />
			<%-- <xform:text showStatus="edit" property="docSubject" required="true"></xform:text> --%>
		</td>
   </tr>
   </table>
  <br>
<input type="hidden" name="tibSysSoapMainId" id="tibSysSoapMainId" value="${tibSysSoapMainId }"/>
<input type="hidden" name="wsBindFunc" id="wsBindFunc" value="${tibSysSoapMainForm.wsBindFunc }"/>
<input type="hidden" name="wsServerSettingId" id="wsServerSettingId" value="${tibSysSoapMainForm.wsServerSettingId }"/>
<textarea name="docInputParam" id="docInputParam" style="display:none;"></textarea>
<textarea name="docOutputParam" id="docOutputParam" style="display:none;">${docOutputParam }</textarea>
<textarea name="idXml" id="idXml" style="display:none;">${idXml }</textarea>
</html:form>
<table id="query_Table" class="tb_normal" width=81%>
	<tbody>
	  <tr>
	    <td>
	     <div id="erp_query_input">
	     </div>
	    </td>
	  </tr>
	</tbody>
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
 			<input type="text" style="width:95%" class="inputsgl"  erpNodeValue="true" nodeKey="{{nodeKey}}" {{#nodeValue}} value="{{nodeValue}}" {{/nodeValue}} > 
			{{/hasNext}}
			</td>			
			</tr>
	{{/info.tbody}}
	</tbody>
</table>
</script>


<script src="${KMSS_Parameter_ContextPath}tib/common/resource/js/custom_validations.js" type="text/javascript"></script>
<script type="text/javascript">
$KMSSValidation();
$(function(){
	// 验证标题
	FUN_AddValidates("docSubject:required");
});
</script>
<%@ include file="/resource/jsp/edit_down.jsp"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@ include file="/sys/xform/include/sysForm_script.jsp" %>
<script type="text/javascript">
Com_IncludeFile("doclist.js|jquery.js|json2.js|dialog.js|formula.js");
</script>
<script type="text/javascript" src="${KMSS_Parameter_ContextPath}tib/common/resource/js/sapEkp.js"></script>
<script type="text/javascript">
Com_IncludeFile("jquery.js");
</script>

<script src="${KMSS_Parameter_ContextPath}tib/common/resource/js/mustache.js" type="text/javascript"></script>
<script src="${KMSS_Parameter_ContextPath}tib/common/resource/js/erp.parser.js" type="text/javascript"></script>
<link href="${KMSS_Parameter_ContextPath}tib/common/resource/css/jquery.treeTable.css" rel="stylesheet" type="text/css" />

<script src="${KMSS_Parameter_ContextPath}tib/common/resource/js/jquery.treeTable.js" type="text/javascript"></script>
<script src="${KMSS_Parameter_ContextPath}tib/common/resource/js/custom_validations.js" type="text/javascript"></script>
<script src="${KMSS_Parameter_ContextPath}tib/soap/mapping/tib_soap_mapping_func/form_event_script.js" type="text/javascript"></script>
<script type="text/javascript">
/************标记修正。。。************
 * 使用国际化的资源文件
 * 必须要引入jQuery
 ************************/
$(function(){
	var spanNode = document.createElement("span");
	spanNode.id = "Include_Custom_Validations_Span_Id";
	document.body.appendChild(spanNode);
	$("#Include_Custom_Validations_Span_Id").load(Com_Parameter.ContextPath +
			"tib/common/resource/jsp/custom_validations.jsp");
});
</script>
<div id="optBarDiv1" style="width: 95%; text-align: right;">
<input type=button value="<bean:message bundle="tib-soap" key="tibSoapMapping.confirm"/>" class="btnopt"
			onclick="Erp_submit_func();">
	<input type=button value="<bean:message bundle="tib-soap" key="tibSoapMapping.seeForm"/>" class="btnopt"
			onclick="alert('<bean:message bundle="tib-soap" key="tibSoapMapping.seeForm"/>');" style="display: none">	
	<input type="button" value="<bean:message key="button.close"/>" class="btnopt" onclick="Com_CloseWindow();">
</div>
<center>
	<table class="tb_normal" width=95%>
		<tr
			<c:if test="${param.fdInvokeType!=0}">
style="display: none"
</c:if>>
			<td class="td_normal_title" width=15% id="fdInvokeType"><bean:message
					bundle="tib-common-mapping" key="tibCommonMappingMain.fdFormEvent" />
			</td>
			<td width="85%"><textarea name="" style="width: 100%"
					id="fdJspSegmen">
		</textarea></td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%><bean:message bundle="tib-soap" key="tibSoapMapping.useExplain"/></td>
			<td width="85%"><textarea name="" style="width: 100%"
					id="fdFuncMark">
	
		</textarea></td>
		</tr>
		<tr
			<c:if test="${param.fdInvokeType!=3&&param.fdInvokeType!=4&&param.fdInvokeType!=6}">
style="display: none"
</c:if>>
			<td class="td_normal_title" width=100% align="center" colspan="2">
				<label><bean:message bundle="tib-soap" key="tibSoapMapping.exceptionHandleConfig"/></label>
			</td>
		</tr>
		<tr
			<c:if test="${param.fdInvokeType!=3&&param.fdInvokeType!=4&&param.fdInvokeType!=6}">
style="display: none"
</c:if>>
			<td class="td_normal_title" width=100% colspan="2">
				<table id="extendForm_table" class="tb_normal" width="100%">
					<tr class="td_normal_title">
						<td><label><bean:message bundle="tib-soap" key="tibSoapMapping.exceptionType"/></label></td>
						<td><label><bean:message bundle="tib-soap" key="tibSoapMapping.exceptionControl"/></label></td>
						<td><label><bean:message bundle="tib-soap" key="tibSoapMapping.handleAssignment"/></label></td>
						<td><label toggleElem="true"><bean:message bundle="tib-soap" key="tibSoapMapping.formField"/></label></td>
						<td><label toggleElem="true"><bean:message bundle="tib-soap" key="tibSoapMapping.AssignmentFix"/></label></td>
					</tr>
					<tr KMSS_IsReferRow="1" style="display: none">
						<td><input type="text" class="inputsgl" readonly="readonly"
							name="fdExtendForms[!{index}].fdExceptionType"></td>
						<td><label><bean:message bundle="tib-soap" key="tibSoapMapping.isStop"/>:</label><input
							name="fdExtendForms[!{index}].fdIsIgnore" value="true"
							type="checkbox" /></td>
						<td><label><bean:message bundle="tib-soap" key="tibSoapMapping.isAssignment"/>:</label><input
							name="fdExtendForms[!{index}].fdIsAssign" controlElem="true"
							onclick="toggleImp()" value="true" type="checkbox" /></td>
						<td><label toggleElem="true"><bean:message bundle="tib-soap" key="tibSoapMapping.assignmentField"/>:</label> <nobr>
								<input class="inputsgl" readonly="readonly"
									name="fdExtendForms[!{index}].fdAssignField" type="text" /> <input
									name="fdExtendForms[!{index}].fdAssignFieldid" type="hidden" />
								<img src="${KMSS_Parameter_StylePath}icons/edit.gif" alt="<bean:message bundle="tib-soap" key="tibSoapMapping.edit"/>"
									name="!{index}" onclick="formula_field_dialog(this);"
									style="cursor: hand"></img>
							</nobr></td>
						<td><label toggleElem="true"><bean:message bundle="tib-soap" key="tibSoapMapping.fixValue"/>:</label> <nobr>
								<input class="inputsgl"
									name="fdExtendForms[!{index}].fdAssignVal" type="text" /> <input
									class="inputsgl" name="fdExtendForms[!{index}].fdId"
									type="hidden" /> <input class="inputsgl"
									name="fdExtendForms[!{index}].fdRefId" type="hidden" />
							</nobr></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</center>
<br/>
<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<bean:message bundle="tib-soap" key="tibSoapMapping.funcName"/>:
<input type="text" value=""  class="inputsgl"  id="fdSoapuiMainName"  name="fdSoapuiMainName"  readonly  style="width: 23%"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type="hidden"  class="inputsgl"  id="fdSoapuiMainId"  name="fdSoapuiMainId"/>
<input readonly="readonly" type=button value="<bean:message bundle="tib-soap" key="tibSoapMapping.chooseFunc"/>" class="btnopt"
onclick="doDialog_TreeList()">
<br/>
<br/>
<center>

<table class="tb_normal" width=95%>
  <tr>
     <td>
       <div id="tib_sys_soap_input"></div>
     </td>
  </tr>
  <tr>
  	<td>&nbsp;</td>
  </tr>
  <tr>
     <td>
       <div id="tib_sys_soap_output"></div>
     </td>
  </tr>
  <tr>
  	<td>&nbsp;</td>
  </tr>
  <tr>
     <td>
       <div id="tib_sys_soap_falut"></div>
     </td>
  </tr>
</table>
</center>
<!-- js input脚本模板 -->
<script id="erp_query_template" type="text/mustache">
<table class="erp_template" style="table-layout:fixed;width:100%" >
<col style="width: 45%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 5%" />
	<caption>{{info.caption}}</caption>
	<thead>
		<tr>
		{{#info.thead}}
			<td style='font-size:13px; text-align:center;' nowrap >{{{th}}}</td>
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
				{{#comment.title}} <input type="text" class="inputread" readOnly keyMatch="true" nodeKey="{{nodeKey}}"  value="{{comment.title}}"  /> {{/comment.title}}
            <td>
			{{^hasNext}}
 			 <input type="text" id="{{nodeKey}}_matchName" readOnly class="inputread" commentName="ekpname" name="{{nodeKey}}_input_name"   nodeKey="{{nodeKey}}" {{#comment.ekpname}} value="{{comment.ekpname}}" {{/comment.ekpname}} /> 
			{{/hasNext}}
				</td>
 			<td>
			
			{{^isHead}}
			{{^hasNext}}
            <input type="text" readOnly id="{{nodeKey}}_matchID" class="inputread" commentName="ekpid"  name="{{nodeKey}}_input_id"  nodeKey="{{nodeKey}}" {{#comment.ekpid}} value="{{comment.ekpid}}" {{/comment.ekpid}} /> 
				{{/hasNext}}
			{{/isHead}}	
			</td>
			<td nowrap>
			{{^isHead}}
			{{^hasNext}}
			<img src="${KMSS_Parameter_StylePath}icons/edit.gif" alt="<bean:message bundle="tib-soap" key="tibSoapMapping.edit"/>"  onclick="Erp_show_formula_dialog('{{nodeKey}}_input_name','{{nodeKey}}_input_id')"  style="cursor: hand" />
			<img src="${KMSS_Parameter_StylePath}icons/delete.gif" alt="<bean:message bundle="tib-soap" key="tibSoapMapping.empty"/>" onclick="Erp_empty_field('{{nodeKey}}_input_name','{{nodeKey}}_input_id')" style="cursor: hand" />
			{{/hasNext}}
			{{/isHead}}
			</td>
			</tr>
	{{/info.tbody}}
	</tbody>
</table>
</script>

<script id="erp_query_outtemplate" type="text/mustache">
<table class="erp_template" style="table-layout:fixed;width:100%" >
<col style="width: 45%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 5%" />
	<caption>{{info.caption}}</caption>
	<thead>
		<tr>
		{{#info.thead}}
			<td style='font-size:13px; text-align:center;' nowrap >{{{th}}}</td>
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
				 {{#comment.title}} <input type="text" class="inputread" readOnly keyMatch="true" nodeKey="{{nodeKey}}" value="{{comment.title}}"  />{{/comment.title}}
            <td>
			{{^hasNext}}
 			 <input type="text" id="{{nodeKey}}_matchName" readOnly class="inputread" commentName="ekpname" name="{{nodeKey}}_output_name"   nodeKey="{{nodeKey}}" {{#comment.ekpname}} value="{{comment.ekpname}}" {{/comment.ekpname}} /> 
			{{/hasNext}}
				</td>
 			<td>
			{{^hasNext}}
            <input type="text" id="{{nodeKey}}_matchID" readOnly class="inputread" commentName="ekpid"  name="{{nodeKey}}_output_id"  nodeKey="{{nodeKey}}" {{#comment.ekpid}} value="{{comment.ekpid}}" {{/comment.ekpid}} /> 
			{{/hasNext}}	
			</td>
			<td nowrap>
			{{^isHead}}
			{{^hasNext}}
			<img src="${KMSS_Parameter_StylePath}icons/edit.gif" alt="<bean:message bundle="tib-soap" key="tibSoapMapping.edit"/>"  onclick="Erp_show_formula_dialog('{{nodeKey}}_output_name','{{nodeKey}}_output_id')"  style="cursor: hand" />
			<img src="${KMSS_Parameter_StylePath}icons/delete.gif" alt="<bean:message bundle="tib-soap" key="tibSoapMapping.empty"/>" onclick="Erp_empty_field('{{nodeKey}}_output_name','{{nodeKey}}_output_id')" style="cursor: hand" />
			{{/hasNext}}
			{{/isHead}}	
			</td>
			</tr>
	{{/info.tbody}}
	</tbody>
</table>
</script>
<script id="erp_query_faulttemplate" type="text/mustache">
<table class="erp_template" style="table-layout:fixed;width:100%" >
<col style="width: 45%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 5%" />
	<caption>{{info.caption}}</caption>
	<thead>
		<tr>
		{{#info.thead}}
			<td style='font-size:13px; text-align:center;' nowrap >{{{th}}}</td>
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
				 {{#comment.title}} <input type="text" class="inputread" readOnly keyMatch="true" nodeKey="{{nodeKey}}" value="{{comment.title}}"  />{{/comment.title}}
            <td>
			{{^hasNext}}
 			 <input type="text" id="{{nodeKey}}_matchName" readOnly class="inputread" commentName="ekpname" name="{{nodeKey}}_fault_name"   nodeKey="{{nodeKey}}" {{#comment.ekpname}} value="{{comment.ekpname}}" {{/comment.ekpname}} /> 
			{{/hasNext}}
				</td>
 			<td>
			{{^hasNext}}
            <input type="text" id="{{nodeKey}}_matchID" readOnly class="inputread" commentName="ekpid"  name="{{nodeKey}}_fault_id"  nodeKey="{{nodeKey}}" {{#comment.ekpid}} value="{{comment.ekpid}}" {{/comment.ekpid}} /> 
			{{/hasNext}}	
			</td>
			<td nowrap>
			{{^isHead}}
			{{^hasNext}}
			<img src="${KMSS_Parameter_StylePath}icons/edit.gif" alt="<bean:message bundle="tib-soap" key="tibSoapMapping.edit"/>"  onclick="Erp_show_formula_dialog('{{nodeKey}}_fault_name','{{nodeKey}}_fault_id')"  style="cursor: hand" />
			<img src="${KMSS_Parameter_StylePath}icons/delete.gif" alt="<bean:message bundle="tib-soap" key="tibSoapMapping.empty"/>" onclick="Erp_empty_field('{{nodeKey}}_fault_name','{{nodeKey}}_fault_id')" style="cursor: hand" />
			{{/hasNext}}
			{{/isHead}}	
			</td>
			</tr>
	{{/info.tbody}}
	</tbody>
</table>
</script>





<script type="text/javascript">

function doDialog_TreeList(){
	var rfcId=document.getElementById("fdSoapuiMainId").value;
	Dialog_TreeList(false, 'fdSoapuiMainId', 'fdSoapuiMainName', 
			';', 'tibSoapMappingFuncTreeListService&selectId=!{value}&type=cate',
			'<bean:message bundle="tib-soap" key="tibSoapMapping.funcType"/>','tibSoapMappingFuncTreeListService&selectId=!{value}&type=func',
			function(){Erp_getTemplateXml(rfcId);},
			'tibSoapMappingFuncTreeListService&type=search&keyword=!{keyword}',
			null,null,null,'<bean:message bundle="tib-soap" key="tibSoapMapping.chooseFunc"/>');
}

//加载对应model数据字典和自定义表单字段到公式定义器树中
function XForm_getXFormDesignerObj(){
	//alert("${param.mainModelName}----${param.fdFormFileName}----${param.fdFormCustomizeName}==${fdFormCustomizeName}");
	var sysObj = TIB_XForm_GetSysDictObj("${param.mainModelName}");//传递model得到对应的数据字典
	var extObj = _XForm_GetExitFileDictObj("${param.fdFormFileName}");//传递最新模板的路径,为空则表明没有用到自定义表单
	// 传递定制明细表的路径,为空则表明没有用到定制明细表
	//var cusObj = _XForm_GetExitFileDictObj("${param.fdFormCustomizeName}");
	return sysObj.concat(extObj);//返回的同时给formVar赋值
}	

//显示公式定义器
function Erp_show_formula_dialog(nodekeyName,nodekeyId){
	var varInfo=XForm_getXFormDesignerObj();
	var fdInvokeType='${param.fdInvokeType}';//得到事件类型
	if (fdInvokeType == "3") {
		//alert(nodekeyId+"-"+nodekeyName);
		Formula_Dialog(nodekeyId, nodekeyName, varInfo,'Object',null,null);	
	} else {
		Dialog_Tree(false,nodekeyId,nodekeyName, null,
				'tibCommonMappingExportTreeService&id=!{value}&modelName=${param.mainModelName}&formFileName=${param.fdFormFileName}',
				'<bean:message bundle="tib-soap" key="tibSoapMapping.var"/>');//如果为传出参数或者传出表格参数则采用订制的选择框
	}
}
//清空单个字段
function Erp_empty_field(nodekeyName,nodekeyId){

	var names=document.getElementsByName(nodekeyName);
	var ids=document.getElementsByName(nodekeyId);
	if(ids&&ids[0]){
         $(ids[0]).val("");
		}
	if(names&&names[0]){
        $(names[0]).val("");
		}
}


/**************
* 提交函数时候更新xml
*/
function Erp_submit_func(){
	if(!Erp_temp_xml){
		return ;
	}
	var fdJspSegmen = document.getElementById("fdJspSegmen").value;
	fdJspSegmen = fdJspSegmen.replace("<script>", "&lt;script&gt;").replace("<\/script>", "&lt;/script&gt;");
	Erp_func_object.fdJspSegmen=fdJspSegmen;//$("#fdJspSegmen").val();
	Erp_func_object.fdFuncMark=$("#fdFuncMark").text();
	
	Erp_func_object.fdRefName=$("#fdSoapuiMainName").val();
	Erp_func_object.fdRefId=$("#fdSoapuiMainId").val();//可以不要，已实现了同步变更
	
	if(Erp_temp_xml!=null)
		Erp_func_object.fdRfcParamXml=Erp_temp_xml;//将xml对象转化为字符串
	var invokeType="${param.fdInvokeType}";

   if(invokeType=='3'||invokeType=='4'||invokeType=='6'){
	   Erp_func_object.fdExtendFormsView=JSON.stringify(DetailJsonHelper.getJsonFromDetail());
   }
	
	var tardom=ERP_parser.parseXml(Erp_temp_xml);
	var key_elem_in=$("#tib_sys_soap_input").find("input[nodeKey]"); 
	var key_elem_out=$("#tib_sys_soap_output").find("input[nodeKey]"); 
	var key_elem_fault=$("#tib_sys_soap_falut").find("input[nodeKey]"); 
	
	Erp_reset_comment(key_elem_in,tardom,"Input");
	Erp_reset_comment(key_elem_out,tardom,"Output");
	Erp_reset_comment(key_elem_fault,tardom,"Fault");
	
	Erp_temp_xml=tardom.xml;
	Erp_func_object.fdRfcParamXml=Erp_temp_xml;
	//alert(Erp_temp_xml);
	window.close();
}

function simple_formula(bindId,bindName){
	Dialog_Tree(false,bindId,bindName, null,'tibCommonMappingExportTreeService&id=!{value}&modelName=${param.mainModelName}&formFileName=${param.fdFormFileName}',
			'<bean:message bundle="tib-soap" key="tibSoapMapping.var"/>');//如果为传出参数或者传出表格参数则采用订制的选择框

	
}




</script>
<%--引入明细配置js --%>
<jsp:include page="../../../common/mapping/tib_common_mapping_func/ex_config.jsp"></jsp:include>
<script type="text/javascript" src="${KMSS_Parameter_ContextPath}tib/common/mapping/tib_common_mapping_func/ex_config.js"></script>
<script type="text/javascript">
     (function(){
         var invokeType="${param.fdInvokeType}";
         <%--只处理机器人节点 && 表单提交--%>
         if(invokeType=='3'||invokeType=='4'||invokeType=='6'){
        	 DetailJsonHelper.initJsonData(window.dialogArguments.fdExtendFormsView);
         }
         toggleImp();
         
         })();
     
</script>
<%@ include file="/resource/jsp/edit_down.jsp"%>

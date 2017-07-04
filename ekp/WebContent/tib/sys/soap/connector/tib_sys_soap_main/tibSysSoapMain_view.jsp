<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>

<script type="text/javascript">
Com_IncludeFile("json2.js");
Com_IncludeFile("dialog.js", null, "js");
</script>
<script>
Com_IncludeFile("jquery.js");

	function confirmDelete(msg) {
		var del = confirm("<bean:message key="page.comfirmDelete"/>");
		return del;
	}
	
	
	function query_edit() {
		var url = Com_Parameter.ContextPath + 
				"tib/sys/soap/connector/tib_sys_soap_main/tibSysSoapMain.do"+
				"?method=viewQueryEdit&funcId=${param.fdId}&isQuery=true";
		Com_OpenWindow(url);
	}
</script>



<script src="${KMSS_Parameter_ContextPath}tib/common/resource/js/mustache.js" type="text/javascript"></script>
<script src="${KMSS_Parameter_ContextPath}tib/common/resource/js/erp.parser.js" type="text/javascript"></script>
<link href="${KMSS_Parameter_ContextPath}tib/common/resource/css/jquery.treeTable.css" rel="stylesheet" type="text/css" />

<script src="${KMSS_Parameter_ContextPath}tib/common/resource/js/jquery.treeTable.js" type="text/javascript"></script>
<script src="${KMSS_Parameter_ContextPath}tib/sys/soap/connector/tib_sys_soap_main/tibSysSoapFunc.js" type="text/javascript"></script>
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



<html:form action="/tib/sys/soap/connector/tib_sys_soap_main/tibSysSoapMain.do">
<div id="optBarDiv">
	<input type="button"
		value="<bean:message key="button.queryData" bundle="tib-sys-soap-connector"/>"
		onclick="query_edit();">
	<kmss:auth requestURL="/tib/sys/soap/connector/tib_sys_soap_main/tibSysSoapMain.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('tibSysSoapMain.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/tib/sys/soap/connector/tib_sys_soap_main/tibSysSoapMain.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('tibSysSoapMain.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.func.config"/></p>

<center>
<table id="Label_Tabel" width=95%>
	<!-- 主文档 -->
	<tr LKS_LabelName="<bean:message bundle="tib-sys-soap-connector" key="table.tibSysSoapMain.main"/>">
		<td>
			<table class="tb_normal" width="100%">
				<!-- 函数名，所属分类 -->
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.func.docSubject"/>
					</td><td width="35%">
						<xform:text property="docSubject" style="width:85%" />
					</td>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.docCategory"/>
					</td><td width="35%">
						<c:out value="${tibSysSoapMainForm.docCategoryName}" />
					</td>
			<%-- 		<td class="td_normal_title" width=15%>
						<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain."/>
					</td><td width="35%">
						<xform:text property="docStatus" style="width:85%" />
					</td>
			 --%>	</tr>
				<!-- 是否启用，版本号 -->
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.wsEnable"/>
					</td><td colspan="3" width="85%">
						<xform:select property="wsEnable">
							<xform:enumsDataSource enumsType="ws_yesno" />
						</xform:select>
					</td>
				</tr>
				<!-- 所属服务 -->
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.wsServerSetting"/>
					</td><td colspan="3" width="35%">
						<c:out value="${tibSysSoapMainForm.wsServerSettingName}" />
					</td>
				</tr>
				<!-- 绑定函数，soap版本 -->
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.wsBindFunc"/>
					</td><td width="35%">
						<xform:text property="wsBindFunc" style="width:85%" />
					</td>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.wsSoapVersion"/>
					</td><td width="35%">
						<xform:text property="wsSoapVersion" style="width:85%" />
					</td>
					
				</tr>
				<!-- 映射模版 -->
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.wsMapperTemplate"/>
					</td><td colspan="3" width="85%">
						<xform:textarea style="display:none"  showStatus="edit" property="wsMapperTemplate" >
						</xform:textarea>
						<!-- 传入参数 -->
						<div id="wsMapperTemplateIn" style="width: 100%"></div>
						<p></p>
						<!-- 传出参数 -->
						<div id="wsMapperTemplateOut" style="width: 100%"></div>
						<p></p>
						<!-- 出错信息-->
						<div id="wsMapperTemplateFault" style="width: 100%"></div>
					
					</td>
				</tr>
				<!-- 函数说明 -->
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.wsBindFuncInfo"/>
					</td><td colspan="3" width="35%">
						<xform:text property="wsBindFuncInfo" style="width:85%" />
						
					</td>
				</tr>
				
				<!-- 备注，创建人 -->
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.wsMarks"/>
					</td><td colspan="3" width="85%">
						<xform:text property="wsMarks" style="width:85%" />
					</td>
				</tr>
				<!-- 创建时间，修改时间 -->
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.docCreator"/>
					</td><td width="35%">
						<c:out value="${tibSysSoapMainForm.docCreatorName}" />
					</td>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.docCreateTime"/>
					</td><td width="35%">
						<xform:datetime property="docCreateTime" />
					</td>
					
				</tr>
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.docAlterTime"/>
					</td><td colspan="3" width="85%">
						<xform:datetime property="docAlterTime" />
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<!-- 版本机制 -->
	<c:import
		url="/sys/edition/include/sysEditionMain_view.jsp"
		charEncoding="UTF-8">
		<c:param name="formName" value="tibSysSoapMainForm" />
	</c:import>
	<!-- 查询历史 -->
	<c:import
		url="/tib/sys/soap/connector/tib_sys_soap_query/tib_sys_soap_view_history.jsp"
		charEncoding="UTF-8">
		<c:param name="formName" value="tibSysSoapMainForm" />
	</c:import>
</table>
<html:hidden property="docStatus" /> 
<html:hidden property="method_GET" />
</center>
<script id="tree_template" type="text/mustache">
<table class="erp_template" style="width:90%" >
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
			<td>
				<input type="checkbox" disabled="true" name="nodeEnable" value="是否启用" commentNode="nodeEnable" nodeKey="{{nodeKey}}" {{comment.nodeEnable}} />
			</td>	
			<td>{{dataType}}</td>
			<td>{{#comment.minOccurs}}  min:{{comment.minOccurs}} {{/comment.minOccurs}}  {{#comment.maxOccurs}} max:{{comment.maxOccurs}}{{/comment.maxOccurs}} </td>
			<td>
			 {{^hasNext}} 
				<label nodeKey="{{nodeKey}}" erp-node="true" >{{#comment.title}} {{comment.title}} {{/comment.title}} </label></td>
			 {{/hasNext}} 
		</tr>
	{{/info.tbody}}
	</tbody>
</table>
</script>
<script id="tree_out_template" type="text/mustache">
<table class="erp_template" style="width:90%" >
	<caption>{{info.caption}}</caption>
	<thead width="100%">
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
			<td>
				{{^hasNext}}
					<select name="disp" nodeKey="{{nodeKey}}" defaultValue="{{comment.disp}}" disabled="true">
					</select>
				{{/hasNext}}
			</td>
			<td>{{dataType}}</td>
			<td>{{#comment.minOccurs}}  min:{{comment.minOccurs}} {{/comment.minOccurs}}  {{#comment.maxOccurs}} max:{{comment.maxOccurs}}{{/comment.maxOccurs}} </td>
			<td>
			 {{^hasNext}} 
				<input type="text"  class="inputread" readOnly commentNode="title"  {{#comment.title}}value="{{comment.title}}" {{/comment.title}}  nodeKey="{{nodeKey}}" erp-node="true" />
			 {{/hasNext}} 
			</td>
			<td>
			 {{^hasNext}} 
			{{#comment.isSuccess}}<label style="float:left"><bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.lang.success"/>:</label><input  type="text" commentNode="isSuccess" style="width:90px"  nodeKey="{{nodeKey}}" value="{{comment.isSuccess}}"  readOnly class="inputread" />{{/comment.isSuccess}}
			{{#comment.isFail}}<label style="float:left"><bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.lang.fail"/>:</label><input type="text"  commentNode="isFail" style="width:90px"  nodeKey="{{nodeKey}}" value="{{comment.isFail}}"  readOnly  class="inputread" />{{/comment.isFail}}
			 {{/hasNext}} 
			</td>
		</tr>
	{{/info.tbody}}
	</tbody>
</table>
</script>
<script id="tree_fault_template" type="text/mustache">
<table class="erp_template" style="width:90%" >
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
			 {{^hasNext}} 
				<label nodeKey="{{nodeKey}}" erp-node="true" >{{#comment.title}} {{comment.title}} {{/comment.title}} </label></td>
			 {{/hasNext}} 
		</tr>
	{{/info.tbody}}
	</tbody>
</table>
</script>

<script type="text/javascript">
//默认加载
$(document).ready(function(){
try{
	erp_loadDataInfo();
}catch(e){

}
		
});


/**********************
* 启动构造树形结构树
*/
function erp_loadDataInfo(){
	var init_str=$(document.getElementsByName("wsMapperTemplate")[0]).val();
	if(!init_str) {
	 return ;
	}
	var xmldom=createXml(init_str);
		reloadInfo(xmldom);
	}
</script>
<script src="${KMSS_Parameter_ContextPath}tib/common/resource/js/custom_validations.js" type="text/javascript"></script>
</html:form>
<%@ include file="/resource/jsp/view_down.jsp"%>

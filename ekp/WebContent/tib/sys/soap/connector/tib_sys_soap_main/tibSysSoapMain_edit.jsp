<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@ taglib uri="/tib/sys/soap/connector/resource/tld/erp-soapui.tld" prefix="soapui"%>
<script type="text/javascript">
Com_IncludeFile("jquery.js|json2.js");
Com_IncludeFile("dialog.js", null, "js");
</script>
<script src="${KMSS_Parameter_ContextPath}tib/common/resource/js/mustache.js" type="text/javascript"></script>
<script src="${KMSS_Parameter_ContextPath}tib/common/resource/js/erp.parser.js" type="text/javascript"></script>
<link href="${KMSS_Parameter_ContextPath}tib/common/resource/css/jquery.treeTable.css" rel="stylesheet" type="text/css" />

<script src="${KMSS_Parameter_ContextPath}tib/common/resource/js/jquery.treeTable.js" type="text/javascript"></script>
<script src="${KMSS_Parameter_ContextPath}tib/sys/soap/connector/tib_sys_soap_main/tibSysSoapFunc.js" type="text/javascript"></script>
<script src="${KMSS_Parameter_ContextPath}tib/common/resource/js/custom_validations.js" type="text/javascript"></script>

<script type="text/javascript">
/************标记修正。。。************
 * 使用国际化的资源文件
 ************************/
 var titleValue= '<bean:message bundle="tib-sys-soap-connector" key="table.tibSysSoapSettCategory"/>';
 
$(function(){
	var spanNode = document.createElement("span");
	spanNode.id = "Include_Custom_Validations_Span_Id";
	document.body.appendChild(spanNode);
	$("#Include_Custom_Validations_Span_Id").load(Com_Parameter.ContextPath +
			"tib/common/resource/jsp/custom_validations.jsp");
	// 编辑状态下选中Soap版本
	var soapVersionValue = "${tibSysSoapMainForm.wsSoapVersion}"; 
	var serviceId = _$("wsServerSettingId").value;
	var data = new KMSSData();
	data.SendToBean("tibSysSoapVersionBean&serviceId="+ serviceId, function(rtnData){
		after_dialogSoapuiSetting(rtnData, soapVersionValue);
	});
});

</script>

<html:form action="/tib/sys/soap/connector/tib_sys_soap_main/tibSysSoapMain.do">

<div id="optBarDiv">
	<c:if test="${tibSysSoapMainForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Erp_webSubmit(document.tibSysSoapMainForm, 'update');">
	</c:if>
	<c:if test="${tibSysSoapMainForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Erp_webSubmit(document.tibSysSoapMainForm,'save' )">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Erp_webSubmit(document.tibSysSoapMainForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.func.config"/></p>
<div id="mydiv"></div>

<center>

<table id="Label_Tabel" width=95%>
	<!-- 主文档 -->
	<tr LKS_LabelName="<bean:message bundle="tib-sys-soap-connector" key="table.tibSysSoapMain.main"/>">
		<td>
			<table class="tb_normal" width="100%">
				<!-- 函数名称，所属分类 -->
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.func.docSubject"/>
					</td><td width="35%">
						<xform:text  property="docSubject" style="width:85%" />
					</td>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.docCategory"/>
					</td><td width="35%">
						<xform:dialog style="width:85%;" required="true" propertyId="docCategoryId" propertyName="docCategoryName" dialogJs="categoryJs()">
						</xform:dialog>
					</td>
				</tr>
				<!-- 是否启用，版本 -->
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.wsEnable"/>
					</td><td colspan="3" width="85%">
						<xform:radio property="wsEnable">
						 <xform:enumsDataSource enumsType="ws_yesno" />
						</xform:radio>
					</td>
				</tr>
				<!-- 所属服务 -->
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.wsServerSetting"/>
					</td><td colspan="3" width="75%">
						<xform:dialog required="true" propertyId="wsServerSettingId" propertyName="wsServerSettingName"
						 	subject="${lfn:message('tib-sys-soap-connector:tibSysSoapMain.wsServerSetting') }" dialogJs="dialog_list_tibSysSoapSetting()" style="width:35%;float:left">
						</xform:dialog>
						 <input type="button" onclick="takeOutFunc();" class="btnopt"
							value="<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.takeOutFunc"/>"/>
						 <input type="button"  class="btnopt"
						 	onclick="if(!confirm('<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.if.cleanCache"/>'))return;cleanCache(wsServerSettingId.value)"
							value="<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.cleanCache"/>"/>
					</td>
				</tr>
				<!-- 绑定函数，soap版本 -->
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.wsBindFunc"/>
					</td><td width="35%">
						<input type="hidden" value="<c:out value='${tibSysSoapMainForm.wsBindFunc}' />" name="wsBindFuncHidden">
						<xform:select  property="wsBindFunc" style="float:left" onValueChange="bindFuncChange();">
						  <soapui:erpSoapFuncDataSource tibSysSoapSettingId="${tibSysSoapMainForm.wsServerSettingId}" tibSysSoapversion="${tibSysSoapMainForm.wsSoapVersion}"></soapui:erpSoapFuncDataSource>
						</xform:select>
						<!-- 抽取函数 -->
						<input type="button" style="float: left;" class="btnopt" onclick="loadFuncInfo()" 
							title="<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.func.getFunc"/>" 
							value="<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.func.getFunc"/>">
						<img style="display: none; float: left;" id="erp_loading_bar" alt="loading"  src="${KMSS_Parameter_ResPath}style/common/images/loading.gif"   />
					</td>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.wsSoapVersion"/>
					</td><td width="35%" id="soapVersionTd">
						<%-- <xform:radio property="wsSoapVersion" >
						<xform:enumsDataSource enumsType="soapui_soapversion"></xform:enumsDataSource>
						</xform:radio> --%>
					</td>
					
				</tr>
				
				<!-- 映射模版 -->
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.wsMapperTemplate"/>
					</td><td colspan="3" width="85%">
						<xform:textarea  style="display:none" showStatus="edit" property="wsMapperTemplate" >
						</xform:textarea>
						<!-- 传入参数 -->
						<div id="wsMapperTemplateIn" style="width: 100%"></div>
						<p></p>
						<!-- 传出参数 -->
						<div id="wsMapperTemplateOut" style="width: 100%"></div>
						<p></p>
						<!-- 错误信息 -->
						<div id="wsMapperTemplateFault" style="width: 100%"></div>
					</td>
				</tr>
				<!-- 函数说明 -->
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.wsBindFuncInfo"/>
					</td><td colspan="3" width="85%">
						<html:textarea
							property="wsBindFuncInfo" style="width:90%;"
							styleClass="inputmul" /> 
					</td>
				</tr>
				<!-- 备注 -->
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.fdMarks"/>
					</td><td colspan="3" width="85%">
						<xform:textarea property="wsMarks" style="width:90%" />
					</td>
				</tr>
				<!-- 创建者,创建时间 -->
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.docCreator"/>
					</td><td width="35%">
						<xform:address propertyId="docCreatorId" propertyName="docCreatorName" orgType="ORG_TYPE_PERSON" showStatus="view" />
					</td>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.docCreateTime"/>
					</td><td width="35%">
						<xform:datetime property="docCreateTime" showStatus="view" />
					 
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<%-- 版本机制 --%>
	<c:import url="/sys/edition/include/sysEditionMain_edit.jsp"
					charEncoding="UTF-8">
		<c:param name="formName" value="tibSysSoapMainForm" />
	</c:import>
	 
	
</table>

</center>
<html:hidden property="fdId" />
<html:hidden property="docStatus" />
<html:hidden property="method_GET" />
<script type="text/javascript">
	$KMSSValidation();
	
	function categoryJs(){
		Dialog_Tree(false, 'docCategoryId', 'docCategoryName', ',', 
			'tibSysSoapCategoryTreeService&parentId=!{value}', 
			'<bean:message key="table.tibSysSoapSettingFunction" bundle="tib-sys-soap-connector"/>', 
			null, null, '${tibSysSoapCategoryForm.fdId}', null, null, 
			'<bean:message  bundle="tib-sys-soap-connector" key="table.tibSysSoapCategory"/>');
	}

	//默认加载
	$(document).ready(function(){
		// 增加验证
		FUN_AddValidates("docSubject:required","wsBindFunc:required");
		// 版本
		var soapV = "${tibSysSoapMainForm.wsSoapVersion}";
		//backLoadVersion("", soapV);
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
		var xmldom = null;
		if(init_str) {
			xmldom=createXml(init_str);
		}
		reloadInfo(xmldom);
	}
//加载所有方法
	function erp_loadWsFunc(){
 			var settingId=$(document.getElementsByName("wsServerSettingId")[0]).val();
 			var soapversion=$(document.getElementsByName("wsSoapVersion")[0]).val();
			var func=$(document.getElementsByName("wsBindFunc")[0]).val();
			if(!(settingId&&soapversion&&func))
			{
				//alert(settingId+soapversion+func);
				return ;
			}
			var data = new KMSSData();
			var bean_str="tibSysSoapSelectOptionsBean&serviceId=!{serviceId}&soapversion=!{soapversion}"
			bean_str=bean_str.replace("!{serviceId}",serviceId).replace("!{soapversion}",soapVerson);
			
			data.SendToBean(bean_str, 
					function(rtnVal){
						var options=[];
						if(!rtnVal){
							return ;
						}
						options = rtnVal.GetHashMapArray();
						refreshOption(document.getElementsByName("wsBindFunc")[0],options,true,func);
		});
	}
	
	// 绑定函数变更后执行的操作
	function bindFuncChange(){
		FUN_RemoveValidMsg("wsBindFunc");
		$("#wsMapperTemplateIn").empty();
		$("#wsMapperTemplateOut").empty();
		$("#wsMapperTemplateFault").empty();
	}
	
	
</script>

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
				<input onclick="partCheckedClick(this, '{{nodeKey}}');" type="checkbox" name="nodeEnable" value="是否启用" commentNode="nodeEnable" nodeKey="{{nodeKey}}" {{comment.nodeEnable}} />
			</td>
			<td><input type="text" readonly nodeKey="{{nodeKey}}" commentNode="ctype" class="inputread" value="{{dataType}}"/></td>
			<td>{{#comment.minOccurs}}  min:{{comment.minOccurs}} {{/comment.minOccurs}}  {{#comment.maxOccurs}} max:{{comment.maxOccurs}}{{/comment.maxOccurs}} </td>
			<td>
			{{^hasNext}} 
				<input type="text" class="inputsgl" commentNode="title"   {{#comment.title}}value="{{comment.title}}" {{/comment.title}}  nodeKey="{{nodeKey}}" erp-node="true" />
			{{/hasNext}}
			</td>
		</tr>
	{{/info.tbody}}
	</tbody>
</table>
</script>
<script id="tree_out_template" type="text/mustache">
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
				{{^hasNext}}
					<select name="disp" nodeKey="{{nodeKey}}" commentNode="disp" defaultValue="{{comment.disp}}">
					</select>
				{{/hasNext}}
			</td>
			<td><input type="text" readonly nodeKey="{{nodeKey}}" commentNode="ctype" class="inputread" value="{{dataType}}"/></td>
			<td>{{#comment.minOccurs}}  min:{{comment.minOccurs}} {{/comment.minOccurs}}  {{#comment.maxOccurs}} max:{{comment.maxOccurs}}{{/comment.maxOccurs}} </td>
			<td>
			{{^hasNext}} 
				<input type="text" class="inputsgl" commentNode="title"  {{#comment.title}}value="{{comment.title}}" {{/comment.title}}  nodeKey="{{nodeKey}}" erp-node="true" />
			{{/hasNext}} 
			</td>
			<td>
			{{^hasNext}} 
 			<span class="edit_searchRange" onclick="erp_toggle(this,'{{nodeKey}}')">
				<a id="{{nodeKey}}_link" href="javascript:void(0)"><bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.lang.edit"/></a> 
			</span>
			<div id="{{nodeKey}}_flag" style="float:left;padding:3px;display:none;border:3px #AAD0EE solid">
			<label style="float:left"><bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.lang.success"/>:</label><input type="text" commentNode="isSuccess" style="float:left;width:90px"  nodeKey="{{nodeKey}}" {{#comment.isSuccess}}value="{{comment.isSuccess}}" {{/comment.isSuccess}} class="inputsgl" />
			<label><bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.lang.fail"/>:</label><input type="text"  commentNode="isFail" style="float:left;width:90px"  nodeKey="{{nodeKey}}" {{#comment.isFail}}value="{{comment.isFail}}" {{/comment.isFail}}  class="inputsgl" />
			<div style="clear:both"></div>
			</div>
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
				<input type="text" class="inputsgl" commentNode="title"   {{#comment.title}}value="{{comment.title}}" {{/comment.title}}  nodeKey="{{nodeKey}}" erp-node="true" />
			{{/hasNext}}
			</td>
		</tr>
	{{/info.tbody}}
	</tbody>
</table>
</script>

</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>

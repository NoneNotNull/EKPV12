<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/tib/sys/soap/connector/resource/tld/erp-soapui.tld" prefix="soap"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@page import="com.landray.kmss.tib.sys.soap.connector.util.header.licence.LicenceHeaderPlugin"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<script language="JavaScript">
	Com_IncludeFile("jquery.js|dialog.js|calendar.js|doclist.js|optbar.js|data.js");
</script>

<script src="${KMSS_Parameter_ContextPath}tib/common/resource/js/erp.parser.js"></script>
<script src="${KMSS_Parameter_ContextPath}tib/common/resource/js/custom_validations.js" type="text/javascript"></script>
<script type="text/javascript">
/************标记修正。。。************
 * 使用国际化的资源文件
 ************************/
$(function(){
	FUN_AddValidates("docSubject:required", "fdWsdlUrl:required");
	var spanNode = document.createElement("span");
	spanNode.id = "Include_Custom_Validations_Span_Id";
	document.body.appendChild(spanNode);
	$("#Include_Custom_Validations_Span_Id").load(Com_Parameter.ContextPath +
			"tib/common/resource/jsp/custom_validations.jsp");
});

function categoryJs(){
	Dialog_Tree(false, 'settCategoryId', 'settCategoryName', ',', 
		'tibSysSoapSettCategoryTreeService&parentId=!{value}', 
		'<bean:message key="table.tibSysSoapSettingRegister" bundle="tib-sys-soap-connector"/>', 
		null, null, '${tibSysSoapSettCategoryForm.fdId}', null, null, 
		'<bean:message  bundle="tib-sys-soap-connector" key="table.tibSysSoapCategory"/>');
}

</script>
<%-- 加载扩展点引入地址--%>
<%
		 	List<Map<String, String>> configsList= LicenceHeaderPlugin.getConfigs(); 
//			记录权限扩展的地址
			List<String> paths=new ArrayList<String>(1);
//			记录扩展的key 
			List<String> keys=new ArrayList<String>(1);
			for(int i=0,len=configsList.size();i<len;i++){
				Map<String,String> curConfig=configsList.get(i);
				String path =curConfig.get(LicenceHeaderPlugin.extendJspPath);
				if(StringUtil.isNotNull(path)){
					paths.add(path);
				}
				String key=curConfig.get(LicenceHeaderPlugin.handlerKey);
				keys.add(key);
				
			};
			//weblogic 10.x StringUtils 不能用,换个实现方式
			pageContext.setAttribute("erp_import_path",paths);
			String keyInfo="";
			for(int i=0,len=keys.size();i<len;i++){
				keyInfo+=keys.get(i);
				if(i!=0&&i!=len-1){
					keyInfo+=";";
				}
			}
			pageContext.setAttribute("erp_import_keys",keyInfo);
			
		%>


<html:form action="/tib/sys/soap/connector/tib_sys_soap_setting/tibSysSoapSetting.do">
<div id="optBarDiv">
	<c:if test="${tibSysSoapSettingForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="waitSubmit('update');">
	</c:if>
	<c:if test="${tibSysSoapSettingForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="waitSubmit('save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="waitSubmit('saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="tib-sys-soap-connector" key="tree.tibSysSoapSetting.register"/></p>

<center>
<table class="tb_normal" width=95%>
	<!-- 服务名称 -->
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.docSubject"/>
		</td><td  width="35%">
			<xform:text property="docSubject" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.settCategory"/>
		</td><td width="35%">
			<xform:dialog style="width:85%;" required="true" propertyId="settCategoryId" propertyName="settCategoryName" dialogJs="categoryJs()">
			</xform:dialog>
		</td>
	</tr>
	<!-- 是否为保护型wsdl --><!-- Wsdl版本  -->
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.fdProtectWsdl"/>
		</td><td colspan="6" width="85%">
			<xform:radio property="fdProtectWsdl" onValueChange="protectWsdlChange();">
				<xform:enumsDataSource  enumsType="ws_serviceSetting_yesno" />
			</xform:radio>
		</td>
	</tr>
	<!-- 加载wsdl 时候获取受保护类型的wsdl 密码 -->
	<tr id="fdloadUserPass" <c:if test="${tibSysSoapSettingForm.fdProtectWsdl eq 'false'}">style="display: none"</c:if> >
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.fdloadUser"/>
		</td><td width="35%">
			<!--<xform:text property="fdloadUser"  style="width:85%" />-->
			<input name="fdloadUser"  id="fdloadUser" style="width:85%" value="${tibSysSoapSettingForm.fdloadUser}" autocomplete=off class="inputsgl"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.fdloadPwd"/>
		</td><td width="35%">
			<!--<html:password property="fdloadPwd" style="width:85%" styleClass="inputsgl"/>-->
			<input name="fdloadPwd"  id="fdloadPwd" style="width:85%" class="inputsgl" value="${tibSysSoapSettingForm.fdloadPwd}" autocomplete=off/>
		</td>
	</tr>
	<!-- WsdlUrl地址 -->
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.fdWsdlUrl"/>
		</td><td colspan="6" width="85%">
			<xform:text property="fdWsdlUrl" style="width:85%;float:left;" />
			<!-- 加载 -->
			<a href="javascript:void(0)" onclick="loadWsdlInfo();"><bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.load"/></a>
			<img id="wsdl_loading" src="${KMSS_Parameter_ResPath}style/common/images/loading.gif" style="display: none"/>
		</td>
	</tr>

	<%-- 
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.address"/>
			<!-- address地址 -->
			<input type="hidden" name="docAddress" id="docAddress" value=""/>
			<!-- 版本 -->
			<html:hidden property="fdSoapVerson"/>
		</td><td colspan="3" width="75%" id="docAddressTdObj">
		</td>
	</tr>
	--%>
	<!-- 可使用的SOAP版本 -->
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.soapVersion"/>
		</td><td width="35%" id="soapVersionTd" colspan="6">
			<xform:checkbox property="fdSoapVerson" showStatus="readOnly">
				<soap:erpSplitStringDateSource sourceString="${tibSysSoapSettingForm.fdSoapVerson}" regx=";"></soap:erpSplitStringDateSource>
			</xform:checkbox>
		</td>
		<%--  
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.fdWsdlVersion"/>
		</td><td  width="35%">
			<input type="hidden" name="fdWsdlVersion" value="WSDL1.1"/>
			WSDL1.1
		</td>
		--%>
	</tr>
	<!-- 是否启用，是否分块发送 -->
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.fdEnable"/>
		</td><td colspan="6" width="85%">
			<xform:radio property="fdEnable">
				<xform:enumsDataSource enumsType="ws_yesno" />
			</xform:radio>
		</td>
		<%-- <td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.fdAllowBlock"/>
		</td><td colspan="3"  width="35%">
			<xform:radio property="fdAllowBlock">
				<xform:enumsDataSource enumsType="ws_yesno" />
			</xform:radio>
		</td> --%>
	</tr>
	<!-- 响应超时，连接超时 -->
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.fdResponseTime"/>
		</td><td width="35%">
			<xform:text property="fdResponseTime" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.fdOverTime"/>
		</td><td width="35%">
			<xform:text property="fdOverTime" style="width:85%" />
		</td>
	</tr>
	<!-- 是否验证 -->
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.fdCheck"/>
		</td><td colspan="6" width="85%">
			<xform:radio property="fdCheck" onValueChange="fdCheckOnClick();">
				<xform:enumsDataSource enumsType="erp_soapuiSetting_yesno" />
			</xform:radio>
		</td>
	</tr>
	<!-- 登录验证方式  -->
	<tr id="wsAuthLogin" <c:if test="${tibSysSoapSettingForm.fdCheck eq 'false'}">style="display: none"</c:if>>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.fdAuthMethod"/>
		</td>
		<td colspan="6">
			<span style="float:left;">
	   		<xform:radio showStatus="edit" property="fdAuthMethod" onValueChange="fdAuthMethodChange();">
				<!-- 加载SOAP消息验证扩展点数据 -->
			 	<soap:soapLicenceDataSource></soap:soapLicenceDataSource>
			</xform:radio>
			</span>
			
		</td>
	</tr>
	<c:forEach items="${erp_import_path}" var="cur_path" varStatus="vstatus">
			<c:import url="${cur_path}"></c:import>
		</c:forEach>
	<!-- 扩展配置名称，扩展配置内容 -->
	<%-- <tr>
		<td class="td_normal_title" width=15%><bean:message
			bundle="tib-sys-soap-connector" key="tibSysSoapSetting.fdServerExt" /></td>
		<td width=35% colspan="3">
			<table class="tb_normal" width=100% id="TABLE_DocList">
				<tr>
					<td class="td_normal_title" width="47%"><bean:message
						bundle="tib-sys-soap-connector" key="tibSysSoapSettingExt.fdWsExtName" /></td>
					<td class="td_normal_title" width="47%"><bean:message
						bundle="tib-sys-soap-connector" key="tibSysSoapSettingExt.fdWsExtValue" /></td>
					<td class="td_normal_title" width="6%"><center><img
						style="cursor: pointer" class=optStyle
						src="<c:url value="/resource/style/default/icons/add.gif"/>"
						onclick="DocList_AddRow();"></center></td>
				</tr>
				<tr KMSS_IsReferRow="1" style="display: none">
					<td><input type="text" name="fdServerExtForms[!{index}].fdWsExtName" class="inputsgl"
						value="${tibSysSoapSettingExtForm.fdWsExtName}" style="width:85%"></td>
					<td><input type="text"
						name="fdServerExtForms[!{index}].fdWsExtValue" class="inputsgl"
						value="${tibSysSoapSettingExtForm.fdWsExtValue}" style="width:85%"></td>
					<td><input type="hidden" name="fdServerExtForms[!{index}].fdId" 
						value="${tibSysSoapSettingExtForm.fdId}">
						<input type="hidden" name="fdServerExtForms[!{index}].fdServerId"
						value="${tibSysSoapSettingForm.fdId}">
					<center><img
						src="${KMSS_Parameter_StylePath}icons/delete.gif"
						onclick="DocList_DeleteRow();" style="cursor: pointer"></center>
					</td>
				</tr>
				<c:forEach items="${tibSysSoapSettingForm.fdServerExtForms}"
					var="tibSysSoapSettingExtForm" varStatus="vstatus">
					<tr KMSS_IsContentRow="1">
						<td><input type="text" class="inputsgl"
							name="fdServerExtForms[${vstatus.index}].fdWsExtName"
							value="${tibSysSoapSettingExtForm.fdWsExtName}" style="width:85%"></td>
						<td><input type="text" class="inputsgl"
							name="fdServerExtForms[${vstatus.index}].fdWsExtValue"
							value="${tibSysSoapSettingExtForm.fdWsExtValue}" style="width:85%"></td>
						<td><input type="hidden" name="fdServerExtForms[${vstatus.index}].fdId"
							value="${tibSysSoapSettingExtForm.fdId}">
							<input type="hidden" name="fdServerExtForms[${vstatus.index}].fdServerId"
							       value="${tibSysSoapSettingExtForm.fdServerId}">
							<center><img
								src="${KMSS_Parameter_StylePath}icons/delete.gif"
								onclick="DocList_DeleteRow();" style="cursor: pointer"></center>
						</td>
					</tr>
				</c:forEach>
			</table>
		</td>
	</tr> --%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.fdMarks"/>
		</td><td colspan="6" width="35%">
			<xform:textarea property="fdMarks" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.docCreator"/>
		</td><td width="35%">
			<xform:address propertyId="docCreatorId" propertyName="docCreatorName" orgType="ORG_TYPE_PERSON" showStatus="view" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.docCreateTime"/>
		</td><td width="35%">
			<xform:datetime property="docCreateTime"  showStatus="view" />
			
			<xform:textarea style="display:none" property="extendInfoXml"></xform:textarea>
</td>
</tr>
</table>



</center>

<html:hidden property="serviceName" />
<html:hidden property="bindName" />
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	$KMSSValidation();	
	// 提示的方法
	function waitSubmit(method) {
		Com_Submit(document.tibSysSoapSettingForm, method);
	}

	
	//隐藏所有相关的扩展点的tr
	function hidePluginTr(keys){
		//先清空原来其它的值
		
		_$("fdUserName").value = "";
		_$("fdPassword").value = "";
		_$("passwordType").value = "";
		_$("soapHeaderCustom").value = "";


		_$("k3UserName").value="";
        _$("k3Password").value="";
        _$("k3IAisID").value="";
		
		//隐藏所以其他关联的tr
		for(var i=0,len=keys.length;i<len;i++){
			
			if("userToken"==keys[i]){//wss-token
				$("#passwordTypeTr").hide();
				$("#passwordTypeTr").hide("fast");
				$("#wsUserPassword").hide();
				}
			else if("soapHeaderCustom"==keys[i]){//soapHeader
				_$("soapHeaderCustom").value = "";
				$("#soapHeaderCustomTr").hide("fast");
				$("#loadSoapBtn").hide("fast");
				$("#wsUserPassword").hide();
				}
			else if("soapHeaderType"==keys[i]||"ekpType"==keys[i]){//soapHeader 或者 ekpType
				$("#wsUserPassword").hide();
			
			}else if("k3Type"==keys[i]){
                //$("#erp_key_k3Login").hide();
                $("tr[id^='k3Login_']").hide();
		      }
			//上面判断为了兼容代码,尽量不修改以前逻辑情况下
			else{
				$("#wsUserPassword").hide();
				var keyTr=keys[i];
				if(keyTr){
				var trID="erp_key_"+keyTr;
				$("#"+trID).hide();
					}
				}
			}
		}

	function showTargetPlugin(keys){
		var fdCheckCheck = $("input[name=fdCheck][value=true]:checked").val();
		//===========上面隐藏==========
		if(fdCheckCheck){
			var authInfo = $("input[name=fdAuthMethod]:checked");
			var authVal=authInfo.val();
			// 为了兼容以前的代码而写,不推荐
			if("userToken"==authVal){
				$("#wsUserPassword").show();
					$("#passwordTypeTr").show();
			} else if("soapHeaderCustom"==authVal){
					// 清空及隐藏无关信息
					_$("fdUserName").value = "";
					_$("fdPassword").value = "";
					_$("passwordType").value = "";
					$("#wsUserPassword").hide();
					//$("#soapHeaderCustomTr").show("fast");
					$("#soapHeaderCustomTr").show();
					$("#loadSoapBtn").show();
					// loadSoapHeaderTemplate();
			} else if("soapHeaderType"==authVal||"ekpType"==authVal){
				_$("soapHeaderCustom").value = "";
				$("#wsUserPassword").show();
				$("#soapHeaderCustomTr").hide();
				$("#loadSoapBtn").hide();
			}else if("k3Type"==authVal){
				  $("tr[id^='k3Login_']").show();
				  _$("k3UserName").value="";
	              _$("k3Password").value="";
	              _$("k3IAisID").value="";
				}
			//上面的是兼容意见表单
			else {
				$("#wsUserPassword").hide();
				_$("fdUserName").value = "";
				_$("fdPassword").value = "";
				_$("passwordType").value = "";

				_$("k3UserName").value="";
                _$("k3Password").value="";
                _$("k3IAisID").value="";
                
				var keyTr=authVal;
				if(keyTr){
					var trID="erp_key_"+keyTr;
					$("#"+trID).show();
				}
			}	
		}
	}
	
	
	// 判断登录方式，操作密码类型
	function fdAuthMethodChange() {
		var keysInfo="${erp_import_keys}";
		var keys= keysInfo.split(";");
		hidePluginTr(keys);
		showTargetPlugin(keys);
	}
	
	// 获取Soap头信息模版
	function loadSoapHeaderTemplate() {
		var fdCheckObj = document.getElementsByName("fdProtectWsdl")[0];
		var fdLoadUser = "";
		var fdLoadPwd = "";
		if(fdCheckObj.checked){
			//如果选中 是否HTTP保护   获得输入的值 (这段代码 主要是用来防止 在firefox情况下，当登陆时使用了记住密码，时firefox  会出现将记住的用户名和密码填充进去)
			fdLoadUser =  _$("fdloadUser").value;
			fdLoadPwd = _$("fdloadPwd").value;
		}
		var wsdlUrl = _$("fdWsdlUrl").value;
		var fdSoapVerson = _$("fdSoapVerson").value;
		// 添加加载旋转图片
		FUN_AppendLoadImg("fdAuthMethod");
		var data = new KMSSData();
		var url = "tibSysSoapLoadHeaderTemplateBean&fdLoadUser="+ fdLoadUser +"&fdLoadPwd="+ 
			fdLoadPwd +"&wsdlUrl="+ wsdlUrl +"&fdSoapVerson="+ fdSoapVerson;
		data.SendToBean(url, after_loadSoapHeaderTemplate);
	}
	
	// 获取Soap头信息模版后的回调
	function after_loadSoapHeaderTemplate(rtnData) {
		var data = rtnData.GetHashMapArray()[0];
		if (data["error"] != undefined) {
			var msg = "<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.loadSoapHeadFail"/>";
			alert(msg);
		} else {
			var headTemplate = "";
			if (data["SOAP1.1"] != undefined) {
				headTemplate += data["SOAP1.1"];
			}
			if (data["SOAP1.2"] != undefined) {
				headTemplate += data["SOAP1.2"];
			}
			_$("soapHeaderCustom").value = headTemplate;
		}
		// 移除加载旋转图片
		FUN_RemoveLoadImg("fdAuthMethod");
	}
	
	// 是否验证onclick事件
	function fdCheckOnClick() {
		// 操作用户名、密码、密码类型、头消息自定义等字段
		fdCheckOperation();
		// 操作密码类型
		fdAuthMethodChange();
	};
	
	// 供是否验证onclick事件调用
	function fdCheckOperation() {
		var fdCheckObj = document.getElementsByName("fdCheck")[0];
		if (fdCheckObj.checked) {
			_$("wsUserPassword").style.display = "";//"block"; 是否验证    yes
			//设置auth
			_$("wsAuthLogin").style.display = "";//"block";
		} else {
			_$("fdUserName").value = "";
			_$("fdPassword").value = "";
			_$("passwordType").value = "";
			_$("soapHeaderCustom").value = "";
			_$("wsUserPassword").style.display = "none";
			_$("soapHeaderCustomTr").style.display = "none";
			//设置auth
			_$("wsAuthLogin").style.display = "none";
		}
	}
	
	// 加载wsdl用户名和密码
	function protectWsdlChange() {
		var fdCheckObj = document.getElementsByName("fdProtectWsdl")[0];
		if (fdCheckObj.checked) {
			_$("fdloadUserPass").style.display = "";//"block"; 显示
		} else {
			_$("fdloadUser").value = "";
			_$("fdloadPwd").value = "";
			_$("fdloadUserPass").style.display = "none";// 隐藏
		}
	};

	//加载soap版本信息 modify zhangtian
	function loadWsdlInfo(){
		var wsdl=$("input[name=fdWsdlUrl]").val();
		var is_protect=$("input[name=fdProtectWsdl]:checked").val();
		var fdloadUser=$("input[name=fdloadUser]").val();
		var fdloadPwd=$("input[name=fdloadPwd]").val();
		var bean_str="tibSysSoapWsdlImpl&user=!{username}&pwd=!{pwd}&fdWsdlUrl=!{fdWsdlUrl}";
		if (!wsdl) {
			return ;
		}
		if (is_protect=="true") {
			bean_str=bean_str.replace("!{username}",fdloadUser).replace("!{pwd}",fdloadPwd);
		} else {
			bean_str=bean_str.replace("!{username}","").replace("!{pwd}","");
		}
		bean_str=bean_str.replace("!{fdWsdlUrl}",wsdl);
		$("#wsdl_loading").show();
		var data = new KMSSData();
		data.SendToBean(bean_str, after_load);
	}
	
	function after_load(rtn){
		$("#wsdl_loading").hide();
		$("#soapVersionTd").empty();
		if(!rtn || rtn.GetHashMapArray().length==0){
			var msg = "<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.loadFail"/>";
			FUN_AppendValidMsg("fdWsdlUrl!"+ msg);
			return ;
		} else {
			FUN_RemoveValidMsg("fdWsdlUrl");
		}
		var str="<NOBR><LABEL><INPUT style=\"IME-MODE: disabled\" disabled name=_fdSoapVerson value=\"!{soap_v}\" CHECKED type=checkbox subject=\"SOAP版本\">!{soap_t}</LABEL></NOBR>";
		var h_box="<INPUT name=fdSoapVerson value=\"!{sv}\" type=hidden>";

		var vs_txt="";
		for(var i=0,len=rtn.GetHashMapArray().length;i<len;i++){
			var vs=rtn.GetHashMapArray()[i]["version"];
			if(i>0){
				vs_txt=vs_txt+";";
			}
			vs_txt=vs_txt+vs;
			var apptxt=str.replace("!{soap_v}",vs).replace("!{soap_t}",vs);
			$("#soapVersionTd").append($(apptxt));
		}
		$("#soapVersionTd").append($(h_box.replace("!{sv}",vs_txt)));
	}
	
	// 删除所有子节点
	function removeAllChild(elementObj) {
		while (elementObj.hasChildNodes()) {
			elementObj.removeChild(elementObj.firstChild);
		}
	}

	//检查radio 选中的值
	function findRadioCheckValue(elemName) {
		var fdProtectWsdls = document.getElementsByName(elemName);
		if (fdProtectWsdls && fdProtectWsdls.length > 0) {
			for ( var i = 0; i < fdProtectWsdls.length; i++) {
				if (fdProtectWsdls[i].checked) {
					return fdProtectWsdls[i].value;
				}
			}
		}
	}

	  $(document).ready(function(){
		var inputs_fdAuthmethod=$("input[name='fdAuthMethod'][type='radio']");
        if(inputs_fdAuthmethod.length>0){
             $(inputs_fdAuthmethod).each(function(i){
                 var input_value= $(this).val();
                 var flag=false;
                 if($(this).is(":checked")){
                       if($.trim(input_value)=='ekpType') flag=true;
                       if($.trim(input_value)=='soapHeaderType') flag=true;
                       if($.trim(input_value)=='userToken') flag=true;
                  } 
                 if(flag) $("#wsUserPassword").show();
                 /* var fdUserName=$("input[name='fdUserName']");
                  var fdUserNameValue = $(fdUserName.get(0)).val();
                  var fdUserPass=$("input[name='fdPassword']")
                  var fdUserPassValue = $(fdUserPass.get(0)).val();
                 */
               });
            }
		  });


</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>

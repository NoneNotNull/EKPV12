<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ taglib uri="/tib/sys/soap/connector/resource/tld/erp-soapui.tld" prefix="soap"%>
<%@ include file="/resource/jsp/view_top.jsp"%>

<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="com.landray.kmss.tib.sys.soap.connector.util.header.licence.LicenceHeaderPlugin"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<script src="${KMSS_Parameter_ResPath}js/jquery.js"></script>
<script type="text/javascript" src="${KMSS_Parameter_ContextPath}tib/common/resource/js/custom_validations.js"></script>

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
			pageContext.setAttribute("erp_import_path",paths);
			//pageContext.setAttribute("erp_import_keys",StringUtils.join(keys,";"));
			//weblogic 10.x StringUtils 不能用,换个实现方式
			String keyInfo="";
			for(int i=0,len=keys.size();i<len;i++){
				keyInfo+=keys.get(i);
				if(i!=0&&i!=len-1){
					keyInfo+=";";
				}
			}
			pageContext.setAttribute("erp_import_keys",keyInfo);
			
			
		%>
<script>
Com_IncludeFile("dialog.js", null, "js");

	// 使Address地址换行
	$(function() {
		var docAddress = "${tibSysSoapSettingForm.docAddress}";
		var reg=new RegExp(";","g"); 
		docAddress = docAddress.replace(reg, "</br>");
		$("#docAddressTd").html(docAddress);
	});
	
	function confirmDelete(msg){
		var del = confirm("<bean:message key="page.comfirmDelete"/>");
		return del;
	}
	
</script>
<div id="optBarDiv">
	<kmss:auth requestURL="/tib/sys/soap/connector/tib_sys_soap_setting/tibSysSoapSetting.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('tibSysSoapSetting.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/tib/sys/soap/connector/tib_sys_soap_setting/tibSysSoapSetting.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('tibSysSoapSetting.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="tib-sys-soap-connector" key="table.tibSysSoapSetting"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.docSubject"/>
		</td><td  width="35%">
			<xform:text property="docSubject" style="width:85%" />
		</td>
		
		<td class="td_normal_title" width=15%>
						<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.settCategory"/>
					</td><td  width="35%">
						<xform:dialog required="true" propertyId="settCategoryId" propertyName="settCategoryName" dialogJs="categoryJs()">
						</xform:dialog>
					</td>
					
	</tr>
	<!-- 是否为保护型wsdl -->
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.fdProtectWsdl"/>
		</td><td colspan="3" width="85%">
			<xform:select property="fdProtectWsdl">
				<xform:enumsDataSource enumsType="ws_yesno" />
			</xform:select>
		</td>
	</tr>
	<!-- 加载wsdl 时候获取受保护类型的wsdl 密码 -->
	<c:if test="${tibSysSoapSettingForm.fdProtectWsdl == 'true' }">
	<tr id="fdloadUserPass">
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.fdloadUser"/>
		</td><td width="35%">
			<xform:text property="fdloadUser" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.fdloadPwd"/>
		</td><td width="35%">
			<input type="password" name="fdloadPwd" value="${tibSysSoapSettingForm.fdloadPwd }" readonly="readonly" style="width: 85%; border: 0px solid #000000;"/>
		</td>
	</tr>
	</c:if>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.fdWsdlUrl"/>
		</td><td colspan="3" width="35%">
			<xform:text property="fdWsdlUrl" style="width:60%" />
		</td>
	</tr>

	<%-- docAddress地址 
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.address"/>
		</td><td colspan="3" width="85%" id="docAddressTd">
			${tibSysSoapSettingForm.docAddress}
		</td>
	</tr>
	--%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.fdSoapVerson"/>
		</td><td width="35%" colspan="3">
			<xform:checkbox property="fdSoapVerson" showStatus="readOnly">
				<soap:erpSplitStringDateSource sourceString="${tibSysSoapSettingForm.fdSoapVerson}" regx=";"></soap:erpSplitStringDateSource>
			</xform:checkbox>
		</td>
		<%-- 
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.fdWsdlVersion"/>
		</td><td  width="35%">
			<xform:text property="fdWsdlVersion" style="width:35%" />
		</td>
		--%>
	</tr>
	<!-- 是否启用，是否分块发送 -->
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.fdEnable"/>
		</td><td colspan="3" width="85%">
			<xform:select property="fdEnable">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:select>
		</td>
		<%-- <td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.fdAllowBlock"/>
		</td><td width="35%">
			<xform:select property="fdAllowBlock">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:select>
		</td> --%>
	</tr>
	<!-- 超时 -->
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
		</td><td colspan="3" width="85%">
			<xform:select property="fdCheck">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:select>
		</td>
	</tr>
	<c:if test="${tibSysSoapSettingForm.fdCheck == 'true' }">
	<tr id="wsAuthLogin">
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.fdAuthMethod"/>
			</td>
			<td colspan="3">
		   		<xform:select showStatus="view" property="fdAuthMethod">
					<!-- 加载SOAP消息验证扩展点数据 -->
				 	<soap:soapLicenceDataSource></soap:soapLicenceDataSource>
				</xform:select>
			</td>
	</tr>
	
	</c:if>
	
	<c:forEach items="${erp_import_path}" var="cur_path" varStatus="vstatus">
			<c:import url="${cur_path}"></c:import>
		</c:forEach>
	
	<%-- <tr>
		<td class="td_normal_title" width=15%><bean:message
			bundle="tib-sys-soap-connector" key="tibSysSoapSetting.fdServerExt" /></td>
		<td width=85% colspan="3">
			<table class="tb_normal" width="95%" id="TABLE_DocList">
				<tr>
					<td class="td_normal_title" width="47%"><bean:message
						bundle="tib-sys-soap-connector" key="tibSysSoapSettingExt.fdWsExtName" /></td>
					<td class="td_normal_title" width="47%"><bean:message
						bundle="tib-sys-soap-connector" key="tibSysSoapSettingExt.fdWsExtValue" /></td>
					<!--<td class="td_normal_title" width="10%"><center><img
						style="cursor: pointer" class=optStyle
						src="<c:url value="/resource/style/default/icons/add.gif"/>"
						onclick="DocList_AddRow();"></center></td>
				--></tr>
				<!--<tr KMSS_IsReferRow="1" style="display: none">
					<td ><input type="text" name="fdServerExtForms[!{index}].fdWsExtName" class="inputsgl"
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
				--><c:forEach items="${tibSysSoapSettingForm.fdServerExtForms}"
					var="tibSysSoapSettingExtForm" varStatus="vstatus">
					<tr KMSS_IsContentRow="1">
						<td>
						<c:out value="${tibSysSoapSettingExtForm.fdWsExtName}" ></c:out>
						<!--<input type="text" class="inputsgl"
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
						--></td>
						<td>
							<c:out value="${tibSysSoapSettingExtForm.fdWsExtValue}" ></c:out>
						</td>
					</tr>
				</c:forEach>
			</table>
		</td>
	</tr> --%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapSetting.fdMarks"/>
		</td><td colspan="3" width="35%">
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
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Set" %>
<%@ page import="com.landray.kmss.sys.config.dict.SysDataDict" %>
<%@ include file="/resource/jsp/edit_top.jsp"%>	 
<%
	String fdModelName = request.getParameter("fdModelName");
	Set propertyNameSet =  SysDataDict.getInstance().getModel(fdModelName).getPropertyMap().keySet();
%>
<script language="JavaScript">
Com_IncludeFile("doclist.js|dialog.js");
</script>
 

<html:form action="/kms/expert/kms_expert_type/kmsExpertType.do">
	<div id="optBarDiv">
		<c:if test="${kmsExpertTypeForm.method_GET=='edit'}">
			<input type=button value="<bean:message key="button.update"/>" 
				onclick="Com_Submit(document.kmsExpertTypeForm, 'update');">
		</c:if>
		<c:if test="${kmsExpertTypeForm.method_GET=='add'}">
			<input type=button value="<bean:message key="button.save"/>" 
				onclick="Com_Submit(document.kmsExpertTypeForm, 'save');">
			<input type=button value="<bean:message key="button.saveadd"/>"
				onclick="Com_Submit(document.kmsExpertTypeForm, 'saveadd');">
		</c:if>
		<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
	</div>

	<p class="txttitle">
		<bean:message bundle="kms-expert" key="table.kmsExpertType" />
	</p>
	<%@ include file="kmsExpertType_script.jsp"%>
	<center>
		<table class="tb_normal" width=95%>
			<tr LKS_LabelName="<c:if test="${empty param.cateTitle}"><bean:message bundle="sys-simplecategory"
				key="table.sysSimpleCategory" /></c:if><c:if test="${not empty param.cateTitle}">${param.cateTitle}</c:if>">
				<td>
					<table class="tb_normal" width="100%" ${param.styleValue}>
						<c:set var="sysSimpleCategoryMain" value="${requestScope['kmsExpertTypeForm']}" />
						<c:set var="selectEmpty" value="true" />
						<kmss:auth
							requestURL="/kms/expert/kms_expert_type/kmsExpertType.do?method=add"
							requestMethod="Get">
							<c:set var="selectEmpty" value="false" />
						</kmss:auth>
						<%--父类别名称 --%>
						<tr>
							<td class="td_normal_title" width=15%>
								<bean:message
									bundle="sys-simplecategory" key="sysSimpleCategory.fdParentName" />
							</td>
							<td colspan="3">
								<html:hidden property="fdParentId" /> 
								<html:text
									property="fdParentName" readonly="true" styleClass="inputsgl"
									style="width:90%" /> 
								<a href="#"
								   onclick="Dialog_SimpleCategory('${param.fdModelName}','fdParentId','fdParentName',false,null,'01',null,${selectEmpty},'${param.fdId}');Cate_getParentMaintainer();">
								<bean:message key="dialog.selectOther" /> 
								</a>
							</td>
						</tr>
						<%--类别名称 --%>
						<tr>
							<td class="td_normal_title" width=15%>
								<bean:message
								 	bundle="sys-simplecategory" key="sysSimpleCategory.fdName" /></td>
							<td colspan="3">
								<html:text property="fdName" style="width:90%" />
								<span class="txtstrong">*</span>
							</td>
						</tr>
						<%--属性 --%>
						<c:import url="/kms/common/resource/ui/sysPropertyTemplate_select.jsp" charEncoding="UTF-8">
							<c:param name="formName" value="kmsExpertTypeForm" />
							<c:param name="mainModelName" value="com.landray.kmss.kms.expert.model.KmsExpertInfo" />
						</c:import>
						<%--序号 --%>
						<tr>
							<td class="td_normal_title" width=15%><bean:message
								key="model.fdOrder" /></td>
							<td colspan="3"><html:text property="fdOrder" /></td>
						</tr>
						<%-- 继承上级分类维护者 --%>
						<tr>
							<td class="td_normal_title" width=15%><bean:message bundle="sys-simplecategory"
								key="sysSimpleCategory.parentMaintainer" /></td>
							<td colspan="3" id="parentMaintainerId">${parentMaintainer}</td>
						</tr>
						
						<tr>
							<td class="td_normal_title" width=15%>
								<bean:message key="model.tempEditorName" />
							</td>
							<td colspan="3">
								<html:hidden  property="authEditorIds"/><html:textarea property="authEditorNames" style="width:90%" rows="4" readonly="true" styleClass="inputmul"/>
								<a href="#" onclick="Dialog_Address(true, 'authEditorIds', 'authEditorNames', ';', null);">
								<bean:message key="dialog.selectOrg"/>
								</a>
								<div class="description_txt">
								<bean:message	bundle="sys-simplecategory" key="description.main.tempEditor" />
								</div>
							</td>
						</tr>
				
						<tr>
							<td class="td_normal_title" width=15%><bean:message
								key="model.tempReaderName" /></td>
							<td colspan="3">
							<input type="checkbox" name="authNotReaderFlag" value="${sysSimpleCategoryMain.authNotReaderFlag}" onclick="Cate_CheckNotReaderFlag(this);" 
							<c:if test="${sysSimpleCategoryMain.authNotReaderFlag eq 'true'}">checked</c:if>>
							<bean:message bundle="sys-simplecategory" key="description.main.tempReader.notUse" />
							<div id="Cate_AllUserId">
								<html:hidden  property="authReaderIds"/>
								<html:textarea property="authReaderNames" style="width:90%" rows="4" readonly="true" styleClass="inputmul"/>
								<a href="#" onclick="Dialog_Address(true, 'authReaderIds', 'authReaderNames', ';', null);">
									<bean:message key="dialog.selectOrg"/>
								</a>
							<div>
							<div id="Cate_AllUserNote">
							<bean:message bundle="sys-simplecategory" key="description.main.tempReader.allUse" />
							</div>
							</td>
						</tr>
						<tr style="display:none">
							<td class="td_normal_title" width=15%><bean:message
								bundle="sys-simplecategory" key="sysSimpleCategory.fdIsinheritMaintainer" /></td>
							<td width=35%>
							<sunbor:enums property="fdIsinheritMaintainer" enumsType="common_yesno" elementType="radio" />
							</td>
							<td class="td_normal_title" width=15%><bean:message
								bundle="sys-simplecategory" key="sysSimpleCategory.fdIsinheritUser" /></td>
							<td width=35%>
								<sunbor:enums property="fdIsinheritUser" enumsType="common_yesno" elementType="radio" />
							</td>			
						</tr>
						<c:if test="${sysSimpleCategoryMain.method_GET!='add'}">
						<tr>
							<td class="td_normal_title" width=15%><bean:message
								key="model.fdCreator" /></td>
							<td width=35%><bean:write name="sysSimpleCategoryMain" property="docCreatorName"/></td>
							<td class="td_normal_title" width=15%><bean:message
								key="model.fdCreateTime" /></td>
							<td width=35%><bean:write name="sysSimpleCategoryMain" property="docCreateTime"/></td>			
						</tr>
						<c:if test="${sysSimpleCategoryMain.docAlterorName!=''}">
						<tr>
							<td class="td_normal_title" width=15%><bean:message
								key="model.docAlteror" /></td>
							<td width=35%><bean:write name="sysSimpleCategoryMain" property="docAlterorName"/></td>
							<td class="td_normal_title" width=15%><bean:message
								key="model.fdAlterTime" /></td>
							<td width=35%><bean:write name="sysSimpleCategoryMain" property="docAlterTime"/></td>
						</tr>
						</c:if>
						</c:if>
					</table>
				</td>
			</tr>
		</table>
	</center>
	<html:hidden property="fdId" />
	<html:hidden property="method_GET" />
</html:form>
<html:javascript formName="kmsExpertTypeForm" cdata="false"
	dynamicJavascript="true" staticJavascript="false" />
<%@ include file="/resource/jsp/edit_down.jsp"%>
<script>
Com_Parameter.event["submit"][Com_Parameter.event["submit"].length] = function() {
	//提交前，校验类别名称唯一性
	if (checkAskName()) {
		return true;
	} else {
		return false;
	}
}
function checkAskName() {
	var fdName = document.getElementsByName("fdName")[0].value;
	var fdId = '${kmsExpertTypeForm.fdId}';
	var parentId = '${kmsExpertTypeForm.fdParentId}';
	if (fdName != "" && fdName != null) {
		var url = "kmsExpertTypeCheckService&fdName=" + fdName + "&fdId=" + fdId + "&parentId=" + parentId;
		url = Com_SetUrlParameter(url, "fdName", fdName);
		var data = new KMSSData();
		var rtnVal = data.AddBeanData(url).GetHashMapArray()[0];
		var flag = rtnVal["flag"];
		if (flag == 'true') {
			return true;
		} else {
			alert('<bean:message key="kmsExpert.msg.type.hasExist" bundle="kms-expert"/>');
			return false;
		}
	} else {
		alert('<bean:message key="kmsExpert.msg.type.notNull" bundle="kms-expert"/>');
		return false;
	}
}
	Com_IncludeFile("jquery.js|dialog.js");
	function Cate_CheckNotReaderFlag(el){
		document.getElementById("Cate_AllUserId").style.display=el.checked?"none":"";
		document.getElementById("Cate_AllUserNote").style.display=el.checked?"none":"";
		el.value=el.checked;
	}
	
	function Cate_Win_Onload(){
		Cate_CheckNotReaderFlag(document.getElementsByName("authNotReaderFlag")[0]);
	}

	Com_AddEventListener(window, "load", Cate_Win_Onload);
	
	function checkParentId(){
		var formObj = document.forms['kmsExpertTypeForm'];
		if(formObj.fdParentId.value!="" && formObj.fdParentId.value==formObj.fdId.value){
			alert('<bean:message bundle="sys-simplecategory" key="error.illegalSelected" />');
			return false;
		}else
			return true;	
	}
	Com_Parameter.event["submit"][Com_Parameter.event["submit"].length] = checkParentId;

	//自动带出继承上级分类维护者
	function Cate_getParentMaintainer(){
		var parameters ="parentId="+document.getElementsByName("fdParentId")[0].value;
		var s_url = Com_Parameter.ContextPath+"/kms/expert/kms_expert_type/kmsExpertType.do?method=getParentMaintainer";
		$.ajax({
				url: s_url,
				type: "GET",
				data: parameters,
				dataType:"text",
				async: false,
				success: function(text){
					$("#parentMaintainerId").text(text);
				}});
	}

</script>
<%@ page
	language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.Set" %>
<%@ page import="com.landray.kmss.sys.config.dict.SysDataDict" %>
<%
	String fdModelName = request.getParameter("fdModelName");
	Set propertyNameSet =  SysDataDict.getInstance().getModel(fdModelName).getPropertyMap().keySet();
%>
<%@ include file="/resource/jsp/edit_top.jsp"%>

<kmss:windowTitle
	subjectKey="kms-multidoc:table.kmsMultidocTemplate"
	moduleKey="kms-multidoc:table.kmdoc" />
<script language="JavaScript">
Com_IncludeFile("dialog.js");

//提交校验
Com_Parameter.event["submit"][Com_Parameter.event["submit"].length] = function() {

  //提交前，校验类别名称唯一性
  // 属性模板必填
	if( checkMultidocName()  )
		 return true ;
	else 
		return false ;
  
}
function checkTemplate() {
	var propTemplateId=document.getElementsByName("fdSysPropTemplateId")[0] ; 

	if(propTemplateId.value=='' || propTemplateId.value==null){
		alert('属性模板不可为空');
		return false;
		}
	else
		return true ; 
 	
}
function checkMultidocName(){

	var fdName=document.getElementsByName("fdName")[0].value ; 
	var fdId='${kmsMultidocTemplateForm.fdId}';
	var parentId='${kmsMultidocTemplateForm.fdParentId}'; 
	 
	if(fdName != "" && fdName != null){
		//fdName=encodeURI(fdName) ; //中文两次转码
		//fdName=encodeURI(fdName)  ;
		var url="kmsMultidocTemplateCheckService&type=1&fdName="+fdName+"&fdId="+fdId+"&parentId="+parentId;
		url = Com_SetUrlParameter(url, "fdName", fdName);
		var data = new KMSSData(); 
		var rtnVal =data.AddBeanData(url).GetHashMapArray()[0];
		var flag=rtnVal["flag"];
			   	if(flag=='true'){
			   		return true;
			   	}else{
			   		//alert("类别名称已存在，请更换类别名称。");
			   	    alert('<bean:message key="msg.hasExist" bundle="kms-multidoc"/>');
			   		return false;
			   	}
	}else{
		//alert("类别名称不能为空。");
		alert('<bean:message key="msg.notNull" bundle="kms-multidoc"/>');
		return false;
	}

	
}

</script>
<html:form
	action="/kms/multidoc/kms_multidoc_template/kmsMultidocTemplate.do"
	onsubmit="return validateKmsMultidocTemplateForm(this);">
		
		<c:import url="/sys/simplecategory/sys_simple_category/sysCategoryMain_edit_button.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="kmsMultidocTemplateForm" />
		</c:import>

	<p class="txttitle"><bean:message
		bundle="kms-multidoc"
		key="table.kmsMultidocTemplate" /></p>

	<center>
	<table
		id="Label_Tabel"
		width="95%">

		<c:set var="selectEmpty" value="true" />
		<kmss:auth
			requestURL="${param.requestURL}"
			requestMethod="Get">
			<c:set var="selectEmpty" value="false" />
		</kmss:auth>
<!-- 类别信息  -->
		<c:import url="/kms/common/resource/ui/sysCategoryMain_edit.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="kmsMultidocTemplateForm" />
			<c:param name="requestURL" value="/kms/multidoc/kms_multidoc_template/kmsMultidocTemplate.do?method=add" />
			<c:param name="fdModelName" value="${param.fdModelName}" />
			<c:param name="mainModelName" value="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge" />
			<c:param name="cateTitle" value="类别信息 " />
		</c:import>
		<tr LKS_LabelName="文档信息" > 
			<td>
			<table
				class="tb_normal"
				width=100%>
				
				<label>在下面填写文档默认值</label>
				<tr>
				<td class="td_normal_title" width=15%><bean:message bundle="kms-multidoc"
						key="kmsMultidocTemplate.docContent" /></td>
				<td width=85%><kmss:editor property="docContent" height="400" /></td>
	 			</tr>
				<tr>
					<td
						class="td_normal_title"
						width=15%><bean:message
						bundle="kms-multidoc"
						key="kmsMultidocTemplate.fdStoretime" /></td>
					<td width=85%><html:text property="docExpire" /><bean:message
						key="message.storetime"
						bundle="kms-multidoc" /><bean:message
						key="message.storetime.tip"
						bundle="kms-multidoc" /></td>
				</tr>
				
				
				<!-- 标签机制 -->
				<c:import url="/sys/tag/include/sysTagTemplate_edit.jsp"
					charEncoding="UTF-8">
					<c:param name="formName" value="kmsMultidocTemplateForm" />
					<c:param name="fdKey" value="mainDoc" /> 
					<c:param name="diyTitle" value="默认关键字" /> 
				</c:import>
				<tr>
					<td
						class="td_normal_title"
						width="15%"><bean:message
						bundle="kms-multidoc"
						key="kmsMultidoc.rattachement" /></td>
					<td><c:import
						url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp"
						charEncoding="UTF-8">
						<c:param
							name="fdKey"
							value="rattachment" />
					</c:import></td>
				</tr>
			</table>
			</td>
		</tr>
		
		<!-- 流程设置  -->
		<c:import url="/sys/workflow/include/sysWfTemplate_edit.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="kmsMultidocTemplateForm" />
			<c:param name="fdKey" value="mainDoc" /> 
			<c:param name="diyTitle" value="设置" /> 
		</c:import>
		<%--<tr LKS_LabelName="<bean:message bundle="kms-multidoc" key="kmsMultidocTemplate.lbl.publish"/>">
			<td>
			<table
				class="tb_normal"
				width="100%">
			</table>
			</td>
		</tr>
		--%>
		<%--关联机制--%>
		<tr LKS_LabelName="知识关联设置">
		<!--  bean:message bundle="sys-relation" key="sysRelationMain.tab.label"  -->
			<c:set
				var="mainModelForm"
				value="${kmsMultidocTemplateForm}"
				scope="request" />
			<c:set
				var="currModelName"
				value="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge"
				scope="request" />
			<td><%@ include file="/sys/relation/include/sysRelationMain_edit.jsp"%></td>
		</tr>
		<%----发布机制开始--%>
		<div style="display:none">
		 
		</div>
		<%----发布机制结束--%>
		
		
		<%----权限--%>
		<tr LKS_LabelName="<bean:message bundle="sys-right" key="right.moduleName" />设置">
			<td>
			<table
				class="tb_normal"
				width=100%>
				<c:import
					url="/sys/right/tmp_right_edit.jsp"
					charEncoding="UTF-8">
					<c:param
						name="formName"
						value="kmsMultidocTemplateForm" />
					<c:param
						name="moduleModelName"
						value="com.landray.kmss.kms.multidoc.model.KmsMultidocTemplate" />
				</c:import>
			</table>
			</td>
		</tr>
	</table>
	</center>
	<html:hidden property="fdId" />
	<html:hidden property="method_GET" />
</html:form>
<html:javascript
	formName="kmsMultidocTemplateForm"
	cdata="false"
	dynamicJavascript="true"
	staticJavascript="false" />
<%@ include file="/resource/jsp/edit_down.jsp"%>
<script>
function loadExtendPropertyData(modelName) {
	var proTemplateId = $("input[name=fdSysPropTemplateId]").val();
	return new KMSSData().AddBeanData("kmsMultidocFormulaDictVarTree&modelName="+modelName+"&proTemplateId="+proTemplateId).GetHashMapArray();
}

var Formula_GetVarInfoByModelName_old = window.Formula_GetVarInfoByModelName;
//获取主文档和表单数据字典
function Formula_GetVarInfoByModelName(modelName) {
	if(window.loadExtendPropertyData){
		return loadExtendPropertyData(modelName);
	}else{
		return Formula_GetVarInfoByModelName_old(modelName);
	}
}

/**
 * 模版改变通知
 */
function updateNotice(val){
	if(proTemplateId && (!val.data[0] || proTemplateId!=val.data[0].id)){
		alert("模板发生变更,如果在流程公式中设置了扩展属性,请手动修改!");
	}
}
</script>

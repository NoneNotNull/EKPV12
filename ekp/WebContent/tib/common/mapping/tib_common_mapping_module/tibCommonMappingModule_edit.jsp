<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/tib/common/mapping/tib_common_mapping_module/tibCommonMappingModule.do">
<div id="optBarDiv">
	<c:if test="${tibCommonMappingModuleForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			<%-- 
			onclick="if(!confirm('<bean:message bundle="tib-common-mapping" key="tibCommonMappingModule.confirm.restart"/>'))return;Com_Submit(document.tibCommonMappingModuleForm, 'update');">
			--%>
			onclick="Com_Submit(document.tibCommonMappingModuleForm, 'update');">
			
	</c:if>
	<c:if test="${tibCommonMappingModuleForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.tibCommonMappingModuleForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.tibCommonMappingModuleForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="tib-common-mapping" key="table.tibCommonMappingModule"/></p>

<center>
<script type="text/javascript">
Com_IncludeFile("dialog.js");
var TibCommon_lang = {
	    examineFlow : "<bean:message bundle="tib-common-mapping" key="tibCommonMappingModule.lang.examineFlow"/>",
	    newModule : "<bean:message bundle="tib-common-mapping" key="tibCommonMappingModule.lang.newModule"/>"
	};
</script>
<script type="text/javascript" src="${KMSS_Parameter_ContextPath}tib/common/mapping/tib_common_mapping_module/modelSettingCfg.js">
</script>

<table class="tb_normal" width=95%>
	<%-- 
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-mapping" key="tibCommonMappingModule.fdServerName"/>
		</td>
		<td colspan="3" width="85%">
			<xform:text property="fdServerName" style="width:50%"  required="true"/>
		</td>
	</tr>
	--%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-mapping" key="tibCommonMappingModule.fdModuleName"/>
		</td><td width="35%">
		<xform:text property="fdModuleName" required="true" > </xform:text>
		<select name="fdModuleName_select"  onchange="changeOther(this)"></select>
		</td>
		
	<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-mapping" key="tibCommonMappingModule.fdUse"/>
		</td><td width="35%">
			<xform:radio property="fdUse">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:radio>
		</td>
	</tr>
	<tr>
	<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-mapping" key="tibCommonMappingModule.fdTemplateName"/>
		</td><td width="35%">
			<xform:text property="fdTemplateName" value="" style="width:85%"  required="true"/><br>
			<xform:radio property="fdCate"  onValueChange="changeAllConfig(this);">
				<xform:enumsDataSource enumsType="tibCommonMappingModule_cate" />
			</xform:radio>
		</td>
			<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-mapping" key="tibCommonMappingModule.fdMainModelName"/>
		</td><td width="35%">
			<xform:text property="fdMainModelName" value="" style="width:85%"  required="true" />
		</td>
	</tr>

	<tr id="allConfig" style="display: ${tibCommonMappingModuleForm.fdCate==0?'none':''}">
	<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-mapping" key="tibCommonMappingModule.fdTemCateFieldName"/>
		</td><td width="35%">
		<xform:text property="fdTemCateFieldName" value="" style="width:70%"  required="${tibCommonMappingModuleForm.fdCate==0?'false':'true'}" />
		<%--  
		<font color="red">一般为docCategory</font>
		--%>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-mapping" key="tibCommonMappingModule.fdTemNameFieldName"/>
		</td><td width="35%">
		<xform:text property="fdTemNameFieldName" value="" style="width:70%" required="${tibCommonMappingModuleForm.fdCate==0?'false':'true'}" />
		<%-- 
		<font color="red">一般为fdName</font>
		--%>
		</td>
	</tr>
	<tr>
	<td class="td_normal_title" width=25%>
			<bean:message bundle="tib-common-mapping" key="tibCommonMappingModule.fdModelTemFieldName"/>
		</td><td width="25%">
		<xform:text property="fdModelTemFieldName" value="" style="width:50%"  required="true" />
		<%-- 
		<font color="red">一般为fdTemplate</font>
		--%>
		</td>
		<td class="td_normal_title" width=25%>
			<bean:message bundle="tib-common-mapping" key="tibCommonMappingModule.fdFormTemFieldName"/>
		</td><td width="25%">
		<xform:text property="fdFormTemFieldName" value="" style="width:50%"  required="true" />
		<%-- 
		<font color="red">一般为fdTemplateId</font>
		--%>
		
		</td>
	</tr>
	<tr>
	<td class="td_normal_title" width=25%>
			<bean:message bundle="tib-common-mapping" key="tibCommonMappingModule.fdType"/>
		</td><td width="25%">
			 <xform:checkbox property="fdType" value="${tibCommonMappingModuleForm.fdType}" >
			     <xform:customizeDataSource className="com.landray.kmss.tib.common.mapping.plugins.taglib.TibCommonPluginsDataSource"/>
		     </xform:checkbox>
		</td>
		<td class="td_normal_title" width=25%>

		</td><td width="25%">

		
		</td>
	</tr>	
	




	
	
	
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script type="text/javascript">
	$KMSSValidation();
	function changeAllConfig(_this){
		var dom=document.getElementById("allConfig");
		if(_this.value=='0') {
			dom.style.display="none";
			document.getElementsByName("fdTemCateFieldName")[0].validate="";
			document.getElementsByName("fdTemNameFieldName")[0].validate="";
		}
		else {
			dom.style.display="";
			document.getElementsByName("fdTemCateFieldName")[0].validate="required";
			document.getElementsByName("fdTemNameFieldName")[0].validate="required";
			}
	}

	<%-- init fdModuleName --%>
   function initElementByCfg(elem){
	   emptyItem(elem);
	   var defOption=new Option("==请选择==","");
	   elem.options.add(defOption);
	   for(var i=0 ,len=cacheModuelInfo.length;i<len;i++){
		   if(cacheModuelInfo[i]["modelName"]){
			   elem.options.add(new Option(cacheModuelInfo[i]["modelName"],cacheModuelInfo[i]["modelName"]));
			   }
		   } 
	   defOption.selected=true;
	   }

   function emptyItem(elem){
	   while (elem.firstChild) {
			elem.removeChild(elem.firstChild);
		}
	   }
	
	;(
   function initSelect(){
     var elem= document.getElementsByName("fdModuleName_select")[0];
     initElementByCfg(elem);
     var initVal='${tibCommonMappingModuleForm.fdModuleName}';
      for(var i=0 ,len =elem.options.length;i<len ;i++){
   	   if(elem.options[i].value==initVal){
    		   elem.options[i].selected=true;
    		   return ;
        	   }
	   }

	   

   })();

	

	
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>

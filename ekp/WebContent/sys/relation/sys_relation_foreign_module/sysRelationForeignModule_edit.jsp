<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@ page import="com.landray.kmss.framework.service.plugin.Plugin"%>
<%@ page import="com.landray.kmss.framework.plugin.core.config.IExtension"%>
<%@ page import="com.landray.kmss.sys.relation.RelaPlugin"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.Map"%>
<script type="text/javascript">
Com_IncludeFile("docutil.js|doclist.js", null, "js");
//选择搜索引擎
function changeSearchEngine(owner){
	var optionValue = owner.options[owner.selectedIndex].value;	
	if(optionValue!=null && optionValue!=""){
		var optionArr = optionValue.split("|");
		if (confirm('<bean:message  bundle="sys-relation" key="sysRelationForeignModule.fdSearchEngineBean.select.tip"/>')) {
			var searchConfigJsp = "";
			if(optionArr.length > 1){//说明含有搜索引擎配置页面
				searchConfigJsp = optionArr[1];
			}				
			var url = location.href;
			url = Com_SetUrlParameter(url, "selectedValue", optionArr[0]);
			url = Com_SetUrlParameter(url, "searchConfigJsp", searchConfigJsp);
			location.href = url;
		}
	}
}

Com_AddEventListener(window, "load", function(){
	var selectObj = document.getElementsByName("fdSearchEngineBean1")[0];
	var selectedValue = "${sysRelationForeignModuleForm.fdSearchEngineBean}";
	var locationSelValue = Com_Trim("${param.selectedValue}");
	
	
	if(locationSelValue.length !=0){
		selectedValue = "${param.selectedValue}";
	}
	//if(selectedValue == null || selectedValue == "")return;
	
	//默认选中当前模块
	for (var j=0; j<selectObj.options.length; j++) {
		var optionValueArr = selectObj.options[j].value.split("|");		
		if(selectedValue == optionValueArr[0]){
			selectObj.options[j].selected = true;
			break;
		}
	}	
});

function commitMethod(commitType){
	var formObj = document.sysRelationForeignModuleForm;
	var fdSearchEngineBeanObj = document.getElementsByName("fdSearchEngineBean1")[0];
	if(fdSearchEngineBeanObj.value == "" || fdSearchEngineBeanObj.value == null ){
		alert('<bean:message  bundle="sys-relation" key="sysRelationForeignModule.fdSearchEngineBean.select"/>');
		return;
	}else{
		document.getElementsByName("fdSearchEngineBean")[0].value = fdSearchEngineBeanObj.options[fdSearchEngineBeanObj.selectedIndex].value.split("|")[0];
	}
	Com_Submit(formObj, commitType);
}
</script>
<html:form action="/sys/relation/sys_relation_foreign_module/sysRelationForeignModule.do" 
	onsubmit="return validateSysRelationForeignModuleForm(this);">
<div id="optBarDiv">
	<c:if test="${sysRelationForeignModuleForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="commitMethod('update');">
	</c:if>
	<c:if test="${sysRelationForeignModuleForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="commitMethod('save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="commitMethod('saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message  bundle="sys-relation" key="table.sysRelationForeignModule"/></p>
<center>
<table id="TABLE_DocList" class="tb_normal" width=95%>
	<tr>	
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-relation" key="sysRelationForeignModule.fdModuleKey"/>
		</td><td width=35%>
			<html:text property="fdModuleKey" style="width: 90%" />
			<span class="txtstrong">*</span>
		</td>	
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-relation" key="sysRelationForeignModule.fdModuleName"/>
		</td><td width=35%>
			<html:text property="fdModuleName" style="width: 90%" />
			<span class="txtstrong">*</span>
		</td>		
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-relation" key="sysRelationForeignModule.fdOrder"/>
		</td><td width=85% colspan="3">
			<html:text  property="fdOrder"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" colspan="4">
			<center><bean:message bundle="sys-relation" key="table.sysRelationForeignParam.list"/></center>
		</td>
	</tr>
	<tr align="center">
		<td class="td_normal_title" width="15%">
			<bean:message bundle="sys-relation" key="sysRelationForeignParam.fdParam" />
		</td>
		<td class="td_normal_title" width="20%">
			<bean:message bundle="sys-relation" key="sysRelationForeignParam.fdParamName" />
		</td>
		<td class="td_normal_title" width="20%">
			<bean:message bundle="sys-relation" key="sysRelationForeignParam.fdParamType" />
		</td>
		<td class="td_normal_title" width="20%">
			<input class="btnopt" id="addRow" type=button value="<bean:message key="button.insert" />" onclick="DocList_AddRow();">			
			<html:hidden property="fdId"/>
		</td>
	</tr>
	<tr KMSS_IsReferRow="1" style="display:none">
		<td><input type="text" name="sysRelationParamFormList[!{index}].fdParam" class="inputsgl" value="" style="width:90%"></td>
		<td><input type="text" name="sysRelationParamFormList[!{index}].fdParamName" class="inputsgl" value="" style="width:90%"></td>
		<td>
			<sunbor:enums property="sysRelationParamFormList[!{index}].fdParamType" enumsType="sysRelation_fdParamType" elementType="select" bundle="sys-relation" />
		</td>
		<td>
			<center>
				<input class="btnopt" id="deleteRow" type=button value="<bean:message key="button.delete" />" onclick="if(confirm('<bean:message key="page.comfirmDelete"/>')){DocList_DeleteRow();}">		
			</center>
		</td>
	</tr>
	<c:forEach items="${sysRelationForeignModuleForm.sysRelationParamFormList}" varStatus="vstatus" var="sysRelationParamForm">
		<c:set var="paramPrefix" value="sysRelationParamFormList[${vstatus.index}]." scope="request"/>		
		<tr KMSS_IsContentRow="1">
			<td>
				<input type="text" class="inputsgl" name="${paramPrefix}fdParam" value="${sysRelationParamForm.fdParam }" style="width:90%"/ >
			</td>
			<td>
				<input type="text" class="inputsgl" name="${paramPrefix}fdParamName" value="${sysRelationParamForm.fdParamName }" style="width:90%"/ >
			</td>
			<td>				
				<sunbor:enums property="${paramPrefix}fdParamType" value="${sysRelationParamForm.fdParamType }" enumsType="sysRelation_fdParamType" elementType="select" bundle="sys-relation" />
			</td>
			<td>
				<center>
					<input class="btnopt" id="deleteRow" type=button value="<bean:message key="button.delete" />" onclick="if(confirm('<bean:message key="page.comfirmDelete"/>')){DocList_DeleteRow();}">
				</center>
			</td>
		</tr>
	</c:forEach>	
	<tr>		
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-relation" key="sysRelationForeignModule.fdSearchEngineBean"/>
		</td><td width=80% colspan="3">
			<select name="fdSearchEngineBean1" onchange="changeSearchEngine(this);">
				<option value="" selected="true"><bean:message  bundle="sys-relation" key="sysRelationForeignModule.fdSearchEngineBean.select"/></option>
				<% 	
				    Iterator ite = RelaPlugin.getSerachExtionMap().entrySet().iterator();
					while(ite.hasNext()){
						Map.Entry entry = (Map.Entry) ite.next();
						String beanName = (String) entry.getKey();
						Map valueMap = (Map) entry.getValue();
						String searchConfigJsp = (String) valueMap.get(RelaPlugin.PARAM_SEARCH_CONFIG_JSP);
						String engineName = (String) valueMap.get(RelaPlugin.PARAM_NAME);
						searchConfigJsp = searchConfigJsp == null ? "":"|"+searchConfigJsp;
						String optionValue = beanName+searchConfigJsp;
				%>
				<option value="<%=optionValue%>"><%=engineName %></option>
				<%	} %>
			</select><span class="txtstrong">*</span>
			<font color="red"><bean:message bundle="sys-relation" key="label.note.select.first" /></font>
			<input type="hidden" name="fdSearchEngineBean" value="">	
		</td>
	</tr>
	<tr>
		<td colspan="4">
			<%--搜索引擎配置页面 --%>
			<c:if test="${not empty param.searchConfigJsp}">
				<c:import url="${param.searchConfigJsp}" charEncoding="UTF-8"></c:import>
			</c:if>
		</td>
	</tr>
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<html:javascript formName="sysRelationForeignModuleForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/resource/jsp/edit_down.jsp"%>
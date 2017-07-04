<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/kms/integral/kms_integral_rule/kmsIntegralRule.do">
<div id="optBarDiv">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="if(validate())return;Com_Submit(document.kmsIntegralRulesForm, 'update');">
		<input style="display:none;" type=button value="<bean:message bundle="kms-integral" key="kmsIntegralRule.extendCategoryRule"/>" 
		onclick="if(validate())return;selectCategory()">
		<input type=button value="<bean:message key="button.delete"/>" 
			onclick="if(deleteValidate())return;Com_Submit(document.kmsIntegralRulesForm, 'deleteall');">
		<input type=button value="<bean:message bundle="kms-integral" key="button.importRule"/>"
			onclick="importRule();">
</div>

<table id="TABLE_DocList" class="tb_normal " width="95%">
	<tr class="tr_normal_title">
		<td width=25%>
			<bean:message bundle="kms-integral" key="kmsIntegralRule.fdName"/>
		</td>
		<td width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralRule.fdExpValue"/>
		</td>
		<td width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralRule.fdRichesValue"/>
		</td>
		<td width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralRule.fdObjectExpValue"/>
		</td>
		<td width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralRule.fdObjectRichesValue"/>
		</td>
		<td width=15% style="display:none;">
			<bean:message bundle="kms-integral" key="kmsIntegralRule.fdCategory"/>
		</td>
	</tr>
	<tr KMSS_IsReferRow="1" style="display:none">
		<td align="center">
			<input type="hidden" name="integralRules[!{index}].fdId" >
			<input type="hidden" name="integralRules[!{index}].fdOperateName" >
			<input type="checkbox" name="integralRules[!{index}].fdId">
			<input type="hidden" name="integralRules[!{index}].attribute" >
			<xform:text property="integralRules[!{index}].fdName" showStatus="readonly" />
		</td>
		<td align="center">
			<xform:text property="integralRules[!{index}].fdExpValue" showStatus="edit" style="width:80%" required="true" />
		</td>
		<td align="center">
			<xform:text property="integralRules[!{index}].fdRichesValue" showStatus="edit" style="width:80%" required="true"/>
		</td>
		<td align="center">
			<xform:text property="integralRules[!{index}].fdObjectExpValue" showStatus="edit" style="width:80%" required="true"/>
		</td>
		<td align="center">
			<xform:text property="integralRules[!{index}].fdObjectRichesValue" showStatus="edit" style="width:80%" required="true"/>
		</td>
		<td align="center" style="display:none;">
			<input type="hidden" name="integralRules[!{index}].fdCategoryId" >
			<xform:text property="integralRules[!{index}].fdCategoryName" showStatus="readonly" />
		</td>
	</tr>
	<c:forEach items="${kmsIntegralRulesForm.integralRules}" var="integralRules" varStatus="vstatus">
	<c:if test="${vstatus.index==0}">
		<c:set value="${integralRules.moduleName}" var="varName" />
	</c:if>
	<c:if test="${integralRules.moduleName!=lastModuleName}">
	<tr KMSS_IsContentRow="1" KMSS_isNotContentRow="true">
		<td colspan="6" style="font-weight: bold">${integralRules.moduleName}
			<a style="font-weight:normal;color:blue;" href="javascript:void(0)" onclick="unfold('${integralRules.moduleName}',this)">${integralRules.moduleName!=varName?'展开':'收缩'}</a>
		</td>
	</tr>
	</c:if>
	<tr KMSS_IsContentRow="1" module="${integralRules.moduleName}" id="${integralRules.fdId}" title="${integralRules.fdName}"  style="cursor:pointer;${integralRules.moduleName!=varName?'display:none;':''}">
		<td align="left" style="padding-left: 100px;">
			<input type="hidden" name="integralRules[${vstatus.index}].fdId" value="${integralRules.fdId }">
			<input type="hidden" name="integralRules[${vstatus.index}].fdOperateName"  value="${integralRules.fdOperateName }">
			<input type="checkbox" name="List_Selected" value="${integralRules.fdId }"/>
			<input type="hidden" name="integralRules[${vstatus.index}].fdModuleKey" value="${integralRules.fdModuleKey }">
			<input type="hidden" name="integralRules[${vstatus.index}].fdModelName" value="${integralRules.fdModelName }">
			${integralRules.fdName}
		</td>
		<td align="center">
			<xform:text property="integralRules[${vstatus.index}].fdExpValue" showStatus="edit" style="width:80%" required="true" validators="integer"/>
		</td>
		<td align="center">
			<xform:text property="integralRules[${vstatus.index}].fdRichesValue" showStatus="edit" style="width:80%" required="true" validators="integer"/>
		</td>
		<td align="center">
			<xform:text property="integralRules[${vstatus.index}].fdObjectExpValue" showStatus="edit" style="width:80%" required="true" validators="integer"/>
		</td>
		<td align="center">
			<xform:text property="integralRules[${vstatus.index}].fdObjectRichesValue" showStatus="edit" style="width:80%" required="true" validators="integer"/>
		</td>
		<td align="center" style="display:none;">
			${integralRules.fdCategoryName}
		</td>
		<c:set value="${integralRules.moduleName}" var="lastModuleName" />
	</tr>
	</c:forEach>
</table>
<script>
	Com_IncludeFile("dialog.js|doclist.js"); 
	var _Valudator = $KMSSValidation();
	Com_AddEventListener(window,"load",initialize);
	var selectedRows;
	var moduleKey;

	//初始化页面
	function initialize(){
		_Valudator.addValidator('integer()', '<bean:message bundle="kms-integral" key="kmsIntegralRule.validate.msg"/>', function(v) {
			return this.getValidator('isEmpty').test(v) || /^[-+]?[0-9]{1,3}$/.test(v);
		});
	}

	//数据验证
	function validate(){
		return !_Valudator.validate();
	}

	//删除验证
	function deleteValidate(){
		if(validate()){
			return true;
		}
		if(!findSelectedRow()){
			return true;
		}
	}

	//收折
	function unfold(moduleName,that){
		if($(that).text()=='<bean:message bundle="kms-integral" key="kmsIntegralRule.unfold"/>'){
			$(that).text('<bean:message bundle="kms-integral" key="kmsIntegralRule.fold"/>');
		}else{
			$(that).text('<bean:message bundle="kms-integral" key="kmsIntegralRule.unfold"/>');
		}
		$("tr[module='"+moduleName+"']").toggle();
	};

	
	//扩展分类规则--选择分类
	function selectCategory(){
		//查找已选择行
		if(!findSelectedRow(true)){
			return;
		}else{
			var _KNOWLEDGE = "com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc";
			var _MULIDOC = "com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge";
			var _WIKI = "com.landray.kmss.kms.wiki.model.KmsWikiMain";
			moduleKey = moduleKey.replace(_MULIDOC,_KNOWLEDGE).replace(_WIKI,_KNOWLEDGE);
		}
		
		//选择分类
		Dialog_Tree(false,null,null,null,
				'kmsIntegralCategroyListService&moduleKey='+moduleKey,
				'<bean:message bundle="kms-integral" key="table.kmsIntegralRule" />',null,addRowAfter,
				null,null,null,'<bean:message bundle="kms-integral" key="kmsIntegralRule.selectCategory.select" />');
	};

	//获得选择的行
	function findSelectedRow(isCheckSameModule){
		selectedRows = [];
		moduleKey = null;
		var isSameModule = false;
		$("input[name='List_Selected']:checked").each(function(){
			selectedRows.push(this.value);
			if(isCheckSameModule && moduleKey && this.nextElementSibling.value != moduleKey){
				isSameModule = true;
			}
			moduleKey = this.nextElementSibling.value||this.nextElementSibling.nextElementSibling.value;
		});
		//
		if(isSameModule){
			alert('<bean:message bundle="kms-integral" key="kmsIntegralRule.isCheckSameModule.msg" />');
			return;
		}
		
		if(!selectedRows || selectedRows.length==0){
			alert('<bean:message bundle="kms-integral" key="kmsIntegralRule.extendCategoryRule.msg" />');
			return;
		}
		return selectedRows;
	}
	
	//通知
	function addRowAfter(dat){
		if(!dat) {
			return ;
		}
		var data = dat.GetHashMapArray();
		for (var i = 0; i < selectedRows.length; i ++) {
			var tr = $("tr#"+selectedRows[i]);
			var fieldValues = new Object();
			fieldValues["integralRules[!{index}].fdOperateName"] = tr[0].children[0].children[1].value;
			fieldValues["integralRules[!{index}].fdExpValue"] = tr[0].children[1].children[0].value;
			fieldValues["integralRules[!{index}].fdRichesValue"] = tr[0].children[2].children[0].value;
			fieldValues["integralRules[!{index}].fdObjectExpValue"] = tr[0].children[3].children[0].value;
			fieldValues["integralRules[!{index}].fdObjectRichesValue"] = tr[0].children[4].children[0].value;
			fieldValues["integralRules[!{index}].attribute"] = tr.attr("id");
			//fieldValues["integralRules[!{index}].fdModelName"] = tr.attr("id");
			fieldValues["integralRules[!{index}].fdName"] = tr.attr("title");
			fieldValues["integralRules[!{index}].fdCategoryName"] = data[0].name;
			fieldValues["integralRules[!{index}].fdCategoryId"] = data[0].id;
			var row = DocList_AddRow("TABLE_DocList", null, fieldValues);
			$(row).attr("title",tr.attr("title"));
			$(row).attr("KMSS_IsContentRow","1");
			$(row).attr("id",tr.attr("id"));
			$("input[name='fdDisplayModel']").each(function(){
				if((this.value=="one"|| this.value=="other" )&& this.checked){
					$(".displayInLine").css("display","none");
				}
			});
		}
		Com_Submit(document.kmsIntegralRulesForm, 'update');
	};

	function importRule(){
		var url='<c:url value="../../integral/kms_integral_rule/kmsIntegralRule.do?method=importRule" />';
		Dialog_PopupWindow(url,700,550);
		//Com_Submit(document.kmsIntegralRulesForm, 'importRule')
	}
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>
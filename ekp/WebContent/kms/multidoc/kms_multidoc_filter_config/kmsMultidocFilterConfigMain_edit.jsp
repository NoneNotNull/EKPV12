<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<kmss:windowTitle
	subject="${kmsMultidocFilterConfigMainForm.fdName}"
	subjectKey="sys-property:table.sysPropertyTemplate"
	moduleKey="sys-property:module.sys.property" />
<script>
Com_IncludeFile("jquery.js");
</script>
<script>
function confirmDelete(msg){
	var del = confirm('<bean:message key="page.comfirmDelete"/>');
	return del;
}
Com_IncludeFile("dialog.js|doclist.js");
function sysPropGetSelectedIds(tb, ref) {
	var ids = [];
	var table = document.getElementById(tb);
	var inputs = table.getElementsByTagName('input');
	for (var i = 0; i < inputs.length; i++){
		if (inputs[i].ref == ref) {
			ids.push(inputs[i].value);
		}
	}
	return ids;
}
function sysPropAddRow(tb, ref, beanData, title, action){
	var dialog = new KMSSDialog();
	var lang = {
		optList: '<bean:message key="dialog.optList"/>',
		selList: '<bean:message key="dialog.selList"/>',
		add: '<bean:message key="dialog.add"/>',
		del: '<bean:message key="dialog.delete"/>',
		addAll: '<bean:message key="dialog.addAll"/>',
		delAll: '<bean:message key="dialog.deleteAll"/>',
		moveUp: '<bean:message key="dialog.moveUp"/>',
		moveDown: '<bean:message key="dialog.moveDown"/>',
		ok: '<bean:message key="button.ok"/>',
		cancel: '<bean:message key="button.cancel"/>'
	};
	if(title){
		lang.title = title;
	}
	dialog.Lang = lang;
	dialog.Window = window;
	dialog.SetAfterShow(action);
	dialog.URL = "dialog.html";
	dialog.exceptValue = sysPropGetSelectedIds(tb, ref);
	dialog.beanData = beanData;
	dialog.Show(550, 480);
}
 
function sysPropFilterAddRowAfter(dat) {
	if(dat) {
		var data = dat.GetHashMapArray();
		for (var i = 0; i < data.length; i ++) {
			var fieldValues = new Object();
			fieldValues["fdFilterForms[!{index}].fdFilterSettingId"] = data[i].id;
			fieldValues["fdFilterForms[!{index}].fdFilterSettingName"] = data[i].name;
			fieldValues["fdFilterForms[!{index}].fdName"] = data[i].name;
			//fieldValues["fdFilterForms[!{index}].fdOrder"] = i+1; 
			DocList_AddRow("TABLE_FilterList", null, fieldValues);
		}
	}
}
function sysPropFilterAddRow() {
	//var defIds = sysPropGetSelectedIds("TABLE_DocList", "fdDefineId").join(";");
	//Dialog_TreeList(true, null, null, null, 
			//"sysPropertyFilterListService&fdType=define&fdParentId=!{value}&fdModelName=${sysPropertyTemplateForm.fdModelName}&fdDefineIds=" + defIds, 
			//'<bean:message bundle="sys-property" key="sysPropertyFilterSetting.fdDefine" />', 
			//"sysPropertyFilterListService&fdType=filter&fdParentId=!{value}&fdModelName=${sysPropertyTemplateForm.fdModelName}", 
			//sysPropFilterAddRowAfter, null,null, null, null, '<bean:message bundle="sys-property" key="table.sysPropertyFilter" />');
	Dialog_Tree(true, null, null, null, 
			"kmsMultidocFilterListService&filterBean=!{value}", 
			'<bean:message bundle="sys-property" key="sysPropertyFilterSetting.fdDefine" />', 
			null, sysPropFilterAddRowAfter, null, null, null, '<bean:message bundle="sys-property" key="table.sysPropertyFilter" />');
}
function validateConfigMainData(thisObj) {
 	var flag=true ;
	var tb = document.getElementById("TABLE_FilterList");
	 
	// 设置序号 
	 for(j=1;j< tb.rows.length;j++){
		var fs= tb.rows[j].getElementsByTagName("input");
		for(var k=0; k < fs.length; k++){
			var fieldName = fs[k].name.replace(/\d+/g, "!{index}");
			if(fieldName == "fdFilterForms[!{index}].fdOrder") {
				fs[k].value=j  ;
			}
		}
	  }

	var fields = tb.getElementsByTagName("input");
	for(var i=0; i < fields.length; i++){
		var fieldName = fields[i].name.replace(/\d+/g, "!{index}");
		if(fieldName == "fdFilterForms[!{index}].fdId") {
			flag=false;
		}
	}
	if(flag){
		alert('<bean:message bundle="kms-multidoc" key="kmsMultidocFilterConfigMain.required" />');<%--至少选择引用一项属性！--%>
		return false;
	}else
		return true ;
}
 
 
</script>
<html:form action="/kms/multidoc/kms_multidoc_filter_config/kmsMultidocFilterConfigMain.do"  onsubmit="return validateConfigMainData(this);" >
<div id="optBarDiv">
	<c:if test="${kmsMultidocFilterConfigMainForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.kmsMultidocFilterConfigMainForm, 'update');">
	</c:if>
	<c:if test="${kmsMultidocFilterConfigMainForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.kmsMultidocFilterConfigMainForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.kmsMultidocFilterConfigMainForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message bundle="kms-multidoc" key="table.kmsMultidocFilterConfigMain" /></p>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-property" key="sysPropertyTemplate.fdName"/>
		</td><td   width="35%">
			<xform:text property="fdName" style="width:85%" required="true"  />
		</td>
		<td class="td_normal_title" width=15%>
				<bean:message bundle="kms-multidoc" key="kmsMultidocFilterConfigMain.fdOrder" />
		</td><td  width="35%">
			<xform:text property="fdOrder" style="width:85%" required="true"  validators="digits"/>
		</td>
	</tr>
 <tr>
		<td class="td_normal_title" width=15%>
				<bean:message bundle="kms-multidoc" key="kmsMultidocFilterConfigMain.fdRemark" />
		</td><td   width="35%">
			<xform:text property="fdRemark" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-property" key="sysPropertyFilterSetting.fdIsEnabled"/>
		</td><td   >
			<xform:radio property="fdIsEnabled">
				<xform:enumsDataSource enumsType="common_yesno_property" />
			</xform:radio>
		</td>
	</tr>  
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-property" key="table.sysPropertyFilter"/>
		</td><td colspan="3" width="85%">
			<table class="tb_normal" width=100% id="TABLE_FilterList">
				<tr align="center">
					  <td class="td_normal_title" width="5%">
						 序号
					</td>
					<td class="td_normal_title" width="36%">
						<bean:message bundle="sys-property" key="sysPropertyFilter.fdFilterSetting"/>
					</td>
					<td class="td_normal_title" width="36%">
						<bean:message bundle="sys-property" key="sysPropertyFilter.fdName"/>
					</td>
					<td class="td_normal_title" align="center" width=23%>
						<img src="${KMSS_Parameter_StylePath}icons/add.gif" onclick="sysPropFilterAddRow();" style="cursor:pointer;" />
					</td>
				</tr>
				<tr KMSS_IsReferRow="1" style="display:none">
				 <td KMSS_IsRowIndex="1">  							
		         </td>
					<td>
					    <input type="hidden" name="fdFilterForms[!{index}].fdOrder" />
						<input type="hidden" name="fdFilterForms[!{index}].fdId" />
						<input type="hidden" name="fdFilterForms[!{index}].fdMainId" value="${param.fdId}" />
						<input type="hidden" name="fdFilterForms[!{index}].fdFilterSettingId" ref="fdFilterSettingId" />
				 
					    <xform:text property="fdFilterForms[!{index}].fdFilterSettingName" style="border:0px; color:black;width:95%;" showStatus="readOnly" />
					</td>
					<td>
						<xform:text property="fdFilterForms[!{index}].fdName" style="width:95%" required="true" />
					</td>
					<td>
					   <center>
							<img src="${KMSS_Parameter_StylePath}icons/up.gif" onclick="DocList_MoveRow(-1);" style="cursor:pointer;">
							<img src="${KMSS_Parameter_StylePath}icons/down.gif" onclick="DocList_MoveRow(1);" style="cursor:pointer;">
							<img src="${KMSS_Parameter_StylePath}icons/delete.gif" onclick="DocList_DeleteRow();" style="cursor:pointer;">
						</center>
					</td>
				</tr>
				<c:forEach items="${kmsMultidocFilterConfigMainForm.fdFilterForms}" var="sysPropertyFilterForm" varStatus="vstatus">
					<tr KMSS_IsContentRow="1">
					<td >  ${vstatus.index + 1 }   
					</td>
						<td>
							<input type="hidden" name="fdFilterForms[${vstatus.index}].fdId" value="${sysPropertyFilterForm.fdId}" />
							<input type="hidden" name="fdFilterForms[${vstatus.index}].fdMainId" value="${sysPropertyFilterForm.fdMainId}" />
							<input type="hidden" name="fdFilterForms[${vstatus.index}].fdFilterSettingId" value="${sysPropertyFilterForm.fdFilterSettingId}" ref="fdFilterSettingId" />
						    <input type="hidden" name="fdFilterForms[${vstatus.index}].fdOrder"  />
						     
						    <xform:text property="fdFilterForms[${vstatus.index}].fdFilterSettingName" style="border:0px; color:black;width:95%;" showStatus="readOnly" />
						</td>
						<td>
							<xform:text property="fdFilterForms[${vstatus.index}].fdName" style="width:95%" required="true" />
						</td>
						<td>
						   <center>
								<img src="${KMSS_Parameter_StylePath}icons/up.gif" onclick="DocList_MoveRow(-1);" style="cursor:pointer;">
								<img src="${KMSS_Parameter_StylePath}icons/down.gif" onclick="DocList_MoveRow(1);" style="cursor:pointer;">
								<img src="${KMSS_Parameter_StylePath}icons/delete.gif" onclick="DocList_DeleteRow();" style="cursor:pointer;">
							</center>
						</td>
					</tr>						
				</c:forEach>
			</table>
			 
		</td>
	</tr>
	
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-property" key="sysPropertyTemplate.docCreator"/>
		</td><td width="35%">
			<xform:address propertyId="docCreatorId" propertyName="docCreatorName" orgType="ORG_TYPE_PERSON" showStatus="view" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-property" key="sysPropertyTemplate.docCreateTime"/>
		</td><td width="35%">
			<xform:datetime property="docCreateTime" showStatus="view" />
		</td>
	</tr>
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<html:hidden property="docCreateTime" />
<html:hidden property="docCreatorId" />
 
<script>
	DocList_Info.push("TABLE_FilterList");
   // $KMSSValidation();
</script>
</html:form> 
<%@ include file="/resource/jsp/edit_down.jsp"%>
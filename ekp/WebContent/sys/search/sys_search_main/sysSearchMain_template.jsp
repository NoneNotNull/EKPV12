<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.sys.search.forms.SysSearchMainForm"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>

<html:form action="/sys/search/sys_search_main/sysSearchMain.do" onsubmit="return validateSysSearchMainForm(this);">
<div id="optBarDiv">
	<input type=button value="<bean:message bundle="sys-search" key="search.btn.nextToParam"/>"
		onclick="submitForm('editParam');">
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message  bundle="sys-search" key="table.sysSearchMain"/><bean:message key="button.edit"/></p>
<center>
<html:hidden property="fdId"/>
<html:hidden property="fdModelName"/>
<html:hidden property="fdKey"/>
<html:hidden property="fdCondition" />
<html:hidden property="fdDisplay" />
<html:hidden property="fdOrderBy" />
<html:hidden property="fdParameters"/>
<table class="tb_normal" width="600px">
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-search" key="sysSearchMain.fdName"/>
		</td>
		<td>
			<html:text property="fdName" style="width:90%"/>
			<span class="txtstrong">*</span>
		</td>
	</tr>
	<c:if test="${sysSearchMainForm.hasCategoryLimit}">
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-search" key="sysSearchMain.fdTemplateId"/>
		</td>
		<td>
			<html:hidden property="fdTemplateId"/>
			<html:text property="fdTemplateName" readonly="true" style="width:85%" styleClass="inputSgl" />
			<a href="javascript:void(0);" onclick="selectCate();">
			<bean:message key="dialog.selectOther"/>
			</a>
		</td>
	</tr>
	</c:if>
	
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-search" key="search.hit"/>
		</td>
		<td>
		<c:if test="${sysSearchMainForm.hasCategoryLimit}">
		<p style="margin: 0 0 5px 0;"><bean:message bundle="sys-search" key="search.fdTemplate.hit"/></p>
		</c:if>
		<p style="margin: 0"><bean:message bundle="sys-search" key="search.fdParement.hit"/></p>
		</td>
	</tr>
	<%-- 搜索项 --%>
	<tr class="tr_normal_title">
		<td colspan="2">
			<bean:message  bundle="sys-search" key="sysSearchMain.fdParemNames"/>
			<html:hidden property="fdParemNames"/>
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<table class="tb_normal" width="100%">
				<tr class="tr_normal_title">
					<td><bean:message key="dialog.optList"/></td>
					<td>&nbsp;</td>
					<td><bean:message key="dialog.selList"/></td>
				</tr>
				<tr>
					<td style="width:220px">
						<select name="tmp_ParemNamesOpt" multiple="multiple" size="15" style="width:220px"
							ondblclick="Select_AddOptions('tmp_ParemNamesOpt', 'tmp_ParemNamesSel');">
							${sysSearchMainForm.optParemNamesHTML}
						</select>
					</td>
					<td>
						<center>
							<input class="btnopt" type="button" value="<bean:message key="dialog.add"/>"
								onclick="Select_AddOptions('tmp_ParemNamesOpt', 'tmp_ParemNamesSel');"><br><br>
							<input class="btnopt" type="button" value="<bean:message key="dialog.delete"/>"
								onclick="Select_DelOptions('tmp_ParemNamesSel');"><br><br>
							<input class="btnopt" type="button" value="<bean:message key="dialog.addAll"/>"
								onclick="Select_AddOptions('tmp_ParemNamesOpt', 'tmp_ParemNamesSel', true);"><br><br>
							<input class="btnopt" type="button" value="<bean:message key="dialog.deleteAll"/>"
								onclick="Select_DelOptions('tmp_ParemNamesSel', true);"><br><br>
							<input class="btnopt" type="button" value="<bean:message key="dialog.moveUp"/>"
								onclick="Select_MoveOptions('tmp_ParemNamesSel', -1);"><br><br>
							<input class="btnopt" type="button" value="<bean:message key="dialog.moveDown"/>"
								onclick="Select_MoveOptions('tmp_ParemNamesSel', 1);">
						</center>
					</td>
					<td style="width:220px">
						<select name="tmp_ParemNamesSel" multiple="multiple" size="15" style="width:220px"
							ondblclick="Select_DelOptions('tmp_ParemNamesSel');">
							${sysSearchMainForm.selParemNamesHTML}
						</select>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>

<script>
Com_IncludeFile("dialog.js|data.js|select.js");

function submitForm(method){
	
	var str = "";
	var options = document.getElementsByName("tmp_ParemNamesSel")[0].options;
	for(var i=0; i<options.length; i++)
		str += ";"+options[i].value;
	document.getElementsByName("fdParemNames")[0].value = str.substring(1);
	
	Com_Submit(document.sysSearchMainForm, method);
}
function replaceModelName(url, modelName) {
	var re = /!\{modelName\}/gi;
	url = url.replace(/!\{modelName\}/gi, modelName);
	return url;
}
function replaceCateid(url, cateid) {
	var re = /!\{cateid\}/gi;
	url = url.replace(/!\{cateid\}/gi, cateid);
	return url;
}
function replaceKey(url, key) {
	var re = /!\{key\}/gi;
	url = url.replace(/!\{key\}/gi, key);
	return url;
}

function loadDictProperties(dictBeanValue) {
	var url = dictBeanValue;
	var kmssData = new KMSSData();
	var datas = kmssData.AddBeanData(url).GetHashMapArray();

	var tmp_ParemNamesOpt = document.getElementsByName('tmp_ParemNamesOpt')[0];
	var tmp_ParemNamesSel = document.getElementsByName('tmp_ParemNamesSel')[0];
	var p = tmp_ParemNamesOpt.parentNode;

	p.removeChild(tmp_ParemNamesOpt);
	tmp_ParemNamesSel.options.length = 0;
	
	var select = '<select name="tmp_ParemNamesOpt" multiple="multiple" size="15" style="width:220px" ondblclick="Select_AddOptions(\'tmp_ParemNamesOpt\', \'tmp_ParemNamesSel\');">';
	p.innerHTML = select + datas[0].key0 + "</select>";
	tmp_ParemNamesOpt = null;
	return;
}

function selectCate() {
	var modelName = document.getElementsByName('fdModelName')[0];
	var key = document.getElementsByName('fdKey')[0];
	var dialog = new KMSSDialog(false, false);
	var treeTitle = "<bean:message bundle="sys-search" key="table.sysSearchMain"/>";
	var node = dialog.CreateTree(treeTitle);
	dialog.winTitle = treeTitle;
	node.AppendBeanData("sysSearchTemplateTree&modelName=" + modelName.value + "&key=" + key.value, null, null, false);
	dialog.notNull = false;
	dialog.BindingField('fdTemplateId', 'fdTemplateName');
	dialog.AfterShowAction = function() {
		if(dialog.rtnData == null) {
			return;
		}
		if (dialog.rtnData.GetHashMapArray().length == 0) {
			var node = {"value" : ""};
		}else {
			var node = Tree_GetNodeByID(dialog.tree.treeRoot, dialog.rtnData.GetHashMapArray()[0].nodeId);
		}

		var dictBeanValue = "sysSearchModelDictService&modelName=!{modelName}&key=!{key}&templateId=!{cateid}";

		dictBeanValue = decodeURIComponent(dictBeanValue);
		dictBeanValue = replaceModelName(dictBeanValue, modelName.value);
		dictBeanValue = replaceCateid(dictBeanValue, node.value);
		dictBeanValue = replaceKey(dictBeanValue, key.value);

		loadDictProperties(dictBeanValue);
	}
	dialog.Show();
}
</script>
<html:javascript formName="sysSearchMainForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/resource/jsp/edit_down.jsp"%>
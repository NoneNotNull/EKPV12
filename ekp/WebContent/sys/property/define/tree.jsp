<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.util.*" %>
<%@ include file="/resource/jsp/common.jsp"%>
<script>
Com_IncludeFile("jquery.js|dialog.js");
</script>
<tr>
	<td class="td_normal_title" width=15%>
		<bean:message bundle="sys-property" key="sysPropertyDefine.dataMapping"/>
	</td><td colspan="3" width="85%">
		<span id="span_multi">
		<xform:radio property="fdIsMulti"   required="true">
			<xform:simpleDataSource value="false"><bean:message bundle="sys-property" key="sysPropertyDefine.fdIsMulti.false"/></xform:simpleDataSource>
			<xform:simpleDataSource value="true"><bean:message bundle="sys-property" key="sysPropertyDefine.fdIsMulti.true"/></xform:simpleDataSource>
		</xform:radio>&nbsp;&nbsp;
		</span>
		 
	</td>
</tr>
<c:if test="${sysPropertyDefineForm.fdType == 'com.landray.kmss.sys.property.model.SysPropertyTree'}">
<tr>
	<td class="td_normal_title" width=15%>
		<bean:message bundle="sys-property" key="sysPropertyDefine.tree.dataSource"/>
	</td><td colspan="3" width="85%">
		<xform:select property="param(fd_data_source)" onValueChange="sysPropDataSourceChange"  showPleaseSelect='true' required='true' >
			<xform:customizeDataSource className="com.landray.kmss.sys.property.service.spring.SysPropertyTreeListService" />
		</xform:select>
	</td>
</tr>
</c:if>
<tr>
	<td class="td_normal_title" width=15%>
		<bean:message bundle="sys-property" key="sysPropertyDefine.fdDefaultValue"/>
	</td><td colspan="3" width="85%">
		<span id="tree_defaultvalue">
		<xform:editShow>
			<xform:text property="param(fd_default_value)" style="width:85%" />
		</xform:editShow>
		<xform:viewShow>
			<xform:text property="param(fd_default_value_name)" style="width:85%" />
		</xform:viewShow>
		</span>
		<xform:text property="param(fd_dialog_js)" showStatus="noShow" value="${defineMap['param']}" />
	</td>
</tr>
<script>
function sysPropTreeDefalutValueChange(clear) {
	var val = $("input[name='fdDisplayType'][checked]").val();
	if("tree" == val){
		//var multi = $("input[name='fdIsMulti'][checked]").val();
		$("#tree_defaultvalue").html('<input type="hidden" name="param(fd_default_value)" ' + (clear ? 'value=""' : 'value="${sysPropertyDefineForm.fdParamMap["fd_default_value"]}"') + ' />'
				+ '<input class="inputsgl" name="param(fd_default_value_name)" readOnly style="width:85%" ' + (clear ? 'value=""' : 'value="${sysPropertyDefineForm.fdParamMap["fd_default_value_name"]}"') + ' />'
				+ '<a href="javascript:void(0);" onclick="sysPropShowTree();return false;"><%=ResourceUtil.getString("button.select")%></a>');
	}
}
function sysPropShowTree() {
	var treeRoot = $("select[name='param(fd_data_source)']");
	if(!(treeRoot.val())) {
		alert('<bean:message bundle="sys-property" key="sysPropertyDefine.tree.dataSource.select"/>');
		return;
	}
	var val=$("input[name='fdIsMulti'][checked]").val();
	var js = $("input[name='param(fd_dialog_js)']").val();
	js = js.replace("!{mulSelect}", val);
	js = js.replace("!{idField}", "param(fd_default_value)");
	js = js.replace("!{nameField}", "param(fd_default_value_name)");
	if(treeRoot) {
		js = js.replace("!{treeRootId}", treeRoot.val());
		js = js.replace("!{message(sys-property:sysPropertyDefine.type.tree)}", treeRoot.find("option:selected").text());
	} else {
		alert(js);
		js = js.replace("!{message(sys-property:sysPropertyDefine.type.tree)}", '<bean:message bundle="sys-property" key="sysPropertyDefine.type.tree"/>');
	}
	var customFun = new Function(js);
	customFun();
}
function sysPropMultiChange(val, obj){
	if(val==null||val==""){
		val=$("input[name='fdIsMulti'][checked]").val();
	}
	if("true"==val){
		$("#tree_fieldName").hide();
		$("#tree_table").show();
	}else{
		$("#tree_fieldName").show();
		$("#tree_table").hide();
	}
	if(obj) {
		sysPropTreeDefalutValueChange(true);
	} else {
		sysPropTreeDefalutValueChange(false);
	}
}
function sysPropDataSourceChange() {
	$("input[name='param(fd_default_value)']").attr("value", "");
	$("input[name='param(fd_default_value_name)']").attr("value", "");
}
function sysPropDataMappingUpdate() {
	if(!confirm('<bean:message bundle="sys-property" key="sysPropertyDefine.dataMapping.updateAlert"/>')) {
		return;
	}
	$("input[name='fdIsMulti']").attr("disabled", false);
	//$("input[name='fdStructureName']").attr("readOnly", false);
	// 标识是否重启hibernate session
	$("input[name='fdIsHbmChange']").attr("value", "true");
}
$(document).ready(function(){
	sysPropMultiChange("${sysPropertyDefineForm.fdIsMulti}");
	<c:if test="${sysPropertyDefineForm.method_GET=='edit'}">
	$("input[name='fdIsMulti']").attr("disabled", true);
	//$("input[name='fdStructureName']").attr("readOnly", true);
	</c:if>
});
</script>
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
<tr>
	<td class="td_normal_title" width=15%>
		<bean:message bundle="sys-property" key="sysPropertyDefine.fdOrgType"/>
	</td><td colspan="3" width="85%">
		<xform:checkbox property="param(fd_org_type)" onValueChange="sysPropAddressDefalutValueChange" subject='<%=ResourceUtil.getString("sys-property:sysPropertyDefine.fdOrgType")%>' required="true">
			<xform:simpleDataSource value="ORG_TYPE_PERSON"><bean:message bundle="sys-property" key="sysPropertyDefine.fdOrgType.person"/></xform:simpleDataSource>
			<xform:simpleDataSource value="ORG_TYPE_ORGORDEPT"><bean:message bundle="sys-property" key="sysPropertyDefine.fdOrgType.dept"/></xform:simpleDataSource>
			<xform:simpleDataSource value="ORG_TYPE_POST"><bean:message bundle="sys-property" key="sysPropertyDefine.fdOrgType.post"/></xform:simpleDataSource>
		</xform:checkbox>
	</td>
</tr>
<tr>
	<td class="td_normal_title" width=15%>
		<bean:message bundle="sys-property" key="sysPropertyDefine.fdDefaultValue"/>
	</td><td colspan="3" width="85%">
		<span id="address_defaultvalue">
		<xform:editShow>
			<xform:text property="param(fd_default_value)" style="width:85%" />
		</xform:editShow>
		<xform:viewShow>
			<xform:text property="param(fd_default_value_name)" style="width:85%" />
		</xform:viewShow>
		</span>
	</td>
</tr>
<script>
function sysPropAddressDefalutValueChange() {
	var sysPropGetCheckboxValue = function(name,split){
		if(split==null){
			split = ";";
		}
		var tmp = "";
		$("input[name="+name+"][checked]").each(function(){tmp+=split+this.value;});
		if(tmp!=""){
			tmp = tmp.substring(split.length);
		}
		return tmp;
	};
	var val = $("input[name='fdDisplayType'][checked]").val();
	if("address" == val){
		var orgType = sysPropGetCheckboxValue("_param(fd_org_type)","|");
		if(orgType!=""){
			var multi = $("input[name='fdIsMulti'][checked]").val();
			$("#address_defaultvalue").html('<input name="param(fd_default_value)" value="${sysPropertyDefineForm.fdParamMap["fd_default_value"]}" type="hidden" /><input class="inputsgl" name="param(fd_default_value_name)" value="${sysPropertyDefineForm.fdParamMap["fd_default_value_name"]}" type="text" readOnly style="width:85%" />'
					+ '<a href="#" onclick="Dialog_Address('+multi+',\'param(fd_default_value)\',\'param(fd_default_value_name)\',\';\','+orgType+');return false;"><%=ResourceUtil.getString("button.select")%></a>');
		}else{
			$("#address_defaultvalue").html('<xform:text property="param(fd_default_value)" style="width:85%" />');
		}
	}
}
function sysPropMultiChange(val){
	if(val==null||val==""){
		val=$("input[name='fdIsMulti'][checked]").val();
	}
	if("true"==val){
		$("#address_fieldName").hide();
		$("#address_table").show();
	}else{
		$("#address_fieldName").show();
		$("#address_table").hide();
	}
	sysPropAddressDefalutValueChange();
}
function sysPropDataMappingUpdate() {
	if(!confirm('<bean:message bundle="sys-property" key="sysPropertyDefine.dataMapping.updateAlert"/>')) {
		return;
	}
	// 单值、多值不能修改
	//$("input[name='fdIsMulti']").attr("disabled", false);
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
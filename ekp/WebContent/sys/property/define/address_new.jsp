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
		<bean:message bundle="sys-property" key="sysPropertyDefine.fdDefaultValue"/>
	</td><td colspan="3" width="85%">
		<span id="address_defaultvalue">
		<xform:text property="param(fd_default_value)" style="width:85%" />
		</span>
	</td>
</tr>
<script>
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
	//	$("input[name='fdStructureName']").attr("readOnly", true);
	</c:if>
});
</script>
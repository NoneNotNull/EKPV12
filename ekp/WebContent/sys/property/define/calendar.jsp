<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.util.*" %>
<%@ include file="/resource/jsp/common.jsp"%>
<script>
Com_IncludeFile("jquery.js|calendar.js");
</script>
<tr>
	<td class="td_normal_title" width=15%>
		<bean:message bundle="sys-property" key="sysPropertyDefine.dataMapping"/>
	</td><td colspan="3" width="85%">
		 
		 
	</td>
</tr>
<tr>
	<td class="td_normal_title" width=15%>
		<bean:message bundle="sys-property" key="sysPropertyDefine.fdDateType"/>
	</td><td colspan="3" width="85%">
		<xform:select property="param(fd_date_type)" showPleaseSelect="false" onValueChange="sysPropDateDefalutValueChange">
			<xform:enumsDataSource enumsType="sys_property_define_date_type" />
		</xform:select>
	</td>
</tr>
<tr>
	<td class="td_normal_title" width=15%>
		<bean:message bundle="sys-property" key="sysPropertyDefine.fdDefaultValue"/>
	</td><td colspan="3" width="85%">
		<span id="calendar_defaultvalue">
		<xform:text property="param(fd_default_value)" style="width:85%" />
		</span>
	</td>
</tr>
<script>
function sysPropDateDefalutValueChange() {
	var val = $("input[name='fdDisplayType'][checked]").val();
	if("calendar" == val){
		var dateType = $("select[name='param(fd_date_type)']").val();
		var _type = "selectDate";
		switch(dateType){
			case "Date":
				_type = "selectDate";
				break;
			case "Time":
				_type = "selectTime";
				break;
			case "DateTime":
				_type = "selectDateTime";
				break;
		}
		$("#calendar_defaultvalue").html('<input type="text" name="param(fd_default_value)" value="${sysPropertyDefineForm.fdParamMap["fd_default_value"]}" class="inputsgl" validate="maxLength(200)" subject=\'<%=ResourceUtil.getString("sys-property:sysPropertyDefine.fdDefaultValue")%>\' title=\'<%=ResourceUtil.getString("sys-property:sysPropertyDefine.fdDefaultValue")%>\' readOnly />'
			+ '<a href="javascript:void(0)" onclick="return('+_type+'(\'param(fd_default_value)\')==true);"><%=ResourceUtil.getString("button.select")%></a>');
	}
}
function sysPropDataMappingUpdate() {
	if(!confirm('<bean:message bundle="sys-property" key="sysPropertyDefine.dataMapping.updateAlert"/>')) {
		return;
	}
	$("input[name='fdStructureName']").attr("readOnly", false);
	// 标识是否重启hibernate session
	$("input[name='fdIsHbmChange']").attr("value", "true");
}
$(document).ready(function(){
	sysPropDateDefalutValueChange();
	<c:if test="${sysPropertyDefineForm.method_GET=='edit'}">
	//$("input[name='fdStructureName']").attr("readOnly", true);
	</c:if>
});
</script>
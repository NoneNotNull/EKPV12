<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.util.*" %>
<%@ include file="/resource/jsp/common.jsp"%>
<script>
Com_IncludeFile("jquery.js");
</script>
<tr>
	<td class="td_normal_title" width=15%>
		<bean:message bundle="sys-property" key="sysPropertyDefine.dataMapping"/>
	</td><td colspan="3" width="85%">
		 
		<bean:message bundle="sys-property" key="sysPropertyDefine.fdFieldLength"/>
		<xform:text property="param(fd_field_length)" style="width:100px" required="true" subject='<%=ResourceUtil.getString("sys-property:sysPropertyDefine.fdFieldLength")%>' validators="digits" />&nbsp;&nbsp;
		<bean:message bundle="sys-property" key="sysPropertyDefine.fdScale"/>
		<xform:text property="param(fd_scale)" style="width:100px" required="true" subject='<%=ResourceUtil.getString("sys-property:sysPropertyDefine.fd_scale")%>' validators="digits" />&nbsp;&nbsp;
		<c:if test="${sysPropertyDefineForm.method_GET=='edit'}">
			<input type="button" class="btnopt" value='<bean:message key="button.edit"/>' onclick="sysPropDataMappingUpdate();" />
		</c:if>
	</td>
</tr>
<tr>
	<td class="td_normal_title" width=15%>
		<bean:message bundle="sys-property" key="sysPropertyDefine.fdDefaultValue"/>
	</td><td colspan="3" width="85%">
		<xform:text property="param(fd_default_value)" style="width:85%" validators="number" onValueChange="checkDefaultValue"/>
	</td>
</tr>
<script>
function sysPropDataMappingUpdate() {
	if(!confirm('<bean:message bundle="sys-property" key="sysPropertyDefine.dataMapping.updateAlert"/>')) {
		return;
	}
	//$("input[name='fdStructureName']").attr("readOnly", false);
	$("input[name='param(fd_field_length)']").attr("readOnly", false);
	$("input[name='param(fd_scale)']").attr("readOnly", false);
	// 标识是否重启hibernate session
	$("input[name='fdIsHbmChange']").attr("value", "true");
}
<c:if test="${sysPropertyDefineForm.method_GET=='edit'}">
$(document).ready(function(){
	//$("input[name='fdStructureName']").attr("readOnly", true);
	$("input[name='param(fd_field_length)']").attr("readOnly", true);
	$("input[name='param(fd_scale)']").attr("readOnly", true);
});
</c:if>
</script>
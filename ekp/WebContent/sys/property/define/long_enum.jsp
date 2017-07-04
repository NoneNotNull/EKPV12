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
		<c:if test="${sysPropertyDefineForm.method_GET=='edit'}">
			<input type="button" class="btnopt" value='<bean:message key="button.edit"/>' onclick="sysPropDataMappingUpdate();" />
		</c:if>
	</td>
</tr>
<tr>
	<td class="td_normal_title" width=15%>
		<bean:message bundle="sys-property" key="sysPropertyDefine.fdOptions"/>
	</td><td colspan="3" width="85%">
		<bean:message bundle="sys-property" key="sysPropertyDefine.fdOptions.source"/>
		<xform:radio property="param(fd_options_source)" onValueChange="sysPropSourceChange" required="true" subject='<%=ResourceUtil.getString("sys-property:sysPropertyDefine.fdOptions.source")%>'>
			<xform:simpleDataSource value="input"><bean:message bundle="sys-property" key="sysPropertyDefine.fdOptions.source.input"/></xform:simpleDataSource>
			<xform:simpleDataSource value="sql"><bean:message bundle="sys-property" key="sysPropertyDefine.fdOptions.source.sql"/></xform:simpleDataSource>
		</xform:radio>
		<div id="div_opt_source0" <c:if test="${sysPropertyDefineForm.fdParamMap['fd_options_source'] != 'input'}">style="display:none"</c:if>>
			<xform:textarea property="param(fd_options)"   style="width:55%;height:250px;" />
			<c:if test="${sysPropertyDefineForm.method_GET!='view'}"><font style="vertical-align:top">图例</font>
				<span style="border:1px dashed black;"><img src="${KMSS_Parameter_ContextPath}sys/property/define/images/enum_sample_long.jpg" border="0"  /> </span> <br />
				<bean:message bundle="sys-property" key="sysPropertyDefine.fdOptions.source.input.note"/> 
			</c:if>
		</div>
		<div id="div_opt_source1" <c:if test="${sysPropertyDefineForm.fdParamMap['fd_options_source'] != 'sql'}">style="display:none"</c:if>>
			<bean:message bundle="sys-property" key="sysPropertyDefine.fdOptions.source.sql.dataSource"/>
			<xform:select property="param(fd_data_source)" showPleaseSelect="false">
				<xform:customizeDataSource className="com.landray.kmss.sys.property.service.spring.SysPropertyDataSource" />
			</xform:select>
			<bean:message bundle="sys-property" key="sysPropertyDefine.fdOptions.source.sql.statement"/><br />
			<xform:textarea property="param(fd_sql)"   style="width:55%;" /><br />
			<c:if test="${sysPropertyDefineForm.method_GET!='view'}">
			<bean:message bundle="sys-property" key="sysPropertyDefine.fdOptions.source.sql.example"/>
			</c:if>
		</div>
	</td>
</tr>
<tr>
	<td class="td_normal_title" width=15%>
		<bean:message bundle="sys-property" key="sysPropertyDefine.fdDefaultValue"/>
	</td><td colspan="3" width="85%">
		<xform:text property="param(fd_default_value)" style="width:85%" validators="digits" onValueChange="checkDefaultValue"/>
	</td>
</tr>
<script>
function sysPropSourceChange(val, ele){
	if("input"==val){
		$("#div_opt_source0").show();
		$("#div_opt_source1").hide();
	} else if("sql"==val){
		$("#div_opt_source0").hide();
		$("#div_opt_source1").show();
	}
}
function sysPropDataMappingUpdate() {
	if(!confirm('<bean:message bundle="sys-property" key="sysPropertyDefine.dataMapping.updateAlert"/>')) {
		return;
	}
	//$("input[name='fdStructureName']").attr("readOnly", false);
	$("input[name='param(fd_field_length)']").attr("readOnly", false);
	// 标识是否重启hibernate session
	$("input[name='fdIsHbmChange']").attr("value", "true");
}
<c:if test="${sysPropertyDefineForm.method_GET=='edit'}">
$(document).ready(function(){
	//$("input[name='fdStructureName']").attr("readOnly", true);
	$("input[name='param(fd_field_length)']").attr("readOnly", true);
});
</c:if>
</script>
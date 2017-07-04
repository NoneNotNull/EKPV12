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
		<bean:message bundle="sys-property" key="sysPropertyDefine.fdFieldName"/>
		att_
		<xform:text property="fdStructureName" style="width:150px" required="true" />&nbsp;&nbsp;
		<c:if test="${sysPropertyDefineForm.method_GET=='edit'}">
			<input type="button" class="btnopt" value='<bean:message key="button.edit"/>' onclick="sysPropDataMappingUpdate();" />
		</c:if>
	</td>
</tr>
<tr>
	<td class="td_normal_title" width=15%>
		依赖属性
	</td><td colspan="3" width="85%">
		<xform:text property="fdParentId" showStatus="noShow" />
		<xform:text property="fdParentName" style="width: 85%" htmlElementProperties="readOnly" />
		<xform:editShow>
		<a href="javascript:void(0);" onclick="Dialog_Tree(false,'fdParentId','fdParentName',null, 'sysPropertyDefineListService&fdId=${param.fdId}&type=com.landray.kmss.sys.property.model.SysPropertyTree&displayType=linkage', '<bean:message bundle="sys-property" key="table.sysPropertyDefine" />', null, sysPropAfterParentSel, '${param.fdId}')"><bean:message key="button.select" /></a>
		</xform:editShow>
	</td>
</tr>
<tr>
	<td class="td_normal_title" width=15%>
		<bean:message bundle="sys-property" key="sysPropertyDefine.tree.dataSource"/>
	</td><td colspan="3" width="85%">
		<span id="data_source1">
		<xform:select property="param(fd_data_source)">
			<xform:customizeDataSource className="com.landray.kmss.sys.property.service.spring.SysPropertyTreeListService" />
		</xform:select>
		</span>
		<span id="data_source2">
		数据来源来自依赖属性的数据源
		</span>
	</td>
</tr>
<script>
function sysPropAfterParentSel(data) {
	if($("input[name='fdParentId']").val() != "") {
		$("select[name='param(fd_data_source)']").attr("value", "");
		$("#data_source1").hide();
		$("#data_source2").show();
	} else {
		$("#data_source1").show();
		$("#data_source2").hide();
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
	sysPropAfterParentSel();
	<c:if test="${sysPropertyDefineForm.method_GET=='edit'}">
	$("input[name='fdStructureName']").attr("readOnly", true);
	</c:if>
});
</script>
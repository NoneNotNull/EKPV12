<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ page import="com.landray.kmss.sys.authorization.util.LicenseUtil" %>
<%
int areaLimit = LicenseUtil.getAreaLicence();
if(areaLimit == -1 || areaLimit > 0) {
%>
<script>
Com_IncludeFile("doclist.js|dialog.js|common.js|jquery.js");
</script>
<script type="text/javascript">
function init() {
	config_area_open();
	areaField = document.getElementsByName("_value(kmss.area.enabled)")[0].checked;
}

function config_area_isolation_enabled(){	
	var areaCheckbox = document.getElementsByName("_value(kmss.area.enabled)");
	var isolationRadio = document.getElementsByName("value(kmss.area.isolation.enabled)");
	var isolationType = $("#kmss.area.isolation.type");
//	var isolationTypeSuperCheckbox = document.getElementById("value(kmss.area.isolation.type.super)");
//	var isolationTypeChildCheckbox = document.getElementById("value(kmss.area.isolation.type.child)");
	if(!isolationRadio[0].checked || !areaCheckbox[0].checked){ 
		//isolationTypeSuperCheckbox.checked = false;
		//isolationTypeChildCheckbox.checked = false;
		isolationType.hide();		
	}else{
	    isolationType.show();
	}
}	
	
function config_area_open(){
	var tbObj = document.getElementById("config.area");
	var field = tbObj.rows[0].getElementsByTagName("INPUT")[0];
	for(var i=1; i<tbObj.rows.length; i++){
		tbObj.rows[i].style.display = field.checked?"":"none";
		var cfgFields = tbObj.rows[i].getElementsByTagName("INPUT");
		for(var j=0; j<cfgFields.length; j++){
			cfgFields[j].disabled = !field.checked;
		}
	}
	
	var isolationField = document.getElementsByName("value(kmss.area.isolation.enabled)");
	if(!isolationField[0].checked && !isolationField[1].checked){
		isolationField[0].checked = true;
	}

	config_area_isolation_enabled();
}

function confirmAreaOpen(checkbox){
	if(checkbox.checked && !areaField) {
		$(document.getElementById('areaTip')).text("<bean:message bundle="sys-authorization" key="area.config.open.comfirm"/>");
	} else if(!checkbox.checked && areaField) {
		$(document.getElementById('areaTip')).text("<bean:message bundle="sys-authorization" key="area.config.close.comfirm"/>");
	} else {
		$(document.getElementById('areaTip')).text("");
	}	
    
	config_area_open();
}

config_addOnloadFuncList(init);
</script>

<table class="tb_normal" width=100% id="config.area">
	<tr>
		<td class="td_normal_title" colspan=2>
				<label>
					<b>
                    <xform:checkbox property="value(kmss.area.enabled)" onValueChange="confirmAreaOpen(this)" showStatus="edit">
						<xform:simpleDataSource value="true">启用集团分级授权</xform:simpleDataSource>
					</xform:checkbox>
                    </b>
					<label id="areaTip" style="color:red;"></label>
				</label>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">场所间数据隔离</td>
		<td>
			<xform:radio property="value(kmss.area.isolation.enabled)" subject="场所间数据隔离" onValueChange="config_area_isolation_enabled();" showStatus="edit">
				<xform:simpleDataSource value="true">是</xform:simpleDataSource>
				<xform:simpleDataSource value="false">否</xform:simpleDataSource>
			</xform:radio>
		</td>
	</tr>
	<tr style="display:none" id="kmss.area.isolation.type">
		<td class="td_normal_title" width="15%">隔离选项</td>
		<td>
			<xform:checkbox property="value(kmss.area.isolation.type.self)" subject="对本场所的数据可见" value="true" dataType="boolean" showStatus="view">
				<xform:simpleDataSource value="true">对本场所的数据可见</xform:simpleDataSource>
			</xform:checkbox>&nbsp;
			<xform:checkbox property="value(kmss.area.isolation.type.super)" subject="对上级场所的数据可见" dataType="boolean" htmlElementProperties="id=\"value(kmss.area.isolation.type.super)\"" showStatus="edit">
				<xform:simpleDataSource value="true">对上级场所的数据可见</xform:simpleDataSource>
			</xform:checkbox>&nbsp;
			<xform:checkbox property="value(kmss.area.isolation.type.child)" subject="对下级场所的数据可见"  dataType="boolean" htmlElementProperties="id=\"value(kmss.area.isolation.type.child)\"" showStatus="edit">
				<xform:simpleDataSource value="true">对下级场所的数据可见</xform:simpleDataSource>
			</xform:checkbox><br>
			&nbsp;&nbsp;<span class="message">说明：某些特定数据（如分类）的隔离不受此项控制</span>			
		</td>
	</tr>
</table>
<% } %>
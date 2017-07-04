<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script>
Com_IncludeFile("doclist.js|dialog.js|jquery.js");
</script>
<script type="text/javascript">
function init() {
	config_oas_open();
	oasField = document.getElementsByName("_value(kmss.oas.enabled)")[0].checked;
}

function config_oas_open(){
	var tbObj = document.getElementById("config.oas");
	var field = tbObj.rows[0].getElementsByTagName("INPUT")[0];
	for(var i=1; i<tbObj.rows.length; i++){
		tbObj.rows[i].style.display = field.checked?"":"none";
		var cfgFields = tbObj.rows[i].getElementsByTagName("INPUT");
		for(var j=0; j<cfgFields.length; j++){
			cfgFields[j].disabled = !field.checked;
		}
	}

	field = document.getElementsByName("value(kmss.sync.area.org)");
	if(!field[0].checked && !field[1].checked){
		field[1].checked = true;
	}

	field = document.getElementsByName("value(kmss.sync.area.dept)");
	if(field[0].value==""){
		field[0].value="0";
	}

	field = document.getElementsByName("value(kmss.sync.area.admin)");
	if(!field[0].checked && !field[1].checked){
		field[0].checked = true;
	}

	field = document.getElementsByName("value(kmss.sync.area.visitor)");
	if(!field[0].checked && !field[1].checked){
		field[1].checked = true;
	}	
}

function confirmOasOpen(checkbox){
	if(checkbox.checked && !oasField) {
		$(document.getElementById('oasTip')).text("<bean:message bundle="sys-authorization" key="oas.open.comfirm"/>");
	} else if(!checkbox.checked && oasField) {
		$(document.getElementById('oasTip')).text("<bean:message bundle="sys-authorization" key="oas.close.comfirm"/>");
	} else {
		$(document.getElementById('oasTip')).text("");
	}	

	config_oas_open();
}

config_addOnloadFuncList(init);
</script>
<table class="tb_normal" width=100% id="config.oas">
	<tr>
		<td class="td_normal_title" colspan=2>
				<label>
					<b>
                    <xform:checkbox property="value(kmss.oas.enabled)" onValueChange="confirmOasOpen(this)" showStatus="edit">
						<xform:simpleDataSource value="true">启用组织场所同步（仅在开启用集团分级授权时生效）</xform:simpleDataSource>
					</xform:checkbox>
                    </b>
					<label id="oasTip" style="color:red;"></label>
				</label>					
		</td>
	</tr>
	<tr style="display:none" id="kmss.sync.area.org">
		<td class="td_normal_title" width="15%">机构同步</td>
		<td>
			<xform:radio property="value(kmss.sync.area.org)" subject="机构同步" showStatus="edit">
				<xform:simpleDataSource value="0">平级</xform:simpleDataSource>
				<xform:simpleDataSource value="1">层级</xform:simpleDataSource>
			</xform:radio>
		</td>
	</tr>	
	<tr style="display:none" id="kmss.sync.area.dept">
		<td class="td_normal_title" width="15%">部门同步</td>
		<td>
			同步<xform:text property="value(kmss.sync.area.dept)" subject="部门同步" validators="required number" required="true"  style="width:50px" showStatus="edit" />级<br>
			<span class="message">在创建机构下的第一级到指定级别的部门时，为每个部门自动创建对应的场所。</span>
		</td>
	</tr>	
	<tr style="display:none" id="kmss.sync.area.admin">
		<td class="td_normal_title" width="15%">管理员同步</td>
		<td>
			<xform:radio property="value(kmss.sync.area.admin)" subject="管理员同步" showStatus="edit">
				<xform:simpleDataSource value="true">是</xform:simpleDataSource>
				<xform:simpleDataSource value="false">否</xform:simpleDataSource>
			</xform:radio>
		</td>
	</tr>		
	<tr style="display:none" id="kmss.sync.area.visitor">
		<td class="td_normal_title" width="15%">场所漫游同步</td>
		<td>
			<xform:radio property="value(kmss.sync.area.visitor)" subject="场所漫游同步" showStatus="edit">
				<xform:simpleDataSource value="true">所属组织的直属用户</xform:simpleDataSource>
				<xform:simpleDataSource value="false">所属组织的全部用户</xform:simpleDataSource>
			</xform:radio>
		</td>
	</tr>			
		
</table>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
Com_IncludeFile("dialog.js|jquery.js");
</script>
<script type="text/javascript">
function selectOrgs(){
	var fields = document.getElementsByName("fdIsMultiple");
	var multi = fields[0].checked;
	var selectType = 0;
	fields = document.getElementsByName("fdOrgType");
	for(var i=0; i<fields.length; i++){
		if(fields[i].checked)
			selectType |= parseInt(fields[i].value);
	}
	Dialog_Address(multi, 'fdOrgIds', 'fdOrgNames', ';', selectType);
}
function startCalculate(){
	var orgIds = document.getElementsByName("fdOrgIds")[0].value;
	if(orgIds==""){
		alert("<bean:message bundle="sys-organization" key="sysOrgRoleConf.simulator.orgListNotNull"/>");
		return;
	}
	$(TD_Result).text("");
	var kmssdata = new KMSSData();
	kmssdata.AddHashMap({orgIds:orgIds, userId:document.getElementsByName("fdUserId")[0].value});
	kmssdata.SendToBean("sysOrgRoleSimulator", function(rtnData){
		if(rtnData==null)
			return;
		var rtnVal = rtnData.GetHashMapArray();
		if(rtnVal.length==0)
			return;
		$(TD_Result).html(rtnVal[0].message);
	});
}
</script>
<div id="optBarDiv">
	<input type="button" value="<bean:message bundle="sys-organization" key="sysOrgRoleConf.simulator.calculate"/>"
		onclick="startCalculate();">
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="sys-organization" key="sysOrgRoleConf.simulator.title"/></p>

<center>
<table class="tb_normal" width=85%>
	<tr>
		<td class="td_normal_title" width=20%>
			<bean:message bundle="sys-organization" key="sysOrgRoleConf.simulator.orgList"/>
		</td><td width=80%>
			<input name="fdOrgIds" type="hidden">
			<textarea name="fdOrgNames" class="inputmul" readonly style="width:100%"></textarea><br>
			<label><input type="checkbox" name="fdIsMultiple" value="1" checked/><bean:message  bundle="sys-organization" key="sysOrgRole.fdIsMultiple"/></label>
			<label><input type="checkbox" name="fdOrgType" value="1" checked/><bean:message  bundle="sys-organization" key="sysOrgElement.org"/></label>
			<label><input type="checkbox" name="fdOrgType" value="2" checked/><bean:message  bundle="sys-organization" key="sysOrgElement.dept"/></label>
			<label><input type="checkbox" name="fdOrgType" value="4" checked/><bean:message  bundle="sys-organization" key="sysOrgElement.post"/></label>
			<label><input type="checkbox" name="fdOrgType" value="8" checked/><bean:message  bundle="sys-organization" key="sysOrgElement.person"/></label>
			<label><input type="checkbox" name="fdOrgType" value="16" checked/><bean:message  bundle="sys-organization" key="sysOrgElement.group"/></label>
			<label><input type="checkbox" name="fdOrgType" value="32" checked/><bean:message  bundle="sys-organization" key="table.common.sysOrgRole"/></label>
			<a href="#" onclick="selectOrgs();">
				<bean:message key="dialog.selectOrg"/>
			</a>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=20%>
			<bean:message  bundle="sys-organization" key="sysOrgRoleConf.simulator.user"/>
		</td><td width=80%>
			<input name="fdUserId" type="hidden" value="<%= UserUtil.getUser().getFdId() %>">
			<input name="fdUserName" class="inputsgl" readonly value="<%= UserUtil.getUser().getFdName() %>">
			<a href="#" onclick="Dialog_Address(false, 'fdUserId', 'fdUserName', ';', ORG_TYPE_ALL, null, null, null, true);">
				<bean:message key="dialog.selectOrg"/>
			</a>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=20%>
			<bean:message bundle="sys-organization" key="sysOrgRoleConf.simulator.result"/>
		</td><td width=80% id="TD_Result"></td>
	</tr>
	<tr>
		<td class="td_normal_title" width=20%>
			<bean:message bundle="sys-organization" key="sysOrgRoleConf.simulator.help"/>
		</td><td width=80%>
			<bean:message  bundle="sys-organization" key="sysOrgRoleConf.simulator.help.text1"/><br><br>
			<bean:message  bundle="sys-organization" key="sysOrgRoleConf.simulator.help.text2"/><br><br>
			<bean:message  bundle="sys-organization" key="sysOrgRoleConf.simulator.help.text3"/><br>
			1）<bean:message bundle="sys-organization" key="sysOrgRole.common.location.person"/><br>
			<bean:message  bundle="sys-organization" key="sysOrgRoleConf.simulator.help.text4"/><br>
			<bean:message  bundle="sys-organization" key="sysOrgRoleConf.simulator.help.text5"/><br>
			2）<bean:message bundle="sys-organization" key="sysOrgRole.common.location.dept"/><br>
			<bean:message  bundle="sys-organization" key="sysOrgRoleConf.simulator.help.text6"/><br>
			<bean:message  bundle="sys-organization" key="sysOrgRoleConf.simulator.help.text7"/><br>
			<bean:message  bundle="sys-organization" key="sysOrgRoleConf.simulator.help.text8"/>
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
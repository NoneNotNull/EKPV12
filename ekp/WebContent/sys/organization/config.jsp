<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script>
Com_IncludeFile("doclist.js|dialog.js");
</script>
<script type="text/javascript">
function config_org_openOrg(){
	var isNotDisplayIdsEnabled = document.getElementsByName("value(kmss.org.isNotDisplayIdsEnabled)")[0];	
	var notDisplayIds = document.getElementsByName("value(kmss.org.notDisplayIds)")[0];
	notDisplayIds.disabled = !isNotDisplayIdsEnabled.checked;
	if (notDisplayIds.disabled) KMSSValidation_HideWarnHint(notDisplayIds);
}
function config_org_checkOrg(){
	var keepGroupUnique =  document.getElementsByName("value(kmss.org.keepGroupUnique)")[0];
	if(keepGroupUnique.value != "true"){
		keepGroupUnique.value = "false";
	}
	return true;
}
function config_org_checkAddrConfig(){
	var addrBookMyDeptNavigateTo =  document.getElementsByName("value(kmss.org.addrBookMyDeptNavigateTo)")[0];
	if(addrBookMyDeptNavigateTo.value != ""){
		var r = /^-?\d+$/;
		if(!r.test(addrBookMyDeptNavigateTo.value)){
				alert("地址本配置，我的部门默认目录树根节点定位到当前用户所在部门的第几级单位  必须为整数！");
				return false;
			}
	}
	var addrBookMyDeptExpandDef =  document.getElementsByName("value(kmss.org.addrBookMyDeptExpandDef)")[0];
	if(addrBookMyDeptExpandDef.value != ""){
		var r1 = /^\d+$/;
		if(!r1.test(addrBookMyDeptExpandDef.value)){
				alert("地址本配置，我的部门目录树默认展开几级  必须为正整数！");
				return false;
			}
	}
	var addrBookOrgExpandDef =  document.getElementsByName("value(kmss.org.addrBookOrgExpandDef)")[0];
	if(addrBookOrgExpandDef.value != ""){
		var r2 = /^\d+$/;
		if(!r2.test(addrBookOrgExpandDef.value)){
				alert("地址本配置，组织架构目录树默认展开几级  必须为正整数！");
				return false;
			}
	}
	var addrBookCommonExpandDef =  document.getElementsByName("value(kmss.org.addrBookCommonExpandDef)")[0];
	if(addrBookCommonExpandDef.value != ""){
		var r3 = /^\d+$/;
		if(!r3.test(addrBookCommonExpandDef.value)){
				alert("地址本配置，常用地址本目录树默认展开几级 必须为正整数！");
				return false;
			}
	}
	return true;
}
config_addOnloadFuncList(config_org_openOrg);
config_addCheckFuncList(config_org_checkOrg);
config_addCheckFuncList(config_org_checkAddrConfig);
</script>
<table class="tb_normal" width=100%>
	<tr>
		<td class="td_normal_title" colspan=2><b>地址本配置</b></td>
	</tr>
	<tr>	
		<td class="td_normal_title" width="15%">我的部门</td>	
		<td>	
			<label>
				打开本栏时，默认目录树根节点定位到当前用户所在部门的第<xform:text property="value(kmss.org.addrBookMyDeptNavigateTo)" required="false" style="10" showStatus="edit"/>级单位<br>
				说明：该项设置中，正数是从上往下推，负数是从下往上推，为0或没设置时默认定位到本部门。<br>
				例如：“蓝凌机构/深圳蓝凌/研发中心/产品部”中的一员工在产品部，<br>
				当查看地址本中我的部门，设置为2的时候，定位到“深圳蓝凌”，<br>
				当设置为-2的时候，定位到“研发中心”。<br>
				打开本栏时，目录树默认展开<xform:text property="value(kmss.org.addrBookMyDeptExpandDef)" required="false" style="10" showStatus="edit"/>级
			</label>
		</td>
	</tr>
	<tr>	
		<td class="td_normal_title" width="15%">组织架构</td>	
		<td>	
			<label>
				打开本栏时，目录树默认展开<xform:text property="value(kmss.org.addrBookOrgExpandDef)" required="false" style="10" showStatus="edit"/>级
			</label>
		</td>
	</tr>
	<tr>	
		<td class="td_normal_title" width="15%">常用地址本</td>	
		<td>	
			<label>
				打开本栏时，目录树默认展开<xform:text property="value(kmss.org.addrBookCommonExpandDef)" required="false" style="10" showStatus="edit"/>级
			</label>
		</td>
	</tr>
	<tr>	
		<td class="td_normal_title" width="15%">是否保持组织架构\群组名唯一</td>	
		<td>	
			<label>
				<xform:checkbox property="value(kmss.org.keepGroupUnique)" showStatus="edit">
					<xform:simpleDataSource value="true">启用</xform:simpleDataSource>
				</xform:checkbox>
			</label>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">不显示的组织架构ID</td>
		<td>
			<label>
				<html:checkbox property="value(kmss.org.isNotDisplayIdsEnabled)" value="true" onclick="config_org_openOrg()"/>启用
			</label>
			<xform:text property="value(kmss.org.notDisplayIds)" subject="不显示的组织架构ID" required="true" style="width:85%" showStatus="edit" htmlElementProperties="disabled='true'"/><br>
			<span class="message">例：871;872;873，说明:id之间使用“;”分隔</span>
		</td>
	</tr>
</table>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script type="text/javascript">
Com_IncludeFile("doclist.js|dialog.js");
<!--
	function check(){
		var len = document.getElementById("TABLE_DocList").rows.length;
		var flag = true;
		for(var i=0;i<len-1;i++){
			if(document.getElementsByName("addressTypeList["+i+"].fdName")[0].value==""){
				alert("<bean:message bundle='sys-organization' key='sysOrgPersonAddressType.fdName.message.empty'/>");
				flag = false;
				break;
			}
			if(isNaN(document.getElementsByName("addressTypeList["+i+"].fdOrder")[0].value)){
				alert("<bean:message bundle='sys-organization' key='sysOrgPersonAddressType.fdOrder.message.integer'/>");
				flag = false;
				break;
			}
			if(document.getElementsByName("addressTypeList["+i+"].fdTypeMemberIds")[0].value==""){
				alert("<bean:message bundle='sys-organization' key='sysOrgPersonAddressType.fdMemberName.message.empty'/>");
				flag = false;
				break;
			}
		}
		return flag;
	}
//-->
</script>
<html:form action="/sys/organization/sys_org_person/sysOrgPerson.do" onsubmit="return check();">
<div id="optBarDiv">
	<c:if test="${sysOrgPersonForm.method_GET=='addressModify'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysOrgPersonForm, 'updateAddress');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message  bundle="sys-organization" key="table.sysOrgPersonAddressType"/></p>

<center>
<table id="TABLE_DocList" class="tb_normal" width=95%>
	<tr>
		<td width="20%" align="center" class="td_normal_title"><bean:message  bundle="sys-organization" key="sysOrgPersonAddressType.fdName"/></td>
		<td width="10%" align="center" class="td_normal_title"><bean:message  bundle="sys-organization" key="sysOrgPersonAddressType.fdOrder"/></td>
		<td width="55%" align="center" class="td_normal_title"><bean:message  bundle="sys-organization" key="sysOrgPersonAddressType.fdMemberName"/></td>
		<td width="15%" align="center" class="td_normal_title">
			<img src="../../../resource/style/default/icons/add.gif" alt="add" onclick="DocList_AddRow();" style="cursor:pointer">
		</td>
	</tr>
	<!--基准行-->
	<tr KMSS_IsReferRow="1" style="display:none">
		<input type="hidden" name="addressTypeList[!{index}].fdId">
		<td width="20%">
			<input style="width:90%" class="inputsgl" name="addressTypeList[!{index}].fdName"><span class="txtstrong">*</span>
		</td>
		<td width="10%">
			<input style="width:100%" class="inputsgl" name="addressTypeList[!{index}].fdOrder">
		</td>
		<td width="55%">
			<input type="hidden" name="addressTypeList[!{index}].fdTypeMemberIds">
			<input readonly="true" class="inputsgl" style="width:90%" name="addressTypeList[!{index}].fdTypeMemberNames">
			<a href="#" onclick="Dialog_Address(true, 'addressTypeList[!{index}].fdTypeMemberIds', 'addressTypeList[!{index}].fdTypeMemberNames', null, ORG_TYPE_ALL|64);">
				<bean:message key="dialog.selectOrg"/>
			</a>
		</td>
		<td width="15%">
			<center>
				<img src="../../../resource/style/default/icons/delete.gif" alt="del" onclick="DocList_DeleteRow();" style="cursor:pointer">&nbsp;&nbsp;
				<img src="../../../resource/style/default/icons/up.gif" alt="up" onclick="DocList_MoveRow(-1);" style="cursor:pointer">&nbsp;&nbsp;
				<img src="../../../resource/style/default/icons/down.gif" alt="down" onclick="DocList_MoveRow(1);" style="cursor:pointer">
			</center>
		</td>
	</tr>
	<!--内容行-->
	<c:forEach items="${sysOrgPersonForm.addressTypeList}" var="addressTypeList" varStatus="vstatus">
		<tr KMSS_IsContentRow="1">
			<input type="hidden" name="addressTypeList[${vstatus.index}].fdId">
			<td width="20%"><input style="width:90%" class="inputsgl" name="addressTypeList[${vstatus.index}].fdName" value="${addressTypeList.fdName }"><span class="txtstrong">*</span></td>
			<td width="10%"><input style="width:100%" class="inputsgl" name="addressTypeList[${vstatus.index}].fdOrder" value="${addressTypeList.fdOrder }"></td>
			<td width="55%">
				<input type="hidden" name="addressTypeList[${vstatus.index}].fdTypeMemberIds" value="${addressTypeList.fdTypeMemberIds }">
				<input class="inputsgl" style="width:90%" name="addressTypeList[${vstatus.index}].fdTypeMemberNames" readonly="true" value="${addressTypeList.fdTypeMemberNames }"/>
				<a href="#" onclick="Dialog_Address(true, 'addressTypeList[${vstatus.index}].fdTypeMemberIds', 'addressTypeList[${vstatus.index}].fdTypeMemberNames', null, ORG_TYPE_ALL|64);">
					<bean:message key="dialog.selectOrg"/>
				</a>
			</td>
			<td width="15%">
				<center>
					<img src="../../../resource/style/default/icons/delete.gif" alt="del" onclick="DocList_DeleteRow();" style="cursor:pointer">&nbsp;&nbsp;
					<img src="../../../resource/style/default/icons/up.gif" alt="up" onclick="DocList_MoveRow(-1);" style="cursor:pointer">&nbsp;&nbsp;
					<img src="../../../resource/style/default/icons/down.gif" alt="down" onclick="DocList_MoveRow(1);" style="cursor:pointer">
				</center>
			</td>
		</tr>
	</c:forEach>
</table>
</center>
<html:hidden property="method_GET"/>
<html:hidden property="fdId" value="${sysOrgPersonForm.fdId }"/>
<html:hidden property="fdName" value="${sysOrgPersonForm.fdName }"/>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>
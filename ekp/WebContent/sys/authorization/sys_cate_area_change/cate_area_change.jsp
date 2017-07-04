<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script language="JavaScript">
Com_IncludeFile("dialog.js");

function validateAreaChgForm(of){
	if(!validateEmpty()){
		return false;
	}
	return true;
}

function validateEmpty() {
	var authAreaId = document.getElementsByName("authAreaId")[0];
	if(authAreaId.value=="") {
		alert("<bean:message key="sysAuthArea.chg.empty" bundle="sys-authorization"/>");
		return false;
	}
	return true;
}

window.onload = function() {
	<c:if test="${not empty param.authAreaId}">
		window.close();
	</c:if>
	<c:if test="${empty param.authAreaId}">
	    Dialog_Tree(false,'authAreaId','authAreaName',';','sysAuthAreaTreeService&parentId=!{value}','<bean:message bundle="sys-authorization" key="table.sysAuthArea"/>',null,afterAreaSelect);
	</c:if>
};

function afterAreaSelect(rtnVal){
	if(rtnVal){
		var values="";
		var select = window.opener.document.getElementsByName("List_Selected");
		for(var i=0;i<select.length;i++) {
			if(select[i].checked){
				values+=select[i].value;
				values+=",";
			}
		}
		document.getElementsByName("fdIds")[0].value=values.substring(0, values.length-1); 
	}
}

</script>

<html:form action="/sys/authorization/areaChgAction.do" onsubmit="return validateAreaChgForm(this);">
	<div id="optBarDiv"><input type=button
		value="<bean:message key="button.save"/>"
		onclick="Com_Submit(document.areaChgForm, 'areaChgUpdate');"> <input
		type="button" value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();"></div>

	<p class="txttitle"><bean:message bundle="sys-authorization"
		key="sysAuthArea.chg.title" /></p>

	<center>
	<table class="tb_normal" width=80%>
		<tr>
			<td class="td_normal_title" width=20%>
			<bean:message key="sysAuthArea.chg.to" bundle="sys-authorization"/></td>
			<td>					
			<html:hidden property="authAreaId"/>
			<input type="text" name="authAreaName" style="width:60%;" class="inputsgl" readonly>
			<span class="txtstrong">*</span>&nbsp;&nbsp;
			<span style="text-decoration: underline;color:blue;cursor:pointer;"
						onclick="Dialog_Tree(false,'authAreaId','authAreaName',';','sysAuthAreaTreeService&parentId=!{value}','<bean:message bundle="sys-authorization" key="table.sysAuthArea"/>',null,afterAreaSelect);"><bean:message
						key="dialog.selectOther" /></span>					
			</td>
		</tr>
		
	    <tr>
		<td class="td_normal_title" width=10%>
			<bean:message  bundle="sys-authorization" key="sysAuthArea.chg.applyto"/>
		</td>
		<td width=90%>
			<input type="checkbox" name="thisCateCheck" checked value="true">
			<bean:message  bundle="sys-authorization" key="sysAuthArea.chg.thisCateCheck"/>
			<input type="checkbox" name="thisCateDocCheck" value="true">
			<bean:message  bundle="sys-authorization" key="sysAuthArea.chg.thisCateDocCheck"/>
			<input type="checkbox" name="thisCateChildCheck" value="true">
			<bean:message  bundle="sys-authorization" key="sysAuthArea.chg.thisCateChildCheck"/>
			<input type="checkbox" name="thisCateChildDocCheck" value="true">
			<bean:message  bundle="sys-authorization" key="sysAuthArea.chg.thisCateChildDocCheck"/>
		</td>
	    </tr>			
	</table>
	</center>
	<html:hidden property="fdIds" value="${param.fdIds}"/>
	<html:hidden property="modelName" value="${param.modelName}"/>
	<html:hidden property="mainModelName" value="${param.mainModelName}"/>
	<html:hidden property="docFkName" value="${param.docFkName}"/>
	<html:hidden property="templateName" value="${param.templateName}"/>
	<html:hidden property="categoryName" value="${param.categoryName}"/>
	<html:hidden property="method_GET" />
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>

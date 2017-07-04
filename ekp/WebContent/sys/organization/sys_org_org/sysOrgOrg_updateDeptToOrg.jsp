<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<Script>Com_IncludeFile("dialog.js");</Script>
<script type="text/javascript">
function check(){
    if (form.deptId.value==""){
      alert("<bean:message  bundle="sys-organization" key="sysOrgOrg.updateDeptToOrg.chooes"/>");
      return false;
    }
}
</script>
<p class="txttitle"><bean:message  bundle="sys-organization" key="sysOrgOrg.updateDeptToOrg"/></p>
<br>
<form name="form" onsubmit="return check()" action="sysOrgOrg.do?method=updateDeptToOrg"
	method="post">
<table align="center" class="no_normal" width="60%" >
	<tr>
		<td>
			<span class="txtstrong"><bean:message bundle="sys-organization" key="sysOrgOrg.updateDeptToOrg.warn"/></span>
		</td>
	</tr>
</table>
<br>
<table align="center" class="tb_normal" width="60%" >	
	<tr>
		<td class="td_normal_title" width="20%">
			<bean:message bundle="sys-organization" key="sysOrgOrg.updateDeptToOrg.chooes"/>
		</td>
		<td width="80%" colspan="3">
			<input type="hidden" name="deptId"/>
			<input type="text" name="deptName" style="width:90%" readonly="true" class="inputSgl"/>&nbsp;
			<a href="#" onclick="Dialog_Address(false,'deptId','deptName',';',ORG_TYPE_DEPT)">
				<bean:message key="dialog.selectOther"/></a>
			<span class="txtstrong">*</span>
		</td>
	</tr>
</table>
<p align="center">
	<input type=submit value='<bean:message bundle="sys-organization" key="sysOrgOrg.updateDeptToOrg.button"/>' class="btnopt">
</p>
</form>
<%@ include file="/resource/jsp/view_down.jsp"%>
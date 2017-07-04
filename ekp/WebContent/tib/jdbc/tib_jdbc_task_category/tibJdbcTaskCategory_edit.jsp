<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/tib/jdbc/tib_jdbc_task_category/tibJdbcTaskCategory.do">

<script type="text/javascript">
	Com_IncludeFile("dialog.js", null, "js");
	Com_IncludeFile("jquery.js");
	function saveAdd() {
		Com_Submit(document.tibJdbcTaskCategoryForm, 'saveadd');
	}
</script>

	<center>
	<table class="tb_normal" width=95%>
		<tr>
		<td class="td_normal_title" width=15%><bean:message
				bundle="tib-jdbc" key="tibJdbcTaskCategory.fdParent" /></td>
			<%-- <td width="35%"><xform:dialog
				dialogJs="wsCategoryDialog();"
				propertyId="fdParentId" propertyName="fdParentName">
			</xform:dialog> </td> --%>
			<td>
				<html:hidden property="fdParentId"/>
				<html:text property="fdParentName" readonly="true" styleClass="inputsgl" style="width:35%"/>
				<a href="#" onclick="Dialog_Tree(false, 'fdParentId', 'fdParentName', ',', 
						'tibJdbcTaskCategoryTreeService&parentId=!{value}', 
						'<bean:message key="table.tibJdbcTaskCategory" bundle="tib-jdbc"/>', 
						null, null, '${tibJdbcTaskCategoryForm.fdId}', null, null, 
						'<bean:message  bundle="tib-jdbc" key="table.tibJdbcTaskCategory"/>');">
					<bean:message key="dialog.selectOther"/>
				</a>
			</td>
			<td class="td_normal_title" width=15%><bean:message
				bundle="tib-jdbc" key="tibJdbcTaskCategory.fdName" /></td>
			<td width="35%"  id="_fdName"><xform:text property="fdName" style="width:85%" required="true"/>
			</td>
		</tr>
	<%-- <tr>
			<td class="td_normal_title" width=15%><bean:message
				bundle="tib-sys-soap-connector" key="tibSysSoapCategory.fdOrder" /></td>
			<td colspan="3" width="35%"><xform:text property="fdOrder" style="width:20%" />
			</td>
		</tr> --%>
	</table>
	</center>
	<html:hidden property="fdId" />
	<html:hidden property="method_GET" />
	<script>
	$KMSSValidation();
function wsCategoryDialog(){
	
}
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>

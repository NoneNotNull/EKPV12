<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<div id="optBarDiv">
		<kmss:auth requestURL="/km/imissive/km_imissive_unit/kmImissiveUnit.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.edit"/>"
				onclick="Com_OpenWindow('kmImissiveUnit.do?method=edit&fdId=${param.fdId}','_self');">
		</kmss:auth>
		<kmss:auth requestURL="/km/imissive/km_imissive_unit/kmImissiveUnit.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.delete"/>"
				onclick="if(!confirmDelete())return;Com_OpenWindow('kmImissiveUnit.do?method=delete&fdId=${param.fdId}','_self');">
		</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message  bundle="km-imissive" key="table.kmImissiveUnit"/></p>
<center>
<table class="tb_normal" width=95%>
		<html:hidden name="kmImissiveUnitForm" property="fdId"/>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-imissive" key="kmImissiveUnit.fdCategoryId"/>
		</td><td width=35%>
			<c:out value="${kmImissiveUnitForm.fdCategoryName}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-imissive" key="kmImissiveUnit.fdNature"/>
		</td><td width=35%>
			<sunbor:enumsShow value="${kmImissiveUnitForm.fdNature}" enumsType="kmImissiveUnit.fdNature" />
		</td>

	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-imissive" key="kmImissiveUnit.fdName"/>
		</td><td width=35%>
			<c:out value="${kmImissiveUnitForm.fdName}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-imissive" key="kmImissiveUnit.fdShortName"/>
		</td><td width=35%>
			<c:out value="${kmImissiveUnitForm.fdShortName}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-imissive" key="kmImissiveUnit.fdOrder"/>
		</td><td width=35%>
			<c:out value="${kmImissiveUnitForm.fdOrder}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-imissive" key="kmImissiveUnit.fdIsAvailable"/>
		</td><td width=35%>
			<sunbor:enumsShow value="${kmImissiveUnitForm.fdIsAvailable}" enumsType="common_yesno" />
		</td>
	</tr>
	<c:if test="${kmImissiveUnitForm.fdNature!='0'}">
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-imissive" key="kmImissiveUnit.fdSecretaryId"/>
		</td><td width=35%>
			<c:out value="${kmImissiveUnitForm.fdSecretaryNames}" />
		</td>
		<td class="td_normal_title" width=15%>
		</td><td width=35%>
		</td>
	</tr>
	</c:if>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-imissive" key="kmImissiveUnit.fdContent"/>
		</td><td width=35% colspan='3'>
			<kmss:showText value="${kmImissiveUnitForm.fdContent}"/>
		</td>
	</tr>
	<tr>
			<td class="td_normal_title" width="15%">
			  <bean:message bundle="km-imissive" key="kmImissiveUnit.areader.distribute"/>
			</td>
			<td width="85%" colspan='3'>
			 ${kmImissiveUnitForm.authReaderNamesDistribute}
			</td>
	</tr>
	<tr>
			<td class="td_normal_title" width="15%">
			  <bean:message bundle="km-imissive" key="kmImissiveUnit.areader.report"/>
			</td>
			<td width="85%" colspan='3'>
			   ${kmImissiveUnitForm.authReaderNamesReport}
			</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-imissive" key="kmImissiveUnit.docCreateId"/>
		</td><td width=35%>
			<c:out value="${kmImissiveUnitForm.docCreatorName}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-imissive" key="kmImissiveUnit.docCreateTime"/>
		</td><td width=35%>
			<c:out value="${kmImissiveUnitForm.docCreateTime}" />
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
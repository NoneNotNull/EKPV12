<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/km/keydata/supplier/km_supplier_main/kmSupplierMain.do">
<div id="optBarDiv">
	<c:if test="${kmSupplierMainForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.kmSupplierMainForm, 'update');">
	</c:if>
	<c:if test="${kmSupplierMainForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.kmSupplierMainForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.kmSupplierMainForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="km-keydata-supplier" key="table.kmSupplierMain"/></p>

<center>
<table
		id="Label_Tabel" 
		width=95%>
		<html:hidden property="fdId" />
		<tr LKS_LabelName="文档">
			<td>
<table class="tb_normal" width=100%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-supplier" key="kmSupplierMain.fdName"/>
		</td><td width="35%">
			<xform:text property="fdName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-supplier" key="kmSupplierMain.fdCode"/>
		</td><td width="35%">
			<xform:text property="fdCode" style="width:85%"  showStatus="view"/>
			<c:if test="${kmSupplierMainForm.method_GET=='add'}">
				提交后自动产生
			</c:if>
		</td>
		
	</tr>
	
	<tr>
					<td
						class="td_normal_title"
						width="15%"><bean:message bundle="km-keydata-supplier" key="kmSupplierMain.fdCategoryName"/></td>
					<td><html:hidden property="fdSupplierCategoryId" /> <bean:write
						name="kmSupplierMainForm"
						property="fdSupplierCategoryName" /></td>
						
					<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-supplier" key="kmSupplierMain.docCreator"/>
		</td><td width="35%">
			<xform:address propertyId="docCreatorId" propertyName="docCreatorName" orgType="ORG_TYPE_PERSON" showStatus="view" />
		</td>
				</tr>
				<tr>
				<td width=15% class="td_normal_title">
					<bean:message bundle="km-keydata-base" key="keydata.fdIsAvailable"/>
				</td><td width="85%" colspan="3">
					<sunbor:enums property="fdIsAvailable" enumsType="common_yesno" elementType="radio" />
				</td>
	</tr>
	<%-- 
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-supplier" key="kmSupplierMain.docCreateTime"/>
		</td><td width="35%">
			<xform:datetime property="docCreateTime" showStatus="view" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-supplier" key="kmSupplierMain.docAlterTime"/>
		</td><td width="35%">
			<xform:datetime property="docAlterTime" showStatus="view" />
		</td>
	</tr>
	--%>
	<tr>
	<td class="td_normal_title" colspan="4">
	&nbsp;
	</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-supplier" key="kmSupplierMain.fdLegal"/>
		</td><td width="35%">
			<xform:text property="fdLegal" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-supplier" key="kmSupplierMain.fdEstablishedDate"/>
		</td><td width="35%">
			<xform:datetime dateTimeType="date" property="fdEstablishedDate" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-supplier" key="kmSupplierMain.fdRegMoney"/>
		</td><td width="35%" colspan="3">
			<xform:text property="fdRegMoney" style="width:85%" />
		</td>
		
	</tr>
	<tr>
	<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-supplier" key="kmSupplierMain.fdAddress"/>
		</td><td width="35%" colspan="3">
			<xform:text property="fdAddress" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-supplier" key="kmSupplierMain.fdPost"/>
		</td><td width="35%" colspan="3">
			<xform:text property="fdPost" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-supplier" key="kmSupplierMain.fdUrl"/>
		</td><td width="35%" colspan="3">
			<xform:text property="fdUrl" style="width:85%" />
		</td>
	</tr>
	
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-supplier" key="kmSupplierMain.fdSummary"/>
		</td><td width="35%" colspan="3">
			<xform:textarea property="fdSummary" style="width:85%" />
		</td>
	</tr>
	
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-supplier" key="kmSupplierMain.fdContactPerson"/>
		</td><td width="35%">
			<xform:text property="fdContactPerson" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-supplier" key="kmSupplierMain.fdPhone"/>
		</td><td width="35%">
			<xform:text property="fdPhone" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-supplier" key="kmSupplierMain.fdEmail"/>
		</td><td width="35%">
			<xform:text property="fdEmail" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-supplier" key="kmSupplierMain.fdFax"/>
		</td><td width="35%">
			<xform:text property="fdFax" style="width:85%" />
		</td>
	</tr>
	<tr>
	<td class="td_normal_title" colspan="4">
	&nbsp;
	</td>
	</tr>
	<tr>
		
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-supplier" key="kmSupplierMain.fdAccountName"/>
		</td><td width="35%">
			<xform:text property="fdAccountName" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-supplier" key="kmSupplierMain.fdAccountBank"/>
		</td><td width="35%">
			<xform:text property="fdAccountBank" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-supplier" key="kmSupplierMain.fdAccountNo"/>
		</td><td width="35%">
			<xform:text property="fdAccountNo" style="width:85%" />
		</td>
	</tr>
	<tr>
		
	</tr>
</table>
</td>
</tr>
<tr LKS_LabelName="<bean:message bundle="sys-right" key="right.moduleName" />">
			<td>
			<table
				class="tb_normal"
				width=100%>
				<c:import
					url="/sys/right/right_edit.jsp"
					charEncoding="UTF-8">
					<c:param
						name="formName"
						value="kmSupplierMainForm" />
					<c:param
						name="moduleModelName"
						value="com.landray.kmss.km.keydata.supplier.model.KmSupplierMain" />
				</c:import>
			</table>
			</td>
		</tr>
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	$KMSSValidation();
	window.onload = function(){
		document.title="供应商";
	}
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>
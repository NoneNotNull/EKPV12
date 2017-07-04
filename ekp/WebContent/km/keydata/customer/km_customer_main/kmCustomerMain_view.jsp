<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<div id="optBarDiv">
	<kmss:auth requestURL="/km/keydata/customer/km_customer_main/kmCustomerMain.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('kmCustomerMain.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="km-keydata-customer" key="table.kmCustomerMain"/></p>

<center>
<table
	id="Label_Tabel"
	width=95%>
	<tr LKS_LabelName="文档">
		<td>
<table class="tb_normal" width=100%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-customer" key="kmCustomerMain.fdName"/>
		</td><td width="35%">
			<xform:text property="fdName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-customer" key="kmCustomerMain.docCreator"/>
		</td><td width="35%">
			<c:out value="${kmCustomerMainForm.docCreatorName}" />
		</td>
		
	</tr>
	
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-customer" key="kmCustomerMain.fdCode"/>
		</td><td width="35%" colspan="3">
			<xform:text property="fdCode" style="width:85%" />
		</td>
		
	</tr>
	
	<tr>
					<td
						class="td_normal_title"
						width="15%"><bean:message bundle="km-keydata-customer" key="kmCustomerMain.fdCategoryName"/></td>
					<td colspan="3" ><bean:write
						name="kmCustomerMainForm"
						property="fdCustomerCategoryName" /></td>
	</tr>
	<tr>			
				<td width=15% class="td_normal_title">
					<bean:message bundle="km-keydata-base" key="keydata.fdIsAvailable"/>
				</td><td width="85%" colspan="3">
					<xform:radio property="fdIsAvailable">
								<xform:enumsDataSource enumsType="common_yesno" />
					</xform:radio>
				</td>
		</tr>
		
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-customer" key="kmCustomerMain.docCreateTime"/>
		</td><td width="35%">
			<xform:datetime property="docCreateTime" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-customer" key="kmCustomerMain.docAlterTime"/>
		</td><td width="35%">
			<xform:datetime property="docAlterTime" />
		</td>
	</tr>
	
	
		
	
	
	<tr>
	<td class="td_normal_title" colspan="4">
	&nbsp;
	</td>
	</tr>
	
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-customer" key="kmCustomerMain.fdEnglishName"/>
		</td><td width="35%">
			<xform:text property="fdEnglishName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-customer" key="kmCustomerMain.fdPinyin"/>
		</td><td width="35%">
			<xform:text property="fdPinyin" style="width:85%" />
		</td>
		
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-customer" key="kmCustomerMain.fdBrief"/>
		</td><td width="35%">
			<xform:text property="fdBrief" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-customer" key="kmCustomerMain.fdPayNo"/>
		</td><td width="35%">
			<xform:text property="fdPayNo" style="width:85%" />
		</td>
		
		
	</tr>
	
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-customer" key="kmCustomerMain.fdCredit"/>
		</td><td width="35%" colspan="3">
			<xform:text property="fdCredit" style="width:85%" />
		</td>
		
	</tr>
	
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-customer" key="kmCustomerMain.fdAddress"/>
		</td><td width="35%">
			<xform:text property="fdAddress" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-customer" key="kmCustomerMain.fdPostcode"/>
		</td><td width="35%">
			<xform:text property="fdPostcode" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-customer" key="kmCustomerMain.fdUrl"/>
		</td><td width="35%" colspan="3">
			<xform:text property="fdUrl" style="width:85%" />
		</td>
		
	</tr>
	
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-customer" key="kmCustomerMain.fdPhone"/>
		</td><td width="35%">
			<xform:text property="fdPhone" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-customer" key="kmCustomerMain.fdFax"/>
		</td><td width="35%">
			<xform:text property="fdFax" style="width:85%" />
		</td>
	</tr>
	
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-customer" key="kmCustomerMain.fdDescription"/>
		</td><td width="35%" colspan="3">
			<xform:textarea property="fdDescription" style="width:85%" />
		</td>
		
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
				url="/sys/right/right_view.jsp"
				charEncoding="UTF-8">
				<c:param
					name="formName"
					value="kmCustomerMainForm" />
				<c:param
					name="moduleModelName"
					value="com.landray.kmss.km.keydata.customer.model.KmCustomerMain" />
			</c:import>
		</table>
		</td>
	</tr>
	</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
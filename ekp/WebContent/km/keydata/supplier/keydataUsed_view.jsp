<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/zone/zone.tld"
	prefix="zone"%>
<template:include file="/km/keydata/base/keydataUsedTemplate.jsp">
	<template:replace name="title">
		<bean:message bundle="km-keydata-supplier" key="table.kmSupplierMain" />
	</template:replace>
	
	<template:replace name="headerBtnGroup">
	<kmss:auth requestURL="/km/keydata/supplier/km_supplier_main/kmSupplierMain.do?method=edit&fdId=${param.fdId}">
		<li><a href="#" onclick="Com_OpenWindow('kmSupplierMain.do?method=edit&fdId=${param.fdId}','_blank');"><bean:message key="button.edit"/></a></li>
    </kmss:auth>
    <c:if test="${kmSupplierMainForm.fdIsAvailable==true}">
		<kmss:auth requestURL="/km/keydata/supplier/km_supplier_main/kmSupplierMain.do?method=updateAvailable&fdId=${param.fdId}">
			<li><a href="#" onclick="Com_OpenWindow('kmSupplierMain.do?method=updateAvailable&fdId=${param.fdId}&fdIsAvailable=false','_self');">置为无效</a></li>
		</kmss:auth>
	</c:if>
	<c:if test="${kmSupplierMainForm.fdIsAvailable==false}">
		<kmss:auth requestURL="/km/keydata/supplier/km_supplier_main/kmSupplierMain.do?method=updateAvailable&fdId=${param.fdId}">
			<li><a href="#" onclick="Com_OpenWindow('kmSupplierMain.do?method=updateAvailable&fdId=${param.fdId}&fdIsAvailable=true','_self');">置为有效</a></li>
		</kmss:auth>
	</c:if>
    <li><a href="#" onclick="Com_CloseWindow();"><bean:message key="button.close"/></a></li>
        
	</template:replace>
	
	<template:replace name="title">
		<bean:message bundle="km-keydata-supplier" key="table.kmSupplierMain" />
	</template:replace>
	
	<template:replace name="dataAttrs">
		<li>
             <span class="title"><bean:message bundle="km-keydata-base" key="keydata.fdName"/>：</span>
             <span class="txt">${kmSupplierMainForm.fdName}</span>
        </li>
        <li>
             <span class="title"><bean:message bundle="km-keydata-base" key="keydata.fdCode"/>：</span>
             <span class="txt">${kmSupplierMainForm.fdCode}</span>
        </li>
        <!-- 
        <li>
             <span class="title"><bean:message bundle="km-keydata-base" key="keydata.docCreateTime"/>：</span>
             <span class="txt">${kmSupplierMainForm.docCreateTime}</span>
        </li>
        <li>
             <span class="title"><bean:message bundle="km-keydata-base" key="keydata.docAlterTime"/>：</span>
             <span class="txt"><xform:datetime property="docCreateTime" pattern="yyyyMMdd"/></span>
        </li>
         -->
        <li>
             <span class="title"><bean:message bundle="km-keydata-base" key="keydata.docCreator"/>：</span>
             <span class="txt">${kmSupplierMainForm.docCreatorName}</span>
        </li>
        <li>
             <span class="title"><bean:message bundle="km-keydata-base" key="keydata.fdIsAvailable"/>：</span>
             <span class="txt"><xform:radio property="fdIsAvailable">
								<xform:enumsDataSource enumsType="common_yesno" />
					</xform:radio></span>
        </li>
        <li>
             <span class="title"><bean:message bundle="km-keydata-supplier" key="kmSupplierMain.fdLegal"/>：</span>
             <span class="txt"><xform:text property="fdLegal" style="width:85%" /></span>
        </li>
        <li>
             <span class="title"><bean:message bundle="km-keydata-supplier" key="kmSupplierMain.fdEstablishedDate"/>：</span>
             <span class="txt"><xform:datetime dateTimeType="date" property="fdEstablishedDate" /></span>
        </li>
        <li>
             <span class="title"><bean:message bundle="km-keydata-supplier" key="kmSupplierMain.fdRegMoney"/>：</span>
             <span class="txt"><xform:text property="fdRegMoney" style="width:85%" /></span>
        </li><li>
             <span class="title"><bean:message bundle="km-keydata-supplier" key="kmSupplierMain.fdContactPerson"/>：</span>
             <span class="txt"><xform:text property="fdContactPerson" style="width:85%" /></span>
        </li><li>
             <span class="title"><bean:message bundle="km-keydata-supplier" key="kmSupplierMain.fdPhone"/>：</span>
             <span class="txt"><xform:text property="fdPhone" style="width:85%" /></span>
        </li><li>
             <span class="title"><bean:message bundle="km-keydata-supplier" key="kmSupplierMain.fdEmail"/>：</span>
             <span class="txt"><xform:text property="fdEmail" style="width:85%" /></span>
        </li>
        <li>
             <span class="title"><bean:message bundle="km-keydata-supplier" key="kmSupplierMain.fdFax"/>：</span>
             <span class="txt"><xform:text property="fdFax" style="width:85%" /></span>
        </li>
        
	</template:replace>
	
<%-- 
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-supplier" key="kmSupplierMain.fdAddress"/>
		</td><td width="35%">
			<xform:text property="fdAddress" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-keydata-supplier" key="kmSupplierMain.fdPost"/>
		</td><td width="35%">
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
	
	 --%>

	
	
</template:include>
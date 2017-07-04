<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/zone/zone.tld"
	prefix="zone"%>
<template:include file="/km/keydata/base/keydataUsedTemplate.jsp">
	<template:replace name="title">
		<bean:message bundle="km-keydata-customer" key="table.kmCustomerMain" />
	</template:replace>
	
	<template:replace name="headerBtnGroup">
	<kmss:auth requestURL="/km/keydata/customer/km_customer_main/kmCustomerMain.do?method=edit&fdId=${param.fdId}">
		<li><a href="#" onclick="Com_OpenWindow('kmCustomerMain.do?method=edit&fdId=${param.fdId}','_blank');"><bean:message key="button.edit"/></a></li>
    </kmss:auth>
    <c:if test="${kmCustomerMainForm.fdIsAvailable==true}">
		<kmss:auth requestURL="/km/keydata/customer/km_customer_main/kmCustomerMain.do?method=updateAvailable&fdId=${param.fdId}">
			<li><a href="#" onclick="Com_OpenWindow('kmCustomerMain.do?method=updateAvailable&fdId=${param.fdId}&fdIsAvailable=false','_self');">置为无效</a></li>
		</kmss:auth>
	</c:if>
	<c:if test="${kmCustomerMainForm.fdIsAvailable==false}">
		<kmss:auth requestURL="/km/keydata/customer/km_customer_main/kmCustomerMain.do?method=updateAvailable&fdId=${param.fdId}">
			<li><a href="#" onclick="Com_OpenWindow('kmCustomerMain.do?method=updateAvailable&fdId=${param.fdId}&fdIsAvailable=true','_self');">置为有效</a></li>
		</kmss:auth>
	</c:if>
    <li><a href="#" onclick="Com_CloseWindow();"><bean:message key="button.close"/></a></li>
        
	</template:replace>
	
	<template:replace name="title">
		<bean:message bundle="km-keydata-project" key="table.kmProjectMain" />
	</template:replace>
	
	<template:replace name="dataAttrs">
		<li>
             <span class="title"><bean:message bundle="km-keydata-base" key="keydata.fdName"/>：</span>
             <span class="txt">${kmCustomerMainForm.fdName}</span>
        </li>
        <li>
             <span class="title"><bean:message bundle="km-keydata-base" key="keydata.fdCode"/>：</span>
             <span class="txt">${kmCustomerMainForm.fdCode}</span>
        </li>
        <!-- 
        <li>
             <span class="title"><bean:message bundle="km-keydata-base" key="keydata.docCreateTime"/>：</span>
             <span class="txt">${kmCustomerMainForm.docCreateTime}</span>
        </li>
        <li>
             <span class="title"><bean:message bundle="km-keydata-base" key="keydata.docAlterTime"/>：</span>
             <span class="txt"><xform:datetime property="docCreateTime" pattern="yyyyMMdd"/></span>
        </li>
         -->
        <li>
             <span class="title"><bean:message bundle="km-keydata-base" key="keydata.docCreator"/>：</span>
             <span class="txt">${kmCustomerMainForm.docCreatorName}</span>
        </li>
        <li>
             <span class="title"><bean:message bundle="km-keydata-base" key="keydata.fdIsAvailable"/>：</span>
             <span class="txt"><xform:radio property="fdIsAvailable">
								<xform:enumsDataSource enumsType="common_yesno" />
					</xform:radio></span>
        </li>
        <li>
             <span class="title"><bean:message bundle="km-keydata-customer" key="kmCustomerMain.fdEnglishName"/>：</span>
             <span class="txt"><xform:text property="fdEnglishName" style="width:85%" /></span>
        </li>
        <li>
             <span class="title"><bean:message bundle="km-keydata-customer" key="kmCustomerMain.fdPinyin"/>：</span>
             <span class="txt"><xform:text property="fdPinyin" style="width:85%" /></span>
        </li>
        <li>
             <span class="title"><bean:message bundle="km-keydata-customer" key="kmCustomerMain.fdBrief"/>：</span>
             <span class="txt"><xform:text property="fdBrief" style="width:85%" /></span>
        </li><li>
             <span class="title"><bean:message bundle="km-keydata-customer" key="kmCustomerMain.fdPayNo"/>：</span>
             <span class="txt"><xform:text property="fdPayNo" style="width:85%" /></span>
        </li><li>
             <span class="title"><bean:message bundle="km-keydata-customer" key="kmCustomerMain.fdCredit"/>：</span>
             <span class="txt"><xform:text property="fdCredit" style="width:85%" /></span>
        </li><li>
             <span class="title"><bean:message bundle="km-keydata-customer" key="kmCustomerMain.fdPostcode"/>：</span>
             <span class="txt"><xform:text property="fdPostcode" style="width:85%" /></span>
        </li><li>
             <span class="title"><bean:message bundle="km-keydata-customer" key="kmCustomerMain.fdPhone"/>：</span>
             <span class="txt"><xform:text property="fdPhone" style="width:85%" /></span>
        </li>
        <li>
             <span class="title"><bean:message bundle="km-keydata-customer" key="kmCustomerMain.fdFax"/>：</span>
             <span class="txt"><xform:text property="fdFax" style="width:85%" /></span>
        </li>
        
	</template:replace>
	
	
	
	
	
</template:include>
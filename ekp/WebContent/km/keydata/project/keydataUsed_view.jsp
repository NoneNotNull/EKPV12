<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/zone/zone.tld"
	prefix="zone"%>

<template:include file="/km/keydata/base/keydataUsedTemplate.jsp">
	<template:replace name="title">
		<bean:message bundle="km-keydata-project" key="table.kmProjectMain" />
	</template:replace>
	
	<template:replace name="headerBtnGroup">
	<kmss:auth requestURL="/km/keydata/project/km_project_main/kmProjectMain.do?method=edit&fdId=${param.fdId}">
		<li><a href="#" onclick="Com_OpenWindow('kmProjectMain.do?method=edit&fdId=${param.fdId}','_blank');"><bean:message key="button.edit"/></a></li>
    </kmss:auth>
    <c:if test="${kmProjectMainForm.fdIsAvailable==true}">
		<kmss:auth requestURL="/km/keydata/project/km_project_main/kmProjectMain.do?method=updateAvailable&fdId=${param.fdId}">
			<li><a href="#" onclick="Com_OpenWindow('kmProjectMain.do?method=updateAvailable&fdId=${param.fdId}&fdIsAvailable=false','_self');">置为无效</a></li>
		</kmss:auth>
	</c:if>
	<c:if test="${kmProjectMainForm.fdIsAvailable==false}">
		<kmss:auth requestURL="/km/keydata/project/km_project_main/kmProjectMain.do?method=updateAvailable&fdId=${param.fdId}">
			<li><a href="#" onclick="Com_OpenWindow('kmProjectMain.do?method=updateAvailable&fdId=${param.fdId}&fdIsAvailable=true','_self');">置为有效</a></li>
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
             <span class="txt">${kmProjectMainForm.fdName}</span>
        </li>
        <li>
             <span class="title"><bean:message bundle="km-keydata-base" key="keydata.fdCode"/>：</span>
             <span class="txt">${kmProjectMainForm.fdCode}</span>
        </li>
        <!-- 
        <li>
             <span class="title"><bean:message bundle="km-keydata-base" key="keydata.docCreateTime"/>：</span>
             <span class="txt">${kmProjectMainForm.docCreateTime}</span>
        </li>
        <li>
             <span class="title"><bean:message bundle="km-keydata-base" key="keydata.docAlterTime"/>：</span>
             <span class="txt"><xform:datetime property="docCreateTime" pattern="yyyyMMdd"/></span>
        </li>
         -->
        <li>
             <span class="title"><bean:message bundle="km-keydata-base" key="keydata.docCreator"/>：</span>
             <span class="txt">${kmProjectMainForm.docCreatorName}</span>
        </li>
        <li>
             <span class="title"><bean:message bundle="km-keydata-base" key="keydata.fdIsAvailable"/>：</span>
             <span class="txt"><xform:radio property="fdIsAvailable">
								<xform:enumsDataSource enumsType="common_yesno" />
					</xform:radio></span>
        </li>
        <li>
             <span class="title"><bean:message bundle="km-keydata-project" key="kmProjectMain.fdExecutiveDept"/>：</span>
             <span class="txt"><c:out value="${kmProjectMainForm.fdExecutiveDeptName}" /></span>
        </li>
        <li>
             <span class="title"><bean:message bundle="km-keydata-project" key="kmProjectMain.fdStatus"/>：</span>
             <span class="txt">
             <xform:select value="${kmProjectMain.fdStatus}" property="fdStatus" showStatus="view">
						<xform:enumsDataSource enumsType="km_keydata_project_status" />
			</xform:select>
             </span>
        </li>
        <li>
             <span class="title"><bean:message bundle="km-keydata-project" key="kmProjectMain.fdPlanStart"/>：</span>
             <span class="txt"><xform:datetime dateTimeType="date" property="fdPlanStart" /></span>
        </li><li>
             <span class="title"><bean:message bundle="km-keydata-project" key="kmProjectMain.fdPlanEnd"/>：</span>
             <span class="txt"><xform:datetime dateTimeType="date" property="fdPlanEnd" /></span>
        </li><li>
             <span class="title"><bean:message bundle="km-keydata-project" key="kmProjectMain.fdInfactStart"/>：</span>
             <span class="txt"><xform:datetime dateTimeType="date" property="fdInfactStart" /></span>
        </li><li>
             <span class="title"><bean:message bundle="km-keydata-project" key="kmProjectMain.fdInfactEnd"/>：</span>
             <span class="txt"><xform:datetime dateTimeType="date" property="fdInfactEnd" /></span>
        </li><li>
             <span class="title"><bean:message bundle="km-keydata-project" key="kmProjectMain.fdPlanDays"/>：</span>
             <span id="fdPlanDays" class="txt"><xform:text property="fdPlanDays" style="width:85%" /></span>
        </li>
        <li>
             <span class="title"><bean:message bundle="km-keydata-project" key="kmProjectMain.fdInfactDays"/>：</span>
             <span id="fdInfactDays" class="txt"><xform:text property="fdInfactDays" style="width:85%" /></span>
        </li>
        
	</template:replace>
	
	
	

	
	
</template:include>

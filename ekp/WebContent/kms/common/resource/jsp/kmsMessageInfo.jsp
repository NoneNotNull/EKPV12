<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
Com_RegisterFile(KMS.kmsResourcePath+"/jsp/"+"kmsMessageInfo.jsp");

if(typeof Kms_MessageInfo == "undefined")
	Kms_MessageInfo = new Array();
if(Kms_MessageInfo.length==0) {
	//#common.js
	Kms_MessageInfo["kms.common.search.input"]="<bean:message bundle="kms-common" key="kms.common.search.input" />";
	Kms_MessageInfo["kms.common.search.empty"]="<bean:message bundle="kms-common" key="kms.common.search.empty" />";
	Kms_MessageInfo["kms.common.logout"]="<bean:message bundle="kms-common" key="kms.common.logout" />";
	Kms_MessageInfo["kms.common.closeAlter"]="<bean:message bundle="kms-common" key="kms.common.closeAlter" />";
	Kms_MessageInfo["button.enter"]="<bean:message bundle="kms-common" key="button.enter" />";

	//#filter.js
	Kms_MessageInfo["kms.filter.caseSelect"]="<bean:message bundle="kms-common" key="kms.filter.caseSelect" />";
	Kms_MessageInfo["kms.filter.caseSelect"]="<bean:message bundle="kms-common" key="kms.filter.caseSelect" />";
	Kms_MessageInfo["kms.filter.query"]="<bean:message bundle="kms-common" key="kms.filter.query" />";
	Kms_MessageInfo["kms.filter.multiple"]="<bean:message bundle="kms-common" key="kms.filter.multiple" />";
	Kms_MessageInfo["kms.filter.onlySelect"]="<bean:message bundle="kms-common" key="kms.filter.onlySelect" />";
	Kms_MessageInfo["kms.filter.noLimit"]="<bean:message bundle="kms-common" key="kms.filter.noLimit" />";
	Kms_MessageInfo["kms.filter.more"]="<bean:message bundle="kms-common" key="kms.filter.more" />";
	Kms_MessageInfo["kms.filter.moreSelect"]="<bean:message bundle="kms-common" key="kms.filter.moreSelect" />";
	Kms_MessageInfo["kms.filter.input"]="<bean:message bundle="kms-common" key="kms.filter.input" />";
	Kms_MessageInfo["kms.filter.number"]="<bean:message bundle="kms-common" key="kms.filter.number" />";
	Kms_MessageInfo["kms.filter.enter"]="<bean:message bundle="kms-common" key="kms.filter.enter" />";
	Kms_MessageInfo["kms.filter.select"]="<bean:message bundle="kms-common" key="kms.filter.select" />";
	Kms_MessageInfo["kms.filter.folded"]="<bean:message bundle="kms-common" key="kms.filter.folded" />";
	Kms_MessageInfo["kms.filter.rightNumber"]="<bean:message bundle="kms-common" key="kms.filter.rightNumber" />";

	//#kms_navi_selector
	Kms_MessageInfo["kms.navi.noSelect"]="<bean:message bundle="kms-common" key="kms.navi.noSelect" />";
	Kms_MessageInfo["kms.navi.left"]="<bean:message bundle="kms-common" key="kms.navi.left" />";
	Kms_MessageInfo["kms.navi.right"]="<bean:message bundle="kms-common" key="kms.navi.right" />";
	Kms_MessageInfo["kms.navi.category"]="<bean:message bundle="kms-common" key="kms.navi.category" />";
	Kms_MessageInfo["kms.navi.load"]="<bean:message bundle="kms-common" key="kms.navi.load" />";
	Kms_MessageInfo["kms.navi.msg"]="<bean:message bundle="kms-common" key="kms.navi.msg" />";
	Kms_MessageInfo["category.noLimits"]="<bean:message bundle="kms-common" key="category.noLimits" />";

	//#kms_opera
	//Kms_MessageInfo["category.noLimits"]="<bean:message bundle="kms-common" key="category.noLimits" />";
	Kms_MessageInfo["kms.opera.selectCategory"]="<bean:message bundle="kms-common" key="kms.opera.selectCategory" />";
	Kms_MessageInfo["category.select"]="<bean:message bundle="kms-common" key="category.select" />";
	Kms_MessageInfo["kms.opera.selectCategory"]="<bean:message bundle="kms-common" key="kms.opera.selectCategory" />";
	Kms_MessageInfo["kms.opera.noSelectData"]="<bean:message bundle="kms-common" key="kms.opera.noSelectData" />";
	Kms_MessageInfo["kms.opera.deleteMsg"]="<bean:message bundle="kms-common" key="kms.opera.deleteMsg" />";
	Kms_MessageInfo["kms.opera.deleteError"]="<bean:message bundle="kms-common" key="kms.opera.deleteError" />";
}

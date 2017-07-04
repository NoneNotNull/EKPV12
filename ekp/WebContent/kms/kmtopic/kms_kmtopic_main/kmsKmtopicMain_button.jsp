<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/kmss.tld" prefix="kmss"%>
<%@ include file="/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain_button_js.jsp"%>

<!-- 知识专辑新建 -->
<kmss:auth requestURL="/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain.do?method=add" requestMethod="GET">
	<ui:button text="${lfn:message('button.add')}" onclick="addTopic()"></ui:button>
</kmss:auth>
<kmss:auth requestURL="/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain.do?method=deleteall&status=${param.status}&categoryId=${param.categoryId}" requestMethod="GET">
	<ui:button text="${lfn:message('button.delete')}" onclick="delDoc()"></ui:button>
</kmss:auth>

<kmss:auth
		requestURL="/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain.do?method=editPropertys&templateId=${param.categoryId}"
		requestMethod="GET">
	<ui:button text="${lfn:message('kms-kmtopic:button.changeProperty')}" onclick="editProperty()"></ui:button>
</kmss:auth>


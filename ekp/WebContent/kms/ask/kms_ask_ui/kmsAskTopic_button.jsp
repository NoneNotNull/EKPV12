<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/kmss.tld" prefix="kmss"%>
<%@ include file="/kms/ask/kms_ask_ui/kmsAskTopic_button_js.jsp"%>

<kmss:auth requestURL="/kms/ask/kms_ask_topic/kmsAskTopic.do?method=add" requestMethod="GET">
	<ui:button text="${lfn:message('kms-ask:kmsAsk.ask')}" onclick="addAsk()"></ui:button>
</kmss:auth>

<kmss:auth requestURL="/kms/ask/kms_ask_topic/kmsAskTopic.do?method=deleteall&categoryId=${param.categoryId}" requestMethod="GET">
	<ui:button text="${lfn:message('button.delete')}" onclick="delDoc()"></ui:button>
</kmss:auth>

<%--问题置顶---%>
<kmss:auth
		requestURL="/kms/ask/kms_ask_topic/kmsAskTopic.do?method=setTop&local=index&categoryId=${param.categoryId}"
		requestMethod="GET">
	<ui:button text="${lfn:message('kms-ask:kmsAskTopic.setTop')}" onclick="setTopSelection();"></ui:button>
</kmss:auth>

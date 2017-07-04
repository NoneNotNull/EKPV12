<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.kms.common.forms.KmsPortalForm"%>
<!doctype html>
<html>
<head>
<title>群内FAQ</title>
<meta http-equiv="X-UA-Compatible" content="IE=9" />
<meta http-equiv="Content-Type" content="text/html;"/>
<meta http-equiv="Pragma" content="No-Cache"/>
<%@ include file="/kms/common/resource/jsp/tags.jsp" %>
<%@ include file="/kms/common/resource/jsp/include_kms.jsp"%>
<%@ include file="/kms/common/resource/jsp/include_ekp.jsp"%>
<%@ include file="/kms/ask/kms_ask_kk/kmsAskKk_view_js.jsp" %>
</head>
<body>
<div id="wrapper" style="padding: 5px 0 10px 0;">
	<div style="margin-top: 5px !important;padding-bottom:0px;">
		<div class="box c" style="width:100%">
			<div>
				<input type="text" name="search" class="search_input">
				<span class="search_btn"></span>
				<div class="clear"></div>
			</div>
			<kms:portlet id="kk2askPortlet" cssClass="l" cssStyle="width:100%" template="portlet_kk2ask_tmpl" dataType="bean" beanParm="{fdGroupId:\"${param.fdGroupId }\"}" dataBean="kmsKk2AskPortlet" ></kms:portlet>
			<div style="width: 95%">
				<a style="float: right;" href="${kmsBasePath }/ask/kms_ask_topic/kmsAskTopic.do?method=indexList&more=4&fdId=com.landray.kmss.kms.ask&fdGroupId=${param.fdGroupId }" target="_blank">更多...</a>
			</div>
		</div>
	</div><!-- main end -->
</div>
<%@ include file="/kms/common/resource/jsp/include_kms_down.jsp" %>
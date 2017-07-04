<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/kmss.tld" prefix="kmss"%>
<%@ include file="/kms/kmaps/kms_kmaps_ui/kmsKmapsMain_button_js.jsp"%>

<!-- 知识地图新建 -->
<kmss:auth requestURL="/kms/kmaps/kms_kmaps_main/kmsKmapsMain.do?method=add" requestMethod="GET">
	<ui:button text="${lfn:message('button.add')}" onclick="addMaps()"></ui:button>
</kmss:auth>
<!-- 知识地图删除 -->
<kmss:auth requestURL="/kms/kmaps/kms_kmaps_main/kmsKmapsMain.do?method=deleteall&status=${param.status}&categoryId=${param.categoryId}" requestMethod="GET">
	<ui:button text="${lfn:message('button.delete')}" onclick="delDoc()" order="5" id="deleteall"></ui:button>
</kmss:auth>
<!-- 属性修改 -->
<kmss:auth
		requestURL="/kms/kmaps/kms_kmaps_main/kmsKmapsMain.do?method=editPropertys&templateId=${param.categoryId}" requestMethod="GET">
	<ui:button text="${lfn:message('kms-kmaps:kmsKmapsMain.button.changeProperty')}" onclick="editProperty()"></ui:button>
</kmss:auth>

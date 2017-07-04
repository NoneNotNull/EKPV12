<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%> 
<c:set var="sysCirculationForm" value="${requestScope[param.formName]}"/>
	<div id="CirculationMain">
	<list:listview channel="paging">
				<ui:source type="AjaxJson">
					{"url":"/sys/circulation/sys_circulation_main/sysCirculationMain.do?method=listData&fdModelId=${sysCirculationForm.circulationForm.fdModelId}&fdModelName=${sysCirculationForm.circulationForm.fdModelName}"}
				</ui:source>
				<list:colTable isDefault="true" layout="sys.ui.listview.listtable" cfg-norecodeLayout="simple">
					<list:col-auto props=""></list:col-auto>
				</list:colTable>						
	</list:listview>
	<div style="height: 15px;"></div>
		<list:paging channel="paging" layout="sys.ui.paging.simple"></list:paging>
	</div>
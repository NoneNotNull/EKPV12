<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
	<div id="CirculationMain">
	<list:listview channel="paging">
				<ui:source type="AjaxJson">
					{"url":"/sys/circulation/sys_circulation_main/sysCirculationMain.do?method=listData&fdModelId=${sysCirculationForm.circulationForm.fdModelId}&fdModelName=${sysCirculationForm.circulationForm.fdModelName}"}
				</ui:source>
				<list:colTable isDefault="true" layout="sys.ui.listview.listtable" cfg-norecodeLayout="simple">
					<list:col-auto props=""></list:col-auto>
					<c:if test="${validateAuth=='true'}">
					<list:col-html style="width:60px;" title="">			
							{$<a href="javascript:;" onclick="deleteCirculation('{%row.fdId%}')" class="com_btn_link"><bean:message key="button.delete" /></a>$}
					</list:col-html>
				</c:if>
				</list:colTable>						
	</list:listview>
	<div style="height: 15px;"></div>
		<list:paging channel="paging" layout="sys.ui.paging.simple"></list:paging>
	</div>

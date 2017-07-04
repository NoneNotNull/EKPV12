<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<list:group-popup title="${lfn:message('sys-ui:ui.criteria.date.range') }" multi="false" key="fdCreateDate">
	<list:varDef name="select">
		<list:item-select type="lui/criteria/criterion_calendar!${not empty varParams['type'] ? varParams['type']:'CriterionDateDatas'}">
		</list:item-select>
	</list:varDef>
</list:group-popup>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<div data-dojo-type="dojox/mobile/ListItem" class="lbpmFlowChartForward"
	 data-dojo-props='icon:"mui mui-picview",rightIcon:"mui mui-forward",clickable:true,noArrow:true,onClick:showFlowChartView'>查看流程图</div>
<div
	data-dojo-type="sys/lbpmservice/mobile/lbpm_audit_note/js/LbpmserviceAuditNote"
	data-dojo-props="fdModelId:'${param.fdModelId }',fdModelName:'${ param.fdModelName}',formBeanName:'${param.formBeanName }'"></div>
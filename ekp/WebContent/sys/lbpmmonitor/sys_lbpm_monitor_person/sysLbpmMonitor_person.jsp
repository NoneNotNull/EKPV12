<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.cluster.interfaces.ClusterDiscover"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="person.home">
	<template:replace name="title">${lfn:message('sys-lbpmmonitor:sysLbpmMonitor.person')}</template:replace>
	<template:replace name="content">
	       <%if (ClusterDiscover.getInstance().getGroupByFunc("lbpmMonitorServer").size()>0){%>
	           <%@ include file="/sys/lbpmmonitor/sys_lbpm_monitor_person/include/sysLbpmMoniter_personCluster.jsp"%>
	       <%}else{ %>
	           <%@ include file="/sys/lbpmmonitor/sys_lbpm_monitor_person/include/sysLbpmMoniter_personNormal.jsp"%>
	       <%}%>
	</template:replace>
</template:include>

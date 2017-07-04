<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.util.SpringBeanUtil"%>
<%@page import="java.util.Date"%>
<%@page import="com.landray.kmss.tib.sys.sap.connector.service.ITibSysSapJcoSettingService"%>
<%@page import="com.landray.kmss.tib.sys.sap.connector.model.TibSysSapJcoSetting"%>
<%@page import="com.landray.kmss.tib.sys.sap.connector.impl.TibSysSapJcoFunctionUtil"%>
<%@page import="com.landray.kmss.tib.sys.sap.connector.model.TibSysSapJcoMonitor"%>
<%@page import="java.util.Hashtable"%>
<%@page import="com.sap.conn.jco.JCoDestination"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Date"%>
<%@page import="com.landray.kmss.util.DateUtil"%>
<%@page import="java.util.ArrayList"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%

	ITibSysSapJcoSettingService tibSysSapJcoSettingService = (ITibSysSapJcoSettingService) SpringBeanUtil
			.getBean("tibSysSapJcoSettingService");
	List<TibSysSapJcoSetting> tibSysSapJcoSettings = tibSysSapJcoSettingService.findList(
			"1<2", null);
	TibSysSapJcoFunctionUtil sapJcoFunctionUtil = (TibSysSapJcoFunctionUtil) SpringBeanUtil
			.getBean("tibSysSapJcoFunctionUtil");
	Hashtable<String, JCoDestination> destinations = sapJcoFunctionUtil
			.getDestinations();
	List<TibSysSapJcoMonitor> tibSysSapJcoMonitorList = new ArrayList<TibSysSapJcoMonitor>();
	if (tibSysSapJcoSettings != null && !tibSysSapJcoSettings.isEmpty()) {
		TibSysSapJcoSetting tibSysSapJcoSetting;
		TibSysSapJcoMonitor tibSysSapJcoMonitor;
		String poolName;
		JCoDestination jcoDestination;
		for (int i = 0; i < tibSysSapJcoSettings.size(); i++) {
			tibSysSapJcoSetting = tibSysSapJcoSettings.get(i);
			tibSysSapJcoMonitor = new TibSysSapJcoMonitor();
			poolName = tibSysSapJcoSetting.getFdPoolName();
			tibSysSapJcoMonitor.setPoolName(poolName);
			jcoDestination = destinations.get(poolName);
			//活动连接数
			tibSysSapJcoMonitor.setActiveConCount(jcoDestination == null ? 0
					: jcoDestination.getMonitor()
							.getUsedConnectionCount());
			//最大使用值
			tibSysSapJcoMonitor.setMaxUsedCount(jcoDestination == null ? 0
					: jcoDestination.getMonitor().getMaxUsedCount());
			//使用值
			tibSysSapJcoMonitor.setUsedCount(jcoDestination == null ? 0
					: jcoDestination.getMonitor()
							.getPooledConnectionCount());
			//等待连接数？
			tibSysSapJcoMonitor
					.setWaitConnectCount(jcoDestination == null ? 0
							: jcoDestination.getMonitor()
									.getPooledConnectionCount());
			//最后使用时间
			tibSysSapJcoMonitor
					.setLastActivityTimestamp(jcoDestination == null ? 0
							: jcoDestination.getMonitor()
									.getLastActivityTimestamp());
			////
			tibSysSapJcoMonitor.setPeakLimit(jcoDestination == null ? 0
					: jcoDestination.getMonitor().getPeakLimit());
			
			tibSysSapJcoMonitorList.add(tibSysSapJcoMonitor);
		}
	}
	pageContext.setAttribute("tibSysSapJcoMonitorList", tibSysSapJcoMonitorList);
%>

<%@page import="com.landray.kmss.tib.sys.sap.connector.impl.TibSysSapJcoFunctionUtil"%><br />
	<div id="optBarDiv"><%-- 刷新 --%> <input type="button"
		value="<bean:message key="button.refresh"/>" onclick="location.reload();">
	</div>
	
<list:data>
	<list:data-columns var="tibSysSapJcoMonitor" list="${tibSysSapJcoMonitorList }">
		<%--标题--%>
		<list:data-column col="poolName" title="${ lfn:message('tib-sys-sap-connector:tibSysSapJcoSetting.fdPoolName') }" style="text-align:center" escape="false">
			<span class="com_subject"><c:out value="${tibSysSapJcoMonitor.poolName}" /></span>
		</list:data-column>
		<list:data-column col="peakLimit" title="${ lfn:message('tib-sys-sap-connector:tibSysSapJcoSetting.fdPoolNumber') }" escape="false" style="text-align:center;">
			<c:out value="${tibSysSapJcoMonitor.peakLimit}" />
		</list:data-column>
		<list:data-column col="activeConCount" title="${ lfn:message('tib-sys-sap-connector:tibSysSapJcoMonitor.active.connect.count') }" escape="false" style="text-align:center;">
			<c:out value="${tibSysSapJcoMonitor.activeConCount}" />
		</list:data-column>
		<list:data-column col="maxUsedCount" title="${ lfn:message('tib-sys-sap-connector:tibSysSapJcoMonitor.maximal.used.count') }" escape="false" style="text-align:center;">
			<c:out value="${tibSysSapJcoMonitor.maxUsedCount}" />
		</list:data-column>
		<list:data-column col="usedCount" title="${ lfn:message('tib-sys-sap-connector:tibSysSapJcoMonitor.used.count') }" escape="false" style="text-align:center;">
			<c:out value="${tibSysSapJcoMonitor.usedCount}" />
		</list:data-column>
		<list:data-column col="waitConnectCount" title="${ lfn:message('tib-sys-sap-connector:tibSysSapJcoMonitor.wait.connect.count') }" escape="false" style="text-align:center;">
			<c:out value="${tibSysSapJcoMonitor.waitConnectCount}" />
		</list:data-column>
		<list:data-column col="currenTime" title="${ lfn:message('tib-sys-sap-connector:tibSysSapJcoMonitor.server.current.time') }">
			<%=DateUtil.convertDateToString(new Date(),
								"yyyy-MM-dd HH:mm:ss")%>
		</list:data-column>
		<list:data-column col="lastActivityTimestampString" title="${ lfn:message('tib-sys-sap-connector:tibSysSapJcoMonitor.lastActivityTimestamp') }">
			${tibSysSapJcoMonitor.lastActivityTimestampString }
		</list:data-column>
	</list:data-columns>

	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>

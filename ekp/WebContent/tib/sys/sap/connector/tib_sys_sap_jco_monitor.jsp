<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
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
<%@page import="com.sunbor.web.tag.Page"%>
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
	Page monitorPage = new Page();
	monitorPage.setTotalrows(tibSysSapJcoMonitorList.size());
	monitorPage.setPageno(1);
	monitorPage.setRowsize(15);
	monitorPage.setList(tibSysSapJcoMonitorList);
	pageContext.setAttribute("queryPage", monitorPage);
%>

<%@page import="com.landray.kmss.tib.sys.sap.connector.impl.TibSysSapJcoFunctionUtil"%><br />
	<div id="optBarDiv"><%-- 刷新 --%> <input type="button"
		value="<bean:message key="button.refresh"/>" onclick="location.reload();">
	</div>
<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
<table id="List_ViewTable">
	<tr>
		<sunbor:columnHead htmlTag="td">
			<td width="40pt"><bean:message key="page.serial" /></td>
			<td><bean:message key="tibSysSapJcoSetting.fdPoolName"
				bundle="tib-sys-sap-connector" /></td>
			<td><bean:message key="tibSysSapJcoSetting.fdPoolNumber"
				bundle="tib-sys-sap-connector" /></td>
			<td><bean:message key="tibSysSapJcoMonitor.active.connect.count"
				bundle="tib-sys-sap-connector" /></td>
			<td><bean:message key="tibSysSapJcoMonitor.maximal.used.count"
				bundle="tib-sys-sap-connector" /></td>
			<td><bean:message key="tibSysSapJcoMonitor.used.count"
				bundle="tib-sys-sap-connector" /></td>
			<td><bean:message key="tibSysSapJcoMonitor.wait.connect.count"
				bundle="tib-sys-sap-connector" /></td>
			<td><bean:message key="tibSysSapJcoMonitor.server.current.time"
				bundle="tib-sys-sap-connector" /></td>
			<td><bean:message key="tibSysSapJcoMonitor.lastActivityTimestamp"
				bundle="tib-sys-sap-connector" /></td>
		</sunbor:columnHead>
	</tr>
	<c:forEach items="${queryPage.list}" var="tibSysSapJcoMonitor"
		varStatus="vstatus">
		<tr kmss_href="">
			<td>${vstatus.index+1}</td>
			<td>${tibSysSapJcoMonitor.poolName}</td>
			<td>${tibSysSapJcoMonitor.peakLimit}</td>
			<td>${tibSysSapJcoMonitor.activeConCount}</td>
			<td>${tibSysSapJcoMonitor.maxUsedCount}</td>
			<td>${tibSysSapJcoMonitor.usedCount}</td>
			<td>${tibSysSapJcoMonitor.waitConnectCount}</td>
			<td><%=DateUtil.convertDateToString(new Date(),
								"yyyy-MM-dd HH:mm:ss")%>
			</td>
			<td>${tibSysSapJcoMonitor.lastActivityTimestampString}</td>
		</tr>
	</c:forEach>
</table>
<%@ include file="/resource/jsp/list_pagenav_down.jsp"%>
<%@ include file="/resource/jsp/list_down.jsp"%>

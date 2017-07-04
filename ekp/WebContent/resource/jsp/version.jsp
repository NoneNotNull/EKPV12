<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<%@ page import="com.landray.kmss.util.StringUtil" %>
<%@ page import="com.landray.kmss.util.ResourceUtil" %>
<%@page import="com.landray.kmss.sys.config.design.SysConfigs"%>
<%@page import="com.landray.kmss.sys.config.design.SysCfgModule"%>
<title>版本信息</title>
<div id="optBarDiv">
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
<center>
<p class="txttitle">版本信息</p>
<c:choose>
<c:when test="${not empty description}">
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			组件名称：
		</td>
		<td width="35%">
			<c:out value="${description.module.moduleName}" />
		</td>
		<td class="td_normal_title" width=15%>
			组件路径：
		</td>
		<td width="35%">
			<c:out value="${description.module.modulePath}" />
		</td>	
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			平行版本：
		</td>
		<td width="35%">
			<c:out value="${description.module.parallelVersion}" />
		</td>	
		<td class="td_normal_title" width=15%>
			当前版本：
		</td>
		<td>
			<c:out value="${description.module.baseline}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			版本序列号：
		</td>
		<td>
			<c:choose>
			<c:when test="${empty description.module.serialNum}">
				0
			</c:when>
			<c:otherwise>
				<c:out value="${description.module.serialNum}" />
			</c:otherwise>
			</c:choose>
		</td>	
		<td class="td_normal_title" width=15%>
			版本标识：
		</td>
		<td>
			<c:out value="${description.module.sourceMd5}" />
		</td>	
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			是否定制：
		</td>
		<td>
			<c:out value="${description.module.isCustom}" />
		</td>
		<c:if test="${not empty description.module.tempVersion}">
			<td class="td_normal_title" width=15%>
				是否临时版本：
			</td>
			<td>
				<span>是（${description.module.tempVersion})</span>
			</td>
		</c:if>
		<c:if test="${empty description.module.tempVersion}">
			<td class="td_normal_title" width=15%>
			</td>
			<td>
			</td>
		</c:if>
	</tr>
</table>
<table border="0" width=95%>
	<tr>
		<td class="txtStrong">			
			<c:if test="${description.module.isCustom != '是'}">
				<br style="font-size: 8px"><a href="<c:url value="/${description.module.modulePath}.version?check=true"/>">版本检测（版本：20111226）</a>：检测项目文件是否有发生改变
			</c:if>
		</td>
	</tr>
</table>
<br/>
<table class="tb_normal" width=95%>
	<tbody>
	<tr>
		<td class="td_normal_title" colspan="6">
			<center>修改记录</center>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="40pt">
			<center><bean:message key="page.serial"/></center>
		</td>
		<td class="td_normal_title" width="60%">
			<center>描述</center>
		</td>
		<%--
		<td class="td_normal_title" width="10%">
			<center>作者</center>
		</td>
		--%>
		<td class="td_normal_title" width="10%">
			<center>修订时间</center>
		</td>
		<td class="td_normal_title" width="10%">
			<center>关联修改</center>
		</td>
		<td class="td_normal_title">
			<center>版本信息</center>
		</td>
	</tr>
	<c:forEach items="${modifyList}" var="modify" varStatus="vstatus">
		<tr>
			<td>
				<center>${vstatus.index+1}</center>
			</td>
			<td>
				<c:out value="${modify.description}" />
			</td>
			<%--
			<td>
				<center><c:out value="${modify.author}" /></center>
			</td>
			--%>
			<td>
				<center><kmss:showDate value="${modify.revisionTime}" type="date" /></center>
			</td>
			<td>
				<c:forEach items="${modify.relation.relationModuleList}" var="relationModule" varStatus="vstatus">
					<c:out value="${relationModule}" />
				</c:forEach>
			</td>
			<td>
				<c:out value="${modify.baseline}" />&nbsp;
			</td>
		</tr>
	</c:forEach>
	</tbody>
</table>
<br />
</c:when>
<c:otherwise>
<span class="txtstrong">版本信息没找到，请检查路径是否正确！</span>
</c:otherwise>
</c:choose>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>